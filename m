Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1232B69A7B
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 20:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfGOSGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 14:06:31 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40151 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 14:06:31 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so35556333iom.7
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 11:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gxs4QGi+nZJ98OAmjIHS5bMx3ITwYZsxkCYCRQp5o00=;
        b=PuBqgEctNOkqCvTtUEsETrTsQMXy6YAliTQMRKH70GXlnoUTK9pYgin23pgXJ+a1Hw
         11gTcHRWh/GvUByjQJ4ak8cGRP1MoXI+XGp0kd+DT4KEfATR43g5NuPwRIS35vxGydf1
         avs/wO6rZ/6EIurgsuPQm3DoTVY/ZHRgJPdrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gxs4QGi+nZJ98OAmjIHS5bMx3ITwYZsxkCYCRQp5o00=;
        b=fPGKbH9KjXPAPi5Inv9EUSVwtJ4t3peEUY+qMBwSYQDGVIqZ89iRwD5zm7GSGeG/IG
         WaGjytdZ2Q7YTb1ztMbGutaX/DseWqVyqgLDG8JZ3flnrtxBQKn6RbkA5TXcis8wHap7
         8zCD+zpic6Xh4Oy8M6LUNLFDyZaHWF1E7Ti4bOnuG8Vb2g/f4Z8auCQOcQjUCRcQGIaQ
         uzI/aVTf2rTe8Eh/VwlRhxiq+Z4+qgKY9/aGgfiQd0ZF6j4cDyQvZ21hUJn0u2L0yv4W
         napxTgiq4z2twtVhmWl9wk6f2gexsX08sKb/d5dtLHnkufYh7sem8jC8zOT8KIIYdYRP
         TgkA==
X-Gm-Message-State: APjAAAUUt7xwbmQwogiv8tH1FaejSMYCCF6N/2FIDn2OcmK5USRHpxG1
        HCoWENthfWojMo8p88Fmb+dNbany4so=
X-Google-Smtp-Source: APXvYqzXq2ja9Mu6bwH6X9YeNuBDtrspn5xI/Wr9GKZg3GXjszAzNI4clIxuac4w0tIGeG69AvBT0w==
X-Received: by 2002:a5e:9506:: with SMTP id r6mr14765681ioj.219.1563213989830;
        Mon, 15 Jul 2019 11:06:29 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id t133sm25457753iof.21.2019.07.15.11.06.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:06:29 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Guenter Roeck <groeck@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [v4.19.y PATCH 3/3] drm/udl: move to embedding drm device inside udl device.
Date:   Mon, 15 Jul 2019 12:05:58 -0600
Message-Id: <20190715180558.221737-4-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715180558.221737-1-zwisler@google.com>
References: <20190715180558.221737-1-zwisler@google.com>
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
2.22.0.510.g264f2c817a-goog

