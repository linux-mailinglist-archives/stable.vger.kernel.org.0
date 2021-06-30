Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686DF3B8096
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 12:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhF3KI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 06:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234150AbhF3KIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 06:08:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F6661D0C;
        Wed, 30 Jun 2021 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625047582;
        bh=avnkog7DAWHGE/DDPBwmxyAibvw4Gdlte4dEESCVyoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=udOpBZzVB4JN0HTHVvrO3eSvnwimfuvMyyr+nIaiE9fMU5868YxXBlpFGBWl+jvYl
         XNgb7Sg904LwLnqu4UWSmwKUnyd6PlkLPwPMARE8fgHpm6t1k4yt2JD9n5GJD0v7BE
         PcbmgK+YE/poI/xZfbc45WpiErOJU74fyjWXXbhE=
Date:   Wed, 30 Jun 2021 12:06:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        matthew.brost@intel.com, maarten.lankhorst@linux.intel.com,
        lucas.demarchi@intel.com, ville.syrjala@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] drm/i915: Drop all references to DRM IRQ midlayer
Message-ID: <YNxCHDGA+x2Xe9pM@kroah.com>
References: <20210630095228.6665-1-tzimmermann@suse.de>
 <20210630095228.6665-3-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630095228.6665-3-tzimmermann@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 11:52:28AM +0200, Thomas Zimmermann wrote:
> Remove all references to DRM's IRQ midlayer. i915 uses Linux' interrupt
> functions directly.
> 
> v2:
> 	* also remove an outdated comment
> 	* move IRQ fix into separate patch
> 	* update Fixes tag (Daniel)
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: b318b82455bd ("drm/i915: Nuke drm_driver irq vfuncs")
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.4+
> ---
>  drivers/gpu/drm/i915/i915_drv.c | 1 -
>  drivers/gpu/drm/i915/i915_irq.c | 5 -----
>  2 files changed, 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index 850b499c71c8..73de45472f60 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -42,7 +42,6 @@
>  #include <drm/drm_aperture.h>
>  #include <drm/drm_atomic_helper.h>
>  #include <drm/drm_ioctl.h>
> -#include <drm/drm_irq.h>
>  #include <drm/drm_managed.h>
>  #include <drm/drm_probe_helper.h>
>  
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 2203dca19895..1d4c683c9de9 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -33,7 +33,6 @@
>  #include <linux/sysrq.h>
>  
>  #include <drm/drm_drv.h>
> -#include <drm/drm_irq.h>
>  
>  #include "display/intel_de.h"
>  #include "display/intel_display_types.h"
> @@ -4564,10 +4563,6 @@ void intel_runtime_pm_enable_interrupts(struct drm_i915_private *dev_priv)
>  
>  bool intel_irqs_enabled(struct drm_i915_private *dev_priv)
>  {
> -	/*
> -	 * We only use drm_irq_uninstall() at unload and VT switch, so
> -	 * this is the only thing we need to check.
> -	 */
>  	return dev_priv->runtime_pm.irqs_enabled;
>  }
>  
> -- 
> 2.32.0
> 

How is this a stable-kernel-related fix?

thanks,

greg k-h
