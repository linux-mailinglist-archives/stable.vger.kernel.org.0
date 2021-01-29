Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93213308ABF
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 17:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhA2Q6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 11:58:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:61265 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231486AbhA2Q5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Jan 2021 11:57:52 -0500
IronPort-SDR: iSMex83aknaBIld/DCEJAPDeljf9Iym4tn+GHHikgukbNywPAuRU49hvPX0ldzNeNm4NtQJiO8
 vq8uNBwIW3dA==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="241971981"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="241971981"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 08:56:51 -0800
IronPort-SDR: ArZMPgfaYKheNGDudyCzOhmxRAde/kCpsboTs6j5CSqJixBBgTkyFd8h7wub+dGh/4a3upyEDN
 oyJryWn3beBQ==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="365330453"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 08:56:50 -0800
Date:   Fri, 29 Jan 2021 18:56:46 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915: Skip vswing programming for TBT
Message-ID: <20210129165646.GA183052@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 05:59:44PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> In thunderbolt mode the PHY is owned by the thunderbolt controller.
> We are not supposed to touch it. So skip the vswing programming
> as well (we already skipped the other steps not applicable to TBT).
> 
> Touching this stuff could supposedly interfere with the PHY
> programming done by the thunderbolt controller.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Matches the spec:
Reviewed-by: Imre Deak <imre.deak@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_ddi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> index 9506b8048530..c94650488dc1 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -2827,6 +2827,9 @@ static void icl_mg_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
>  	int n_entries, ln;
>  	u32 val;
>  
> +	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
> +		return;
> +
>  	ddi_translations = icl_get_mg_buf_trans(encoder, crtc_state, &n_entries);
>  
>  	if (drm_WARN_ON_ONCE(&dev_priv->drm, !ddi_translations))
> @@ -2962,6 +2965,9 @@ tgl_dkl_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
>  	u32 val, dpcnt_mask, dpcnt_val;
>  	int n_entries, ln;
>  
> +	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
> +		return;
> +
>  	ddi_translations = tgl_get_dkl_buf_trans(encoder, crtc_state, &n_entries);
>  
>  	if (drm_WARN_ON_ONCE(&dev_priv->drm, !ddi_translations))
> -- 
> 2.26.2
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
