Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6820412C7CB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfL2Rq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbfL2Rq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8F620718;
        Sun, 29 Dec 2019 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641586;
        bh=RMFOB0y672cN40adGCHabr6xDBGC/365oahggngiGB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AH0Sw44wOKQqzboWbr88S1EpmZJ2+pmUaTsWkVMxigq2Dt8rqVohE2ocCRo04kDrC
         nuFqfGBWMiHNGxJG/Iuc8VfHxo6yXAcHwiiQJoefW3iJxgVozLv3yh6OWwQierQgRv
         jMLbcYv0kwpLH5t62Bq0lNlaEdvBy8n+x80to5Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/434] media: ti-vpe: vpe: Fix Motion Vector vpdma stride
Date:   Sun, 29 Dec 2019 18:23:00 +0100
Message-Id: <20191229172710.134098130@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 60b575bb44c4..5ba72445584d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1013,11 +1013,14 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
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
@@ -1044,6 +1047,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 		}
 		/* Apply the offset */
 		dma_addr += offset;
+		stride = q_data->bytesperline[VPE_LUMA];
 	}
 
 	if (q_data->flags & Q_DATA_FRAME_1D)
@@ -1055,7 +1059,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 			   MAX_W, MAX_H);
 
 	vpdma_add_out_dtd(&ctx->desc_list, q_data->width,
-			  q_data->bytesperline[VPE_LUMA], &q_data->c_rect,
+			  stride, &q_data->c_rect,
 			  vpdma_fmt, dma_addr, MAX_OUT_WIDTH_REG1,
 			  MAX_OUT_HEIGHT_REG1, p_data->channel, flags);
 }
@@ -1074,10 +1078,13 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
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
@@ -1104,6 +1111,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 		}
 		/* Apply the offset */
 		dma_addr += offset;
+		stride = q_data->bytesperline[VPE_LUMA];
 
 		if (q_data->flags & Q_DATA_INTERLACED_SEQ_TB) {
 			/*
@@ -1139,10 +1147,10 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
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



