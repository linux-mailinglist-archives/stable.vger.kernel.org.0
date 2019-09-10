Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63603AE880
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392889AbfIJKjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 06:39:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:16613 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392720AbfIJKjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 06:39:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 03:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385299218"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga006.fm.intel.com with ESMTP; 10 Sep 2019 03:39:50 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 241915C1E43; Tue, 10 Sep 2019 13:39:38 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Martin Peres <martin.peres@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/6] drm/i915: Perform GGTT restore much earlier during resume
In-Reply-To: <20190909110011.8958-4-chris@chris-wilson.co.uk>
References: <20190909110011.8958-1-chris@chris-wilson.co.uk> <20190909110011.8958-4-chris@chris-wilson.co.uk>
Date:   Tue, 10 Sep 2019 13:39:38 +0300
Message-ID: <87y2ywsadx.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> As soon as we re-enable the various functions within the HW, they may go
> off and read data via a GGTT offset. Hence, if we have not yet restored
> the GGTT PTE before then, they may read and even *write* random locations
> in memory.
>
> Detected by DMAR faults during resume.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Martin Peres <martin.peres@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gem/i915_gem_pm.c    | 3 ---
>  drivers/gpu/drm/i915/i915_drv.c           | 5 +++++
>  drivers/gpu/drm/i915/selftests/i915_gem.c | 6 ++++++
>  3 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pm.c b/drivers/gpu/drm/i915/gem/i915_gem_pm.c
> index b3993d24b83d..9b1129aaacfe 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_pm.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pm.c
> @@ -242,9 +242,6 @@ void i915_gem_resume(struct drm_i915_private *i915)
>  	mutex_lock(&i915->drm.struct_mutex);
>  	intel_uncore_forcewake_get(&i915->uncore, FORCEWAKE_ALL);
>  
> -	i915_gem_restore_gtt_mappings(i915);
> -	i915_gem_restore_fences(i915);
> -
>  	if (i915_gem_init_hw(i915))
>  		goto err_wedged;
>  
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index 7b2c81a8bbaa..1af4eba968c0 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -1877,6 +1877,11 @@ static int i915_drm_resume(struct drm_device *dev)
>  	if (ret)
>  		DRM_ERROR("failed to re-enable GGTT\n");
>  
> +	mutex_lock(&dev_priv->drm.struct_mutex);
> +	i915_gem_restore_gtt_mappings(dev_priv);
> +	i915_gem_restore_fences(dev_priv);
> +	mutex_unlock(&dev_priv->drm.struct_mutex);
> +
>  	intel_csr_ucode_resume(dev_priv);
>  
>  	i915_restore_state(dev_priv);
> diff --git a/drivers/gpu/drm/i915/selftests/i915_gem.c b/drivers/gpu/drm/i915/selftests/i915_gem.c
> index bb6dd54a6ff3..37593831b539 100644
> --- a/drivers/gpu/drm/i915/selftests/i915_gem.c
> +++ b/drivers/gpu/drm/i915/selftests/i915_gem.c
> @@ -118,6 +118,12 @@ static void pm_resume(struct drm_i915_private *i915)
>  	with_intel_runtime_pm(&i915->runtime_pm, wakeref) {
>  		intel_gt_sanitize(&i915->gt, false);
>  		i915_gem_sanitize(i915);
> +
> +		mutex_lock(&i915->drm.struct_mutex);
> +		i915_gem_restore_gtt_mappings(i915);
> +		i915_gem_restore_fences(i915);
> +		mutex_unlock(&i915->drm.struct_mutex);
> +
>  		i915_gem_resume(i915);
>  	}
>  }
> -- 
> 2.23.0
