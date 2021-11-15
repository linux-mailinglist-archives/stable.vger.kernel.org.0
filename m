Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB246450C6D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbhKORir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237856AbhKORhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6A1632CC;
        Mon, 15 Nov 2021 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997103;
        bh=HeCemhcgdAzSxJL3nK2UCCNL9an3UeVZRo2Rwzy6SV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3T+OpMnL3v7liPYqjQHvHBeF5hsR08LcUiKmeXcHnMllKtsB5I4Q5kmLndV9/PNm
         E+HgmNs6Uv37CLCwqA0geLxCwx8jf5cNaOgSxl8AYHcvhe5zcZiO5I9dD5IquHmrKG
         E5eRxOrR/3JGek+XJK2YLjhjlf9YCGv6yzV7jBT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 026/575] media: v4l2-ioctl: Fix check_ext_ctrls
Date:   Mon, 15 Nov 2021 17:55:51 +0100
Message-Id: <20211115165344.518109975@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

commit 861f92cb9160b14beef0ada047384c2340701ee2 upstream.

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
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |   60 ++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 21 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -907,7 +907,7 @@ static void v4l_print_default(const void
 	pr_cont("driver-specific ioctl\n");
 }
 
-static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
+static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
 {
 	__u32 i;
 
@@ -916,23 +916,41 @@ static int check_ext_ctrls(struct v4l2_e
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
+		if (ioctl == VIDIOC_G_CTRL || ioctl == VIDIOC_S_CTRL)
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
+			c->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i :
+								      c->count;
+			return false;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static int check_fmt(struct file *file, enum v4l2_buf_type type)
@@ -2226,7 +2244,7 @@ static int v4l_g_ctrl(const struct v4l2_
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, 1)) {
+	if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
 		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
 
 		if (ret == 0)
@@ -2260,7 +2278,7 @@ static int v4l_s_ctrl(const struct v4l2_
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, 1))
+	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
 		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
 	return -EINVAL;
 }
@@ -2282,8 +2300,8 @@ static int v4l_g_ext_ctrls(const struct
 					vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_G_EXT_CTRLS) ?
+				ops->vidioc_g_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
@@ -2303,8 +2321,8 @@ static int v4l_s_ext_ctrls(const struct
 					vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_S_EXT_CTRLS) ?
+				ops->vidioc_s_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
@@ -2324,8 +2342,8 @@ static int v4l_try_ext_ctrls(const struc
 					  vfd, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_try_ext_ctrls == NULL)
 		return -ENOTTY;
-	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
-					-EINVAL;
+	return check_ext_ctrls(p, VIDIOC_TRY_EXT_CTRLS) ?
+			ops->vidioc_try_ext_ctrls(file, fh, p) : -EINVAL;
 }
 
 /*


