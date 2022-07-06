Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A1D568634
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiGFKyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiGFKyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:54:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF4327B06;
        Wed,  6 Jul 2022 03:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657104858; x=1688640858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=qrEumAiCGHwpWr14nERu9HZ9oiyvzZusQBL2z+Vav/k=;
  b=QOYlxB+fisZAK/zoGiBYCkBRTNnpgHGnovUFEpzusz7Nebdlc0cL5lhz
   scFgaw9+ShACFcllSipQRNyFJn7qlq4qu+7JyYO4QrG3dr2qaxVhyWRnV
   nb1DgZT53TgjpVlXl1RcA4qap5dge3S/H6Px7EzDQnaPqlJhBl8XATddA
   YDqzgvJ/jNDVTo0k8OPBEkaWqJhbVwfmMDRFtDmmt9X7SUyT+j/YAm3w0
   +DIsAGZfoV9h3yD9JPwFt4SduhzqvABpfk2guxm9n1Uyh1UJID1JEqla5
   Ts2i5HiRaR1eng0tVazwIujiV9dDlTHUzCkCr4oQ/YxdxuHZrHgPxHgvS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="264131974"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="264131974"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 03:51:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="620260611"
Received: from mropara-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.49.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 03:51:33 -0700
Date:   Wed, 6 Jul 2022 12:51:31 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas =?iso-8859-15?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: Re: [PATCH v3 1/2] drm/i915/gt: Serialize GRDOM access between
 multiple engine resets
Message-ID: <YsVpM1f86FAIEO8i@alfio.lan>
References: <cover.1656921701.git.mchehab@kernel.org>
 <ccc54757d89d38af35e5c5885edfb980c7b227f6.1656921701.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccc54757d89d38af35e5c5885edfb980c7b227f6.1656921701.git.mchehab@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro and Chris,

On Mon, Jul 04, 2022 at 09:09:28AM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Don't allow two engines to be reset in parallel, as they would both
> try to select a reset bit (and send requests to common registers)
> and wait on that register, at the same time. Serialize control of
> the reset requests/acks using the uncore->lock, which will also ensure
> that no other GT state changes at the same time as the actual reset.
> 
> Cc: stable@vger.kernel.org # Up to 4.4
> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@intel.com>
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

sorry for the delay but I wanted to understand what has been
agreed between you and Tvrtko about the Cc'ing the stable list.

Anyway, I confirm my review here.

Andi

> ---
> 
> To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH v3 0/2] at: https://lore.kernel.org/all/cover.1656921701.git.mchehab@kernel.org/
> 
>  drivers/gpu/drm/i915/gt/intel_reset.c | 37 ++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
> index a5338c3fde7a..c68d36fb5bbd 100644
> --- a/drivers/gpu/drm/i915/gt/intel_reset.c
> +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
> @@ -300,9 +300,9 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
>  	return err;
>  }
>  
> -static int gen6_reset_engines(struct intel_gt *gt,
> -			      intel_engine_mask_t engine_mask,
> -			      unsigned int retry)
> +static int __gen6_reset_engines(struct intel_gt *gt,
> +				intel_engine_mask_t engine_mask,
> +				unsigned int retry)
>  {
>  	struct intel_engine_cs *engine;
>  	u32 hw_mask;
> @@ -321,6 +321,20 @@ static int gen6_reset_engines(struct intel_gt *gt,
>  	return gen6_hw_domain_reset(gt, hw_mask);
>  }
>  
> +static int gen6_reset_engines(struct intel_gt *gt,
> +			      intel_engine_mask_t engine_mask,
> +			      unsigned int retry)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&gt->uncore->lock, flags);
> +	ret = __gen6_reset_engines(gt, engine_mask, retry);
> +	spin_unlock_irqrestore(&gt->uncore->lock, flags);
> +
> +	return ret;
> +}
> +
>  static struct intel_engine_cs *find_sfc_paired_vecs_engine(struct intel_engine_cs *engine)
>  {
>  	int vecs_id;
> @@ -487,9 +501,9 @@ static void gen11_unlock_sfc(struct intel_engine_cs *engine)
>  	rmw_clear_fw(uncore, sfc_lock.lock_reg, sfc_lock.lock_bit);
>  }
>  
> -static int gen11_reset_engines(struct intel_gt *gt,
> -			       intel_engine_mask_t engine_mask,
> -			       unsigned int retry)
> +static int __gen11_reset_engines(struct intel_gt *gt,
> +				 intel_engine_mask_t engine_mask,
> +				 unsigned int retry)
>  {
>  	struct intel_engine_cs *engine;
>  	intel_engine_mask_t tmp;
> @@ -583,8 +597,11 @@ static int gen8_reset_engines(struct intel_gt *gt,
>  	struct intel_engine_cs *engine;
>  	const bool reset_non_ready = retry >= 1;
>  	intel_engine_mask_t tmp;
> +	unsigned long flags;
>  	int ret;
>  
> +	spin_lock_irqsave(&gt->uncore->lock, flags);
> +
>  	for_each_engine_masked(engine, gt, engine_mask, tmp) {
>  		ret = gen8_engine_reset_prepare(engine);
>  		if (ret && !reset_non_ready)
> @@ -612,17 +629,19 @@ static int gen8_reset_engines(struct intel_gt *gt,
>  	 * This is best effort, so ignore any error from the initial reset.
>  	 */
>  	if (IS_DG2(gt->i915) && engine_mask == ALL_ENGINES)
> -		gen11_reset_engines(gt, gt->info.engine_mask, 0);
> +		__gen11_reset_engines(gt, gt->info.engine_mask, 0);
>  
>  	if (GRAPHICS_VER(gt->i915) >= 11)
> -		ret = gen11_reset_engines(gt, engine_mask, retry);
> +		ret = __gen11_reset_engines(gt, engine_mask, retry);
>  	else
> -		ret = gen6_reset_engines(gt, engine_mask, retry);
> +		ret = __gen6_reset_engines(gt, engine_mask, retry);
>  
>  skip_reset:
>  	for_each_engine_masked(engine, gt, engine_mask, tmp)
>  		gen8_engine_reset_cancel(engine);
>  
> +	spin_unlock_irqrestore(&gt->uncore->lock, flags);
> +
>  	return ret;
>  }
>  
> -- 
> 2.36.1
