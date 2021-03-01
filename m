Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D051327AD7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhCAJcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:32:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:39086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233930AbhCAJcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 04:32:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D802DAAC5;
        Mon,  1 Mar 2021 09:31:32 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: [PATCH v6] drm: Use USB controller's DMA mask when importing dmabufs
Date:   Mon,  1 Mar 2021 10:31:27 +0100
Message-Id: <20210301093127.11028-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

v6:
	* implement workaround in DRM drivers and hold reference to
	  DMA device while USB device is in use
	* remove dev_is_usb() (Greg)
	* collapse USB helper into usb_intf_get_dma_device() (Alan)
	* integrate Daniel's TODO statement (Daniel)
	* fix typos (Greg)
v5:
	* provide a helper for USB interfaces (Alan)
	* add FIXME item to documentation and TODO list (Daniel)
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
Tested-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 Documentation/gpu/todo.rst      | 21 +++++++++++++++++++++
 drivers/gpu/drm/tiny/gm12u320.c | 25 +++++++++++++++++++++++++
 drivers/gpu/drm/udl/udl_drv.c   | 17 +++++++++++++++++
 drivers/gpu/drm/udl/udl_drv.h   |  1 +
 drivers/gpu/drm/udl/udl_main.c  |  9 +++++++++
 drivers/usb/core/usb.c          | 32 ++++++++++++++++++++++++++++++++
 include/linux/usb.h             |  2 ++
 7 files changed, 107 insertions(+)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index 0631b9b323d5..fdfd6a1081ec 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -571,6 +571,27 @@ Contact: Daniel Vetter
 
 Level: Intermediate
 
+Remove automatic page mapping from dma-buf importing
+----------------------------------------------------
+
+When importing dma-bufs, the dma-buf and PRIME frameworks automatically map
+imported pages into the importer's DMA area. drm_gem_prime_fd_to_handle() and
+drm_gem_prime_handle_to_fd() require that importers call dma_buf_attach()
+even if they never do actual device DMA, but only CPU access through
+dma_buf_vmap(). This is a problem for USB devices, which do not support DMA
+operations.
+
+To fix the issue, automatic page mappings should be removed from the
+buffer-sharing code. Fixing this is a bit more involved, since the import/export
+cache is also tied to &drm_gem_object.import_attach. Meanwhile we paper over
+this problem for USB devices by fishing out the USB host controller device, as
+long as that supports DMA. Otherwise importing can still needlessly fail.
+
+Contact: Thomas Zimmermann <tzimmermann@suse.de>, Daniel Vetter
+
+Level: Advanced
+
+
 Better Testing
 ==============
 
diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
index 0b4f4f2af1ef..48b5b06f70e8 100644
--- a/drivers/gpu/drm/tiny/gm12u320.c
+++ b/drivers/gpu/drm/tiny/gm12u320.c
@@ -84,6 +84,7 @@ MODULE_PARM_DESC(eco_mode, "Turn on Eco mode (less bright, more silent)");
 
 struct gm12u320_device {
 	struct drm_device	         dev;
+	struct device                   *dmadev;
 	struct drm_simple_display_pipe   pipe;
 	struct drm_connector	         conn;
 	unsigned char                   *cmd_buf;
@@ -599,6 +600,22 @@ static const uint64_t gm12u320_pipe_modifiers[] = {
 	DRM_FORMAT_MOD_INVALID
 };
 
+/*
+ * FIXME: Dma-buf sharing requires DMA support by the importing device.
+ *        This function is a workaround to make USB devices work as well.
+ *        See todo.rst for how to fix the issue in the dma-buf framework.
+ */
+static struct drm_gem_object *gm12u320_gem_prime_import(struct drm_device *dev,
+							struct dma_buf *dma_buf)
+{
+	struct gm12u320_device *gm12u320 = to_gm12u320(dev);
+
+	if (!gm12u320->dmadev)
+		return ERR_PTR(-ENODEV);
+
+	return drm_gem_prime_import_dev(dev, dma_buf, gm12u320->dmadev);
+}
+
 DEFINE_DRM_GEM_FOPS(gm12u320_fops);
 
 static const struct drm_driver gm12u320_drm_driver = {
@@ -612,6 +629,7 @@ static const struct drm_driver gm12u320_drm_driver = {
 
 	.fops		 = &gm12u320_fops,
 	DRM_GEM_SHMEM_DRIVER_OPS,
+	.gem_prime_import = gm12u320_gem_prime_import,
 };
 
 static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
@@ -639,6 +657,10 @@ static int gm12u320_usb_probe(struct usb_interface *interface,
 	if (IS_ERR(gm12u320))
 		return PTR_ERR(gm12u320);
 
+	gm12u320->dmadev = usb_intf_get_dma_device(to_usb_interface(dev->dev));
+	if (!gm12u320->dmadev)
+		drm_warn(dev, "buffer sharing not supported"); /* not an error */
+
 	INIT_DELAYED_WORK(&gm12u320->fb_update.work, gm12u320_fb_update_work);
 	mutex_init(&gm12u320->fb_update.lock);
 
@@ -691,7 +713,10 @@ static int gm12u320_usb_probe(struct usb_interface *interface,
 static void gm12u320_usb_disconnect(struct usb_interface *interface)
 {
 	struct drm_device *dev = usb_get_intfdata(interface);
+	struct gm12u320_device *gm12u320 = to_gm12u320(dev);
 
+	put_device(gm12u320->dmadev);
+	gm12u320->dmadev = NULL;
 	drm_dev_unplug(dev);
 	drm_atomic_helper_shutdown(dev);
 }
diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index 9269092697d8..5703277c6f52 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -32,6 +32,22 @@ static int udl_usb_resume(struct usb_interface *interface)
 	return drm_mode_config_helper_resume(dev);
 }
 
+/*
+ * FIXME: Dma-buf sharing requires DMA support by the importing device.
+ *        This function is a workaround to make USB devices work as well.
+ *        See todo.rst for how to fix the issue in the dma-buf framework.
+ */
+static struct drm_gem_object *udl_driver_gem_prime_import(struct drm_device *dev,
+							  struct dma_buf *dma_buf)
+{
+	struct udl_device *udl = to_udl(dev);
+
+	if (!udl->dmadev)
+		return ERR_PTR(-ENODEV);
+
+	return drm_gem_prime_import_dev(dev, dma_buf, udl->dmadev);
+}
+
 DEFINE_DRM_GEM_FOPS(udl_driver_fops);
 
 static const struct drm_driver driver = {
@@ -40,6 +56,7 @@ static const struct drm_driver driver = {
 	/* GEM hooks */
 	.fops = &udl_driver_fops,
 	DRM_GEM_SHMEM_DRIVER_OPS,
+	.gem_prime_import = udl_driver_gem_prime_import,
 
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index 875e73551ae9..cc16a13316e4 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -50,6 +50,7 @@ struct urb_list {
 struct udl_device {
 	struct drm_device drm;
 	struct device *dev;
+	struct device *dmadev;
 
 	struct drm_simple_display_pipe display_pipe;
 
diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_main.c
index 0e2a376cb075..7c0338bcadea 100644
--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -315,6 +315,10 @@ int udl_init(struct udl_device *udl)
 
 	DRM_DEBUG("\n");
 
+	udl->dmadev = usb_intf_get_dma_device(to_usb_interface(dev->dev));
+	if (!udl->dmadev)
+		drm_warn(dev, "buffer sharing not supported"); /* not an error */
+
 	mutex_init(&udl->gem_lock);
 
 	if (!udl_parse_vendor_descriptor(udl)) {
@@ -349,6 +353,11 @@ int udl_init(struct udl_device *udl)
 
 int udl_drop_usb(struct drm_device *dev)
 {
+	struct udl_device *udl = to_udl(dev);
+
 	udl_free_urb_list(dev);
+	put_device(udl->dmadev);
+	udl->dmadev = NULL;
+
 	return 0;
 }
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 8f07b0516100..a566bb494e24 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -748,6 +748,38 @@ void usb_put_intf(struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(usb_put_intf);
 
+/**
+ * usb_intf_get_dma_device - acquire a reference on the usb interface's DMA endpoint
+ * @intf: the usb interface
+ *
+ * While a USB device cannot perform DMA operations by itself, many USB
+ * controllers can. A call to usb_intf_get_dma_device() returns the DMA endpoint
+ * for the given USB interface, if any. The returned device structure must be
+ * released with put_device().
+ *
+ * See also usb_get_dma_device().
+ *
+ * Returns: A reference to the usb interface's DMA endpoint; or NULL if none
+ *          exists.
+ */
+struct device *usb_intf_get_dma_device(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
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
+EXPORT_SYMBOL_GPL(usb_intf_get_dma_device);
+
 /*			USB device locking
  *
  * USB devices and interfaces are locked using the semaphore in their
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7d72c4e0713c..d6a41841b93e 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -746,6 +746,8 @@ extern int usb_lock_device_for_reset(struct usb_device *udev,
 extern int usb_reset_device(struct usb_device *dev);
 extern void usb_queue_reset_device(struct usb_interface *dev);
 
+extern struct device *usb_intf_get_dma_device(struct usb_interface *intf);
+
 #ifdef CONFIG_ACPI
 extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable);
-- 
2.30.1

