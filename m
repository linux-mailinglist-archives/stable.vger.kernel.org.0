Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F65A739F0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390953AbfGXTpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390950AbfGXTpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:45:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7919A2083B;
        Wed, 24 Jul 2019 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997516;
        bh=52a8PYgzZEugHZEXBvBLrLYC6Ms7gzUn+3xw6S2uNE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyE8kIFVzNtNbgYQIybXK8s9mXLbFoOsxBVlmu/K6G9yn2J8OagwmwnGGej3e2TOc
         UOZXsn+2K/QVWaOEHgQWV3XzQ+GZcQMBj/mzvLBbFb+pmCAGp3D2sNziyj9l0piFpp
         n2J+NliR3jy4moAc6G3DrYIhzIdyJ8PvDuX7X4wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 050/371] crypto: talitos - properly handle split ICV.
Date:   Wed, 24 Jul 2019 21:16:42 +0200
Message-Id: <20190724191728.467231915@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eae55a586c3c8b50982bad3c3426e9c9dd7a0075 ]

The driver assumes that the ICV is as a single piece in the last
element of the scatterlist. This assumption is wrong.

This patch ensures that the ICV is properly handled regardless of
the scatterlist layout.

Fixes: 9c4a79653b35 ("crypto: talitos - Freescale integrated security engine (SEC) driver")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6ef41114e0fc..657cf739ee40 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1001,7 +1001,6 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	void *icvdata;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
@@ -1015,9 +1014,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 		else
 			icvdata = &edesc->link_tbl[edesc->src_nents +
 						   edesc->dst_nents + 2];
-		sg = sg_last(areq->dst, edesc->dst_nents);
-		memcpy((char *)sg_virt(sg) + sg->length - authsize,
-		       icvdata, authsize);
+		sg_pcopy_from_buffer(areq->dst, edesc->dst_nents ? : 1, icvdata,
+				     authsize, areq->assoclen + areq->cryptlen);
 	}
 
 	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
@@ -1035,7 +1033,6 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	char *oicv, *icv;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1045,9 +1042,18 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 	ipsec_esp_unmap(dev, edesc, req);
 
 	if (!err) {
+		char icvdata[SHA512_DIGEST_SIZE];
+		int nents = edesc->dst_nents ? : 1;
+		unsigned int len = req->assoclen + req->cryptlen;
+
 		/* auth check */
-		sg = sg_last(req->dst, edesc->dst_nents ? : 1);
-		icv = (char *)sg_virt(sg) + sg->length - authsize;
+		if (nents > 1) {
+			sg_pcopy_to_buffer(req->dst, nents, icvdata, authsize,
+					   len - authsize);
+			icv = icvdata;
+		} else {
+			icv = (char *)sg_virt(req->dst) + len - authsize;
+		}
 
 		if (edesc->dma_len) {
 			if (is_sec1)
@@ -1463,7 +1469,6 @@ static int aead_decrypt(struct aead_request *req)
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	void *icvdata;
 
 	req->cryptlen -= authsize;
@@ -1497,9 +1502,8 @@ static int aead_decrypt(struct aead_request *req)
 	else
 		icvdata = &edesc->link_tbl[0];
 
-	sg = sg_last(req->src, edesc->src_nents ? : 1);
-
-	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - authsize, authsize);
+	sg_pcopy_to_buffer(req->src, edesc->src_nents ? : 1, icvdata, authsize,
+			   req->assoclen + req->cryptlen - authsize);
 
 	return ipsec_esp(edesc, req, ipsec_esp_decrypt_swauth_done);
 }
-- 
2.20.1



