Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB8109C19
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 11:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfKZKPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 05:15:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:37148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727813AbfKZKPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 05:15:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55907B1B5;
        Tue, 26 Nov 2019 10:15:32 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, john.p.donnelly@oracle.com,
        kraxel@redhat.com, sam@ravnborg.org
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] drm/mgag200: Add workaround for HW that does not support 'startadd'
Date:   Tue, 26 Nov 2019 11:15:29 +0100
Message-Id: <20191126101529.20356-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191126101529.20356-1-tzimmermann@suse.de>
References: <20191126101529.20356-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's at least one system that does not interpret the value of
the device's 'startadd' field correctly, which leads to incorrectly
displayed scanout buffers. Always placing the active scanout buffer
at offset 0 works around the problem.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: John Donnelly <john.p.donnelly@oracle.com>
Tested-by: John Donnelly <john.p.donnelly@oracle.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with kunmap + unpin")
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "José Roberto de Souza" <jose.souza@intel.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.3+
Link: https://gitlab.freedesktop.org/drm/misc/issues/7
---
 drivers/gpu/drm/mgag200/mgag200_drv.c | 36 ++++++++++++++++++++++++++-
 drivers/gpu/drm/mgag200/mgag200_drv.h |  3 +++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.c b/drivers/gpu/drm/mgag200/mgag200_drv.c
index 397f8b0a9af8..d43951caeea0 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -30,6 +30,8 @@ module_param_named(modeset, mgag200_modeset, int, 0400);
 static struct drm_driver driver;
 
 static const struct pci_device_id pciidlist[] = {
+	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_VENDOR_ID_SUN, 0x4852, 0, 0,
+		G200_SE_A | MGAG200_FLAG_HW_BUG_NO_STARTADD},
 	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_A },
 	{ PCI_VENDOR_ID_MATROX, 0x524, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_B },
 	{ PCI_VENDOR_ID_MATROX, 0x530, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_EV },
@@ -60,6 +62,35 @@ static void mga_pci_remove(struct pci_dev *pdev)
 
 DEFINE_DRM_GEM_FOPS(mgag200_driver_fops);
 
+static bool mgag200_pin_bo_at_0(const struct mga_device *mdev)
+{
+	return mdev->flags & MGAG200_FLAG_HW_BUG_NO_STARTADD;
+}
+
+int mgag200_driver_dumb_create(struct drm_file *file,
+			       struct drm_device *dev,
+			       struct drm_mode_create_dumb *args)
+{
+	struct mga_device *mdev = dev->dev_private;
+	unsigned long pg_align;
+
+	if (WARN_ONCE(!dev->vram_mm, "VRAM MM not initialized"))
+		return -EINVAL;
+
+	pg_align = 0ul;
+
+	/*
+	 * Aligning scanout buffers to the size of the video ram forces
+	 * placement at offset 0. Works around a bug where HW does not
+	 * respect 'startadd' field.
+	 */
+	if (mgag200_pin_bo_at_0(mdev))
+		pg_align = PFN_UP(mdev->mc.vram_size);
+
+	return drm_gem_vram_fill_create_dumb(file, dev, &dev->vram_mm->bdev,
+					     pg_align, false, args);
+}
+
 static struct drm_driver driver = {
 	.driver_features = DRIVER_GEM | DRIVER_MODESET,
 	.load = mgag200_driver_load,
@@ -71,7 +102,10 @@ static struct drm_driver driver = {
 	.major = DRIVER_MAJOR,
 	.minor = DRIVER_MINOR,
 	.patchlevel = DRIVER_PATCHLEVEL,
-	DRM_GEM_VRAM_DRIVER
+	.debugfs_init = drm_vram_mm_debugfs_init,
+	.dumb_create = mgag200_driver_dumb_create,
+	.dumb_map_offset = drm_gem_vram_driver_dumb_mmap_offset,
+	.gem_prime_mmap = drm_gem_prime_mmap,
 };
 
 static struct pci_driver mgag200_pci_driver = {
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 4b4f9ce74a84..aa32aad222c2 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -150,6 +150,9 @@ enum mga_type {
 	G200_EW3,
 };
 
+/* HW does not handle 'startadd' field correct. */
+#define MGAG200_FLAG_HW_BUG_NO_STARTADD	(1ul << 8)
+
 #define MGAG200_TYPE_MASK	(0x000000ff)
 #define MGAG200_FLAG_MASK	(0x00ffff00)
 
-- 
2.23.0

