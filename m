Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC00154A1B
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 18:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFRQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 12:16:21 -0500
Received: from mx1.bezdeka.de ([5.181.50.93]:55296 "EHLO smtp.bezdeka.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727390AbgBFRQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 12:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bezdeka.de;
         s=mail201812; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sXKX2WVwzeiEqWTWA3obBYXXVxkbFjI/BA+I8vpSaqE=; b=Hsaaed2+h+gZbGzKXAt5GKB0J1
        zuPVDqTMTOkUv+26eSyUpQ0ZbpQAkTzSIV+Z8GGQJIqWKxGG2krMoYAT11REdfF6njISynBKvAy8o
        fuStdRumjtKzPt4HkauA83i8k3u6NueDws6Zg5lJ4stY/PqFVcm8LyxRS03ACw4HZp/K61jrASP/h
        +xkCOP3Wnl9SftfgXVe05UbXK9f+OusEl/5TL5YDbpDrB0LpcPmEJ6GFdAeColojK/vzrEHVMyMEV
        bg1lGfybBrNOShnZXLOJExx6youGgokm8MFNWATVZGPsw7+QilL/tEAZEQTU6v0QYi5c1sPG4HnAm
        5aVRQ5wQ==;
Received: from [2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e] (helo=flo.bbg.bezdeka.de)
        by smtp.bezdeka.de with esmtpa (Exim 4.92.3)
        (envelope-from <florian@bezdeka.de>)
        id 1izklB-0007us-PX; Thu, 06 Feb 2020 18:16:14 +0100
From:   Florian Bezdeka <florian@bezdeka.de>
To:     stable@vger.kernel.org
Cc:     Florian Bezdeka <florian@bezdeka.de>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19] crypto: geode-aes - convert to skcipher API and make thread-safe
Date:   Thu,  6 Feb 2020 18:15:34 +0100
Message-Id: <20200206171534.4051-1-florian@bezdeka.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: florian@bezdeka.de
X-Authenticator: plain
X-Exim-Version: 4.92.3 (build at 19-Nov-2019 13:15:30)
X-Date: 2020-02-06 18:16:13
X-Connected-IP: 2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e:58778
X-Message-Linecount: 711
X-Body-Linecount: 699
X-Message-Size: 21199
X-Body-Size: 20745
X-Received-Count: 1
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4549f7e5aa27ffc2cba63b5db8842a3b486f5688 upstream.

The geode AES driver is heavily broken because it stores per-request
state in the transform context.  So it will crash or produce the wrong
result if used by any of the many places in the kernel that issue
concurrent requests for the same transform object.

This driver is also implemented using the deprecated blkcipher API,
which makes it difficult to fix, and puts it among the drivers
preventing that API from being removed.

Convert this driver to use the skcipher API, and change it to not store
per-request state in the transform context.

Fixes: 9fe757b ("[PATCH] crypto: Add support for the Geode LX AES hardware")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
---
 drivers/crypto/geode-aes.c | 442 ++++++++++++-------------------------
 drivers/crypto/geode-aes.h |  15 +-
 2 files changed, 149 insertions(+), 308 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index d670f7000cbb..0bd99c0decf5 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -14,7 +14,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/skcipher.h>
+#include <crypto/internal/skcipher.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -28,12 +28,12 @@ static spinlock_t lock;
 
 /* Write a 128 bit field (either a writable key or IV) */
 static inline void
-_writefield(u32 offset, void *value)
+_writefield(u32 offset, const void *value)
 {
 	int i;
 
 	for (i = 0; i < 4; i++)
-		iowrite32(((u32 *) value)[i], _iobase + offset + (i * 4));
+		iowrite32(((const u32 *) value)[i], _iobase + offset + (i * 4));
 }
 
 /* Read a 128 bit field (either a writable key or IV) */
@@ -47,12 +47,12 @@ _readfield(u32 offset, void *value)
 }
 
 static int
-do_crypt(void *src, void *dst, int len, u32 flags)
+do_crypt(const void *src, void *dst, u32 len, u32 flags)
 {
 	u32 status;
 	u32 counter = AES_OP_TIMEOUT;
 
-	iowrite32(virt_to_phys(src), _iobase + AES_SOURCEA_REG);
+	iowrite32(virt_to_phys((void *)src), _iobase + AES_SOURCEA_REG);
 	iowrite32(virt_to_phys(dst), _iobase + AES_DSTA_REG);
 	iowrite32(len,  _iobase + AES_LENA_REG);
 
@@ -69,16 +69,14 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 	return counter ? 0 : 1;
 }
 
-static unsigned int
-geode_aes_crypt(struct geode_aes_op *op)
+static void
+geode_aes_crypt(const struct geode_aes_tfm_ctx *tctx, const void *src,
+		void *dst, u32 len, u8 *iv, int mode, int dir)
 {
 	u32 flags = 0;
 	unsigned long iflags;
 	int ret;
 
-	if (op->len == 0)
-		return 0;
-
 	/* If the source and destination is the same, then
 	 * we need to turn on the coherent flags, otherwise
 	 * we don't need to worry
@@ -86,32 +84,28 @@ geode_aes_crypt(struct geode_aes_op *op)
 
 	flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
 
-	if (op->dir == AES_DIR_ENCRYPT)
+	if (dir == AES_DIR_ENCRYPT)
 		flags |= AES_CTRL_ENCRYPT;
 
 	/* Start the critical section */
 
 	spin_lock_irqsave(&lock, iflags);
 
-	if (op->mode == AES_MODE_CBC) {
+	if (mode == AES_MODE_CBC) {
 		flags |= AES_CTRL_CBC;
-		_writefield(AES_WRITEIV0_REG, op->iv);
+		_writefield(AES_WRITEIV0_REG, iv);
 	}
 
-	if (!(op->flags & AES_FLAGS_HIDDENKEY)) {
-		flags |= AES_CTRL_WRKEY;
-		_writefield(AES_WRITEKEY0_REG, op->key);
-	}
+	flags |= AES_CTRL_WRKEY;
+	_writefield(AES_WRITEKEY0_REG, tctx->key);
 
-	ret = do_crypt(op->src, op->dst, op->len, flags);
+	ret = do_crypt(src, dst, len, flags);
 	BUG_ON(ret);
 
-	if (op->mode == AES_MODE_CBC)
-		_readfield(AES_WRITEIV0_REG, op->iv);
+	if (mode == AES_MODE_CBC)
+		_readfield(AES_WRITEIV0_REG, iv);
 
 	spin_unlock_irqrestore(&lock, iflags);
-
-	return op->len;
 }
 
 /* CRYPTO-API Functions */
@@ -119,13 +113,13 @@ geode_aes_crypt(struct geode_aes_op *op)
 static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 		unsigned int len)
 {
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	struct geode_aes_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
 	unsigned int ret;
 
-	op->keylen = len;
+	tctx->keylen = len;
 
 	if (len == AES_KEYSIZE_128) {
-		memcpy(op->key, key, len);
+		memcpy(tctx->key, key, len);
 		return 0;
 	}
 
@@ -138,132 +132,93 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.cip->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	tctx->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	tctx->fallback.cip->base.crt_flags |=
+		(tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
+	ret = crypto_cipher_setkey(tctx->fallback.cip, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.cip->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= (tctx->fallback.cip->base.crt_flags &
+				   CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
 }
 
-static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
-		unsigned int len)
+static int geode_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int len)
 {
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	struct geode_aes_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	unsigned int ret;
 
-	op->keylen = len;
+	tctx->keylen = len;
 
 	if (len == AES_KEYSIZE_128) {
-		memcpy(op->key, key, len);
+		memcpy(tctx->key, key, len);
 		return 0;
 	}
 
 	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
 		/* not supported at all */
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	crypto_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(op->fallback.blk,
-				  tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
-
-	ret = crypto_skcipher_setkey(op->fallback.blk, key, len);
-	if (ret) {
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= crypto_skcipher_get_flags(op->fallback.blk) &
-				  CRYPTO_TFM_RES_MASK;
-	}
+	crypto_skcipher_clear_flags(tctx->fallback.skcipher,
+				    CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(tctx->fallback.skcipher,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	ret = crypto_skcipher_setkey(tctx->fallback.skcipher, key, len);
+	crypto_skcipher_set_flags(tfm,
+				  crypto_skcipher_get_flags(tctx->fallback.skcipher) &
+				  CRYPTO_TFM_RES_MASK);
 	return ret;
 }
 
-static int fallback_blk_dec(struct blkcipher_desc *desc,
-		struct scatterlist *dst, struct scatterlist *src,
-		unsigned int nbytes)
-{
-	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
-
-	skcipher_request_set_tfm(req, op->fallback.blk);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
-
-	return crypto_skcipher_decrypt(req);
-}
-
-static int fallback_blk_enc(struct blkcipher_desc *desc,
-		struct scatterlist *dst, struct scatterlist *src,
-		unsigned int nbytes)
-{
-	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
-	SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
-
-	skcipher_request_set_tfm(req, op->fallback.blk);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
-
-	return crypto_skcipher_encrypt(req);
-}
-
 static void
 geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	const struct geode_aes_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
 
-	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
-		crypto_cipher_encrypt_one(op->fallback.cip, out, in);
+	if (unlikely(tctx->keylen != AES_KEYSIZE_128)) {
+		crypto_cipher_encrypt_one(tctx->fallback.cip, out, in);
 		return;
 	}
 
-	op->src = (void *) in;
-	op->dst = (void *) out;
-	op->mode = AES_MODE_ECB;
-	op->flags = 0;
-	op->len = AES_BLOCK_SIZE;
-	op->dir = AES_DIR_ENCRYPT;
-
-	geode_aes_crypt(op);
+	geode_aes_crypt(tctx, in, out, AES_BLOCK_SIZE, NULL,
+			AES_MODE_ECB, AES_DIR_ENCRYPT);
 }
 
 
 static void
 geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	const struct geode_aes_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
 
-	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
-		crypto_cipher_decrypt_one(op->fallback.cip, out, in);
+	if (unlikely(tctx->keylen != AES_KEYSIZE_128)) {
+		crypto_cipher_decrypt_one(tctx->fallback.cip, out, in);
 		return;
 	}
 
-	op->src = (void *) in;
-	op->dst = (void *) out;
-	op->mode = AES_MODE_ECB;
-	op->flags = 0;
-	op->len = AES_BLOCK_SIZE;
-	op->dir = AES_DIR_DECRYPT;
-
-	geode_aes_crypt(op);
+	geode_aes_crypt(tctx, in, out, AES_BLOCK_SIZE, NULL,
+			AES_MODE_ECB, AES_DIR_DECRYPT);
 }
 
 static int fallback_init_cip(struct crypto_tfm *tfm)
 {
 	const char *name = crypto_tfm_alg_name(tfm);
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	struct geode_aes_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
 
-	op->fallback.cip = crypto_alloc_cipher(name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	tctx->fallback.cip = crypto_alloc_cipher(name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
 
-	if (IS_ERR(op->fallback.cip)) {
+	if (IS_ERR(tctx->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.cip);
+		return PTR_ERR(tctx->fallback.cip);
 	}
 
 	return 0;
@@ -271,10 +226,9 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 static void fallback_exit_cip(struct crypto_tfm *tfm)
 {
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	struct geode_aes_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_cipher(op->fallback.cip);
-	op->fallback.cip = NULL;
+	crypto_free_cipher(tctx->fallback.cip);
 }
 
 static struct crypto_alg geode_alg = {
@@ -287,7 +241,7 @@ static struct crypto_alg geode_alg = {
 	.cra_init			=	fallback_init_cip,
 	.cra_exit			=	fallback_exit_cip,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct geode_aes_op),
+	.cra_ctxsize		=	sizeof(struct geode_aes_tfm_ctx),
 	.cra_module			=	THIS_MODULE,
 	.cra_u				=	{
 		.cipher	=	{
@@ -300,222 +254,126 @@ static struct crypto_alg geode_alg = {
 	}
 };
 
-static int
-geode_cbc_decrypt(struct blkcipher_desc *desc,
-		  struct scatterlist *dst, struct scatterlist *src,
-		  unsigned int nbytes)
+static int geode_init_skcipher(struct crypto_skcipher *tfm)
 {
-	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	int err, ret;
-
-	if (nbytes % AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (unlikely(op->keylen != AES_KEYSIZE_128))
-		return fallback_blk_dec(desc, dst, src, nbytes);
+	const char *name = crypto_tfm_alg_name(&tfm->base);
+	struct geode_aes_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	op->iv = walk.iv;
-
-	while ((nbytes = walk.nbytes)) {
-		op->src = walk.src.virt.addr,
-		op->dst = walk.dst.virt.addr;
-		op->mode = AES_MODE_CBC;
-		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
-		op->dir = AES_DIR_DECRYPT;
-
-		ret = geode_aes_crypt(op);
-
-		nbytes -= ret;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	tctx->fallback.skcipher =
+		crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK |
+				      CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tctx->fallback.skcipher)) {
+		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		return PTR_ERR(tctx->fallback.skcipher);
 	}
 
-	return err;
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct skcipher_request) +
+				    crypto_skcipher_reqsize(tctx->fallback.skcipher));
+	return 0;
 }
 
-static int
-geode_cbc_encrypt(struct blkcipher_desc *desc,
-		  struct scatterlist *dst, struct scatterlist *src,
-		  unsigned int nbytes)
+static void geode_exit_skcipher(struct crypto_skcipher *tfm)
 {
-	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	int err, ret;
+	struct geode_aes_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 
-	if (nbytes % AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (unlikely(op->keylen != AES_KEYSIZE_128))
-		return fallback_blk_enc(desc, dst, src, nbytes);
+	crypto_free_skcipher(tctx->fallback.skcipher);
+}
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-	op->iv = walk.iv;
+static int geode_skcipher_crypt(struct skcipher_request *req, int mode, int dir)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct geode_aes_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+
+	if (unlikely(tctx->keylen != AES_KEYSIZE_128)) {
+		struct skcipher_request *subreq = skcipher_request_ctx(req);
+
+		*subreq = *req;
+		skcipher_request_set_tfm(subreq, tctx->fallback.skcipher);
+		if (dir == AES_DIR_DECRYPT)
+			return crypto_skcipher_decrypt(subreq);
+		else
+			return crypto_skcipher_encrypt(subreq);
+	}
 
-	while ((nbytes = walk.nbytes)) {
-		op->src = walk.src.virt.addr,
-		op->dst = walk.dst.virt.addr;
-		op->mode = AES_MODE_CBC;
-		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
-		op->dir = AES_DIR_ENCRYPT;
+	err = skcipher_walk_virt(&walk, req, false);
 
-		ret = geode_aes_crypt(op);
-		nbytes -= ret;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
+	while ((nbytes = walk.nbytes) != 0) {
+		geode_aes_crypt(tctx, walk.src.virt.addr, walk.dst.virt.addr,
+				round_down(nbytes, AES_BLOCK_SIZE),
+				walk.iv, mode, dir);
+		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
 	}
 
 	return err;
 }
 
-static int fallback_init_blk(struct crypto_tfm *tfm)
+static int geode_cbc_encrypt(struct skcipher_request *req)
 {
-	const char *name = crypto_tfm_alg_name(tfm);
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
-
-	op->fallback.blk = crypto_alloc_skcipher(name, 0,
-						 CRYPTO_ALG_ASYNC |
-						 CRYPTO_ALG_NEED_FALLBACK);
-
-	if (IS_ERR(op->fallback.blk)) {
-		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
-	}
-
-	return 0;
+	return geode_skcipher_crypt(req, AES_MODE_CBC, AES_DIR_ENCRYPT);
 }
 
-static void fallback_exit_blk(struct crypto_tfm *tfm)
+static int geode_cbc_decrypt(struct skcipher_request *req)
 {
-	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
-
-	crypto_free_skcipher(op->fallback.blk);
-	op->fallback.blk = NULL;
+	return geode_skcipher_crypt(req, AES_MODE_CBC, AES_DIR_DECRYPT);
 }
 
-static struct crypto_alg geode_cbc_alg = {
-	.cra_name		=	"cbc(aes)",
-	.cra_driver_name	=	"cbc-aes-geode",
-	.cra_priority		=	400,
-	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-						CRYPTO_ALG_KERN_DRIVER_ONLY |
-						CRYPTO_ALG_NEED_FALLBACK,
-	.cra_init			=	fallback_init_blk,
-	.cra_exit			=	fallback_exit_blk,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct geode_aes_op),
-	.cra_alignmask		=	15,
-	.cra_type			=	&crypto_blkcipher_type,
-	.cra_module			=	THIS_MODULE,
-	.cra_u				=	{
-		.blkcipher	=	{
-			.min_keysize	=	AES_MIN_KEY_SIZE,
-			.max_keysize	=	AES_MAX_KEY_SIZE,
-			.setkey			=	geode_setkey_blk,
-			.encrypt		=	geode_cbc_encrypt,
-			.decrypt		=	geode_cbc_decrypt,
-			.ivsize			=	AES_BLOCK_SIZE,
-		}
-	}
-};
-
-static int
-geode_ecb_decrypt(struct blkcipher_desc *desc,
-		  struct scatterlist *dst, struct scatterlist *src,
-		  unsigned int nbytes)
+static int geode_ecb_encrypt(struct skcipher_request *req)
 {
-	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	int err, ret;
-
-	if (nbytes % AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (unlikely(op->keylen != AES_KEYSIZE_128))
-		return fallback_blk_dec(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-
-	while ((nbytes = walk.nbytes)) {
-		op->src = walk.src.virt.addr,
-		op->dst = walk.dst.virt.addr;
-		op->mode = AES_MODE_ECB;
-		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
-		op->dir = AES_DIR_DECRYPT;
-
-		ret = geode_aes_crypt(op);
-		nbytes -= ret;
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	return err;
+	return geode_skcipher_crypt(req, AES_MODE_ECB, AES_DIR_ENCRYPT);
 }
 
-static int
-geode_ecb_encrypt(struct blkcipher_desc *desc,
-		  struct scatterlist *dst, struct scatterlist *src,
-		  unsigned int nbytes)
+static int geode_ecb_decrypt(struct skcipher_request *req)
 {
-	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-	int err, ret;
-
-	if (nbytes % AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (unlikely(op->keylen != AES_KEYSIZE_128))
-		return fallback_blk_enc(desc, dst, src, nbytes);
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-
-	while ((nbytes = walk.nbytes)) {
-		op->src = walk.src.virt.addr,
-		op->dst = walk.dst.virt.addr;
-		op->mode = AES_MODE_ECB;
-		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
-		op->dir = AES_DIR_ENCRYPT;
-
-		ret = geode_aes_crypt(op);
-		nbytes -= ret;
-		ret =  blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	return err;
+	return geode_skcipher_crypt(req, AES_MODE_ECB, AES_DIR_DECRYPT);
 }
 
-static struct crypto_alg geode_ecb_alg = {
-	.cra_name			=	"ecb(aes)",
-	.cra_driver_name	=	"ecb-aes-geode",
-	.cra_priority		=	400,
-	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-						CRYPTO_ALG_KERN_DRIVER_ONLY |
-						CRYPTO_ALG_NEED_FALLBACK,
-	.cra_init			=	fallback_init_blk,
-	.cra_exit			=	fallback_exit_blk,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct geode_aes_op),
-	.cra_alignmask		=	15,
-	.cra_type			=	&crypto_blkcipher_type,
-	.cra_module			=	THIS_MODULE,
-	.cra_u				=	{
-		.blkcipher	=	{
-			.min_keysize	=	AES_MIN_KEY_SIZE,
-			.max_keysize	=	AES_MAX_KEY_SIZE,
-			.setkey			=	geode_setkey_blk,
-			.encrypt		=	geode_ecb_encrypt,
-			.decrypt		=	geode_ecb_decrypt,
-		}
-	}
+static struct skcipher_alg geode_skcipher_algs[] = {
+	{
+		.base.cra_name		= "cbc(aes)",
+		.base.cra_driver_name	= "cbc-aes-geode",
+		.base.cra_priority	= 400,
+		.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct geode_aes_tfm_ctx),
+		.base.cra_alignmask	= 15,
+		.base.cra_module	= THIS_MODULE,
+		.init			= geode_init_skcipher,
+		.exit			= geode_exit_skcipher,
+		.setkey			= geode_setkey_skcipher,
+		.encrypt		= geode_cbc_encrypt,
+		.decrypt		= geode_cbc_decrypt,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+	}, {
+		.base.cra_name		= "ecb(aes)",
+		.base.cra_driver_name	= "ecb-aes-geode",
+		.base.cra_priority	= 400,
+		.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct geode_aes_tfm_ctx),
+		.base.cra_alignmask	= 15,
+		.base.cra_module	= THIS_MODULE,
+		.init			= geode_init_skcipher,
+		.exit			= geode_exit_skcipher,
+		.setkey			= geode_setkey_skcipher,
+		.encrypt		= geode_ecb_encrypt,
+		.decrypt		= geode_ecb_decrypt,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+	},
 };
 
 static void geode_aes_remove(struct pci_dev *dev)
 {
 	crypto_unregister_alg(&geode_alg);
-	crypto_unregister_alg(&geode_ecb_alg);
-	crypto_unregister_alg(&geode_cbc_alg);
+	crypto_unregister_skciphers(geode_skcipher_algs,
+				    ARRAY_SIZE(geode_skcipher_algs));
 
 	pci_iounmap(dev, _iobase);
 	_iobase = NULL;
@@ -553,20 +411,14 @@ static int geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (ret)
 		goto eiomap;
 
-	ret = crypto_register_alg(&geode_ecb_alg);
+	ret = crypto_register_skciphers(geode_skcipher_algs,
+					ARRAY_SIZE(geode_skcipher_algs));
 	if (ret)
 		goto ealg;
 
-	ret = crypto_register_alg(&geode_cbc_alg);
-	if (ret)
-		goto eecb;
-
 	dev_notice(&dev->dev, "GEODE AES engine enabled.\n");
 	return 0;
 
- eecb:
-	crypto_unregister_alg(&geode_ecb_alg);
-
  ealg:
 	crypto_unregister_alg(&geode_alg);
 
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index c5763a041bb8..157443dc6d8a 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -50,21 +50,10 @@
 
 #define AES_OP_TIMEOUT    0x50000
 
-struct geode_aes_op {
-
-	void *src;
-	void *dst;
-
-	u32 mode;
-	u32 dir;
-	u32 flags;
-	int len;
-
+struct geode_aes_tfm_ctx {
 	u8 key[AES_KEYSIZE_128];
-	u8 *iv;
-
 	union {
-		struct crypto_skcipher *blk;
+		struct crypto_skcipher *skcipher;
 		struct crypto_cipher *cip;
 	} fallback;
 	u32 keylen;
-- 
2.24.1

