Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DF812C40D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfL2RZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbfL2RZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:25:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E707821744;
        Sun, 29 Dec 2019 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640356;
        bh=SO5jFCBQPGyj0zKJ5SiSGQxk3Bo7ULmVJtiiuTwEgZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MhWYwgQdhkPEDUUnufm6sc3ly8oKa9cl1SC4qdSdD7Rj9P6zFVxy90U6+TH7iNg/
         CzEfTMCpF13VmQQMs25zysvMR/CtN2TABT3SfOnPB2VGNHqnPCplJKpiFiuuYMR2sO
         j/lBtjwM8mWs70WJCSTKzXnE1OFWLceEuc+QIe/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vandana BN <bnvandana@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/161] media: v4l2-core: fix touch support in v4l_g_fmt
Date:   Sun, 29 Dec 2019 18:18:54 +0100
Message-Id: <20191229162425.060612027@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 681eef972e63..7cafc8a57950 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1363,10 +1363,26 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -1404,6 +1420,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
 		/* just in case the driver zeroed it again */
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+		if (vfd->vfl_type == VFL_TYPE_TOUCH)
+			v4l_pix_format_touch(&p->fmt.pix);
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
@@ -1439,21 +1457,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
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



