Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239CD14B93A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgA1O3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387601AbgA1O3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6E724688;
        Tue, 28 Jan 2020 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221753;
        bh=DGkn0T8um9aUZbLl16ewYz61FG8Hvju4fsmee5CFgaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+cuqlJbW0R1vcEVX4SnbYneB6p+TGqhS2mUAe86GlkdbH/fuM3kzX6IH7YVrZYIP
         c1rxWJ5Sv1YZzG/u/YgoR+R6yFtVZY7lEM5mztdbCasVtt8rYotx+TAJXyjYaPE0CO
         m7yw4u7DWVCq+t4Hr59oNnHOyetCv+qvLWlTcNmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Florian Bezdeka <florian@bezdeka.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 60/92] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
Date:   Tue, 28 Jan 2020 15:08:28 +0100
Message-Id: <20200128135816.937763211@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 504582e8e40b90b8f8c58783e2d1e4f6a2b71a3a upstream.

Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
the generic CBC template wrapper from a blkcipher to a skcipher algo,
to get away from the deprecated blkcipher interface. However, as a side
effect, drivers that instantiate CBC transforms using the blkcipher as
a fallback no longer work, since skciphers can wrap blkciphers but not
the other way around. This broke the geode-aes driver.

So let's fix it by moving to the sync skcipher interface when allocating
the fallback. At the same time, align with the generic API for ECB and
CBC by rejecting inputs that are not a multiple of the AES block size.

Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
Cc: <stable@vger.kernel.org> # v4.20+ ONLY
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/geode-aes.c |   57 ++++++++++++++++++++++++++-------------------
 drivers/crypto/geode-aes.h |    2 -
 2 files changed, 35 insertions(+), 24 deletions(-)

--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/skcipher.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -170,13 +171,15 @@ static int geode_setkey_blk(struct crypt
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(op->fallback.blk,
+				  tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
+	ret = crypto_skcipher_setkey(op->fallback.blk, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= crypto_skcipher_get_flags(op->fallback.blk) &
+				  CRYPTO_TFM_RES_MASK;
 	}
 	return ret;
 }
@@ -185,33 +188,28 @@ static int fallback_blk_dec(struct blkci
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_tfm(req, op->fallback.blk);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_decrypt(req);
 }
+
 static int fallback_blk_enc(struct blkcipher_desc *desc,
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_tfm(req, op->fallback.blk);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_encrypt(req);
 }
 
 static void
@@ -311,6 +309,9 @@ geode_cbc_decrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -343,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
@@ -370,8 +374,9 @@ static int fallback_init_blk(struct cryp
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	op->fallback.blk = crypto_alloc_skcipher(name, 0,
+						 CRYPTO_ALG_ASYNC |
+						 CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(op->fallback.blk)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
@@ -385,7 +390,7 @@ static void fallback_exit_blk(struct cry
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(op->fallback.blk);
+	crypto_free_skcipher(op->fallback.blk);
 	op->fallback.blk = NULL;
 }
 
@@ -424,6 +429,9 @@ geode_ecb_decrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -454,6 +462,9 @@ geode_ecb_encrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -64,7 +64,7 @@ struct geode_aes_op {
 	u8 *iv;
 
 	union {
-		struct crypto_blkcipher *blk;
+		struct crypto_skcipher *blk;
 		struct crypto_cipher *cip;
 	} fallback;
 	u32 keylen;


