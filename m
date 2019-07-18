Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C936C6D6
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390985AbfGRDLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390991AbfGRDLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:11:44 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396612053B;
        Thu, 18 Jul 2019 03:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419503;
        bh=Cf1a/+xiUmejQNtMpMDZ7l+V+H20cegVoA9RHPjXCpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXl+39cs+73AVwHw5TPD+BaMiM5Eo4qHfM1oimd7SwpMhI0Zm4lf2hl4Z3CPs68ee
         HCN86VD2IprA+Gq6UBkHA3yDGrV7SaXdHctZr3weN7ewso9IdHViWSJL7jKvhiGMwr
         MF8cG/+omTwxZyBMB6LH7uZ07YrUAvwqowIhpOmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ross Zwisler <zwisler@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 80/80] drm/udl: move to embedding drm device inside udl device.
Date:   Thu, 18 Jul 2019 12:02:11 +0900
Message-Id: <20190718030105.759766674@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
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

[rez] Regarding the backport to v4.14.y, the only difference is due to
the fact that in v4.14.y the udl_usb_probe() function still uses
drm_dev_unref() instead of drm_dev_put().

Backport notes:

On Mon, Jul 15, 2019 at 09:13:08PM -0400, Sasha Levin wrote:
> Hm, we don't need ac3b35f11a06 here? Why not? I'd love to document that
> with the backport.

Nope, we don't need that patch in the v4.14 backport.

In v4.19.y we have two functions, drm_dev_put() and drm_dev_unref(), which are
aliases for one another (drm_dev_unref() just calls drm_dev_put()).
drm_dev_unref() is the older of the two, and was introduced back in v4.0.
drm_dev_put() was introduced in v4.15 with

9a96f55034e41 drm: introduce drm_dev_{get/put} functions

and slowly callers were moved from the old name (_unref) to the new name
(_put).  The patch you mentioned, ac3b35f11a06, is one such patch where we are
replacing a drm_dev_unref() call with a drm_dev_put() call.  This doesn't have
a functional change, but was necessary so that the third patch in the v4.19.y
series I sent would apply cleanly.

For the v4.14.y series, though, the drm_dev_put() function hasn't yet been
defined and everyone is still using drm_dev_unref().  So, we don't need a
backport of ac3b35f11a06, and I also had a small backport change in the last
patch of the v4.14.y series where I had to change a drm_dev_put() call with a
drm_dev_unref() call.

Just for posterity, the drm_dev_unref() calls were eventually all changed to
drm_dev_put() in v5.0, and drm_dev_unref() was removed entirely.  That
happened with the following two patches:

808bad32ea423 drm: replace "drm_dev_unref" function with "drm_dev_put"
ba1d345401476 drm: remove deprecated "drm_dev_unref" function

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
index b45ac6bc8add..b428c3da7576 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -43,10 +43,16 @@ static const struct file_operations udl_driver_fops = {
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
@@ -70,28 +76,56 @@ static struct drm_driver driver = {
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
-	drm_dev_unref(dev);
+	drm_dev_unref(&udl->drm);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index ba0146e06b1e..d5a5dcd15dd8 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -49,8 +49,8 @@ struct urb_list {
 struct udl_fbdev;
 
 struct udl_device {
+	struct drm_device drm;
 	struct device *dev;
-	struct drm_device *ddev;
 	struct usb_device *udev;
 	struct drm_crtc *crtc;
 
@@ -68,7 +68,7 @@ struct udl_device {
 	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
 };
 
-#define to_udl(x) ((x)->dev_private)
+#define to_udl(x) container_of(x, struct udl_device, drm)
 
 struct udl_gem_object {
 	struct drm_gem_object base;
@@ -101,9 +101,8 @@ struct urb *udl_get_urb(struct drm_device *dev);
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
index 1e78767df06c..f41fd0684ce4 100644
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
index 05c14c80024c..124428f33e1e 100644
--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -311,20 +311,12 @@ int udl_submit_urb(struct drm_device *dev, struct urb *urb, size_t len)
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
 
 	if (!udl_parse_vendor_descriptor(dev, udl->udev)) {
 		ret = -ENODEV;
@@ -359,7 +351,6 @@ int udl_driver_load(struct drm_device *dev, unsigned long flags)
 err:
 	if (udl->urbs.count)
 		udl_free_urb_list(dev);
-	kfree(udl);
 	DRM_ERROR("%d\n", ret);
 	return ret;
 }
@@ -370,7 +361,7 @@ int udl_drop_usb(struct drm_device *dev)
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



