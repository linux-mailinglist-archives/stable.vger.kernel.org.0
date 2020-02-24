Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AED016AC40
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 17:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgBXQyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 11:54:07 -0500
Received: from www.linuxtv.org ([130.149.80.248]:36406 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgBXQyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 11:54:07 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6Gxx-0093eK-Tj; Mon, 24 Feb 2020 16:52:21 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 16:18:13 +0000
Subject: [git:media_tree/master] media: hantro: Read be32 words starting at every fourth byte
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6Gxx-0093eK-Tj@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Read be32 words starting at every fourth byte
Author:  Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Date:    Mon Jan 27 15:30:06 2020 +0100

Since (luma/chroma)_qtable is an array of unsigned char, indexing it
returns consecutive byte locations, but we are supposed to read the arrays
in four-byte words. Consequently, we should be pointing
get_unaligned_be32() at consecutive word locations instead.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
Cc: stable@vger.kernel.org
Fixes: 00c30f42c7595f "media: rockchip vpu: remove some unused vars"
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c     | 9 +++++++--
 drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c | 9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

---

diff --git a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
index 0d8afc3e5d71..4f72d92cd98f 100644
--- a/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
+++ b/drivers/staging/media/hantro/hantro_h1_jpeg_enc.c
@@ -67,12 +67,17 @@ hantro_h1_jpeg_enc_set_qtable(struct hantro_dev *vpu,
 			      unsigned char *chroma_qtable)
 {
 	u32 reg, i;
+	__be32 *luma_qtable_p;
+	__be32 *chroma_qtable_p;
+
+	luma_qtable_p = (__be32 *)luma_qtable;
+	chroma_qtable_p = (__be32 *)chroma_qtable;
 
 	for (i = 0; i < H1_JPEG_QUANT_TABLE_COUNT; i++) {
-		reg = get_unaligned_be32(&luma_qtable[i]);
+		reg = get_unaligned_be32(&luma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, H1_REG_JPEG_LUMA_QUAT(i));
 
-		reg = get_unaligned_be32(&chroma_qtable[i]);
+		reg = get_unaligned_be32(&chroma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, H1_REG_JPEG_CHROMA_QUAT(i));
 	}
 }
diff --git a/drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c
index 4c2d43fb6fd1..a85c4f9fd10a 100644
--- a/drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c
@@ -98,12 +98,17 @@ rk3399_vpu_jpeg_enc_set_qtable(struct hantro_dev *vpu,
 			       unsigned char *chroma_qtable)
 {
 	u32 reg, i;
+	__be32 *luma_qtable_p;
+	__be32 *chroma_qtable_p;
+
+	luma_qtable_p = (__be32 *)luma_qtable;
+	chroma_qtable_p = (__be32 *)chroma_qtable;
 
 	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
-		reg = get_unaligned_be32(&luma_qtable[i]);
+		reg = get_unaligned_be32(&luma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
 
-		reg = get_unaligned_be32(&chroma_qtable[i]);
+		reg = get_unaligned_be32(&chroma_qtable_p[i]);
 		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_CHROMA_QUAT(i));
 	}
 }
