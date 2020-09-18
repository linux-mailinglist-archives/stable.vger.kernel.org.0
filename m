Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4926FFEA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 16:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIRObo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 10:31:44 -0400
Received: from aibo.runbox.com ([91.220.196.211]:39136 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgIRObo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 10:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=Ls2rWbdf6hbdI2AidJb29lGkM5H7xENCw+Tzom6K5Qs=; b=i/S2G34jgWtw4Gqr4fcTfux/mI
        7AyakoNRudZ7RREDon/s7sTJQAmK+ty8GcHWIFylnyHKNZAAibiBXjs1wq9ee9v3INVovm/VcRK/j
        /tu7Og2jFP973KMVn6Z7S5if4kI+fcNMhblMeqUIFOr//cQqlLYwu/D739UJOuwRt3CCFLCkBLkst
        vL2yH+xypwcVdIapG8oDLa+vydlFMnXKpkur4iP8XSKpP8dRniidpkWvEnwnoDvzt0GgrqY4S3/Wd
        t36rwhsYztwdbvd3i0rN58sJD6OADK4GEMkfzaZ/CvntUIMXKfu4RWgOp8DQQFdVcWsuDhiExk7vm
        ATrDnGFg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kJHQJ-00019z-9R; Fri, 18 Sep 2020 16:31:39 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kJHQA-0007Qs-U3; Fri, 18 Sep 2020 16:31:31 +0200
Subject: Re: [PATCH 1/3] usbcore/driver: Fix specific driver selection
To:     linux-usb@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>, syzkaller@googlegroups.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <363eab9a-c32a-4c60-4d6b-14ae8d873c52@runbox.com>
Date:   Fri, 18 Sep 2020 17:31:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917144151.355848-1-m.v.b@runbox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/09/2020 17.41, M. Vefa Bicakci wrote:
> This commit resolves a bug in the selection/discovery of more
> specific USB device drivers for devices that are currently bound to
> generic USB device drivers.
> 
> The bug is in the logic that determines whether a device currently
> bound to a generic USB device driver should be re-probed by a
> more specific USB device driver or not. The code in
> __usb_bus_reprobe_drivers() used to have the following lines:
> 
>    if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
>        (!new_udriver->match || new_udriver->match(udev) != 0))
>   		return 0;
> 
>    ret = device_reprobe(dev);
> 
> As the reader will notice, the code checks whether the USB device in
> consideration matches the identifier table (id_table) of a specific
> USB device_driver (new_udriver), followed by a similar check, but this
> time with the USB device driver's match function. However, the match
> function's return value is not checked correctly. When match() returns
> zero, it means that the specific USB device driver is *not* applicable
> to the USB device in question, but the code then goes on to reprobe the
> device with the new USB device driver under consideration. All this to
> say, the logic is inverted.
> 
> This bug was found by code inspection and instrumentation after
> Andrey Konovalov's report indicating USB/IP subsystem's misbehaviour
> with the generic USB device driver matching code.
> 
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Fixes: d5643d2249 ("USB: Fix device driver race")
> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
> Cc: <stable@vger.kernel.org> # 5.8
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: <syzkaller@googlegroups.com>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>   drivers/usb/core/driver.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index c976ea9f9582..950044a6e77f 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -924,7 +924,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
>   
>   	udev = to_usb_device(dev);
>   	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
> -	    (!new_udriver->match || new_udriver->match(udev) != 0))
> +	    (!new_udriver->match || new_udriver->match(udev) == 0))
>   		return 0;
>   
>   	ret = device_reprobe(dev);
> 
> base-commit: 871e6496207c6aa94134448779c77631a11bfa2e

Hello all,

I noticed that applying this patch on its own to the kernel causes the following
unexpected behaviour: As soon as the usbip_host module is loaded, all of the
USB devices are re-probed() by their drivers, and this causes the USB devices
connected to my system to be momentarily unavailable. This happens because
*without* the third patch in this patch set, the match function for the usbip_host
device driver unconditionally returns true.

The third patch in this patch set [1] makes this unexpected behaviour go
away, as it makes the usbip device driver's match function only match devices
that were requested by user-space to be used with USB-IP.

Is this something to be concerned about? I was thinking of people who might be
using git-bisect, who might encounter this issue in an unexpected manner.

As a potential solution, I can prepare another patch to revert commit
7a2f2974f2 ("usbip: Implement a match function to fix usbip") so that this
unexpected behaviour will not be observed. This revert would be placed as
the first patch in the patch series.

Thank you,

Vefa

[1] https://lore.kernel.org/linux-usb/20200917144151.355848-3-m.v.b@runbox.com/
