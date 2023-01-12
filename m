Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B16667E7D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 19:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbjALS5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 13:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238687AbjALS5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 13:57:06 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2095712AE3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 10:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673548160; x=1705084160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=J0iL4rgix2mw0Wk4Bh4WpBm6DrHW+PsG8OlOTt+T2Gw=;
  b=YAeQIcZi2H9GgrwUu57iMr0B7IH2oZsc1Gsbkb4tdmIFpEvNnMSbNnrw
   zUvpZ/RmZCszIny3viNQWJl6abZpk1l0zwTXrbytBd1CAqU4m9vIQrP5f
   2G4J7bOi7COKwADNmxd/XhLfbbVCTYpR+1sIC35JiBm0/bEmvER1OsWx1
   8AiNNXGyWHQXPxG3hQn46S5HbdV89fWcJXu1Gn4ETApq6uN5OL9acWPZl
   REcBxbVCbd5vb7NXdp/3rLHpldMmaC4pdyOI7Qi4QIJe+FxC0kgKRNrzz
   Oa6gyPo6ZSb6Gtb1helLNzooKVYUxFH6QPOc0uu1InJSAOs9u5OEtj85g
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="311638260"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="311638260"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 10:29:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="688436443"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="688436443"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.55])
  by orsmga008.jf.intel.com with SMTP; 12 Jan 2023 10:29:16 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 12 Jan 2023 20:29:15 +0200
Date:   Thu, 12 Jan 2023 20:29:15 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Drew Davenport <ddavenport@chromium.org>
Subject: Re: [PATCH] drm/i915: Reject < 1x1 pixel plane source size
Message-ID: <Y8BRe4DUUsRou4uN@intel.com>
References: <20230112152145.1117-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230112152145.1117-1-ville.syrjala@linux.intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 05:21:45PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We don't have proper sub-pixel coordinate support (some platforms
> simply can't do it, for others we've not implemented it). This
> can cause us to treat a < 1 pixel source width/height as zero
> which is not valid for the hardware, and can also cause a div
> by zero in some cases.
> 
> Refuse < 1x1 plane source size to avoid these problems.
> 
> Cc: stable@vger.kernel.org
> Cc: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
> Reported-by: Drew Davenport <ddavenport@chromium.org>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
> The other option would be to clamp the source size to >=1x1 pixels,
> but dunno if that has any real benefits.
> 
>  drivers/gpu/drm/i915/display/intel_atomic_plane.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_atomic_plane.c b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
> index 10e1fc9d0698..c6e43d684458 100644
> --- a/drivers/gpu/drm/i915/display/intel_atomic_plane.c
> +++ b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
> @@ -921,6 +921,21 @@ int intel_atomic_plane_check_clipping(struct intel_plane_state *plane_state,
>  	 */
>  	plane_state->uapi.visible = drm_rect_clip_scaled(src, dst, clip);
>  
> +	/*
> +	 * Avoid zero source size when we later
> +	 * discard the fractional coords.
> +	 *
> +	 * FIXME add proper sub-pixel coordinate handling
> +	 * for platforms/planes that support it.
> +	 */
> +	if (plane_state->uapi.visible &&
> +	    (drm_rect_width(src) < 0x10000 || drm_rect_height(src) < 0x10000)) {
> +		drm_dbg_kms(&i915->drm, "Plane source must be at least 1x1 pixels\n");
> +		drm_rect_debug_print("src: ", src, true);
> +		drm_rect_debug_print("dst: ", dst, false);
> +		return -EINVAL;
> +	}

Scratch that. Went with Drew's original patch instead.

> +
>  	drm_rect_rotate_inv(src, fb->width << 16, fb->height << 16, rotation);
>  
>  	if (!can_position && plane_state->uapi.visible &&
> -- 
> 2.38.2

-- 
Ville Syrjälä
Intel
