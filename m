Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3C13531A8
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 01:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBXp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 19:45:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:39410 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235538AbhDBXp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Apr 2021 19:45:56 -0400
IronPort-SDR: OLeWFJ+65p7Q7pqH/DCapBc5ruyQOGFk+ML9HuU2dM8+FlOcfe4N9LTLeiI7MWxrZloEYmg+Mo
 jdvrpt+ajfHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9942"; a="256531416"
X-IronPort-AV: E=Sophos;i="5.81,300,1610438400"; 
   d="scan'208";a="256531416"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 16:45:54 -0700
IronPort-SDR: CpI3kaH/eUqkC3h/O9Aq6Oh1xn7fApXVx2IVoz0/P/r2WpwoyPUAHg/sekp6NbmDMZhhTsi5in
 3jC/VGt8f84A==
X-IronPort-AV: E=Sophos;i="5.81,300,1610438400"; 
   d="scan'208";a="395126078"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 16:45:52 -0700
Date:   Sat, 3 Apr 2021 02:45:49 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Takashi Iwai <tiwai@suse.de>,
        Santiago Zarate <santiago.zarate@suse.com>,
        Bodo Graumann <mail@bodograumann.de>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Subject: Re: [gfx-internal-devel] [PATCH 1/3] drm/i915/ilk-glk: Fix link
 training on links with LTTPRs
Message-ID: <20210402234549.GD1736175@ideak-desk.fi.intel.com>
References: <20210401232927.1711811-1-imre.deak@intel.com>
 <20210401232927.1711811-2-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210401232927.1711811-2-imre.deak@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please ignore this patchset, it's not yet the correct version rebased on
v5.11 (more precisely I Cc'd stable for this version of the patchset by
mistake).

I'll resend this patchset properly rebased on v5.11.

Sorry for the noise.

--Imre

On Fri, Apr 02, 2021 at 02:29:24AM +0300, Imre Deak wrote:
> The spec requires to use at least 3.2ms for the AUX timeout period if
> there are LT-tunable PHY Repeaters on the link (2.11.2). An upcoming
> spec update makes this more specific, by requiring a 3.2ms minimum
> timeout period for the LTTPR detection reading the 0xF0000-0xF0007
> range (3.6.5.1).
> 
> Accordingly disable LTTPR detection until GLK, where the maximum timeout
> we can set is only 1.6ms.
> 
> Link training in the non-transparent mode is known to fail at least on
> some SKL systems with a WD19 dock on the link, which exposes an LTTPR
> (see the References below). While this could have different reasons
> besides the too short AUX timeout used, not detecting LTTPRs (and so not
> using the non-transparent LT mode) fixes link training on these systems.
> 
> While at it add a code comment about the platform specific maximum
> timeout values.
> 
> v2: Add a comment about the g4x maximum timeout as well. (Ville)
> 
> Reported-by: Takashi Iwai <tiwai@suse.de>
> Reported-and-tested-by: Santiago Zarate <santiago.zarate@suse.com>
> Reported-and-tested-by: Bodo Graumann <mail@bodograumann.de>
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/3166
> Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent mode link training")
> Cc: <stable@vger.kernel.org> # v5.11
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210317184901.4029798-2-imre.deak@intel.com
> (cherry picked from commit 984982f3ef7b240cd24c2feb2762d81d9d8da3c2)
> ---
>  drivers/gpu/drm/i915/display/intel_dp_aux.c       |  7 +++++++
>  .../gpu/drm/i915/display/intel_dp_link_training.c | 15 ++++++++++++---
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> index eaebf123310a..10fe17b7280d 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> @@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct intel_dp *intel_dp,
>  	else
>  		precharge = 5;
>  
> +	/* Max timeout value on G4x-BDW: 1.6ms */
>  	if (IS_BROADWELL(dev_priv))
>  		timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
>  	else
> @@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
>  	enum phy phy = intel_port_to_phy(i915, dig_port->base.port);
>  	u32 ret;
>  
> +	/*
> +	 * Max timeout values:
> +	 * SKL-GLK: 1.6ms
> +	 * CNL: 3.2ms
> +	 * ICL+: 4ms
> +	 */
>  	ret = DP_AUX_CH_CTL_SEND_BUSY |
>  	      DP_AUX_CH_CTL_DONE |
>  	      DP_AUX_CH_CTL_INTERRUPT |
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> index 892d7db7d94f..35cda72492d7 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> @@ -81,6 +81,18 @@ static void intel_dp_read_lttpr_phy_caps(struct intel_dp *intel_dp,
>  
>  static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
>  {
> +	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
> +
> +	if (intel_dp_is_edp(intel_dp))
> +		return false;
> +
> +	/*
> +	 * Detecting LTTPRs must be avoided on platforms with an AUX timeout
> +	 * period < 3.2ms. (see DP Standard v2.0, 2.11.2, 3.6.6.1).
> +	 */
> +	if (INTEL_GEN(i915) < 10)
> +		return false;
> +
>  	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
>  					  intel_dp->lttpr_common_caps) < 0) {
>  		memset(intel_dp->lttpr_common_caps, 0,
> @@ -126,9 +138,6 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
>  	bool ret;
>  	int i;
>  
> -	if (intel_dp_is_edp(intel_dp))
> -		return 0;
> -
>  	ret = intel_dp_read_lttpr_common_caps(intel_dp);
>  	if (!ret)
>  		return 0;
