Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37CAD157678
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgBJMwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730198AbgBJMmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B111020661;
        Mon, 10 Feb 2020 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338535;
        bh=8PhorLcVVruykYZgtpPgsqnyXsagz0RSq9BrUyTTfug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIfxDvlY/cGm3lk9yv3+LWuJ8veRgK3GOevDeQYAY1WMNKTryEQqau/QFbL0ivXAD
         FydypoJ8fX2vZ7+NJIC95cBqydJjiHaXysqVQ/tbaiMI64XSc8oR3i8SChV8DX5YRI
         1pZWdqvFRK019NZe//GsoI2J1ADLOCOEJEL3L3rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 363/367] crypto: atmel-aes - Fix saving of IV for CTR mode
Date:   Mon, 10 Feb 2020 04:34:36 -0800
Message-Id: <20200210122455.849290023@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 371731ec2179d5810683406e7fc284b41b127df7 ]

The req->iv of the skcipher_request is expected to contain the
last used IV. Update the req->iv for CTR mode.

Fixes: bd3c7b5c2aba ("crypto: atmel - add Atmel AES driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 43 +++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 7b7079db2e860..ea9dcd7ce799b 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -121,6 +121,7 @@ struct atmel_aes_ctr_ctx {
 	size_t			offset;
 	struct scatterlist	src[2];
 	struct scatterlist	dst[2];
+	u16			blocks;
 };
 
 struct atmel_aes_gcm_ctx {
@@ -513,6 +514,26 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev *dd)
 	}
 }
 
+static inline struct atmel_aes_ctr_ctx *
+atmel_aes_ctr_ctx_cast(struct atmel_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct atmel_aes_ctr_ctx, base);
+}
+
+static void atmel_aes_ctr_update_req_iv(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_ctr_ctx *ctx = atmel_aes_ctr_ctx_cast(dd->ctx);
+	struct skcipher_request *req = skcipher_request_cast(dd->areq);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+	int i;
+
+	for (i = 0; i < ctx->blocks; i++)
+		crypto_inc((u8 *)ctx->iv, AES_BLOCK_SIZE);
+
+	memcpy(req->iv, ctx->iv, ivsize);
+}
+
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
 	struct skcipher_request *req = skcipher_request_cast(dd->areq);
@@ -527,8 +548,12 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	dd->flags &= ~AES_FLAGS_BUSY;
 
 	if (!dd->ctx->is_aead &&
-	    (rctx->mode & AES_FLAGS_OPMODE_MASK) != AES_FLAGS_ECB)
-		atmel_aes_set_iv_as_last_ciphertext_block(dd);
+	    (rctx->mode & AES_FLAGS_OPMODE_MASK) != AES_FLAGS_ECB) {
+		if ((rctx->mode & AES_FLAGS_OPMODE_MASK) != AES_FLAGS_CTR)
+			atmel_aes_set_iv_as_last_ciphertext_block(dd);
+		else
+			atmel_aes_ctr_update_req_iv(dd);
+	}
 
 	if (dd->is_async)
 		dd->areq->complete(dd->areq, err);
@@ -1007,12 +1032,6 @@ static int atmel_aes_start(struct atmel_aes_dev *dd)
 				   atmel_aes_transfer_complete);
 }
 
-static inline struct atmel_aes_ctr_ctx *
-atmel_aes_ctr_ctx_cast(struct atmel_aes_base_ctx *ctx)
-{
-	return container_of(ctx, struct atmel_aes_ctr_ctx, base);
-}
-
 static int atmel_aes_ctr_transfer(struct atmel_aes_dev *dd)
 {
 	struct atmel_aes_ctr_ctx *ctx = atmel_aes_ctr_ctx_cast(dd->ctx);
@@ -1020,7 +1039,7 @@ static int atmel_aes_ctr_transfer(struct atmel_aes_dev *dd)
 	struct scatterlist *src, *dst;
 	size_t datalen;
 	u32 ctr;
-	u16 blocks, start, end;
+	u16 start, end;
 	bool use_dma, fragmented = false;
 
 	/* Check for transfer completion. */
@@ -1030,14 +1049,14 @@ static int atmel_aes_ctr_transfer(struct atmel_aes_dev *dd)
 
 	/* Compute data length. */
 	datalen = req->cryptlen - ctx->offset;
-	blocks = DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
+	ctx->blocks = DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
 	ctr = be32_to_cpu(ctx->iv[3]);
 
 	/* Check 16bit counter overflow. */
 	start = ctr & 0xffff;
-	end = start + blocks - 1;
+	end = start + ctx->blocks - 1;
 
-	if (blocks >> 16 || end < start) {
+	if (ctx->blocks >> 16 || end < start) {
 		ctr |= 0xffff;
 		datalen = AES_BLOCK_SIZE * (0x10000 - start);
 		fragmented = true;
-- 
2.20.1



