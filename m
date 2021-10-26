Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F066A43B451
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 16:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhJZOi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 10:38:28 -0400
Received: from smtp126.ord1d.emailsrvr.com ([184.106.54.126]:60839 "EHLO
        smtp126.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236739AbhJZOiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 10:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635258945;
        bh=09DsGG934eAWsrYgTTEyogH6LDSB0Wo6kjXmpIsK7zo=;
        h=Subject:To:From:Date:From;
        b=JpjX7COpm49F29ojHTexC79WPHa556bgJ5jztCzQpSSC582AAjYzf2ZmZKKdHBw9Z
         svRdanUjfO+1Uo7MDJoKJFReOCwIIZdQ6wP4y8qp25/U8LE/G/rdPY2liRUPksdW8U
         Y5Aih6iGtHIgsYv08SkS+wlrY68w1s7buDSb5bNE=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp8.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 05104C0184;
        Tue, 26 Oct 2021 10:35:44 -0400 (EDT)
Subject: Re: [PATCH 5/5] comedi: vmk80xx: fix bulk and interrupt message
 timeouts
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-6-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <fb1c3dcd-39cd-d4e2-e6f5-061dad6b2751@mev.co.uk>
Date:   Tue, 26 Oct 2021 15:35:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025114532.4599-6-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: 2f3175d9-b0e8-4937-a8e3-a5d800e9b366-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2021 12:45, Johan Hovold wrote:
> USB bulk and interrupt message timeouts are specified in milliseconds
> and should specifically not vary with CONFIG_HZ.
> 
> Note that the bulk-out transfer timeout was set to the endpoint
> bInterval value, which should be ignored for bulk endpoints and is
> typically set to zero. This meant that a failing bulk-out transfer
> would never time out.
> 
> Assume that the 10 second timeout used for all other transfers is more
> than enough also for the bulk-out endpoint.
> 
> Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
> Fixes: 951348b37738 ("staging: comedi: vmk80xx: wait for URBs to complete")
> Cc: stable@vger.kernel.org      # 2.6.31
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/comedi/drivers/vmk80xx.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
> index 9c56918e3b76..4b00a9ea611a 100644
> --- a/drivers/comedi/drivers/vmk80xx.c
> +++ b/drivers/comedi/drivers/vmk80xx.c
> @@ -91,6 +91,7 @@ enum {
>   #define IC6_VERSION		BIT(1)
>   
>   #define MIN_BUF_SIZE		64
> +#define PACKET_TIMEOUT		10000	/* ms */
>   
>   enum vmk80xx_model {
>   	VMK8055_MODEL,
> @@ -169,10 +170,11 @@ static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
>   	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
>   	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
>   
> -	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
> -		     tx_size, NULL, devpriv->ep_tx->bInterval);
> +	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf, tx_size, NULL,
> +		     PACKET_TIMEOUT);
>   
> -	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL, HZ * 10);
> +	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL,
> +		     PACKET_TIMEOUT);
>   }
>   
>   static int vmk80xx_read_packet(struct comedi_device *dev)
> @@ -191,7 +193,7 @@ static int vmk80xx_read_packet(struct comedi_device *dev)
>   	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
>   	return usb_interrupt_msg(usb, pipe, devpriv->usb_rx_buf,
>   				 usb_endpoint_maxp(ep), NULL,
> -				 HZ * 10);
> +				 PACKET_TIMEOUT);
>   }
>   
>   static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
> @@ -212,7 +214,7 @@ static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
>   	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);
>   	return usb_interrupt_msg(usb, pipe, devpriv->usb_tx_buf,
>   				 usb_endpoint_maxp(ep), NULL,
> -				 HZ * 10);
> +				 PACKET_TIMEOUT);
>   }
>   
>   static int vmk80xx_reset_device(struct comedi_device *dev)
> 

Looks good, thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
