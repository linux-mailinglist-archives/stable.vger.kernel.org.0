Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294C8583BCD
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 12:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiG1KLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiG1KLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 06:11:34 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B6E3AE7B;
        Thu, 28 Jul 2022 03:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659003093; x=1690539093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=abgk3vUpAQZd9qPd9c0j2BN6XVDXH3lIfe2uKYnCea4=;
  b=LDFfJBBCTea7L182ShLL2FDdPtGnr12+c1YqwgbbcLj8IQ7YsPGUUDxV
   0h6Ueh5vunlLVHMfeFxNvinySfaXItfP+68op/kDDyfEVe9iG02+GrA0G
   Mh/U2S0SSWnmDD0pmGmFQTBhz3ljn7vnHBuwUmOy91v/I6bpwZ45lpUgG
   ws8dsVtk8khxDCOLf16liqhtcwdd077UbhZE4TbgUYY2D/I3YVFFz3wor
   KTFWzq5MTtOYnbbMjTL6f3drLsT+PMuY0QWz/C4KfwlUS6y2M/RbSwr/J
   fLFDlsF/ElYDsm5zvTHXZeSORmwpziHH86Y3ktfLNW/wKYOdyzTdLCWm7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="314263779"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="314263779"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 03:11:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="633603135"
Received: from niviojax-mobl2.ger.corp.intel.com (HELO [10.213.204.129]) ([10.213.204.129])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 03:11:29 -0700
Message-ID: <a5605b3a-173d-d4a4-fccf-7cf6ba559913@linux.intel.com>
Date:   Thu, 28 Jul 2022 11:11:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Intel-gfx] [PATCH v2 06/21] drm/i915/gt: Batch TLB invalidations
Content-Language: en-US
To:     Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
Cc:     stable@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>, linux-media@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linaro-mm-sig@lists.linaro.org,
        Chris Wilson <chris.p.wilson@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Matthew Auld <matthew.auld@intel.com>
References: <cover.1657800199.git.mchehab@kernel.org>
 <9f535a97f32320a213a619a30c961ba44b595453.1657800199.git.mchehab@kernel.org>
 <567823d5-57ba-30db-dd64-de609df4d8c5@linux.intel.com>
 <20220727134836.7f7b5fab@maurocar-mobl2>
 <d2337b73-ae34-3dd3-afa3-85c77dc2135e@linux.intel.com>
 <20220728083232.352f80cf@maurocar-mobl2>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220728083232.352f80cf@maurocar-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/07/2022 07:32, Mauro Carvalho Chehab wrote:
> On Wed, 27 Jul 2022 13:56:50 +0100
> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> 
>>> Because vma_invalidate_tlb() basically stores a TLB seqno, but the
>>> actual invalidation is deferred to when the pages are unset, at
>>> __i915_gem_object_unset_pages().
>>>
>>> So, what happens is:
>>>
>>> - on VMA sync mode, the need to invalidate TLB is marked at
>>>     __vma_put_pages(), before VMA unbind;
>>> - on async, this is deferred to happen at ppgtt_unbind_vma(), where
>>>     it marks the need to invalidate TLBs.
>>>
>>> On both cases, __i915_gem_object_unset_pages() is called later,
>>> when the driver is ready to unmap the page.
>>
>> Sorry still not clear to me why is the patch moving marking of the need
>> to invalidate (regardless if it a bit like today, or a seqno like in
>> this patch) from bind to unbind?
>>
>> What if the seqno was stored in i915_vma_bind, where the bit is set
>> today, and all the hunks which touch the unbind and evict would
>> disappear from the patch. What wouldn't work in that case, if anything?
> 
> Ah, now I see your point.
> 
> I can't see any sense on having a sequence number at VMA bind, as the
> unbind order can be different. The need of doing a full TLB invalidation
> or not depends on the unbind order.

Sorry yes that was stupid from me.. What I was really thinking was the 
approach I initially used for coalescing. Keeping the set_bit in bind 
and then once the code enters intel_gt_invalidate_tlbs, takes a "ticket" 
and waits on the mutex. Once it gets the mutex checks the ticket against 
the GT copy and if two invalidations have passed since it was waiting on 
the mutex it can immediately exit. That would seem like a minimal 
improvement to batch things up.

But I guess it would still emit needless invalidations if there is no 
contention, just a stream of serialized put pages. While the approach 
from this patch can skip all but truly required.

Okay, go for it and thanks for the explanations.

Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko

P.S. The last remaining "ugliness" is the 2nd call to invalidation from 
evict. It would be nicer if there was a single common place to do it on 
vma unbind but okay, I do not plan to dig into it so fine.

> 
> The way the current algorithm works is that drm_i915_gem_object can be
> created on any order, and, at unbind/evict, they receive a seqno.
> 
> The seqno is incremented at intel_gt_invalidate_tlb():
> 
>      void intel_gt_invalidate_tlb(struct intel_gt *gt, u32 seqno)
>      {
> 	with_intel_gt_pm_if_awake(gt, wakeref) {
> 		mutex_lock(&gt->tlb.invalidate_lock);
> 		if (tlb_seqno_passed(gt, seqno))
> 				goto unlock;
> 
> 		mmio_invalidate_full(gt);
> 
> 		write_seqcount_invalidate(&gt->tlb.seqno);	// increment seqno
> 		
> 
> So, let's say 3 objects were created, on this order:
> 
> 	obj1
> 	obj2
> 	obj3
> 
> They would be unbind/evict on a different order. On that time,
> the mm.tlb will be stamped with a seqno, using the number from the
> last TLB flush, plus 1.
> 
> As different threads can be used to handle TLB flushes, let's imagine
> two threads (just for the sake of having an example). On such case,
> what we would have is:
> 
> seqno		Thread 0			Thread 1
> 
> seqno=2		unbind/evict event
> 		obj3.mm.tlb = seqno | 1
> seqno=2		unbind/evict event
> 		obj1.mm.tlb = seqno | 1
> 						__i915_gem_object_unset_pages()
> 						called for obj3, TLB flush happened,
> 						invalidating both obj1 and obj2.
> 						seqno += 2					
> seqno=4		unbind/evict event
> 		obj1.mm.tlb = seqno | 1
> 						__i915_gem_object_unset_pages()
> 						called for obj1, don't flush.
> ...
> 						__i915_gem_object_unset_pages() called for obj2, TLB flush happened
> 						seqno += 2
> seqno=6
> 
> So, basically the seqno is used to track when the object data stopped
> being updated, because of an unbind/evict event, being later used by
> intel_gt_invalidate_tlb() when called from __i915_gem_object_unset_pages(),
> in order to check if a previous invalidation call was enough to invalidate
> the object, or if a new call is needed.
> 
> Now, if seqno is stored at bind, data can still leak, as the assumption
> made by intel_gt_invalidate_tlb() that the data stopped being used at
> seqno is not true anymore.
> 
> Still, I agree that this logic is complex and should be better
> documented. So, if you're now OK with this patch, I'll add the above
> explanation inside a kernel-doc comment.
> 
> Regards,
> Mauro
