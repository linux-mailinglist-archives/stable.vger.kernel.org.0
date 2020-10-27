Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AA829B1A0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897341AbgJ0OcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902295AbgJ0OcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D541F2222C;
        Tue, 27 Oct 2020 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809125;
        bh=wTYV13Qu7AzZ9uMtTee9hD/eZ5j0RFAk4/jNG+8Dma4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/qrCQnntgvSXXbFBmBbwUTbhfCN0Ih8VMmsbzlDfg3uHOPI+JBi9aOqt824pFt/t
         Zq6A4MecKeuOPNyj50utaCXlSiwD6NzkzUlR6WGQG6x2KkaGTQObsaFrpmxlU/vbWc
         vxYkUxAiYxatrFOrmv04BFJJGn9gCs7ArNPcBj+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Botila <andrei.botila@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 054/408] crypto: caam/qi - add fallback for XTS with more than 8B IV
Date:   Tue, 27 Oct 2020 14:49:52 +0100
Message-Id: <20201027135457.567824408@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

commit 83e8aa9121380b23ebae6e413962fa2a7b52cf92 upstream.

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/Kconfig      |    1 
 drivers/crypto/caam/caamalg_qi.c |   70 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 67 insertions(+), 4 deletions(-)

--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -112,6 +112,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
+	select CRYPTO_XTS
 	help
 	  Selecting this will use CAAM Queue Interface (QI) for sending
 	  & receiving crypto jobs to/from CAAM. This gives better performance
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <asm/unaligned.h>
 
 /*
  * crypto alg
@@ -67,6 +68,11 @@ struct caam_ctx {
 	struct device *qidev;
 	spinlock_t lock;	/* Protects multiple init of driver context */
 	struct caam_drv_ctx *drv_ctx[NUM_OP];
+	struct crypto_skcipher *fallback;
+};
+
+struct caam_skcipher_req_ctx {
+	struct skcipher_request fallback_req;
 };
 
 static int aead_set_sh_desc(struct crypto_aead *aead)
@@ -745,12 +751,17 @@ static int xts_skcipher_setkey(struct cr
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	int ret = 0;
+	int err;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_err(jrdev, "key size mismatch\n");
 		goto badkey;
 	}
 
+	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (err)
+		return err;
+
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -1395,6 +1406,14 @@ static struct skcipher_edesc *skcipher_e
 	return edesc;
 }
 
+static inline bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	return !!get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+}
+
 static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct skcipher_edesc *edesc;
@@ -1405,6 +1424,21 @@ static inline int skcipher_crypt(struct
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+
+		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&rctx->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return encrypt ? crypto_skcipher_encrypt(&rctx->fallback_req) :
+				 crypto_skcipher_decrypt(&rctx->fallback_req);
+	}
+
 	if (unlikely(caam_congested))
 		return -EAGAIN;
 
@@ -1529,6 +1563,7 @@ static struct caam_skcipher_alg driver_a
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2462,9 +2497,32 @@ static int caam_cra_init(struct crypto_s
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
+	int ret = 0;
+
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
+
+		fallback = crypto_alloc_skcipher(tfm_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(fallback)) {
+			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
+				tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+					    crypto_skcipher_reqsize(fallback));
+	}
+
+	ret = caam_init_common(ctx, &caam_alg->caam, false);
+	if (ret && ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
 
-	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
-				false);
+	return ret;
 }
 
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -2490,7 +2548,11 @@ static void caam_exit_common(struct caam
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_skcipher_ctx(tfm));
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+	caam_exit_common(ctx);
 }
 
 static void caam_aead_exit(struct crypto_aead *tfm)
@@ -2524,7 +2586,7 @@ static void caam_skcipher_alg_init(struc
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;


