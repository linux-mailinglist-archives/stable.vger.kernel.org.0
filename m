Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1D361D1D
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241350AbhDPJVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:21:11 -0400
Received: from smtp.radex.nl ([178.250.146.7]:60680 "EHLO radex-web.radex.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238823AbhDPJVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:21:10 -0400
Received: from [192.168.1.158] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id D9EE0240A8;
        Fri, 16 Apr 2021 11:10:55 +0200 (CEST)
From:   Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     John Stultz <john.stultz@linaro.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <CALAqxLW9d-jWC4qyfWvTQAYT-V7W19tFY+v3pzCE_QHfNYeYTg@mail.gmail.com>
 <CALAqxLX0b=uZ4JQX1h5PLRUq+B05wWOt2=QSO_QoO8rdMWgp=w@mail.gmail.com>
Message-ID: <b0b99566-a5d3-5c16-d9b1-0f743f3a6a55@gmail.com>
Date:   Fri, 16 Apr 2021 11:10:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CALAqxLX0b=uZ4JQX1h5PLRUq+B05wWOt2=QSO_QoO8rdMWgp=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Op 16-04-2021 om 05:28 schreef John Stultz:
> On Thu, Apr 15, 2021 at 5:12 PM John Stultz<john.stultz@linaro.org>  wrote:
>> On Thu, Apr 15, 2021 at 3:20 PM Thinh Nguyen<Thinh.Nguyen@synopsys.com>  wrote:
>>> From: Yu Chen<chenyu56@huawei.com>
>>> From: John Stultz<john.stultz@linaro.org>
>>>
>>> According to the programming guide, to switch mode for DRD controller,
>>> the driver needs to do the following.
>>>
>>> To switch from device to host:
>>> 1. Reset controller with GCTL.CoreSoftReset
>>> 2. Set GCTL.PrtCapDir(host mode)
>>> 3. Reset the host with USBCMD.HCRESET
>>> 4. Then follow up with the initializing host registers sequence
>>>
>>> To switch from host to device:
>>> 1. Reset controller with GCTL.CoreSoftReset
>>> 2. Set GCTL.PrtCapDir(device mode)
>>> 3. Reset the device with DCTL.CSftRst
>>> 4. Then follow up with the initializing registers sequence
>>>
>>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
>>> switching from host to device. John Stult reported a lockup issue seen
>>> with HiKey960 platform without these steps[1]. Similar issue is observed
>>> with Ferry's testing platform[2].
>>>
>>> So, apply the required steps along with some fixes to Yu Chen's and John
>>> Stultz's version. The main fixes to their versions are the missing wait
>>> for clocks synchronization before clearing GCTL.CoreSoftReset and only
>>> apply DCTL.CSftRst when switching from host to device.
>>>
>>> [1]https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
>>> [2]https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/
>>>
>>> Cc: Andy Shevchenko<andy.shevchenko@gmail.com>
>>> Cc: Ferry Toth<fntoth@gmail.com>
>>> Cc: Wesley Cheng<wcheng@codeaurora.org>
>>> Cc:<stable@vger.kernel.org>
>>> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
>>> Signed-off-by: Yu Chen<chenyu56@huawei.com>
>>> Signed-off-by: John Stultz<john.stultz@linaro.org>
>>> Signed-off-by: Thinh Nguyen<Thinh.Nguyen@synopsys.com>
>>> ---
>>> Changes in v3:
>>> - Check if the desired mode is OTG, then keep the old flow
>>> - Remove condition for OTG support only since the device can still be
>>>    configured DRD host/device mode only
>>> - Remove redundant hw_mode check since __dwc3_set_mode() only applies when
>>>    hw_mode is DRD
>>> Changes in v2:
>>> - Initialize mutex per device and not as global mutex.
>>> - Add additional checks for DRD only mode
>>>
>> I've not been able to test all the different modes on HiKey960 yet,
>> but with this patch we avoid the !COREIDLE hangs that we see
>> frequently on bootup, so it looks pretty good to me.  I'll get back to
>> you tonight when I can put hands on the board to test the gadget to
>> host switching to make sure all is well (I really don't expect any
>> issues, but just want to be sure).
> Ok, got a chance to test the mode switching and everything is looking good.
I expect to be able to test this weekend on my platform.
> Tested-by: John Stultz<john.stultz@linaro.org>
>
> Thanks again for continuing to push this!
> -john
