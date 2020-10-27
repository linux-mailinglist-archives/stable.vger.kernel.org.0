Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB27B29C176
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818924AbgJ0RZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772926AbgJ0Owd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BFD022275;
        Tue, 27 Oct 2020 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810352;
        bh=oqiga26U9hH3sk726F+S+IKxDsft1pfs3nWQ6L67yL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKOjR6at/5JxuF59zugmVvApGUYZvXTZB8aWsSoQ1CNEYdGj5hWp/QbJMh+8UHdyZ
         mUlwDHDEkU3Ky9T6tZoAuRSBeUeZDxpMNo6GlmNdWFnFPK1XGW0TNxkBQhy72tz6ui
         MEOY2AsyKlJIiJ3ojDhBlDOQLit7RiGlnmYqfsL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Botila <andrei.botila@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.8 078/633] crypto: caam/qi - add support for more XTS key lengths
Date:   Tue, 27 Oct 2020 14:47:01 +0100
Message-Id: <20201027135526.351672306@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

commit 62b9a6690926ee199445b23fd46e6349d9057146 upstream.

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_qi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -68,6 +69,7 @@ struct caam_ctx {
 	struct device *qidev;
 	spinlock_t lock;	/* Protects multiple init of driver context */
 	struct caam_drv_ctx *drv_ctx[NUM_OP];
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -734,11 +736,15 @@ static int xts_skcipher_setkey(struct cr
 	int ret = 0;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(jrdev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1402,7 +1408,8 @@ static inline int skcipher_crypt(struct
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);


