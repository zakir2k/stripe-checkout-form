require 'rubygems'
require 'sinatra'
require 'stripe'

Stripe.api_key = "STRIPE API PRIVATE KEY"
set :views, File.dirname(__FILE__) + "/views"

def is_number?(i)
  true if Float(i) rescue false
end

get "/" do
  erb :form
end

# An api endpoint to start the payment process
post '/pay' do
  
  amount = ((params[:amount].to_f)*100).to_i

  #Create a PaymentIntent with amount and currency
    payment_intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: 'usd'
    )
  #Confirm the payment intent
    @confirm = Stripe::PaymentIntent.confirm(
    payment_intent.id,
      {payment_method: 'pm_card_visa'},
    )
    if @confirm.status == 'succeeded'
      erb :thanks
    else
      redirect "/"
    end
end