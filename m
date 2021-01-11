Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC92F1C8D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387538AbhAKRf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:35:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:53028 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732053AbhAKRf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:35:56 -0500
IronPort-SDR: wBvqPPqrqGBbNyaoyd9i+cdidZPAerfruoC16ja0CFxIadwDHlpwZ/poKbaswGMCYDU2TDq+z7
 2D0agOdKDR2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="175325639"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="175325639"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 09:35:16 -0800
IronPort-SDR: jwe53H6FJjojpI9CffbPmcp3isaPTdp82CajTlfqZl0E3hTYq93OC++Dtnl/yPlJXkUM1y3iN0
 +Cas/OFceLGA==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="399875801"
Received: from jaksamit-mobl.amr.corp.intel.com (HELO intel.com) ([10.212.178.167])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 09:35:15 -0800
Date:   Mon, 11 Jan 2021 12:35:12 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, Randy Wright <rwright@hpe.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 01/11] drm/i915/gt: Limit VFE threads based
 on GT
Message-ID: <20210111173512.GA3689@intel.com>
References: <20210110150404.19535-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110150404.19535-1-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 03:03:54PM +0000, Chris Wilson wrote:
> MEDIA_STATE_VFE only accepts the 'maximum number of threads' in the
> range [0, n-1] where n is #EU * (#threads/EU) with the number of threads
> based on plaform and the number of EU based on the number of slices and
> subslices. This is a fixed number per platform/gt, so appropriately
> limit the number of threads we spawn to match the device.
> 
> v2: Oversaturate the system with tasks to force execution on every HW
> thread; if the thread idles it is returned to the pool and may be reused
> again before an unused thread.
> 
> v3: Fix more state commands, which was causing Baytrail to barf.

CI is still not happy with byt right? or is that false positive?

> v4: STATE_CACHE_INVALIDATE requires a stall on Ivybridge
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2024
> Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
> Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Randy Wright <rwright@hpe.com>
> Cc: stable@vger.kernel.org # v5.7+
> ---
>  drivers/gpu/drm/i915/gt/gen7_renderclear.c | 157 ++++++++++++---------
>  1 file changed, 94 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/gen7_renderclear.c b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> index d93d85cd3027..f32a8e8040b2 100644
> --- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> +++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> @@ -7,8 +7,6 @@
>  #include "i915_drv.h"
>  #include "intel_gpu_commands.h"
>  
> -#define MAX_URB_ENTRIES 64
> -#define STATE_SIZE (4 * 1024)
>  #define GT3_INLINE_DATA_DELAYS 0x1E00
>  #define batch_advance(Y, CS) GEM_BUG_ON((Y)->end != (CS))
>  
> @@ -34,38 +32,59 @@ struct batch_chunk {
>  };
>  
>  struct batch_vals {
> -	u32 max_primitives;
> -	u32 max_urb_entries;
> -	u32 cmd_size;
> -	u32 state_size;
> +	u32 max_threads;
>  	u32 state_start;
> -	u32 batch_size;
> +	u32 surface_start;
>  	u32 surface_height;
>  	u32 surface_width;
> -	u32 scratch_size;
> -	u32 max_size;
> +	u32 size;
>  };
>  
> +static inline int num_primitives(const struct batch_vals *bv)
> +{
> +	/*
> +	 * We need to saturate the GPU with work in order to dispatch
> +	 * a shader on every HW thread, and clear the thread-local registers.
> +	 * In short, we have to dispatch work faster than the shaders can
> +	 * run in order to fill occupy each HW thread.
> +	 */
> +	return bv->max_threads;
> +}
> +
>  static void
>  batch_get_defaults(struct drm_i915_private *i915, struct batch_vals *bv)
>  {
>  	if (IS_HASWELL(i915)) {
> -		bv->max_primitives = 280;
> -		bv->max_urb_entries = MAX_URB_ENTRIES;
> +		switch (INTEL_INFO(i915)->gt) {
> +		default:
> +		case 1:
> +			bv->max_threads = 70;
> +			break;
> +		case 2:
> +			bv->max_threads = 140;
> +			break;
> +		case 3:
> +			bv->max_threads = 280;
> +			break;
> +		}
>  		bv->surface_height = 16 * 16;
>  		bv->surface_width = 32 * 2 * 16;
>  	} else {
> -		bv->max_primitives = 128;
> -		bv->max_urb_entries = MAX_URB_ENTRIES / 2;
> +		switch (INTEL_INFO(i915)->gt) {
> +		default:
> +		case 1: /* including vlv */
> +			bv->max_threads = 36;
> +			break;
> +		case 2:
> +			bv->max_threads = 128;
> +			break;
> +		}
>  		bv->surface_height = 16 * 8;
>  		bv->surface_width = 32 * 16;

all the values above matches the spec.

>  	}
> -	bv->cmd_size = bv->max_primitives * 4096;
> -	bv->state_size = STATE_SIZE;
> -	bv->state_start = bv->cmd_size;
> -	bv->batch_size = bv->cmd_size + bv->state_size;
> -	bv->scratch_size = bv->surface_height * bv->surface_width;
> -	bv->max_size = bv->batch_size + bv->scratch_size;
> +	bv->state_start = round_up(SZ_1K + num_primitives(bv) * 64, SZ_4K);
> +	bv->surface_start = bv->state_start + SZ_4K;
> +	bv->size = bv->surface_start + bv->surface_height * bv->surface_width;

I liked this batch values simplification...

>  }
>  
>  static void batch_init(struct batch_chunk *bc,
> @@ -155,7 +174,8 @@ static u32
>  gen7_fill_binding_table(struct batch_chunk *state,
>  			const struct batch_vals *bv)
>  {
> -	u32 surface_start = gen7_fill_surface_state(state, bv->batch_size, bv);
> +	u32 surface_start =
> +		gen7_fill_surface_state(state, bv->surface_start, bv);
>  	u32 *cs = batch_alloc_items(state, 32, 8);
>  	u32 offset = batch_offset(state, cs);
>  
> @@ -214,9 +234,9 @@ static void
>  gen7_emit_state_base_address(struct batch_chunk *batch,
>  			     u32 surface_state_base)
>  {
> -	u32 *cs = batch_alloc_items(batch, 0, 12);
> +	u32 *cs = batch_alloc_items(batch, 0, 10);
>  
> -	*cs++ = STATE_BASE_ADDRESS | (12 - 2);
> +	*cs++ = STATE_BASE_ADDRESS | (10 - 2);
>  	/* general */
>  	*cs++ = batch_addr(batch) | BASE_ADDRESS_MODIFY;
>  	/* surface */
> @@ -233,8 +253,6 @@ gen7_emit_state_base_address(struct batch_chunk *batch,
>  	*cs++ = BASE_ADDRESS_MODIFY;
>  	*cs++ = 0;
>  	*cs++ = BASE_ADDRESS_MODIFY;
> -	*cs++ = 0;
> -	*cs++ = 0;

why don't we need this anymore?

>  	batch_advance(batch, cs);
>  }
>  
> @@ -244,8 +262,7 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
>  		    u32 urb_size, u32 curbe_size,
>  		    u32 mode)
>  {
> -	u32 urb_entries = bv->max_urb_entries;
> -	u32 threads = bv->max_primitives - 1;
> +	u32 threads = bv->max_threads - 1;
>  	u32 *cs = batch_alloc_items(batch, 32, 8);
>  
>  	*cs++ = MEDIA_VFE_STATE | (8 - 2);
> @@ -254,7 +271,7 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
>  	*cs++ = 0;
>  
>  	/* number of threads & urb entries for GPGPU vs Media Mode */
> -	*cs++ = threads << 16 | urb_entries << 8 | mode << 2;
> +	*cs++ = threads << 16 | 1 << 8 | mode << 2;
>  
>  	*cs++ = 0;
>  
> @@ -293,17 +310,12 @@ gen7_emit_media_object(struct batch_chunk *batch,
>  {
>  	unsigned int x_offset = (media_object_index % 16) * 64;
>  	unsigned int y_offset = (media_object_index / 16) * 16;
> -	unsigned int inline_data_size;
> -	unsigned int media_batch_size;
> -	unsigned int i;
> +	unsigned int pkt = 6 + 3;
>  	u32 *cs;
>  
> -	inline_data_size = 112 * 8;
> -	media_batch_size = inline_data_size + 6;
> +	cs = batch_alloc_items(batch, 8, pkt);
>  
> -	cs = batch_alloc_items(batch, 8, media_batch_size);
> -
> -	*cs++ = MEDIA_OBJECT | (media_batch_size - 2);
> +	*cs++ = MEDIA_OBJECT | (pkt - 2);
>  
>  	/* interface descriptor offset */
>  	*cs++ = 0;
> @@ -317,25 +329,44 @@ gen7_emit_media_object(struct batch_chunk *batch,
>  	*cs++ = 0;
>  
>  	/* inline */
> -	*cs++ = (y_offset << 16) | (x_offset);
> +	*cs++ = y_offset << 16 | x_offset;
>  	*cs++ = 0;
>  	*cs++ = GT3_INLINE_DATA_DELAYS;
> -	for (i = 3; i < inline_data_size; i++)
> -		*cs++ = 0;

why?

>  
>  	batch_advance(batch, cs);
>  }
>  
>  static void gen7_emit_pipeline_flush(struct batch_chunk *batch)
>  {
> -	u32 *cs = batch_alloc_items(batch, 0, 5);
> +	u32 *cs = batch_alloc_items(batch, 0, 4);
>  
> -	*cs++ = GFX_OP_PIPE_CONTROL(5);
> -	*cs++ = PIPE_CONTROL_STATE_CACHE_INVALIDATE |
> -		PIPE_CONTROL_GLOBAL_GTT_IVB;
> +	*cs++ = GFX_OP_PIPE_CONTROL(4);
> +	*cs++ = PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH |
> +		PIPE_CONTROL_DEPTH_CACHE_FLUSH |
> +		PIPE_CONTROL_DC_FLUSH_ENABLE |
> +		PIPE_CONTROL_CS_STALL;
>  	*cs++ = 0;
>  	*cs++ = 0;
> +
> +	batch_advance(batch, cs);
> +}
> +
> +static void gen7_emit_pipeline_invalidate(struct batch_chunk *batch)
> +{
> +	u32 *cs = batch_alloc_items(batch, 0, 8);
> +
> +	/* ivb: Stall before STATE_CACHE_INVALIDATE */
> +	*cs++ = GFX_OP_PIPE_CONTROL(4);
> +	*cs++ = PIPE_CONTROL_STALL_AT_SCOREBOARD |
> +		PIPE_CONTROL_CS_STALL;
>  	*cs++ = 0;
> +	*cs++ = 0;
> +
> +	*cs++ = GFX_OP_PIPE_CONTROL(4);
> +	*cs++ = PIPE_CONTROL_STATE_CACHE_INVALIDATE;
> +	*cs++ = 0;
> +	*cs++ = 0;
> +
>  	batch_advance(batch, cs);
>  }
>  
> @@ -344,34 +375,34 @@ static void emit_batch(struct i915_vma * const vma,
>  		       const struct batch_vals *bv)
>  {
>  	struct drm_i915_private *i915 = vma->vm->i915;
> -	unsigned int desc_count = 64;
> -	const u32 urb_size = 112;
> +	const unsigned int desc_count = 1;
> +	const unsigned int urb_size = 1;
>  	struct batch_chunk cmds, state;
> -	u32 interface_descriptor;
> +	u32 descriptors;
>  	unsigned int i;
>  
> -	batch_init(&cmds, vma, start, 0, bv->cmd_size);
> -	batch_init(&state, vma, start, bv->state_start, bv->state_size);
> +	batch_init(&cmds, vma, start, 0, bv->state_start);
> +	batch_init(&state, vma, start, bv->state_start, SZ_4K);
>  
> -	interface_descriptor =
> -		gen7_fill_interface_descriptor(&state, bv,
> -					       IS_HASWELL(i915) ?
> -					       &cb_kernel_hsw :
> -					       &cb_kernel_ivb,
> -					       desc_count);
> -	gen7_emit_pipeline_flush(&cmds);
> +	descriptors = gen7_fill_interface_descriptor(&state, bv,
> +						     IS_HASWELL(i915) ?
> +						     &cb_kernel_hsw :
> +						     &cb_kernel_ivb,
> +						     desc_count);
> +
> +	gen7_emit_pipeline_invalidate(&cmds);
>  	batch_add(&cmds, PIPELINE_SELECT | PIPELINE_SELECT_MEDIA);
>  	batch_add(&cmds, MI_NOOP);
> -	gen7_emit_state_base_address(&cmds, interface_descriptor);
> +	gen7_emit_pipeline_invalidate(&cmds);
> +
>  	gen7_emit_pipeline_flush(&cmds);
> +	gen7_emit_state_base_address(&cmds, descriptors);
> +	gen7_emit_pipeline_invalidate(&cmds);

why do we need double invalidate?

>  
>  	gen7_emit_vfe_state(&cmds, bv, urb_size - 1, 0, 0);
> +	gen7_emit_interface_descriptor_load(&cmds, descriptors, desc_count);
>  
> -	gen7_emit_interface_descriptor_load(&cmds,
> -					    interface_descriptor,
> -					    desc_count);
> -
> -	for (i = 0; i < bv->max_primitives; i++)
> +	for (i = 0; i < num_primitives(bv); i++)
>  		gen7_emit_media_object(&cmds, i);
>  
>  	batch_add(&cmds, MI_BATCH_BUFFER_END);
> @@ -385,15 +416,15 @@ int gen7_setup_clear_gpr_bb(struct intel_engine_cs * const engine,
>  
>  	batch_get_defaults(engine->i915, &bv);
>  	if (!vma)
> -		return bv.max_size;
> +		return bv.size;
>  
> -	GEM_BUG_ON(vma->obj->base.size < bv.max_size);
> +	GEM_BUG_ON(vma->obj->base.size < bv.size);
>  
>  	batch = i915_gem_object_pin_map(vma->obj, I915_MAP_WC);
>  	if (IS_ERR(batch))
>  		return PTR_ERR(batch);
>  
> -	emit_batch(vma, memset(batch, 0, bv.max_size), &bv);
> +	emit_batch(vma, memset(batch, 0, bv.size), &bv);
>  
>  	i915_gem_object_flush_map(vma->obj);
>  	__i915_gem_object_release_map(vma->obj);
> -- 
> 2.20.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
