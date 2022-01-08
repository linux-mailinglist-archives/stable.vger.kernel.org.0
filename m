Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3325F488413
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiAHOrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 09:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiAHOrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 09:47:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A0C06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 06:47:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B03C60BBA
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 14:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFDAC36AE9;
        Sat,  8 Jan 2022 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641653259;
        bh=tv9egGmruaVrmN+/wvL5EyFc/bi25ftLr+GrCPuB1hY=;
        h=Subject:To:Cc:From:Date:From;
        b=dsP/WI63BId4whbTn0JKwCMlInvKXNf9LdoBrB1QofiQYMESo5uMswIynUxsr3FOt
         yL84WLIdkc82f33uY8VWjG++RqbFvoOMhpBMqgMAdGpIodBBB/i8gho/fu+FhLSAYr
         VWDjDVx60pBpj7yBSiu9Ajv07UTze4gkVuRWdc60=
Subject: FAILED: patch "[PATCH] drm/amdgpu: disable runpm if we are the primary adapter" failed to apply to 5.15-stable tree
To:     alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 08 Jan 2022 15:47:36 +0100
Message-ID: <164165325654138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b95dc06af3e683d6b7ddbbae178b2b2a21ee8b2b Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Wed, 22 Dec 2021 22:57:16 -0500
Subject: [PATCH] drm/amdgpu: disable runpm if we are the primary adapter

If we are the primary adapter (i.e., the one used by the firwmare
framebuffer), disable runtime pm.  This fixes a regression caused
by commit 55285e21f045 which results in the displays waking up
shortly after they go to sleep due to the device coming out of
runtime suspend and sending a hotplug uevent.

v2: squash in reworked fix from Evan

Fixes: 55285e21f045 ("fbdev/efifb: Release PCI device's runtime PM ref during FB destroy")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=215203
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1840
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index b85b67a88a3d..7d67aec6f4a2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1077,6 +1077,7 @@ struct amdgpu_device {
 	bool                            runpm;
 	bool                            in_runpm;
 	bool                            has_pr3;
+	bool                            is_fw_fb;
 
 	bool                            pm_sysfs_en;
 	bool                            ucode_sysfs_en;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 86ca80da9eea..99370bdd8c5b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -39,6 +39,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/suspend.h>
 #include <linux/cc_platform.h>
+#include <linux/fb.h>
 
 #include "amdgpu.h"
 #include "amdgpu_irq.h"
@@ -1890,6 +1891,26 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 
 static const struct drm_driver amdgpu_kms_driver;
 
+static bool amdgpu_is_fw_framebuffer(resource_size_t base,
+				     resource_size_t size)
+{
+	bool found = false;
+#if IS_REACHABLE(CONFIG_FB)
+	struct apertures_struct *a;
+
+	a = alloc_apertures(1);
+	if (!a)
+		return false;
+
+	a->ranges[0].base = base;
+	a->ranges[0].size = size;
+
+	found = is_firmware_framebuffer(a);
+	kfree(a);
+#endif
+	return found;
+}
+
 static int amdgpu_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
@@ -1898,6 +1919,8 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	unsigned long flags = ent->driver_data;
 	int ret, retry = 0, i;
 	bool supports_atomic = false;
+	bool is_fw_fb;
+	resource_size_t base, size;
 
 	/* skip devices which are owned by radeon */
 	for (i = 0; i < ARRAY_SIZE(amdgpu_unsupported_pciidlist); i++) {
@@ -1966,6 +1989,10 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	}
 #endif
 
+	base = pci_resource_start(pdev, 0);
+	size = pci_resource_len(pdev, 0);
+	is_fw_fb = amdgpu_is_fw_framebuffer(base, size);
+
 	/* Get rid of things like offb */
 	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &amdgpu_kms_driver);
 	if (ret)
@@ -1978,6 +2005,7 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	adev->dev  = &pdev->dev;
 	adev->pdev = pdev;
 	ddev = adev_to_drm(adev);
+	adev->is_fw_fb = is_fw_fb;
 
 	if (!supports_atomic)
 		ddev->driver_features &= ~DRIVER_ATOMIC;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 651c7abfde03..09ad17944eb2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -206,6 +206,12 @@ int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 			adev->runpm = true;
 			break;
 		}
+		/* XXX: disable runtime pm if we are the primary adapter
+		 * to avoid displays being re-enabled after DPMS.
+		 * This needs to be sorted out and fixed properly.
+		 */
+		if (adev->is_fw_fb)
+			adev->runpm = false;
 		if (adev->runpm)
 			dev_info(adev->dev, "Using BACO for runtime pm\n");
 	}

