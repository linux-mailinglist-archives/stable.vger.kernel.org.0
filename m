Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75A7340C60
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 19:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCRSAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 14:00:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:49331 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhCRSAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 14:00:13 -0400
IronPort-SDR: OoA5zWGDsGZFyxylXDR8bkDQd2KHbP0NQllAup8SmNbZbX7/VL3jdM083fGtfVNQYxkBumKdRR
 Iuk6Aw6vsqMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="251095424"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="251095424"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 11:00:13 -0700
IronPort-SDR: ro7YVxnXiCp+zBgYJ81Sxdp29Ts51zPhsrULw/SY+//gT7PHrNUvNgW2VLfCGtY0q6rgj9khfe
 rH88PaEbggdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="450570890"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga001.jf.intel.com with SMTP; 18 Mar 2021 11:00:10 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 18 Mar 2021 20:00:10 +0200
Date:   Thu, 18 Mar 2021 20:00:10 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] drm/i915: Disable LTTPR support when the LTTPR
 rev < 1.4
Message-ID: <YFOVKoReLkmB7ZuQ@intel.com>
References: <20210317184901.4029798-1-imre.deak@intel.com>
 <20210317184901.4029798-4-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317184901.4029798-4-imre.deak@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 08:49:01PM +0200, Imre Deak wrote:
> By the specification the 0xF0000 - 0xF02FF range is only valid if the
> LTTPR revision at 0xF0000 is at least 1.4. Disable the LTTPR support
> otherwise.
> 
> Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
> Cc: <stable@vger.kernel.org> # v5.11
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  .../gpu/drm/i915/display/intel_dp_link_training.c  | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> index d8d90903226f..d92eb192c89d 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> @@ -100,17 +100,23 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
>  		return false;
>  
>  	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
> -					  intel_dp->lttpr_common_caps) < 0) {
> -		intel_dp_reset_lttpr_common_caps(intel_dp);
> -		return false;
> -	}
> +					  intel_dp->lttpr_common_caps) < 0)
> +		goto reset_caps;

BTW just noticed this oddball thing in the spec:
"DPTX shall read specific registers within the LTTPR field (DPCD
 Addresses F0000h through F0004h; see Table 2-198) to determine
 whether any LTTPR(s) are present and if so, how many. This read
 shall be in the form of a 5-byte native AUX Read transaction."

Why exactly 5 bytes? I have no idea. Doesn't really make sense.
Just wondering if we really need to respect that and some LTTPRs
would fsck things up if we read more...

Anyways
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

>  
>  	drm_dbg_kms(&dp_to_i915(intel_dp)->drm,
>  		    "LTTPR common capabilities: %*ph\n",
>  		    (int)sizeof(intel_dp->lttpr_common_caps),
>  		    intel_dp->lttpr_common_caps);
>  
> +	/* The minimum value of LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV is 1.4 */
> +	if (intel_dp->lttpr_common_caps[0] < 0x14)
> +		goto reset_caps;
> +
>  	return true;
> +
> +reset_caps:
> +	intel_dp_reset_lttpr_common_caps(intel_dp);
> +	return false;
>  }
>  
>  static bool
> -- 
> 2.25.1

-- 
Ville Syrjälä
Intel
