Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC975498F67
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346560AbiAXTwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356357AbiAXTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:46:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6404361523;
        Mon, 24 Jan 2022 19:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CA5C340E5;
        Mon, 24 Jan 2022 19:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053560;
        bh=7j4QYyMjm/9sgur3HyUzCNJo7/u+AvcMqUm5RnpUKDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YebtX/4f0QvuJGtFq6hjRKvuLArz7hN+eR5mtDbJrcaLAD4uFBIAujy+glhYAsdUG
         fdiEdxhTb8B4NczpKnjwktT7tRkafloBMb9FyisiWgf74KNQ6BS0Uw2xI6+jvMn1d7
         EqfI8aZxwVNkllNXRF9zyFH26dU5z1aKjPP3ufTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/563] media: atomisp: fix enum formats logic
Date:   Mon, 24 Jan 2022 19:37:18 +0100
Message-Id: <20220124184026.929304775@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit fae46cb0531b45c789e39128f676f2bafa3a7b47 ]

Changeset 374d62e7aa50 ("media: v4l2-subdev: Verify v4l2_subdev_call() pad config argument")
added an extra verification for a pads parameter for enum mbus
format code.

Such change broke atomisp, because now the V4L2 core
refuses to enum MBUS formats if the state is empty.

So, add .which field in order to select the active formats,
in order to make it work again.

While here, improve error messages.

Fixes: 374d62e7aa50 ("media: v4l2-subdev: Verify v4l2_subdev_call() pad config argument")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_ioctl.c | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index 35717a91cbd15..830df02626634 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -773,7 +773,10 @@ static int atomisp_enum_fmt_cap(struct file *file, void *fh,
 	struct video_device *vdev = video_devdata(file);
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
-	struct v4l2_subdev_mbus_code_enum code = { 0 };
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_subdev *camera;
 	unsigned int i, fi = 0;
 	int rval;
 
@@ -783,14 +786,20 @@ static int atomisp_enum_fmt_cap(struct file *file, void *fh,
 		return -EINVAL;
 	}
 
+	camera = isp->inputs[asd->input_curr].camera;
+	if(!camera) {
+		dev_err(isp->dev, "%s(): camera is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	rt_mutex_lock(&isp->mutex);
-	rval = v4l2_subdev_call(isp->inputs[asd->input_curr].camera, pad,
-				enum_mbus_code, NULL, &code);
+
+	rval = v4l2_subdev_call(camera, pad, enum_mbus_code, NULL, &code);
 	if (rval == -ENOIOCTLCMD) {
 		dev_warn(isp->dev,
-			 "enum_mbus_code pad op not supported. Please fix your sensor driver!\n");
-		//	rval = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-		//				video, enum_mbus_fmt, 0, &code.code);
+			 "enum_mbus_code pad op not supported by %s. Please fix your sensor driver!\n",
+			 camera->name);
 	}
 	rt_mutex_unlock(&isp->mutex);
 
@@ -820,6 +829,8 @@ static int atomisp_enum_fmt_cap(struct file *file, void *fh,
 		f->pixelformat = format->pixelformat;
 		return 0;
 	}
+	dev_err(isp->dev, "%s(): format for code %x not found.\n",
+		__func__, code.code);
 
 	return -EINVAL;
 }
-- 
2.34.1



