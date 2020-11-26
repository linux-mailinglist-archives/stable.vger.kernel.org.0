Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F42C2C56AD
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 15:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389944AbgKZOI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 09:08:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:28971 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388291AbgKZOI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 09:08:28 -0500
IronPort-SDR: RtKnTLAhZXdJnbnQFVH6xfmCqbInYfs+DRTqLfsmdWscAeAOSvqjmEEV2invTX/mAh73/Nf8jN
 ljneLEbrMC9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="236419276"
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="236419276"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 06:08:27 -0800
IronPort-SDR: 9KuBSnl1FVO9DCadtC0W/v3sgX9kkFYWUYMVfQTHWxPjvB5k+b818A985hngegNRzX+VbmGsEN
 LyZgBcHwnj4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="371291717"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 26 Nov 2020 06:08:25 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 26 Nov 2020 16:08:24 +0200
Date:   Thu, 26 Nov 2020 16:08:24 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Jason Ekstrand <jason@jlekstrand.net>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9
Message-ID: <20201126140824.GC6112@intel.com>
References: <20201126105539.2661-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201126105539.2661-1-chris@chris-wilson.co.uk>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 10:55:39AM +0000, Chris Wilson wrote:
> Ville noticed that the last mocs entry is used unconditionally by the HW
> when it performs cache evictions, and noted that while the value is not
> meant to be writable by the driver, we should program it to a reasonable
> value nevertheless.
> 
> As it turns out, we can change the value of mocs:63 and the value we
> were programming into it would cause hard hangs in conjunction with
> atomic operations.
> 
> Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2707
> Fixes: 3bbaba0ceaa2 ("drm/i915: Added Programming of the MOCS")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Jason Ekstrand <jason@jlekstrand.net>
> Cc: <stable@vger.kernel.org> # v4.3+
> ---
>  drivers/gpu/drm/i915/gt/intel_mocs.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
> index 254873e1646e..6ae512847f64 100644
> --- a/drivers/gpu/drm/i915/gt/intel_mocs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
> @@ -131,7 +131,10 @@ static const struct drm_i915_mocs_entry skl_mocs_table[] = {
>  	GEN9_MOCS_ENTRIES,
>  	MOCS_ENTRY(I915_MOCS_CACHED,
>  		   LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
> -		   L3_3_WB)
> +		   L3_3_WB),
> +	MOCS_ENTRY(63,

Wonder if we should give these magic MOCS entries actual names?

Anyways, matches my reading of the spec
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> +		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
> +		   L3_1_UC)
>  };
>  
>  /* NOTE: the LE_TGT_CACHE is not used on Broxton */
> -- 
> 2.20.1

-- 
Ville Syrjälä
Intel
