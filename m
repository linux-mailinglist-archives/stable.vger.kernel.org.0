Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5F511B0CE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbfLKP0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733098AbfLKP0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667F4222C4;
        Wed, 11 Dec 2019 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077978;
        bh=wqWB3edme22S00bQqrqhZjtMi9qt3abxS/gc7xLxhS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl5xIxJth88VP46NM9Ct5ct+pz0cmOq1I3oKTkk9PQRZeh0CDKOfmItXWpE+e+vyU
         /UF3fdz9MI2ll4KUhwB2ysrD3HXUvE6LI/xJCa/WuPnOxFvmzLE9NpO34bnNfMeBQP
         nGDYVaaKO33QikYV18mEfoPSMVtq+q8J0Kxaqtlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 230/243] crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize
Date:   Wed, 11 Dec 2019 16:06:32 +0100
Message-Id: <20191211150354.861227340@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 86ef1dfcb561473fbf5e199d58d18c55554d78be upstream.

commit 394a9e044702 ("crypto: cfb - add missing 'chunksize' property")
adds a test vector where the input length is smaller than the IV length
(the second test vector). This revealed a NULL pointer dereference in
the atmel-aes driver, that is caused by passing an incorrect offset in
scatterwalk_map_and_copy() when atmel_aes_complete() is called.

Do not save the IV in req->info of ablkcipher_request (or equivalently
req->iv of skcipher_request) when req->nbytes < ivsize, because the IV
will not be further used.

While touching the code, modify the type of ivsize from int to
unsigned int, to comply with the return type of
crypto_ablkcipher_ivsize().

Fixes: 91308019ecb4 ("crypto: atmel-aes - properly set IV after {en,de}crypt")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/atmel-aes.c |   53 +++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -493,6 +493,29 @@ static inline bool atmel_aes_is_encrypt(
 static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 #endif
 
+static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev *dd)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
+	if (req->nbytes < ivsize)
+		return;
+
+	if (rctx->mode & AES_FLAGS_ENCRYPT) {
+		scatterwalk_map_and_copy(req->info, req->dst,
+					 req->nbytes - ivsize, ivsize, 0);
+	} else {
+		if (req->src == req->dst)
+			memcpy(req->info, rctx->lastc, ivsize);
+		else
+			scatterwalk_map_and_copy(req->info, req->src,
+						 req->nbytes - ivsize,
+						 ivsize, 0);
+	}
+}
+
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
@@ -503,26 +526,8 @@ static inline int atmel_aes_complete(str
 	clk_disable(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
-	if (!dd->ctx->is_aead) {
-		struct ablkcipher_request *req =
-			ablkcipher_request_cast(dd->areq);
-		struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
-		struct crypto_ablkcipher *ablkcipher =
-			crypto_ablkcipher_reqtfm(req);
-		int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-
-		if (rctx->mode & AES_FLAGS_ENCRYPT) {
-			scatterwalk_map_and_copy(req->info, req->dst,
-				req->nbytes - ivsize, ivsize, 0);
-		} else {
-			if (req->src == req->dst) {
-				memcpy(req->info, rctx->lastc, ivsize);
-			} else {
-				scatterwalk_map_and_copy(req->info, req->src,
-					req->nbytes - ivsize, ivsize, 0);
-			}
-		}
-	}
+	if (!dd->ctx->is_aead)
+		atmel_aes_set_iv_as_last_ciphertext_block(dd);
 
 	if (dd->is_async)
 		dd->areq->complete(dd->areq, err);
@@ -1128,10 +1133,12 @@ static int atmel_aes_crypt(struct ablkci
 	rctx->mode = mode;
 
 	if (!(mode & AES_FLAGS_ENCRYPT) && (req->src == req->dst)) {
-		int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+		unsigned int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
-		scatterwalk_map_and_copy(rctx->lastc, req->src,
-			(req->nbytes - ivsize), ivsize, 0);
+		if (req->nbytes >= ivsize)
+			scatterwalk_map_and_copy(rctx->lastc, req->src,
+						 req->nbytes - ivsize,
+						 ivsize, 0);
 	}
 
 	return atmel_aes_handle_queue(dd, &req->base);


