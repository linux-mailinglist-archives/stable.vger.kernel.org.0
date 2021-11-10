Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EB344C4C5
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 17:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhKJQGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 11:06:14 -0500
Received: from www.linuxtv.org ([130.149.80.248]:37922 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhKJQGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 11:06:14 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mkq4L-007V9V-Fv; Wed, 10 Nov 2021 16:03:25 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 10 Nov 2021 15:59:00 +0000
Subject: [git:media_stage/master] media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mkq4L-007V9V-Fv@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Wed Nov 3 12:28:31 2021 +0000

If V4L2_CAP_READWRITE is not set, then readbuffers must be set to 0,
otherwise v4l2-compliance will complain.

A note on the Fixes tag below: this patch does not really fix that commit,
but it can be applied from that commit onwards. For older code there is no
guarantee that device_caps is set, so even though this patch would apply,
it will not work reliably.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 049e684f2de9 (media: v4l2-dev: fix WARN_ON(!vdev->device_caps))
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/v4l2-core/v4l2-ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 31d0109ce5a8..69b74d0e8a90 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2090,6 +2090,7 @@ static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
 static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_streamparm *p = arg;
 	v4l2_std_id std;
 	int ret = check_fmt(file, p->type);
@@ -2101,7 +2102,8 @@ static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
-	p->parm.capture.readbuffers = 2;
+	if (vfd->device_caps & V4L2_CAP_READWRITE)
+		p->parm.capture.readbuffers = 2;
 	ret = ops->vidioc_g_std(file, fh, &std);
 	if (ret == 0)
 		v4l2_video_std_frame_period(std, &p->parm.capture.timeperframe);
