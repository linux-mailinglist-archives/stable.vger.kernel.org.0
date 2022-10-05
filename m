Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEED5F511D
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 10:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJEIpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 04:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiJEIpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 04:45:12 -0400
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 064D93C16A;
        Wed,  5 Oct 2022 01:45:04 -0700 (PDT)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 5106C24065;
        Wed,  5 Oct 2022 10:45:03 +0200 (CEST)
Message-ID: <53ca04e3-ee6f-1c4d-3a08-7b5d9dd0d629@gmail.com>
Date:   Wed, 5 Oct 2022 10:45:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
 <CAHQ1cqG9-SDM4_zUfCvxP7XD-U+PPOWqWDBFKU73ecomDpt9Jw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAHQ1cqG9-SDM4_zUfCvxP7XD-U+PPOWqWDBFKU73ecomDpt9Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 05-10-2022 04:39, Andrey Smirnov wrote:
> On Tue, Oct 4, 2022 at 7:12 PM Thinh Nguyen<Thinh.Nguyen@synopsys.com>  wrote:
>> On Tue, Oct 04, 2022, Ferry Toth wrote:
>>> Hi
>>>
>>> Op 04-10-2022 om 10:28 schreef Andy Shevchenko:
>>>> On Mon, Oct 03, 2022 at 09:57:35PM +0000, Thinh Nguyen wrote:
>>>>> On Tue, Sep 27, 2022, Andy Shevchenko wrote:
>>>>>> This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.
>>>>>>
>>>>>> As pointed out by Ferry this breaks Dual Role support on
>>>>>> Intel Merrifield platforms.
>>>>> Can you provide more info than this (any debug info/description)? It
>>>>> will be difficult to come back to fix with just this to go on. The
>>>>> reverted patch was needed to fix a different issue.
>>> On Merrifield we have a switch with extcon driver to switch between host and
>>> device mode. Now with commit 0f01017, device mode works. In host mode the
>>> root hub appears, but no devices appear. In the logs there are no messages
>>> from tusb1210, but there should be because lately there normally are
>>> (harmless) error messages. Nothing in the logs point in the direction of
>>> tusb1210 not being probed.
>>>
>>> The discussion is here:https://urldefense.com/v3/__https://lkml.org/lkml/2022/9/24/237__;!!A4F2R9G_pg!avfDjiGwi8xu0grHYrQQTZEEUnmaKu82xxdty0ZltxyU8BkoFD6AMq4a-7STYiKxNQpdYXgP1QG_IZbroEM$
>>>
>>> I tried moving some code as suggested without result:https://urldefense.com/v3/__https://lkml.org/lkml/2022/9/24/434__;!!A4F2R9G_pg!avfDjiGwi8xu0grHYrQQTZEEUnmaKu82xxdty0ZltxyU8BkoFD6AMq4a-7STYiKxNQpdYXgP1QG_boaK8Qw$
>>>
>>> And with success:https://urldefense.com/v3/__https://lkml.org/lkml/2022/9/25/285__;!!A4F2R9G_pg!avfDjiGwi8xu0grHYrQQTZEEUnmaKu82xxdty0ZltxyU8BkoFD6AMq4a-7STYiKxNQpdYXgP1QG_MbbbZII$
>>>
>>> So, as Andrey Smirnov writes "I think we'd want to figure out why the
>>> ordering is important if we want to justify the above fix."
>>>
>>>> It's already applied, but Ferry probably can provide more info if you describe
>>>> step-by-step instructions. (I'm still unable to test this particular type of
>>>> features since remove access is always in host mode.)
>>>>
>>> I'd be happy to test.
>> Thanks!
>>
>> Does the failure only happen the first time host is initialized? Or can
>> it recover after switching to device then back to host mode?
>>
>> Probably the failure happens if some step(s) in dwc3_core_init() hasn't
>> completed.
>>
>> tusb1210 is a phy driver right? The issue is probably because we didn't
>> initialize the phy yet. So, I suspect placing dwc3_get_extcon() after
>> initializing the phy will probably solve the dependency problem.
>>
>> You can try something for yourself or I can provide something to test
>> later if you don't mind (maybe next week if it's ok).
> FWIW, I just got the same HW Ferry has last week and am planning to
> work on this over the weekend.
I can help you setup, we have binary images available on github as well 
as Yocto recipies to build them.
