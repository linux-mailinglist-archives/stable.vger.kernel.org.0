Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7F6C752
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390608AbfGRDID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390601AbfGRDID (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:03 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64342173E;
        Thu, 18 Jul 2019 03:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419283;
        bh=1E5KVj4G0WL07FDo69IxQG3sTxcw9QLYL/zcBouUFYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vW1BUyzpUHAyNzxAkcyy51r9IcsQSzvJHu/JSU0QtnSMg1PBn4SM468DYoOXoJGYV
         c/zRboBOFagw42IwBhP3Bwbk3PmWXZ51uj446chwqEUBPLt69unTOyX9uIScHX62Qf
         cXqN5iXh3L7FeVAAp4sEZ7CTFZSlpo8i+YUzDN40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ross Zwisler <zwisler@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/47] drm/udl: introduce a macro to convert dev to udl.
Date:   Thu, 18 Jul 2019 12:01:58 +0900
Message-Id: <20190718030052.482745174@linuxfoundation.org>
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

commit fd96e0dba19c53c2d66f2a398716bb74df8ca85e upstream.

This just makes it easier to later embed drm into udl.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405031715.5959-3-airlied@gmail.com
Signed-off-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_drv.h  |  2 ++
 drivers/gpu/drm/udl/udl_fb.c   | 10 +++++-----
 drivers/gpu/drm/udl/udl_gem.c  |  2 +-
 drivers/gpu/drm/udl/udl_main.c | 12 ++++++------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index 4ae67d882eae..b3e08e876d62 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -71,6 +71,8 @@ struct udl_device {
 	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
 };
 
+#define to_udl(x) ((x)->dev_private)
+
 struct udl_gem_object {
 	struct drm_gem_object base;
 	struct page **pages;
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index dd9ffded223b..590323ea261f 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -82,7 +82,7 @@ int udl_handle_damage(struct udl_framebuffer *fb, int x, int y,
 		      int width, int height)
 {
 	struct drm_device *dev = fb->base.dev;
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int i, ret;
 	char *cmd;
 	cycles_t start_cycles, end_cycles;
@@ -210,7 +210,7 @@ static int udl_fb_open(struct fb_info *info, int user)
 {
 	struct udl_fbdev *ufbdev = info->par;
 	struct drm_device *dev = ufbdev->ufb.base.dev;
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 
 	/* If the USB device is gone, we don't accept new opens */
 	if (drm_dev_is_unplugged(udl->ddev))
@@ -441,7 +441,7 @@ static void udl_fbdev_destroy(struct drm_device *dev,
 
 int udl_fbdev_init(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int bpp_sel = fb_bpp;
 	struct udl_fbdev *ufbdev;
 	int ret;
@@ -480,7 +480,7 @@ int udl_fbdev_init(struct drm_device *dev)
 
 void udl_fbdev_cleanup(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	if (!udl->fbdev)
 		return;
 
@@ -491,7 +491,7 @@ void udl_fbdev_cleanup(struct drm_device *dev)
 
 void udl_fbdev_unplug(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	struct udl_fbdev *ufbdev;
 	if (!udl->fbdev)
 		return;
diff --git a/drivers/gpu/drm/udl/udl_gem.c b/drivers/gpu/drm/udl/udl_gem.c
index bb7b58407039..3b3e17652bb2 100644
--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -203,7 +203,7 @@ int udl_gem_mmap(struct drm_file *file, struct drm_device *dev,
 {
 	struct udl_gem_object *gobj;
 	struct drm_gem_object *obj;
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret = 0;
 
 	mutex_lock(&udl->gem_lock);
diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_main.c
index 19055dda3140..09ce98113c0e 100644
--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -29,7 +29,7 @@
 static int udl_parse_vendor_descriptor(struct drm_device *dev,
 				       struct usb_device *usbdev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	char *desc;
 	char *buf;
 	char *desc_end;
@@ -165,7 +165,7 @@ void udl_urb_completion(struct urb *urb)
 
 static void udl_free_urb_list(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int count = udl->urbs.count;
 	struct list_head *node;
 	struct urb_node *unode;
@@ -198,7 +198,7 @@ static void udl_free_urb_list(struct drm_device *dev)
 
 static int udl_alloc_urb_list(struct drm_device *dev, int count, size_t size)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	struct urb *urb;
 	struct urb_node *unode;
 	char *buf;
@@ -262,7 +262,7 @@ static int udl_alloc_urb_list(struct drm_device *dev, int count, size_t size)
 
 struct urb *udl_get_urb(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret = 0;
 	struct list_head *entry;
 	struct urb_node *unode;
@@ -295,7 +295,7 @@ struct urb *udl_get_urb(struct drm_device *dev)
 
 int udl_submit_urb(struct drm_device *dev, struct urb *urb, size_t len)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret;
 
 	BUG_ON(len > udl->urbs.size);
@@ -370,7 +370,7 @@ int udl_drop_usb(struct drm_device *dev)
 
 void udl_driver_unload(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 
 	drm_kms_helper_poll_fini(dev);
 
-- 
2.20.1



