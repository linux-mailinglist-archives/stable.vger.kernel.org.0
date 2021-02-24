Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EC6323962
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 10:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhBXJYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 04:24:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:52060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234595AbhBXJXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 04:23:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 61704AE72;
        Wed, 24 Feb 2021 09:23:07 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: [PATCH v4] drm: Use USB controller's DMA mask when importing dmabufs
Date:   Wed, 24 Feb 2021 10:23:04 +0100
Message-Id: <20210224092304.29932-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB devices cannot perform DMA and hence have no dma_mask set in their
device structure. Therefore importing dmabuf into a USB-based driver
fails, which breaks joining and mirroring of display in X11.

For USB devices, pick the associated USB controller as attachment device.
This allows the DRM import helpers to perform the DMA setup. If the DMA
controller does not support DMA transfers, we're out of luck and cannot
import. Our current USB-based DRM drivers don't use DMA, so the actual
DMA device is not important.

Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
instance of struct drm_driver.

Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.

v4:
	* implement workaround with USB helper functions (Greg)
	* use struct usb_device->bus->sysdev as DMA device (Takashi)
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
Cc: <stable@vger.kernel.org> # v5.10+
---
 drivers/gpu/drm/drm_prime.c        | 38 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
 drivers/gpu/drm/udl/udl_drv.c      |  2 +-
 drivers/usb/core/usb.c             | 29 +++++++++++++++++++++++
 include/drm/drm_gem_shmem_helper.h | 13 ++++++++++
 include/drm/drm_prime.h            |  5 ++++
 include/linux/usb.h                |  3 +++
 7 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 2a54f86856af..15c82088ab4c 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -29,6 +29,7 @@
 #include <linux/export.h>
 #include <linux/dma-buf.h>
 #include <linux/rbtree.h>
+#include <linux/usb.h>
 
 #include <drm/drm.h>
 #include <drm/drm_drv.h>
@@ -1055,3 +1056,40 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
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
+	struct device *dmadev;
+	struct drm_gem_object *obj;
+
+	if (!dev_is_usb(dev->dev))
+		return ERR_PTR(-ENODEV);
+	udev = interface_to_usbdev(to_usb_interface(dev->dev));
+
+	dmadev = usb_get_dma_device(udev);
+	if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
+		return ERR_PTR(-ENODEV);
+
+	obj = drm_gem_prime_import_dev(dev, dma_buf, dmadev);
+
+	put_device(dmadev);
+
+	return obj;
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
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 8f07b0516100..253bf71780fd 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -748,6 +748,35 @@ void usb_put_intf(struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(usb_put_intf);
 
+/**
+ * usb_get_dma_device - acquire a reference on the usb device's DMA endpoint
+ * @udev: usb device
+ *
+ * While a USB device cannot perform DMA operations by itself, many USB
+ * controllers can. A call to usb_get_dma_device() returns the DMA endpoint
+ * for the given USB device, if any. The returned device structure should be
+ * released with put_device().
+ *
+ * Returns: A reference to the usb device's DMA endpoint; or NULL if none
+ *          exists.
+ */
+struct device *usb_get_dma_device(struct usb_device *udev)
+{
+	struct device *dmadev;
+
+	if (!udev->bus)
+		return NULL;
+
+	dmadev = get_device(udev->bus->sysdev);
+	if (!dmadev || !dmadev->dma_mask) {
+		put_device(dmadev);
+		return NULL;
+	}
+
+	return dmadev;
+}
+EXPORT_SYMBOL_GPL(usb_get_dma_device);
+
 /*			USB device locking
  *
  * USB devices and interfaces are locked using the semaphore in their
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
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7d72c4e0713c..a9bd698c8839 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -711,6 +711,7 @@ struct usb_device {
 	unsigned use_generic_driver:1;
 };
 #define	to_usb_device(d) container_of(d, struct usb_device, dev)
+#define dev_is_usb(d)	((d)->bus == &usb_bus_type)
 
 static inline struct usb_device *interface_to_usbdev(struct usb_interface *intf)
 {
@@ -746,6 +747,8 @@ extern int usb_lock_device_for_reset(struct usb_device *udev,
 extern int usb_reset_device(struct usb_device *dev);
 extern void usb_queue_reset_device(struct usb_interface *dev);
 
+extern struct device *usb_get_dma_device(struct usb_device *udev);
+
 #ifdef CONFIG_ACPI
 extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable);
-- 
2.30.1

