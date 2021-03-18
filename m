Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8D340F16
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 21:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhCRU3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 16:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhCRU3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 16:29:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E44C061760
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 13:29:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w18so8335358edc.0
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FoTNLAOXFMQlhoehVNvrR3D+MbUba/aJhWEJ/3u+/wQ=;
        b=Gy6lr22SSC6SHuKO3ZQL9boQrV+nP0bJNV43u7oKTPA/l/I7KFgSMPWesy+r3kc6rH
         oQ/3ld5dd0taAQYxooaVdn81vhKNpwIJrDgleWUYgQzK1syv2po4prno0Jh62+fALIgr
         3bQTIfY9JISvyyJb2h0UMOMSt+G9sl/N4RCpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FoTNLAOXFMQlhoehVNvrR3D+MbUba/aJhWEJ/3u+/wQ=;
        b=iagdNHd/NjJ1V7b8lXiuEPCFlzG7py16WD4H+M2yQgGMQaPYxHzbAwTjMBoZ4u4Rxa
         a6CZ62cxCbWdJkvfs/xdRfJxAyojrDJHgFFrWZJ3IWX6ZzdsJVOTQ8OCSqoLpIlaTZsE
         hTEfsqw4eyFxUTUZyfoiSFxs7kpgZ+kXOmqS6DgKIOuUNib/Q1ch7Q/zqnJq1Ewi7+e3
         47m2G5q7r6q4z+r2lqci5ysspmtY10KsK+ukNL/cNUZXbIVoBKmXlhRuVSLHsukmoSOK
         ilGCeglmvZ8aLr1aOmK6tKjuda/OJouTx1ZfYFAvQ9SjozdlLfbt/UVttUn+cJe8gUgA
         gfWw==
X-Gm-Message-State: AOAM533b8eaUNF9EMiXKNMO+Sk/dVqyhbZRKHU/bT8hIvWnfw7SqhfV7
        HZO1TCgSPgNVBNCiq+cNgVP1zw==
X-Google-Smtp-Source: ABdhPJxp2gIqEt5N7i9tItTvg0/F43kCTmNwNHAmErCyzvkRwK4BCSfphZoOITmmlp9v/zKS0QV2WA==
X-Received: by 2002:a05:6402:12cf:: with SMTP id k15mr5718330edx.192.1616099370709;
        Thu, 18 Mar 2021 13:29:30 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id a22sm2533767ejr.89.2021.03.18.13.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 13:29:30 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v7 01/17] media: v4l2-ioctl: Fix check_ext_ctrls
Date:   Thu, 18 Mar 2021 21:29:12 +0100
Message-Id: <20210318202928.166955-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210318202928.166955-1-ribalda@chromium.org>
References: <20210318202928.166955-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers that do not use the ctrl-framework use this function instead.

Fix the following issues:

- Do not check for multiple classes when getting the DEF_VAL.
- Return -EINVAL for request_api calls
- Default value cannot be changed, return EINVAL as soon as possible.
- Return the right error_idx
[If an error is found when validating the list of controls passed with
VIDIOC_G_EXT_CTRLS, then error_idx shall be set to ctrls->count to
indicate to userspace that no actual hardware was touched.
It would have been much nicer of course if error_idx could point to the
control index that failed the validation, but sadly that's not how the
API was designed.]

Fixes v4l2-compliance:
Control ioctls (Input 0):
        warn: v4l2-test-controls.cpp(834): error_idx should be equal to count
        warn: v4l2-test-controls.cpp(855): error_idx should be equal to count
		fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
Buffer ioctls (Input 0):
		fail: v4l2-test-buffers.cpp(1994): ret != EINVAL && ret != EBADR && ret != ENOTTY
	test Requests: FAIL

Cc: stable@vger.kernel.org
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 59 ++++++++++++++++++----------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 31d1342e61e8..ccd21b4d9c72 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -908,7 +908,7 @@ static void v4l_print_default(const void *arg, bool write_only)
 	pr_cont("driver-specific ioctl\n");
 }
 
-static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
+static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
 {
 	__u32 i;
 
@@ -917,23 +917,40 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	for (i = 0; i < c->count; i++)
 		c->controls[i].reserved2[0] = 0;
 
-	/* V4L2_CID_PRIVATE_BASE cannot be used as control class
-	   when using extended controls.
-	   Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
-	   is it allowed for backwards compatibility.
-	 */
-	if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
-		return 0;
-	if (!c->which)
-		return 1;
+	switch (c->which) {
+	case V4L2_CID_PRIVATE_BASE:
+		/*
+		 * V4L2_CID_PRIVATE_BASE cannot be used as control class
+		 * when using extended controls.
+		 * Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
+		 * is it allowed for backwards compatibility.
+		 */
+		if (ioctl == VIDIOC_G_CTRL || ioctl == VIDIOC_S_CROP)
+			return false;
+		break;
+	case V4L2_CTRL_WHICH_DEF_VAL:
+		/* Default value cannot be changed */
+		if (ioctl == VIDIOC_S_EXT_CTRLS ||
+		    ioctl == VIDIOC_TRY_EXT_CTRLS) {
+			c->error_idx = c->count;
+			return false;
+		}
+		return true;
+	case V4L2_CTRL_WHICH_CUR_VAL:
+		return true;
+	case V4L2_CTRL_WHICH_REQUEST_VAL:
+		c->error_idx = c->count;
+		return false;
+	}
+
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
 		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
-			c->error_idx = i;
-			return 0;
+			c->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i : c->count;
+			return false;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static int check_fmt(struct file *file, enum v4l2_buf_type type)
@@ -2229,7 +2246,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, 1)) {
+	if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
 		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
 
 		if (ret == 0)
@@ -2263,7 +2280,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, 1))
+	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
 		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
 	return -EINVAL;
 }
@@ -2285,8 +2302,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_G_EXT_CTRLS) ?
+				ops->vidioc_g_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
@@ -2306,8 +2323,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_S_EXT_CTRLS) ?
+				ops->vidioc_s_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
@@ -2327,8 +2344,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					  vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_try_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_TRY_EXT_CTRLS) ?
+			ops->vidioc_try_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 /*
-- 
2.31.0.rc2.261.g7f71774620-goog

