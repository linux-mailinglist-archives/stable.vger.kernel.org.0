Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB85E5CBD
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 09:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiIVH4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIVH4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 03:56:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B25357CE
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 00:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663833406; x=1695369406;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DHnshpJXgS0wLVRLy6Z4hikW5QAdGGxrmEDk2Isok7k=;
  b=nfZpuBiQYNOLSkdIc6tMYv4Xx0vH3G3fAVANei2ZdkgOG0CtgsPyAeBJ
   zk47mD62O0LYIba52xRftwBid/fKvEV2kPNxgmyJthEQVTz2ssfJ9M5wM
   bH7OPv1Cp21O7Pa2vD476SOoQmjprvGKe15T/w6mvkeg1ZnIoHrhV3CV8
   Y/YABeT0QAFTjJe8tJf4a4sxyteh6Q3OfIkrBPJOu8A2Wz+0zrMh1p3xY
   8Lx7/WHMTKciMGdQOea2eDrrLa+7mKp3nkUs1kESA0a+Lj70dI1R5J/al
   U9oLPVfKV2D9PSow5U3SH7+Zb8pWfvrvbP2sUFEUvdRf7enUVBGDKciYo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="280600324"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="280600324"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 00:56:08 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="688198629"
Received: from mmorri2-mobl.ger.corp.intel.com (HELO [10.213.205.83]) ([10.213.205.83])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 00:56:06 -0700
Message-ID: <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
Date:   Thu, 22 Sep 2022 08:56:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Daniel J Blueman <daniel@quora.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
Content-Language: en-US
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 21/09/2022 18:39, Rodrigo Vivi wrote:
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
>   drivers/gpu/drm/i915/i915_pci.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
> index 77e7df21f539..fc3e7c69af2a 100644
> --- a/drivers/gpu/drm/i915/i915_pci.c
> +++ b/drivers/gpu/drm/i915/i915_pci.c
> @@ -25,6 +25,7 @@
>   #include <drm/drm_color_mgmt.h>
>   #include <drm/drm_drv.h>
>   #include <drm/i915_pciids.h>
> +#include <linux/pm_runtime.h>
>   
>   #include "gt/intel_gt_regs.h"
>   #include "gt/intel_sa_media.h"
> @@ -1304,6 +1305,7 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   {
>   	struct intel_device_info *intel_info =
>   		(struct intel_device_info *) ent->driver_data;
> +	struct device *kdev = &pdev->dev;
>   	int err;
>   
>   	if (intel_info->require_force_probe &&
> @@ -1314,6 +1316,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   			 "module parameter or CONFIG_DRM_I915_FORCE_PROBE=%04x configuration option,\n"
>   			 "or (recommended) check for kernel updates.\n",
>   			 pdev->device, pdev->device, pdev->device);
> +
> +		/* Let's not waste power if we are not managing the device */
> +		pm_runtime_use_autosuspend(kdev);
> +		pm_runtime_allow(kdev);
> +		pm_runtime_put_autosuspend(kdev);

This sequence is black magic to me so can't really comment on the specifics. But in general, what I think I've figured out is, that the PCI core calls our runtime resume callback before probe:

local_pci_probe:
...
         /*
          * Unbound PCI devices are always put in D0, regardless of
          * runtime PM status.  During probe, the device is set to
          * active and the usage count is incremented.  If the driver
          * supports runtime PM, it should call pm_runtime_put_noidle(),
          * or any other runtime PM helper function decrementing the usage
          * count, in its probe routine and pm_runtime_get_noresume() in
          * its remove routine.
          */
         pm_runtime_get_sync(dev);
         pci_dev->driver = pci_drv;
         rc = pci_drv->probe(pci_dev, ddi->id);
         if (!rc)
                 return rc;
         if (rc < 0) {
                 pci_dev->driver = NULL;
                 pm_runtime_put_sync(dev);
                 return rc;
         }

And if probe fails it calls pm_runtime_put_sync which presumably does not provide the symmetry we need?

Anyway since I can't provide meaningful review I'll copy Imre since I think he worked in the area in the past. Just so more eyes is better.

Regards,

Tvrtko


> +
>   		return -ENODEV;
>   	}
>   
