Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E55126BA7
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbfLSSzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbfLSSzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EC6024686;
        Thu, 19 Dec 2019 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781706;
        bh=8lf+bvqxmeTkyo+Jri7kTp9DHiOIK0LeB435rMQ/SCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wb1RnXllbyM5VgeCu+ctzG02hLIzQdXxPg/TFVB/Qqsnj+Ei+XTP2CwPydHp/CX6h
         OfmoYbqKK+26EofVWBqeVjH4aVUFALCvBZZbhmwqvqzbwUd/08ErziIEM0UaD0y86y
         5Ou7LVIP2TyHwAr7j+35EWrE1rczQKn75EXU/c+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.4 48/80] drm/mgag200: Add workaround for HW that does not support startadd
Date:   Thu, 19 Dec 2019 19:34:40 +0100
Message-Id: <20191219183116.739455056@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 1591fadf857cdbaf2baa55e421af99a61354713c upstream.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20191126101529.20356-4-tzimmermann@suse.de
[drop debugfs_init callback - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_drv.c |   35 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/mgag200/mgag200_drv.h |    3 ++
 2 files changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -30,6 +30,8 @@ module_param_named(modeset, mgag200_mode
 static struct drm_driver driver;
 
 static const struct pci_device_id pciidlist[] = {
+	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_VENDOR_ID_SUN, 0x4852, 0, 0,
+		G200_SE_A | MGAG200_FLAG_HW_BUG_NO_STARTADD},
 	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_A },
 	{ PCI_VENDOR_ID_MATROX, 0x524, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_B },
 	{ PCI_VENDOR_ID_MATROX, 0x530, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_EV },
@@ -63,6 +65,35 @@ static const struct file_operations mgag
 	DRM_VRAM_MM_FILE_OPERATIONS
 };
 
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
@@ -74,7 +105,9 @@ static struct drm_driver driver = {
 	.major = DRIVER_MAJOR,
 	.minor = DRIVER_MINOR,
 	.patchlevel = DRIVER_PATCHLEVEL,
-	DRM_GEM_VRAM_DRIVER
+	.dumb_create = mgag200_driver_dumb_create,
+	.dumb_map_offset = drm_gem_vram_driver_dumb_mmap_offset,
+	.gem_prime_mmap = drm_gem_prime_mmap,
 };
 
 static struct pci_driver mgag200_pci_driver = {
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -159,6 +159,9 @@ enum mga_type {
 	G200_EW3,
 };
 
+/* HW does not handle 'startadd' field correct. */
+#define MGAG200_FLAG_HW_BUG_NO_STARTADD	(1ul << 8)
+
 #define MGAG200_TYPE_MASK	(0x000000ff)
 #define MGAG200_FLAG_MASK	(0x00ffff00)
 


