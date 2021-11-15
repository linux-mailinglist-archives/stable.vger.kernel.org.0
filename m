Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DEC4502DC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 11:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhKOK5T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 15 Nov 2021 05:57:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:9455 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231233AbhKOK5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 05:57:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233257828"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233257828"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 02:53:48 -0800
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="493973187"
Received: from csrini4x-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.218.37])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 02:53:43 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Lyude Paul <lyude@redhat.com>, intel-gfx@lists.freedesktop.org
Cc:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        =?utf-8?Q?Jos?= =?utf-8?Q?=C3=A9?= Roberto de Souza 
        <jose.souza@intel.com>, Uma Shankar <uma.shankar@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        "open list\:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/dp: Perform 30ms delay after source OUI write
In-Reply-To: <20211112215016.270267-1-lyude@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20211112215016.270267-1-lyude@redhat.com>
Date:   Mon, 15 Nov 2021 12:53:40 +0200
Message-ID: <878rxp3d1n.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Nov 2021, Lyude Paul <lyude@redhat.com> wrote:
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

Ugh. Thanks for digging into this.

The only thing that I dislike with the implementation is splitting the
implementation to two places. See how well we've managed to shove all of
the PPS waits inside intel_pps.c. Almost all of intel_dp->pps is managed
within intel_pps.c.

I think I'd actually add a intel_dp_wait_source_oui() or something in
intel_dp.c, so all of the details about source OUI and
intel_dp->last_oui_write access would be localized.


BR,
Jani.


>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 4a8d79901d5b ("drm/i915/dp: Enable Intel's HDR backlight interface (only SDR for now)")
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.12+
> ---
>  drivers/gpu/drm/i915/display/intel_display_types.h    |  3 +++
>  drivers/gpu/drm/i915/display/intel_dp.c               |  3 +++
>  drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c | 11 +++++++++++
>  3 files changed, 17 insertions(+)
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
> index 0a424bf69396..77d9a9390c1e 100644
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
> @@ -2010,6 +2011,8 @@ intel_edp_init_source_oui(struct intel_dp *intel_dp, bool careful)
>  
>  	if (drm_dp_dpcd_write(&intel_dp->aux, DP_SOURCE_OUI, oui, sizeof(oui)) < 0)
>  		drm_err(&i915->drm, "Failed to write source OUI\n");
> +
> +	intel_dp->last_oui_write = jiffies;
>  }
>  
>  /* If the device supports it, try to set the power state appropriately */
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> index 569d17b4d00f..2c35b999ec2c 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> @@ -96,6 +96,13 @@
>  #define INTEL_EDP_BRIGHTNESS_OPTIMIZATION_1                            0x359
>  
>  /* Intel EDP backlight callbacks */
> +static void
> +wait_for_oui(struct drm_i915_private *i915, struct intel_dp *intel_dp)
> +{
> +	drm_dbg_kms(&i915->drm, "Performing OUI wait\n");
> +	wait_remaining_ms_from_jiffies(intel_dp->last_oui_write, 30);
> +}
> +
>  static bool
>  intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
>  {
> @@ -106,6 +113,8 @@ intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
>  	int ret;
>  	u8 tcon_cap[4];
>  
> +	wait_for_oui(i915, intel_dp);
> +
>  	ret = drm_dp_dpcd_read(aux, INTEL_EDP_HDR_TCON_CAP0, tcon_cap, sizeof(tcon_cap));
>  	if (ret != sizeof(tcon_cap))
>  		return false;
> @@ -204,6 +213,8 @@ intel_dp_aux_hdr_enable_backlight(const struct intel_crtc_state *crtc_state,
>  	int ret;
>  	u8 old_ctrl, ctrl;
>  
> +	wait_for_oui(i915, intel_dp);
> +
>  	ret = drm_dp_dpcd_readb(&intel_dp->aux, INTEL_EDP_HDR_GETSET_CTRL_PARAMS, &old_ctrl);
>  	if (ret != 1) {
>  		drm_err(&i915->drm, "Failed to read current backlight control mode: %d\n", ret);

-- 
Jani Nikula, Intel Open Source Graphics Center
