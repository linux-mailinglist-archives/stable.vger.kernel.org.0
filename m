Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA25288F
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfFYJsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:48:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:19506 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbfFYJsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 05:48:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 02:48:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,415,1557212400"; 
   d="scan'208";a="166626086"
Received: from gaia.fi.intel.com ([10.237.72.169])
  by orsmga006.jf.intel.com with ESMTP; 25 Jun 2019 02:48:36 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 032BA5C1EB3; Tue, 25 Jun 2019 12:48:22 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Kenneth Graunke <kenneth@whitecape.org>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.
In-Reply-To: <20190625090655.19220-1-chris@chris-wilson.co.uk>
References: <20190625070829.25277-1-kenneth@whitecape.org> <20190625090655.19220-1-chris@chris-wilson.co.uk>
Date:   Tue, 25 Jun 2019 12:48:22 +0300
Message-ID: <87ef3i572x.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> From: Kenneth Graunke <kenneth@whitecape.org>
>
> The Demand Prefetch workaround (binding table prefetching) only applies
> to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
> applied to all Gen11 steppings, according to a programming note in the
> SARCHKMD documentation.
>
> Using the Intel Gallium driver, I have seen intermittent failures in
> the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
> applying this workaround, the tests reliably pass.
>
> v2: Remove the overlap with a pre-production w/a
>
> BSpec: 9663
> Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@vger.kernel.org

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index c70445adfb02..993804d09517 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -1252,8 +1252,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>  		if (IS_ICL_REVID(i915, ICL_REVID_A0, ICL_REVID_B0))
>  			wa_write_or(wal,
>  				    GEN7_SARCHKMD,
> -				    GEN7_DISABLE_DEMAND_PREFETCH |
> -				    GEN7_DISABLE_SAMPLER_PREFETCH);
> +				    GEN7_DISABLE_DEMAND_PREFETCH);
> +
> +		/* Wa_1606682166:icl */
> +		wa_write_or(wal,
> +			    GEN7_SARCHKMD,
> +			    GEN7_DISABLE_SAMPLER_PREFETCH);
>  	}
>  
>  	if (IS_GEN_RANGE(i915, 9, 11)) {
> -- 
> 2.20.1
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
