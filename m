Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52411195F9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfLJVYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:24:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbfLJVK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30428246B9;
        Tue, 10 Dec 2019 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012256;
        bh=cQMKOX25Wq8pLkfNAErys6KzFr9M5KO/PQFYg5AOy9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jzm8RQRkrqSvDmbWk3k53v5PtoRgzNcPrtyJZLmEqsjJjC4VlSq30OiYaGCKLJLE7
         KRgqoZSywTLr0WnyVRkFRr0vmvkoqxcwnZZtVWKQRHRcUB25t1GxYw3eGg4nBtU+Uf
         w2xKN0W+iCXR+9/qabBu31C8F+qQ+jOUJVIjLKTw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vandana BN <bnvandana@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 203/350] media: v4l2-core: fix touch support in v4l_g_fmt
Date:   Tue, 10 Dec 2019 16:05:08 -0500
Message-Id: <20191210210735.9077-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vandana BN <bnvandana@gmail.com>

[ Upstream commit 545b618cfb5cadacd00c25066b9a36540e5ca9e9 ]

v4l_s_fmt, for VFL_TYPE_TOUCH, sets unneeded members of
the v4l2_pix_format structure to default values.This was
missing in v4l_g_fmt, which would lead to failures in
v4l2-compliance tests.

Signed-off-by: Vandana BN <bnvandana@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 33 +++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 51b912743f0f4..21bb96ce4cd65 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1466,10 +1466,26 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 	return ret;
 }
 
+static void v4l_pix_format_touch(struct v4l2_pix_format *p)
+{
+	/*
+	 * The v4l2_pix_format structure contains fields that make no sense for
+	 * touch. Set them to default values in this case.
+	 */
+
+	p->field = V4L2_FIELD_NONE;
+	p->colorspace = V4L2_COLORSPACE_RAW;
+	p->flags = 0;
+	p->ycbcr_enc = 0;
+	p->quantization = 0;
+	p->xfer_func = 0;
+}
+
 static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_format *p = arg;
+	struct video_device *vfd = video_devdata(file);
 	int ret = check_fmt(file, p->type);
 
 	if (ret)
@@ -1507,6 +1523,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
 		/* just in case the driver zeroed it again */
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+		if (vfd->vfl_type == VFL_TYPE_TOUCH)
+			v4l_pix_format_touch(&p->fmt.pix);
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
@@ -1544,21 +1562,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	return -EINVAL;
 }
 
-static void v4l_pix_format_touch(struct v4l2_pix_format *p)
-{
-	/*
-	 * The v4l2_pix_format structure contains fields that make no sense for
-	 * touch. Set them to default values in this case.
-	 */
-
-	p->field = V4L2_FIELD_NONE;
-	p->colorspace = V4L2_COLORSPACE_RAW;
-	p->flags = 0;
-	p->ycbcr_enc = 0;
-	p->quantization = 0;
-	p->xfer_func = 0;
-}
-
 static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
-- 
2.20.1

