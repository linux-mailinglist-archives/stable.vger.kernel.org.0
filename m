Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2739A240BFC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 19:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgHJRbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 13:31:34 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:42753 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgHJRbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 13:31:34 -0400
Received: from classic (lns-bzn-39-82-255-60-242.adsl.proxad.net [82.255.60.242])
        (Authenticated sender: hadess@hadess.net)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 1F489240008;
        Mon, 10 Aug 2020 17:31:29 +0000 (UTC)
Message-ID: <6e450e16117afb9e1dd1e4270ef5c2e0d5885348.camel@hadess.net>
Subject: Re: [PATCH] usbip: Implement a match function to fix usbip
From:   Bastien Nocera <hadess@hadess.net>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Date:   Mon, 10 Aug 2020 19:31:29 +0200
In-Reply-To: <20200810160017.46002-1-m.v.b@runbox.com>
References: <20200810160017.46002-1-m.v.b@runbox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-08-10 at 19:00 +0300, M. Vefa Bicakci wrote:
> Commit 88b7381a939d ("USB: Select better matching USB drivers when
> available") introduced the use of a "match" function to select a
> non-generic/better driver for a particular USB device. This
> unfortunately breaks the operation of usbip in general, as reported
> in
> the kernel bugzilla with bug 208267 (linked below).
> 
> Upon inspecting the aforementioned commit, one can observe that the
> original code in the usb_device_match function used to return 1
> unconditionally, but the aforementioned commit makes the
> usb_device_match
> function use identifier tables and "match" virtual functions, if
> either of
> them are available.
> 
> Hence, this commit implements a match function for usbip that
> unconditionally returns true to ensure that usbip is functional
> again.
> 
> This change has been verified to restore usbip functionality, with a
> v5.7.y kernel on an up-to-date version of Qubes OS 4.0, which uses
> usbip to redirect USB devices between VMs.
> 
> Thanks to Jonathan Dieter for the effort in bisecting this issue down
> to the aforementioned commit.

Looks correct. Thanks for root causing the problem.

Reviewed-by: Bastien Nocera <hadess@hadess.net>

> Fixes: 88b7381a939d ("USB: Select better matching USB drivers when
> available")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=208267
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1856443
> Link: https://github.com/QubesOS/qubes-issues/issues/5905
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> Cc: <stable@vger.kernel.org> # 5.7
> Cc: Valentina Manea <valentina.manea.m@gmail.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/usbip/stub_dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/usb/usbip/stub_dev.c
> b/drivers/usb/usbip/stub_dev.c
> index 2305d425e6c9..9d7d642022d1 100644
> --- a/drivers/usb/usbip/stub_dev.c
> +++ b/drivers/usb/usbip/stub_dev.c
> @@ -461,6 +461,11 @@ static void stub_disconnect(struct usb_device
> *udev)
>  	return;
>  }
>  
> +static bool usbip_match(struct usb_device *udev)
> +{
> +	return true;
> +}
> +
>  #ifdef CONFIG_PM
>  
>  /* These functions need usb_port_suspend and usb_port_resume,
> @@ -486,6 +491,7 @@ struct usb_device_driver stub_driver = {
>  	.name		= "usbip-host",
>  	.probe		= stub_probe,
>  	.disconnect	= stub_disconnect,
> +	.match		= usbip_match,
>  #ifdef CONFIG_PM
>  	.suspend	= stub_suspend,
>  	.resume		= stub_resume,

