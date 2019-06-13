Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4423843E2C
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfFMPsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:48:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:12151 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731743AbfFMJZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 05:25:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 02:25:03 -0700
X-ExtLoop1: 1
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga001.jf.intel.com with SMTP; 13 Jun 2019 02:25:00 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 13 Jun 2019 12:24:59 +0300
Date:   Thu, 13 Jun 2019 12:24:59 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Blubberbub@protonmail.com,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 1/4] drm/i915: Don't clobber M/N values during fastset
 check
Message-ID: <20190613092459.GV5942@intel.com>
References: <20190612130801.2085-1-ville.syrjala@linux.intel.com>
 <20190612172423.25231-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190612172423.25231-1-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 08:24:23PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We're now calling intel_pipe_config_compare(..., true) uncoditionally
> which means we're always going clobber the calculated M/N values with
> the old values if the fuzzy M/N check passes. That causes problems
> because the fuzzy check allows for a huge difference in the values.
> 
> I'm actually tempted to just make the M/N checks exact, but that might
> prevent fastboot from kicking in when people want it. So for now let's
> overwrite the computed values with the old values only if decide to skip
> the modeset.
> 
> v2: Copy has_drrs along with M/N M2/N2 values
> 
> Cc: stable@vger.kernel.org
> Cc: Blubberbub@protonmail.com
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Blubberbub@protonmail.com
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110782
> Fixes: d19f958db23c ("drm/i915: Enable fastset for non-boot modesets.")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Looks like also
https://bugs.freedesktop.org/show_bug.cgi?id=110675

> ---
>  drivers/gpu/drm/i915/intel_display.c | 36 +++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 1b1ddb48ca7a..3d8ed1cf0ab7 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -12299,9 +12299,6 @@ intel_compare_link_m_n(const struct intel_link_m_n *m_n,
>  			      m2_n2->gmch_m, m2_n2->gmch_n, !adjust) &&
>  	    intel_compare_m_n(m_n->link_m, m_n->link_n,
>  			      m2_n2->link_m, m2_n2->link_n, !adjust)) {
> -		if (adjust)
> -			*m2_n2 = *m_n;
> -
>  		return true;
>  	}
>  
> @@ -13433,6 +13430,33 @@ static int calc_watermark_data(struct intel_atomic_state *state)
>  	return 0;
>  }
>  
> +static void intel_crtc_check_fastset(struct intel_crtc_state *old_crtc_state,
> +				     struct intel_crtc_state *new_crtc_state)
> +{
> +	struct drm_i915_private *dev_priv =
> +		to_i915(new_crtc_state->base.crtc->dev);
> +
> +	if (!intel_pipe_config_compare(dev_priv, old_crtc_state,
> +				       new_crtc_state, true))
> +		return;
> +
> +	new_crtc_state->base.mode_changed = false;
> +	new_crtc_state->update_pipe = true;
> +
> +	/*
> +	 * If we're not doing the full modeset we want to
> +	 * keep the current M/N values as they may be
> +	 * sufficiently different to the computed values
> +	 * to cause problems.
> +	 *
> +	 * FIXME: should really copy more fuzzy state here
> +	 */
> +	new_crtc_state->fdi_m_n = old_crtc_state->fdi_m_n;
> +	new_crtc_state->dp_m_n = old_crtc_state->dp_m_n;
> +	new_crtc_state->dp_m2_n2 = old_crtc_state->dp_m2_n2;
> +	new_crtc_state->has_drrs = old_crtc_state->has_drrs;
> +}
> +
>  /**
>   * intel_atomic_check - validate state object
>   * @dev: drm device
> @@ -13474,11 +13498,7 @@ static int intel_atomic_check(struct drm_device *dev,
>  		if (ret)
>  			goto fail;
>  
> -		if (intel_pipe_config_compare(dev_priv, old_crtc_state,
> -					      new_crtc_state, true)) {
> -			new_crtc_state->base.mode_changed = false;
> -			new_crtc_state->update_pipe = true;
> -		}
> +		intel_crtc_check_fastset(old_crtc_state, new_crtc_state);
>  
>  		if (needs_modeset(&new_crtc_state->base))
>  			any_ms = true;
> -- 
> 2.21.0

-- 
Ville Syrjälä
Intel
