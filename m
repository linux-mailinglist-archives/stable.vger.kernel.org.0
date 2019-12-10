Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50261119ABD
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfLJWDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbfLJWDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A1E8222C4;
        Tue, 10 Dec 2019 22:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015423;
        bh=84Rbjmiv/oI6l8x6mreZvE7POjxp2KgMNIzREPjCz9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c23FbxtNOMsT+uNk4W3e2UiO3wUzpBIRL5TJYv9/KU2YQOc2WFKat4+dy/kFJBCPN
         x+nv0o6qlsVtIQweGPFHgyaSD8M5pv6e/GEJ0V7TdYO4Ql5t+2vScd9qL+NbSzBOrS
         P/rXc74D57/WNkTkHeopWBAo+14Ov+1tMtThkuJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 035/130] media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel format
Date:   Tue, 10 Dec 2019 17:01:26 -0500
Message-Id: <20191210220301.13262-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
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
index 19c0a26146356..4dc08f5a60811 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -352,20 +352,25 @@ enum {
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
@@ -1608,9 +1613,9 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	unsigned int stride = 0;
 
 	if (!fmt || !(fmt->types & type)) {
-		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
+		vpe_dbg(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
 			pix->pixelformat);
-		return -EINVAL;
+		fmt = __find_format(V4L2_PIX_FMT_YUYV);
 	}
 
 	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE
-- 
2.20.1

