Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A042EE663
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 20:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbhAGTvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 14:51:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:34700 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbhAGTvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 14:51:20 -0500
IronPort-SDR: 3RnL4MvLkbrinlh/zbPb88VYLcuQ2JoBoCXT8pAuT3AwSZ1OnpOa+uz3o/lMH6jMrlXm9mjIWn
 C5L6rctXY7fg==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="173978269"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="173978269"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 11:50:40 -0800
IronPort-SDR: vXdDF79OoQAQWQrByWQkNjdKXD0JY8vqZpv1czBT8dpK/ub3cintR8LOJ0DQUHXBi4sHLre6EU
 WRmqbud7C9ug==
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="347105059"
Received: from vishalka-mobl.amr.corp.intel.com (HELO intel.com) ([10.212.118.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 11:50:39 -0800
Date:   Thu, 7 Jan 2021 14:50:37 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Limit VFE threads based on GT
Message-ID: <20210107195037.GA7228@intel.com>
References: <20201016175411.30406-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016175411.30406-1-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 06:54:11PM +0100, Chris Wilson wrote:
> MEDIA_STATE_VFE only accepts the 'maximum number of threads' in the
> range [0, n-1] where n is #EU * (#threads/EU) with the number of threads
> based on plaform and the number of EU based on the number of slices and
> subslices. This is a fixed number per platform/gt, so appropriately
> limit the number of threads we spawn to match the device.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2024

we need to get this closed...

> Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
> Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
> Cc: Balestrieri Francesco <francesco.balestrieri@intel.com>
> Cc: Bloomfield Jon <jon.bloomfield@intel.com>
> Cc: <stable@vger.kernel.org> # v5.7+
> ---
>  drivers/gpu/drm/i915/gt/gen7_renderclear.c | 35 +++++++++++++++-------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/gen7_renderclear.c b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> index d93d85cd3027..f3b8fea6226e 100644
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
> @@ -34,8 +32,7 @@ struct batch_chunk {
>  };
>  
>  struct batch_vals {
> -	u32 max_primitives;
> -	u32 max_urb_entries;
> +	u32 max_primitives; /* == number of VFE threads */
>  	u32 cmd_size;
>  	u32 state_size;
>  	u32 state_start;
> @@ -50,18 +47,35 @@ static void
>  batch_get_defaults(struct drm_i915_private *i915, struct batch_vals *bv)
>  {
>  	if (IS_HASWELL(i915)) {
> -		bv->max_primitives = 280;
> -		bv->max_urb_entries = MAX_URB_ENTRIES;
> +		switch (INTEL_INFO(i915)->gt) {
> +		default:
> +		case 1:
> +			bv->max_primitives = 70;
> +			break;
> +		case 2:
> +			bv->max_primitives = 140;
> +			break;
> +		case 3:
> +			bv->max_primitives = 280;
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
> +			bv->max_primitives = 36;
> +			break;
> +		case 2:
> +			bv->max_primitives = 128;
> +			break;
> +		}
>  		bv->surface_height = 16 * 8;
>  		bv->surface_width = 32 * 16;
>  	}
>  	bv->cmd_size = bv->max_primitives * 4096;
> -	bv->state_size = STATE_SIZE;
> +	bv->state_size = SZ_4K;
>  	bv->state_start = bv->cmd_size;
>  	bv->batch_size = bv->cmd_size + bv->state_size;
>  	bv->scratch_size = bv->surface_height * bv->surface_width;
> @@ -244,7 +258,6 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
>  		    u32 urb_size, u32 curbe_size,
>  		    u32 mode)
>  {
> -	u32 urb_entries = bv->max_urb_entries;
>  	u32 threads = bv->max_primitives - 1;
>  	u32 *cs = batch_alloc_items(batch, 32, 8);
>  
> @@ -254,7 +267,7 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
>  	*cs++ = 0;
>  
>  	/* number of threads & urb entries for GPGPU vs Media Mode */
> -	*cs++ = threads << 16 | urb_entries << 8 | mode << 2;
> +	*cs++ = threads << 16 | 1 << 8 | mode << 2;

why urb_entries = 1 ?

the range is 0,64 and 0,128 depending on the sku.

in general there's a min of 32 URBs

>  
>  	*cs++ = 0;
>  
> -- 
> 2.20.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
