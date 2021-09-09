Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82835404E51
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbhIIMLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344593AbhIIMG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7093A61215;
        Thu,  9 Sep 2021 11:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188053;
        bh=Y9yifLqTMAhtK6J/aU0Oho44D67037QoREffN/4CvcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBEROKbdK71gAUjgLUOmHuI1sT7qc9SPQEnTKSiWbGiyQgM+UD43oQ1gs4g6x4hUs
         WEF1u+2EumOyvmS6P/armJxbb2HzE/nyYMwbf2v4maMOmYZg31cOesWDuGpIZK/lrs
         qQpLf9pi5mJbPnm94cOiGT8WVFojfJShYfUfFx+e5wlB+e2nDYx8b54cgv+bl+irzm
         xU1LPvjPCaJ87P3DCXyhKYaV4c1lAiLwVd3BRsWVKo6vjomSPymclthVOJFGHB+TEB
         dCHNmCZ0lTsXuwSYHs3WmwtsMqz2nuQJDLRixi6VEAF8iUvMUuX7tguu8BeCKof10b
         oMQdh038S4ciA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Alex Bee <knaerzche@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.13 045/219] media: hantro: vp8: Move noisy WARN_ON to vpu_debug
Date:   Thu,  9 Sep 2021 07:43:41 -0400
Message-Id: <20210909114635.143983-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 .../staging/media/hantro/rk3399_vpu_hw_vp8_dec.c    | 13 ++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_g1_vp8_dec.c b/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
index 57002ba70176..3cd90637ac63 100644
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
diff --git a/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c b/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c
index 8661a3cc1e6b..361619201605 100644
--- a/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c
+++ b/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c
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

