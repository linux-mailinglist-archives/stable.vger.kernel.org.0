Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570292347A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389052AbfETM1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389465AbfETM1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84FED21479;
        Mon, 20 May 2019 12:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355234;
        bh=jtIPTCrCDBggXmWVcRLXc+5STIRFw19bMK6i/GTSBXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQIQhwM25Pglby1CpaN5mVzYDJ3eBsdp3PIx8lrrwSURNoiv8JZdwgtRJ/+lTt6Af
         /j0xLA40Y4X5jlAe5iIKgpE4XK7skI9iAjxg4aObAClfsMJldNpGVNhQ38lswLEo8G
         /FTIY0KtjHMetJOhINiBMmaPS+Soie5XVJx0BiqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 041/123] crypto: caam/qi2 - generate hash keys in-place
Date:   Mon, 20 May 2019 14:13:41 +0200
Message-Id: <20190520115247.453960552@linuxfoundation.org>
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

From: Horia Geantă <horia.geanta@nxp.com>

commit 418cd20e4dcdca97e6f6d59e6336228dacf2e45d upstream.

Commit 307244452d3d ("crypto: caam - generate hash keys in-place")
fixed ahash implementation in caam/jr driver such that user-provided key
buffer is not DMA mapped, since it's not guaranteed to be DMAable.

Apply a similar fix for caam/qi2 driver.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_qi2.c |   41 +++++++++++++-------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3021,13 +3021,13 @@ static void split_key_sh_done(void *cbk_
 }
 
 /* Digest hash size if it is too large */
-static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
-			   u32 *keylen, u8 *key_out, u32 digestsize)
+static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
+			   u32 digestsize)
 {
 	struct caam_request *req_ctx;
 	u32 *desc;
 	struct split_key_sh_result result;
-	dma_addr_t src_dma, dst_dma;
+	dma_addr_t key_dma;
 	struct caam_flc *flc;
 	dma_addr_t flc_dma;
 	int ret = -ENOMEM;
@@ -3044,17 +3044,10 @@ static int hash_digest_key(struct caam_h
 	if (!flc)
 		goto err_flc;
 
-	src_dma = dma_map_single(ctx->dev, (void *)key_in, *keylen,
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(ctx->dev, src_dma)) {
-		dev_err(ctx->dev, "unable to map key input memory\n");
-		goto err_src_dma;
-	}
-	dst_dma = dma_map_single(ctx->dev, (void *)key_out, digestsize,
-				 DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, dst_dma)) {
-		dev_err(ctx->dev, "unable to map key output memory\n");
-		goto err_dst_dma;
+	key_dma = dma_map_single(ctx->dev, key, *keylen, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(ctx->dev, key_dma)) {
+		dev_err(ctx->dev, "unable to map key memory\n");
+		goto err_key_dma;
 	}
 
 	desc = flc->sh_desc;
@@ -3079,14 +3072,14 @@ static int hash_digest_key(struct caam_h
 
 	dpaa2_fl_set_final(in_fle, true);
 	dpaa2_fl_set_format(in_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(in_fle, src_dma);
+	dpaa2_fl_set_addr(in_fle, key_dma);
 	dpaa2_fl_set_len(in_fle, *keylen);
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, dst_dma);
+	dpaa2_fl_set_addr(out_fle, key_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, key_in, *keylen, 1);
+			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -3106,17 +3099,15 @@ static int hash_digest_key(struct caam_h
 		wait_for_completion(&result.completion);
 		ret = result.err;
 		print_hex_dump_debug("digested key@" __stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, key_in,
+				     DUMP_PREFIX_ADDRESS, 16, 4, key,
 				     digestsize, 1);
 	}
 
 	dma_unmap_single(ctx->dev, flc_dma, sizeof(flc->flc) + desc_bytes(desc),
 			 DMA_TO_DEVICE);
 err_flc_dma:
-	dma_unmap_single(ctx->dev, dst_dma, digestsize, DMA_FROM_DEVICE);
-err_dst_dma:
-	dma_unmap_single(ctx->dev, src_dma, *keylen, DMA_TO_DEVICE);
-err_src_dma:
+	dma_unmap_single(ctx->dev, key_dma, *keylen, DMA_BIDIRECTIONAL);
+err_key_dma:
 	kfree(flc);
 err_flc:
 	kfree(req_ctx);
@@ -3138,12 +3129,10 @@ static int ahash_setkey(struct crypto_ah
 	dev_dbg(ctx->dev, "keylen %d blocksize %d\n", keylen, blocksize);
 
 	if (keylen > blocksize) {
-		hashed_key = kmalloc_array(digestsize, sizeof(*hashed_key),
-					   GFP_KERNEL | GFP_DMA);
+		hashed_key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 		if (!hashed_key)
 			return -ENOMEM;
-		ret = hash_digest_key(ctx, key, &keylen, hashed_key,
-				      digestsize);
+		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
 		key = hashed_key;


