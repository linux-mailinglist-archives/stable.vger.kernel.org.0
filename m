Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2812F5FAF70
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 11:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJKJgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 05:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJKJgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 05:36:42 -0400
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C90D8B2F1;
        Tue, 11 Oct 2022 02:36:35 -0700 (PDT)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 614E62407C;
        Tue, 11 Oct 2022 11:36:34 +0200 (CEST)
Message-ID: <ceac55a0-ad71-c6cc-8a7d-38bd11d7f5e2@gmail.com>
Date:   Tue, 11 Oct 2022 11:36:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
From:   Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <Y0PFZGLaREQUazVP@smile.fi.intel.com>
 <CAHQ1cqG73UAoU=ag9qSuKdp+MzT9gYJcwGv8k8BOa=e8gWwzSg@mail.gmail.com>
 <Y0U1j2LXmGLBYLAV@smile.fi.intel.com>
Content-Language: en-US
In-Reply-To: <Y0U1j2LXmGLBYLAV@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 11-10-2022 11:21, Andy Shevchenko wrote:
> On Mon, Oct 10, 2022 at 02:40:30PM -0700, Andrey Smirnov wrote:
>> On Mon, Oct 10, 2022 at 12:13 AM Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com>  wrote:
>>> On Sun, Oct 09, 2022 at 10:02:26PM -0700, Andrey Smirnov wrote:
>>>> On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth<fntoth@gmail.com>  wrote:
> ...
>
>>>> OK, Ferry, I think I'm going to need clarification on specifics on
>>>> your test setup. Can you share your kernel config, maybe your
>>>> "/proc/config.gz", somewhere? When you say you are running vanilla
>>>> Linux, do you mean it or do you mean vanilla tree + some patch delta?
>>>>
>>>> The reason I'm asking is because I'm having a hard time reproducing
>>>> the problem on my end. In fact, when I build v6.0
>>>> (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
>>>>
>>>> git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
>>>>
>>>> I get an infinite loop of reprobing that looks something like (some
>>>> debug tracing, function name + line number, included):
>>> Yes, this is (one of) known drawback(s) of deferred probe hack. I think
>>> the kernel that Ferry runs has a patch that basically reverts one from
>>> 2014 [1] and allows to have extcon as a module. (1)
>>>
>>> [1]: 58b116bce136 ("drivercore: deferral race condition fix")
>>>
>>>> which renders the system completely unusable, but USB host is
>>>> definitely going to be broken too. Now, ironically, with my patch
>>>> in-place, an attempt to probe extcon that ends up deferring the probe
>>>> happens before the ULPI driver failure (which wasn't failing driver
>>>> probe prior tohttps://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
>>>> there no "driver binding" event that re-triggers deferred probe
>>>> causing the loop, so the system progresses to a point where extcon is
>>>> available and dwc3 driver eventually loads.
>>>>
>>>> After that, and I don't know if I'm doing the same test, USB host
>>>> seems to work as expected. lsusb works, my USB stick enumerates as
>>>> expected. Switching the USB mux to micro-USB and back shuts the host
>>>> functionality down and brings it up as expected. Now I didn't try to
>>>> load any gadgets to make sure USB gadget works 100%, but since you
>>>> were saying it was USB host that was broken, I wasn't concerned with
>>>> that. Am I doing the right test?
>>> Hmm... What you described above sounds more like a yet another attempt to
>>> workaround (1). _If_ this is the case, we probably can discuss how to fix
>>> it in generic way (somewhere in dd.c, rather than in the certain driver).
>> No, I'm not describing an attempt to fix anything. Just how vanilla
>> v6.0 (where my patch is not reverted) works and where my patch, fixing
>> a logical problem in which extcon was requested too late causing a
>> forced OTG -> "gadget only" switch, also changed the ordering enough
>> to accidentally avoid the loop.
> You still refer to a fix, but my question was if it's the same problem or not.
>
>>> That said, the real test case should be performed on top of clean kernel
>>> before judging if it's good or bad.
>> Given your level of involvemnt with this particular platform and you
>> being the author of
>> https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
>> I assumed/expected you to double check this before sending this revert
>> out. Please do so next time.
> As I said I have not yet restored my testing environment for that platform and
> I relied on the Ferry's report. Taking into account the history of breakages
> that done for Intel Merrifield, in particular by not wide tested patches
> against DWC3 driver, I immediately react with a revert. I agree that I had had
> to think about that ordering issue and a patch on top of it first. I thought
> that Yocto configuration that Ferry is using is clean of custom (controversial)
> patches like that. Now, since you have this platform, you can also help with
> testing the DWC3 on it.
>
It's my fault I'm afraid. My apologies. We have been needing the "Break 
infinite loop" patch at least since v5.10. Without IIRC we can not even 
boot normally or at least we have no dwc3. No way to bisect. In my mind 
I didn't  link that patch to this issue. Other patches were indeed 
removed during bisecting.

But it is interesting that we should be able to drop that patch for 
v6.0, even if that is a side effect. I will try to reproduce and report 
back here.

