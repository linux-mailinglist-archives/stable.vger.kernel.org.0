Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48747464A
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 16:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhLNPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 10:19:21 -0500
Received: from www.linuxtv.org ([130.149.80.248]:54144 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232952AbhLNPTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 10:19:19 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mx9aG-002y3W-H9; Tue, 14 Dec 2021 15:19:16 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 14 Dec 2021 15:19:03 +0000
Subject: [git:media_stage/master] media: Revert "media: uvcvideo: Set unique vdev name based in type"
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mx9aG-002y3W-H9@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: Revert "media: uvcvideo: Set unique vdev name based in type"
Author:  Ricardo Ribalda <ribalda@chromium.org>
Date:    Tue Dec 7 01:38:37 2021 +0100

A lot of userspace depends on a descriptive name for vdev. Without this
patch, users have a hard time figuring out which camera shall they use
for their video conferencing.

This reverts commit e3f60e7e1a2b451f538f9926763432249bcf39c4.

Link: https://lore.kernel.org/linux-media/20211207003840.1212374-2-ribalda@chromium.org
Cc: <stable@vger.kernel.org>
Fixes: e3f60e7e1a2b ("media: uvcvideo: Set unique vdev name based in type")
Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/uvc/uvc_driver.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

---

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 57152648d8ae..5f394d4efc21 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2195,7 +2195,6 @@ int uvc_register_video_device(struct uvc_device *dev,
 			      const struct v4l2_file_operations *fops,
 			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
-	const char *name;
 	int ret;
 
 	/* Initialize the video buffers queue. */
@@ -2224,20 +2223,16 @@ int uvc_register_video_device(struct uvc_device *dev,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	default:
 		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Video Capture";
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-		name = "Video Output";
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Metadata";
 		break;
 	}
 
-	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
-		 stream->header.bTerminalLink);
+	strscpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
