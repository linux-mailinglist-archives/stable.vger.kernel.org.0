Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833EF322924
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 11:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhBWK73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 05:59:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:34452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230459AbhBWK71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 05:59:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9FF8AC1D;
        Tue, 23 Feb 2021 10:58:45 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Johan Hovold <johan@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH v3] drm: Use USB controller's DMA mask when importing dmabufs
Date:   Tue, 23 Feb 2021 11:58:42 +0100
Message-Id: <20210223105842.27011-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB devices cannot perform DMA and hence have no dma_mask set in their
device structure. Importing dmabuf into a USB-based driver fails, which
break joining and mirroring of display in X11.

For USB devices, pick the associated USB controller as attachment device,
so that it can perform DMA. If the DMa controller does not support DMA
transfers, we're aout of luck and cannot import.

Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
instance of struct drm_driver.

Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.

v3:
	* drop gem_create_object
	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
v2:
	* move fix to importer side (Christian, Daniel)
	* update SHMEM and CMA helpers for new PRIME callbacks

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org> # v5.10+
---
 drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
 drivers/gpu/drm/udl/udl_drv.c      |  2 +-
 include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
 include/drm/drm_prime.h            |  5 +++++
 5 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 2a54f86856af..9015850f2160 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -29,6 +29,7 @@
 #include <linux/export.h>
 #include <linux/dma-buf.h>
 #include <linux/rbtree.h>
+#include <linux/usb.h>

 #include <drm/drm.h>
 #include <drm/drm_drv.h>
@@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
 	dma_buf_put(dma_buf);
 }
 EXPORT_SYMBOL(drm_prime_gem_destroy);
+
+/**
+ * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
+ * @dev: drm_device to import into
+ * @dma_buf: dma-buf object to import
+ *
+ * This is an implementation of drm_gem_prime_import() for USB-based devices.
+ * USB devices cannot perform DMA directly. This function selects the USB host
+ * controller as DMA device instead. Drivers can use this as their
+ * &drm_driver.gem_prime_import implementation.
+ *
+ * See also drm_gem_prime_import().
+ */
+#ifdef CONFIG_USB
+struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
+						struct dma_buf *dma_buf)
+{
+	struct usb_device *udev;
+	struct device *usbhost;
+
+	if (dev->dev->bus != &usb_bus_type)
+		return ERR_PTR(-ENODEV);
+
+	udev = interface_to_usbdev(to_usb_interface(dev->dev));
+	if (!udev->bus)
+		return ERR_PTR(-ENODEV);
+
+	usbhost = udev->bus->controller;
+	if (!usbhost || !usbhost->dma_mask)
+		return ERR_PTR(-ENODEV);
+
+	return drm_gem_prime_import_dev(dev, dma_buf, usbhost);
+}
+EXPORT_SYMBOL(drm_gem_prime_import_usb);
+#endif
diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
index 0b4f4f2af1ef..99e7bd36a220 100644
--- a/drivers/gpu/drm/tiny/gm12u320.c
+++ b/drivers/gpu/drm/tiny/gm12u320.c
@@ -611,7 +611,7 @@ static const struct drm_driver gm12u320_drm_driver = {
 	.minor		 = DRIVER_MINOR,

 	.fops		 = &gm12u320_fops,
-	DRM_GEM_SHMEM_DRIVER_OPS,
+	DRM_GEM_SHMEM_DRIVER_OPS_USB,
 };

 static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index 9269092697d8..2db483b2b199 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -39,7 +39,7 @@ static const struct drm_driver driver = {

 	/* GEM hooks */
 	.fops = &udl_driver_fops,
-	DRM_GEM_SHMEM_DRIVER_OPS,
+	DRM_GEM_SHMEM_DRIVER_OPS_USB,

 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index 434328d8a0d9..09d12f632cad 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -162,4 +162,17 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_object *obj);
 	.gem_prime_mmap		= drm_gem_prime_mmap, \
 	.dumb_create		= drm_gem_shmem_dumb_create

+#ifdef CONFIG_USB
+/**
+ * DRM_GEM_SHMEM_DRIVER_OPS_USB - Default shmem GEM operations for USB devices
+ *
+ * This macro provides a shortcut for setting the shmem GEM operations in
+ * the &drm_driver structure. Drivers for USB-based devices should use this
+ * macro instead of &DRM_GEM_SHMEM_DRIVER_OPS.
+ */
+#define DRM_GEM_SHMEM_DRIVER_OPS_USB \
+	DRM_GEM_SHMEM_DRIVER_OPS, \
+	.gem_prime_import = drm_gem_prime_import_usb
+#endif
+
 #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
index 54f2c58305d2..b42e07edd9e6 100644
--- a/include/drm/drm_prime.h
+++ b/include/drm/drm_prime.h
@@ -110,4 +110,9 @@ int drm_prime_sg_to_page_array(struct sg_table *sgt, struct page **pages,
 int drm_prime_sg_to_dma_addr_array(struct sg_table *sgt, dma_addr_t *addrs,
 				   int max_pages);

+#ifdef CONFIG_USB
+struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
+						struct dma_buf *dma_buf);
+#endif
+
 #endif /* __DRM_PRIME_H__ */
--
2.30.1

