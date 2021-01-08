Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3457F2EF74D
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 19:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbhAHS0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 13:26:32 -0500
Received: from mga06.intel.com ([134.134.136.31]:52084 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbhAHS0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 13:26:32 -0500
IronPort-SDR: 9jAORHBtJh/nY3BVIW+8DtGhp4e/vMIg+h8hYAbCWSWwWYVpJba1cu2AdPoi0tlMKOJCcV2Mi3
 ppJu5zYcBAoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="239187058"
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="239187058"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 10:25:51 -0800
IronPort-SDR: sgZW7y6IYKAOcWtHW3tyWjsIFmDmZPVAUnG9KOr7ETYEIYbVODxGfswzcQnKJqgDU+ClmV/Od5
 jXLvMVV465Ig==
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="497930909"
Received: from mdroper-desk1.fm.intel.com (HELO mdroper-desk1.amr.corp.intel.com) ([10.1.27.168])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 10:25:48 -0800
Date:   Fri, 8 Jan 2021 10:25:48 -0800
From:   Matt Roper <matthew.d.roper@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Prevent use of engine->wa_ctx after error
Message-ID: <20210108182548.GG3894148@mdroper-desk1.amr.corp.intel.com>
References: <20210108150924.29437-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108150924.29437-1-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 08, 2021 at 03:09:24PM +0000, Chris Wilson wrote:
> On error we unpin and free the wa_ctx.vma, but do not clear any of the
> derived flags. During lrc_init, we look at the flags and attempt to
> dereference the wa_ctx.vma if they are set. To protect the error path
> where we try to limp along without the wa_ctx, make sure we clear those
> flags!
> 
> Reported-by: Matt Roper <matthew.d.roper@intel.com>
> Fixes: 604a8f6f1e33 ("drm/i915/lrc: Only enable per-context and per-bb buffers if set")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matt Roper <matthew.d.roper@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v4.15+

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index 4e856947fb13..703d9ecc3f7e 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -1453,6 +1453,9 @@ static int lrc_setup_wa_ctx(struct intel_engine_cs *engine)
>  void lrc_fini_wa_ctx(struct intel_engine_cs *engine)
>  {
>  	i915_vma_unpin_and_release(&engine->wa_ctx.vma, 0);
> +
> +	/* Called on error unwind, clear all flags to prevent further use */
> +	memset(&engine->wa_ctx, 0, sizeof(engine->wa_ctx));
>  }
>  
>  typedef u32 *(*wa_bb_func_t)(struct intel_engine_cs *engine, u32 *batch);
> -- 
> 2.20.1
> 

-- 
Matt Roper
Graphics Software Engineer
VTT-OSGC Platform Enablement
Intel Corporation
(916) 356-2795
