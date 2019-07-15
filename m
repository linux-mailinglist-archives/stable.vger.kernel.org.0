Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2E69B79
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 21:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfGOTgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 15:36:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43651 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729948AbfGOTgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 15:36:23 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so35993544ios.10
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 12:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dG2193yxqmXlYY7LOEv7WFXw0/mMYiRzUuFH9lLVFL4=;
        b=NcvvYowuKAvxtepZoejRRaYMn8j5RuSZq6n6yxjoBjWKNe9CCVZzy5lNlHLwH0kF7m
         nziy6qFC2bPXfR9Qk/XgdAC80WrdWdklV991TmvOdFGyq/4DvbqHEJgJmAQTgYQvo7yG
         6rCDwvjP9CQg1jw35Tt/ZzNOniu12iitfBx3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dG2193yxqmXlYY7LOEv7WFXw0/mMYiRzUuFH9lLVFL4=;
        b=Wcw68Vzmro9FZwnu/iCDKb0VTJ5n/sudLhX9tQxkaXLJu2PDGqE3088gmKPZ44LQiT
         2w4G1aYD5lGY0PhFcp+K0Pb5nE3h2pi8gWv181oArE70tPHjlrJaY8dxCnejkuX/4zh+
         hOsWO3VFQ+w/PjC97DrAOZim7fs0aVttc2BFVmL35ySdB0Vw8Ul5H/ayfX0yrKToXdqg
         QtkHkXwKnFekeh5LUHHfFkz95SxeF23m8lbXsx+CuQxRPXgsLQCqvlfW8/bGchemaq+Q
         6wfgyJOFILLdWnx4SHCbODD4Imc86wiPM1XdTV/KcObUBn5bH37rySGgszcYOgzfgXir
         ut2Q==
X-Gm-Message-State: APjAAAUvUEy9N9xv/j+pSY62H8ral/PXW7Q8s16ztsyw1GN4AZ34cxZT
        zUMwVVCBPaW7nGJDhLnewWigEQog/AM=
X-Google-Smtp-Source: APXvYqzHwitH4zIxv5RTrdGCxi8Wemm48uEvCm1gPfianJY795q5iwKRPC7lFM8WgSTbX5/QpSnD/g==
X-Received: by 2002:a5d:8451:: with SMTP id w17mr28127622ior.226.1563219382583;
        Mon, 15 Jul 2019 12:36:22 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id b20sm14349082ios.44.2019.07.15.12.36.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 12:36:21 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ross Zwisler <zwisler@google.com>
Subject: [v4.14.y PATCH 1/2] drm/udl: introduce a macro to convert dev to udl.
Date:   Mon, 15 Jul 2019 13:36:17 -0600
Message-Id: <20190715193618.24578-2-zwisler@google.com>
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

commit fd96e0dba19c53c2d66f2a398716bb74df8ca85e upstream.

This just makes it easier to later embed drm into udl.

[rez] Regarding the backport to v4.14.y, the only difference is due to
the fact that in v4.14.y the udl_gem_mmap() function doesn't have a
local 'struct udl_device' pointer so it didn't need to be converted.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405031715.5959-3-airlied@gmail.com
Signed-off-by: Ross Zwisler <zwisler@google.com>
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
2.22.0.510.g264f2c817a-goog

