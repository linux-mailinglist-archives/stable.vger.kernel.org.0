Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48ECD71910
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfGWNUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 09:20:02 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36518 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbfGWNUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 09:20:01 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9AEB31A00C6;
        Tue, 23 Jul 2019 15:19:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8DB1C1A0029;
        Tue, 23 Jul 2019 15:19:58 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4364E205DD;
        Tue, 23 Jul 2019 15:19:58 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 4.9] crypto: caam - limit output IV to CBC to work around CTR mode DMA issue
Date:   Tue, 23 Jul 2019 16:19:47 +0300
Message-Id: <20190723131947.27871-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit ed527b13d800dd515a9e6c582f0a73eca65b2e1b upstream.

The CAAM driver currently violates an undocumented and slightly
controversial requirement imposed by the crypto stack that a buffer
referred to by the request structure via its virtual address may not
be modified while any scatterlists passed via the same request
structure are mapped for inbound DMA.

This may result in errors like

  alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
  alg: aead: Failed to load transform for gcm(aes): -2

on non-cache coherent systems, due to the fact that the GCM driver
passes an IV buffer by virtual address which shares a cacheline with
the auth_tag buffer passed via a scatterlist, resulting in corruption
of the auth_tag when the IV is updated while the DMA mapping is live.

Since the IV that is returned to the caller is only valid for CBC mode,
and given that the in-kernel users of CBC (such as CTS) don't trigger the
same issue as the GCM driver, let's just disable the output IV generation
for all modes except CBC for the time being.

Fixes: 854b06f76879 ("crypto: caam - properly set IV after {en,de}crypt")
Cc: Horia Geanta <horia.geanta@nxp.com>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ Horia: backported to 4.9 ]
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 88caca3370f2..f8ac768ed5d7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2015,6 +2015,7 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
 #ifdef DEBUG
@@ -2040,10 +2041,11 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	/*
 	 * The crypto API expects us to set the IV (req->info) to the last
-	 * ciphertext block. This is used e.g. by the CTS mode.
+	 * ciphertext block when running in CBC mode.
 	 */
-	scatterwalk_map_and_copy(req->info, req->dst, req->nbytes - ivsize,
-				 ivsize, 0);
+	if ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
+		scatterwalk_map_and_copy(req->info, req->dst, req->nbytes -
+					 ivsize, ivsize, 0);
 
 	kfree(edesc);
 
@@ -2056,6 +2058,7 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
 #ifdef DEBUG
@@ -2080,10 +2083,11 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	/*
 	 * The crypto API expects us to set the IV (req->info) to the last
-	 * ciphertext block.
+	 * ciphertext block when running in CBC mode.
 	 */
-	scatterwalk_map_and_copy(req->info, req->src, req->nbytes - ivsize,
-				 ivsize, 0);
+	if ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
+		scatterwalk_map_and_copy(req->info, req->src, req->nbytes -
+					 ivsize, ivsize, 0);
 
 	kfree(edesc);
 
-- 
2.17.1

