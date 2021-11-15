Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70820451048
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbhKOSpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239230AbhKOSnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:43:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056D563358;
        Mon, 15 Nov 2021 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999547;
        bh=RiV6o3xlqct9o0S+qUsjUOp1C4FLjZPFFtwZBcvw6mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyS2Fw6FSSqGYbsaFQuxTwBSOfWnJC15W4iZK76T+JjAkDDGiHq0FgwRBIs9ISaRA
         f3pJqC0c3oVw2RIoq2MZuzR0NsPOr5ksG8/g9ePF7zyzHYIC5HDt0Vut4ZNrkfCMf4
         N6j12rAOaAXFkswnjtlK8ruEtjl5Lp6I3/Lu7djU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Imre Deak <imre.deak@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 337/849] fbdev/efifb: Release PCI devices runtime PM ref during FB destroy
Date:   Mon, 15 Nov 2021 17:57:00 +0100
Message-Id: <20211115165431.634942587@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 55285e21f04517939480966164a33898c34b2af2 ]

Atm the EFI FB platform driver gets a runtime PM reference for the
associated GFX PCI device during probing the EFI FB platform device and
releases it only when the platform device gets unbound.

When fbcon switches to the FB provided by the PCI device's driver (for
instance i915/drmfb), the EFI FB will get only unregistered without the
EFI FB platform device getting unbound, keeping the runtime PM reference
acquired during the platform device probing. This reference will prevent
the PCI driver from runtime suspending the device.

Fix this by releasing the RPM reference from the EFI FB's destroy hook,
called when the FB gets unregistered.

While at it assert that pm_runtime_get_sync() didn't fail.

v2:
- Move pm_runtime_get_sync() before register_framebuffer() to avoid its
  race wrt. efifb_destroy()->pm_runtime_put(). (Daniel)
- Assert that pm_runtime_get_sync() didn't fail.
- Clarify commit message wrt. platform/PCI device/driver and driver
  removal vs. device unbinding.

Fixes: a6c0fd3d5a8b ("efifb: Ensure graphics device for efifb stays at PCI D0")
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch> (v1)
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210809133146.2478382-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/efifb.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 8ea8f079cde26..edca3703b9640 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -47,6 +47,8 @@ static bool use_bgrt = true;
 static bool request_mem_succeeded = false;
 static u64 mem_flags = EFI_MEMORY_WC | EFI_MEMORY_UC;
 
+static struct pci_dev *efifb_pci_dev;	/* dev with BAR covering the efifb */
+
 static struct fb_var_screeninfo efifb_defined = {
 	.activate		= FB_ACTIVATE_NOW,
 	.height			= -1,
@@ -243,6 +245,9 @@ static inline void efifb_show_boot_graphics(struct fb_info *info) {}
 
 static void efifb_destroy(struct fb_info *info)
 {
+	if (efifb_pci_dev)
+		pm_runtime_put(&efifb_pci_dev->dev);
+
 	if (info->screen_base) {
 		if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
 			iounmap(info->screen_base);
@@ -333,7 +338,6 @@ ATTRIBUTE_GROUPS(efifb);
 
 static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
 
-static struct pci_dev *efifb_pci_dev;	/* dev with BAR covering the efifb */
 static struct resource *bar_resource;
 static u64 bar_offset;
 
@@ -569,17 +573,22 @@ static int efifb_probe(struct platform_device *dev)
 		pr_err("efifb: cannot allocate colormap\n");
 		goto err_groups;
 	}
+
+	if (efifb_pci_dev)
+		WARN_ON(pm_runtime_get_sync(&efifb_pci_dev->dev) < 0);
+
 	err = register_framebuffer(info);
 	if (err < 0) {
 		pr_err("efifb: cannot register framebuffer\n");
-		goto err_fb_dealoc;
+		goto err_put_rpm_ref;
 	}
 	fb_info(info, "%s frame buffer device\n", info->fix.id);
-	if (efifb_pci_dev)
-		pm_runtime_get_sync(&efifb_pci_dev->dev);
 	return 0;
 
-err_fb_dealoc:
+err_put_rpm_ref:
+	if (efifb_pci_dev)
+		pm_runtime_put(&efifb_pci_dev->dev);
+
 	fb_dealloc_cmap(&info->cmap);
 err_groups:
 	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
@@ -603,8 +612,6 @@ static int efifb_remove(struct platform_device *pdev)
 	unregister_framebuffer(info);
 	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
 	framebuffer_release(info);
-	if (efifb_pci_dev)
-		pm_runtime_put(&efifb_pci_dev->dev);
 
 	return 0;
 }
-- 
2.33.0



