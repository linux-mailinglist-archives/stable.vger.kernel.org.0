Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092A61BAB4A
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgD0RaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 13:30:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:3540 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgD0RaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 13:30:13 -0400
IronPort-SDR: RvypKaXia26CQk60rk07DUSua/JX1WEEBANlQH4+gK9Vu0t9wNZ5N6GK740uXsclJvGZx7Rjb2
 76pLqa2j6v7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 10:30:13 -0700
IronPort-SDR: LXFcd4Gxq9bf9zLwVhomAPxYk8+tbKL9BAkYelE4PpB3MJ7/hK2JGqjdYFlaMgKRnnWU0aBFoP
 4wxp5xGFf9+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,324,1583222400"; 
   d="scan'208";a="292570810"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga002.fm.intel.com with ESMTP; 27 Apr 2020 10:30:11 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 52C045C1F9A; Mon, 27 Apr 2020 20:28:12 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915/execlists: Avoid reusing the same logical CC_ID
In-Reply-To: <20200427170513.24019-1-chris@chris-wilson.co.uk>
References: <20200427170513.24019-1-chris@chris-wilson.co.uk>
Date:   Mon, 27 Apr 2020 20:28:12 +0300
Message-ID: <875zdkltxv.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> ---
>  drivers/gpu/drm/i915/gt/intel_engine_types.h |  3 +--
>  drivers/gpu/drm/i915/gt/intel_lrc.c          | 23 ++++++++++++++------
>  drivers/gpu/drm/i915/i915_perf.c             |  3 +--
>  drivers/gpu/drm/i915/selftests/i915_vma.c    |  2 +-
>  4 files changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
> index bf395227c99f..a9fc3fbbe482 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
> +++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
> @@ -304,8 +304,7 @@ struct intel_engine_cs {
>  	u32 context_size;
>  	u32 mmio_base;
>  
> -	unsigned int context_tag;
> -#define NUM_CONTEXT_TAG roundup_pow_of_two(2 * EXECLIST_MAX_PORTS)
> +	unsigned long context_tag;
>  
>  	struct rb_node uabi_node;
>  
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index 93a1b73ad96b..d68a04f2a9d5 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -1404,13 +1404,16 @@ __execlists_schedule_in(struct i915_request *rq)
>  	ce->lrc_desc &= ~GENMASK_ULL(47, 37);
>  	if (ce->tag) {
>  		/* Use a fixed tag for OA and friends */
> +		GEM_BUG_ON(ce->tag <= BITS_PER_TYPE(engine->context_tag));
>  		ce->lrc_desc |= (u64)ce->tag << 32;

I see danger here to completely trash the upper part our our lrc_desc.
Is the ce->tag validated or should we add more enforcement in here?

>  	} else {
>  		/* We don't need a strict matching tag, just different values */
> -		ce->lrc_desc |=
> -			(u64)(++engine->context_tag % NUM_CONTEXT_TAG) <<
> -			GEN11_SW_CTX_ID_SHIFT;
> -		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
> +		unsigned int tag = ffs(engine->context_tag);
> +
> +		clear_bit(tag - 1, &engine->context_tag);
> +		ce->lrc_desc |= (u64)tag << GEN11_SW_CTX_ID_SHIFT;
> +
> +		BUILD_BUG_ON(BITS_PER_TYPE(engine->context_tag) > GEN12_MAX_CONTEXT_HW_ID);
>  	}
>  
>  	__intel_gt_pm_get(engine->gt);
> @@ -1452,7 +1455,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
>  
>  static inline void
>  __execlists_schedule_out(struct i915_request *rq,
> -			 struct intel_engine_cs * const engine)
> +			 struct intel_engine_cs * const engine,
> +			 int tag)
>  {
>  	struct intel_context * const ce = rq->context;
>  
> @@ -1470,6 +1474,9 @@ __execlists_schedule_out(struct i915_request *rq,
>  	    i915_request_completed(rq))
>  		intel_engine_add_retire(engine, ce->timeline);
>  
> +	if (tag <= BITS_PER_TYPE(engine->context_tag))
> +		set_bit(tag - 1, &engine->context_tag);
> +
>  	intel_context_update_runtime(ce);
>  	intel_engine_context_out(engine);
>  	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
> @@ -1495,15 +1502,17 @@ execlists_schedule_out(struct i915_request *rq)
>  {
>  	struct intel_context * const ce = rq->context;
>  	struct intel_engine_cs *cur, *old;
> +	int tag;
>  
>  	trace_i915_request_out(rq);
>  
> +	tag = upper_32_bits(rq->context->lrc_desc);

There is more in the upper part than just a tag (sw field).
So we need to only set/get a particular masked field.

-Mika

>  	old = READ_ONCE(ce->inflight);
>  	do
>  		cur = ptr_unmask_bits(old, 2) ? ptr_dec(old) : NULL;
>  	while (!try_cmpxchg(&ce->inflight, &old, cur));
>  	if (!cur)
> -		__execlists_schedule_out(rq, old);
> +		__execlists_schedule_out(rq, old, tag);
>  
>  	i915_request_put(rq);
>  }
> @@ -4002,7 +4011,7 @@ static void enable_execlists(struct intel_engine_cs *engine)
>  
>  	enable_error_interrupt(engine);
>  
> -	engine->context_tag = 0;
> +	engine->context_tag = -1u;
>  }
>  
>  static bool unexpected_starting_state(struct intel_engine_cs *engine)
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index dec1b33e4da8..1863a5c4778d 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -1281,11 +1281,10 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
>  			((1U << GEN11_SW_CTX_ID_WIDTH) - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
>  		/*
>  		 * Pick an unused context id
> -		 * 0 - (NUM_CONTEXT_TAG - 1) are used by other contexts
> +		 * 0 - BITS_PER_LONG are used by other contexts
>  		 * GEN12_MAX_CONTEXT_HW_ID (0x7ff) is used by idle context
>  		 */
>  		stream->specific_ctx_id = (GEN12_MAX_CONTEXT_HW_ID - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
> -		BUILD_BUG_ON((GEN12_MAX_CONTEXT_HW_ID - 1) < NUM_CONTEXT_TAG);
>  		break;
>  	}
>  
> diff --git a/drivers/gpu/drm/i915/selftests/i915_vma.c b/drivers/gpu/drm/i915/selftests/i915_vma.c
> index 58b5f40a07dd..af89c7fc8f59 100644
> --- a/drivers/gpu/drm/i915/selftests/i915_vma.c
> +++ b/drivers/gpu/drm/i915/selftests/i915_vma.c
> @@ -173,7 +173,7 @@ static int igt_vma_create(void *arg)
>  		}
>  
>  		nc = 0;
> -		for_each_prime_number(num_ctx, 2 * NUM_CONTEXT_TAG) {
> +		for_each_prime_number(num_ctx, 2 * BITS_PER_LONG) {
>  			for (; nc < num_ctx; nc++) {
>  				ctx = mock_context(i915, "mock");
>  				if (!ctx)
> -- 
> 2.20.1
