Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0700769039
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390154AbfGOOTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389694AbfGOOTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:19:46 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D360D21849;
        Mon, 15 Jul 2019 14:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200385;
        bh=VbUdvuZCjsQZ77IdoV7wqtuBsUHRU16MhnT13/HeiSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpUgQQy1crl2459r+AyU1eWEbpr3CoHJYFZHT0r4N801jk6HMOAdvJlchVu7/PDBl
         V72C+41/RnhNmS0+gWwgvUnd7y5UamUYomDwYSfdvJvTx5o9uXhwWw8wYQva7yLzP+
         jpb1H96GiUesnBdSqZglAjtxTbF6UzfVzzVS5eUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 033/158] crypto: talitos - properly handle split ICV.
Date:   Mon, 15 Jul 2019 10:16:04 -0400
Message-Id: <20190715141809.8445-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

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
index 9cc5309a3fbf..027cb298888e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1015,7 +1015,6 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	void *icvdata;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
@@ -1029,9 +1028,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
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
@@ -1049,7 +1047,6 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	char *oicv, *icv;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1059,9 +1056,18 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
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
@@ -1481,7 +1487,6 @@ static int aead_decrypt(struct aead_request *req)
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	void *icvdata;
 
 	req->cryptlen -= authsize;
@@ -1515,9 +1520,8 @@ static int aead_decrypt(struct aead_request *req)
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

