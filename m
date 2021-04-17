Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E162F36312F
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 18:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhDQQcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Apr 2021 12:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbhDQQcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Apr 2021 12:32:43 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0D7C061574;
        Sat, 17 Apr 2021 09:32:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g5so39828358ejx.0;
        Sat, 17 Apr 2021 09:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Mre8A1qZzwXDozmV16DdOY4KfTSWbWa13Kk6WV+A88M=;
        b=LEZ/lklsIto0L9i/m1Lr4oQzuPm35PpYdqNIAsqWYtLCpJfh7ntXv4UMGx8Y+kR0z6
         JGI3/j0IFBL+EIU+LnucthcIvrPzsCn6B7p7rR/R0UbPsJQzlD6cnCDg2nduTmWO3l9p
         dINwxi5jrDeg33SYBz7QXCIh4+2fmDQEpaN9oGh0ICl4tbZEUVqeqP6VkbyVzxVoDbJo
         5oNwm4+INyDsNqqZWCX6SOGCLqOeDR6KxVTK96cT92Wdxf8t3kGWG4W32dTcJsll2Qvw
         YH8H1T2LgHp/GZxZl9+i77mtgRSWAoIf3EkaHRVZLxXGH9/PuiE0k+kpC8Bhwm/vtg/T
         ANjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Mre8A1qZzwXDozmV16DdOY4KfTSWbWa13Kk6WV+A88M=;
        b=at84RxXNgKdzZ63AGd77ypaVqqtPfiVTgRQD6AhE9ltY/1bc+bCSjEp8u19HD+zk2v
         /KxeZsmJhMTQKF0xICA1sRDhnw+he5fBvhroskwslKOnD6w/+kjlLwJVg2CY9+wR1yeh
         s4ZOps7Adt/gNYQ5Mn3s4SFl4g0Q9/If6ZChReOECTJJGwvy7V1tKo7oNOcCZxGJy+CJ
         fSITEtHwz1znCA9iITt1I7RB4mmf+a9vr1Rh6MbTpw1JZ4h7YJ3BQrgauCudqeJPDNzC
         wLaednYtel+pPVmaxlYsqi01IAIP3bAjrNwNJjdX9rhsxhXA9cBT7eSCL5m34TsoQOBf
         t0Ew==
X-Gm-Message-State: AOAM530qRR9QGMxPh870YsBKc+CLn1brMah8RkJCX78ZCIUy20+nt3xl
        BqYi6CoUXrs+/Y8unGBz0ud/nz/a4+kOWQ==
X-Google-Smtp-Source: ABdhPJygZpvREYWAh8AQ9zqEH4enYtHe70nC+lkPTMfy/hVF1OryonAs+npu51slcyA4N17W0lnUoA==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr13988380ejc.292.1618677133552;
        Sat, 17 Apr 2021 09:32:13 -0700 (PDT)
Received: from ?IPv6:2001:981:6fec:1:efde:9c02:f7b7:ab9c? ([2001:981:6fec:1:efde:9c02:f7b7:ab9c])
        by smtp.gmail.com with ESMTPSA id d18sm8470064edv.1.2021.04.17.09.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 09:32:13 -0700 (PDT)
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
From:   Ferry Toth <fntoth@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
 <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
 <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com>
 <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
Message-ID: <09755742-c73b-f737-01c1-8ecd309de551@gmail.com>
Date:   Sat, 17 Apr 2021 18:32:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Op 17-04-2021 om 16:22 schreef Ferry Toth:
> Hi
>
> Op 17-04-2021 om 04:27 schreef Thinh Nguyen:
>> Ferry Toth wrote:
>>> Hi
>>>
>>> Op 16-04-2021 om 00:23 schreef Thinh Nguyen:
>>>> Thinh Nguyen wrote:
>>>>> From: Yu Chen <chenyu56@huawei.com>
>>>>> From: John Stultz <john.stultz@linaro.org>
>>>>>
>>>>> According to the programming guide, to switch mode for DRD 
>>>>> controller,
>>>>> the driver needs to do the following.
>>>>>
>>>>> To switch from device to host:
>>>>> 1. Reset controller with GCTL.CoreSoftReset
>>>>> 2. Set GCTL.PrtCapDir(host mode)
>>>>> 3. Reset the host with USBCMD.HCRESET
>>>>> 4. Then follow up with the initializing host registers sequence
>>>>>
>>>>> To switch from host to device:
>>>>> 1. Reset controller with GCTL.CoreSoftReset
>>>>> 2. Set GCTL.PrtCapDir(device mode)
>>>>> 3. Reset the device with DCTL.CSftRst
>>>>> 4. Then follow up with the initializing registers sequence
>>>>>
>>>>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 
>>>>> 3) of
>>>>> switching from host to device. John Stult reported a lockup issue 
>>>>> seen
>>>>> with HiKey960 platform without these steps[1]. Similar issue is 
>>>>> observed
>>>>> with Ferry's testing platform[2].
>>>>>
>>>>> So, apply the required steps along with some fixes to Yu Chen's 
>>>>> and John
>>>>> Stultz's version. The main fixes to their versions are the missing 
>>>>> wait
>>>>> for clocks synchronization before clearing GCTL.CoreSoftReset and 
>>>>> only
>>>>> apply DCTL.CSftRst when switching from host to device.
>>>>>
>>>>> [1]
>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/__;!!A4F2R9G_pg!PW9Jbs4wv4a_zKGgZHN0FYrIpfecPX0Ouq9V3d16Yz-9-GSHqZWsfBAF-WkeqLhzN4i3$ 
>>>>>
>>>>>
>>>>> [2]
>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/__;!!A4F2R9G_pg!PW9Jbs4wv4a_zKGgZHN0FYrIpfecPX0Ouq9V3d16Yz-9-GSHqZWsfBAF-WkeqGeZStt4$ 
>>>>>
>>>>>
>>>>>
>>>>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>>>>> Cc: Ferry Toth <fntoth@gmail.com>
>>>>> Cc: Wesley Cheng <wcheng@codeaurora.org>
>>>>> Cc: <stable@vger.kernel.org>
>>>>> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work
>>>>> properly")
>>>>> Signed-off-by: Yu Chen <chenyu56@huawei.com>
>>>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>>>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>>>> ---
>>>>> Changes in v3:
>>>>> - Check if the desired mode is OTG, then keep the old flow
>>>>> - Remove condition for OTG support only since the device can still be
>>>>>     configured DRD host/device mode only
>>>>> - Remove redundant hw_mode check since __dwc3_set_mode() only applies
>>>>> when
>>>>>     hw_mode is DRD
>>>>> Changes in v2:
>>>>> - Initialize mutex per device and not as global mutex.
>>>>> - Add additional checks for DRD only mode
>>>>>
>>>>>    drivers/usb/dwc3/core.c | 27 +++++++++++++++++++++++++++
>>>>>    drivers/usb/dwc3/core.h |  5 +++++
>>>>>    2 files changed, 32 insertions(+)
>>>>>
>>>> Hi John,
>>>>
>>>> If possible, can you run a test with this version on your platform?
>>>>
>>>> Thanks,
>>>> Thinh
>>>>
>>> I tested this on edison-arduino with this patch on top of usb-next
>>> (5.12-rc7 + "increase BESL baseline to 6" to prevent throttling").
>>>
>>> On this platform there is a physical switch to switch roles. With this
>>> patch I find:
>>>
>>> - switch to host mode always works fine
>>>
>>> - switch to gadget mode I need to flip the switch 3x 
>>> (gadget-host-gadget).
>>>
>>> An error message appears on the gadget side "dwc3 dwc3.0.auto: timed 
>>> out
>>> waiting for SETUP phase" appears, but then the device connects to my 
>>> PC,
>>> no throttling.
>>>
>>> - alternatively I can switch to gadget 1x and then unplug/replug the 
>>> cable.
>>>
>>> No error message and connects fine.
>>>
>>> - if I flip the switch only once, on the PC side I get:
>>>
>>>    kernel: usb 1-5: new high-speed USB device number 18 using xhci_hcd
>>>    kernel: usb 1-5: New USB device found, idVendor=1d6b,
>>>    idProduct=0104, bcdDevice= 1.00 kernel: usb 1-5: New USB device
>>>    strings: Mfr=1, Product=2, SerialNumber=3 kernel: usb 1-5: Product:
>>>    USBArmory Gadget kernel: usb 1-5: Manufacturer: USBArmory kernel:
>>>    usb 1-5: SerialNumber: 0123456789abcdef kernel: usb 1-5: can't set
>>>    config #1, error -110
>> The device failed at set_configuration() request and timed out. It
>> probably timed out from the status stage looking at the device err 
>> print.
>>
>>> Then if I wait long enough on the gadget side I get:
>>>
>>>    root@yuna:~# ifconfig
>>>
>>>    usb0: flags=-28605<UP,BROADCAST,RUNNING,MULTICAST,DYNAMIC> mtu 1500
>>>    inet 169.254.119.239 netmask 255.255.0.0 broadcast 169.254.255.255
>>>    inet6 fe80::a8bb:ccff:fedd:eef1 prefixlen 64 scopeid 0x20<link>
>>>    ether aa:bb:cc:dd:ee:f1 txqueuelen 1000 (Ethernet) RX packets 490424
>>>    bytes 735146578 (701.0 MiB) RX errors 0 dropped 191 overruns 0 frame
>>>    0 TX packets 35279 bytes 2532746 (2.4 MiB) TX errors 0 dropped 0
>>>    overruns 0 carrier 0 collisions 0
>>>
>>> (correct would be: inet 10.42.0.221 netmask 255.255.255.0 broadcast
>>> 10.42.0.255)
>>>
>>> So much improved now, but it seems I am still missing something on 
>>> plug.
>>>
>> That's great! We can look at it further. Can you capture the tracepoints
>> of the issue. Also, can you try with mass_storage gadget to see if the
>> result is the same?
>
> I have already gser, eem, mass_storage and uac2 combo. When eem fails, 
> the mass_storage and uac2 don't appear (on KDE you get all kind of 
> popups when they appear).
>
> So either all works, or all fails.
>
> I'll trace this later today.

Trace capturing switch from host-> gadget  here 
https://github.com/andy-shev/linux/files/6329600/5.12-rc7%2Busb-next.zip

(Issue history: https://github.com/andy-shev/linux/issues/31)

On the PC side this resulted to:

apr 17 18:17:44 delfion kernel: usb 1-5: new high-speed USB device 
number 12 using xhci_hcd
apr 17 18:17:44 delfion kernel: usb 1-5: New USB device found, 
idVendor=1d6b, idProduct=0104, bcdDevice= 1.00
apr 17 18:17:44 delfion kernel: usb 1-5: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
apr 17 18:17:44 delfion kernel: usb 1-5: Product: USBArmory Gadget
apr 17 18:17:44 delfion kernel: usb 1-5: Manufacturer: USBArmory
apr 17 18:17:44 delfion kernel: usb 1-5: SerialNumber: 0123456789abcdef
apr 17 18:17:49 delfion kernel: usb 1-5: can't set config #1, error -110


Thanks for all your help!

>
>> Thanks,
>> Thinh
