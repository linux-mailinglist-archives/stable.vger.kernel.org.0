Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16215E5E6F
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIVJXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiIVJXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:23:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C695046D8E
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663838629; x=1695374629;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=pAA6CKJgflHgoCD9eQJgqzEcuMrs8//acQTd+tjbx5E=;
  b=Djqsoob6IfsNa6CtwiOMrJVGAYeAufSwKSHdUb0s6cy6s9AOgc+I/Lwj
   CRpBDb/iRGZxuE+fmt84VT+rH6fl7UCFKKHx6bylwGf4A9Kl33oFsBdKa
   grp28w3CGi49Dt0churjpiN1wy6y0x2m+awY7XE8nmOvTMiWZmi62IF94
   Kq8+v7d0qJ2FboeBov+4/lYDpqkZnjNZ07v/rP7MyL4BxgoOsj/u3Hz4X
   W46MIONaUzGep892EA55O+seQE4U4wwTCQk0DRAlgoQr2LF5jC9b+hUQo
   8nMANoLFVlgpLKNqiA6f8yKEEvJbGQY1FxwlCJ02LCG8a0SlQr0kEOFeY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="283300870"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="283300870"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 02:23:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="688225609"
Received: from akoska-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.36.156])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 02:23:41 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Daniel J Blueman <daniel@quora.org>, stable@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
In-Reply-To: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
Date:   Thu, 22 Sep 2022 12:23:23 +0300
Message-ID: <87illf7ofo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Cc: Rafael

On Wed, 21 Sep 2022, Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
> The force_probe protection actively avoids the probe of i915 to
> manage a device that is currently under development. It is a nice
> protection for future users when getting a new platform but using
> some older kernel.
>
> However, when we avoid the probe we don't take back the registration
> of the device. We cannot give up the registration anyway since we can
> have multiple devices present. For instance an integrated and a discrete
> one.
>
> When this scenario occurs, the user will not be able to change any
> of the runtime pm configuration of the unmanaged device. So, it will
> be blocked in D0 state wasting power. This is specially bad in the
> case where we have a discrete platform attached, but the user is
> able to fully use the integrated one for everything else.
>
> So, let's put the protected and unmanaged device in D3. So we can
> save some power.
>
> Reported-by: Daniel J Blueman <daniel@quora.org>
> Cc: stable@vger.kernel.org
> Cc: Daniel J Blueman <daniel@quora.org>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Anshuman Gupta <anshuman.gupta@intel.com>
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_pci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
> index 77e7df21f539..fc3e7c69af2a 100644
> --- a/drivers/gpu/drm/i915/i915_pci.c
> +++ b/drivers/gpu/drm/i915/i915_pci.c
> @@ -25,6 +25,7 @@
>  #include <drm/drm_color_mgmt.h>
>  #include <drm/drm_drv.h>
>  #include <drm/i915_pciids.h>
> +#include <linux/pm_runtime.h>
>  
>  #include "gt/intel_gt_regs.h"
>  #include "gt/intel_sa_media.h"
> @@ -1304,6 +1305,7 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	struct intel_device_info *intel_info =
>  		(struct intel_device_info *) ent->driver_data;
> +	struct device *kdev = &pdev->dev;
>  	int err;
>  
>  	if (intel_info->require_force_probe &&
> @@ -1314,6 +1316,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  			 "module parameter or CONFIG_DRM_I915_FORCE_PROBE=%04x configuration option,\n"
>  			 "or (recommended) check for kernel updates.\n",
>  			 pdev->device, pdev->device, pdev->device);
> +
> +		/* Let's not waste power if we are not managing the device */
> +		pm_runtime_use_autosuspend(kdev);
> +		pm_runtime_allow(kdev);
> +		pm_runtime_put_autosuspend(kdev);
> +
>  		return -ENODEV;
>  	}

-- 
Jani Nikula, Intel Open Source Graphics Center
