Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B2537177D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhECPGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 11:06:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:51088 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhECPGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 11:06:40 -0400
IronPort-SDR: 7ASA0+Kyn07o6RdhwgHlWd6AZn8J5gaalUzVHeQAPMC0AlJDlHjpmVHrbQQ1SgexPbmQAa9rv0
 x1oXIq9Y91vA==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="218551757"
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="218551757"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 08:05:47 -0700
IronPort-SDR: B1DeOxGgmBP9vKILXtocflw5cECHBCijteH/+9roDteI3BMPGnfTMekWp/BBsiM7N1YkwU6sV7
 1yXU9dOt9nMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="389617374"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga006.jf.intel.com with SMTP; 03 May 2021 08:05:43 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 May 2021 18:05:43 +0300
Date:   Mon, 3 May 2021 18:05:43 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     airlied@linux.ie, daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/display Try YCbCr420 color when RGB fails
Message-ID: <YJARR2sanRuiWByO@intel.com>
References: <20210429120553.7823-1-wse@tuxedocomputers.com>
 <YIw2q/aibOplo7b+@intel.com>
 <c68865ea-a968-a0b2-e534-a97c51a42d16@tuxedocomputers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c68865ea-a968-a0b2-e534-a97c51a42d16@tuxedocomputers.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 01:39:04PM +0200, Werner Sembach wrote:
> Thanks for the feedback. I got some questions below.
> > On Thu, Apr 29, 2021 at 02:05:53PM +0200, Werner Sembach wrote:
> >> When encoder validation of a display mode fails, retry with less bandwidth
> >> heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
> >> to support 4k60Hz output, which previously failed silently.
> >>
> >> AMDGPU had nearly the exact same issue. This problem description is
> >> therefore copied from my commit message of the AMDGPU patch.
> >>
> >> On some setups, while the monitor and the gpu support display modes with
> >> pixel clocks of up to 600MHz, the link encoder might not. This prevents
> >> YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
> >> possible. However, which color mode is used is decided before the link
> >> encoder capabilities are checked. This patch fixes the problem by retrying
> >> to find a display mode with YCbCr420 enforced and using it, if it is
> >> valid.
> >>
> >> I'm not entierly sure if the second
> >> "if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))" check in
> >> intel_hdmi_compute_config(...) after forcing ycbcr420 is necessary. I
> >> included it to better be safe then sorry.
> >>
> >> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> >> Cc: <stable@vger.kernel.org>
> >> ---
> >> Rebased from 5.12 to drm-tip and resend to resolve merge conflict.
> >>
> >> >From 876c1c8d970ff2a411ee8d08651bd4edbe9ecb3d Mon Sep 17 00:00:00 2001
> >> From: Werner Sembach <wse@tuxedocomputers.com>
> >> Date: Thu, 29 Apr 2021 13:59:30 +0200
> >> Subject: [PATCH] Retry using YCbCr420 encoding if clock setup for RGB fails
> >>
> >> ---
> >>  drivers/gpu/drm/i915/display/intel_hdmi.c | 80 +++++++++++++++++------
> >>  1 file changed, 60 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
> >> index 46de56af33db..c9b5a7d7f9c6 100644
> >> --- a/drivers/gpu/drm/i915/display/intel_hdmi.c
> >> +++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
> >> @@ -1861,6 +1861,30 @@ static int intel_hdmi_port_clock(int clock, int bpc)
> >>  	return clock * bpc / 8;
> >>  }
> >>  
> >> +static enum drm_mode_status
> >> +intel_hdmi_check_bpc(struct intel_hdmi *hdmi, int clock, bool has_hdmi_sink, struct drm_i915_private *dev_priv)
> > Don't pass dev_priv. It can be extracted from the intel_hdmi.
> >
> > The name of the function isn't really sitting super well with me.
> > I guess I'd just call it something like intel_hdmi_mode_clock_valid().
> >
> > We should also split this big patch up into smaller parts. Just this
> > mechanical extraction of this function without any functional changes
> > could be a nice first patch in the series.
> >
> >> +{
> >> +	enum drm_mode_status status;
> >> +
> >> +	/* check if we can do 8bpc */
> >> +	status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 8),
> >> +				       true, has_hdmi_sink);
> >> +
> >> +	if (has_hdmi_sink) {
> >> +		/* if we can't do 8bpc we may still be able to do 12bpc */
> >> +		if (status != MODE_OK && !HAS_GMCH(dev_priv))
> >> +			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 12),
> >> +						       true, has_hdmi_sink);
> >> +
> >> +		/* if we can't do 8,12bpc we may still be able to do 10bpc */
> >> +		if (status != MODE_OK && DISPLAY_VER(dev_priv) >= 11)
> >> +			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 10),
> >> +						       true, has_hdmi_sink);
> >> +	}
> >> +
> >> +	return status;
> >> +}
> >> +
> >>  static enum drm_mode_status
> >>  intel_hdmi_mode_valid(struct drm_connector *connector,
> >>  		      struct drm_display_mode *mode)
> >> @@ -1891,23 +1915,18 @@ intel_hdmi_mode_valid(struct drm_connector *connector,
> >>  	if (drm_mode_is_420_only(&connector->display_info, mode))
> >>  		clock /= 2;
> >>  
> >> -	/* check if we can do 8bpc */
> >> -	status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 8),
> >> -				       true, has_hdmi_sink);
> >> +	status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
> >>  
> >> -	if (has_hdmi_sink) {
> >> -		/* if we can't do 8bpc we may still be able to do 12bpc */
> >> -		if (status != MODE_OK && !HAS_GMCH(dev_priv))
> >> -			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 12),
> >> -						       true, has_hdmi_sink);
> >> +	if (status != MODE_OK) {
> >> +		if (drm_mode_is_420_also(&connector->display_info, mode)) {
> > We also need a connector->ycbcr_420_allowed check here.
> >
> >> +			/* if we can't do full color resolution we may still be able to do reduced color resolution */
> >> +			clock /= 2;
> >>  
> >> -		/* if we can't do 8,12bpc we may still be able to do 10bpc */
> >> -		if (status != MODE_OK && DISPLAY_VER(dev_priv) >= 11)
> >> -			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 10),
> >> -						       true, has_hdmi_sink);
> >> +			status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
> >> +		}
> >> +		if (status != MODE_OK)
> >> +			return status;
> >>  	}
> >> -	if (status != MODE_OK)
> >> -		return status;
> >>  
> >>  	return intel_mode_valid_max_plane_size(dev_priv, mode, false);
> >>  }
> >> @@ -1990,14 +2009,17 @@ static bool hdmi_deep_color_possible(const struct intel_crtc_state *crtc_state,
> >>  
> >>  static int
> >>  intel_hdmi_ycbcr420_config(struct intel_crtc_state *crtc_state,
> >> -			   const struct drm_connector_state *conn_state)
> >> +			   const struct drm_connector_state *conn_state,
> >> +			   const bool force_ycbcr420)
> >>  {
> >>  	struct drm_connector *connector = conn_state->connector;
> >>  	struct drm_i915_private *i915 = to_i915(connector->dev);
> >>  	const struct drm_display_mode *adjusted_mode =
> >>  		&crtc_state->hw.adjusted_mode;
> >>  
> >> -	if (!drm_mode_is_420_only(&connector->display_info, adjusted_mode))
> >> +	if (!(drm_mode_is_420_only(&connector->display_info, adjusted_mode) ||
> >> +			(force_ycbcr420 &&
> >> +			drm_mode_is_420_also(&connector->display_info, adjusted_mode))))
> >>  		return 0;
> >>  
> > This function I think we just want to throw out and roll something
> > a bit better.
> >
> > Something like this I believe should work nicely:
> >
> > intel_hdmi_compute_output_format()
> > {
> > 	if (drm_mode_is_420_only())
> > 		crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
> > 	else
> > 		crtc_state->output_format = INTEL_OUTPUT_FORMAT_RGB;
> >
> > 	ret = intel_hdmi_compute_clock();
> > 	if (ret) {
> > 		if (crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR420)
> > 			return ret;
> >
> > 		crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
> >
> > 		ret = intel_hdmi_compute_clock()
> > 		if (ret)
> > 			return ret;
> > 	}
> >
> > 	return 0;
> > }
> 
> Can you give clarification on the 3 checks coming in between intel_hdmi_ycbcr420_config and intel_hdmi_compute_clock?
> 
> I guess this can be done before:
> 
> pipe_config->has_audio =
>         intel_hdmi_has_audio(encoder, pipe_config, conn_state);
> 
> This one behaves differently whether or not RGB or YCbCr is used, but I guess does not change the required clock speed? I'm unsure about this however. If it has no effect on the clock I would call it after intel_hdmi_compute_clock:
> 
> pipe_config->limited_color_range =
>         intel_hdmi_limited_color_range(pipe_config, conn_state);
> 
> I don't know what this actually does, but it doesn't seem to have to do something with color encoding so, like the has_audio check, it can be done before deciding on RGB or YCbCr420? Correct me if I'm wrong:

limited_color_rage and has_audio we can do after the
output_format/clock stuff.

So basically I'm thinking the result should look like:

...
ret = intel_hdmi_compute_output_format(...);
if (ret)
	return ret;

if (crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR420) {
	ret = intel_pch_panel_fitting(...);
	if (ret)
		return ret;
}

crtc_state->limited_color_range = intel_hdmi_limited_color_range(...);

crtc_state->has_audio = intel_hdmi_has_audio(...);
...

Or I guess has_audio could be the first thing before
intel_hdmi_compute_output_format(). Doesn't really matter atm. There
may be some linkage between audio/clocks/etc. that we should be thinking
about which may dictate what the order should be. But since we're not
checking any of that anyway you don't have to worry about it right
now.

> 
> if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))
>         pipe_config->has_pch_encoder = true;

This one doesn't really matter as long as it's done somewhere. We could
just move it somewhere quite early so it doesn't confuse people so much.
Just after the DRM_MODE_FLAG_DBLSCAN check could be a sane spot for it.

> 
> > assuming we make intel_hdmi_compute_clock() check whether 420 output
> > is actually supported.
> 
> Currently it's check ycbcr420 then set. This would turn this around. Check first is more logical for my brain however.
> 
> what about something like this?
> 
> intel_hdmi_compute_output_format()
> {
>     if (drm_mode_is_420_only())
>         crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
>     else
>         crtc_state->output_format = INTEL_OUTPUT_FORMAT_RGB;
> 
>     ret = intel_hdmi_compute_clock();
>     if (ret) {
>         if (crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR420 ||
>                 !drm_mode_is_420_also() ||
>                 !connector->ycbcr_420_allowed)
>             return ret;
> 
>         crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
> 
>         ret = intel_hdmi_compute_clock()
>         if (ret)
>             return ret;
>     }
> 
>     return 0;
> }

Looks mostly OK. But I think we need a ycbcr_420_allowed check for the
420_only case too.

> 
> > Could roll a small helper for that. Something along these lines perhaps:
> > static bool intel_hdmi_ycbcr_420_supported()
> > {
> > 	return connector->ycbcr_420_allowed &&
> > 	       (drm_mode_is_420_only() || drm_mode_is_420_also());
> > }
> >
> > The intel_pch_panel_fitting() call should probably just be hoisted
> > into intel_hdmi_compute_config() after we've called the new
> > intel_hdmi_compute_output_format().
> >
> > I think a three patch series is probably what we want for this:
> > patch 1: extract intel_hdmi_mode_clock_valid() without 420_also handling
> > patch 2: introduce intel_hdmi_compute_output_format() without 420_also handling
> > patch 3: drop in the 420_also handling everywhere
> >
> > That way if there's any regression due to the 420_also stuff at least
> > we won't have to revert the whole thing, and can then more easily work
> > on fixing whatever needs fixing.
> >
> >>  	if (!connector->ycbcr_420_allowed) {
> >> @@ -2126,7 +2148,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
> >>  	struct drm_display_mode *adjusted_mode = &pipe_config->hw.adjusted_mode;
> >>  	struct drm_connector *connector = conn_state->connector;
> >>  	struct drm_scdc *scdc = &connector->display_info.hdmi.scdc;
> >> -	int ret;
> >> +	int ret, ret_saved;
> >>  
> >>  	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLSCAN)
> >>  		return -EINVAL;
> >> @@ -2141,7 +2163,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
> >>  	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLCLK)
> >>  		pipe_config->pixel_multiplier = 2;
> >>  
> >> -	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state);
> >> +	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, false);
> >>  	if (ret)
> >>  		return ret;
> >>  
> >> @@ -2155,8 +2177,26 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
> >>  		intel_hdmi_has_audio(encoder, pipe_config, conn_state);
> >>  
> >>  	ret = intel_hdmi_compute_clock(encoder, pipe_config);
> >> -	if (ret)
> >> -		return ret;
> >> +	if (ret) {
> >> +		ret_saved = ret;
> >> +
> >> +		ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, true);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		if (pipe_config->output_format != INTEL_OUTPUT_FORMAT_YCBCR420)
> >> +			return ret_saved;
> >> +
> >> +		pipe_config->limited_color_range =
> >> +			intel_hdmi_limited_color_range(pipe_config, conn_state);
> >> +
> >> +		if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))
> >> +			pipe_config->has_pch_encoder = true;
> >> +
> >> +		ret = intel_hdmi_compute_clock(encoder, pipe_config);
> >> +		if (ret)
> >> +			return ret;
> >> +	}
> >>  
> >>  	if (conn_state->picture_aspect_ratio)
> >>  		adjusted_mode->picture_aspect_ratio =
> >> -- 
> >> 2.25.1
> >>
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel
