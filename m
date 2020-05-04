Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8381C3B63
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 15:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgEDNjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 09:39:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:46989 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgEDNjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 09:39:05 -0400
IronPort-SDR: i0xiI5/Vqkwg4eQ0NQP01vDCh+XEP3vw0Z+qTYcvY3uOlv1HNipQuA6YvYiyRPhvZzNAPA1IYb
 oI0SBi1Rx6Dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 06:39:04 -0700
IronPort-SDR: 9tlhy0yB/jVg0+uNo7gj9NQAVX3zrmYljAsiVgzHDimBiw8UN+meutQv26vzXOYpLvdIYAxggn
 IIoFufZ6L9vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="248219466"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga007.jf.intel.com with SMTP; 04 May 2020 06:39:02 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 04 May 2020 16:39:01 +0300
Date:   Mon, 4 May 2020 16:39:01 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/tgl+: Fix interrupt handling for DP
 AUX transactions
Message-ID: <20200504133901.GZ6112@intel.com>
References: <20200504075828.20348-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200504075828.20348-1-imre.deak@intel.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 10:58:28AM +0300, Imre Deak wrote:
> Unmask/enable AUX interrupts on all ports on TGL+. So far the interrupts
> worked only on port A, which meant each transaction on other ports took
> 10ms.
> 
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/i915_irq.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index bd722d0650c8..0b8b0c069ce3 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -3361,7 +3361,7 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
>  	u32 de_pipe_masked = gen8_de_pipe_fault_mask(dev_priv) |
>  		GEN8_PIPE_CDCLK_CRC_DONE;
>  	u32 de_pipe_enables;
> -	u32 de_port_masked = GEN8_AUX_CHANNEL_A;
> +	u32 de_port_masked = gen8_de_port_aux_mask(dev_priv);
>  	u32 de_port_enables;
>  	u32 de_misc_masked = GEN8_DE_EDP_PSR;
>  	enum pipe pipe;
> @@ -3369,18 +3369,8 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
>  	if (INTEL_GEN(dev_priv) <= 10)
>  		de_misc_masked |= GEN8_DE_MISC_GSE;
>  
> -	if (INTEL_GEN(dev_priv) >= 9) {
> -		de_port_masked |= GEN9_AUX_CHANNEL_B | GEN9_AUX_CHANNEL_C |
> -				  GEN9_AUX_CHANNEL_D;
> -		if (IS_GEN9_LP(dev_priv))
> -			de_port_masked |= BXT_DE_PORT_GMBUS;
> -	}
> -
> -	if (INTEL_GEN(dev_priv) >= 11)
> -		de_port_masked |= ICL_AUX_CHANNEL_E;
> -
> -	if (IS_CNL_WITH_PORT_F(dev_priv) || INTEL_GEN(dev_priv) >= 11)
> -		de_port_masked |= CNL_AUX_CHANNEL_F;
> +	if (IS_GEN9_LP(dev_priv))
> +		de_port_masked |= BXT_DE_PORT_GMBUS;
>  
>  	de_pipe_enables = de_pipe_masked | GEN8_PIPE_VBLANK |
>  					   GEN8_PIPE_FIFO_UNDERRUN;
> -- 
> 2.23.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
