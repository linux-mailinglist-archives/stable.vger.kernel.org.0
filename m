Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920FA26EF90
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgIRCgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbgIRCMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48574238E6;
        Fri, 18 Sep 2020 02:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395171;
        bh=HcjsIQJ2wG7xbyWwQkeT9I6skDkr2DsBikFXcv6uPFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7JuaBMVa0eo9AsMcENTxPBul9CyUpRJRRq+m0QZUN5wRvSjfSSZ9urpHXZrRNHBr
         POBfDnVvQg3FSbfgvr3Im6iFl3tnspjkI4w6aDP3VLVB1Gv2an5wJ2UUzeURJeYIQH
         FkjtoD2w1UEDrJya2/LDvtxAf2qEaTrLrdXM8ofc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikhil Devshatwar <nikhil.nd@ti.com>,
        Benoit Parrot <bparrot@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 027/127] media: ti-vpe: cal: Restrict DMA to avoid memory corruption
Date:   Thu, 17 Sep 2020 22:10:40 -0400
Message-Id: <20200918021220.2066485-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikhil Devshatwar <nikhil.nd@ti.com>

[ Upstream commit 6e72eab2e7b7a157d554b8f9faed7676047be7c1 ]

When setting DMA for video capture from CSI channel, if the DMA size
is not given, it ends up writing as much data as sent by the camera.

This may lead to overwriting the buffers causing memory corruption.
Observed green lines on the default framebuffer.

Restrict the DMA to maximum height as specified in the S_FMT ioctl.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/cal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index b6dcae1ecc1be..ad344e642ddb7 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -687,12 +687,13 @@ static void pix_proc_config(struct cal_ctx *ctx)
 }
 
 static void cal_wr_dma_config(struct cal_ctx *ctx,
-			      unsigned int width)
+			      unsigned int width, unsigned int height)
 {
 	u32 val;
 
 	val = reg_read(ctx->dev, CAL_WR_DMA_CTRL(ctx->csi2_port));
 	set_field(&val, ctx->csi2_port, CAL_WR_DMA_CTRL_CPORT_MASK);
+	set_field(&val, height, CAL_WR_DMA_CTRL_YSIZE_MASK);
 	set_field(&val, CAL_WR_DMA_CTRL_DTAG_PIX_DAT,
 		  CAL_WR_DMA_CTRL_DTAG_MASK);
 	set_field(&val, CAL_WR_DMA_CTRL_MODE_CONST,
@@ -1318,7 +1319,8 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 	csi2_lane_config(ctx);
 	csi2_ctx_config(ctx);
 	pix_proc_config(ctx);
-	cal_wr_dma_config(ctx, ctx->v_fmt.fmt.pix.bytesperline);
+	cal_wr_dma_config(ctx, ctx->v_fmt.fmt.pix.bytesperline,
+			  ctx->v_fmt.fmt.pix.height);
 	cal_wr_dma_addr(ctx, addr);
 	csi2_ppi_enable(ctx);
 
-- 
2.25.1

