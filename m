Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2885157662
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgBJMmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbgBJMmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:17 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF3A520842;
        Mon, 10 Feb 2020 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338536;
        bh=WWM6fib8opGDkswqll+d82MV6sbwE0HLaqWv3A/yaME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0V8gJvPg33MHMRTgRJORvd3p1amsSG5JD8xEJYFZZLxzQ0SblEf84PzGnfRI1PnMe
         rSUERfRRAG7Z9yjQUGWCayHxqS+1mzNl8+420FP05jvw5sqecX1LQCjuOgwrYTk9fN
         IoXqOb8fVA705SF8w1DnK22BoAaCgQGDWCgR9GBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 365/367] crypto: atmel-tdes - Map driver data flags to Mode Register
Date:   Mon, 10 Feb 2020 04:34:38 -0800
Message-Id: <20200210122456.014380489@linuxfoundation.org>
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

[ Upstream commit 848572f817721499c05b66553afc7ce0c08b1723 ]

Simplifies the configuration of the TDES IP.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 144 ++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 73 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index eaa14a80d40ce..fde34846b0170 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -41,20 +41,23 @@
 #include "atmel-tdes-regs.h"
 
 /* TDES flags  */
-#define TDES_FLAGS_MODE_MASK		0x00ff
-#define TDES_FLAGS_ENCRYPT	BIT(0)
-#define TDES_FLAGS_CBC		BIT(1)
-#define TDES_FLAGS_CFB		BIT(2)
-#define TDES_FLAGS_CFB8		BIT(3)
-#define TDES_FLAGS_CFB16	BIT(4)
-#define TDES_FLAGS_CFB32	BIT(5)
-#define TDES_FLAGS_CFB64	BIT(6)
-#define TDES_FLAGS_OFB		BIT(7)
-
-#define TDES_FLAGS_INIT		BIT(16)
-#define TDES_FLAGS_FAST		BIT(17)
-#define TDES_FLAGS_BUSY		BIT(18)
-#define TDES_FLAGS_DMA		BIT(19)
+/* Reserve bits [17:16], [13:12], [2:0] for AES Mode Register */
+#define TDES_FLAGS_ENCRYPT	TDES_MR_CYPHER_ENC
+#define TDES_FLAGS_OPMODE_MASK	(TDES_MR_OPMOD_MASK | TDES_MR_CFBS_MASK)
+#define TDES_FLAGS_ECB		TDES_MR_OPMOD_ECB
+#define TDES_FLAGS_CBC		TDES_MR_OPMOD_CBC
+#define TDES_FLAGS_OFB		TDES_MR_OPMOD_OFB
+#define TDES_FLAGS_CFB64	(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_64b)
+#define TDES_FLAGS_CFB32	(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_32b)
+#define TDES_FLAGS_CFB16	(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_16b)
+#define TDES_FLAGS_CFB8		(TDES_MR_OPMOD_CFB | TDES_MR_CFBS_8b)
+
+#define TDES_FLAGS_MODE_MASK	(TDES_FLAGS_OPMODE_MASK | TDES_FLAGS_ENCRYPT)
+
+#define TDES_FLAGS_INIT		BIT(3)
+#define TDES_FLAGS_FAST		BIT(4)
+#define TDES_FLAGS_BUSY		BIT(5)
+#define TDES_FLAGS_DMA		BIT(6)
 
 #define ATMEL_TDES_QUEUE_LENGTH	50
 
@@ -282,25 +285,7 @@ static int atmel_tdes_write_ctrl(struct atmel_tdes_dev *dd)
 		valmr |= TDES_MR_TDESMOD_DES;
 	}
 
-	if (dd->flags & TDES_FLAGS_CBC) {
-		valmr |= TDES_MR_OPMOD_CBC;
-	} else if (dd->flags & TDES_FLAGS_CFB) {
-		valmr |= TDES_MR_OPMOD_CFB;
-
-		if (dd->flags & TDES_FLAGS_CFB8)
-			valmr |= TDES_MR_CFBS_8b;
-		else if (dd->flags & TDES_FLAGS_CFB16)
-			valmr |= TDES_MR_CFBS_16b;
-		else if (dd->flags & TDES_FLAGS_CFB32)
-			valmr |= TDES_MR_CFBS_32b;
-		else if (dd->flags & TDES_FLAGS_CFB64)
-			valmr |= TDES_MR_CFBS_64b;
-	} else if (dd->flags & TDES_FLAGS_OFB) {
-		valmr |= TDES_MR_OPMOD_OFB;
-	}
-
-	if ((dd->flags & TDES_FLAGS_ENCRYPT) || (dd->flags & TDES_FLAGS_OFB))
-		valmr |= TDES_MR_CYPHER_ENC;
+	valmr |= dd->flags & TDES_FLAGS_MODE_MASK;
 
 	atmel_tdes_write(dd, TDES_CR, valcr);
 	atmel_tdes_write(dd, TDES_MR, valmr);
@@ -308,10 +293,8 @@ static int atmel_tdes_write_ctrl(struct atmel_tdes_dev *dd)
 	atmel_tdes_write_n(dd, TDES_KEY1W1R, dd->ctx->key,
 						dd->ctx->keylen >> 2);
 
-	if (((dd->flags & TDES_FLAGS_CBC) || (dd->flags & TDES_FLAGS_CFB) ||
-		(dd->flags & TDES_FLAGS_OFB)) && dd->req->iv) {
+	if (dd->req->iv && (valmr & TDES_MR_OPMOD_MASK) != TDES_MR_OPMOD_ECB)
 		atmel_tdes_write_n(dd, TDES_IV1R, (void *)dd->req->iv, 2);
-	}
 
 	return 0;
 }
@@ -402,6 +385,7 @@ static int atmel_tdes_crypt_pdc(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 {
 	struct atmel_tdes_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct atmel_tdes_dev *dd = ctx->dd;
+	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(dd->req);
 	int len32;
 
 	dd->dma_size = length;
@@ -411,12 +395,19 @@ static int atmel_tdes_crypt_pdc(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 					   DMA_TO_DEVICE);
 	}
 
-	if ((dd->flags & TDES_FLAGS_CFB) && (dd->flags & TDES_FLAGS_CFB8))
+	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
+	case TDES_FLAGS_CFB8:
 		len32 = DIV_ROUND_UP(length, sizeof(u8));
-	else if ((dd->flags & TDES_FLAGS_CFB) && (dd->flags & TDES_FLAGS_CFB16))
+		break;
+
+	case TDES_FLAGS_CFB16:
 		len32 = DIV_ROUND_UP(length, sizeof(u16));
-	else
+		break;
+
+	default:
 		len32 = DIV_ROUND_UP(length, sizeof(u32));
+		break;
+	}
 
 	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
 	atmel_tdes_write(dd, TDES_TPR, dma_addr_in);
@@ -438,8 +429,10 @@ static int atmel_tdes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 {
 	struct atmel_tdes_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct atmel_tdes_dev *dd = ctx->dd;
+	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(dd->req);
 	struct scatterlist sg[2];
 	struct dma_async_tx_descriptor	*in_desc, *out_desc;
+	enum dma_slave_buswidth addr_width;
 
 	dd->dma_size = length;
 
@@ -448,23 +441,23 @@ static int atmel_tdes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 					   DMA_TO_DEVICE);
 	}
 
-	if (dd->flags & TDES_FLAGS_CFB8) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-	} else if (dd->flags & TDES_FLAGS_CFB16) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-	} else {
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
+	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
+	case TDES_FLAGS_CFB8:
+		addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		break;
+
+	case TDES_FLAGS_CFB16:
+		addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+
+	default:
+		addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		break;
 	}
 
+	dd->dma_lch_in.dma_conf.dst_addr_width = addr_width;
+	dd->dma_lch_out.dma_conf.src_addr_width = addr_width;
+
 	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
 	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_conf);
 
@@ -701,30 +694,38 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct atmel_tdes_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(req);
 
-	if (mode & TDES_FLAGS_CFB8) {
+	switch (mode & TDES_FLAGS_OPMODE_MASK) {
+	case TDES_FLAGS_CFB8:
 		if (!IS_ALIGNED(req->cryptlen, CFB8_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of CFB8 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = CFB8_BLOCK_SIZE;
-	} else if (mode & TDES_FLAGS_CFB16) {
+		break;
+
+	case TDES_FLAGS_CFB16:
 		if (!IS_ALIGNED(req->cryptlen, CFB16_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of CFB16 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = CFB16_BLOCK_SIZE;
-	} else if (mode & TDES_FLAGS_CFB32) {
+		break;
+
+	case TDES_FLAGS_CFB32:
 		if (!IS_ALIGNED(req->cryptlen, CFB32_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of CFB32 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = CFB32_BLOCK_SIZE;
-	} else {
+		break;
+
+	default:
 		if (!IS_ALIGNED(req->cryptlen, DES_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of DES blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = DES_BLOCK_SIZE;
+		break;
 	}
 
 	rctx->mode = mode;
@@ -844,17 +845,17 @@ static int atmel_tdes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 static int atmel_tdes_ecb_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT);
+	return atmel_tdes_crypt(req, TDES_FLAGS_ECB | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_ecb_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, 0);
+	return atmel_tdes_crypt(req, TDES_FLAGS_ECB);
 }
 
 static int atmel_tdes_cbc_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CBC);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CBC | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_cbc_decrypt(struct skcipher_request *req)
@@ -863,50 +864,47 @@ static int atmel_tdes_cbc_decrypt(struct skcipher_request *req)
 }
 static int atmel_tdes_cfb_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB64 | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_cfb_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB64);
 }
 
 static int atmel_tdes_cfb8_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
-						TDES_FLAGS_CFB8);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB8 | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_cfb8_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB8);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB8);
 }
 
 static int atmel_tdes_cfb16_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
-						TDES_FLAGS_CFB16);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB16 | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_cfb16_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB16);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB16);
 }
 
 static int atmel_tdes_cfb32_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_CFB |
-						TDES_FLAGS_CFB32);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB32 | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_cfb32_decrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_CFB | TDES_FLAGS_CFB32);
+	return atmel_tdes_crypt(req, TDES_FLAGS_CFB32);
 }
 
 static int atmel_tdes_ofb_encrypt(struct skcipher_request *req)
 {
-	return atmel_tdes_crypt(req, TDES_FLAGS_ENCRYPT | TDES_FLAGS_OFB);
+	return atmel_tdes_crypt(req, TDES_FLAGS_OFB | TDES_FLAGS_ENCRYPT);
 }
 
 static int atmel_tdes_ofb_decrypt(struct skcipher_request *req)
-- 
2.20.1



