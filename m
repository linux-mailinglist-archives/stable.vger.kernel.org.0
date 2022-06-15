Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE954D250
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 22:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244622AbiFOUIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 16:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345769AbiFOUIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 16:08:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EAF4B40A
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 13:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655323715; x=1686859715;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=S7NMnGTIfM2jkG+LdFL71xW44Y24coo/Xm5TwrfiI5w=;
  b=XRhMcfy2jxQsje52dPOgVZ1yiNTxVhBlNy+D5OapeuHTvW+9Og+MNE/u
   zo5/GucR4+aQZ3n45W/atMhm7piL+3ZP1HCMGMg3vda+zdjcHfrnalA7u
   sO6H+O+gjdWStjCeF/K8c3dg0flqJyB7vgyG5B0Deo8cikW92YULOxotA
   zD+czUXfA1T3sSt96yZGa7OMH7pRe7DS8VFnDCahVec3x1qFg7TUNLLaj
   Y5d+n9YhnGGJxTWP/xrT1x6FT1u4B8Hu7kaWYQ8AC3P/GCLw0GRs54OCo
   s9ROhMOV//wMCIbYDwY541dH0Xf1r5Du2/R41Rg+353a2fc0CzTdbQtwQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="279807670"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="279807670"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 13:08:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="589309118"
Received: from mdroper-desk1.fm.intel.com (HELO mdroper-desk1.amr.corp.intel.com) ([10.1.27.134])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 13:08:34 -0700
Date:   Wed, 15 Jun 2022 13:08:33 -0700
From:   Matt Roper <matthew.d.roper@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Implement w/a 22010492432 for adl-s
Message-ID: <Yqo8QUuk/A7Rvaks@mdroper-desk1.amr.corp.intel.com>
References: <20220613201439.23341-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220613201439.23341-1-ville.syrjala@linux.intel.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 11:14:39PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> adl-s needs the combo PLL DCO fraction w/a as well.
> Get us slightly more accurate clock out of the PLL.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_dpll_mgr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> index 64708e874b13..982e5b945680 100644
> --- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> +++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> @@ -2459,7 +2459,7 @@ static void icl_wrpll_params_populate(struct skl_wrpll_params *params,
>  }
>  
>  /*
> - * Display WA #22010492432: ehl, tgl, adl-p
> + * Display WA #22010492432: ehl, tgl, adl-s, adl-p
>   * Program half of the nominal DCO divider fraction value.
>   */
>  static bool
> @@ -2467,7 +2467,7 @@ ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
>  {
>  	return ((IS_PLATFORM(i915, INTEL_ELKHARTLAKE) &&
>  		 IS_JSL_EHL_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
> -		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_P(i915)) &&
> +		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
>  		 i915->dpll.ref_clks.nssc == 38400;
>  }
>  
> -- 
> 2.35.1
> 

-- 
Matt Roper
Graphics Software Engineer
VTT-OSGC Platform Enablement
Intel Corporation
