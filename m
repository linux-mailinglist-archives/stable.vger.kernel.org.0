Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D027464A
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390822AbfGYFmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390831AbfGYFmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:42:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B541622CB9;
        Thu, 25 Jul 2019 05:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033343;
        bh=jMcefBxLFaoYMKd4VwmvofWNMZWR6VtwFsw+KOPPfxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egiL+7ssq4ywI4ms9o/IAS9cGnyH7SdvUGfmX5OhKQdIFa0YQNJFA8jBzBGtfrmp3
         C4//6dlDZDrbednf3Hm9JfkGwi0mJluVWiIiuWDDHf3ZSXPOzfLnJvjgELnZLZue41
         4M5kN7KiMgUUcnyNU7fOlwm16/62n4UIpIaAacCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 176/271] crypto: chacha20poly1305 - fix atomic sleep when using async algorithm
Date:   Wed, 24 Jul 2019 21:20:45 +0200
Message-Id: <20190724191710.248237474@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 7545b6c2087f4ef0287c8c9b7eba6a728c67ff8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/chacha20poly1305.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -67,6 +67,8 @@ struct chachapoly_req_ctx {
 	unsigned int cryptlen;
 	/* Actual AD, excluding IV */
 	unsigned int assoclen;
+	/* request flags, with MAY_SLEEP cleared if needed */
+	u32 flags;
 	union {
 		struct poly_req poly;
 		struct chacha_req chacha;
@@ -76,8 +78,12 @@ struct chachapoly_req_ctx {
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
@@ -144,7 +150,7 @@ static int chacha_decrypt(struct aead_re
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
 	}
 
-	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      chacha_decrypt_done, req);
 	skcipher_request_set_tfm(&creq->req, ctx->chacha);
 	skcipher_request_set_crypt(&creq->req, src, dst,
@@ -188,7 +194,7 @@ static int poly_tail(struct aead_request
 	memcpy(&preq->tail.cryptlen, &len, sizeof(len));
 	sg_set_buf(preq->src, &preq->tail, sizeof(preq->tail));
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_tail_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src,
@@ -219,7 +225,7 @@ static int poly_cipherpad(struct aead_re
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, &preq->pad, padlen);
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipherpad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
@@ -250,7 +256,7 @@ static int poly_cipher(struct aead_reque
 	sg_init_table(rctx->src, 2);
 	crypt = scatterwalk_ffwd(rctx->src, crypt, req->assoclen);
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipher_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, crypt, NULL, rctx->cryptlen);
@@ -280,7 +286,7 @@ static int poly_adpad(struct aead_reques
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, preq->pad, padlen);
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_adpad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
@@ -304,7 +310,7 @@ static int poly_ad(struct aead_request *
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_ad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, req->src, NULL, rctx->assoclen);
@@ -331,7 +337,7 @@ static int poly_setkey(struct aead_reque
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, rctx->key, sizeof(rctx->key));
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_setkey_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, sizeof(rctx->key));
@@ -355,7 +361,7 @@ static int poly_init(struct aead_request
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
-	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_init_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
 
@@ -393,7 +399,7 @@ static int poly_genkey(struct aead_reque
 
 	chacha_iv(creq->iv, req, 0);
 
-	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      poly_genkey_done, req);
 	skcipher_request_set_tfm(&creq->req, ctx->chacha);
 	skcipher_request_set_crypt(&creq->req, creq->src, creq->src,
@@ -433,7 +439,7 @@ static int chacha_encrypt(struct aead_re
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
 	}
 
-	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+	skcipher_request_set_callback(&creq->req, rctx->flags,
 				      chacha_encrypt_done, req);
 	skcipher_request_set_tfm(&creq->req, ctx->chacha);
 	skcipher_request_set_crypt(&creq->req, src, dst,
@@ -451,6 +457,7 @@ static int chachapoly_encrypt(struct aea
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
 	rctx->cryptlen = req->cryptlen;
+	rctx->flags = aead_request_flags(req);
 
 	/* encrypt call chain:
 	 * - chacha_encrypt/done()
@@ -472,6 +479,7 @@ static int chachapoly_decrypt(struct aea
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
 	rctx->cryptlen = req->cryptlen - POLY1305_DIGEST_SIZE;
+	rctx->flags = aead_request_flags(req);
 
 	/* decrypt call chain:
 	 * - poly_genkey/done()


