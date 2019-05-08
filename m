Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4225717634
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 12:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfEHKqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 06:46:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:47235 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbfEHKqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 06:46:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 03:46:11 -0700
X-ExtLoop1: 1
Received: from faerberc-mobl.ger.corp.intel.com (HELO [10.252.63.220]) ([10.252.63.220])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 03:46:10 -0700
Subject: Re: [PATCH 1/2] drm/i915: Fix fastset vs. pfit on/off on HSW EDP
 transcoder
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <20190425162906.5242-1-ville.syrjala@linux.intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <8c07fb94-ab18-b371-5cff-7e071e3a31c7@linux.intel.com>
Date:   Wed, 8 May 2019 12:46:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425162906.5242-1-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 25-04-2019 om 18:29 schreef Ville Syrjala:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> On HSW the pipe A panel fitter lives inside the display power well,
> and the input MUX for the EDP transcoder needs to be configured
> appropriately to route the data through the power well as needed.
> Changing the MUX setting is not allowed while the pipe is active,
> so we need to force a full modeset whenever we need to change it.
>
> Currently we may end up doing a fastset which won't change the
> MUX settings, but it will drop the power well reference, and that
> kills the pipe.
>
> Cc: stable@vger.kernel.org
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Fixes: d19f958db23c ("drm/i915: Enable fastset for non-boot modesets.")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c  |  9 +++++++++
>  drivers/gpu/drm/i915/intel_pipe_crc.c | 13 ++++++++++---
>  2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index c67f165b466c..691c9a929164 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -12133,6 +12133,7 @@ intel_pipe_config_compare(struct drm_i915_private *dev_priv,
>  			  struct intel_crtc_state *pipe_config,
>  			  bool adjust)
>  {
> +	struct intel_crtc *crtc = to_intel_crtc(current_config->base.crtc);
>  	bool ret = true;
>  	bool fixup_inherited = adjust &&
>  		(current_config->base.mode.private_flags & I915_MODE_FLAG_INHERITED) &&
> @@ -12354,6 +12355,14 @@ intel_pipe_config_compare(struct drm_i915_private *dev_priv,
>  		PIPE_CONF_CHECK_X(gmch_pfit.pgm_ratios);
>  	PIPE_CONF_CHECK_X(gmch_pfit.lvds_border_bits);
>  
> +	/*
> +	 * Changing the EDP transcoder input mux
> +	 * (A_ONOFF vs. A_ON) requires a full modeset.
> +	 */
> +	if (IS_HASWELL(dev_priv) && crtc->pipe == PIPE_A &&
> +	    current_config->cpu_transcoder == TRANSCODER_EDP)
> +		PIPE_CONF_CHECK_BOOL(pch_pfit.enabled);

I guess it depends if we want to make it a blocker or not..

> +
>  	if (!adjust) {
>  		PIPE_CONF_CHECK_I(pipe_src_w);
>  		PIPE_CONF_CHECK_I(pipe_src_h);
> diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
> index e94b5b1bc1b7..e7c7be4911c1 100644
> --- a/drivers/gpu/drm/i915/intel_pipe_crc.c
> +++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
> @@ -311,10 +311,17 @@ intel_crtc_crc_setup_workarounds(struct intel_crtc *crtc, bool enable)
>  	pipe_config->base.mode_changed = pipe_config->has_psr;
>  	pipe_config->crc_enabled = enable;
>  
> -	if (IS_HASWELL(dev_priv) && crtc->pipe == PIPE_A) {
> +	if (IS_HASWELL(dev_priv) &&
> +	    pipe_config->base.active && crtc->pipe == PIPE_A &&
> +	    pipe_config->cpu_transcoder == TRANSCODER_EDP) {
> +		bool old_need_power_well = pipe_config->pch_pfit.enabled ||
> +			pipe_config->pch_pfit.force_thru;
> +		bool new_need_power_well = pipe_config->pch_pfit.enabled ||
> +			enable;
> +
>  		pipe_config->pch_pfit.force_thru = enable;
> -		if (pipe_config->cpu_transcoder == TRANSCODER_EDP &&
> -		    pipe_config->pch_pfit.enabled != enable)
> +
> +		if (old_need_power_well != new_need_power_well)
>  			pipe_config->base.connectors_changed = true;

Could we get rid of this logic and set mode_changed instead?

Ah, I see that is done in 2/2, much less surprises then. :)

In that case, for both:

Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

