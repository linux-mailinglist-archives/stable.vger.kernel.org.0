Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F984498F55
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357853AbiAXTwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350513AbiAXTZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:25:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D14E161484;
        Mon, 24 Jan 2022 19:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93201C340E5;
        Mon, 24 Jan 2022 19:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052300;
        bh=4bt5yiIaD1VywPIFb0uE+2wtLcFRrruAE3LteqpOqAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3XlmBa+VqHG52oAA9d2n6LJekqdryCqILCJ+xRaqTnwR4GRcAztmoTJ5lOEBW7Mv
         Lkr9wAzIXJWKup9J7AOKNtSEzSc2zHE7dFz4D1WgZnWHYIqMB8+Xtp67EY3cxPVyq4
         7UM8srvf7FEjK2z8Air9QEuPI4dYkero41mSFUyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 014/320] media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE
Date:   Mon, 24 Jan 2022 19:39:58 +0100
Message-Id: <20220124183954.239152458@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit cd9d9377ed235b294a492a094e1666178a5e78fd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2046,6 +2046,7 @@ static int v4l_prepare_buf(const struct
 static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_streamparm *p = arg;
 	v4l2_std_id std;
 	int ret = check_fmt(file, p->type);
@@ -2057,7 +2058,8 @@ static int v4l_g_parm(const struct v4l2_
 	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
-	p->parm.capture.readbuffers = 2;
+	if (vfd->device_caps & V4L2_CAP_READWRITE)
+		p->parm.capture.readbuffers = 2;
 	ret = ops->vidioc_g_std(file, fh, &std);
 	if (ret == 0)
 		v4l2_video_std_frame_period(std, &p->parm.capture.timeperframe);


