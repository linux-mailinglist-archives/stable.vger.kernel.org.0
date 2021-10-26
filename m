Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AB043B3DB
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhJZOYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 10:24:08 -0400
Received: from smtp95.ord1d.emailsrvr.com ([184.106.54.95]:57498 "EHLO
        smtp95.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233382AbhJZOYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 10:24:07 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2021 10:24:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635257549;
        bh=+4cb5meI4blfHPvJYISdY1ggOGQPN9CfCZDwjUGLC2M=;
        h=Subject:To:From:Date:From;
        b=NRZzEnMFGrC5X4Hc1B1RL9z+RT5V8FIDaUQwhldIyCOZAHGUnT+83W8RETj5lrzHM
         SPfYis0X9JfwtxyISRZd45SbRpNBLk7E+qdYSbPB4PmrylHO4ihZ3Ma3vE3ZR7M0T+
         BEnwq5KAS++kk6uey0mmKf3yZoEQZdFAZXDD8BDU=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp12.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id C1E97E0115;
        Tue, 26 Oct 2021 10:12:28 -0400 (EDT)
Subject: Re: [PATCH 1/5] comedi: ni_usb6501: fix NULL-deref in command paths
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Luca Ellero <luca.ellero@brickedbrain.com>
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-2-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <be9dcb4f-3594-e756-78e3-74750a49fe91@mev.co.uk>
Date:   Tue, 26 Oct 2021 15:12:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025114532.4599-2-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: ffc54a2e-ba37-4dec-b7bf-ea32ca4e0a9e-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2021 12:45, Johan Hovold wrote:
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
>   drivers/comedi/drivers/ni_usb6501.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/comedi/drivers/ni_usb6501.c b/drivers/comedi/drivers/ni_usb6501.c
> index 5b6d9d783b2f..eb2e5c23f25d 100644
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
> @@ -486,12 +490,16 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
>   		ep_desc = &iface_desc->endpoint[i].desc;
>   
>   		if (usb_endpoint_is_bulk_in(ep_desc)) {
> +			if (usb_endpoint_maxp(ep_desc) < RX_MAX_SIZE)
> +				continue;
>   			if (!devpriv->ep_rx)
>   				devpriv->ep_rx = ep_desc;
>   			continue;
>   		}
>   
>   		if (usb_endpoint_is_bulk_out(ep_desc)) {
> +			if (usb_endpoint_maxp(ep_desc) < TX_MAX_SIZE)
> +				continue;
>   			if (!devpriv->ep_tx)
>   				devpriv->ep_tx = ep_desc;
>   			continue;
> 

Perhaps it should return an error if the first encountered bulk-in 
endpoint has the wrong size or the first encountered bulk-out endpoint 
has the wrong size. Something like:

		if (usb_endpoint_is_bulk_in(ep_desc)) {
			if (!devpriv->ep_rx) {
				if (usb_endpoint_maxp(ep_desc) < RX_MAX_SIZE)
					break;
			}
			continue;

(similar for bulk-out with TX_MAX_SIZE)

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
