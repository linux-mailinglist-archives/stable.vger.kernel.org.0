Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61BE147FD0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbgAXLFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732407AbgAXLFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:18 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D0B02071A;
        Fri, 24 Jan 2020 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863917;
        bh=Inq9NTntY9B95lLaVyJWPaWiZ2i4ZH7VXHk2oiqovP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKlUgsuakOqtOSCiKUlHSaemVUc6G750TlZjErD0fioTPyQSMJ7Xqpj6lthkhe518
         oXuDPWE8zNQ7M+jxnkSTdFYxqnPF+7JszRDc9fl5kJOyXdSzP07ITMapluJYgqkAbc
         nXWAfrjwmUjQ7ZarxjVrr0uOPuEolOmvBCjDp+bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Wu <peter@lekensteyn.nl>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/639] drm/fb-helper: generic: Fix setup error path
Date:   Fri, 24 Jan 2020 10:24:52 +0100
Message-Id: <20200124093102.581024290@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

[ Upstream commit 6e1490cf439aa86b104e5124c36275b964238e1f ]

If register_framebuffer() fails during fbdev setup we will leak the
framebuffer, the GEM buffer and the shadow buffer for defio. This is
because drm_fb_helper_fbdev_setup() just calls drm_fb_helper_fini() on
error not taking into account that register_framebuffer() can fail.

Since the generic emulation uses DRM client for its framebuffer and
backing buffer in addition to a shadow buffer, it's necessary to open code
drm_fb_helper_fbdev_setup() to properly handle the error path.

Error cleanup is removed from .fb_probe and is handled by one function for
all paths.

Fixes: 9060d7f49376 ("drm/fb-helper: Finish the generic fbdev emulation")
Reported-by: Peter Wu <peter@lekensteyn.nl>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190105181846.26495-1-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 98 +++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index f57fc1450b613..1c87ad6667e73 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2979,18 +2979,16 @@ static int drm_fbdev_fb_release(struct fb_info *info, int user)
 	return 0;
 }
 
-/*
- * fb_ops.fb_destroy is called by the last put_fb_info() call at the end of
- * unregister_framebuffer() or fb_release().
- */
-static void drm_fbdev_fb_destroy(struct fb_info *info)
+static void drm_fbdev_cleanup(struct drm_fb_helper *fb_helper)
 {
-	struct drm_fb_helper *fb_helper = info->par;
 	struct fb_info *fbi = fb_helper->fbdev;
 	struct fb_ops *fbops = NULL;
 	void *shadow = NULL;
 
-	if (fbi->fbdefio) {
+	if (!fb_helper->dev)
+		return;
+
+	if (fbi && fbi->fbdefio) {
 		fb_deferred_io_cleanup(fbi);
 		shadow = fbi->screen_buffer;
 		fbops = fbi->fbops;
@@ -3004,6 +3002,12 @@ static void drm_fbdev_fb_destroy(struct fb_info *info)
 	}
 
 	drm_client_framebuffer_delete(fb_helper->buffer);
+}
+
+static void drm_fbdev_release(struct drm_fb_helper *fb_helper)
+{
+	drm_fbdev_cleanup(fb_helper);
+
 	/*
 	 * FIXME:
 	 * Remove conditional when all CMA drivers have been moved over to using
@@ -3015,6 +3019,15 @@ static void drm_fbdev_fb_destroy(struct fb_info *info)
 	}
 }
 
+/*
+ * fb_ops.fb_destroy is called by the last put_fb_info() call at the end of
+ * unregister_framebuffer() or fb_release().
+ */
+static void drm_fbdev_fb_destroy(struct fb_info *info)
+{
+	drm_fbdev_release(info->par);
+}
+
 static int drm_fbdev_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	struct drm_fb_helper *fb_helper = info->par;
@@ -3065,7 +3078,6 @@ int drm_fb_helper_generic_probe(struct drm_fb_helper *fb_helper,
 	struct drm_framebuffer *fb;
 	struct fb_info *fbi;
 	u32 format;
-	int ret;
 
 	DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d)\n",
 		      sizes->surface_width, sizes->surface_height,
@@ -3082,10 +3094,8 @@ int drm_fb_helper_generic_probe(struct drm_fb_helper *fb_helper,
 	fb = buffer->fb;
 
 	fbi = drm_fb_helper_alloc_fbi(fb_helper);
-	if (IS_ERR(fbi)) {
-		ret = PTR_ERR(fbi);
-		goto err_free_buffer;
-	}
+	if (IS_ERR(fbi))
+		return PTR_ERR(fbi);
 
 	fbi->par = fb_helper;
 	fbi->fbops = &drm_fbdev_fb_ops;
@@ -3116,8 +3126,7 @@ int drm_fb_helper_generic_probe(struct drm_fb_helper *fb_helper,
 		if (!fbops || !shadow) {
 			kfree(fbops);
 			vfree(shadow);
-			ret = -ENOMEM;
-			goto err_fb_info_destroy;
+			return -ENOMEM;
 		}
 
 		*fbops = *fbi->fbops;
@@ -3129,13 +3138,6 @@ int drm_fb_helper_generic_probe(struct drm_fb_helper *fb_helper,
 	}
 
 	return 0;
-
-err_fb_info_destroy:
-	drm_fb_helper_fini(fb_helper);
-err_free_buffer:
-	drm_client_framebuffer_delete(buffer);
-
-	return ret;
 }
 EXPORT_SYMBOL(drm_fb_helper_generic_probe);
 
@@ -3147,18 +3149,11 @@ static void drm_fbdev_client_unregister(struct drm_client_dev *client)
 {
 	struct drm_fb_helper *fb_helper = drm_fb_helper_from_client(client);
 
-	if (fb_helper->fbdev) {
-		drm_fb_helper_unregister_fbi(fb_helper);
+	if (fb_helper->fbdev)
 		/* drm_fbdev_fb_destroy() takes care of cleanup */
-		return;
-	}
-
-	/* Did drm_fb_helper_fbdev_setup() run? */
-	if (fb_helper->dev)
-		drm_fb_helper_fini(fb_helper);
-
-	drm_client_release(client);
-	kfree(fb_helper);
+		drm_fb_helper_unregister_fbi(fb_helper);
+	else
+		drm_fbdev_release(fb_helper);
 }
 
 static int drm_fbdev_client_restore(struct drm_client_dev *client)
@@ -3174,7 +3169,7 @@ static int drm_fbdev_client_hotplug(struct drm_client_dev *client)
 	struct drm_device *dev = client->dev;
 	int ret;
 
-	/* If drm_fb_helper_fbdev_setup() failed, we only try once */
+	/* Setup is not retried if it has failed */
 	if (!fb_helper->dev && fb_helper->funcs)
 		return 0;
 
@@ -3184,15 +3179,34 @@ static int drm_fbdev_client_hotplug(struct drm_client_dev *client)
 	if (!dev->mode_config.num_connector)
 		return 0;
 
-	ret = drm_fb_helper_fbdev_setup(dev, fb_helper, &drm_fb_helper_generic_funcs,
-					fb_helper->preferred_bpp, 0);
-	if (ret) {
-		fb_helper->dev = NULL;
-		fb_helper->fbdev = NULL;
-		return ret;
-	}
+	drm_fb_helper_prepare(dev, fb_helper, &drm_fb_helper_generic_funcs);
+
+	ret = drm_fb_helper_init(dev, fb_helper, dev->mode_config.num_connector);
+	if (ret)
+		goto err;
+
+	ret = drm_fb_helper_single_add_all_connectors(fb_helper);
+	if (ret)
+		goto err_cleanup;
+
+	if (!drm_drv_uses_atomic_modeset(dev))
+		drm_helper_disable_unused_functions(dev);
+
+	ret = drm_fb_helper_initial_config(fb_helper, fb_helper->preferred_bpp);
+	if (ret)
+		goto err_cleanup;
 
 	return 0;
+
+err_cleanup:
+	drm_fbdev_cleanup(fb_helper);
+err:
+	fb_helper->dev = NULL;
+	fb_helper->fbdev = NULL;
+
+	DRM_DEV_ERROR(dev->dev, "fbdev: Failed to setup generic emulation (ret=%d)\n", ret);
+
+	return ret;
 }
 
 static const struct drm_client_funcs drm_fbdev_client_funcs = {
@@ -3245,6 +3259,10 @@ int drm_fbdev_generic_setup(struct drm_device *dev, unsigned int preferred_bpp)
 
 	drm_client_add(&fb_helper->client);
 
+	if (!preferred_bpp)
+		preferred_bpp = dev->mode_config.preferred_depth;
+	if (!preferred_bpp)
+		preferred_bpp = 32;
 	fb_helper->preferred_bpp = preferred_bpp;
 
 	drm_fbdev_client_hotplug(&fb_helper->client);
-- 
2.20.1



