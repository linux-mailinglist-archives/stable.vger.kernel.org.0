Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E802729B631
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796250AbgJ0PVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797060AbgJ0PVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:21:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E731321D41;
        Tue, 27 Oct 2020 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812080;
        bh=np3Jas7xhV1WUTEhMHGU5ZUdB+kZQ1xE+/zxF4exA8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL0ZJaNzQ+aqNR09x7zm6arTvZI+kkTAM6hkvY7lsWvhrE6F0jsEOa2w4aAIfcEHw
         ell9qwddEygjowSeQi0a/YtLXCESx0nfzYrxqVr0Ygt1mc8z3eUAEhQZ+FCR80lbYf
         uXI05THsJv4ifaDN2fdStZj75EM8S3Dc+dayX5i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Botila <andrei.botila@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.9 086/757] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
Date:   Tue, 27 Oct 2020 14:45:36 +0100
Message-Id: <20201027135454.582270640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

commit 36e2d7cfdcf17b6126863d884d4200191e922524 upstream.

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/Kconfig       |    1 
 drivers/crypto/caam/caamalg_qi2.c |   80 +++++++++++++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.h |    2 
 3 files changed, 78 insertions(+), 5 deletions(-)

--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -167,6 +167,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 	select CRYPTO_AEAD
 	select CRYPTO_HASH
 	select CRYPTO_DES
+	select CRYPTO_XTS
 	help
 	  CAAM driver for QorIQ Data Path Acceleration Architecture 2.
 	  It handles DPSECI DPAA2 objects that sit on the Management Complex
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
 
@@ -80,6 +81,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	struct crypto_skcipher *fallback;
 };
 
 static void *dpaa2_caam_iova_to_virt(struct dpaa2_caam_priv *priv,
@@ -1056,12 +1058,17 @@ static int xts_skcipher_setkey(struct cr
 	struct device *dev = ctx->dev;
 	struct caam_flc *flc;
 	u32 *desc;
+	int err;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_dbg(dev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
+	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (err)
+		return err;
+
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -1443,6 +1450,14 @@ static void skcipher_decrypt_done(void *
 	skcipher_request_complete(req, ecode);
 }
 
+static inline bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	return !!get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+}
+
 static int skcipher_encrypt(struct skcipher_request *req)
 {
 	struct skcipher_edesc *edesc;
@@ -1459,6 +1474,18 @@ static int skcipher_encrypt(struct skcip
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&caam_req->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&caam_req->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return crypto_skcipher_encrypt(&caam_req->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);
 	if (IS_ERR(edesc))
@@ -1494,6 +1521,19 @@ static int skcipher_decrypt(struct skcip
 	 */
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
+
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&caam_req->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&caam_req->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return crypto_skcipher_decrypt(&caam_req->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);
 	if (IS_ERR(edesc))
@@ -1547,9 +1587,34 @@ static int caam_cra_init_skcipher(struct
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
+			dev_err(ctx->dev, "Failed to allocate %s fallback: %ld\n",
+				tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
+					    crypto_skcipher_reqsize(fallback));
+	} else {
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
+	}
+
+	ret = caam_cra_init(ctx, &caam_alg->caam, false);
+	if (ret && ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
 
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
-	return caam_cra_init(crypto_skcipher_ctx(tfm), &caam_alg->caam, false);
+	return ret;
 }
 
 static int caam_cra_init_aead(struct crypto_aead *tfm)
@@ -1572,7 +1637,11 @@ static void caam_exit_common(struct caam
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_skcipher_ctx(tfm));
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+	caam_exit_common(ctx);
 }
 
 static void caam_cra_exit_aead(struct crypto_aead *tfm)
@@ -1675,6 +1744,7 @@ static struct caam_skcipher_alg driver_a
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi2",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2922,8 +2992,8 @@ static void caam_skcipher_alg_init(struc
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include "dpseci.h"
 #include "desc_constr.h"
+#include <crypto/skcipher.h>
 
 #define DPAA2_CAAM_STORE_SIZE	16
 /* NAPI weight *must* be a multiple of the store size. */
@@ -186,6 +187,7 @@ struct caam_request {
 	void (*cbk)(void *ctx, u32 err);
 	void *ctx;
 	void *edesc;
+	struct skcipher_request fallback_req;
 };
 
 /**


