Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211A334EC8
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 19:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfFDR3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 13:29:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:25328 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFDR3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 13:29:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 10:29:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,550,1549958400"; 
   d="scan'208";a="181630918"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga002.fm.intel.com with SMTP; 04 Jun 2019 10:29:37 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 04 Jun 2019 20:29:36 +0300
Date:   Tue, 4 Jun 2019 20:29:36 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915/dsi: Use a fuzzy check for burst mode clock
 check
Message-ID: <20190604172936.GH5942@intel.com>
References: <20190524174028.21659-1-hdegoede@redhat.com>
 <20190524174028.21659-2-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190524174028.21659-2-hdegoede@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 07:40:28PM +0200, Hans de Goede wrote:
> Prior to this commit we fail to init the DSI panel on the GPD MicroPC:
> https://www.indiegogo.com/projects/gpd-micropc-6-inch-handheld-industry-laptop#/
> 
> The problem is intel_dsi_vbt_init() failing with the following error:
> *ERROR* Burst mode freq is less than computed
> 
> The pclk in the VBT panel modeline is 70000, together with 24 bpp and
> 4 lines this results in a bitrate value of 70000 * 24 / 4 = 420000.
> But the target_burst_mode_freq in the VBT is 418000.
> 
> This commit works around this problem by adding an intel_fuzzy_clock_check
> when target_burst_mode_freq < bitrate and setting target_burst_mode_freq to
> bitrate when that checks succeeds, fixing the panel not working.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/gpu/drm/i915/intel_dsi_vbt.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dsi_vbt.c b/drivers/gpu/drm/i915/intel_dsi_vbt.c
> index 022bf59418df..a2a9b9d0eeaa 100644
> --- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
> +++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
> @@ -895,6 +895,17 @@ bool intel_dsi_vbt_init(struct intel_dsi *intel_dsi, u16 panel_id)
>  		if (mipi_config->target_burst_mode_freq) {
>  			u32 bitrate = intel_dsi_bitrate(intel_dsi);
>  
> +			/*
> +			 * Sometimes the VBT contains a slightly lower clock,
> +			 * then the bitrate we have calculated, in this case
> +			 * just replace it with the calculated bitrate.
> +			 */
> +			if (mipi_config->target_burst_mode_freq < bitrate &&
> +			    intel_fuzzy_clock_check(
> +					mipi_config->target_burst_mode_freq,
> +					bitrate))
> +				mipi_config->target_burst_mode_freq = bitrate;

Maybe should squash these patches together to make the stable
backport less painful?

Anyways, seems OK to me.
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> +
>  			if (mipi_config->target_burst_mode_freq < bitrate) {
>  				DRM_ERROR("Burst mode freq is less than computed\n");
>  				return false;
> -- 
> 2.21.0

-- 
Ville Syrjälä
Intel
