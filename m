Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482EE3213CC
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhBVKJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhBVKHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 05:07:32 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59EBC061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 02:06:51 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id x16so12912531wmk.3
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 02:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7534on97qoCxOFebL6pBL3B9vTI8yBrF8g9T6cZAwE=;
        b=ku6IF1VdyLf02rbWq4jBRfho74k83VjYi/KZAHkdzZuPNaFyFZZvIahTwgGKLnevhv
         P7eFkxGfJxNeIVVRGfuFbW6j5ogJzzxOe1mxdWF/MXI4zdDi35ie7iEnxbCw9sqZFhdu
         GY4/sunyFOF+XMxq62fvbFbT39CHRbDasTrZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7534on97qoCxOFebL6pBL3B9vTI8yBrF8g9T6cZAwE=;
        b=RxdBFxO+8uy3sQtSLElwT2fgsOf5nhHsuH7BGlsEN1SltHiCxCPNaJpeb4i0LLwEKD
         ktRAhLaRM6A4jpGHFZF+PSWggk1kbggjM/U1w50kUlvZmtshiwxUq1ywI/V5CtoLVr1M
         CmJSRfLrJ0Aha/i2t+AmUDHNEBL7AVJFRDXUk6lMGPbkdgYkhj4NDqwqhO7HwjRkLXkm
         +yZ2L6JgYGKzu/9aGcIYD9ueaxjHVdFz6HWxI2oL7TzXOnoEWc5z9Q0rqlC5LhhM5PsA
         30tUGAA+6yol0iMrC4OPK7vlw+ZN27nK2jKxQKEGHQfxxsAt092GXSXPosloPiO9FM3r
         STNw==
X-Gm-Message-State: AOAM531aYfAQZolX5BLgsQm6Yy4lAqA4+0u5zOtgWcGMXBZIbALWVRcv
        WiFTZKmWRjfAan0knVmkWeJ66w==
X-Google-Smtp-Source: ABdhPJywt59k47vW7IA3ulT+kiIPyFpnZSYCg/EFt/CS/dgSQJT/mNLct4z9ktVbfmGxWnTsu3fb1A==
X-Received: by 2002:a1c:9843:: with SMTP id a64mr19241254wme.44.1613988410454;
        Mon, 22 Feb 2021 02:06:50 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id c9sm25672268wmb.33.2021.02.22.02.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 02:06:50 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/compat: Clear bounce structures
Date:   Mon, 22 Feb 2021 11:06:43 +0100
Message-Id: <20210222100643.400935-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some of them have gaps, or fields we don't clear. Native ioctl code
does full copies plus zero-extends on size mismatch, so nothing can
leak. But compat is more hand-rolled so need to be careful.

None of these matter for performance, so just memset.

Also I didn't fix up the CONFIG_DRM_LEGACY or CONFIG_DRM_AGP ioctl, those
are security holes anyway.

Reported-by: syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com # vblank ioctl
Cc: syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_ioc32.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index f86448ab1fe0..dc734d4828a1 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -99,6 +99,8 @@ static int compat_drm_version(struct file *file, unsigned int cmd,
 	if (copy_from_user(&v32, (void __user *)arg, sizeof(v32)))
 		return -EFAULT;
 
+	memset(&v, 0, sizeof(v));
+
 	v = (struct drm_version) {
 		.name_len = v32.name_len,
 		.name = compat_ptr(v32.name),
@@ -137,6 +139,9 @@ static int compat_drm_getunique(struct file *file, unsigned int cmd,
 
 	if (copy_from_user(&uq32, (void __user *)arg, sizeof(uq32)))
 		return -EFAULT;
+
+	memset(&uq, 0, sizeof(uq));
+
 	uq = (struct drm_unique){
 		.unique_len = uq32.unique_len,
 		.unique = compat_ptr(uq32.unique),
@@ -265,6 +270,8 @@ static int compat_drm_getclient(struct file *file, unsigned int cmd,
 	if (copy_from_user(&c32, argp, sizeof(c32)))
 		return -EFAULT;
 
+	memset(&client, 0, sizeof(client));
+
 	client.idx = c32.idx;
 
 	err = drm_ioctl_kernel(file, drm_getclient, &client, 0);
@@ -852,6 +859,8 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	if (copy_from_user(&req32, argp, sizeof(req32)))
 		return -EFAULT;
 
+	memset(&req, 0, sizeof(req));
+
 	req.request.type = req32.request.type;
 	req.request.sequence = req32.request.sequence;
 	req.request.signal = req32.request.signal;
@@ -889,6 +898,8 @@ static int compat_drm_mode_addfb2(struct file *file, unsigned int cmd,
 	struct drm_mode_fb_cmd2 req64;
 	int err;
 
+	memset(&req64, 0, sizeof(req64));
+
 	if (copy_from_user(&req64, argp,
 			   offsetof(drm_mode_fb_cmd232_t, modifier)))
 		return -EFAULT;
-- 
2.30.0

