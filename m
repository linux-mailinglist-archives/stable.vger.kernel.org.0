Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB3B8650
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389592AbfISWT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388006AbfISWTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86BAE21907;
        Thu, 19 Sep 2019 22:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931562;
        bh=8ZsyCqdCQYULk/KZ2gU6zijVGHecZMDT7Cgm36fRpKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd4iqt+pN5hw/qnOBbWc6DUCvwugnoX09pHsVf70P9hq3ivdhzZi6JRZ890s6cOAL
         0jZaOetprr+bi37Mu5iYlqiOf6lUxt5jvAoljUFCYMDPfsrcCQEWYhBTybz6PVzwnf
         WJpevNEMfBmUvvVdL2P9g6GmAOjBO7DCBKBjsW9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 30/74] crypto: talitos - Do not modify req->cryptlen on decryption.
Date:   Fri, 20 Sep 2019 00:03:43 +0200
Message-Id: <20190919214807.971753602@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
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
@@ -943,11 +943,13 @@ static void talitos_sg_unmap(struct devi
 
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
 
 	if (edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP)
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
@@ -956,7 +958,7 @@ static void ipsec_esp_unmap(struct devic
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen,
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, cryptlen,
 			 areq->assoclen);
 
 	if (edesc->dma_len)
@@ -967,7 +969,7 @@ static void ipsec_esp_unmap(struct devic
 		unsigned int dst_nents = edesc->dst_nents ? : 1;
 
 		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
-				   areq->assoclen + areq->cryptlen - ivsize);
+				   areq->assoclen + cryptlen - ivsize);
 	}
 }
 
@@ -988,7 +990,7 @@ static void ipsec_esp_encrypt_done(struc
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, areq);
+	ipsec_esp_unmap(dev, edesc, areq, true);
 
 	/* copy the generated ICV to dst */
 	if (edesc->icv_ool) {
@@ -1020,7 +1022,7 @@ static void ipsec_esp_decrypt_swauth_don
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, req);
+	ipsec_esp_unmap(dev, edesc, req, false);
 
 	if (!err) {
 		char icvdata[SHA512_DIGEST_SIZE];
@@ -1066,7 +1068,7 @@ static void ipsec_esp_decrypt_hwauth_don
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, req);
+	ipsec_esp_unmap(dev, edesc, req, false);
 
 	/* check ICV auth status */
 	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
@@ -1173,6 +1175,7 @@ static int talitos_sg_map(struct device
  * fill in and submit ipsec_esp descriptor
  */
 static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
+		     bool encrypt,
 		     void (*callback)(struct device *dev,
 				      struct talitos_desc *desc,
 				      void *context, int error))
@@ -1182,7 +1185,7 @@ static int ipsec_esp(struct talitos_edes
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
-	unsigned int cryptlen = areq->cryptlen;
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	int tbl_off = 0;
 	int sg_count, ret;
@@ -1324,7 +1327,7 @@ static int ipsec_esp(struct talitos_edes
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
-		ipsec_esp_unmap(dev, edesc, areq);
+		ipsec_esp_unmap(dev, edesc, areq, encrypt);
 		kfree(edesc);
 	}
 	return ret;
@@ -1433,9 +1436,10 @@ static struct talitos_edesc *aead_edesc_
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
@@ -1454,7 +1458,7 @@ static int aead_encrypt(struct aead_requ
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return ipsec_esp(edesc, req, ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
 }
 
 static int aead_decrypt(struct aead_request *req)
@@ -1466,8 +1470,6 @@ static int aead_decrypt(struct aead_requ
 	struct talitos_edesc *edesc;
 	void *icvdata;
 
-	req->cryptlen -= authsize;
-
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, req->iv, 1, false);
 	if (IS_ERR(edesc))
@@ -1485,7 +1487,8 @@ static int aead_decrypt(struct aead_requ
 		/* reset integrity check result bits */
 		edesc->desc.hdr_lo = 0;
 
-		return ipsec_esp(edesc, req, ipsec_esp_decrypt_hwauth_done);
+		return ipsec_esp(edesc, req, false,
+				 ipsec_esp_decrypt_hwauth_done);
 	}
 
 	/* Have to check the ICV with software */
@@ -1501,7 +1504,7 @@ static int aead_decrypt(struct aead_requ
 	sg_pcopy_to_buffer(req->src, edesc->src_nents ? : 1, icvdata, authsize,
 			   req->assoclen + req->cryptlen - authsize);
 
-	return ipsec_esp(edesc, req, ipsec_esp_decrypt_swauth_done);
+	return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
 }
 
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,


