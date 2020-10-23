Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C558296DA6
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 13:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462965AbgJWL0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 07:26:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:22512 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S462927AbgJWL0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 07:26:53 -0400
IronPort-SDR: ATfIPI8C/vEqVOFHmcT0Bi1p0YXnHE7kS80dl9VZexRsVSmo5SITJeuRxk2mqfB3utf4/UF4IK
 zq85w3Lo7Pyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="164166479"
X-IronPort-AV: E=Sophos;i="5.77,408,1596524400"; 
   d="scan'208";a="164166479"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 04:26:50 -0700
IronPort-SDR: vgyiyETabY8Y9fu8DGNqT0S4y3voZFUPA3TDlgvSTj2LgKvJ6XzptgzuWw0unRZdLUBRFYTLrJ
 LUkoXSgtZKdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,408,1596524400"; 
   d="scan'208";a="354408690"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga002.fm.intel.com with ESMTP; 23 Oct 2020 04:26:47 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 0A4D05C2038; Fri, 23 Oct 2020 14:25:08 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Use the local HWSP offset during submission
In-Reply-To: <20201022064127.10159-1-chris@chris-wilson.co.uk>
References: <20201021220411.5777-1-chris@chris-wilson.co.uk> <20201022064127.10159-1-chris@chris-wilson.co.uk>
Date:   Fri, 23 Oct 2020 14:25:08 +0300
Message-ID: <87r1ppqj57.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> We wrap the timeline on construction of the next request, but there may
> still be requests in flight that have not yet finalized the breadcrumb.
> (The breadcrumb is delayed as we need engine-local offsets, and for the
> virtual engine that is not known until execution.) As such, by the time
> we write to the timeline's HWSP offset it may have changed, and we
> should use the value we preserved in the request instead.
>
> Though the window is small and infrequent (at full flow we can expect a
> timeline's seqno to wrap once every 30 minutes), the impact of writing
> the old seqno into the new HWSP is severe: the old requests are never
> completed, and the new requests are completed before they are even
> submitted.
>
> Fixes: ebece7539242 ("drm/i915: Keep timeline HWSP allocated until idle across the system")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.2+
> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c           | 27 +++++++++++++------
>  drivers/gpu/drm/i915/gt/intel_timeline.c      | 18 +++++++------
>  .../gpu/drm/i915/gt/intel_timeline_types.h    |  2 ++
>  3 files changed, 31 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index c22d47cc6701..d0be98b67138 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -3597,6 +3597,19 @@ static const struct intel_context_ops execlists_context_ops = {
>  	.destroy = execlists_context_destroy,
>  };
>  
> +static u32 hwsp_offset(const struct i915_request *rq)
> +{
> +	const struct intel_timeline_cacheline *cl;
> +
> +	/* Before the request is executed, the timeline/cachline is fixed */

s/cachline/cacheline

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> +
> +	cl = rcu_dereference_protected(rq->hwsp_cacheline, 1);
> +	if (cl)
> +		return cl->ggtt_offset;
> +
> +	return rcu_dereference_protected(rq->timeline, 1)->hwsp_offset;
> +}
> +
>  static int gen8_emit_init_breadcrumb(struct i915_request *rq)
>  {
>  	u32 *cs;
> @@ -3619,7 +3632,7 @@ static int gen8_emit_init_breadcrumb(struct i915_request *rq)
>  	*cs++ = MI_NOOP;
>  
>  	*cs++ = MI_STORE_DWORD_IMM_GEN4 | MI_USE_GGTT;
> -	*cs++ = i915_request_timeline(rq)->hwsp_offset;
> +	*cs++ = hwsp_offset(rq);
>  	*cs++ = 0;
>  	*cs++ = rq->fence.seqno - 1;
>  
> @@ -4939,11 +4952,9 @@ gen8_emit_fini_breadcrumb_tail(struct i915_request *request, u32 *cs)
>  	return gen8_emit_wa_tail(request, cs);
>  }
>  
> -static u32 *emit_xcs_breadcrumb(struct i915_request *request, u32 *cs)
> +static u32 *emit_xcs_breadcrumb(struct i915_request *rq, u32 *cs)
>  {
> -	u32 addr = i915_request_active_timeline(request)->hwsp_offset;
> -
> -	return gen8_emit_ggtt_write(cs, request->fence.seqno, addr, 0);
> +	return gen8_emit_ggtt_write(cs, rq->fence.seqno, hwsp_offset(rq), 0);
>  }
>  
>  static u32 *gen8_emit_fini_breadcrumb(struct i915_request *rq, u32 *cs)
> @@ -4962,7 +4973,7 @@ static u32 *gen8_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
>  	/* XXX flush+write+CS_STALL all in one upsets gem_concurrent_blt:kbl */
>  	cs = gen8_emit_ggtt_write_rcs(cs,
>  				      request->fence.seqno,
> -				      i915_request_active_timeline(request)->hwsp_offset,
> +				      hwsp_offset(request),
>  				      PIPE_CONTROL_FLUSH_ENABLE |
>  				      PIPE_CONTROL_CS_STALL);
>  
> @@ -4974,7 +4985,7 @@ gen11_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
>  {
>  	cs = gen8_emit_ggtt_write_rcs(cs,
>  				      request->fence.seqno,
> -				      i915_request_active_timeline(request)->hwsp_offset,
> +				      hwsp_offset(request),
>  				      PIPE_CONTROL_CS_STALL |
>  				      PIPE_CONTROL_TILE_CACHE_FLUSH |
>  				      PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH |
> @@ -5044,7 +5055,7 @@ gen12_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
>  {
>  	cs = gen12_emit_ggtt_write_rcs(cs,
>  				       request->fence.seqno,
> -				       i915_request_active_timeline(request)->hwsp_offset,
> +				       hwsp_offset(request),
>  				       PIPE_CONTROL0_HDC_PIPELINE_FLUSH,
>  				       PIPE_CONTROL_CS_STALL |
>  				       PIPE_CONTROL_TILE_CACHE_FLUSH |
> diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
> index a2f74cefe4c3..7ea94d201fe6 100644
> --- a/drivers/gpu/drm/i915/gt/intel_timeline.c
> +++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
> @@ -188,10 +188,14 @@ cacheline_alloc(struct intel_timeline_hwsp *hwsp, unsigned int cacheline)
>  	return cl;
>  }
>  
> -static void cacheline_acquire(struct intel_timeline_cacheline *cl)
> +static void cacheline_acquire(struct intel_timeline_cacheline *cl,
> +			      u32 ggtt_offset)
>  {
> -	if (cl)
> -		i915_active_acquire(&cl->active);
> +	if (!cl)
> +		return;
> +
> +	cl->ggtt_offset = ggtt_offset;
> +	i915_active_acquire(&cl->active);
>  }
>  
>  static void cacheline_release(struct intel_timeline_cacheline *cl)
> @@ -340,7 +344,7 @@ int intel_timeline_pin(struct intel_timeline *tl, struct i915_gem_ww_ctx *ww)
>  	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
>  		 tl->fence_context, tl->hwsp_offset);
>  
> -	cacheline_acquire(tl->hwsp_cacheline);
> +	cacheline_acquire(tl->hwsp_cacheline, tl->hwsp_offset);
>  	if (atomic_fetch_inc(&tl->pin_count)) {
>  		cacheline_release(tl->hwsp_cacheline);
>  		__i915_vma_unpin(tl->hwsp_ggtt);
> @@ -515,7 +519,7 @@ __intel_timeline_get_seqno(struct intel_timeline *tl,
>  	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
>  		 tl->fence_context, tl->hwsp_offset);
>  
> -	cacheline_acquire(cl);
> +	cacheline_acquire(cl, tl->hwsp_offset);
>  	tl->hwsp_cacheline = cl;
>  
>  	*seqno = timeline_advance(tl);
> @@ -573,9 +577,7 @@ int intel_timeline_read_hwsp(struct i915_request *from,
>  	if (err)
>  		goto out;
>  
> -	*hwsp = i915_ggtt_offset(cl->hwsp->vma) +
> -		ptr_unmask_bits(cl->vaddr, CACHELINE_BITS) * CACHELINE_BYTES;
> -
> +	*hwsp = cl->ggtt_offset;
>  out:
>  	i915_active_release(&cl->active);
>  	return err;
> diff --git a/drivers/gpu/drm/i915/gt/intel_timeline_types.h b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
> index 02181c5020db..4474f487f589 100644
> --- a/drivers/gpu/drm/i915/gt/intel_timeline_types.h
> +++ b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
> @@ -94,6 +94,8 @@ struct intel_timeline_cacheline {
>  	struct intel_timeline_hwsp *hwsp;
>  	void *vaddr;
>  
> +	u32 ggtt_offset;
> +
>  	struct rcu_head rcu;
>  };
>  
> -- 
> 2.20.1
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
