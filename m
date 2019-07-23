Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B4D71459
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 10:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbfGWItP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 04:49:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42579 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733220AbfGWItO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 04:49:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CA87A21B03;
        Tue, 23 Jul 2019 04:49:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 04:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=h9cATb
        yWVS+0bAZr7upjXorukYTRKaiecVTaoHlH9Zo=; b=uucfgVXafg4TbXPADelze8
        YBcmXZ6dEr6anLKQmVfxU/3jozvX5rKnO10pjV1Ay9FQwjwMdvHU45UHZQ7AgPCf
        fpKcasUaVmBF9HjnqTLMHud5kv4HWjODBxErSaxDdBLY0//QW34aP8ltG4qdoT0t
        RXOBaPUATm5QVRR2POymLYl3agFwLP5Tm/YTQ+eCG/CV47Ciduy8r+DE2o0prjt+
        jUTIvKHHGqoc8DIq7b6ijs8p/NDU0jc0PbIzRgvW5ou7UWn38PdH/oxYF2T4zxc0
        qemxmS2pCSQpr4YYFZ7kir2cppKk7h4YYL3PnNhStt/lQujFILeNSSBVzBDQ8qXg
        ==
X-ME-Sender: <xms:B8o2Xc9iMTHw_YM3US5GxODXXm-QIraCgpWRHHInl93eu0SSF1pgrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:B8o2XaaauZ5BrTZUejKTdOnv6UtSCvPzFbUoQGDuIH5V9J5ia9IoTQ>
    <xmx:B8o2XTMPWSADZfU6CtANx8EiVQRzbJ8IvO7wMvcbH12omc7odRs6xg>
    <xmx:B8o2XaSEF07Je4DvcnIggzr2eyidde0cIjuf1WYHmrjMaNqrij1Hag>
    <xmx:CMo2Xefe-wNLNEgr2H0UT1fVbGV2Pdvz5hALmmIGCmwS740BBZkzog>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64C178005C;
        Tue, 23 Jul 2019 04:49:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam - limit output IV to CBC to work around CTR mode" failed to apply to 4.19-stable tree
To:     ard.biesheuvel@linaro.org, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, iuliana.prodan@nxp.com,
        s.hauer@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 10:49:09 +0200
Message-ID: <156387174945179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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
 

