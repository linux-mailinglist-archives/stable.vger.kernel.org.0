Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACEB1196FF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfLJVa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbfLJVJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76098246A2;
        Tue, 10 Dec 2019 21:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012188;
        bh=LOmML4j0AvqWLR08iz2857qkXOPq9QctwnVX/F+K1Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4iE8ce0AhvVJh9i2UKLfRXBdYuiCf5+6L+fPYSTcGlQhYTy4KGcLxDjj0fMundVS
         mbXwix3r8Sb9x6o/lbYmHJlpcJCJf+OCnUKd7b2zbFwBdnf26OrMscrUxl/bWSlFhc
         2kvF/SB4pO2CpoG3IulSP2EkPaC0gDFYrCGGxEdc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 144/350] media: cedrus: Fix undefined shift with a SHIFT_AND_MASK_BITS macro
Date:   Tue, 10 Dec 2019 16:04:09 -0500
Message-Id: <20191210210735.9077-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 06eff2150d4db991ca236f3d05a9dc0101475aea ]

We need to shift and mask values at different occasions to fill up
cedrus registers. This was done using macros that don't explicitly
treat arguments as unsigned, leading to possibly undefined behavior.

Introduce the SHIFT_AND_MASK_BITS macro and use it where possible.
In cases where it doesn't apply as-is, explicitly cast to unsigned
instead.

This macro should be moved to include/linux/bits.h eventually.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/sunxi/cedrus/cedrus_regs.h  | 31 ++++++++++---------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
index ddd29788d685b..f9dd8cbf34582 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -10,6 +10,9 @@
 #ifndef _CEDRUS_REGS_H_
 #define _CEDRUS_REGS_H_
 
+#define SHIFT_AND_MASK_BITS(v, h, l) \
+	(((unsigned long)(v) << (l)) & GENMASK(h, l))
+
 /*
  * Common acronyms and contractions used in register descriptions:
  * * VLD : Variable-Length Decoder
@@ -37,8 +40,8 @@
 #define VE_PRIMARY_CHROMA_BUF_LEN		0xc4
 #define VE_PRIMARY_FB_LINE_STRIDE		0xc8
 
-#define VE_PRIMARY_FB_LINE_STRIDE_CHROMA(s)	(((s) << 16) & GENMASK(31, 16))
-#define VE_PRIMARY_FB_LINE_STRIDE_LUMA(s)	(((s) << 0) & GENMASK(15, 0))
+#define VE_PRIMARY_FB_LINE_STRIDE_CHROMA(s)	SHIFT_AND_MASK_BITS(s, 31, 16)
+#define VE_PRIMARY_FB_LINE_STRIDE_LUMA(s)	SHIFT_AND_MASK_BITS(s, 15, 0)
 
 #define VE_CHROMA_BUF_LEN			0xe8
 
@@ -46,7 +49,7 @@
 #define VE_SECONDARY_OUT_FMT_EXT		(0x01 << 30)
 #define VE_SECONDARY_OUT_FMT_YU12		(0x02 << 30)
 #define VE_SECONDARY_OUT_FMT_YV12		(0x03 << 30)
-#define VE_CHROMA_BUF_LEN_SDRT(l)		((l) & GENMASK(27, 0))
+#define VE_CHROMA_BUF_LEN_SDRT(l)		SHIFT_AND_MASK_BITS(l, 27, 0)
 
 #define VE_PRIMARY_OUT_FMT			0xec
 
@@ -69,15 +72,15 @@
 
 #define VE_DEC_MPEG_MP12HDR			(VE_ENGINE_DEC_MPEG + 0x00)
 
-#define VE_DEC_MPEG_MP12HDR_SLICE_TYPE(t)	(((t) << 28) & GENMASK(30, 28))
+#define VE_DEC_MPEG_MP12HDR_SLICE_TYPE(t)	SHIFT_AND_MASK_BITS(t, 30, 28)
 #define VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)	(24 - 4 * (y) - 8 * (x))
 #define VE_DEC_MPEG_MP12HDR_F_CODE(__x, __y, __v) \
-	(((__v) & GENMASK(3, 0)) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(__x, __y))
+	(((unsigned long)(__v) & GENMASK(3, 0)) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(__x, __y))
 
 #define VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(p) \
-	(((p) << 10) & GENMASK(11, 10))
+	SHIFT_AND_MASK_BITS(p, 11, 10)
 #define VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(s) \
-	(((s) << 8) & GENMASK(9, 8))
+	SHIFT_AND_MASK_BITS(s, 9, 8)
 #define VE_DEC_MPEG_MP12HDR_TOP_FIELD_FIRST(v) \
 	((v) ? BIT(7) : 0)
 #define VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(v) \
@@ -98,19 +101,19 @@
 #define VE_DEC_MPEG_PICCODEDSIZE		(VE_ENGINE_DEC_MPEG + 0x08)
 
 #define VE_DEC_MPEG_PICCODEDSIZE_WIDTH(w) \
-	((DIV_ROUND_UP((w), 16) << 8) & GENMASK(15, 8))
+	SHIFT_AND_MASK_BITS(DIV_ROUND_UP((w), 16), 15, 8)
 #define VE_DEC_MPEG_PICCODEDSIZE_HEIGHT(h) \
-	((DIV_ROUND_UP((h), 16) << 0) & GENMASK(7, 0))
+	SHIFT_AND_MASK_BITS(DIV_ROUND_UP((h), 16), 7, 0)
 
 #define VE_DEC_MPEG_PICBOUNDSIZE		(VE_ENGINE_DEC_MPEG + 0x0c)
 
-#define VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(w)	(((w) << 16) & GENMASK(27, 16))
-#define VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(h)	(((h) << 0) & GENMASK(11, 0))
+#define VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(w)	SHIFT_AND_MASK_BITS(w, 27, 16)
+#define VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(h)	SHIFT_AND_MASK_BITS(h, 11, 0)
 
 #define VE_DEC_MPEG_MBADDR			(VE_ENGINE_DEC_MPEG + 0x10)
 
-#define VE_DEC_MPEG_MBADDR_X(w)			(((w) << 8) & GENMASK(15, 8))
-#define VE_DEC_MPEG_MBADDR_Y(h)			(((h) << 0) & GENMASK(7, 0))
+#define VE_DEC_MPEG_MBADDR_X(w)			SHIFT_AND_MASK_BITS(w, 15, 8)
+#define VE_DEC_MPEG_MBADDR_Y(h)			SHIFT_AND_MASK_BITS(h, 7, 0)
 
 #define VE_DEC_MPEG_CTRL			(VE_ENGINE_DEC_MPEG + 0x14)
 
@@ -225,7 +228,7 @@
 #define VE_DEC_MPEG_IQMINPUT_FLAG_INTRA		(0x01 << 14)
 #define VE_DEC_MPEG_IQMINPUT_FLAG_NON_INTRA	(0x00 << 14)
 #define VE_DEC_MPEG_IQMINPUT_WEIGHT(i, v) \
-	(((v) & GENMASK(7, 0)) | (((i) << 8) & GENMASK(13, 8)))
+	(SHIFT_AND_MASK_BITS(i, 13, 8) | SHIFT_AND_MASK_BITS(v, 7, 0))
 
 #define VE_DEC_MPEG_ERROR			(VE_ENGINE_DEC_MPEG + 0xc4)
 #define VE_DEC_MPEG_CRTMBADDR			(VE_ENGINE_DEC_MPEG + 0xc8)
-- 
2.20.1

