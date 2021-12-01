Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7122A464A3A
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347990AbhLAJBa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 1 Dec 2021 04:01:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:24798 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237533AbhLAJBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Dec 2021 04:01:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236646950"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="236646950"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 00:58:09 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="459948084"
Received: from pwedlarx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.26.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 00:58:03 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Lyude Paul <lyude@redhat.com>, intel-gfx@lists.freedesktop.org
Cc:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        =?utf-8?Q?Jos=C3=A9?= Roberto de Souza <jose.souza@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] drm/i915/dp: Perform 30ms delay after source OUI write
In-Reply-To: <20211130212912.212044-1-lyude@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20211129233354.101347-1-lyude@redhat.com>
 <20211130212912.212044-1-lyude@redhat.com>
Date:   Wed, 01 Dec 2021 10:58:00 +0200
Message-ID: <87k0goitwn.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Nov 2021, Lyude Paul <lyude@redhat.com> wrote:
> While working on supporting the Intel HDR backlight interface, I noticed
> that there's a couple of laptops that will very rarely manage to boot up
> without detecting Intel HDR backlight support - even though it's supported
> on the system. One example of such a laptop is the Lenovo P17 1st
> generation.
>
> Following some investigation Ville Syrjälä did through the docs they have
> available to them, they discovered that there's actually supposed to be a
> 30ms wait after writing the source OUI before we begin setting up the rest
> of the backlight interface.
>
> This seems to be correct, as adding this 30ms delay seems to have
> completely fixed the probing issues I was previously seeing. So - let's
> start performing a 30ms wait after writing the OUI, which we do in a manner
> similar to how we keep track of PPS delays (e.g. record the timestamp of
> the OUI write, and then wait for however many ms are left since that
> timestamp right before we interact with the backlight) in order to avoid
> waiting any longer then we need to. As well, this also avoids us performing
> this delay on systems where we don't end up using the HDR backlight
> interface.
>
> V3:
> * Move last_oui_write into intel_dp
> V2:
> * Move panel delays into intel_pps
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Fixes: 4a8d79901d5b ("drm/i915/dp: Enable Intel's HDR backlight interface (only SDR for now)")
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.12+

Thanks, pushed to drm-intel-next.

BR,
Jani.

> ---
>  drivers/gpu/drm/i915/display/intel_display_types.h    |  3 +++
>  drivers/gpu/drm/i915/display/intel_dp.c               | 11 +++++++++++
>  drivers/gpu/drm/i915/display/intel_dp.h               |  2 ++
>  drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c |  5 +++++
>  4 files changed, 21 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
> index ea1e8a6e10b0..b9c967837872 100644
> --- a/drivers/gpu/drm/i915/display/intel_display_types.h
> +++ b/drivers/gpu/drm/i915/display/intel_display_types.h
> @@ -1653,6 +1653,9 @@ struct intel_dp {
>  	struct intel_dp_pcon_frl frl;
>  
>  	struct intel_psr psr;
> +
> +	/* When we last wrote the OUI for eDP */
> +	unsigned long last_oui_write;
>  };
>  
>  enum lspcon_vendor {
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index 0a424bf69396..5a8206298691 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -29,6 +29,7 @@
>  #include <linux/i2c.h>
>  #include <linux/notifier.h>
>  #include <linux/slab.h>
> +#include <linux/timekeeping.h>
>  #include <linux/types.h>
>  
>  #include <asm/byteorder.h>
> @@ -2010,6 +2011,16 @@ intel_edp_init_source_oui(struct intel_dp *intel_dp, bool careful)
>  
>  	if (drm_dp_dpcd_write(&intel_dp->aux, DP_SOURCE_OUI, oui, sizeof(oui)) < 0)
>  		drm_err(&i915->drm, "Failed to write source OUI\n");
> +
> +	intel_dp->last_oui_write = jiffies;
> +}
> +
> +void intel_dp_wait_source_oui(struct intel_dp *intel_dp)
> +{
> +	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
> +
> +	drm_dbg_kms(&i915->drm, "Performing OUI wait\n");
> +	wait_remaining_ms_from_jiffies(intel_dp->last_oui_write, 30);
>  }
>  
>  /* If the device supports it, try to set the power state appropriately */
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
> index ce229026dc91..b64145a3869a 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.h
> +++ b/drivers/gpu/drm/i915/display/intel_dp.h
> @@ -119,4 +119,6 @@ void intel_dp_pcon_dsc_configure(struct intel_dp *intel_dp,
>  				 const struct intel_crtc_state *crtc_state);
>  void intel_dp_phy_test(struct intel_encoder *encoder);
>  
> +void intel_dp_wait_source_oui(struct intel_dp *intel_dp);
> +
>  #endif /* __INTEL_DP_H__ */
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> index 8b9c925c4c16..62c112daacf2 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> @@ -36,6 +36,7 @@
>  
>  #include "intel_backlight.h"
>  #include "intel_display_types.h"
> +#include "intel_dp.h"
>  #include "intel_dp_aux_backlight.h"
>  
>  /* TODO:
> @@ -106,6 +107,8 @@ intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
>  	int ret;
>  	u8 tcon_cap[4];
>  
> +	intel_dp_wait_source_oui(intel_dp);
> +
>  	ret = drm_dp_dpcd_read(aux, INTEL_EDP_HDR_TCON_CAP0, tcon_cap, sizeof(tcon_cap));
>  	if (ret != sizeof(tcon_cap))
>  		return false;
> @@ -204,6 +207,8 @@ intel_dp_aux_hdr_enable_backlight(const struct intel_crtc_state *crtc_state,
>  	int ret;
>  	u8 old_ctrl, ctrl;
>  
> +	intel_dp_wait_source_oui(intel_dp);
> +
>  	ret = drm_dp_dpcd_readb(&intel_dp->aux, INTEL_EDP_HDR_GETSET_CTRL_PARAMS, &old_ctrl);
>  	if (ret != 1) {
>  		drm_err(&i915->drm, "Failed to read current backlight control mode: %d\n", ret);

-- 
Jani Nikula, Intel Open Source Graphics Center
