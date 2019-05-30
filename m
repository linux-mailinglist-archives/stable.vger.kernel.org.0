Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0EB2F4DF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfE3DMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbfE3DMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BACC244EF;
        Thu, 30 May 2019 03:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185935;
        bh=Ux4iU9NMy5l3YIqvdhdoJ0rRWPRxf2Q1ouyCQdxHfqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gY67FwwSYjCQ5i4o8B9GqQxGGQo//D4S9dheVgAi2joKq9DBf8oZyZuUD+Wd54hj8
         F4IGQS98XvwnAwwG3GhMgyYbZkYLFvlbd0lLBWKYr+rGn1UK4Pzb+CtFtQ8pO9s/mH
         FhpntAXWH0NSviNEsnYWxg0H4hHX+spvdj1ScCkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Courbot <acourbot@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 290/405] media: mtk-vcodec: fix access to incorrect planes member
Date:   Wed, 29 May 2019 20:04:48 -0700
Message-Id: <20190530030555.531409844@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 52fafc58c3535c9f4f53864686dbaee3bcbadcb4 ]

Commit 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem
buffer helpers") fixed the return types for mem2mem buffer helper
functions by changing a few local variables from vb2_buffer to
vb2_v4l2_buffer. However, it left a few accesses to vb2_buffer::planes
as-is, accidentally turning them into accesses to
vb2_v4l2_buffer::planes and resulting in values being read from/written
to the wrong place.

Fix this by inserting vb2_buf into these accesses so they mimic their
original behavior.

Fixes: 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem buffer helpers")

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  4 ++--
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index d022c65bb34c2..49babf994cb75 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -388,7 +388,7 @@ static void mtk_vdec_worker(struct work_struct *work)
 	}
 	buf.va = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
 	buf.dma_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
-	buf.size = (size_t)src_buf->planes[0].bytesused;
+	buf.size = (size_t)src_buf->vb2_buf.planes[0].bytesused;
 	if (!buf.va) {
 		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 		mtk_v4l2_err("[%d] id=%d src_addr is NULL!!",
@@ -1155,7 +1155,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 
 	src_mem.va = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
 	src_mem.dma_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
-	src_mem.size = (size_t)src_buf->planes[0].bytesused;
+	src_mem.size = (size_t)src_buf->vb2_buf.planes[0].bytesused;
 	mtk_v4l2_debug(2,
 			"[%d] buf id=%d va=%p dma=%pad size=%zx",
 			ctx->id, src_buf->index,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index c6b48b5925fbe..50351adafc470 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -894,7 +894,7 @@ static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
-			dst_buf->planes[0].bytesused = 0;
+			dst_buf->vb2_buf.planes[0].bytesused = 0;
 			v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		}
 	} else {
@@ -947,7 +947,7 @@ static int mtk_venc_encode_header(void *priv)
 
 	bs_buf.va = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
 	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
-	bs_buf.size = (size_t)dst_buf->planes[0].length;
+	bs_buf.size = (size_t)dst_buf->vb2_buf.planes[0].length;
 
 	mtk_v4l2_debug(1,
 			"[%d] buf id=%d va=0x%p dma_addr=0x%llx size=%zu",
@@ -976,7 +976,7 @@ static int mtk_venc_encode_header(void *priv)
 	}
 
 	ctx->state = MTK_STATE_HEADER;
-	dst_buf->planes[0].bytesused = enc_result.bs_size;
+	dst_buf->vb2_buf.planes[0].bytesused = enc_result.bs_size;
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
 	return 0;
@@ -1107,12 +1107,12 @@ static void mtk_venc_worker(struct work_struct *work)
 
 	if (ret) {
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
-		dst_buf->planes[0].bytesused = 0;
+		dst_buf->vb2_buf.planes[0].bytesused = 0;
 		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		mtk_v4l2_err("venc_if_encode failed=%d", ret);
 	} else {
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
-		dst_buf->planes[0].bytesused = enc_result.bs_size;
+		dst_buf->vb2_buf.planes[0].bytesused = enc_result.bs_size;
 		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 		mtk_v4l2_debug(2, "venc_if_encode bs size=%d",
 				 enc_result.bs_size);
-- 
2.20.1



