Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24471463
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbfGWIvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 04:51:32 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35739 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbfGWIvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 04:51:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CACF4423;
        Tue, 23 Jul 2019 04:51:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 04:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kosfkQ
        eI0ZA0IGQDZ1OM+2lFviwLc8NzHK61PXgUVls=; b=IvwjxFRLSJNLaqw7rzVr/b
        vhVs2mgynW7pdrMw4xg3g3eh0e/AHpoed7D7natgY8I7X6b+gYXnkzgHHBwyR6Ep
        GeCrC/HpirNUPZob0LRcJNeqqpVpGxBfEhhv08+6xGuHx7+fDYi3ATg/zWKbau0t
        91OjtKyOcw7WJojXJY07njcFIv261K2EM4EXMxAgIrMVI9Yw/90fAxJyNEzqQJiW
        8Jy7MTI0MjRu4D0kljAeA+ANQNnUaitL22UzbMYUuwJ/WDKFACjOTmWu/ZpAtB+X
        YefCERg2nBfiS0d0mW9biNTEsRGCMmPEldCrqUZpFzmNtAVu7zGQq3oNZLcaE8DA
        ==
X-ME-Sender: <xms:kMo2XWLJq8WSPfb62Wzfr1SkEmId857HS9OBYI6wacV0FpC6CC28QQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:kMo2XauxNps3vjCCC4N2k-tZvhUCjAIT3vMwvIThkmC-h7JlvnoTdA>
    <xmx:kMo2XbKAM8FWcsBpci1U83Q00dBroScUP0YXSAARtQBFkMNH77Wg1A>
    <xmx:kMo2XSO5Grmk_s3qmuFpz4CYF3bv6aZ7RNzTAAlEbCPL9k_pJEjf4g>
    <xmx:kco2XRP_b5Wyg0Sw6eRpw1Yw-T5Po7OpfwIxDy0awPubpeetNm0FyQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C508F380083;
        Tue, 23 Jul 2019 04:51:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: chacha20poly1305 - fix atomic sleep when using async" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        martin@strongswan.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 10:51:26 +0200
Message-ID: <1563871886183110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7545b6c2087f4ef0287c8c9b7eba6a728c67ff8e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Fri, 31 May 2019 11:12:30 -0700
Subject: [PATCH] crypto: chacha20poly1305 - fix atomic sleep when using async
 algorithm

Clear the CRYPTO_TFM_REQ_MAY_SLEEP flag when the chacha20poly1305
operation is being continued from an async completion callback, since
sleeping may not be allowed in that context.

This is basically the same bug that was recently fixed in the xts and
lrw templates.  But, it's always been broken in chacha20poly1305 too.
This was found using syzkaller in combination with the updated crypto
self-tests which actually test the MAY_SLEEP flag now.

Reproducer:

    python -c 'import socket; socket.socket(socket.AF_ALG, 5, 0).bind(
    	       ("aead", "rfc7539(cryptd(chacha20-generic),poly1305-generic)"))'

Kernel output:

    BUG: sleeping function called from invalid context at include/crypto/algapi.h:426
    in_atomic(): 1, irqs_disabled(): 0, pid: 1001, name: kworker/2:2
    [...]
    CPU: 2 PID: 1001 Comm: kworker/2:2 Not tainted 5.2.0-rc2 #5
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
    Workqueue: crypto cryptd_queue_worker
    Call Trace:
     __dump_stack lib/dump_stack.c:77 [inline]
     dump_stack+0x4d/0x6a lib/dump_stack.c:113
     ___might_sleep kernel/sched/core.c:6138 [inline]
     ___might_sleep.cold.19+0x8e/0x9f kernel/sched/core.c:6095
     crypto_yield include/crypto/algapi.h:426 [inline]
     crypto_hash_walk_done+0xd6/0x100 crypto/ahash.c:113
     shash_ahash_update+0x41/0x60 crypto/shash.c:251
     shash_async_update+0xd/0x10 crypto/shash.c:260
     crypto_ahash_update include/crypto/hash.h:539 [inline]
     poly_setkey+0xf6/0x130 crypto/chacha20poly1305.c:337
     poly_init+0x51/0x60 crypto/chacha20poly1305.c:364
     async_done_continue crypto/chacha20poly1305.c:78 [inline]
     poly_genkey_done+0x15/0x30 crypto/chacha20poly1305.c:369
     cryptd_skcipher_complete+0x29/0x70 crypto/cryptd.c:279
     cryptd_skcipher_decrypt+0xcd/0x110 crypto/cryptd.c:339
     cryptd_queue_worker+0x70/0xa0 crypto/cryptd.c:184
     process_one_work+0x1ed/0x420 kernel/workqueue.c:2269
     worker_thread+0x3e/0x3a0 kernel/workqueue.c:2415
     kthread+0x11f/0x140 kernel/kthread.c:255
     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
Cc: <stable@vger.kernel.org> # v4.2+
Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index e38a2d61819a..acbbf010222e 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -65,6 +65,8 @@ struct chachapoly_req_ctx {
 	unsigned int cryptlen;
 	/* Actual AD, excluding IV */
 	unsigned int assoclen;
+	/* request flags, with MAY_SLEEP cleared if needed */
+	u32 flags;
 	union {
 		struct poly_req poly;
 		struct chacha_req chacha;
@@ -74,8 +76,12 @@ struct chachapoly_req_ctx {
 static inline void async_done_continue(struct aead_request *req, int err,
 				       int (*cont)(struct aead_request *))
 {
-	if (!err)
+	if (!err) {
+		struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+
+		rctx->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 		err = cont(req);
+	}
 
 	if (err != -EINPROGRESS && err != -EBUSY)
 		aead_request_complete(req, err);
@@ -142,7 +148,7 @@ static int chacha_decrypt(struct aead_request *req)
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
 	}
 
-	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      chacha_decrypt_done, req);
 	skcipher_request_set_tfm(&creq->req, ctx->chacha);
 	skcipher_request_set_crypt(&creq->req, src, dst,
@@ -186,7 +192,7 @@ static int poly_tail(struct aead_request *req)
 	memcpy(&preq->tail.cryptlen, &len, sizeof(len));
 	sg_set_buf(preq->src, &preq->tail, sizeof(preq->tail));
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_tail_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src,
@@ -217,7 +223,7 @@ static int poly_cipherpad(struct aead_request *req)
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, &preq->pad, padlen);
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipherpad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
@@ -248,7 +254,7 @@ static int poly_cipher(struct aead_request *req)
 	sg_init_table(rctx->src, 2);
 	crypt = scatterwalk_ffwd(rctx->src, crypt, req->assoclen);
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipher_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, crypt, NULL, rctx->cryptlen);
@@ -278,7 +284,7 @@ static int poly_adpad(struct aead_request *req)
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, preq->pad, padlen);
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_adpad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
@@ -302,7 +308,7 @@ static int poly_ad(struct aead_request *req)
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_ad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, req->src, NULL, rctx->assoclen);
@@ -329,7 +335,7 @@ static int poly_setkey(struct aead_request *req)
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, rctx->key, sizeof(rctx->key));
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_setkey_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, sizeof(rctx->key));
@@ -353,7 +359,7 @@ static int poly_init(struct aead_request *req)
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_init_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 
@@ -391,7 +397,7 @@ static int poly_genkey(struct aead_request *req)
 
 	chacha_iv(creq->iv, req, 0);
 
-	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      poly_genkey_done, req);
 	skcipher_request_set_tfm(&creq->req, ctx->chacha);
 	skcipher_request_set_crypt(&creq->req, creq->src, creq->src,
@@ -431,7 +437,7 @@ static int chacha_encrypt(struct aead_request *req)
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
 	}
 
-	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      chacha_encrypt_done, req);
 	skcipher_request_set_tfm(&creq->req, ctx->chacha);
 	skcipher_request_set_crypt(&creq->req, src, dst,
@@ -449,6 +455,7 @@ static int chachapoly_encrypt(struct aead_request *req)
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
 	rctx->cryptlen = req->cryptlen;
+	rctx->flags = aead_request_flags(req);
 
 	/* encrypt call chain:
 	 * - chacha_encrypt/done()
@@ -470,6 +477,7 @@ static int chachapoly_decrypt(struct aead_request *req)
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
 	rctx->cryptlen = req->cryptlen - POLY1305_DIGEST_SIZE;
+	rctx->flags = aead_request_flags(req);
 
 	/* decrypt call chain:
 	 * - poly_genkey/done()

