Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4452B2C587F
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 16:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391333AbgKZPuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 10:50:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:59994 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbgKZPuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 10:50:14 -0500
IronPort-SDR: dYNvmBViASNL2wIqGSF5Y0V5IR6jr4eXzRYZJ4xJStlN7O7DK79ffK8Ev0pnC77S7iXzcriMkP
 5SpXCpTHli0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9817"; a="257007542"
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="257007542"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 07:50:13 -0800
IronPort-SDR: BnBTSG+uF5JgA2gwSndjWIHPdhsWZxdcUN9sS74/1IxTgJqwrdonmYtSKbP+IN+lImdUsuUucI
 zati/nRaPsDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="365857613"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga002.fm.intel.com with SMTP; 26 Nov 2020 07:50:10 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 26 Nov 2020 17:50:10 +0200
Date:   Thu, 26 Nov 2020 17:50:10 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Jason Ekstrand <jason@jlekstrand.net>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9
Message-ID: <20201126155010.GD6112@intel.com>
References: <20201126105539.2661-1-chris@chris-wilson.co.uk>
 <20201126140841.1982-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201126140841.1982-1-chris@chris-wilson.co.uk>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 02:08:41PM +0000, Chris Wilson wrote:
> Ville noticed that the last mocs entry is used unconditionally by the HW
> when it performs cache evictions, and noted that while the value is not
> meant to be writable by the driver, we should program it to a reasonable
> value nevertheless.
> 
> As it turns out, we can change the value of mocs:63 and the value we
> were programming into it would cause hard hangs in conjunction with
> atomic operations.
> 
> v2: Add details from bspec about how it is used by HW
> 
> Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2707
> Fixes: 3bbaba0ceaa2 ("drm/i915: Added Programming of the MOCS")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Jason Ekstrand <jason@jlekstrand.net>
> Cc: <stable@vger.kernel.org> # v4.3+
> ---
>  drivers/gpu/drm/i915/gt/intel_mocs.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
> index 254873e1646e..26cedde80476 100644
> --- a/drivers/gpu/drm/i915/gt/intel_mocs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
> @@ -131,7 +131,19 @@ static const struct drm_i915_mocs_entry skl_mocs_table[] = {
>  	GEN9_MOCS_ENTRIES,
>  	MOCS_ENTRY(I915_MOCS_CACHED,
>  		   LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
> -		   L3_3_WB)
> +		   L3_3_WB),
> +
> +	/*
> +	 * mocs:63
> +	 * - used by the L3 for all its evictions.
> +	 *   Thus it is expected to allow LLC cacheability to enable coherent
> +	 *   flows to be maintained.
> +	 * - used to force L3 uncachable cycles.
> +	 *   Thus it is expected to make the surce L3 uncacheable.

"surce"?

> +	 */
> +	MOCS_ENTRY(63,
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
