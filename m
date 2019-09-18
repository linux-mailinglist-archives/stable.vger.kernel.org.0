Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6169AB5C7D
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfIRG0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbfIRG0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545A2218AF;
        Wed, 18 Sep 2019 06:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788011;
        bh=vD6JDGzbIZxa6SnE9uU+YbRlIM+lwOXfOkVjjujYh+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJXwQB1foGv3aK0eYt0gjBlZRhT2YwKD9dlROBg5F0RfHUBWDtpdzt3TC8zJ+MCn6
         Szt86JgPgGrcxoJZ00tCObM8Gw4WP/sNspN1zpl6hwKMptdwgrB/++q8lRoT5leQkk
         3HfKYSVhtFkgjiivwBDz04pjvt++nSZtE/hmkk8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 67/85] crypto: talitos - Do not modify req->cryptlen on decryption.
Date:   Wed, 18 Sep 2019 08:19:25 +0200
Message-Id: <20190918061237.535504072@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 7ede4c36cf7c6516986ee9d75b197c8bf73ea96f upstream.

For decrypt, req->cryptlen includes the size of the authentication
part while all functions of the driver expect cryptlen to be
the size of the encrypted data.

As it is not expected to change req->cryptlen, this patch
implements local calculation of cryptlen.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 9c4a79653b35 ("crypto: talitos - Freescale integrated security engine (SEC) driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -994,11 +994,13 @@ static void talitos_sg_unmap(struct devi
 
 static void ipsec_esp_unmap(struct device *dev,
 			    struct talitos_edesc *edesc,
-			    struct aead_request *areq)
+			    struct aead_request *areq, bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
 	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
 
@@ -1007,7 +1009,7 @@ static void ipsec_esp_unmap(struct devic
 					 DMA_FROM_DEVICE);
 	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen,
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, cryptlen,
 			 areq->assoclen);
 
 	if (edesc->dma_len)
@@ -1018,7 +1020,7 @@ static void ipsec_esp_unmap(struct devic
 		unsigned int dst_nents = edesc->dst_nents ? : 1;
 
 		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
-				   areq->assoclen + areq->cryptlen - ivsize);
+				   areq->assoclen + cryptlen - ivsize);
 	}
 }
 
@@ -1040,7 +1042,7 @@ static void ipsec_esp_encrypt_done(struc
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, areq);
+	ipsec_esp_unmap(dev, edesc, areq, true);
 
 	/* copy the generated ICV to dst */
 	if (edesc->icv_ool) {
@@ -1074,7 +1076,7 @@ static void ipsec_esp_decrypt_swauth_don
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, req);
+	ipsec_esp_unmap(dev, edesc, req, false);
 
 	if (!err) {
 		char icvdata[SHA512_DIGEST_SIZE];
@@ -1120,7 +1122,7 @@ static void ipsec_esp_decrypt_hwauth_don
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, req);
+	ipsec_esp_unmap(dev, edesc, req, false);
 
 	/* check ICV auth status */
 	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
@@ -1223,6 +1225,7 @@ static int talitos_sg_map(struct device
  * fill in and submit ipsec_esp descriptor
  */
 static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
+		     bool encrypt,
 		     void (*callback)(struct device *dev,
 				      struct talitos_desc *desc,
 				      void *context, int error))
@@ -1232,7 +1235,7 @@ static int ipsec_esp(struct talitos_edes
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
-	unsigned int cryptlen = areq->cryptlen;
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	int tbl_off = 0;
 	int sg_count, ret;
@@ -1359,7 +1362,7 @@ static int ipsec_esp(struct talitos_edes
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
-		ipsec_esp_unmap(dev, edesc, areq);
+		ipsec_esp_unmap(dev, edesc, areq, encrypt);
 		kfree(edesc);
 	}
 	return ret;
@@ -1473,9 +1476,10 @@ static struct talitos_edesc *aead_edesc_
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 
 	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
-				   iv, areq->assoclen, areq->cryptlen,
+				   iv, areq->assoclen, cryptlen,
 				   authsize, ivsize, icv_stashing,
 				   areq->base.flags, encrypt);
 }
@@ -1494,7 +1498,7 @@ static int aead_encrypt(struct aead_requ
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return ipsec_esp(edesc, req, ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
 }
 
 static int aead_decrypt(struct aead_request *req)
@@ -1506,8 +1510,6 @@ static int aead_decrypt(struct aead_requ
 	struct talitos_edesc *edesc;
 	void *icvdata;
 
-	req->cryptlen -= authsize;
-
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, req->iv, 1, false);
 	if (IS_ERR(edesc))
@@ -1524,7 +1526,8 @@ static int aead_decrypt(struct aead_requ
 
 		/* reset integrity check result bits */
 
-		return ipsec_esp(edesc, req, ipsec_esp_decrypt_hwauth_done);
+		return ipsec_esp(edesc, req, false,
+				 ipsec_esp_decrypt_hwauth_done);
 	}
 
 	/* Have to check the ICV with software */
@@ -1540,7 +1543,7 @@ static int aead_decrypt(struct aead_requ
 	sg_pcopy_to_buffer(req->src, edesc->src_nents ? : 1, icvdata, authsize,
 			   req->assoclen + req->cryptlen - authsize);
 
-	return ipsec_esp(edesc, req, ipsec_esp_decrypt_swauth_done);
+	return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
 }
 
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,


