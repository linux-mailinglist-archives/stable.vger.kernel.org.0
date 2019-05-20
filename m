Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9F235D5
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390464AbfETMjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390783AbfETMdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DCA21479;
        Mon, 20 May 2019 12:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355626;
        bh=ThuQJlJWUbJBxZLkx4DtB+RwKwOeEAz2/qoq9LVWops=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YOeaN/ySDbdfbMbNsJicDMIq+flf5LiUOznorgb1ouXvoW12usOQnRJRh1k35eDQ
         jZGn6MTd0L3M3G9WMsz5yUk4MZlUSQ7b9QasZ2u4laKhTkAT4kIM9h3EDSFu70NoB2
         lZFh6qdjryV82u9dIVYWRoQb8pD9nBkfQHkl3gDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 064/128] crypto: ccree - dont map AEAD key and IV on stack
Date:   Mon, 20 May 2019 14:14:11 +0200
Message-Id: <20190520115254.120694661@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit e8662a6a5f8f7f2cadc0edb934aef622d96ac3ee upstream.

The AEAD authenc key and IVs might be passed to us on stack. Copy it to
a slab buffer before mapping to gurantee proper DMA mapping.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_aead.c       |   11 ++++++++++-
 drivers/crypto/ccree/cc_buffer_mgr.c |   15 ++++++++++++---
 drivers/crypto/ccree/cc_driver.h     |    1 +
 3 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -424,7 +424,7 @@ static int validate_keys_sizes(struct cc
 /* This function prepers the user key so it can pass to the hmac processing
  * (copy to intenral buffer or hash in case of key longer than block
  */
-static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *authkey,
 				 unsigned int keylen)
 {
 	dma_addr_t key_dma_addr = 0;
@@ -437,6 +437,7 @@ static int cc_get_plain_hmac_key(struct
 	unsigned int hashmode;
 	unsigned int idx = 0;
 	int rc = 0;
+	u8 *key = NULL;
 	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
 	dma_addr_t padded_authkey_dma_addr =
 		ctx->auth_state.hmac.padded_authkey_dma_addr;
@@ -455,11 +456,17 @@ static int cc_get_plain_hmac_key(struct
 	}
 
 	if (keylen != 0) {
+
+		key = kmemdup(authkey, keylen, GFP_KERNEL);
+		if (!key)
+			return -ENOMEM;
+
 		key_dma_addr = dma_map_single(dev, (void *)key, keylen,
 					      DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
+			kzfree(key);
 			return -ENOMEM;
 		}
 		if (keylen > blocksize) {
@@ -542,6 +549,8 @@ static int cc_get_plain_hmac_key(struct
 	if (key_dma_addr)
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
 
+	kzfree(key);
+
 	return rc;
 }
 
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -560,6 +560,7 @@ void cc_unmap_aead_request(struct device
 	if (areq_ctx->gen_ctx.iv_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
 				 hw_iv_size, DMA_BIDIRECTIONAL);
+		kzfree(areq_ctx->gen_ctx.iv);
 	}
 
 	/* Release pool */
@@ -664,19 +665,27 @@ static int cc_aead_chain_iv(struct cc_dr
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
 	struct device *dev = drvdata_to_dev(drvdata);
+	gfp_t flags = cc_gfp_flags(&req->base);
 	int rc = 0;
 
 	if (!req->iv) {
 		areq_ctx->gen_ctx.iv_dma_addr = 0;
+		areq_ctx->gen_ctx.iv = NULL;
 		goto chain_iv_exit;
 	}
 
-	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
-						       hw_iv_size,
-						       DMA_BIDIRECTIONAL);
+	areq_ctx->gen_ctx.iv = kmemdup(req->iv, hw_iv_size, flags);
+	if (!areq_ctx->gen_ctx.iv)
+		return -ENOMEM;
+
+	areq_ctx->gen_ctx.iv_dma_addr =
+		dma_map_single(dev, areq_ctx->gen_ctx.iv, hw_iv_size,
+			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
 		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
 			hw_iv_size, req->iv);
+		kzfree(areq_ctx->gen_ctx.iv);
+		areq_ctx->gen_ctx.iv = NULL;
 		rc = -ENOMEM;
 		goto chain_iv_exit;
 	}
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -168,6 +168,7 @@ struct cc_alg_template {
 
 struct async_gen_req_ctx {
 	dma_addr_t iv_dma_addr;
+	u8 *iv;
 	enum drv_crypto_direction op_type;
 };
 


