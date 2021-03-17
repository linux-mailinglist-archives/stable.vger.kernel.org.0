Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7373333F5D0
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhCQQp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbhCQQpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 12:45:16 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E097AC061760
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:15 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ci14so3673805ejc.7
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ERNXG1v+qDkfV0aFqnySPvlk5uuRx9CupYTJSS90Mk4=;
        b=aHcwsimQ4eB5xhyPHCGPnZ8+zMDMnDDgA2E7ZAv2rmdgbOW/aJ6XzLcj+VmeM8YtD0
         /4bk7PlON9VlmR7hqtiloYJ0COSAgSp/diwQaZQTa95VzRoh0X5WNrCF3NZiMYpoYdQd
         IGfCn9Q7ahtF/NxApdC9UxZAKy3QkjjDHORVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ERNXG1v+qDkfV0aFqnySPvlk5uuRx9CupYTJSS90Mk4=;
        b=ntstvlYyjFzGkuP71oYpRrfYlYt4p5oRSVXC2zMzG4A+lyrnW8d1WecoHaAJWswEc2
         zvMUXK3PiQX/5/lhPoHOyaXRBh7tVylC/rZ1FWbWo7dJfSrJxW4gqtgQfaDhNjs98cxu
         kJ2ocfuTmEosEi/oj2VA6RCmqwc6dCc32/WnxwZHQxspHJHMG2c9EoReEF/UmC39mhVD
         PSB/Y+624DtM/DBluoCpzwl2FA657MjRm0Yqxu+zjAuytP2Y2GYCtdfmD0umjXTIq3bl
         cyGXUlASYWCwQbsstG4pOTLjiXSCVK9pgrpJ8jl8tmcXiMoP8L5ylV/748OuEhKA66NK
         CxIQ==
X-Gm-Message-State: AOAM530E65NDcoUYrpRc1oU2qKEhOX5+QcqxmIiajpgc0MIXBEIA3ync
        3sCw91uzDB/uddLvqVsZGCXW8Q==
X-Google-Smtp-Source: ABdhPJxl2JNc6WfYlfosiLWA9NRvZab0R8hg8Oj1BxFs50Ce/4RjjnNYz0OlOMfbyWwk+OWVhxPUjw==
X-Received: by 2002:a17:906:b752:: with SMTP id fx18mr37310300ejb.128.1615999514597;
        Wed, 17 Mar 2021 09:45:14 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id hy25sm12088128ejc.119.2021.03.17.09.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:45:14 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v6 01/17] media: v4l2-ioctl: check_ext_ctrls: Fix multiclass V4L2_CTRL_WHICH_DEF_VAL
Date:   Wed, 17 Mar 2021 17:44:55 +0100
Message-Id: <20210317164511.39967-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210317164511.39967-1-ribalda@chromium.org>
References: <20210317164511.39967-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers that do not use the ctrl-framework use this function instead.

- Do not check for multiple classes when getting the DEF_VAL.

Fixes v4l2-compliance:
Control ioctls (Input 0):
		fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Cc: stable@vger.kernel.org
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 47 ++++++++++++++++------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 31d1342e61e8..403f957a1012 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -908,7 +908,7 @@ static void v4l_print_default(const void *arg, bool write_only)
 	pr_cont("driver-specific ioctl\n");
 }
 
-static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
+static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
 {
 	__u32 i;
 
@@ -917,23 +917,30 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
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
+	case V4L2_CTRL_WHICH_CUR_VAL:
+		return true;
+	}
+
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
 		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
 			c->error_idx = i;
-			return 0;
+			return false;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static int check_fmt(struct file *file, enum v4l2_buf_type type)
@@ -2229,7 +2236,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, 1)) {
+	if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
 		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
 
 		if (ret == 0)
@@ -2263,7 +2270,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, 1))
+	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
 		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
 	return -EINVAL;
 }
@@ -2285,8 +2292,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_G_EXT_CTRLS) ?
+				ops->vidioc_g_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
@@ -2306,8 +2313,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_S_EXT_CTRLS) ?
+				ops->vidioc_s_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
@@ -2327,8 +2334,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
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

