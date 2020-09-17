Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516DB26DFD7
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 17:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgIQPlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 11:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgIQPVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 11:21:12 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA111C061756
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 08:21:11 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id h17so2270027otr.1
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 08:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MTVVCrJVa8GUaPAcJjmBPCpJDItiRuSaBMYiXKb62FU=;
        b=iYZlm72Rmim58xVUQGXw4xVLjxW8sc4ZJsks9PXXs9yKAWaFXAGBJyn1wVZoptvzSf
         546VR0MJqQn9jICAjPJspzktWQDV5PatKrdTpU3x2Ur4Fyv54fMqoPGds/BIi56gaMtF
         C6a+WBjlxkuIRPDK1rhR0jKN85MFZyNUHYgPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTVVCrJVa8GUaPAcJjmBPCpJDItiRuSaBMYiXKb62FU=;
        b=EqoIjJflG+vt7NrckECb428Kp//I2PIOPq6Wams+dh4x43hoZrJgkap3yLwusJ2KuK
         7JyLArA+lb5Ug1tlBaWanCkNdtNACJ6JZdV5Px7Vl7n5vMJqo+fHjxrvdjotbBss8V98
         zfW6DVMtkUVVPy18sM1SOzxF093Jmn8Js4/tCCwafLpbbBO7Jp3vgXFr5/fz1iosaS20
         NtdsREbs64YS4zbSVny5E7tpbPZdivGPHCb3+pR6ziOxYIc2r6BccM0uMVWuOJGHr3uu
         3wfZumgQ5nzjNQB69LhZvCN9lukBR5LTohMjJk1sQ+lfH92frxNiRT3gC3OaNfgOgC/Q
         9QJQ==
X-Gm-Message-State: AOAM532/BIITKhmuzXF9Az4s8Lar+i6r4GwTdqQJSIe6xF8V9JTzifo2
        Z3e53XK7pphKOkEFjbAGHcj1Ig==
X-Google-Smtp-Source: ABdhPJyYyPOcQ0DOIqvmXsmP4TVnPt7Wz94HKJTHhcrEzgh+sw123ahOhmwlWS3JMchquydogOZugQ==
X-Received: by 2002:a9d:2d87:: with SMTP id g7mr963838otb.320.1600356069612;
        Thu, 17 Sep 2020 08:21:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s20sm107133oot.15.2020.09.17.08.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 08:21:09 -0700 (PDT)
Subject: Re: [PATCH 3/3] usbip: Make the driver's match function specific
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com, Shuah Khan <skhan@linuxfoundation.org>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <20200917144151.355848-3-m.v.b@runbox.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <45badff8-53e9-359d-4bf2-b0f71b910b2f@linuxfoundation.org>
Date:   Thu, 17 Sep 2020 09:21:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200917144151.355848-3-m.v.b@runbox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/17/20 8:41 AM, M. Vefa Bicakci wrote:
> Prior to this commit, the USB-IP subsystem's USB device driver match
> function used to match all USB devices (by returning true
> unconditionally). Unfortunately, this is not correct behaviour and is
> likely the root cause of the bug reported by Andrey Konovalov.
> 
> USB-IP should only match USB devices that the user-space asked the kernel
> to handle via USB-IP, by writing to the match_busid sysfs file, which is
> what this commit aims to achieve. This is done by making the match
> function check that the passed in USB device was indeed requested by the
> user-space to be handled by USB-IP.
> 

I see two patches 2/2 and 3/3 back to back. What is the difference
between 2/2 and 3/3 versions? They look identical. Please include
changes if any from version to version to make it easier for me to
review.

> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Fixes: 7a2f2974f2 ("usbip: Implement a match function to fix usbip")
> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
> Cc: <stable@vger.kernel.org> # 5.8
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: Valentina Manea <valentina.manea.m@gmail.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: <syzkaller@googlegroups.com>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>   drivers/usb/usbip/stub_dev.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
> index 9d7d642022d1..3d9c8ff6762e 100644
> --- a/drivers/usb/usbip/stub_dev.c
> +++ b/drivers/usb/usbip/stub_dev.c
> @@ -463,7 +463,20 @@ static void stub_disconnect(struct usb_device *udev)
>   
>   static bool usbip_match(struct usb_device *udev)
>   {
> -	return true;
> +	bool match;
> +	struct bus_id_priv *busid_priv;
> +	const char *udev_busid = dev_name(&udev->dev);
> +
> +	busid_priv = get_busid_priv(udev_busid);
> +	if (!busid_priv)
> +		return false;
> +
> +	match = (busid_priv->status != STUB_BUSID_REMOV &&
> +		 busid_priv->status != STUB_BUSID_OTHER);
> +
> +	put_busid_priv(busid_priv);
> +
> +	return match;
>   }
>   
>   #ifdef CONFIG_PM
> 

Did you happen to run the usbip test on this patch? If not, can you
please run tools/testing/selftests/drivers/usb/usbip/usbip_test.sh
and make sure there are no regressions.

thanks,
-- Shuah

