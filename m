Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27B568625
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiGFKwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiGFKwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:52:21 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22287275E7;
        Wed,  6 Jul 2022 03:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657104741; x=1688640741;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2NwnHUQ+1i1bQIU5tiViEs9faDnwXJ421nhEuxSIMuk=;
  b=lbwLy8EOFyZrbtJ3dlaw/hH8lDaIzPi+6Ui90ewkfsKNd68sveucgsFn
   zr4Qo/qke2vxsKNEUY47vGOM2QszqpKc7ea9NGgkIRmxHE/8zO9Q916TC
   hgynUCurT9koiaGkihDMPuNf3IZylz9kqfiv+2MW9pnHkFkYZgZZCg0o8
   A4cieJapHCneDLwVmeOmZkOFDwvvuVvB/klFji4rAufdhZUgpKTWkQdzZ
   8xoTGNK7Ap1I5kfs/l+42Z56uJ3+x+1F7x0vug39V2Q+iQptRmEBH/zpX
   4jusi48SNwE4EbbxU1rWraSJZe0nsWeIZDubApCpSXz1oVOU92AwRePp7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="263498556"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="263498556"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 03:50:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="650610565"
Received: from mropara-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.49.154])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 03:50:07 -0700
Date:   Wed, 6 Jul 2022 12:50:05 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas =?iso-8859-15?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: Re: [PATCH v3 2/2] drm/i915/gt: Serialize TLB invalidates with GT
 resets
Message-ID: <YsVo3ZBHGsodvFwQ@alfio.lan>
References: <cover.1656921701.git.mchehab@kernel.org>
 <3ecc1f94290a66b2e682f956b5232b4903c32a2c.1656921701.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ecc1f94290a66b2e682f956b5232b4903c32a2c.1656921701.git.mchehab@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro and Chris,

On Mon, Jul 04, 2022 at 09:09:29AM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Avoid trying to invalidate the TLB in the middle of performing an
> engine reset, as this may result in the reset timing out. Currently,
> the TLB invalidate is only serialised by its own mutex, forgoing the
> uncore lock, but we can take the uncore->lock as well to serialise
> the mmio access, thereby serialising with the GDRST.
> 
> Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
> i915 selftest/hangcheck.
> 
> Cc: stable@vger.kernel.org # Up to 4.4
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
> 
> To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH v3 0/2] at: https://lore.kernel.org/all/cover.1656921701.git.mchehab@kernel.org/
> 
>  drivers/gpu/drm/i915/gt/intel_gt.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index 8da3314bb6bf..68c2b0d8f187 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -952,6 +952,20 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>  	mutex_lock(&gt->tlb_invalidate_lock);
>  	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
>  
> +	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
> +
> +	for_each_engine(engine, gt, id) {
> +		struct reg_and_bit rb;
> +
> +		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
> +		if (!i915_mmio_reg_offset(rb.reg))
> +			continue;
> +
> +		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
> +	}
> +
> +	spin_unlock_irq(&uncore->lock);
> +

looks good,

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi

>  	for_each_engine(engine, gt, id) {
>  		/*
>  		 * HW architecture suggest typical invalidation time at 40us,
> @@ -966,7 +980,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>  		if (!i915_mmio_reg_offset(rb.reg))
>  			continue;
>  
> -		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
>  		if (__intel_wait_for_register_fw(uncore,
>  						 rb.reg, rb.bit, 0,
>  						 timeout_us, timeout_ms,
> -- 
> 2.36.1
