Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE53A6492AA
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 07:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLKGJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 01:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLKGJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 01:09:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE54E12D07
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 22:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51BE260CA3
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 06:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65741C433D2;
        Sun, 11 Dec 2022 06:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670738975;
        bh=vgsqI3eNKUhoZD1AcF+9vSNIqET/vbS0+Gq6EFfGsmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8M2aHM3S1FvUhxzOwNtnYhpt/90LAjGVVX3MoxL23BtNGF1zUKVIKnqU3+bh+KEt
         lanQoTOJ4VdOoCNB8y8LbntzeFepb0BsQ3eoa5RCtssEJrKSS3soS6FTK7Z6DsxcFl
         4RnRVkZuMQgoQHjLsrOyipztccOR1+F6eUYe9aOBMyKbsjyEkrEzQ/xsN+1DazlcLb
         xU5sYLCNQ29R9I1SQs3EMis/U2SFIqG2TabjFvREqAUJiiLTy0QoAcudjS9L6uV11g
         p0FPi/mL9ngxmgIAPOtMH0CvwdXom595QKsYeugEvx3fME5ihWXE7hWbqTT4AIWR/S
         dQRrgAIOQoMog==
Date:   Sun, 11 Dec 2022 01:09:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc:     "Chen, Kane" <kane.chen@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Message-ID: <Y5V0HpqcueAth01g@sashalap>
References: <20221207035722.15749-1-kane.chen@intel.com>
 <Y5Ag6YhxcPPbs4Jr@sashalap>
 <MW5PR11MB5857D26C66FA084280709384E01A9@MW5PR11MB5857.namprd11.prod.outlook.com>
 <70ee669e-9d35-4ff0-13b4-c72e2448a1f7@o2.pl>
 <Y5KDSGfpzk8AyQ4y@sashalap>
 <4f74e731-0dce-2234-f834-c46b54ec9a43@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f74e731-0dce-2234-f834-c46b54ec9a43@o2.pl>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 11:40:56PM +0100, Mateusz Jończyk wrote:
>W dniu 9.12.2022 o 01:37, Sasha Levin pisze:
>> On Thu, Dec 08, 2022 at 10:47:17PM +0100, Mateusz Jończyk wrote:
>>> W dniu 7.12.2022 o 07:51, Chen, Kane pisze:
>>>>> -----Original Message-----
>>>>> From: Sasha Levin <sashal@kernel.org>
>>>>> Sent: Wednesday, December 7, 2022 1:13 PM
>>>>> To: Chen, Kane <kane.chen@intel.com>
>>>>> Cc: stable@vger.kernel.org
>>>>> Subject: Re: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
>>>>>
>>>>> On Wed, Dec 07, 2022 at 11:57:22AM +0800, Kane Chen wrote:
>>>>>> While runnings s0ix cycling test based on rtc alarm wakeup on ADL-P
>>>>>> devices, We found the data from CMOS_READ is not reasonable and causes
>>>>> RTC wake up fail.
>>>>>> With the below changes, we don't see unreasonable data from cmos and
>>>>> issue is gone.
>>>>>
>>>>> Thanks for the analysis, I can queue most of these up. There are two which
>>>>> won't go in:
>>>>>
>>>>>> cd17420: rtc: cmos: avoid UIP when writing alarm time
>>>>>> cdedc45: rtc: cmos: avoid UIP when reading alarm time
>>>>>> ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
>>>>>> ea6fa49: rtc: mc146818-lib: fix RTC presence check
>>>>>> 13be2ef: rtc: cmos: Disable irq around direct invocation of
>>>>>> cmos_interrupt()
>>>>>> 0dd8d6c: rtc: Check return value from mc146818_get_time()
>>>>>> e1aba37: rtc: cmos: remove stale REVISIT comments
>>>>>> 6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard
>>>>>> IRQ
>>>>> This one fixes a commit which isn't in the 5.10 tree.
>>>>>
>>>>>> d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
>>>>>> ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
>>>>>> 211e5db: rtc: mc146818: Detect and handle broken RTCs
>>>>>> dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()
>>>>> This one looks like an optimization.
>>>>>
>>>>> --
>>>> I'm sorry,
>>>> I thought dcf257e and  6950d04, 13be2ef  are also required to avoid cherry-pick conflict
>>>> After checking again, dcf257e, 6950d04, 13be2ef are not needed.
>>>>
>>>> Here is the list I would like to pick
>>>> cd17420: rtc: cmos: avoid UIP when writing alarm time
>>>> cdedc45: rtc: cmos: avoid UIP when reading alarm time
>>>> ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
>>>> ea6fa49: rtc: mc146818-lib: fix RTC presence check
>>>> 0dd8d6c: rtc: Check return value from mc146818_get_time()
>>>> e1aba37: rtc: cmos: remove stale REVISIT comments
>>>> d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
>>>> ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
>>>> 211e5db: rtc: mc146818: Detect and handle broken RTCs
>>>> 05a0302: rtc: mc146818: Prevent reading garbage
>>>>
>>>> Thanks a lot
>>>>
>>>>> Thanks,
>>>>> Sasha
>>>>>
>>> Hello,
>>>
>>> I think that you should also pick these patches which fix issues in the series
>>> that is prepared for 5.4:
>>>
>>> 1) commit 7372971c1be5 ("rtc: mc146818-lib: fix signedness bug in mc146818_get_time()")
>>>
>>> which fixes d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
>>>
>>> 2) commit 13be2efc390a ("rtc: cmos: Disable irq around direct invocation of cmos_interrupt()")
>>>
>>> which fixes 6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ
>>> and is not prepared for 5.4 stable even though it was mentioned above.
>>>
>>> 3) commit 811f5559270f ("rtc: mc146818-lib: fix locking in mc146818_set_time")
>>>
>>> which fixes dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()
>>
>> Ack, will do, thanks.
>
>Hello,
>
>However, I would like to ask: is it really necessary to include all of
>these patches in stable? I think that it is very likely that only these patches
>are sufficient to fix the original problem reported by Kane Chen:
>
>cd17420: rtc: cmos: avoid UIP when writing alarm time
>cdedc45: rtc: cmos: avoid UIP when reading alarm time
>ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP

I would agree that this could be enough to fix the issue that was
described, but...

>These patches should be most relevant when using the RTC alarm and are
>self-contained. So I would like to ask Kane Chen to recheck with these patches
>only. Other patches change the CMOS RTC reading routines significantly
>and have a higher risk of introducing regressions (but I am not aware of any
>outstanding problems).

The rest of the patches do look like fixes that should have been added
to stable (or are dependencies of such fixes) on their own. Given
those patches are pretty old, any reason to not just include them?

The process works better if we address issues before making users come
and complain on the mailing list :)

-- 
Thanks,
Sasha
