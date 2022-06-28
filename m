Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FAD55E8B1
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347136AbiF1Ptd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 11:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346643AbiF1Ptc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 11:49:32 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ECB2315B;
        Tue, 28 Jun 2022 08:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656431370; x=1687967370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gr/uxZdIp9ZY5+9GxWfp/6OkkcLAEwf6JeNxclzyWC4=;
  b=nmAres3MIaqNOtKMIwmtL1+UkWuZ3E19IA9NwtgMVra5LHRg+dgohQ00
   o+xC30DRyUz4C/dyxZY0rJGg006fnCimpCiLoZwTh4xgyKD3f5XEsT8IQ
   TFM/iC/b7lmQOEEt9eF0Ycg6QVzaaBYGMXbgixa47Or/HxEQNYvUbsprF
   3X4G4G+Hwb+vSEbfJpQcFg5L7mRlrmluZg4t/hEJuYRBwd2SyTF48HprK
   yl5HtV1c0AREfzGMEf0W2iue5ks0G3i5nO1idp3Al/lQnKmAcRUCxsbk4
   Fqmy2FWdIOHxn4J2ktcuUKpzGKC6tthRbUVQpHU98sgPvWok3P4HaK4Pz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343467600"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343467600"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 08:49:30 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="587911424"
Received: from leejust1-mobl.amr.corp.intel.com (HELO [10.209.162.132]) ([10.209.162.132])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 08:49:25 -0700
Message-ID: <d79492ad-b99a-f9a9-f64a-52b94db68a3b@linux.intel.com>
Date:   Tue, 28 Jun 2022 16:49:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between multiple
 engine resets
Content-Language: en-US
To:     "Mauro Carvalho Chehab (by way of Mauro Carvalho Chehab" 
        <mauro.chehab@linux.intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
 <YrRLyg1IJoZpVGfg@intel.intel>
 <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
 <20220627110056.6dfa4f9b@maurocar-mobl2>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220627110056.6dfa4f9b@maurocar-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

On 27/06/2022 10:00, Mauro Carvalho Chehab (by way of Mauro Carvalho 
Chehab <mauro.chehab@linux.intel.com>) wrote:
> Hi Tvrtko,
> 
> On Fri, 24 Jun 2022 09:34:21 +0100
> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> 
>> On 23/06/2022 12:17, Andi Shyti wrote:
>>> Hi Mauro,
>>>
>>> On Wed, Jun 15, 2022 at 04:27:39PM +0100, Mauro Carvalho Chehab wrote:
>>>> From: Chris Wilson <chris.p.wilson@intel.com>
>>>>
>>>> Don't allow two engines to be reset in parallel, as they would both
>>>> try to select a reset bit (and send requests to common registers)
>>>> and wait on that register, at the same time. Serialize control of
>>>> the reset requests/acks using the uncore->lock, which will also ensure
>>>> that no other GT state changes at the same time as the actual reset.
>>>>
>>>> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
>>>>
>>>> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
>>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>>> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
>>>> Cc: Andi Shyti <andi.shyti@intel.com>
>>>> Cc: stable@vger.kernel.org
>>>> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
>>>
>>> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
>>
>> Notice I had a bunch of questions and asks in this series so please do
>> not merge until those are addressed.
>>
>> In this particular patch (and some others) for instance Fixes: tag, at
>> least against that sha, shouldn't be there.
> 
> Hmm... I sent an answer to your points, but I can't see it at:
> 
> 	https://lore.kernel.org/all/160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com/
> 
> Maybe it got lost somewhere, I dunno.

Yeah, no replies received on my end I'm afraid.

> 
> Yeah, indeed the fixes tag on patch 5/6 should be removed as this is not
> directly related to changeset 7938d61591d3. Yet, this one is required for
> patch 6 to work.
> 
> The other patches on this series, though, are modifying the code
> introduced by changeset 7938d61591d3.

Modifying the code does not strictly means something is a fix for a 
certain patch.

> Patch 2 is clearly a workaround needed for TLB cache invalidation to
> work on some GPUs. So, while not related to Broadwell, they're also
> fixing some TLB cache issues. So, IMO, it should keep the fixes.

Umesh commented that patch 2 is not needed - who is right then? :)

> I tried to port just the two serialize patches to drm-tip, in order
> to solve the issues on Broadwell, but it didn't work, as the logic
> inside the spinlock could be calling schedule() with a spinlock hold:
>   
> 	Jun 14 17:38:48 silver kernel: [   23.227813] BUG: sleeping function called from invalid context at drivers/gpu/drm/i915/intel_uncore.c:2496
> 	Jun 14 17:38:48 silver kernel: [   23.227816] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 37, name: kworker/u8:1
> 	Jun 14 17:38:48 silver kernel: [   23.227818] preempt_count: 1, expected: 0
> 	Jun 14 17:38:48 silver kernel: [   23.227819] RCU nest depth: 0, expected: 0
> 	Jun 14 17:38:48 silver kernel: [   23.227820] 5 locks held by kworker/u8:1/37:
> 	Jun 14 17:38:48 silver kernel: [   23.227822]  #0: ffff88811159b538 ((wq_completion)i915){+.+.}-{0:0}, at: process_one_work+0x1e0/0x580
> 	Jun 14 17:38:48 silver kernel: [   23.227831]  #1: ffffc90000183e60 ((work_completion)(&(&i915->mm.free_work)->work)){+.+.}-{0:0}, at: process_one_work+0x1e0/0x580
> 	Jun 14 17:38:48 silver kernel: [   23.227837]  #2: ffff88811b34c5e8 (reservation_ww_class_mutex){+.+.}-{3:3}, at: __i915_gem_free_objects+0xba/0x210 [i915]
> 	Jun 14 17:38:48 silver kernel: [   23.228283]  #3: ffff88810a66c2d8 (&gt->tlb_invalidate_lock){+.+.}-{3:3}, at: intel_gt_invalidate_tlbs+0xe7/0x4d0 [i915]
> 	Jun 14 17:38:48 silver kernel: [   23.228663]  #4: ffff88810a668f28 (&uncore->lock){-.-.}-{2:2}, at: intel_gt_invalidate_tlbs+0x115/0x4d0 [i915]
> 
> I didn't investigate the root cause, but it seems related to PM, so
> patches 1 and 3 seem to be required for the serialization logic
> to actually work.

Yes that is clear, what is needed is the split of the for_each_engine 
loop into request and wait.

But question is how much backporting trouble will the _extra_ changes 
patch 1 brings create.

In the ideal world patch 1 wouldn't be an optimising one, I mean adding 
skipping of TLB invalidations on idle engines but just the loop split. 
That would make it smaller and more suitable for Cc: stable. Because 
both i915_gem_pages.c and intel_gt_pm.h hunks wouldn't even be there. 
And the refactor in intel_gt_invalidate_tlbs would be smaller since it 
wouldn't be adding the engine awake checks...

> So, I would keep the Fixes: tag mentioning changeset 7938d61591d3
> on patches: 1, 2, 3 and 6.

... which for me means a different patch 1, followed by patch 6 (moved 
to be patch 2) would be ideal stable material.

Then we have the current patch 2 which is open/unknown (to me at least).

And the rest seem like optimisations which shouldn't be tagged as fixes.

Apart from patch 5 which should be cc: stable, but no fixes as agreed.

Could you please double check if what I am suggesting here is feasible 
to implement and if it is just send those minimal patches out alone?

Maybe it even makes sense to squash such 1&2 into a single patch.

Again, since the original TLB flush was backported quite far back into 
long term stable releases I think it would be much easier to really have 
a minimal patch/series to fix Broadwell in those kernels.

Regards,

Tvrtko

> 
> Yet, IMO the entire series should be merged on -stable.
> 
> If that's OK for you and there's no additional issues to be
> addressed, I'll submit a v2 of this series removing the Fixes tag
> from patches 4 and 5.
> 
> Regards,
> Mauro
