Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04F7697BC
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbfGONuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731934AbfGONuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:50:02 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E038220651;
        Mon, 15 Jul 2019 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198601;
        bh=S7QMUTIfrMKNE8TMyNmP9bg8l/7SEA7p9sCrWAdjPfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSOUGZQbbHnlcO08kBwExeBbFZVE0RiQb8UMVFdehX7OCK1jfNiQtxt+JsZmFPl8V
         vrEvP6aTLMN+VZcA8AGDmkI5YCDcTXth81QcvUSKIYWUkQPLH/uclU9pqaA0ecjlIl
         gGcCwpoSmpY/0g+6oxJKFp1ez5yJ68y00NIkTQOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 056/249] crypto: talitos - properly handle split ICV.
Date:   Mon, 15 Jul 2019 09:43:41 -0400
Message-Id: <20190715134655.4076-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
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
index 2d9a0971a7fc..eec880909fdf 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1050,7 +1050,6 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	void *icvdata;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
@@ -1064,9 +1063,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
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
@@ -1084,7 +1082,6 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	char *oicv, *icv;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1094,9 +1091,18 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
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
@@ -1516,7 +1522,6 @@ static int aead_decrypt(struct aead_request *req)
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
 	struct talitos_edesc *edesc;
-	struct scatterlist *sg;
 	void *icvdata;
 
 	req->cryptlen -= authsize;
@@ -1550,9 +1555,8 @@ static int aead_decrypt(struct aead_request *req)
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

