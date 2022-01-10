Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E76D4891D4
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbiAJHgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41982 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbiAJHdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A76E861193;
        Mon, 10 Jan 2022 07:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87390C36AE9;
        Mon, 10 Jan 2022 07:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800012;
        bh=o6nv9/Tyj/hIo8Msvl8jf2YXPBM04YwucowcgRwdQXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WJazGq4GCmg+1uceW+asQWZQF+l2AdjARu4HaZ03477vkdV+2y4FZjY7Tqk9FI9S
         GWPoFaYsUuo899CY8eF5Bz9YAkSGSo2krcvdu4Xm1L905E3M/Fhhg2hAcfU+kfrRPc
         As/z1m3coTfQixyxXxgUItPl6a1a0+xJLmIFf0lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 49/72] drm/amdgpu: disable runpm if we are the primary adapter
Date:   Mon, 10 Jan 2022 08:23:26 +0100
Message-Id: <20220110071823.203140239@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit b95dc06af3e683d6b7ddbbae178b2b2a21ee8b2b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h     |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   28 ++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    6 ++++++
 3 files changed, 35 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1069,6 +1069,7 @@ struct amdgpu_device {
 	bool                            runpm;
 	bool                            in_runpm;
 	bool                            has_pr3;
+	bool                            is_fw_fb;
 
 	bool                            pm_sysfs_en;
 	bool                            ucode_sysfs_en;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -38,6 +38,7 @@
 #include <drm/drm_probe_helper.h>
 #include <linux/mmu_notifier.h>
 #include <linux/suspend.h>
+#include <linux/fb.h>
 
 #include "amdgpu.h"
 #include "amdgpu_irq.h"
@@ -1246,6 +1247,26 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 
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
@@ -1254,6 +1275,8 @@ static int amdgpu_pci_probe(struct pci_d
 	unsigned long flags = ent->driver_data;
 	int ret, retry = 0;
 	bool supports_atomic = false;
+	bool is_fw_fb;
+	resource_size_t base, size;
 
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
@@ -1310,6 +1333,10 @@ static int amdgpu_pci_probe(struct pci_d
 	}
 #endif
 
+	base = pci_resource_start(pdev, 0);
+	size = pci_resource_len(pdev, 0);
+	is_fw_fb = amdgpu_is_fw_framebuffer(base, size);
+
 	/* Get rid of things like offb */
 	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &amdgpu_kms_driver);
 	if (ret)
@@ -1322,6 +1349,7 @@ static int amdgpu_pci_probe(struct pci_d
 	adev->dev  = &pdev->dev;
 	adev->pdev = pdev;
 	ddev = adev_to_drm(adev);
+	adev->is_fw_fb = is_fw_fb;
 
 	if (!supports_atomic)
 		ddev->driver_features &= ~DRIVER_ATOMIC;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -206,6 +206,12 @@ int amdgpu_driver_load_kms(struct amdgpu
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


