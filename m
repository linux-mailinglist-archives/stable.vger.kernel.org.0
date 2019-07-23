Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330A17145C
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 10:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbfGWItX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 04:49:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59705 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbfGWItW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 04:49:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CD33621FE9;
        Tue, 23 Jul 2019 04:49:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 04:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SQDrqd
        wu7U91G59Z/Hg3/uO26+5e1KcUOOmwDwiOlNA=; b=Q/On1vKRbWTki1uhOh3d2H
        eeU6WWUe2XX3xyLDlLbO8ikUkbKLe4kxsYB8+xguRvar0OhrUsixpKLxHUvpi3ER
        k6znXDe8Tu49lTraWAaKJ8Z9z1886/MRwkSZzLAB4dirf3icxJJXCtYNwrciLmc2
        zRfWPGjW2DdHNY3ZvZOq0m5zuAoq/LBx+XhbfmLFwlpl/dXrzlqWznpwodIpSEOt
        bnzpf3+dDeH5B/vClbtH7pMOZlew0MKz9f0zHEB6FKJgCwpgiInq95LH5vo2BwRp
        HvQDnWnulis/ioZS6oHu54h21O+UJHDgQ2Xzce0WgL8s/l9gFGe4fY8ARyW4kMvg
        ==
X-ME-Sender: <xms:Eco2XbdjNj25eSRO5kXZQ4W-lmleEulsOJeEF-X_qcNw8ZZQ0Vux4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:Eco2XQTa2xpMIabipZq5KjK163S4kjJ1B-t87qOZkgecKEWbh_hgag>
    <xmx:Eco2XaspuPwaGpI6Hfcnqq7FqtT_s2P4wyhCKWQ5SwYvb2H89oQJuw>
    <xmx:Eco2XZd9ZjhyZKi8zy8EW-WRekZhLPcidH5jleW3crEhxVFkeB1sZw>
    <xmx:Eco2XS7i5xEUpvYOMeoK8x6PWH4mpzzsZHlB0kFmZ2MLezlkVeyISA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5250D8005C;
        Tue, 23 Jul 2019 04:49:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam - limit output IV to CBC to work around CTR mode" failed to apply to 4.9-stable tree
To:     ard.biesheuvel@linaro.org, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, iuliana.prodan@nxp.com,
        s.hauer@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 10:49:11 +0200
Message-ID: <156387175113040@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed527b13d800dd515a9e6c582f0a73eca65b2e1b Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 31 May 2019 10:13:06 +0200
Subject: [PATCH] crypto: caam - limit output IV to CBC to work around CTR mode
 DMA issue

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

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 1efa6f5b62cf..4b03c967009b 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -977,6 +977,7 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -990,9 +991,9 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block. This is used e.g. by the CTS mode.
+	 * ciphertext block when running in CBC mode.
 	 */
-	if (ivsize)
+	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
 		scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen -
 					 ivsize, ivsize, 0);
 
@@ -1836,9 +1837,9 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block.
+	 * ciphertext block when running in CBC mode.
 	 */
-	if (ivsize)
+	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
 		scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
 					 ivsize, ivsize, 0);
 

