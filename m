Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C97D40E6D8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348413AbhIPRZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348132AbhIPRX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 307B561BCF;
        Thu, 16 Sep 2021 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810616;
        bh=uDKUJYqqIqQdZRhp/mjQ+sG7ZBn9+fzahbqiKun/kV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP1r49se1CtxfnRxJ2Ttvz3r7vZii03s2+/QQ9KCPArd55umlBTSfHxxhfZM4hbeS
         5G0sfQ9J0DbRlu+11LS9VVVUYKs1tE5kbcnsQbq0o10h4k1PC1LeZ4vqclPp12f0gr
         vW2J0MVIaJtpLAlpPQgy5Rj+QgMEBellA9DHor1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Alex Bee <knaerzche@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 207/432] media: hantro: vp8: Move noisy WARN_ON to vpu_debug
Date:   Thu, 16 Sep 2021 17:59:16 +0200
Message-Id: <20210916155817.844384512@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 6ad61a7847da09b6261824accb539d05bcdfef65 ]

When the VP8 decoders can't find a reference frame,
the driver falls back to the current output frame.

This will probably produce some undesirable results,
leading to frame corruption, but shouldn't cause
noisy warnings.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Acked-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Tested-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_g1_vp8_dec.c    | 13 ++++++++++---
 .../staging/media/hantro/rockchip_vpu2_hw_vp8_dec.c | 13 ++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_g1_vp8_dec.c b/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
index 96622a7f8279..2afd5996d75f 100644
--- a/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
+++ b/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
@@ -376,12 +376,17 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vb2_dst = hantro_get_dst_buf(ctx);
 
 	ref = hantro_get_ref(ctx, hdr->last_frame_ts);
-	if (!ref)
+	if (!ref) {
+		vpu_debug(0, "failed to find last frame ts=%llu\n",
+			  hdr->last_frame_ts);
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
+	}
 	vdpu_write_relaxed(vpu, ref, G1_REG_ADDR_REF(0));
 
 	ref = hantro_get_ref(ctx, hdr->golden_frame_ts);
-	WARN_ON(!ref && hdr->golden_frame_ts);
+	if (!ref && hdr->golden_frame_ts)
+		vpu_debug(0, "failed to find golden frame ts=%llu\n",
+			  hdr->golden_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_GOLDEN)
@@ -389,7 +394,9 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vdpu_write_relaxed(vpu, ref, G1_REG_ADDR_REF(4));
 
 	ref = hantro_get_ref(ctx, hdr->alt_frame_ts);
-	WARN_ON(!ref && hdr->alt_frame_ts);
+	if (!ref && hdr->alt_frame_ts)
+		vpu_debug(0, "failed to find alt frame ts=%llu\n",
+			  hdr->alt_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_ALT)
diff --git a/drivers/staging/media/hantro/rockchip_vpu2_hw_vp8_dec.c b/drivers/staging/media/hantro/rockchip_vpu2_hw_vp8_dec.c
index 951b55f58a61..704607511b57 100644
--- a/drivers/staging/media/hantro/rockchip_vpu2_hw_vp8_dec.c
+++ b/drivers/staging/media/hantro/rockchip_vpu2_hw_vp8_dec.c
@@ -453,12 +453,17 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vb2_dst = hantro_get_dst_buf(ctx);
 
 	ref = hantro_get_ref(ctx, hdr->last_frame_ts);
-	if (!ref)
+	if (!ref) {
+		vpu_debug(0, "failed to find last frame ts=%llu\n",
+			  hdr->last_frame_ts);
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
+	}
 	vdpu_write_relaxed(vpu, ref, VDPU_REG_VP8_ADDR_REF0);
 
 	ref = hantro_get_ref(ctx, hdr->golden_frame_ts);
-	WARN_ON(!ref && hdr->golden_frame_ts);
+	if (!ref && hdr->golden_frame_ts)
+		vpu_debug(0, "failed to find golden frame ts=%llu\n",
+			  hdr->golden_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_GOLDEN)
@@ -466,7 +471,9 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vdpu_write_relaxed(vpu, ref, VDPU_REG_VP8_ADDR_REF2_5(2));
 
 	ref = hantro_get_ref(ctx, hdr->alt_frame_ts);
-	WARN_ON(!ref && hdr->alt_frame_ts);
+	if (!ref && hdr->alt_frame_ts)
+		vpu_debug(0, "failed to find alt frame ts=%llu\n",
+			  hdr->alt_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_ALT)
-- 
2.30.2



