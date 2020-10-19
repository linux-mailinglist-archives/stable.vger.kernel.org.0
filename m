Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D258C2927E5
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 15:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgJSNI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 09:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgJSNI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 09:08:27 -0400
Received: from manul.sfritsch.de (manul.sfritsch.de [IPv6:2a01:4f8:172:195f:112::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F6FC0613CE
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 06:08:27 -0700 (PDT)
Date:   Mon, 19 Oct 2020 15:08:17 +0200 (CEST)
From:   Stefan Fritsch <sf@sfritsch.de>
To:     Chris Wilson <chris@chris-wilson.co.uk>
cc:     intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Force VT'd workarounds when running as a guest
 OS
In-Reply-To: <20201019101523.4145-1-chris@chris-wilson.co.uk>
Message-ID: <alpine.DEB.2.21.2010191506390.5579@manul.sfritsch.de>
References: <20201019101230.29860-1-chris@chris-wilson.co.uk> <20201019101523.4145-1-chris@chris-wilson.co.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Works for me and makes the fault messages disappear. Thanks.

Tested-by: Stefan Fritsch <sf@sfritsch.de>


On Mon, 19 Oct 2020, Chris Wilson wrote:

> If i915.ko is being used as a passthrough device, it does not know if
> the host is using intel_iommu. Mixing the iommu and gfx causing a few
> issues (such as scanout overfetch) which we need to workaround inside
> the driver, so if we detect we are running under a hypervisor, also
> assume the device access is being virtualised.
> 
> Reported-by: Stefan Fritsch <sf@sfritsch.de>
> Suggested-by: Stefan Fritsch <sf@sfritsch.de>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Stefan Fritsch <sf@sfritsch.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_drv.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 1a5729932c81..bcd8650603d8 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -33,6 +33,8 @@
>  #include <uapi/drm/i915_drm.h>
>  #include <uapi/drm/drm_fourcc.h>
>  
> +#include <asm/hypervisor.h>
> +
>  #include <linux/io-mapping.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-algo-bit.h>
> @@ -1760,7 +1762,9 @@ static inline bool intel_vtd_active(void)
>  	if (intel_iommu_gfx_mapped)
>  		return true;
>  #endif
> -	return false;
> +
> +	/* Running as a guest, we assume the host is enforcing VT'd */
> +	return !hypervisor_is_type(X86_HYPER_NATIVE);
>  }
>  
>  static inline bool intel_scanout_needs_vtd_wa(struct drm_i915_private *dev_priv)
> 
