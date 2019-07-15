Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89ABC69B7A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 21:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfGOTg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 15:36:26 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40840 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729948AbfGOTgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 15:36:25 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so36009676iom.7
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 12:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OIbNYUMybWvFcOp0rS8geKIjW6f3u8jBUcNhgPzlosU=;
        b=HrPLfLohRhuZFmDzhuwh9weXgBOjyeNYfojyiVOaoDfMgS+w4TiJV5jqCYf+zJxxsJ
         X2I+0cyUykotfWl5prtwf7lqhaeaVXW2qd1acnmSVRWzuHbwKytkA33g6uqAJnAQFu4H
         oI6vi8B8XjE71THWWjtbR76KC+muJGJpiS2V8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OIbNYUMybWvFcOp0rS8geKIjW6f3u8jBUcNhgPzlosU=;
        b=G2egXDaOgmWU+0v0xVCbUv+5W75vOFsZkXKnowSIcJaeFkSZbBNDRKqMPWSLsZZ4Z3
         uIrGnhdz/p+PMC5coRyhMzyrE3SSRsMj6ns1h1YIzsH3jnwrauU/4jhc7UKCQ4v9pG+N
         zlpxpa8QEEPQqxpcbZNpc5iy6v37cGnSCo/+9SXvc1A2l/ydeYag39m359l2brv3u/Bn
         nKtR8Vtg8CEgU6GYIejUD9SmptvAOJzcao8NiApdhGpBd0G8mrXgHvwP1tfDoccTYG53
         doJJfauqkhIrJO/YRRAcsxQ2TprguyN8DIRfbo2+7buIgMbzZ+s1xSlMKGrHvRbQ+Ac2
         pb7A==
X-Gm-Message-State: APjAAAVamaQgtKVlfbYXIkHjpXx3K4FHaVEvGyDPu6wzS9ZYXQKEXJL9
        nmeK4T30Yl5UFeIY952SivVC6/lB+Y8=
X-Google-Smtp-Source: APXvYqz6AtdxJP8ShRNcE1hjdzs24BUSw/lFxc4R/M3umFlDGmUj+QSH5qxYLz7H0Z4qvGil2r9Myw==
X-Received: by 2002:a5e:820a:: with SMTP id l10mr2730690iom.283.1563219384306;
        Mon, 15 Jul 2019 12:36:24 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id s3sm15988373iob.49.2019.07.15.12.36.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 12:36:23 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [v4.14.y PATCH 2/2] drm/udl: move to embedding drm device inside udl device.
Date:   Mon, 15 Jul 2019 13:36:18 -0600
Message-Id: <20190715193618.24578-3-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715193618.24578-1-zwisler@google.com>
References: <20190715193618.24578-1-zwisler@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit 6ecac85eadb9d4065b9038fa3d3c66d49038e14b upstream.

This should help with some of the lifetime issues, and move us away
from load/unload.

[rez] Regarding the backport to v4.14.y, the only difference is due to
the fact that in v4.14.y the udl_usb_probe() function still uses
drm_dev_unref() instead of drm_dev_put().

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405031715.5959-4-airlied@gmail.com
Signed-off-by: Ross Zwisler <zwisler@google.com>
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
2.22.0.510.g264f2c817a-goog

