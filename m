Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A26C6E2
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391472AbfGRDLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391461AbfGRDLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:11:43 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B11120818;
        Thu, 18 Jul 2019 03:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419501;
        bh=oRBcSGHv2PFwnQvU9asDYheOp+4qhfeHajrqlsl1K/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gb/S+oxdroKn0trU4Ug3a44JO6cJnPkdMtqOP/hUIp5vpjp7HXSrktGjt4quMlimZ
         FnzNoPId1Dkg+xJM3TOXHel5MMBlH0LiYw6TV1MzHDJI5qqSLhp4rHFDq4WPQrITrK
         B+TPFZFU9X1cz2O33dSHEoWlAlHuF+Ib58jtTvS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ross Zwisler <zwisler@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 79/80] drm/udl: introduce a macro to convert dev to udl.
Date:   Thu, 18 Jul 2019 12:02:10 +0900
Message-Id: <20190718030105.682959719@linuxfoundation.org>
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

commit fd96e0dba19c53c2d66f2a398716bb74df8ca85e upstream.

This just makes it easier to later embed drm into udl.

[rez] Regarding the backport to v4.14.y, the only difference is due to
the fact that in v4.14.y the udl_gem_mmap() function doesn't have a
local 'struct udl_device' pointer so it didn't need to be converted.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405031715.5959-3-airlied@gmail.com
Signed-off-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_drv.h  |  2 ++
 drivers/gpu/drm/udl/udl_fb.c   | 10 +++++-----
 drivers/gpu/drm/udl/udl_main.c | 12 ++++++------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index 307455dd6526..ba0146e06b1e 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -68,6 +68,8 @@ struct udl_device {
 	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
 };
 
+#define to_udl(x) ((x)->dev_private)
+
 struct udl_gem_object {
 	struct drm_gem_object base;
 	struct page **pages;
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index 491f1892b50e..1e78767df06c 100644
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
diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_main.c
index 60866b422f81..05c14c80024c 100644
--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -28,7 +28,7 @@
 static int udl_parse_vendor_descriptor(struct drm_device *dev,
 				       struct usb_device *usbdev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	char *desc;
 	char *buf;
 	char *desc_end;
@@ -164,7 +164,7 @@ void udl_urb_completion(struct urb *urb)
 
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
@@ -296,7 +296,7 @@ struct urb *udl_get_urb(struct drm_device *dev)
 
 int udl_submit_urb(struct drm_device *dev, struct urb *urb, size_t len)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 	int ret;
 
 	BUG_ON(len > udl->urbs.size);
@@ -372,7 +372,7 @@ int udl_drop_usb(struct drm_device *dev)
 
 void udl_driver_unload(struct drm_device *dev)
 {
-	struct udl_device *udl = dev->dev_private;
+	struct udl_device *udl = to_udl(dev);
 
 	if (udl->urbs.count)
 		udl_free_urb_list(dev);
-- 
2.20.1



