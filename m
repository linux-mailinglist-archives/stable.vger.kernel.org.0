Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF78A57B175
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 09:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiGTHNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 03:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGTHNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 03:13:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7851599ED;
        Wed, 20 Jul 2022 00:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658301195; x=1689837195;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C4guEf5ByHXvwa1MrRvVncmlNBatFlLImdYf1S9lI+E=;
  b=CPvQGVKtrwlp694dd5zHPBf6Hw59xQQGxAsebIZHRMb4HLTQtFTuFpC+
   wB+PJhPGAKqVHyoTQUJ9WIlwbe+UkuaaouqQiY+Qzq4jJSqBDieTsJj+y
   PHdPaYJJClU+Q2dud15m2s4SEhIGi8N+i7PsBLJRgyRsiwj6PlWREhDrP
   oWOpSeBhjIggT0h3qCv04CLdC79EbmXQX7jigpQlooDxH1ggeLv+wE+fD
   JdccDJie4nXBSjBllH9vQnmOBK4bs46MRlVqXAuz4RaCxEJV4V1Jl+glc
   iFHxFLaDSuWk39n8EvgD5wJpLr+g3agStdWQXIjyX9dgGUvrzXOxwuYSX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="373000508"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="373000508"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 00:13:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="656143102"
Received: from maurocar-mobl2.ger.corp.intel.com (HELO maurocar-mobl2) ([10.249.35.29])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 00:13:11 -0700
Date:   Wed, 20 Jul 2022 09:13:04 +0200
From:   Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= 
        <thomas.hellstrom@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        intel-gfx@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-media@vger.kernel.org,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [Intel-gfx] [PATCH v2 06/21] drm/i915/gt: Batch TLB
 invalidations
Message-ID: <20220720091304.14b5186b@maurocar-mobl2>
In-Reply-To: <605ab738-42df-c8fe-efb3-654d5792d3cc@linux.intel.com>
References: <cover.1657800199.git.mchehab@kernel.org>
        <9f535a97f32320a213a619a30c961ba44b595453.1657800199.git.mchehab@kernel.org>
        <605ab738-42df-c8fe-efb3-654d5792d3cc@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jul 2022 14:52:05 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

> 
> On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:
> > From: Chris Wilson <chris.p.wilson@intel.com>
> > 
> > Invalidate TLB in patch, in order to reduce performance regressions.
> 
> "in batches"?

Yeah. Will fix it.

> > diff --git a/drivers/gpu/drm/i915/gt/intel_ppgtt.c b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
> > index d8b94d638559..2da6c82a8bd2 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
> > @@ -206,8 +206,12 @@ void ppgtt_bind_vma(struct i915_address_space *vm,
> >   void ppgtt_unbind_vma(struct i915_address_space *vm,
> >   		      struct i915_vma_resource *vma_res)
> >   {
> > -	if (vma_res->allocated)
> > -		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
> > +	if (!vma_res->allocated)
> > +		return;
> > +
> > +	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
> > +	if (vma_res->tlb)
> > +		vma_invalidate_tlb(vm, *vma_res->tlb);
> 
> The patch is about more than batching? If there is a security hole in 
> this area (unbind) with the current code?

No, I don't think there's a security hole. The rationale for this is
not due to it.

Since commit 2f6b90da9192 ("drm/i915: Use vma resources for async unbinding"),
VMA unbind can happen either sync or async.

So, the logic needs to do TLB invalidate on two places. After this
patch, the code at __i915_vma_evict is:

	struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async)
	{
...
		if (async)
			unbind_fence = i915_vma_resource_unbind(vma_res,
								&vma->obj->mm.tlb);
		else
			unbind_fence = i915_vma_resource_unbind(vma_res, NULL);

		vma->resource = NULL;

		atomic_and(~(I915_VMA_BIND_MASK | I915_VMA_ERROR | I915_VMA_GGTT_WRITE),
			   &vma->flags);

		i915_vma_detach(vma);

		if (!async) {
			if (unbind_fence) {
				dma_fence_wait(unbind_fence, false);
				dma_fence_put(unbind_fence);
				unbind_fence = NULL;
			}
			vma_invalidate_tlb(vma->vm, vma->obj->mm.tlb);
		}
...

So, basically, if !async, __i915_vma_evict() will do TLB cache invalidation.

However, when async is used, the actual page release will happen later,
at this function:

	void ppgtt_unbind_vma(struct i915_address_space *vm,
			      struct i915_vma_resource *vma_res)
	{
		if (!vma_res->allocated)
			return;

		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
		if (vma_res->tlb)
			vma_invalidate_tlb(vm, *vma_res->tlb);
	}
	
Regards,
Mauro
