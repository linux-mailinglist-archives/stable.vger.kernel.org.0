Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CFE270151
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 17:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgIRPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 11:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRPtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 11:49:15 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99248C0613CF
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 08:49:15 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id b12so1520536oop.13
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 08:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ZCvvmPS8NZtzcruP7g025J2xlGm6Ho0jKBIcAsBZw8=;
        b=FQcc71LXQzx71dmeeefd9NzMr960WhzjM+ML44qYvLf/kwepwfygyAnsLEa3l7CPmD
         QBB7oIcSwiVCNe086MFRQ4Ff/JJqxAbZQztXfinVbDFX7jrtNcCtJ4C1QxafYK+9d1Qw
         w5FYm+ijWZTrToN5m/arhmrFbwIRKgyKe9gm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ZCvvmPS8NZtzcruP7g025J2xlGm6Ho0jKBIcAsBZw8=;
        b=acHCyvqBO7lURJJXv5hxhxV4MGrRDNECQ5GEX0TTzSFeFNDtvQ+/brQkdjp3WlxpQN
         J9B3ObXUqlCrMOOOVGFGUA3XU+d17cs1MKfndmaSyjkxEefWA/BRTKJrGAlOPk3WbcNo
         F5ITpPjPHJry4lffdquKOw4GcVN2XQM60oFt4/dDzC892xFDXRm0sGUUhUj20UlyvGRe
         RRYVJFnMFs2CCVDSvPAqF+OsYzM7Y8WMy2ioh7M//Ppas77DLPjTwg8H8T+0mdcBNxNw
         4paxvu9YXJaZgtUATfLYwLfoQdYL7NmE2Z3RkWVCgjUx4IT165XYOsGG32ZnVKg4RgkW
         ysSw==
X-Gm-Message-State: AOAM5315Zhn2SmWVp7m3S0YAG7yLvLIQjCnJue54+xsnQRbtxjJ35kQF
        VMUHMcv5i1bz9kA6Qf1rpaHEcw==
X-Google-Smtp-Source: ABdhPJzxEgRaV8FUuna5mSlVx3LEhW2+ch/5o+hyR0quWhQb+fauYLPUj1Ysu4SsHrEEoWKIX9DYRA==
X-Received: by 2002:a4a:d04c:: with SMTP id x12mr24290524oor.61.1600444154765;
        Fri, 18 Sep 2020 08:49:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j24sm2518897otn.64.2020.09.18.08.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 08:49:14 -0700 (PDT)
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
 <45badff8-53e9-359d-4bf2-b0f71b910b2f@linuxfoundation.org>
 <e64f51b0-db05-e078-af58-b31a0be1e9ca@runbox.com>
 <e6404ae3-4b4e-f8d4-4c92-a71410e20569@runbox.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d6d43c46-3231-7e64-b708-d1fe8349e8a3@linuxfoundation.org>
Date:   Fri, 18 Sep 2020 09:49:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e6404ae3-4b4e-f8d4-4c92-a71410e20569@runbox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/18/20 8:31 AM, M. Vefa Bicakci wrote:
> On 18/09/2020 12.26, M. Vefa Bicakci wrote:
>> On 17/09/2020 18.21, Shuah Khan wrote:
>>> On 9/17/20 8:41 AM, M. Vefa Bicakci wrote:
>>>> Prior to this commit, the USB-IP subsystem's USB device driver match
>>>> function used to match all USB devices (by returning true
>>>> unconditionally). Unfortunately, this is not correct behaviour and is
>>>> likely the root cause of the bug reported by Andrey Konovalov.
>>>>
>>>> USB-IP should only match USB devices that the user-space asked the 
>>>> kernel
>>>> to handle via USB-IP, by writing to the match_busid sysfs file, 
>>>> which is
>>>> what this commit aims to achieve. This is done by making the match
>>>> function check that the passed in USB device was indeed requested by 
>>>> the
>>>> user-space to be handled by USB-IP.
> 
> [snipped by Vefa]
> 
>>>> Reported-by: Andrey Konovalov <andreyknvl@google.com>
>>>> Fixes: 7a2f2974f2 ("usbip: Implement a match function to fix usbip")
>>>> Link: 
>>>> https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/ 
>>>>
>>>> Cc: <stable@vger.kernel.org> # 5.8
>>>> Cc: Bastien Nocera <hadess@hadess.net>
>>>> Cc: Valentina Manea <valentina.manea.m@gmail.com>
>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Cc: Alan Stern <stern@rowland.harvard.edu>
>>>> Cc: <syzkaller@googlegroups.com>
>>>> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
>>>> ---
>>>>   drivers/usb/usbip/stub_dev.c | 15 ++++++++++++++-
>>>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/usb/usbip/stub_dev.c 
>>>> b/drivers/usb/usbip/stub_dev.c
>>>> index 9d7d642022d1..3d9c8ff6762e 100644
>>>> --- a/drivers/usb/usbip/stub_dev.c
>>>> +++ b/drivers/usb/usbip/stub_dev.c
>>>> @@ -463,7 +463,20 @@ static void stub_disconnect(struct usb_device 
>>>> *udev)
>>>>   static bool usbip_match(struct usb_device *udev)
>>>>   {
>>>> -    return true;
>>>> +    bool match;
>>>> +    struct bus_id_priv *busid_priv;
>>>> +    const char *udev_busid = dev_name(&udev->dev);
>>>> +
>>>> +    busid_priv = get_busid_priv(udev_busid);
>>>> +    if (!busid_priv)
>>>> +        return false;
>>>> +
>>>> +    match = (busid_priv->status != STUB_BUSID_REMOV &&
>>>> +         busid_priv->status != STUB_BUSID_OTHER);
>>>> +
>>>> +    put_busid_priv(busid_priv);
>>>> +
>>>> +    return match;
>>>>   }
>>>>   #ifdef CONFIG_PM
>>>>
>>>
>>> Did you happen to run the usbip test on this patch? If not, can you
>>> please run tools/testing/selftests/drivers/usb/usbip/usbip_test.sh
>>> and make sure there are no regressions.
>>
>> Ah, this is a very good point! I have been testing the patches on 
>> Qubes OS,
>> which uses usbip to forward USB devices between VMs. To be honest, I 
>> was not
>> aware of the self-tests for usbip, and I will run the self-tests prior to
>> publishing the next version of the patch series.
> 
> Hello Shuah,
> 
> I have just cleaned up the patches and run usbip_test.sh with a kernel 
> without
> the patches in this series and with a kernel in this series.
> 
> I noticed that there is a change in behaviour due to the fact that the new
> match function (usbip_match) does not always return true. This causes the
> stub device driver's probe() function to not get called at all, as the new
> more selective match function will prevent the stub device driver from 
> being
> considered as a potential driver for the device under consideration.
> 

Yes. This is the behavior I am concerned about and hence the reason
to use the usbip test to verify this doesn't happen.

With the patch you have the usbip match behavior becomes restrictive
which isn't desirable.

> All of this results in the following difference in the logs of the 
> usbip_test.sh,
> where the expected kernel log message "usbip-host 2-6: 2-6 is not in 
> match_busid table... skip!"
> is not printed by a kernel that includes the patches in this series.
> 
> --- unpatched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
> +++ patched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
> @@ -213,70 +213,69 @@
>       |__ Port 1: Dev 2, If 0, Class=Human Interface Device, 
> Driver=usbhid, 480M
>   ==============================================================
>   modprobe usbip_host - does it work?
>   Should see -busid- is not in match_busid table... skip! dmesg
>   ==============================================================
> -usbip-host 2-6: 2-6 is not in match_busid table... skip!
>   ==============================================================
> 
> Do you find this change in behaviour unacceptable?

Yeah. This behavior isn't acceptable.

If no, I can remove this
> test case from usbip_test.sh with the same patch. If yes, then there is 
> a need
> for a different solution to resolve the unexpected negative interaction 
> between
> Bastien's work on generic/specific USB device driver selection and usbip
> functionality.
> 

I would recommend finding a different solution. Now that you have the
usbip test handy, you can verify and test for regressions.

thanks,
-- Shuah

