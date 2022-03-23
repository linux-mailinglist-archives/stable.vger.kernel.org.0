Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8C4E54E2
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 16:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbiCWPKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 11:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238443AbiCWPKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 11:10:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDD0E03D
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648048151; x=1679584151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=shoRowFg1yK7IIvq/zXYPsuOfhD8hfo5h8WB7Jh4cdk=;
  b=kg5dVRF+8WHu9LtZnmHVDsiQLR0oaWeXVuBzmIP6DIazd5vY1wF0Q5x4
   uSlHIAIiY4pK0edRa7pcyhc/OmXWY2pQbX+oE0lZlc7KtsMtqVfnflcBE
   GuIlb/sa2EsKthYpM6+tNv2Kxibj0fQCt/L9H3SHBgVEFT97awlDjyl/p
   glwTVsSijyO16xIeObzKghhwLWVIIQ0S4DctvXbkt3mEfOELjsaeDsMT6
   BAtOGYAK13PJ2ZvvqgWXcHXh4FQMP4Om/nmBV3ADjIBUg3dVAI4Wnw/iS
   ej7xRsGDwRb1Vwrd1Jvi8g/kJou5kvEndZVrxZssBe6PPOaz48wjaUePa
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="258321103"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="258321103"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 08:09:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="552518780"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.61])
  by fmsmga007.fm.intel.com with SMTP; 23 Mar 2022 08:09:08 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 23 Mar 2022 17:09:07 +0200
Date:   Wed, 23 Mar 2022 17:09:07 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, Shawn C Lee <shawn.c.lee@intel.com>
Subject: Re: [PATCH] drm/edid: fix CEA extension byte #3 parsing
Message-ID: <Yjs4E5gl3KZoUOBR@intel.com>
References: <20220323100438.1757295-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220323100438.1757295-1-jani.nikula@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 12:04:38PM +0200, Jani Nikula wrote:
> Only an EDID CEA extension has byte #3, while the CTA DisplayID Data
> Block does not. Don't interpret bogus data for color formats.

I think what we might want eventually is a cleaner split between
the CTA data blocks vs. the rest of the EDID CTA ext block. Only
the former is relevant for DisplayID.

But for a bugfix we want to keep it simple.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> 
> For most displays it's probably an unlikely scenario you'd have a CTA
> DisplayID Data Block without a CEA extension, but they do exist.
> 
> Fixes: e28ad544f462 ("drm/edid: parse CEA blocks embedded in DisplayID")
> Cc: <stable@vger.kernel.org> # v4.15
> Cc: Shawn C Lee <shawn.c.lee@intel.com>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> 
> ---
> 
> commit e28ad544f462 was merged in v5.3, but it has Cc: stable for v4.15.
> 
> This is also fixed in my CEA data block iteration series [1], but we'll
> want the simple fix for stable first.
> 
> Hum, CTA is formerly CEA, I and the code seem to use both, should we use
> only one or the other?

And before CEA it was called EIA (IIRC). Dunno if we also use that name
somewhere.

If someone cares enough I guess we could rename everything to "cta".

> 
> [1] https://patchwork.freedesktop.org/series/101659/
> ---
>  drivers/gpu/drm/drm_edid.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 561f53831e29..ccf7031a6797 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -5187,10 +5187,14 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
>  
>  	/* The existence of a CEA block should imply RGB support */
>  	info->color_formats = DRM_COLOR_FORMAT_RGB444;
> -	if (edid_ext[3] & EDID_CEA_YCRCB444)
> -		info->color_formats |= DRM_COLOR_FORMAT_YCBCR444;
> -	if (edid_ext[3] & EDID_CEA_YCRCB422)
> -		info->color_formats |= DRM_COLOR_FORMAT_YCBCR422;
> +
> +	/* CTA DisplayID Data Block does not have byte #3 */
> +	if (edid_ext[0] == CEA_EXT) {
> +		if (edid_ext[3] & EDID_CEA_YCRCB444)
> +			info->color_formats |= DRM_COLOR_FORMAT_YCBCR444;
> +		if (edid_ext[3] & EDID_CEA_YCRCB422)
> +			info->color_formats |= DRM_COLOR_FORMAT_YCBCR422;
> +	}
>  
>  	if (cea_db_offsets(edid_ext, &start, &end))
>  		return;
> -- 
> 2.30.2

-- 
Ville Syrjälä
Intel
