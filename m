Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63B2147AAB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgAXJgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgAXJgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:36:54 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D07A8214AF;
        Fri, 24 Jan 2020 09:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858613;
        bh=GMUtTIjylQCJKRf7RhyMRUlXYbmcZ9aghfJdTjF50i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0io3N01Cei6thB5GnX6Ls1Fd3YC3MNvSaw9XoaQMleV41oXI3Ujls6oW2Zjq6jWU
         at/dMtOeNtcgLpt8x9+AZhFlxICHjkPdGKxGT4GnT8XEJJ45zipzbhhnY4rin6Lx+t
         EcacmL5dEXZBceUtNohSnxYZ3ChHpH7ErSFfsV9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 006/343] crypto: sun4i-ss - fix big endian issues
Date:   Fri, 24 Jan 2020 10:27:04 +0100
Message-Id: <20200124092920.419083397@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

commit d1d787bcebfe122a5bd443ae565696661e2e9656 upstream.

When testing BigEndian kernel, the sun4i-ss was failling all crypto
tests.
This patch fix endian issues with it.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -179,7 +179,7 @@ static int sun4i_hash(struct ahash_reque
 	 */
 	unsigned int i = 0, end, fill, min_fill, nwait, nbw = 0, j = 0, todo;
 	unsigned int in_i = 0;
-	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, wb = 0, v, ivmode = 0;
+	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
@@ -188,6 +188,7 @@ static int sun4i_hash(struct ahash_reque
 	struct sg_mapping_iter mi;
 	int in_r, err = 0;
 	size_t copied = 0;
+	__le32 wb = 0;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
@@ -399,7 +400,7 @@ hash_final:
 
 		nbw = op->len - 4 * nwait;
 		if (nbw) {
-			wb = *(u32 *)(op->buf + nwait * 4);
+			wb = cpu_to_le32(*(u32 *)(op->buf + nwait * 4));
 			wb &= GENMASK((nbw * 8) - 1, 0);
 
 			op->byte_count += nbw;
@@ -408,7 +409,7 @@ hash_final:
 
 	/* write the remaining bytes of the nbw buffer */
 	wb |= ((1 << 7) << (nbw * 8));
-	bf[j++] = wb;
+	bf[j++] = le32_to_cpu(wb);
 
 	/*
 	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
@@ -427,13 +428,13 @@ hash_final:
 
 	/* write the length of data */
 	if (op->mode == SS_OP_SHA1) {
-		__be64 bits = cpu_to_be64(op->byte_count << 3);
-		bf[j++] = lower_32_bits(bits);
-		bf[j++] = upper_32_bits(bits);
+		__be64 *bits = (__be64 *)&bf[j];
+		*bits = cpu_to_be64(op->byte_count << 3);
+		j += 2;
 	} else {
-		__le64 bits = op->byte_count << 3;
-		bf[j++] = lower_32_bits(bits);
-		bf[j++] = upper_32_bits(bits);
+		__le64 *bits = (__le64 *)&bf[j];
+		*bits = cpu_to_le64(op->byte_count << 3);
+		j += 2;
 	}
 	writesl(ss->base + SS_RXFIFO, bf, j);
 
@@ -475,7 +476,7 @@ hash_final:
 		}
 	} else {
 		for (i = 0; i < 4; i++) {
-			v = readl(ss->base + SS_MD0 + i * 4);
+			v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
 			memcpy(areq->result + i * 4, &v, 4);
 		}
 	}


