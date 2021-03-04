Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4E632CEF3
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 09:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbhCDI5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 03:57:01 -0500
Received: from air.basealt.ru ([194.107.17.39]:54224 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236918AbhCDI4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 03:56:37 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2021 03:56:37 EST
Received: by air.basealt.ru (Postfix, from userid 490)
        id 2E99A589443; Thu,  4 Mar 2021 08:50:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        RP_MATCHES_RCVD autolearn=ham autolearn_force=no version=3.4.1
Received: from nickel-ws.localdomain (obninsk.basealt.ru [217.15.195.17])
        by air.basealt.ru (Postfix) with ESMTPSA id AC3FF58941E;
        Thu,  4 Mar 2021 08:49:59 +0000 (UTC)
Reply-To: nickel@basealt.ru
Subject: Re: elan_i2c: failed to read report data: -71
To:     stable@vger.kernel.org
Cc:     jingle <jingle.wu@emc.com.tw>, kernel@pengutronix.de,
        linux-input@vger.kernel.org,
        'Dmitry Torokhov' <dmitry.torokhov@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
 <YEA9oajb7qj6LGPD@google.com>
 <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
From:   Nikolai Kostrigin <nickel@basealt.ru>
Organization: BaseALT
Message-ID: <15cb57ba-9188-51a1-b931-da45932e199f@basealt.ru>
Date:   Thu, 4 Mar 2021 11:49:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

04.03.2021 09:59, Uwe Kleine-König пишет:
> Hello,
> 
> On Wed, Mar 03, 2021 at 05:53:37PM -0800, 'Dmitry Torokhov' wrote:
>> On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-König wrote:
>>> On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-König wrote:
>>>> On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
>>>>> Please updates this patchs.
>>>>>
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=056115daede8d01f71732bc7d778fb85acee8eb6
>>>>>
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=e4c9062717feda88900b566463228d1c4910af6d
>>>>
>>>> The first was one of the two patches I already tried, but the latter
>>>> indeed fixes my problem \o/.
>>>>
>>>> @Dmitry: If you don't consider your tree stable, feel free to add a
>>>>
>>>> 	Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>>>
>>>> to e4c9062717feda88900b566463228d1c4910af6d.
>>>
>>> Do you consider this patch for stable? I'd like to see it in Debian's
>>> 5.10 kernel and I guess I'm not the only one who would benefit from such
>>> a backport.
>>
>> When I was applying the patches I did not realize that there was already
>> hardware in the wild that needed it. The patches are now in mainline, so
>> I can no longer adjust the tags, but I will not object if you propose
>> them for stable.
> 
> I want to propose to backport commit
> 
> e4c9062717fe ("Input: elantech - fix protocol errors for some trackpoints in SMBus mode")
> 
> to the active stable kernels. This commit repairs the track point and
> the touch pad buttons on a Lenovo Thinkpad E15 here. Without this change
> I don't get any events apart from an error message for each button press
> or move of the track point in the kernel log. (Also the error message is
> the same for all buttons and the track point, so I cannot create a new
> input event driver in userspace that emulates the right event depending
> on the error message :-)
> 
> At least to 5.10.x it applies cleanly, I didn't try the older stable
> branches.
> 
> Best regards and thanks
> Uwe
> 

I'd like to propose to backport [1] also as it was checked along with
previously proposed patch and fixes Elan Trackpoint operation on
Thinkpad L13.

Both patches apply cleanly to 5.10.17 in my case.

I also tried to apply to 5.4.x, but failed.

[1] 056115daede8 Input: elan_i2c - add new trackpoint report type 0x5F

Additional info is available here:

https://lore.kernel.org/linux-input/fe31f6f8-6e38-2ed6-8548-6fa271bf36e9@basealt.ru/T/#m514047f2c5e7e2ec4ed9658782f14221ed7598fc
-- 
Best regards,
Nikolai Kostrigin
