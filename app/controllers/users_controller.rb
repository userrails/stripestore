class UsersController < ApplicationController
  
  def index
    @user = User.all
  end
  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if  @user.save
      # create Stripe customer
      customer = Stripe::Customer.create(
        description: @user.email, 
        card: @user.stripe_card_token
      )
    
      # create Stripe charge
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => 100,
        :description => "#{@user.first_name}",
        :currency    => 'usd'
      )
      redirect_to users_path
      flash[:notice] = "User was successfully created"
    else
      render :action => "new"
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit!
  end
end
