Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF06E234A4
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbfETM3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389843AbfETM3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E98820645;
        Mon, 20 May 2019 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355354;
        bh=jS18uhjhZFB0J7GPa296xwoUoszjtacB5vvBJtErWs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTWndb4kDopFDVLmcwB1PffqwKgstb5BW6Gt484s9Xp9p7OHdCGTCnZKPQhnR7dVT
         4+MiNy0qYHq6biWFMtZo62hX9dHu6OPFj/WHsASWuMIf6CnzgKprqgI0M1jBXIYIaj
         MJng72E+DGPzBrL8HmiL7ZXX3jvdc1wH8BuA15cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 060/123] crypto: ccree - dont map MAC key on stack
Date:   Mon, 20 May 2019 14:14:00 +0200
Message-Id: <20190520115248.773914614@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit 874e163759f27e0a9988c5d1f4605e3f25564fd2 upstream.

The MAC hash key might be passed to us on stack. Copy it to
a slab buffer before mapping to gurantee proper DMA mapping.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_hash.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -69,6 +69,7 @@ struct cc_hash_alg {
 struct hash_key_req_ctx {
 	u32 keylen;
 	dma_addr_t key_dma_addr;
+	u8 *key;
 };
 
 /* hash per-session context */
@@ -730,13 +731,20 @@ static int cc_hash_setkey(struct crypto_
 	ctx->key_params.keylen = keylen;
 	ctx->key_params.key_dma_addr = 0;
 	ctx->is_hmac = true;
+	ctx->key_params.key = NULL;
 
 	if (keylen) {
+		ctx->key_params.key = kmemdup(key, keylen, GFP_KERNEL);
+		if (!ctx->key_params.key)
+			return -ENOMEM;
+
 		ctx->key_params.key_dma_addr =
-			dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+			dma_map_single(dev, (void *)ctx->key_params.key, keylen,
+				       DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
-				key, keylen);
+				ctx->key_params.key, keylen);
+			kzfree(ctx->key_params.key);
 			return -ENOMEM;
 		}
 		dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
@@ -887,6 +895,9 @@ out:
 		dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 	}
+
+	kzfree(ctx->key_params.key);
+
 	return rc;
 }
 
@@ -913,11 +924,16 @@ static int cc_xcbc_setkey(struct crypto_
 
 	ctx->key_params.keylen = keylen;
 
+	ctx->key_params.key = kmemdup(key, keylen, GFP_KERNEL);
+	if (!ctx->key_params.key)
+		return -ENOMEM;
+
 	ctx->key_params.key_dma_addr =
-		dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		dma_map_single(dev, ctx->key_params.key, keylen, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 			key, keylen);
+		kzfree(ctx->key_params.key);
 		return -ENOMEM;
 	}
 	dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
@@ -969,6 +985,8 @@ static int cc_xcbc_setkey(struct crypto_
 	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 
+	kzfree(ctx->key_params.key);
+
 	return rc;
 }
 


