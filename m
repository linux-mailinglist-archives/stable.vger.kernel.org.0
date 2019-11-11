Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628D7F74CC
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKKN20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfKKN2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:28:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E131A21E6F;
        Mon, 11 Nov 2019 13:28:24 +0000 (UTC)
Date:   Mon, 11 Nov 2019 14:28:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: serial: mos7720: fix remote wakeup
Message-ID: <20191111132823.GB450958@kroah.com>
References: <20191107132119.2159-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107132119.2159-1-johan@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 02:21:18PM +0100, Johan Hovold wrote:
> The driver was setting the device remote-wakeup feature during probe in
> violation of the USB specification (which says it should only be set
> just prior to suspending the device). This could potentially waste
> power during suspend as well as lead to spurious wakeups.
> 
> Note that USB core would clear the remote-wakeup feature at first
> resume.
> 
> Fixes: 0f64478cbc7a ("USB: add USB serial mos7720 driver")
> Cc: stable <stable@vger.kernel.org>     # 2.6.19
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/mos7720.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
> index 18110225d506..2ec4eeacebc7 100644
> --- a/drivers/usb/serial/mos7720.c
> +++ b/drivers/usb/serial/mos7720.c
> @@ -1833,10 +1833,6 @@ static int mos7720_startup(struct usb_serial *serial)
>  	product = le16_to_cpu(serial->dev->descriptor.idProduct);
>  	dev = serial->dev;
>  
> -	/* setting configuration feature to one */
> -	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
> -			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
> -
>  	if (product == MOSCHIP_DEVICE_ID_7715) {
>  		struct urb *urb = serial->port[0]->interrupt_in_urb;
>  

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
