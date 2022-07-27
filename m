Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DAB5825D6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiG0Lsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 07:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiG0Lsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 07:48:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C604E4AD5B;
        Wed, 27 Jul 2022 04:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658922524; x=1690458524;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Az1nDJh3EQ7R5j6ZaG1tS/RcvdlaJn7u98b87B9prMk=;
  b=CSAqdr8KIupoR3PpfSTbumtuml8eov3NKE5WJyouR89aAPiIXP3bMZGr
   dXwlkmaZQKLEPxhJdUIqpMhUIn9xV5r2XgYBvSIbEMZ0uoUxBnQV+VVW1
   aG6nfX1ul0XV1Bsbcxq63x4Zm8wsWyApknuLtV+3Y5Vjzr5MCcDZzowt+
   AEZFnH+GNA/MQdRz8YRCyl6IqSoOefNuzZpAfb03WpTwFcdmC17vhtiUR
   KOac3YbjFAxw+oRAeohp/APCuNbBEFToFJTgjX1YmJvAmhJam2wQe68Hp
   84IoVHoQHahwt9CvDDmHGbAZBp7dG1WxBpzYim3CEiTeKlq4y/aiMbkRU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="349916810"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="349916810"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:48:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="628346740"
Received: from maurocar-mobl2.ger.corp.intel.com (HELO maurocar-mobl2) ([10.252.45.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:48:39 -0700
Date:   Wed, 27 Jul 2022 13:48:36 +0200
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
Message-ID: <20220727134836.7f7b5fab@maurocar-mobl2>
In-Reply-To: <567823d5-57ba-30db-dd64-de609df4d8c5@linux.intel.com>
References: <cover.1657800199.git.mchehab@kernel.org>
        <9f535a97f32320a213a619a30c961ba44b595453.1657800199.git.mchehab@kernel.org>
        <567823d5-57ba-30db-dd64-de609df4d8c5@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 20 Jul 2022 11:49:59 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

> On 20/07/2022 08:13, Mauro Carvalho Chehab wrote:
> > On Mon, 18 Jul 2022 14:52:05 +0100
> > Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> >   
> >>
> >> On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:  
> >>> From: Chris Wilson <chris.p.wilson@intel.com>
> >>>
> >>> Invalidate TLB in patch, in order to reduce performance regressions.  
> >>
> >> "in batches"?  
> > 
> > Yeah. Will fix it.

> > +void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb)
> > +{
> > +	/*
> > +	 * Before we release the pages that were bound by this vma, we
> > +	 * must invalidate all the TLBs that may still have a reference
> > +	 * back to our physical address. It only needs to be done once,
> > +	 * so after updating the PTE to point away from the pages, record
> > +	 * the most recent TLB invalidation seqno, and if we have not yet
> > +	 * flushed the TLBs upon release, perform a full invalidation.
> > +	 */
> > +	WRITE_ONCE(tlb, intel_gt_next_invalidate_tlb_full(vm->gt));  
> 
> Shouldn't tlb be a pointer for this to make sense?

Oh, my mistake! Will fix at the next version.

> >   
> >>> diff --git a/drivers/gpu/drm/i915/gt/intel_ppgtt.c b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
> >>> index d8b94d638559..2da6c82a8bd2 100644
> >>> --- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
> >>> +++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
> >>> @@ -206,8 +206,12 @@ void ppgtt_bind_vma(struct i915_address_space *vm,
> >>>    void ppgtt_unbind_vma(struct i915_address_space *vm,
> >>>    		      struct i915_vma_resource *vma_res)
> >>>    {
> >>> -	if (vma_res->allocated)
> >>> -		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
> >>> +	if (!vma_res->allocated)
> >>> +		return;
> >>> +
> >>> +	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
> >>> +	if (vma_res->tlb)
> >>> +		vma_invalidate_tlb(vm, *vma_res->tlb);  
> >>
> >> The patch is about more than batching? If there is a security hole in
> >> this area (unbind) with the current code?  
> > 
> > No, I don't think there's a security hole. The rationale for this is
> > not due to it.  
> 
> In this case obvious question is why are these changes in the patch 
> which declares itself to be about batching invalidations? Because...

Because vma_invalidate_tlb() basically stores a TLB seqno, but the
actual invalidation is deferred to when the pages are unset, at
__i915_gem_object_unset_pages().

So, what happens is:

- on VMA sync mode, the need to invalidate TLB is marked at
  __vma_put_pages(), before VMA unbind;
- on async, this is deferred to happen at ppgtt_unbind_vma(), where
  it marks the need to invalidate TLBs.

On both cases, __i915_gem_object_unset_pages() is called later,
when the driver is ready to unmap the page.

> I am explaining why it looks to me that the patch is doing two things. 
> Implementing batching _and_ adding invalidation points at VMA unbind 
> sites, while so far we had it at backing store release only. Maybe I am 
> wrong and perhaps I am too slow to pick up on the explanation here.
> 
> So if the patch is doing two things please split it up.
> 
> I am further confused by the invalidation call site in evict and in 
> unbind - why there can't be one logical site since the logical sequence 
> is evict -> unbind.

The invalidation happens only on one place: __i915_gem_object_unset_pages().

Despite its name, vma_invalidate_tlb() just marks the need of doing TLB
invalidation.

Regards,
Mauro
