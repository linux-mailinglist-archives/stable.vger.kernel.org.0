Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768C0146901
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 14:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgAWN1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 08:27:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:15397 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgAWN1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 08:27:11 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 05:27:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="229827766"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 23 Jan 2020 05:27:08 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 23 Jan 2020 15:27:07 +0200
Date:   Thu, 23 Jan 2020 15:27:07 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Detect overflow in calculating
 dumb buffer size
Message-ID: <20200123132707.GK13686@intel.com>
References: <20200123125934.1401755-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200123125934.1401755-1-chris@chris-wilson.co.uk>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 12:59:34PM +0000, Chris Wilson wrote:
> To multiply 2 u32 numbers to generate a u64 in C requires a bit of
> forewarning for the compiler.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Ramalingam C <ramalingam.c@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_gem.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 0a20083321a3..ff79da5657f8 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -265,7 +265,10 @@ i915_gem_dumb_create(struct drm_file *file,
>  						    DRM_FORMAT_MOD_LINEAR))
>  		args->pitch = ALIGN(args->pitch, 4096);
>  
> -	args->size = args->pitch * args->height;
> +	if (args->pitch < args->width)
> +		return -EINVAL;
> +
> +	args->size = mul_u32_u32(args->pitch, args->height);

I thought something would have checked these against the mode_config
fb limits already. But can't see code like that anywhere. Maybe we
should just do that in the core?

>  
>  	mem_type = INTEL_MEMORY_SYSTEM;
>  	if (HAS_LMEM(to_i915(dev)))
> -- 
> 2.25.0
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
