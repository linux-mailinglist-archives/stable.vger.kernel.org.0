Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBCB119E3D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfLJWbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbfLJWbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:31:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B787E207FF;
        Tue, 10 Dec 2019 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017065;
        bh=TwpJsn+VWHD6/a00zAejKGYPYa89KcNwRWbQTMR1IVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3jUTg3NI7UKDdggR0pJ0WP28+U+55kkf01cYerHDjGP1CFAOsO30n+aXYxbkhyh3
         T3Mi7m8UfvD6jFPJA0tysb9JbZJeBRQaGrQjFZvLnqP4Kvp1m8/E83DQlnJuelBsd9
         A4NdTE7af/uny9P4iuOGCvhVmuhRAQEXqrOn9iiw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 25/91] media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel format
Date:   Tue, 10 Dec 2019 17:29:29 -0500
Message-Id: <20191210223035.14270-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit 06bec72b250b2cb3ba96fa45c2b8e0fb83745517 ]

v4l2-compliance warns with this message:

   warn: v4l2-test-formats.cpp(717): \
 	TRY_FMT cannot handle an invalid pixelformat.
   warn: v4l2-test-formats.cpp(718): \
 	This may or may not be a problem. For more information see:
   warn: v4l2-test-formats.cpp(719): \
 	http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
	...
   test VIDIOC_TRY_FMT: FAIL

We need to make sure that the returns a valid pixel format in all
instance. Based on the v4l2 framework convention drivers must return a
valid pixel format when the requested pixel format is either invalid or
not supported.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 0189f7f7cb03f..da308fa6561fc 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -330,20 +330,25 @@ enum {
 };
 
 /* find our format description corresponding to the passed v4l2_format */
-static struct vpe_fmt *find_format(struct v4l2_format *f)
+static struct vpe_fmt *__find_format(u32 fourcc)
 {
 	struct vpe_fmt *fmt;
 	unsigned int k;
 
 	for (k = 0; k < ARRAY_SIZE(vpe_formats); k++) {
 		fmt = &vpe_formats[k];
-		if (fmt->fourcc == f->fmt.pix.pixelformat)
+		if (fmt->fourcc == fourcc)
 			return fmt;
 	}
 
 	return NULL;
 }
 
+static struct vpe_fmt *find_format(struct v4l2_format *f)
+{
+	return __find_format(f->fmt.pix.pixelformat);
+}
+
 /*
  * there is one vpe_dev structure in the driver, it is shared by
  * all instances.
@@ -1433,9 +1438,9 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	int i, depth, depth_bytes;
 
 	if (!fmt || !(fmt->types & type)) {
-		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
+		vpe_dbg(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
 			pix->pixelformat);
-		return -EINVAL;
+		fmt = __find_format(V4L2_PIX_FMT_YUYV);
 	}
 
 	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE)
-- 
2.20.1

