Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC3F58272D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 14:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiG0M46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 08:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiG0M45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 08:56:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB622BB2F;
        Wed, 27 Jul 2022 05:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658926616; x=1690462616;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZZz/K3MC/VTWwgoscj+ukc/J2fLhkf7sdFzroIufZjI=;
  b=NYf9rincFkxFuBZzdxtcV69CILt9Y5j8aYTNDkdKAyJUk2m5Sm7E/jlC
   HB12Hwc0se0SISi2jEyiYQQtyBLYRpf5f+OOlrMeDBFt/C+/N44MZpfJQ
   eKv5sg6iyhv1h1JPoVEGykbRJXUt9nf3pXmb6fUwJmFSCbB4NwI0mC66W
   /V6wvCyWNnNmkmlLJPcH4+bAaaWz9zYupx/ydSYhgKGeFoFQAbfagXebw
   ZbGSa87HlWw/2pQewMMb/9ff5kLCh5H5w6DT63JTGvaWUdnO8aFWc8n7g
   rm8XP9sLS37KG3pGQloP/pHbdfzxZoA0dR2tTJSmM/hpEG5wVtX1DvN8C
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="271264048"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="271264048"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 05:56:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="927778582"
Received: from ncouniha-mobl.ger.corp.intel.com (HELO [10.213.217.229]) ([10.213.217.229])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 05:56:52 -0700
Message-ID: <d2337b73-ae34-3dd3-afa3-85c77dc2135e@linux.intel.com>
Date:   Wed, 27 Jul 2022 13:56:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Intel-gfx] [PATCH v2 06/21] drm/i915/gt: Batch TLB invalidations
Content-Language: en-US
To:     Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        intel-gfx@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-media@vger.kernel.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <cover.1657800199.git.mchehab@kernel.org>
 <9f535a97f32320a213a619a30c961ba44b595453.1657800199.git.mchehab@kernel.org>
 <567823d5-57ba-30db-dd64-de609df4d8c5@linux.intel.com>
 <20220727134836.7f7b5fab@maurocar-mobl2>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220727134836.7f7b5fab@maurocar-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/07/2022 12:48, Mauro Carvalho Chehab wrote:
> On Wed, 20 Jul 2022 11:49:59 +0100
> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> 
>> On 20/07/2022 08:13, Mauro Carvalho Chehab wrote:
>>> On Mon, 18 Jul 2022 14:52:05 +0100
>>> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
>>>    
>>>>
>>>> On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:
>>>>> From: Chris Wilson <chris.p.wilson@intel.com>
>>>>>
>>>>> Invalidate TLB in patch, in order to reduce performance regressions.
>>>>
>>>> "in batches"?
>>>
>>> Yeah. Will fix it.
> 
>>> +void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb)
>>> +{
>>> +	/*
>>> +	 * Before we release the pages that were bound by this vma, we
>>> +	 * must invalidate all the TLBs that may still have a reference
>>> +	 * back to our physical address. It only needs to be done once,
>>> +	 * so after updating the PTE to point away from the pages, record
>>> +	 * the most recent TLB invalidation seqno, and if we have not yet
>>> +	 * flushed the TLBs upon release, perform a full invalidation.
>>> +	 */
>>> +	WRITE_ONCE(tlb, intel_gt_next_invalidate_tlb_full(vm->gt));
>>
>> Shouldn't tlb be a pointer for this to make sense?
> 
> Oh, my mistake! Will fix at the next version.
> 
>>>    
>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_ppgtt.c b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
>>>>> index d8b94d638559..2da6c82a8bd2 100644
>>>>> --- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
>>>>> @@ -206,8 +206,12 @@ void ppgtt_bind_vma(struct i915_address_space *vm,
>>>>>     void ppgtt_unbind_vma(struct i915_address_space *vm,
>>>>>     		      struct i915_vma_resource *vma_res)
>>>>>     {
>>>>> -	if (vma_res->allocated)
>>>>> -		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
>>>>> +	if (!vma_res->allocated)
>>>>> +		return;
>>>>> +
>>>>> +	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
>>>>> +	if (vma_res->tlb)
>>>>> +		vma_invalidate_tlb(vm, *vma_res->tlb);
>>>>
>>>> The patch is about more than batching? If there is a security hole in
>>>> this area (unbind) with the current code?
>>>
>>> No, I don't think there's a security hole. The rationale for this is
>>> not due to it.
>>
>> In this case obvious question is why are these changes in the patch
>> which declares itself to be about batching invalidations? Because...
> 
> Because vma_invalidate_tlb() basically stores a TLB seqno, but the
> actual invalidation is deferred to when the pages are unset, at
> __i915_gem_object_unset_pages().
> 
> So, what happens is:
> 
> - on VMA sync mode, the need to invalidate TLB is marked at
>    __vma_put_pages(), before VMA unbind;
> - on async, this is deferred to happen at ppgtt_unbind_vma(), where
>    it marks the need to invalidate TLBs.
> 
> On both cases, __i915_gem_object_unset_pages() is called later,
> when the driver is ready to unmap the page.

Sorry still not clear to me why is the patch moving marking of the need 
to invalidate (regardless if it a bit like today, or a seqno like in 
this patch) from bind to unbind?

What if the seqno was stored in i915_vma_bind, where the bit is set 
today, and all the hunks which touch the unbind and evict would 
disappear from the patch. What wouldn't work in that case, if anything?

Regards,

Tvrtko

> 
>> I am explaining why it looks to me that the patch is doing two things.
>> Implementing batching _and_ adding invalidation points at VMA unbind
>> sites, while so far we had it at backing store release only. Maybe I am
>> wrong and perhaps I am too slow to pick up on the explanation here.
>>
>> So if the patch is doing two things please split it up.
>>
>> I am further confused by the invalidation call site in evict and in
>> unbind - why there can't be one logical site since the logical sequence
>> is evict -> unbind.
> 
> The invalidation happens only on one place: __i915_gem_object_unset_pages().
> 
> Despite its name, vma_invalidate_tlb() just marks the need of doing TLB
> invalidation.
> 
> Regards,
> Mauro
