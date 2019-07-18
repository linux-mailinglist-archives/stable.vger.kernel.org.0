Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BDC6C737
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389705AbfGRDW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389729AbfGRDIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:25 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A222173B;
        Thu, 18 Jul 2019 03:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419304;
        bh=HVq0OY3XtiBCPDAHr9rv9F9mDFCboIdnwymOPwkKx90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYYCDSnETtciBpXg3ErMQKMFHnq5r367NuXcnlFh8Wps4oyzi7P2A8gXhd5lVFDe0
         BEg2BCegcI0tManP1NLmjJGSmsPtK4jDylXTIj+16bkoa7QS/B9++qRU1qPT+kjiq6
         xtLKcAkOQRdy0FgfrXVIpkNVINfo3dQrtLsBjKQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ross Zwisler <zwisler@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/47] drm/udl: move to embedding drm device inside udl device.
Date:   Thu, 18 Jul 2019 12:02:00 +0900
Message-Id: <20190718030052.641913444@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6ecac85eadb9d4065b9038fa3d3c66d49038e14b upstream.

This should help with some of the lifetime issues, and move us away
from load/unload.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405031715.5959-4-airlied@gmail.com
Signed-off-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_drv.c  | 56 +++++++++++++++++++++++++++-------
 drivers/gpu/drm/udl/udl_drv.h  |  9 +++---
 drivers/gpu/drm/udl/udl_fb.c   |  2 +-
 drivers/gpu/drm/udl/udl_main.c | 23 ++------------
 4 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index bd4f0b88bbd7..f28703db8dbd 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -47,10 +47,16 @@ static const struct file_operations udl_driver_fops = {
 	.llseek = noop_llseek,
 };
 
+static void udl_driver_release(struct drm_device *dev)
+{
+	udl_fini(dev);
+	udl_modeset_cleanup(dev);
+	drm_dev_fini(dev);
+	kfree(dev);
+}
+
 static struct drm_driver driver = {
 	.driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME,
-	.load = udl_driver_load,
-	.unload = udl_driver_unload,
 	.release = udl_driver_release,
 
 	/* gem hooks */
@@ -74,28 +80,56 @@ static struct drm_driver driver = {
 	.patchlevel = DRIVER_PATCHLEVEL,
 };
 
+static struct udl_device *udl_driver_create(struct usb_interface *interface)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	struct udl_device *udl;
+	int r;
+
+	udl = kzalloc(sizeof(*udl), GFP_KERNEL);
+	if (!udl)
+		return ERR_PTR(-ENOMEM);
+
+	r = drm_dev_init(&udl->drm, &driver, &interface->dev);
+	if (r) {
+		kfree(udl);
+		return ERR_PTR(r);
+	}
+
+	udl->udev = udev;
+	udl->drm.dev_private = udl;
+
+	r = udl_init(udl);
+	if (r) {
+		drm_dev_fini(&udl->drm);
+		kfree(udl);
+		return ERR_PTR(r);
+	}
+
+	usb_set_intfdata(interface, udl);
+	return udl;
+}
+
 static int udl_usb_probe(struct usb_interface *interface,
 			 const struct usb_device_id *id)
 {
-	struct usb_device *udev = interface_to_usbdev(interface);
-	struct drm_device *dev;
 	int r;
+	struct udl_device *udl;
 
-	dev = drm_dev_alloc(&driver, &interface->dev);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
+	udl = udl_driver_create(interface);
+	if (IS_ERR(udl))
+		return PTR_ERR(udl);
 
-	r = drm_dev_register(dev, (unsigned long)udev);
+	r = drm_dev_register(&udl->drm, 0);
 	if (r)
 		goto err_free;
 
-	usb_set_intfdata(interface, dev);
-	DRM_INFO("Initialized udl on minor %d\n", dev->primary->index);
+	DRM_INFO("Initialized udl on minor %d\n", udl->drm.primary->index);
 
 	return 0;
 
 err_free:
-	drm_dev_put(dev);
+	drm_dev_put(&udl->drm);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index b3e08e876d62..35c1f33fbc1a 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -50,8 +50,8 @@ struct urb_list {
 struct udl_fbdev;
 
 struct udl_device {
+	struct drm_device drm;
 	struct device *dev;
-	struct drm_device *ddev;
 	struct usb_device *udev;
 	struct drm_crtc *crtc;
 
@@ -71,7 +71,7 @@ struct udl_device {
 	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
 };
 
-#define to_udl(x) ((x)->dev_private)
+#define to_udl(x) container_of(x, struct udl_device, drm)
 
 struct udl_gem_object {
 	struct drm_gem_object base;
@@ -104,9 +104,8 @@ struct urb *udl_get_urb(struct drm_device *dev);
 int udl_submit_urb(struct drm_device *dev, struct urb *urb, size_t len);
 void udl_urb_completion(struct urb *urb);
 
-int udl_driver_load(struct drm_device *dev, unsigned long flags);
-void udl_driver_unload(struct drm_device *dev);
-void udl_driver_release(struct drm_device *dev);
+int udl_init(struct udl_device *udl);
+void udl_fini(struct drm_device *dev);
 
 int udl_fbdev_init(struct drm_device *dev);
 void udl_fbdev_cleanup(struct drm_device *dev);
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index 590323ea261f..4ab101bf1df0 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -213,7 +213,7 @@ static int udl_fb_open(struct fb_info *info, int user)
 	struct udl_device *udl = to_udl(dev);
 
 	/* If the USB device is gone, we don't accept new opens */
-	if (drm_dev_is_unplugged(udl->ddev))
+	if (drm_dev_is_unplugged(&udl->drm))
 		return -ENODEV;
 
 	ufbdev->fb_count++;
diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_main.c
index 09ce98113c0e..8d22b6cd5241 100644
--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -310,20 +310,12 @@ int udl_submit_urb(struct drm_device *dev, struct urb *urb, size_t len)
 	return ret;
 }
 
-int udl_driver_load(struct drm_device *dev, unsigned long flags)
+int udl_init(struct udl_device *udl)
 {
-	struct usb_device *udev = (void*)flags;
-	struct udl_device *udl;
+	struct drm_device *dev = &udl->drm;
 	int ret = -ENOMEM;
 
 	DRM_DEBUG("\n");
-	udl = kzalloc(sizeof(struct udl_device), GFP_KERNEL);
-	if (!udl)
-		return -ENOMEM;
-
-	udl->udev = udev;
-	udl->ddev = dev;
-	dev->dev_private = udl;
 
 	mutex_init(&udl->gem_lock);
 
@@ -357,7 +349,6 @@ int udl_driver_load(struct drm_device *dev, unsigned long flags)
 err:
 	if (udl->urbs.count)
 		udl_free_urb_list(dev);
-	kfree(udl);
 	DRM_ERROR("%d\n", ret);
 	return ret;
 }
@@ -368,7 +359,7 @@ int udl_drop_usb(struct drm_device *dev)
 	return 0;
 }
 
-void udl_driver_unload(struct drm_device *dev)
+void udl_fini(struct drm_device *dev)
 {
 	struct udl_device *udl = to_udl(dev);
 
@@ -378,12 +369,4 @@ void udl_driver_unload(struct drm_device *dev)
 		udl_free_urb_list(dev);
 
 	udl_fbdev_cleanup(dev);
-	kfree(udl);
-}
-
-void udl_driver_release(struct drm_device *dev)
-{
-	udl_modeset_cleanup(dev);
-	drm_dev_fini(dev);
-	kfree(dev);
 }
-- 
2.20.1



