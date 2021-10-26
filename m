Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAAE43B443
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 16:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhJZOgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 10:36:55 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:41819 "EHLO
        smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234268AbhJZOgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 10:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635258869;
        bh=hoG7Z99yRqEL6f8++suWM6VfWSywPukq4+YM/RboeG4=;
        h=Subject:To:From:Date:From;
        b=X1hrFjq3VvX32dNP6/NCISeO32ddReMfnzwiQgTIbdnlpq6uO2ZN357cAsHIoeDkP
         g68SWobJA0zGIi0QF3mR1EAzcci8KVsoJ5OE9ZRIVzhv6I8pTmJN5OaazmyswK85Sn
         b2lDyzYIXzvnEaVCKRASRi+/pOxJyz7JynR4g9dg=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp11.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 924DAA01E2;
        Tue, 26 Oct 2021 10:34:28 -0400 (EDT)
Subject: Re: [PATCH 4/5] comedi: vmk80xx: fix bulk-buffer overflow
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-5-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <86298eaa-aee8-18fe-d389-8522c6746578@mev.co.uk>
Date:   Tue, 26 Oct 2021 15:34:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025114532.4599-5-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: 37e2f1e2-460e-40bb-bd09-f599f052d5aa-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2021 12:45, Johan Hovold wrote:
> The driver is using endpoint-sized buffers but must not assume that the
> tx and rx buffers are of equal size or a malicious device could overflow
> the slab-allocated receive buffer when doing bulk transfers.
> 
> Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
> Cc: stable@vger.kernel.org      # 2.6.31
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/comedi/drivers/vmk80xx.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
> index f2c1572d0cd7..9c56918e3b76 100644
> --- a/drivers/comedi/drivers/vmk80xx.c
> +++ b/drivers/comedi/drivers/vmk80xx.c
> @@ -159,22 +159,20 @@ static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
>   	__u8 rx_addr;
>   	unsigned int tx_pipe;
>   	unsigned int rx_pipe;
> -	size_t size;
> +	size_t tx_size;
> +	size_t rx_size;
>   
>   	tx_addr = devpriv->ep_tx->bEndpointAddress;
>   	rx_addr = devpriv->ep_rx->bEndpointAddress;
>   	tx_pipe = usb_sndbulkpipe(usb, tx_addr);
>   	rx_pipe = usb_rcvbulkpipe(usb, rx_addr);
> -
> -	/*
> -	 * The max packet size attributes of the K8061
> -	 * input/output endpoints are identical
> -	 */
> -	size = usb_endpoint_maxp(devpriv->ep_tx);
> +	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
> +	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
>   
>   	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
> -		     size, NULL, devpriv->ep_tx->bInterval);
> -	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, size, NULL, HZ * 10);
> +		     tx_size, NULL, devpriv->ep_tx->bInterval);
> +
> +	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL, HZ * 10);
>   }
>   
>   static int vmk80xx_read_packet(struct comedi_device *dev)
> 

Looks good, thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
