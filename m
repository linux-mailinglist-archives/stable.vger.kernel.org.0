Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715DE499968
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455206AbiAXVe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452527AbiAXVZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:25:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7530DC01D7DE;
        Mon, 24 Jan 2022 12:18:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C7A3B812A5;
        Mon, 24 Jan 2022 20:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B036C33DFC;
        Mon, 24 Jan 2022 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055487;
        bh=etfi1XoxwPCCKLkAB4cI1QWD8NDS0GEZK+3hfTrKG3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAGfx9+rX7QTPX2sBPpX7isIDLqcvrhVcjeIkMjTnDsUVh8FrRNU3+XhTJ7TbBZJ9
         1uShcsyfW3FqdzdB1qS0TDGMQ4jp7ubvn4znnnoB7pBKM5sSa3gomVxKVcP113+lSy
         0kcT1o7Mr9Qe8/XZxraTZ8INZY6d4qBsuAG/rztw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/846] media: hantro: Hook up RK3399 JPEG encoder output
Date:   Mon, 24 Jan 2022 19:34:44 +0100
Message-Id: <20220124184106.738124517@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 230d683ae04894933720425c8dead9508a09ebc3 ]

The JPEG encoder found in the Hantro H1 encoder block only produces a
raw entropy-encoded scan. The driver is responsible for building a JPEG
compliant bitstream and placing the entropy-encoded scan in it. Right
now the driver uses a bounce buffer for the hardware to output the raw
scan to.

In commit e765dba11ec2 ("hantro: Move hantro_enc_buf_finish to JPEG
codec_ops.done"), the code that copies the raw scan from the bounce
buffer to the capture buffer was moved, but was only hooked up for the
Hantro H1 (then RK3288) variant. The RK3399 variant was broken,
producing a JPEG bitstream without the scan, and the capture buffer's
.bytesused field unset.

Fix this by duplicating the code that is executed when the JPEG encoder
finishes encoding a frame. As the encoded length is read back from
hardware, and the variants having different register layouts, the
code is duplicated rather than shared.

Fixes: e765dba11ec2 ("hantro: Move hantro_enc_buf_finish to JPEG codec_ops.done")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/hantro/hantro_h1_jpeg_enc.c   |  2 +-
 drivers/staging/media/hantro/hantro_hw.h        |  3 ++-
 .../media/hantro/rockchip_vpu2_hw_jpeg_enc.c    | 17 +++++++++++++++++
 drivers/staging/media/hantro/rockchip_vpu_hw.c  |  5 +++--
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
index 56cf261a8e958..9cd713c02a455 100644
--- a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
+++ b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
@@ -140,7 +140,7 @@ int hantro_h1_jpeg_enc_run(struct hantro_ctx *ctx)
 	return 0;
 }
 
-void hantro_jpeg_enc_done(struct hantro_ctx *ctx)
+void hantro_h1_jpeg_enc_done(struct hantro_ctx *ctx)
 {
 	struct hantro_dev *vpu = ctx->dev;
 	u32 bytesused = vepu_read(vpu, H1_REG_STR_BUF_LIMIT) / 8;
diff --git a/drivers/staging/media/hantro/hantro_hw.h b/drivers/staging/media/hantro/hantro_hw.h
index df7b5e3a57b9b..fd738653a5735 100644
--- a/drivers/staging/media/hantro/hantro_hw.h
+++ b/drivers/staging/media/hantro/hantro_hw.h
@@ -235,7 +235,8 @@ int hantro_h1_jpeg_enc_run(struct hantro_ctx *ctx);
 int rockchip_vpu2_jpeg_enc_run(struct hantro_ctx *ctx);
 int hantro_jpeg_enc_init(struct hantro_ctx *ctx);
 void hantro_jpeg_enc_exit(struct hantro_ctx *ctx);
-void hantro_jpeg_enc_done(struct hantro_ctx *ctx);
+void hantro_h1_jpeg_enc_done(struct hantro_ctx *ctx);
+void rockchip_vpu2_jpeg_enc_done(struct hantro_ctx *ctx);
 
 dma_addr_t hantro_h264_get_ref_buf(struct hantro_ctx *ctx,
 				   unsigned int dpb_idx);
diff --git a/drivers/staging/media/hantro/rockchip_vpu2_hw_jpeg_enc.c b/drivers/staging/media/hantro/rockchip_vpu2_hw_jpeg_enc.c
index 991213ce16108..5d9ff420f0b5f 100644
--- a/drivers/staging/media/hantro/rockchip_vpu2_hw_jpeg_enc.c
+++ b/drivers/staging/media/hantro/rockchip_vpu2_hw_jpeg_enc.c
@@ -171,3 +171,20 @@ int rockchip_vpu2_jpeg_enc_run(struct hantro_ctx *ctx)
 
 	return 0;
 }
+
+void rockchip_vpu2_jpeg_enc_done(struct hantro_ctx *ctx)
+{
+	struct hantro_dev *vpu = ctx->dev;
+	u32 bytesused = vepu_read(vpu, VEPU_REG_STR_BUF_LIMIT) / 8;
+	struct vb2_v4l2_buffer *dst_buf = hantro_get_dst_buf(ctx);
+
+	/*
+	 * TODO: Rework the JPEG encoder to eliminate the need
+	 * for a bounce buffer.
+	 */
+	memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0) +
+	       ctx->vpu_dst_fmt->header_size,
+	       ctx->jpeg_enc.bounce_buffer.cpu, bytesused);
+	vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+			      ctx->vpu_dst_fmt->header_size + bytesused);
+}
diff --git a/drivers/staging/media/hantro/rockchip_vpu_hw.c b/drivers/staging/media/hantro/rockchip_vpu_hw.c
index d4f52957cc534..0c22039162a00 100644
--- a/drivers/staging/media/hantro/rockchip_vpu_hw.c
+++ b/drivers/staging/media/hantro/rockchip_vpu_hw.c
@@ -343,7 +343,7 @@ static const struct hantro_codec_ops rk3066_vpu_codec_ops[] = {
 		.run = hantro_h1_jpeg_enc_run,
 		.reset = rockchip_vpu1_enc_reset,
 		.init = hantro_jpeg_enc_init,
-		.done = hantro_jpeg_enc_done,
+		.done = hantro_h1_jpeg_enc_done,
 		.exit = hantro_jpeg_enc_exit,
 	},
 	[HANTRO_MODE_H264_DEC] = {
@@ -371,7 +371,7 @@ static const struct hantro_codec_ops rk3288_vpu_codec_ops[] = {
 		.run = hantro_h1_jpeg_enc_run,
 		.reset = rockchip_vpu1_enc_reset,
 		.init = hantro_jpeg_enc_init,
-		.done = hantro_jpeg_enc_done,
+		.done = hantro_h1_jpeg_enc_done,
 		.exit = hantro_jpeg_enc_exit,
 	},
 	[HANTRO_MODE_H264_DEC] = {
@@ -399,6 +399,7 @@ static const struct hantro_codec_ops rk3399_vpu_codec_ops[] = {
 		.run = rockchip_vpu2_jpeg_enc_run,
 		.reset = rockchip_vpu2_enc_reset,
 		.init = hantro_jpeg_enc_init,
+		.done = rockchip_vpu2_jpeg_enc_done,
 		.exit = hantro_jpeg_enc_exit,
 	},
 	[HANTRO_MODE_H264_DEC] = {
-- 
2.34.1



