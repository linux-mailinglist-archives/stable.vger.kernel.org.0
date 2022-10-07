Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5718F5F7898
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJGNHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 09:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJGNHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 09:07:34 -0400
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DCB7C0993;
        Fri,  7 Oct 2022 06:07:29 -0700 (PDT)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id A76072407C;
        Fri,  7 Oct 2022 15:07:27 +0200 (CEST)
Message-ID: <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
Date:   Fri, 7 Oct 2022 15:07:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07-10-2022 04:11, Thinh Nguyen wrote:
> On Thu, Oct 06, 2022, Ferry Toth wrote:
>> Hi
>>
>> On 06-10-2022 04:12, Thinh Nguyen wrote:
>>> On Wed, Oct 05, 2022, Ferry Toth wrote:
>>>> Hi,
>>>>
>>>>       Thanks!
>>>>
>>>>       Does the failure only happen the first time host is initialized? Or can
>>>>       it recover after switching to device then back to host mode?
>>>>
>>>> I can switch back and forth and device mode works each time, host mode remains
>>>> dead.
>>> Ok.
>>>
>>>>       Probably the failure happens if some step(s) in dwc3_core_init() hasn't
>>>>       completed.
>>>>
>>>>       tusb1210 is a phy driver right? The issue is probably because we didn't
>>>>       initialize the phy yet. So, I suspect placing dwc3_get_extcon() after
>>>>       initializing the phy will probably solve the dependency problem.
>>>>
>>>>       You can try something for yourself or I can provide something to test
>>>>       later if you don't mind (maybe next week if it's ok).
>>>>
>>>> Yes, the code move I mentioned above "moves dwc3_get_extcon() until after
>>>> dwc3_core_init() but just before dwc3_core_init_mode(). AFAIU initially
>>>> dwc3_get_extcon() was called from within dwc3_core_init_mode() but only for
>>>> case USB_DR_MODE_OTG. So with this change order of events is more or less
>>>> unchanged" solves the issue.
>>>>
>>> I saw the experiment you did from the link you provided. We want to also
>>> confirm exactly which step in dwc3_core_init() was needed.
>> Ok. I first tried the code move suggested by Andrey (didn't work). Then
>> after reading the actual code I moved a bit further.
>>
>> This move was on top of -rc6 without any reverts. I did not make additional
>> changes to dwc3_core_init()
>>
>> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
>> dwc3_core_init - .. - dwc3_core_init_mode (not working)
>>
>> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. - dwc3_core_init - ..
>> - dwc3_core_init_mode (no change)
>>
>> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. - dwc3_get_extcon -
>> dwc3_core_init_mode (works)
>>
>> .. are what I believe for this issue irrelevant calls to
>> dwc3_alloc_scratch_buffers, dwc3_check_params and dwc3_debugfs_init.
>>
> Right. Thanks for narrowing it down. There are still many steps in
> dwc3_core_init(). We have some suspicion, but we still haven't confirmed
> the exact cause of the failure. We can write a proper patch once we know
> the reason.
If you would like me to test your suspicion, just tell me what to do :-)
>
> Thanks,
> Thinh
