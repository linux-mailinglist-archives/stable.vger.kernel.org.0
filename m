Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDBF647845
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 22:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLHVyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 16:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLHVyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 16:54:01 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Dec 2022 13:53:59 PST
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3A6865A3
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 13:53:59 -0800 (PST)
Received: (wp-smtpd smtp.tlen.pl 12325 invoked from network); 8 Dec 2022 22:47:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1670536037; bh=EBSs+vJL8c6Kq20TINutZX7cXWTadKq3z2+PMTBk734=;
          h=Subject:To:Cc:From;
          b=ySkECOXl0t4LYf1RBBSqDGCixsIc6p0d0xptQdVMWNYlzfzsBxrwlertCCSLwNKG6
           2G/+0mxI9L1PjfoNqrkuYymvlOj/0wRrgIKsOi8VnXbKFAjwdbLP55dSCh7VRjIT90
           OWUKsdZps5g0fQSeaR+pX8VuXJZZgyLmGzDc/1gU=
Received: from aaev158.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.125.158])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <kane.chen@intel.com>; 8 Dec 2022 22:47:17 +0100
Message-ID: <70ee669e-9d35-4ff0-13b4-c72e2448a1f7@o2.pl>
Date:   Thu, 8 Dec 2022 22:47:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: RE: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm
 time
Content-Language: en-GB
To:     "Chen, Kane" <kane.chen@intel.com>, Sasha Levin <sashal@kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
References: <20221207035722.15749-1-kane.chen@intel.com>
 <Y5Ag6YhxcPPbs4Jr@sashalap>
 <MW5PR11MB5857D26C66FA084280709384E01A9@MW5PR11MB5857.namprd11.prod.outlook.com>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <MW5PR11MB5857D26C66FA084280709384E01A9@MW5PR11MB5857.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: ca973171d301ee2bfc35ceb4fa3efd10
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [IVPk]                               
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W dniu 7.12.2022 o 07:51, Chen, Kane pisze:
>> -----Original Message-----
>> From: Sasha Levin <sashal@kernel.org>
>> Sent: Wednesday, December 7, 2022 1:13 PM
>> To: Chen, Kane <kane.chen@intel.com>
>> Cc: stable@vger.kernel.org
>> Subject: Re: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
>>
>> On Wed, Dec 07, 2022 at 11:57:22AM +0800, Kane Chen wrote:
>>> While runnings s0ix cycling test based on rtc alarm wakeup on ADL-P
>>> devices, We found the data from CMOS_READ is not reasonable and causes
>> RTC wake up fail.
>>> With the below changes, we don't see unreasonable data from cmos and
>> issue is gone.
>>
>> Thanks for the analysis, I can queue most of these up. There are two which
>> won't go in:
>>
>>> cd17420: rtc: cmos: avoid UIP when writing alarm time
>>> cdedc45: rtc: cmos: avoid UIP when reading alarm time
>>> ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
>>> ea6fa49: rtc: mc146818-lib: fix RTC presence check
>>> 13be2ef: rtc: cmos: Disable irq around direct invocation of
>>> cmos_interrupt()
>>> 0dd8d6c: rtc: Check return value from mc146818_get_time()
>>> e1aba37: rtc: cmos: remove stale REVISIT comments
>>> 6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard
>>> IRQ
>> This one fixes a commit which isn't in the 5.10 tree.
>>
>>> d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
>>> ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
>>> 211e5db: rtc: mc146818: Detect and handle broken RTCs
>>> dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()
>> This one looks like an optimization.
>>
>> --
> I'm sorry,
> I thought dcf257e and  6950d04, 13be2ef  are also required to avoid cherry-pick conflict
> After checking again, dcf257e, 6950d04, 13be2ef are not needed.
>
> Here is the list I would like to pick
> cd17420: rtc: cmos: avoid UIP when writing alarm time
> cdedc45: rtc: cmos: avoid UIP when reading alarm time
> ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
> ea6fa49: rtc: mc146818-lib: fix RTC presence check
> 0dd8d6c: rtc: Check return value from mc146818_get_time()
> e1aba37: rtc: cmos: remove stale REVISIT comments
> d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
> ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
> 211e5db: rtc: mc146818: Detect and handle broken RTCs
> 05a0302: rtc: mc146818: Prevent reading garbage
>
> Thanks a lot
>
>> Thanks,
>> Sasha
>>
Hello,

I think that you should also pick these patches which fix issues in the series
that is prepared for 5.4:

1) commit 7372971c1be5 ("rtc: mc146818-lib: fix signedness bug in mc146818_get_time()")

which fixes d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()

2) commit 13be2efc390a ("rtc: cmos: Disable irq around direct invocation of cmos_interrupt()")

which fixes 6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ
and is not prepared for 5.4 stable even though it was mentioned above.

3) commit 811f5559270f ("rtc: mc146818-lib: fix locking in mc146818_set_time")

which fixes dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()


When it comes to these two patches:

cd17420: rtc: cmos: avoid UIP when writing alarm time
cdedc45: rtc: cmos: avoid UIP when reading alarm time

I used to think that the issues they fix were very unlikely to happen in practice,
so I did not submit them into stable. So thanks for proving me wrong.

Greetings,
Mateusz

