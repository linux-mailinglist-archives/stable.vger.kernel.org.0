Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E577119BE3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfLJWDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfLJWDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D8892053B;
        Tue, 10 Dec 2019 22:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015422;
        bh=T1P+sQHp5vUbzjfuXgGcu23aX5/LkzygKf4VZQ0khIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVNDJJ1Oi81T15JOW5PRlhnbbInV9trBc5J7VrWTFeIdxLD7v81R8f5MXcU+MA2/3
         08GpULiK2cjOdEq45LcFxA7oX4IZow3vzHp0QRp5oGpatvYObV3XzAY9cR1ozZ3Ay+
         ZkNEvrSpcerfAHhS8aQPX+O7YUjWBPH2tPmv+HV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 034/130] media: ti-vpe: vpe: Fix Motion Vector vpdma stride
Date:   Tue, 10 Dec 2019 17:01:25 -0500
Message-Id: <20191210220301.13262-34-sashal@kernel.org>
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

[ Upstream commit 102af9b9922f658f705a4b0deaccabac409131bf ]

commit 3dc2046ca78b ("[media] media: ti-vpe: vpe: allow use of user
specified stride") and commit da4414eaed15 ("[media] media: ti-vpe: vpdma:
add support for user specified stride") resulted in the Motion Vector
stride to be the same as the image stride.

This caused memory corruption in the output image as mentioned in
commit 00db969964c8 ("[media] media: ti-vpe: vpe: Fix line stride
for output motion vector").

Fixes: 3dc2046ca78b ("[media] media: ti-vpe: vpe: allow use of user specified stride")
Fixes: da4414eaed15 ("[media] media: ti-vpe: vpdma: add support for user specified stride")
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 45bd10544189e..19c0a26146356 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1044,11 +1044,14 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 	dma_addr_t dma_addr;
 	u32 flags = 0;
 	u32 offset = 0;
+	u32 stride;
 
 	if (port == VPE_PORT_MV_OUT) {
 		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
 		dma_addr = ctx->mv_buf_dma[mv_buf_selector];
 		q_data = &ctx->q_data[Q_DATA_SRC];
+		stride = ALIGN((q_data->width * vpdma_fmt->depth) >> 3,
+			       VPDMA_STRIDE_ALIGN);
 	} else {
 		/* to incorporate interleaved formats */
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
@@ -1075,6 +1078,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 		}
 		/* Apply the offset */
 		dma_addr += offset;
+		stride = q_data->bytesperline[VPE_LUMA];
 	}
 
 	if (q_data->flags & Q_DATA_FRAME_1D)
@@ -1086,7 +1090,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 			   MAX_W, MAX_H);
 
 	vpdma_add_out_dtd(&ctx->desc_list, q_data->width,
-			  q_data->bytesperline[VPE_LUMA], &q_data->c_rect,
+			  stride, &q_data->c_rect,
 			  vpdma_fmt, dma_addr, MAX_OUT_WIDTH_REG1,
 			  MAX_OUT_HEIGHT_REG1, p_data->channel, flags);
 }
@@ -1105,10 +1109,13 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 	dma_addr_t dma_addr;
 	u32 flags = 0;
 	u32 offset = 0;
+	u32 stride;
 
 	if (port == VPE_PORT_MV_IN) {
 		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
 		dma_addr = ctx->mv_buf_dma[mv_buf_selector];
+		stride = ALIGN((q_data->width * vpdma_fmt->depth) >> 3,
+			       VPDMA_STRIDE_ALIGN);
 	} else {
 		/* to incorporate interleaved formats */
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
@@ -1135,6 +1142,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 		}
 		/* Apply the offset */
 		dma_addr += offset;
+		stride = q_data->bytesperline[VPE_LUMA];
 
 		if (q_data->flags & Q_DATA_INTERLACED_SEQ_TB) {
 			/*
@@ -1170,10 +1178,10 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 	if (p_data->vb_part && fmt->fourcc == V4L2_PIX_FMT_NV12)
 		frame_height /= 2;
 
-	vpdma_add_in_dtd(&ctx->desc_list, q_data->width,
-			 q_data->bytesperline[VPE_LUMA], &q_data->c_rect,
-		vpdma_fmt, dma_addr, p_data->channel, field, flags, frame_width,
-		frame_height, 0, 0);
+	vpdma_add_in_dtd(&ctx->desc_list, q_data->width, stride,
+			 &q_data->c_rect, vpdma_fmt, dma_addr,
+			 p_data->channel, field, flags, frame_width,
+			 frame_height, 0, 0);
 }
 
 /*
-- 
2.20.1

