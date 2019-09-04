Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533F8A80C3
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 13:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfIDLAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 07:00:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:39036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbfIDLAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 07:00:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 04:00:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="173542759"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga007.jf.intel.com with ESMTP; 04 Sep 2019 04:00:00 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 9BAB85C1E29; Wed,  4 Sep 2019 13:59:52 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Jason Ekstrand <jason@jlekstrand.net>,
        denys.kostin@globallogic.com, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE) for skl+
In-Reply-To: <20190904100707.7377-1-chris@chris-wilson.co.uk>
References: <20190904100707.7377-1-chris@chris-wilson.co.uk>
Date:   Wed, 04 Sep 2019 13:59:52 +0300
Message-ID: <87tv9stjh3.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> This bit was fliped on for "syncing dependencies between camera and
> graphics". BSpec has no recollection why, and it is causing
> unrecoverable GPU hangs with Vulkan compute workloads.
>
> From BSpec, setting bit5 to 0 enables relaxed padding requiremets for
> buffers, 1D and 2D non-array, non-MSAA, non-mip-mapped linear surfaces;
> and *must* be set to 0h on skl+ to ensure "Out of Bounds" case is
> suppressed.
>
> Reported-by: Jason Ekstrand <jason@jlekstrand.net>
> Suggested-by: Jason Ekstrand <jason@jlekstrand.net>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110998
> Fixes: 8424171e135c ("drm/i915/gen9: h/w w/a: syncing dependencies between camera and graphics")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Tested-by: denys.kostin@globallogic.com
> Cc: Jason Ekstrand <jason@jlekstrand.net>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v4.1+

The bug and especially #110228 was like a good detective story.
But one step left the reader curious: from the compute shader
reproducer the territory to search for was shrunk to gpgpu
workarounds. Was the rest brute force or how did you end up
with this particular one?

Great that it got nailed! Thanks everyone,

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index 8639fcccdb42..243d3f77be13 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -297,11 +297,6 @@ static void gen9_ctx_workarounds_init(struct intel_engine_cs *engine,
>  			  FLOW_CONTROL_ENABLE |
>  			  PARTIAL_INSTRUCTION_SHOOTDOWN_DISABLE);
>  
> -	/* Syncing dependencies between camera and graphics:skl,bxt,kbl */
> -	if (!IS_COFFEELAKE(i915))
> -		WA_SET_BIT_MASKED(HALF_SLICE_CHICKEN3,
> -				  GEN9_DISABLE_OCL_OOB_SUPPRESS_LOGIC);
> -
>  	/* WaEnableYV12BugFixInHalfSliceChicken7:skl,bxt,kbl,glk,cfl */
>  	/* WaEnableSamplerGPGPUPreemptionSupport:skl,bxt,kbl,cfl */
>  	WA_SET_BIT_MASKED(GEN9_HALF_SLICE_CHICKEN7,
> -- 
> 2.23.0
