Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8315C14955D
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 12:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAYLuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 06:50:05 -0500
Received: from mx1.bezdeka.de ([5.181.50.93]:51980 "EHLO smtp.bezdeka.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbgAYLuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jan 2020 06:50:05 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jan 2020 06:50:04 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bezdeka.de;
         s=mail201812; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IKz8hOIeIv39xjX6o6mzkPwTWlsH8Kvllw5HyP5yM6E=; b=fgCI6wVFUPcFMtuGZtPw8kE8RI
        DKsteGv3X0OfU/sWis6yFv/9ncwaXLxHRBguZcVhezfR2ML8/ixOwCfV9w+H6fAttpIEMZbOnUGhQ
        FGEBP+p6oSioy1igXWIkPhAgkwyVn5jlqnb2J9VP/DjEziShxRc6enyqHGTvEnUvXD/e/Fp2laAMi
        Yn7VCYG6x9knbNls/Hozjt364fJglQMv57UCYSnyR9Mg9RrX5ESWd/92+/Oi+dIbJr++W1VIHHo+S
        OJ9ZqZRREvjNPUxocuZH+1yIFSkxiC1bCPRIvUva4BZYRveNiuVJTuHvee8NbzxoQdBOd6lXQ8wrW
        OsMdm3Zg==;
Received: from [2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e] (helo=flo.bbg.bezdeka.de)
        by smtp.bezdeka.de with esmtpa (Exim 4.92.3)
        (envelope-from <florian@bezdeka.de>)
        id 1ivJqM-00048r-Bb; Sat, 25 Jan 2020 12:43:14 +0100
From:   Florian Bezdeka <florian@bezdeka.de>
To:     stable@vger.kernel.org
Cc:     Florian Bezdeka <florian@bezdeka.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH stable 4.19] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
Date:   Sat, 25 Jan 2020 12:42:50 +0100
Message-Id: <20200125114250.588589-1-florian@bezdeka.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: florian@bezdeka.de
X-Authenticator: plain
X-Exim-Version: 4.92.3 (build at 19-Nov-2019 13:15:30)
X-Date: 2020-01-25 12:43:14
X-Connected-IP: 2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e:41982
X-Message-Linecount: 195
X-Body-Linecount: 184
X-Message-Size: 6462
X-Body-Size: 6038
X-Received-Count: 1
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 504582e8e40b90b8f8c58783e2d1e4f6a2b71a3a upstream.

[Why]
This is the backport of the upstream commit for the 4.19 stable tree.

[How]
Just replaced all occurrences of *sync_skcipher* with *skcipher*
(including upper case ones), and passing 'CRYPTO_ALG_ASYNC |
CRYPTO_ALG_NEED_FALLBACK' as the third parameter to
crypto_alloc_skcipher.

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
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
---
 drivers/crypto/geode-aes.c | 57 +++++++++++++++++++++++---------------
 drivers/crypto/geode-aes.h |  2 +-
 2 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index eb2a0a73cbed..d670f7000cbb 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/skcipher.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -170,13 +171,15 @@ static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
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
@@ -185,33 +188,28 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
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
@@ -311,6 +309,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -343,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
@@ -370,8 +374,9 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	op->fallback.blk = crypto_alloc_skcipher(name, 0,
+						 CRYPTO_ALG_ASYNC |
+						 CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(op->fallback.blk)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
@@ -385,7 +390,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(op->fallback.blk);
+	crypto_free_skcipher(op->fallback.blk);
 	op->fallback.blk = NULL;
 }
 
@@ -424,6 +429,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -454,6 +462,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index f442ca972e3c..c5763a041bb8 100644
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
-- 
2.24.1

