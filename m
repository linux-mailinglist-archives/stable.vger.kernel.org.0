Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2EE12EF15
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgABWeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730247AbgABWef (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:34:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FA422525;
        Thu,  2 Jan 2020 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004475;
        bh=+5YuairaGG6kMU68ZaqLdhb0LRh4UtKhlg1Rwc//BzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwCv7xg1STwuM8FUnLJfh1wJB5XSrZmancgL/ipsLUI8+LLNlyzRj02hSTp3Tk49F
         5uXyb+dEZk+FQKjCSN9gwr0ncu2rUiQo3TOb75uD2H0J3bKCG8vvT6/4fsiVR3Qz7b
         aQLp0+B/sg37Zb6Uf4fqLtm7fsc4MM/5ejqF6Zb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 022/137] media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel format
Date:   Thu,  2 Jan 2020 23:06:35 +0100
Message-Id: <20200102220549.639128370@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index de24effd984f..ca6629ccf82d 100644
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
@@ -1434,9 +1439,9 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
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



