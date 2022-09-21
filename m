Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5C75C0565
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 19:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIURjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 13:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIURjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 13:39:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0553A2A88
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663781957; x=1695317957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bAcz2IxWNeTSEn4OYqfDJwBxxByUN4ILEORtNvdgOSQ=;
  b=nCevyCR0Ria7qv3W25hIoxZ7aVUjGHBD7J6Fjg8F+4gnfnLppM0lE9Qr
   De+YxCPquO0i0n/xlc9YNJAhAcsnTvnPofPajS/3WWuTHL4b25L++SCxQ
   mNbfKdYTa5EKJ6HTMlKusi81LTNhmlLnT5p3OuwA5Uu43hUScEatXH6kN
   av7oOVPmxYoYb8pmipFLOu4odVzwv0nXU3Zmi30NJ4by8Ntd2BFLmvmip
   vpcw42STccv8BIkHjaEwAipwHTpZChbbuH+CxYLVWIct9am3Z81qOHwTe
   uMdNbXGDPA8pQC2dAqPeyp0ZzrDaRKdj6A/bYBVFMS1pzEN4kIt5alOWA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300061482"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300061482"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 10:39:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="794769608"
Received: from kkpalani-mobl1.amr.corp.intel.com (HELO rdvivi-mobl4.intel.com) ([10.255.32.108])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 10:39:16 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Daniel J Blueman <daniel@quora.org>, stable@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>
Subject: [PATCH] drm/i915: Allow D3 when we are not actively managing a known PCI device.
Date:   Wed, 21 Sep 2022 13:39:14 -0400
Message-Id: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The force_probe protection actively avoids the probe of i915 to
manage a device that is currently under development. It is a nice
protection for future users when getting a new platform but using
some older kernel.

However, when we avoid the probe we don't take back the registration
of the device. We cannot give up the registration anyway since we can
have multiple devices present. For instance an integrated and a discrete
one.

When this scenario occurs, the user will not be able to change any
of the runtime pm configuration of the unmanaged device. So, it will
be blocked in D0 state wasting power. This is specially bad in the
case where we have a discrete platform attached, but the user is
able to fully use the integrated one for everything else.

So, let's put the protected and unmanaged device in D3. So we can
save some power.

Reported-by: Daniel J Blueman <daniel@quora.org>
Cc: stable@vger.kernel.org
Cc: Daniel J Blueman <daniel@quora.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/i915_pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 77e7df21f539..fc3e7c69af2a 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -25,6 +25,7 @@
 #include <drm/drm_color_mgmt.h>
 #include <drm/drm_drv.h>
 #include <drm/i915_pciids.h>
+#include <linux/pm_runtime.h>
 
 #include "gt/intel_gt_regs.h"
 #include "gt/intel_sa_media.h"
@@ -1304,6 +1305,7 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct intel_device_info *intel_info =
 		(struct intel_device_info *) ent->driver_data;
+	struct device *kdev = &pdev->dev;
 	int err;
 
 	if (intel_info->require_force_probe &&
@@ -1314,6 +1316,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "module parameter or CONFIG_DRM_I915_FORCE_PROBE=%04x configuration option,\n"
 			 "or (recommended) check for kernel updates.\n",
 			 pdev->device, pdev->device, pdev->device);
+
+		/* Let's not waste power if we are not managing the device */
+		pm_runtime_use_autosuspend(kdev);
+		pm_runtime_allow(kdev);
+		pm_runtime_put_autosuspend(kdev);
+
 		return -ENODEV;
 	}
 
-- 
2.37.2

