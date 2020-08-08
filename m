Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAD623FB2A
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHHXhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgHHXhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F3F2073E;
        Sat,  8 Aug 2020 23:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929866;
        bh=pwd8sTXOmkL22U64OXCCpqiQ23X2e4TzpaRY8PfRy+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWaneOvpP8E0FeT9f+mdKj78TYLIYQ6s1VW0KQ6i4mMTXMbYLZsgrNqNkA+DL20jP
         svqbFGmzUUKPZWm5jJ3KC28l/46iNWxhM65FOOByzBgrYbCfOcfPHNDquvgRoZF7jF
         TUQJpz61gMkqT9sUNp03jg78f+9BvfurAb6Bxbz0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 16/58] crypto: ccree - fix resource leak on error path
Date:   Sat,  8 Aug 2020 19:36:42 -0400
Message-Id: <20200808233724.3618168-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 9bc6165d608d676f05d8bf156a2c9923ee38d05b ]

Fix a small resource leak on the error path of cipher processing.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 63ee04c8b491e ("crypto: ccree - add skcipher support")
Cc: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_cipher.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index a84335328f371..89f7661f0dce8 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -159,7 +159,6 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 				     skcipher_alg.base);
 	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
-	int rc = 0;
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
 		crypto_tfm_alg_name(tfm));
@@ -171,10 +170,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	ctx_p->flow_mode = cc_alg->flow_mode;
 	ctx_p->drvdata = cc_alg->drvdata;
 
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Alloc hash tfm for essiv */
+		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
+		if (IS_ERR(ctx_p->shash_tfm)) {
+			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
+			return PTR_ERR(ctx_p->shash_tfm);
+		}
+	}
+
 	/* Allocate key buffer, cache line aligned */
 	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
 	if (!ctx_p->user.key)
-		return -ENOMEM;
+		goto free_shash;
 
 	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
 		ctx_p->user.key);
@@ -186,21 +194,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
 		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
 			max_key_buf_size, ctx_p->user.key);
-		return -ENOMEM;
+		goto free_key;
 	}
 	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
 		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
 
-	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-		/* Alloc hash tfm for essiv */
-		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
-		if (IS_ERR(ctx_p->shash_tfm)) {
-			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
-			return PTR_ERR(ctx_p->shash_tfm);
-		}
-	}
+	return 0;
 
-	return rc;
+free_key:
+	kfree(ctx_p->user.key);
+free_shash:
+	crypto_free_shash(ctx_p->shash_tfm);
+
+	return -ENOMEM;
 }
 
 static void cc_cipher_exit(struct crypto_tfm *tfm)
-- 
2.25.1

