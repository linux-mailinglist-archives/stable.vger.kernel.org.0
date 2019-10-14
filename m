Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD29D5D37
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 10:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfJNIPP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Oct 2019 04:15:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:10635 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbfJNIPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 04:15:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 01:15:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,295,1566889200"; 
   d="scan'208";a="207923278"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.39.77])
  by fmsmga001.fm.intel.com with ESMTP; 14 Oct 2019 01:15:12 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Masami Ichikawa <masami256@gmail.com>,
        Torsten <freedesktop201910@liggy.de>
Subject: Re: [PATCH] drm/i915: Favor last VBT child device with conflicting AUX ch/DDC pin
In-Reply-To: <20191011202030.8829-1-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20191011202030.8829-1-ville.syrjala@linux.intel.com>
Date:   Mon, 14 Oct 2019 11:16:08 +0300
Message-ID: <878spnd9o7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Oct 2019, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> The first come first served apporoach to handling the VBT
> child device AUX ch conflicts has backfired. We have machines
> in the wild where the VBT specifies both port A eDP and
> port E DP (in that order) with port E being the real one.
>
> So let's try to flip the preference around and let the last
> child device win once again.

I think there will be legitimate cases where we need first come first
served. Oh well, another VBT misery to tackle in the future.

Acked-by: Jani Nikula <jani.nikula@intel.com>


>
> Cc: stable@vger.kernel.org
> Cc: Jani Nikula <jani.nikula@intel.com>
> Cc: Masami Ichikawa <masami256@gmail.com>
> Tested-by: Torsten <freedesktop201910@liggy.de>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111966
> Fixes: 36a0f92020dc ("drm/i915/bios: make child device order the priority order")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_bios.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
> index 9628b485b179..f0307b04cc13 100644
> --- a/drivers/gpu/drm/i915/display/intel_bios.c
> +++ b/drivers/gpu/drm/i915/display/intel_bios.c
> @@ -1270,7 +1270,7 @@ static void sanitize_ddc_pin(struct drm_i915_private *dev_priv,
>  		DRM_DEBUG_KMS("port %c trying to use the same DDC pin (0x%x) as port %c, "
>  			      "disabling port %c DVI/HDMI support\n",
>  			      port_name(port), info->alternate_ddc_pin,
> -			      port_name(p), port_name(port));
> +			      port_name(p), port_name(p));
>  
>  		/*
>  		 * If we have multiple ports supposedly sharing the
> @@ -1278,9 +1278,14 @@ static void sanitize_ddc_pin(struct drm_i915_private *dev_priv,
>  		 * port. Otherwise they share the same ddc bin and
>  		 * system couldn't communicate with them separately.
>  		 *
> -		 * Give child device order the priority, first come first
> -		 * served.
> +		 * Give inverse child device order the priority,
> +		 * last one wins. Yes, there are real machines
> +		 * (eg. Asrock B250M-HDV) where VBT has both
> +		 * port A and port E with the same AUX ch and
> +		 * we must pick port E :(
>  		 */
> +		info = &dev_priv->vbt.ddi_port_info[p];
> +
>  		info->supports_dvi = false;
>  		info->supports_hdmi = false;
>  		info->alternate_ddc_pin = 0;
> @@ -1316,7 +1321,7 @@ static void sanitize_aux_ch(struct drm_i915_private *dev_priv,
>  		DRM_DEBUG_KMS("port %c trying to use the same AUX CH (0x%x) as port %c, "
>  			      "disabling port %c DP support\n",
>  			      port_name(port), info->alternate_aux_channel,
> -			      port_name(p), port_name(port));
> +			      port_name(p), port_name(p));
>  
>  		/*
>  		 * If we have multiple ports supposedlt sharing the
> @@ -1324,9 +1329,14 @@ static void sanitize_aux_ch(struct drm_i915_private *dev_priv,
>  		 * port. Otherwise they share the same aux channel
>  		 * and system couldn't communicate with them separately.
>  		 *
> -		 * Give child device order the priority, first come first
> -		 * served.
> +		 * Give inverse child device order the priority,
> +		 * last one wins. Yes, there are real machines
> +		 * (eg. Asrock B250M-HDV) where VBT has both
> +		 * port A and port E with the same AUX ch and
> +		 * we must pick port E :(
>  		 */
> +		info = &dev_priv->vbt.ddi_port_info[p];
> +
>  		info->supports_dp = false;
>  		info->alternate_aux_channel = 0;
>  	}

-- 
Jani Nikula, Intel Open Source Graphics Center
