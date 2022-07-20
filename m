Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7979457B4BF
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiGTKuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiGTKuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 06:50:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCD51B783;
        Wed, 20 Jul 2022 03:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658314215; x=1689850215;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eg1H8HXl4bo5sbqv6QtUBh6VCLBJoEPGZh2Ov9xgfkE=;
  b=Snetx5rZhbN3ktjGfihdKgSB8m1fITtWDAAz4RLHHx1DzU0I1CpyEXEx
   Bs8LU38X0y2xVTuKeXKCKTPbafJarg0pOzh+1wUUWDH2XupyWnNHtPTtF
   7WgJogVp+QYdX10kLLHYmPXDKYdH5LnOEJteg5wXTtWjmrK7pd3DDRxxP
   dRpbjmea0x94DRWotADA4CewrZAoaPnztKlXISnfuOQl28LTxUEFf0G2f
   fz0hg+B6wqvVHMzWQ9Ow1RPadK3FE4gJ78u9/2qT0Ypi3Nk0hBoj1lSr8
   Cpt6eIRMiHIjIMbucXqBa6zXAK2vA/WoTuG42xvNJVBwtQfvjdbndU/FR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="286753524"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="286753524"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 03:50:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="630727631"
Received: from spmccann-mobl.ger.corp.intel.com (HELO [10.213.200.99]) ([10.213.200.99])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 03:50:00 -0700
Message-ID: <6b064764-6d4c-bbbb-f8b0-8a125a59a4a0@linux.intel.com>
Date:   Wed, 20 Jul 2022 11:49:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
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
 <605ab738-42df-c8fe-efb3-654d5792d3cc@linux.intel.com>
 <20220720091304.14b5186b@maurocar-mobl2>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220720091304.14b5186b@maurocar-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/07/2022 08:13, Mauro Carvalho Chehab wrote:
> On Mon, 18 Jul 2022 14:52:05 +0100
> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> 
>>
>> On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:
>>> From: Chris Wilson <chris.p.wilson@intel.com>
>>>
>>> Invalidate TLB in patch, in order to reduce performance regressions.
>>
>> "in batches"?
> 
> Yeah. Will fix it.
> 
>>> diff --git a/drivers/gpu/drm/i915/gt/intel_ppgtt.c b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
>>> index d8b94d638559..2da6c82a8bd2 100644
>>> --- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
>>> +++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
>>> @@ -206,8 +206,12 @@ void ppgtt_bind_vma(struct i915_address_space *vm,
>>>    void ppgtt_unbind_vma(struct i915_address_space *vm,
>>>    		      struct i915_vma_resource *vma_res)
>>>    {
>>> -	if (vma_res->allocated)
>>> -		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
>>> +	if (!vma_res->allocated)
>>> +		return;
>>> +
>>> +	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
>>> +	if (vma_res->tlb)
>>> +		vma_invalidate_tlb(vm, *vma_res->tlb);
>>
>> The patch is about more than batching? If there is a security hole in
>> this area (unbind) with the current code?
> 
> No, I don't think there's a security hole. The rationale for this is
> not due to it.

In this case obvious question is why are these changes in the patch 
which declares itself to be about batching invalidations? Because...

> Since commit 2f6b90da9192 ("drm/i915: Use vma resources for async unbinding"),
> VMA unbind can happen either sync or async.
> 
> So, the logic needs to do TLB invalidate on two places. After this
> patch, the code at __i915_vma_evict is:
> 
> 	struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async)
> 	{
> ...
> 		if (async)
> 			unbind_fence = i915_vma_resource_unbind(vma_res,
> 								&vma->obj->mm.tlb);
> 		else
> 			unbind_fence = i915_vma_resource_unbind(vma_res, NULL);
> 
> 		vma->resource = NULL;
> 
> 		atomic_and(~(I915_VMA_BIND_MASK | I915_VMA_ERROR | I915_VMA_GGTT_WRITE),
> 			   &vma->flags);
> 
> 		i915_vma_detach(vma);
> 
> 		if (!async) {
> 			if (unbind_fence) {
> 				dma_fence_wait(unbind_fence, false);
> 				dma_fence_put(unbind_fence);
> 				unbind_fence = NULL;
> 			}
> 			vma_invalidate_tlb(vma->vm, vma->obj->mm.tlb);
> 		}
> ...
> 
> So, basically, if !async, __i915_vma_evict() will do TLB cache invalidation.
> 
> However, when async is used, the actual page release will happen later,
> at this function:
> 
> 	void ppgtt_unbind_vma(struct i915_address_space *vm,
> 			      struct i915_vma_resource *vma_res)
> 	{
> 		if (!vma_res->allocated)
> 			return;
> 
> 		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
> 		if (vma_res->tlb)
> 			vma_invalidate_tlb(vm, *vma_res->tlb);
> 	}

.. frankly I don't follow since I don't see any page release happening 
in here. Just PTE clearing.

I am explaining why it looks to me that the patch is doing two things. 
Implementing batching _and_ adding invalidation points at VMA unbind 
sites, while so far we had it at backing store release only. Maybe I am 
wrong and perhaps I am too slow to pick up on the explanation here.

So if the patch is doing two things please split it up.

I am further confused by the invalidation call site in evict and in 
unbind - why there can't be one logical site since the logical sequence 
is evict -> unbind.

Regards,

Tvrtko
