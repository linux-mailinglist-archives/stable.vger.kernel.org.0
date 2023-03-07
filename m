Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EBA6AF43F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbjCGTPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbjCGTO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:14:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E32AD016
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B317BB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102C1C433D2;
        Tue,  7 Mar 2023 18:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215508;
        bh=J+drjrDxiHDGGynp5M88400QZXXAYjwGh8WQ4t0wTUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY9PxbSE8BBEsad2OXAkr8H9rMH/4iZKVhhwVfVGhzEPpKNKcSuG5xQfQMvd8Lul4
         ebavQS6kexT4P/WjXqTsc5dEl03FuyOlEhvdAo0wmLtCUt0GQyXTPcVJTYYWEkOhyF
         i1gMBvpuwUUkY8N5KMFZxjr234I1mf/M2m5cpCW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/567] media: uvcvideo: Remove s_ctrl and g_ctrl
Date:   Tue,  7 Mar 2023 18:00:20 +0100
Message-Id: <20230307165918.214317047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 0c6bcbdfefa83b8a1e9659b3c127758dce0fe7ac ]

If we do not implement these callbacks the framework will call the
ext_ctrl callbaks instead, which are a superset of this functions.

Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9f582f0418ed ("media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 56 --------------------------------
 1 file changed, 56 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index d2e633f6ec671..6955ed080d7dc 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1000,60 +1000,6 @@ static int uvc_ioctl_query_ext_ctrl(struct file *file, void *fh,
 	return 0;
 }
 
-static int uvc_ioctl_g_ctrl(struct file *file, void *fh,
-			    struct v4l2_control *ctrl)
-{
-	struct uvc_fh *handle = fh;
-	struct uvc_video_chain *chain = handle->chain;
-	struct v4l2_ext_control xctrl;
-	int ret;
-
-	memset(&xctrl, 0, sizeof(xctrl));
-	xctrl.id = ctrl->id;
-
-	ret = uvc_ctrl_begin(chain);
-	if (ret < 0)
-		return ret;
-
-	ret = uvc_ctrl_get(chain, &xctrl);
-	uvc_ctrl_rollback(handle);
-	if (ret < 0)
-		return ret;
-
-	ctrl->value = xctrl.value;
-	return 0;
-}
-
-static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
-			    struct v4l2_control *ctrl)
-{
-	struct uvc_fh *handle = fh;
-	struct uvc_video_chain *chain = handle->chain;
-	struct v4l2_ext_control xctrl;
-	int ret;
-
-	memset(&xctrl, 0, sizeof(xctrl));
-	xctrl.id = ctrl->id;
-	xctrl.value = ctrl->value;
-
-	ret = uvc_ctrl_begin(chain);
-	if (ret < 0)
-		return ret;
-
-	ret = uvc_ctrl_set(handle, &xctrl);
-	if (ret < 0) {
-		uvc_ctrl_rollback(handle);
-		return ret;
-	}
-
-	ret = uvc_ctrl_commit(handle, &xctrl, 1);
-	if (ret < 0)
-		return ret;
-
-	ctrl->value = xctrl.value;
-	return 0;
-}
-
 static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 				 struct v4l2_ext_controls *ctrls)
 {
@@ -1539,8 +1485,6 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
 	.vidioc_s_input = uvc_ioctl_s_input,
 	.vidioc_queryctrl = uvc_ioctl_queryctrl,
 	.vidioc_query_ext_ctrl = uvc_ioctl_query_ext_ctrl,
-	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
-	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
 	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,
 	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
 	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
-- 
2.39.2



