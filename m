Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6979743DE1F
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 11:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJ1JyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 05:54:11 -0400
Received: from smtp74.iad3a.emailsrvr.com ([173.203.187.74]:49321 "EHLO
        smtp74.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhJ1JyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 05:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635414291;
        bh=GHy2nV4GSIm/Zg7KtLF9h09s3w/Q86hpAOQm11zTqZ0=;
        h=Subject:To:From:Date:From;
        b=TtEz/7Tlt2EnEef+dvTgCC/C0ous8qAp87E0PJPAmW2E6Axp863nV28bTMjsfL0Uu
         mWwzwv4p4uBa7MC09wYmzAkpTld8K94BvoESWMQyGCAkuGHBXHuRYFfsmB3oyInTze
         GUXhOh8BPSHmO9R2WffQZyscZLnOb4CVZ0mvpoiI=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp2.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 1F02A18AB;
        Thu, 28 Oct 2021 05:44:51 -0400 (EDT)
Subject: Re: [PATCH v2 1/2] comedi: ni_usb6501: fix NULL-deref in command
 paths
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Luca Ellero <luca.ellero@brickedbrain.com>
References: <20211027093529.30896-1-johan@kernel.org>
 <20211027093529.30896-2-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <44fc8c7a-9281-b2b1-a8ec-4009b0a5f33c@mev.co.uk>
Date:   Thu, 28 Oct 2021 10:44:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027093529.30896-2-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: f6f3b32a-8cea-445e-9639-66bc3da331f8-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2021 10:35, Johan Hovold wrote:
> The driver uses endpoint-sized USB transfer buffers but had no sanity
> checks on the sizes. This can lead to zero-size-pointer dereferences or
> overflowed transfer buffers in ni6501_port_command() and
> ni6501_counter_command() if a (malicious) device has smaller max-packet
> sizes than expected (or when doing descriptor fuzz testing).
> 
> Add the missing sanity checks to probe().
> 
> Fixes: a03bb00e50ab ("staging: comedi: add NI USB-6501 support")
> Cc: stable@vger.kernel.org      # 3.18
> Cc: Luca Ellero <luca.ellero@brickedbrain.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/comedi/drivers/ni_usb6501.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/comedi/drivers/ni_usb6501.c b/drivers/comedi/drivers/ni_usb6501.c
> index 5b6d9d783b2f..c42987b74b1d 100644
> --- a/drivers/comedi/drivers/ni_usb6501.c
> +++ b/drivers/comedi/drivers/ni_usb6501.c
> @@ -144,6 +144,10 @@ static const u8 READ_COUNTER_RESPONSE[]	= {0x00, 0x01, 0x00, 0x10,
>   					   0x00, 0x00, 0x00, 0x02,
>   					   0x00, 0x00, 0x00, 0x00};
>   
> +/* Largest supported packets */
> +static const size_t TX_MAX_SIZE	= sizeof(SET_PORT_DIR_REQUEST);
> +static const size_t RX_MAX_SIZE	= sizeof(READ_PORT_RESPONSE);
> +
>   enum commands {
>   	READ_PORT,
>   	WRITE_PORT,
> @@ -501,6 +505,12 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
>   	if (!devpriv->ep_rx || !devpriv->ep_tx)
>   		return -ENODEV;
>   
> +	if (usb_endpoint_maxp(devpriv->ep_rx) < RX_MAX_SIZE)
> +		return -ENODEV;
> +
> +	if (usb_endpoint_maxp(devpriv->ep_tx) < TX_MAX_SIZE)
> +		return -ENODEV;
> +
>   	return 0;
>   }
>   
> 

Looks good, thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
