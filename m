Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348C45614A1
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiF3IQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 04:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiF3IQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 04:16:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D74543AC3;
        Thu, 30 Jun 2022 01:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656576768; x=1688112768;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=wxEA/uVAqJQvtCxzPctMKgmGZGDpbP+frW55pMt+y00=;
  b=ZgWINTlavdrEkoKerpbaY8ETL4I11+CFzXm7n1lT0jahJ8VWNcRzxGtz
   3mfdIPCP3k+Ud4OffZ2jRLT+Dz0WNqi7y4HhRgpVYpWvAfYpjT6D063uP
   G7E//vjlfK7Tr0vF6HgWGVpctWQ1KkDWeXKwJIEFOfy3EH59ECx3YDILG
   SZGNn3EZBwUAfUoqY3+f0KlF6Q2YnhQPZKnzpQ6+mL/Mp5ScrGV4R/qd8
   +AdmHHYgnLXYQ9WoOlu6eAByURtKsT5PaIuWrXdcMvLiEbeJFRxypC4zT
   qbMQMIIwbBrzv8vqAvwCyLyONt7OMOe2X/UQVw4MJbdcs4O/86aJQqZvv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="307786398"
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="gz'50?scan'50,208,49,50,223";a="307786398"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 01:12:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="gz'50?scan'50,208,49,50,223";a="837507771"
Received: from hanj1-mobl1.ccr.corp.intel.com (HELO [10.213.202.230]) ([10.213.202.230])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 01:12:43 -0700
Content-Type: multipart/mixed; boundary="------------dyTIjYH5NtKqsvq5qbqdpxjr"
Message-ID: <9477a8f1-3535-ed7f-c491-9ca9f27a10dc@linux.intel.com>
Date:   Thu, 30 Jun 2022 09:12:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between multiple
 engine resets
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Fei Yang <fei.yang@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        John Harrison <John.C.Harrison@intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
 <YrRLyg1IJoZpVGfg@intel.intel>
 <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
 <20220627110056.6dfa4f9b@maurocar-mobl2>
 <d79492ad-b99a-f9a9-f64a-52b94db68a3b@linux.intel.com>
 <20220629172955.64ffb5c3@maurocar-mobl2>
 <7e6a9a27-7286-7f21-7fec-b9832b93b10c@linux.intel.com>
 <20220630083256.35a56cb1@sal.lan>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220630083256.35a56cb1@sal.lan>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------dyTIjYH5NtKqsvq5qbqdpxjr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 30/06/2022 08:32, Mauro Carvalho Chehab wrote:
> Em Wed, 29 Jun 2022 17:02:59 +0100
> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> escreveu:
> 
>> On 29/06/2022 16:30, Mauro Carvalho Chehab wrote:
>>> On Tue, 28 Jun 2022 16:49:23 +0100
>>> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
>>>    
>>>> .. which for me means a different patch 1, followed by patch 6 (moved
>>>> to be patch 2) would be ideal stable material.
>>>>
>>>> Then we have the current patch 2 which is open/unknown (to me at least).
>>>>
>>>> And the rest seem like optimisations which shouldn't be tagged as fixes.
>>>>
>>>> Apart from patch 5 which should be cc: stable, but no fixes as agreed.
>>>>
>>>> Could you please double check if what I am suggesting here is feasible
>>>> to implement and if it is just send those minimal patches out alone?
>>>
>>> Tested and porting just those 3 patches are enough to fix the Broadwell
>>> bug.
>>>
>>> So, I submitted a v2 of this series with just those. They all need to
>>> be backported to stable.
>>
>> I would really like to give even a smaller fix a try. Something like, although not even compile tested:
>>
>> commit 4d5e94aef164772f4d85b3b4c1a46eac9a2bd680
>> Author: Chris Wilson <chris.p.wilson@intel.com>
>> Date:   Wed Jun 29 16:25:24 2022 +0100
>>
>>       drm/i915/gt: Serialize TLB invalidates with GT resets
>>       
>>       Avoid trying to invalidate the TLB in the middle of performing an
>>       engine reset, as this may result in the reset timing out. Currently,
>>       the TLB invalidate is only serialised by its own mutex, forgoing the
>>       uncore lock, but we can take the uncore->lock as well to serialise
>>       the mmio access, thereby serialising with the GDRST.
>>       
>>       Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
>>       i915 selftest/hangcheck.
>>       
>>       Cc: stable@vger.kernel.org
>>       Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
>>       Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
>>       Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
>>       Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
>>       Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
>>       Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>>       Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>>       Reviewed-by: Andi Shyti <andi.shyti@intel.com>
>>       Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
>>       Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>
>> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
>> index 8da3314bb6bf..aaadd0b02043 100644
>> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
>> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
>> @@ -952,7 +952,23 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>>           mutex_lock(&gt->tlb_invalidate_lock);
>>           intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
>>    
>> +       spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
>> +
>> +       for_each_engine(engine, gt, id) {
>> +               struct reg_and_bit rb;
>> +
>> +               rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
>> +               if (!i915_mmio_reg_offset(rb.reg))
>> +                       continue;
>> +
>> +               intel_uncore_write_fw(uncore, rb.reg, rb.bit);
>> +       }
>> +
>> +       spin_unlock_irq(&uncore->lock);
>> +
>>           for_each_engine(engine, gt, id) {
>> +               struct reg_and_bit rb;
>> +
>>                   /*
>>                    * HW architecture suggest typical invalidation time at 40us,
>>                    * with pessimistic cases up to 100us and a recommendation to
>> @@ -960,13 +976,11 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>>                    */
>>                   const unsigned int timeout_us = 100;
>>                   const unsigned int timeout_ms = 4;
>> -               struct reg_and_bit rb;
>>    
>>                   rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
>>                   if (!i915_mmio_reg_offset(rb.reg))
>>                           continue;
>>    
>> -               intel_uncore_write_fw(uncore, rb.reg, rb.bit);
>>                   if (__intel_wait_for_register_fw(uncore,
>>                                                    rb.reg, rb.bit, 0,
>>                                                    timeout_us, timeout_ms,
>>
> 
> This won't work, as it is not serializing TLB cache invalidation with
> i915 resets. Besides that, this is more or less merging patches 1 and 3,

Could you explain why you think it is not doing exactly that? In both 
versions end result is TLB flush requests are under the uncore lock and 
waits are outside it.

> placing patches with different rationales altogether. Upstream rule is
> to have one logical change per patch.

I don't think it applies in this case. It is simply splitting into two 
loops so lock can be held across all mmio writes. I think of it this way 
- what is the rationale for sending only the first patch to stable? What 
does it _fix_ on it's own?

>> If this works it would be least painful to backport. The other improvements can then be devoid of the fixes tag.
> 
>  From backport PoV, it wouldn't make any difference applying one patch
> or two. See, intel_gt_invalidate_tlbs() function doesn't exist before
> changeset 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store"),
> so, it shouldn't have merge conflicts while backporting it, maybe except
> if some functions it calls (or parameters) have changed. On such case,
> the backport fix should be trivial, and the end result of backporting
> one folded patch or two would be the same.

Yes a lot of things changed. Not least engine and GT pm code. Note that 
TLB flushing was backported all the way to 4.4 so any hunk you don't 
strictly need can and will bite you. I have attached a tarball of 
patches for you to explore. :)
Regards,

Tvrtko

> If any conflict happens, I can help doing the backports.
> 
>>> I still think that other TLB patches are needed/desired upstream, but
>>> I'll submit them on a separate series. Let's fix the regression first ;-)
>>
>> Yep, that's exactly right.
>>
>> Regards,
>>
>> Tvrtko
--------------dyTIjYH5NtKqsvq5qbqdpxjr
Content-Type: application/gzip; name="tlbflush-220114-patches.tar.gz"
Content-Disposition: attachment; filename="tlbflush-220114-patches.tar.gz"
Content-Transfer-Encoding: base64

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
CBAgQIAAAQIECBAgQIAA4eaH/wefDdWqALgBAA==

--------------dyTIjYH5NtKqsvq5qbqdpxjr--
