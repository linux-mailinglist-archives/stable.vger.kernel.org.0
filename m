Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659DF11B5C3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfLKPzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731574AbfLKPPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05AFD20663;
        Wed, 11 Dec 2019 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077339;
        bh=KMskS2d1qc91r8quykui3HyZFlFhTsVOYc2Ir+Blyro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anJhU2U8xL/Y0myzj6KDQCXlzLEW7Iyzh+DORgCbPBIsThOTPGsvG/SzgBVIpnEsX
         ZBZ/U+FEzQfQxoJzvVFE89jFqZn8DJGEX3DouH7EbiuMaWCR1C+JA31Le1Z/j9M9lm
         +bsyy+wvOVbuv6AUSk2LJPTjmhTUSE8+zkGlgqmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Florian Bezdeka <florian@bezdeka.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 088/105] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
Date:   Wed, 11 Dec 2019 16:06:17 +0100
Message-Id: <20191211150300.172484322@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/geode-aes.c |   57 ++++++++++++++++++++++++++-------------------
 drivers/crypto/geode-aes.h |    2 -
 2 files changed, 34 insertions(+), 25 deletions(-)

--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/skcipher.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -166,13 +167,15 @@ static int geode_setkey_blk(struct crypt
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(op->fallback.blk,
+				       tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
+	ret = crypto_sync_skcipher_setkey(op->fallback.blk, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= crypto_sync_skcipher_get_flags(op->fallback.blk) &
+				  CRYPTO_TFM_RES_MASK;
 	}
 	return ret;
 }
@@ -181,33 +184,28 @@ static int fallback_blk_dec(struct blkci
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_sync_tfm(req, op->fallback.blk);
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
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_sync_tfm(req, op->fallback.blk);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_encrypt(req);
 }
 
 static void
@@ -307,6 +305,9 @@ geode_cbc_decrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -339,6 +340,9 @@ geode_cbc_encrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
@@ -366,9 +370,8 @@ static int fallback_init_blk(struct cryp
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
-
+	op->fallback.blk = crypto_alloc_sync_skcipher(name, 0,
+						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(op->fallback.blk)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
 		return PTR_ERR(op->fallback.blk);
@@ -381,7 +384,7 @@ static void fallback_exit_blk(struct cry
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(op->fallback.blk);
+	crypto_free_sync_skcipher(op->fallback.blk);
 	op->fallback.blk = NULL;
 }
 
@@ -420,6 +423,9 @@ geode_ecb_decrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -450,6 +456,9 @@ geode_ecb_encrypt(struct blkcipher_desc
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -60,7 +60,7 @@ struct geode_aes_op {
 	u8 *iv;
 
 	union {
-		struct crypto_blkcipher *blk;
+		struct crypto_sync_skcipher *blk;
 		struct crypto_cipher *cip;
 	} fallback;
 	u32 keylen;


