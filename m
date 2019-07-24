Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898A07461C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405319AbfGYFqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405324AbfGYFqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:46:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DEF21880;
        Thu, 25 Jul 2019 05:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033573;
        bh=mCR6aN+uceSECLUj63ofoTuojhqSJs4eio7FLW/vthU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjOPIiu09eoVIvEWB7Nss+AKOb7EsyCwV+a2hrubsTIhREx/pWCeXGEKT+hKkimR4
         iV+7S9AnZYwSGIPJxsZFke8giBCtapty3zlAz/Uv/jlFQNrNg6S1eJRF3v0Agf+7vx
         tHjf/AyfO9Ftk+8mUBzJM5XYPvoTTESdxDfhHITE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Horia Geanta <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 252/271] crypto: caam - limit output IV to CBC to work around CTR mode DMA issue
Date:   Wed, 24 Jul 2019 21:22:01 +0200
Message-Id: <20190724191716.805830869@linuxfoundation.org>
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
[ Horia: backported to 4.14, 4.19 ]
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -887,6 +887,7 @@ static void ablkcipher_encrypt_done(stru
 	struct ablkcipher_request *req = context;
 	struct ablkcipher_edesc *edesc;
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
 #ifdef DEBUG
@@ -911,10 +912,11 @@ static void ablkcipher_encrypt_done(stru
 
 	/*
 	 * The crypto API expects us to set the IV (req->info) to the last
-	 * ciphertext block. This is used e.g. by the CTS mode.
+	 * ciphertext block when running in CBC mode.
 	 */
-	scatterwalk_map_and_copy(req->info, req->dst, req->nbytes - ivsize,
-				 ivsize, 0);
+	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
+		scatterwalk_map_and_copy(req->info, req->dst, req->nbytes -
+					 ivsize, ivsize, 0);
 
 	/* In case initial IV was generated, copy it in GIVCIPHER request */
 	if (edesc->iv_dir == DMA_FROM_DEVICE) {
@@ -1651,10 +1653,11 @@ static int ablkcipher_decrypt(struct abl
 
 	/*
 	 * The crypto API expects us to set the IV (req->info) to the last
-	 * ciphertext block.
+	 * ciphertext block when running in CBC mode.
 	 */
-	scatterwalk_map_and_copy(req->info, req->src, req->nbytes - ivsize,
-				 ivsize, 0);
+	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
+		scatterwalk_map_and_copy(req->info, req->src, req->nbytes -
+					 ivsize, ivsize, 0);
 
 	/* Create and submit job descriptor*/
 	init_ablkcipher_job(ctx->sh_desc_dec, ctx->sh_desc_dec_dma, edesc, req);


