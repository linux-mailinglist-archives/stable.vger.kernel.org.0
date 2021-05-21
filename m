Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B5038CCEB
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhEUSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhEUSJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 14:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B383C613CB;
        Fri, 21 May 2021 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621620466;
        bh=rnrZncwe75g1z0VWYMaoSY/Ys80pRAv4pgoQnaiKhm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XzrgcYbHkFmnbCvPaLrBI2PRoY2fX70XzGoenu3UPSAMrOnk+LRj72ETVP7xExJiU
         fsg0EeQMpf2qIMSJObY3k+sp8VDPI9tHlkmDXPr7sI0tXfvJYpBQzqXtz78UN959W6
         2RB8kWp+r+NQSsV2e5yYYPAoNSaAcUfNpIIwTXTc=
Date:   Fri, 21 May 2021 20:07:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: trancevibrator: fix control-request direction
Message-ID: <YKf28CaRalCTsXfO@kroah.com>
References: <20210521133109.17396-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521133109.17396-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 03:31:09PM +0200, Johan Hovold wrote:
> The direction of the pipe argument must match the request-type direction
> bit or control requests may fail depending on the host-controller-driver
> implementation.
> 
> Fix the set-speed request which erroneously used USB_DIR_IN and update
> the default timeout argument to match (same value).
> 
> Fixes: 5638e4d92e77 ("USB: add PlayStation 2 Trance Vibrator driver")
> Cc: stable@vger.kernel.org      # 2.6.19
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/misc/trancevibrator.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
> index a3dfc77578ea..26baba3ab7d7 100644
> --- a/drivers/usb/misc/trancevibrator.c
> +++ b/drivers/usb/misc/trancevibrator.c
> @@ -61,9 +61,9 @@ static ssize_t speed_store(struct device *dev, struct device_attribute *attr,
>  	/* Set speed */
>  	retval = usb_control_msg(tv->udev, usb_sndctrlpipe(tv->udev, 0),
>  				 0x01, /* vendor request: set speed */
> -				 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_OTHER,
> +				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
>  				 tv->speed, /* speed value */
> -				 0, NULL, 0, USB_CTRL_GET_TIMEOUT);
> +				 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
>  	if (retval) {
>  		tv->speed = old;
>  		dev_dbg(&tv->udev->dev, "retval = %d\n", retval);
> -- 
> 2.26.3
> 

Thanks for searching the whole tree for these mistakes, nice work!

greg k-h
