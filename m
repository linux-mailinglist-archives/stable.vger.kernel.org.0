Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB27712C96A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbfL2SHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731431AbfL2RsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB33E206DB;
        Sun, 29 Dec 2019 17:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641699;
        bh=u9R7HTgwarOv0wUlUwQOwWhPK9d/LWi/IGgzsfiya6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNX2/lPAZGYwwQc+2znVqD5afMn9P70TV77g9ZNSTZvnEa+9slqbuykDy28Up8c4R
         egbOR624AqUWCStwHLMKMtWNFpD3/NjexWi1Ay2+/HDq1yBtWEyI91nyVi2Gs2q61x
         Bv7Pmsu06vwk2KrPCvs3SM980t7MXYxXzkowolIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/434] media: cedrus: Fix undefined shift with a SHIFT_AND_MASK_BITS macro
Date:   Sun, 29 Dec 2019 18:23:46 +0100
Message-Id: <20191229172713.300684530@linuxfoundation.org>
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
index ddd29788d685..f9dd8cbf3458 100644
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



