Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C6F33B7AC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhCOOBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232729AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BE1664F66;
        Mon, 15 Mar 2021 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816758;
        bh=ETO2Tb0fCItQRUPThW3IMjun938x5hpGdHwEd+9Obqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyAi1Ra3TO/RfTVGNs5Win2KSSs334222OcccvDbmndsEZmBAI7WyuPovaSZGUbBc
         LCw9ddXT7/9PLEVvMsPqLRV2L5WqHNBWHzZVysXNkmJkSM6F4h9noTs7h1QEs0jznA
         amAHKHv8IxqApEEL8wFAISJpArQnsTFcrJMy2Q4A=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Christoph Hellwig <hch@lst.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.11 107/306] drm: Use USB controllers DMA mask when importing dmabufs
Date:   Mon, 15 Mar 2021 14:52:50 +0100
Message-Id: <20210315135511.262250714@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 659ab7a49cbebe0deffcbe1f9560e82006b21817 upstream.

USB devices cannot perform DMA and hence have no dma_mask set in their
device structure. Therefore importing dmabuf into a USB-based driver
fails, which breaks joining and mirroring of display in X11.

For USB devices, pick the associated USB controller as attachment device.
This allows the DRM import helpers to perform the DMA setup. If the DMA
controller does not support DMA transfers, we're out of luck and cannot
import. Our current USB-based DRM drivers don't use DMA, so the actual
DMA device is not important.

Tested by joining/mirroring displays of udl and radeon under Gnome/X11.

v8:
	* release dmadev if device initialization fails (Noralf)
	* fix commit description (Noralf)
v7:
	* fix use-before-init bug in gm12u320 (Dan)
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
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210303133229.3288-1-tzimmermann@suse.de
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/gpu/todo.rst      |   21 +++++++++++++++++++
 drivers/gpu/drm/tiny/gm12u320.c |   44 ++++++++++++++++++++++++++++++++--------
 drivers/gpu/drm/udl/udl_drv.c   |   17 +++++++++++++++
 drivers/gpu/drm/udl/udl_drv.h   |    1 
 drivers/gpu/drm/udl/udl_main.c  |   10 +++++++++
 drivers/usb/core/usb.c          |   32 +++++++++++++++++++++++++++++
 include/linux/usb.h             |    2 +
 7 files changed, 119 insertions(+), 8 deletions(-)

--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -594,6 +594,27 @@ Some of these date from the very introdu
 
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
 
--- a/drivers/gpu/drm/tiny/gm12u320.c
+++ b/drivers/gpu/drm/tiny/gm12u320.c
@@ -83,6 +83,7 @@ MODULE_PARM_DESC(eco_mode, "Turn on Eco
 
 struct gm12u320_device {
 	struct drm_device	         dev;
+	struct device                   *dmadev;
 	struct drm_simple_display_pipe   pipe;
 	struct drm_connector	         conn;
 	unsigned char                   *cmd_buf;
@@ -601,6 +602,22 @@ static const uint64_t gm12u320_pipe_modi
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
@@ -614,6 +631,7 @@ static const struct drm_driver gm12u320_
 
 	.fops		 = &gm12u320_fops,
 	DRM_GEM_SHMEM_DRIVER_OPS,
+	.gem_prime_import = gm12u320_gem_prime_import,
 };
 
 static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
@@ -640,15 +658,18 @@ static int gm12u320_usb_probe(struct usb
 				      struct gm12u320_device, dev);
 	if (IS_ERR(gm12u320))
 		return PTR_ERR(gm12u320);
+	dev = &gm12u320->dev;
+
+	gm12u320->dmadev = usb_intf_get_dma_device(to_usb_interface(dev->dev));
+	if (!gm12u320->dmadev)
+		drm_warn(dev, "buffer sharing not supported"); /* not an error */
 
 	INIT_DELAYED_WORK(&gm12u320->fb_update.work, gm12u320_fb_update_work);
 	mutex_init(&gm12u320->fb_update.lock);
 
-	dev = &gm12u320->dev;
-
 	ret = drmm_mode_config_init(dev);
 	if (ret)
-		return ret;
+		goto err_put_device;
 
 	dev->mode_config.min_width = GM12U320_USER_WIDTH;
 	dev->mode_config.max_width = GM12U320_USER_WIDTH;
@@ -658,15 +679,15 @@ static int gm12u320_usb_probe(struct usb
 
 	ret = gm12u320_usb_alloc(gm12u320);
 	if (ret)
-		return ret;
+		goto err_put_device;
 
 	ret = gm12u320_set_ecomode(gm12u320);
 	if (ret)
-		return ret;
+		goto err_put_device;
 
 	ret = gm12u320_conn_init(gm12u320);
 	if (ret)
-		return ret;
+		goto err_put_device;
 
 	ret = drm_simple_display_pipe_init(&gm12u320->dev,
 					   &gm12u320->pipe,
@@ -676,24 +697,31 @@ static int gm12u320_usb_probe(struct usb
 					   gm12u320_pipe_modifiers,
 					   &gm12u320->conn);
 	if (ret)
-		return ret;
+		goto err_put_device;
 
 	drm_mode_config_reset(dev);
 
 	usb_set_intfdata(interface, dev);
 	ret = drm_dev_register(dev, 0);
 	if (ret)
-		return ret;
+		goto err_put_device;
 
 	drm_fbdev_generic_setup(dev, 0);
 
 	return 0;
+
+err_put_device:
+	put_device(gm12u320->dmadev);
+	return ret;
 }
 
 static void gm12u320_usb_disconnect(struct usb_interface *interface)
 {
 	struct drm_device *dev = usb_get_intfdata(interface);
+	struct gm12u320_device *gm12u320 = to_gm12u320(dev);
 
+	put_device(gm12u320->dmadev);
+	gm12u320->dmadev = NULL;
 	drm_dev_unplug(dev);
 	drm_atomic_helper_shutdown(dev);
 }
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -32,6 +32,22 @@ static int udl_usb_resume(struct usb_int
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
@@ -40,6 +56,7 @@ static const struct drm_driver driver =
 	/* GEM hooks */
 	.fops = &udl_driver_fops,
 	DRM_GEM_SHMEM_DRIVER_OPS,
+	.gem_prime_import = udl_driver_gem_prime_import,
 
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -50,6 +50,7 @@ struct urb_list {
 struct udl_device {
 	struct drm_device drm;
 	struct device *dev;
+	struct device *dmadev;
 
 	struct drm_simple_display_pipe display_pipe;
 
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
@@ -343,12 +347,18 @@ int udl_init(struct udl_device *udl)
 err:
 	if (udl->urbs.count)
 		udl_free_urb_list(dev);
+	put_device(udl->dmadev);
 	DRM_ERROR("%d\n", ret);
 	return ret;
 }
 
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
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -748,6 +748,38 @@ void usb_put_intf(struct usb_interface *
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
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -746,6 +746,8 @@ extern int usb_lock_device_for_reset(str
 extern int usb_reset_device(struct usb_device *dev);
 extern void usb_queue_reset_device(struct usb_interface *dev);
 
+extern struct device *usb_intf_get_dma_device(struct usb_interface *intf);
+
 #ifdef CONFIG_ACPI
 extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable);


