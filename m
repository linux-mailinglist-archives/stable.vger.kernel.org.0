Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B8F26DF1B
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgIQPHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 11:07:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58709 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727869AbgIQPHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 11:07:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:07:44 EDT
Received: (qmail 1089856 invoked by uid 1000); 17 Sep 2020 11:01:01 -0400
Date:   Thu, 17 Sep 2020 11:01:01 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzkaller@googlegroups.com
Subject: Re: [PATCH 2/3] usbcore/driver: Fix incorrect downcast
Message-ID: <20200917150101.GA1088823@rowland.harvard.edu>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <20200917144151.355848-2-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917144151.355848-2-m.v.b@runbox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 05:41:50PM +0300, M. Vefa Bicakci wrote:
> This commit resolves a minor bug in the selection/discovery of more
> specific USB device drivers for devices that are currently bound to
> generic USB device drivers.
> 
> The bug is related to the way a candidate USB device driver is
> compared against the generic USB device driver. The code in
> is_dev_usb_generic_driver() assumes that the device driver in question
> is a USB device driver by calling to_usb_device_driver(dev->driver)
> to downcast; however I have observed that this assumption is not always
> true, through code instrumentation.
> 
> Given that USB device drivers are bound to struct device instances with
> of the type &usb_device_type, this commit checks the return value of
> is_usb_device() before the call to is_dev_usb_generic_driver(), and
> therefore ensures that incorrect type downcasts do not occur. The use
> of is_usb_device() was suggested by Bastien Nocera.
> 
> This bug was found while investigating Andrey Konovalov's report
> indicating USB/IP subsystem's misbehaviour with the generic USB device
> driver matching code.
> 
> Fixes: d5643d2249 ("USB: Fix device driver race")
> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
> Cc: <stable@vger.kernel.org> # 5.8
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: <syzkaller@googlegroups.com>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>  drivers/usb/core/driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index 950044a6e77f..ba7acd6e7cc4 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -919,7 +919,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
>  	struct usb_device *udev;
>  	int ret;
>  
> -	if (!is_dev_usb_generic_driver(dev))
> +	if (!is_usb_device(dev) || !is_dev_usb_generic_driver(dev))
>  		return 0;
>  
>  	udev = to_usb_device(dev);
> -- 
> 2.26.2

Why not simplify the whole thing by testing the underlying driver 
pointer?

	/* Don't reprobe if current driver isn't usb_generic_driver */
	if (dev->driver != &usb_generic_driver.drvwrap.driver)
		return 0;

Then is_dev_usb_generic_driver can be removed entirely.

Alan Stern
