Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B966C6AF444
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjCGTPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjCGTPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EBFB863F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9A5B819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0B4C433D2;
        Tue,  7 Mar 2023 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215524;
        bh=G2MaftlTZHbhhxQc1Zm90oxbAPq/povNQVq3cjdn/pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRXDPjFIp+fmmxBS9wgeKdgD1AfwgZuYXq9RVVV4typp8wOon7NyrXm5KXOjMLWdf
         xZ4WeC+eLm9v1RtNdj5cLio1ZfeaKCemjXGFUhx/7Ukr5EdjKPv1eGL/TdzptAbCc4
         LJbFAWcTqW9GiRoF/z13JvoMOE450ZHcQBODIbi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/567] media: uvcvideo: Check controls flags before accessing them
Date:   Tue,  7 Mar 2023 18:00:24 +0100
Message-Id: <20230307165918.395862367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit ee929d5a10ca433a1c21b9aaeb70a67c5507c101 ]

We can figure out if reading/writing a set of controls can fail without
accessing them by checking their flags.

This way we can honor the API closer:

If an error is found when validating the list of controls passed with
VIDIOC_G_EXT_CTRLS, then error_idx shall be set to ctrls->count to
indicate to userspace that no actual hardware was touched.

Fixes v4l2-compliance:
Control ioctls (Input 0):
		warn: v4l2-test-controls.cpp(765): g_ext_ctrls(0) invalid error_idx 0
                fail: v4l2-test-controls.cpp(645): invalid error index write only control
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9f582f0418ed ("media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 22 ++++++++++++++++++
 drivers/media/usb/uvc/uvc_v4l2.c | 39 ++++++++++++++++++++++++++++----
 drivers/media/usb/uvc/uvcvideo.h |  2 ++
 3 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 748f87af5e43e..fcfbd0f726936 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1062,6 +1062,28 @@ static int uvc_query_v4l2_class(struct uvc_video_chain *chain, u32 req_id,
 	return 0;
 }
 
+int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
+			   bool read)
+{
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+
+	if (__uvc_query_v4l2_class(chain, v4l2_id, 0) >= 0)
+		return -EACCES;
+
+	ctrl = uvc_find_control(chain, v4l2_id, &mapping);
+	if (!ctrl)
+		return -EINVAL;
+
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) && read)
+		return -EACCES;
+
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR) && !read)
+		return -EACCES;
+
+	return 0;
+}
+
 static const char *uvc_map_get_name(const struct uvc_control_mapping *map)
 {
 	const char *name;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 533c4a0645ee4..7dd387e96c9de 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1006,6 +1006,26 @@ static int uvc_ioctl_query_ext_ctrl(struct file *file, void *fh,
 	return 0;
 }
 
+static int uvc_ctrl_check_access(struct uvc_video_chain *chain,
+				 struct v4l2_ext_controls *ctrls,
+				 unsigned long ioctl)
+{
+	struct v4l2_ext_control *ctrl = ctrls->controls;
+	unsigned int i;
+	int ret = 0;
+
+	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+		ret = uvc_ctrl_is_accessible(chain, ctrl->id,
+					    ioctl == VIDIOC_G_EXT_CTRLS);
+		if (ret)
+			break;
+	}
+
+	ctrls->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i : ctrls->count;
+
+	return ret;
+}
+
 static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 				 struct v4l2_ext_controls *ctrls)
 {
@@ -1015,6 +1035,10 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 	unsigned int i;
 	int ret;
 
+	ret = uvc_ctrl_check_access(chain, ctrls, VIDIOC_G_EXT_CTRLS);
+	if (ret < 0)
+		return ret;
+
 	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
 			struct v4l2_queryctrl qc = { .id = ctrl->id };
@@ -1051,13 +1075,17 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 
 static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 				     struct v4l2_ext_controls *ctrls,
-				     bool commit)
+				     unsigned long ioctl)
 {
 	struct v4l2_ext_control *ctrl = ctrls->controls;
 	struct uvc_video_chain *chain = handle->chain;
 	unsigned int i;
 	int ret;
 
+	ret = uvc_ctrl_check_access(chain, ctrls, ioctl);
+	if (ret < 0)
+		return ret;
+
 	ret = uvc_ctrl_begin(chain);
 	if (ret < 0)
 		return ret;
@@ -1066,14 +1094,15 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 		ret = uvc_ctrl_set(handle, ctrl);
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
-			ctrls->error_idx = commit ? ctrls->count : i;
+			ctrls->error_idx = ioctl == VIDIOC_S_EXT_CTRLS ?
+						    ctrls->count : i;
 			return ret;
 		}
 	}
 
 	ctrls->error_idx = 0;
 
-	if (commit)
+	if (ioctl == VIDIOC_S_EXT_CTRLS)
 		return uvc_ctrl_commit(handle, ctrls->controls, ctrls->count);
 	else
 		return uvc_ctrl_rollback(handle);
@@ -1084,7 +1113,7 @@ static int uvc_ioctl_s_ext_ctrls(struct file *file, void *fh,
 {
 	struct uvc_fh *handle = fh;
 
-	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, true);
+	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, VIDIOC_S_EXT_CTRLS);
 }
 
 static int uvc_ioctl_try_ext_ctrls(struct file *file, void *fh,
@@ -1092,7 +1121,7 @@ static int uvc_ioctl_try_ext_ctrls(struct file *file, void *fh,
 {
 	struct uvc_fh *handle = fh;
 
-	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, false);
+	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, VIDIOC_TRY_EXT_CTRLS);
 }
 
 static int uvc_ioctl_querymenu(struct file *file, void *fh,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 33befa48fb493..d414a22244057 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -901,6 +901,8 @@ static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 
 int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl);
 int uvc_ctrl_set(struct uvc_fh *handle, struct v4l2_ext_control *xctrl);
+int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
+			   bool read);
 
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		      struct uvc_xu_control_query *xqry);
-- 
2.39.2



