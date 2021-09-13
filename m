Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2440946E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbhIMObO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346137AbhIMO2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5C0561507;
        Mon, 13 Sep 2021 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540995;
        bh=6XK9ezonN+Cv5y/XbpLEd8r12K4ExVw7ZkyHY5uStW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+UPgLIHo+6Jom5Cqc60FRSNJM15IxG5pBjrQBqBOCu6LcktpPkIuD9ofsRB29OQ0
         77bjQsc7+PyTpTLqE3RbgpkAPpd9Wa0VQp0uww5uzQH33fkdl3M97dl1DT1pVEzq7E
         coZZrrsdWGr3QFpmc8+ZpmdECS9iEkEf24CgBlEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrej Picej <andrej.picej@norik.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 119/334] media: coda: fix frame_mem_ctrl for YUV420 and YVU420 formats
Date:   Mon, 13 Sep 2021 15:12:53 +0200
Message-Id: <20210913131117.389877533@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 44693d74f5653f82cd7ca0fe730eed0f6b83306a ]

The frame memory control register value is currently determined
before userspace selects the final capture format and never corrected.
Update ctx->frame_mem_ctrl in __coda_start_decoding() to fix decoding
into YUV420 or YVU420 capture buffers.

Reported-by: Andrej Picej <andrej.picej@norik.com>
Fixes: 497e6b8559a6 ("media: coda: add sequence initialization work")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2f42808c43a4..c484c008ab02 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2053,17 +2053,25 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	u32 src_fourcc, dst_fourcc;
 	int ret;
 
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	src_fourcc = q_data_src->fourcc;
+	dst_fourcc = q_data_dst->fourcc;
+
 	if (!ctx->initialized) {
 		ret = __coda_decoder_seq_init(ctx);
 		if (ret < 0)
 			return ret;
+	} else {
+		ctx->frame_mem_ctrl &= ~(CODA_FRAME_CHROMA_INTERLEAVE | (0x3 << 9) |
+					 CODA9_FRAME_TILED2LINEAR);
+		if (dst_fourcc == V4L2_PIX_FMT_NV12 || dst_fourcc == V4L2_PIX_FMT_YUYV)
+			ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
+		if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
+			ctx->frame_mem_ctrl |= (0x3 << 9) |
+				((ctx->use_vdoa) ? 0 : CODA9_FRAME_TILED2LINEAR);
 	}
 
-	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	src_fourcc = q_data_src->fourcc;
-	dst_fourcc = q_data_dst->fourcc;
-
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
 
 	ret = coda_alloc_framebuffers(ctx, q_data_dst, src_fourcc);
-- 
2.30.2



