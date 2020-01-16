Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC213FF5A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgAPXmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389563AbgAPX0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 611B820684;
        Thu, 16 Jan 2020 23:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217204;
        bh=fie/VVcWmbXEWsdoSUFANSBNvQIF5+dbvGAku2TdS9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPhf+e9TU9z3/TO/u4elskuwCTNdKgTCjHQ2tjUxy+UZJyyQ7Id+jPjAzfNfEuyqD
         bi6PfIvyEG21zotE9lPGVMHc6/07DvY8JAClOrx5+czQx/rTR9Kk3UVPCQQEsbPDfJ
         BR2BLduSDkzNOU743jGqFawyg6sAsUCey8XHeSs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 156/203] media: hantro: Do not reorder H264 scaling list
Date:   Fri, 17 Jan 2020 00:17:53 +0100
Message-Id: <20200116231758.448421502@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

commit e17f08e3166635d2eaa6a894afeb28ca651ddd35 upstream.

Scaling list supplied from userspace should be in matrix order
and can be used without applying the inverse scanning process.

The HW also only support 8x8 scaling list for the Y component, indices 0
and 1 in the scaling list supplied from userspace.

Remove reordering and write the scaling matrix in an order expected by
the VPU, also only allocate memory for the two 8x8 lists supported.

Fixes: a9471e25629b ("media: hantro: Add core bits to support H264 decoding")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_h264.c |   51 ++++++-----------------------
 1 file changed, 12 insertions(+), 39 deletions(-)

--- a/drivers/staging/media/hantro/hantro_h264.c
+++ b/drivers/staging/media/hantro/hantro_h264.c
@@ -20,7 +20,7 @@
 /* Size with u32 units. */
 #define CABAC_INIT_BUFFER_SIZE		(460 * 2)
 #define POC_BUFFER_SIZE			34
-#define SCALING_LIST_SIZE		(6 * 16 + 6 * 64)
+#define SCALING_LIST_SIZE		(6 * 16 + 2 * 64)
 
 #define POC_CMP(p0, p1) ((p0) < (p1) ? -1 : 1)
 
@@ -194,23 +194,6 @@ static const u32 h264_cabac_table[] = {
 	0x1f0c2517, 0x1f261440
 };
 
-/*
- * NOTE: The scaling lists are in zig-zag order, apply inverse scanning process
- * to get the values in matrix order. In addition, the hardware requires bytes
- * swapped within each subsequent 4 bytes. Both arrays below include both
- * transformations.
- */
-static const u32 zig_zag_4x4[] = {
-	3, 2, 7, 11, 6, 1, 0, 5, 10, 15, 14, 9, 4, 8, 13, 12
-};
-
-static const u32 zig_zag_8x8[] = {
-	3, 2, 11, 19, 10, 1, 0, 9, 18, 27, 35, 26, 17, 8, 7, 6,
-	15, 16, 25, 34, 43, 51, 42, 33, 24, 23, 14, 5, 4, 13, 22, 31,
-	32, 41, 50, 59, 58, 49, 40, 39, 30, 21, 12, 20, 29, 38, 47, 48,
-	57, 56, 55, 46, 37, 28, 36, 45, 54, 63, 62, 53, 44, 52, 61, 60
-};
-
 static void
 reorder_scaling_list(struct hantro_ctx *ctx)
 {
@@ -218,33 +201,23 @@ reorder_scaling_list(struct hantro_ctx *
 	const struct v4l2_ctrl_h264_scaling_matrix *scaling = ctrls->scaling;
 	const size_t num_list_4x4 = ARRAY_SIZE(scaling->scaling_list_4x4);
 	const size_t list_len_4x4 = ARRAY_SIZE(scaling->scaling_list_4x4[0]);
-	const size_t num_list_8x8 = ARRAY_SIZE(scaling->scaling_list_8x8);
 	const size_t list_len_8x8 = ARRAY_SIZE(scaling->scaling_list_8x8[0]);
 	struct hantro_h264_dec_priv_tbl *tbl = ctx->h264_dec.priv.cpu;
-	u8 *dst = tbl->scaling_list;
-	const u8 *src;
+	u32 *dst = (u32 *)tbl->scaling_list;
+	const u32 *src;
 	int i, j;
 
-	BUILD_BUG_ON(ARRAY_SIZE(zig_zag_4x4) != list_len_4x4);
-	BUILD_BUG_ON(ARRAY_SIZE(zig_zag_8x8) != list_len_8x8);
-	BUILD_BUG_ON(ARRAY_SIZE(tbl->scaling_list) !=
-		     num_list_4x4 * list_len_4x4 +
-		     num_list_8x8 * list_len_8x8);
-
-	src = &scaling->scaling_list_4x4[0][0];
-	for (i = 0; i < num_list_4x4; ++i) {
-		for (j = 0; j < list_len_4x4; ++j)
-			dst[zig_zag_4x4[j]] = src[j];
-		src += list_len_4x4;
-		dst += list_len_4x4;
+	for (i = 0; i < num_list_4x4; i++) {
+		src = (u32 *)&scaling->scaling_list_4x4[i];
+		for (j = 0; j < list_len_4x4 / 4; j++)
+			*dst++ = swab32(src[j]);
 	}
 
-	src = &scaling->scaling_list_8x8[0][0];
-	for (i = 0; i < num_list_8x8; ++i) {
-		for (j = 0; j < list_len_8x8; ++j)
-			dst[zig_zag_8x8[j]] = src[j];
-		src += list_len_8x8;
-		dst += list_len_8x8;
+	/* Only Intra/Inter Y lists */
+	for (i = 0; i < 2; i++) {
+		src = (u32 *)&scaling->scaling_list_8x8[i];
+		for (j = 0; j < list_len_8x8 / 4; j++)
+			*dst++ = swab32(src[j]);
 	}
 }
 


