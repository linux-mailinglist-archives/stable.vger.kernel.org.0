Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0AB67A8B
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 16:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfGMO3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 10:29:22 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38097 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727504AbfGMO3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 10:29:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F147343F;
        Sat, 13 Jul 2019 10:29:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 13 Jul 2019 10:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:from:message-id:mime-version:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9dKnyNZW++hPbr5k9cgrcZDonT4AhbBHIUhHGbgqrmM=; b=0Lj8i/UD
        fiE6/Ey8o55YpAv9rWMEjYWEfwZZoHwvjrYsoewxbhFwacuajFGGPN6jmEmO2p5F
        mDCAthkc8M8OW3iWyl2iSxXQ5fmQJCbAu2qTuMqnXzH6QVXnPR4UtHMj6THe+Gtq
        n1ovh61a9HlwpCksW3G0UrbW/CkavAoBMl8WkUEnMNe6ZCXgj9fk3EPzq9diqC0B
        DX4yl8/YNMIl99TYC2nJmq+XHLPq5IWRwJMGf3/RfNUq/xVb6dDfrCwcNzNMnWge
        uxnSImlYwFPYhuBLuXBOdcG5Is/b+fwC4DhlxjNAbPl/7SmhFwo+IlItRYbixxzj
        AjGASrQDTCo1kQ==
X-ME-Sender: <xms:vOopXWwGG2a-nvAB_k3QABkHBN6fbPQOXz_HPNgkIbF4p1xVwR6wfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedvgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vOopXRDiuN2e-v8Pve9_90V4dNDN5DNIKX7naz6BJDbugXjhR_VSVw>
    <xmx:vOopXX4p8M4Etopw45qufkMUI2GH8SpHTuOkga5l5WPOW0w0jRtZxg>
    <xmx:vOopXW0k6AZYvRguxCN0wrnh8g80dJTp5tJ_NaD4RakhumfZP53HEw>
    <xmx:veopXZB-XOyXhMQfvzp-xqP5o9lSbO5Z8lcajvyKetn7CBj_OjmqrQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1413C80061;
        Sat, 13 Jul 2019 10:29:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: talitos - fix hash on SEC1." failed to apply to 5.2-stable tree
To:     christophe.leroy@c-s.fr
Cc:     <stable@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Jul 2019 16:26:31 +0200
Message-ID: <156302799113810@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 58cdbc6d2263beb36954408522762bbe73169306 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Mon, 24 Jun 2019 07:20:16 +0000
Subject: [PATCH] crypto: talitos - fix hash on SEC1.

On SEC1, hash provides wrong result when performing hashing in several
steps with input data SG list has more than one element. This was
detected with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS:

[   44.185947] alg: hash: md5-talitos test failed (wrong result) on test vector 6, cfg="random: may_sleep use_finup src_divs=[<reimport>25.88%@+8063, <flush>24.19%@+9588, 28.63%@+16333, <reimport>4.60%@+6756, 16.70%@+16281] dst_divs=[71.61%@alignmask+16361, 14.36%@+7756, 14.3%@+"
[   44.325122] alg: hash: sha1-talitos test failed (wrong result) on test vector 3, cfg="random: inplace use_final src_divs=[<flush,nosimd>16.56%@+16378, <reimport>52.0%@+16329, 21.42%@alignmask+16380, 10.2%@alignmask+16380] iv_offset=39"
[   44.493500] alg: hash: sha224-talitos test failed (wrong result) on test vector 4, cfg="random: use_final nosimd src_divs=[<reimport>52.27%@+7401, <reimport>17.34%@+16285, <flush>17.71%@+26, 12.68%@+10644] iv_offset=43"
[   44.673262] alg: hash: sha256-talitos test failed (wrong result) on test vector 4, cfg="random: may_sleep use_finup src_divs=[<reimport>60.6%@+12790, 17.86%@+1329, <reimport>12.64%@alignmask+16300, 8.29%@+15, 0.40%@+13506, <reimport>0.51%@+16322, <reimport>0.24%@+16339] dst_divs"

This is due to two issues:
- We have an overlap between the buffer used for copying the input
data (SEC1 doesn't do scatter/gather) and the chained descriptor.
- Data copy is wrong when the previous hash left less than one
blocksize of data to hash, implying a complement of the previous
block with a few bytes from the new request.

Fix it by:
- Moving the second descriptor after the buffer, as moving the buffer
after the descriptor would make it more complex for other cipher
operations (AEAD, ABLKCIPHER)
- Skip the bytes taken from the new request to complete the previous
one by moving the SG list forward.

Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash on SEC1")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3918b3dbe684..c431d96e5596 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -320,6 +320,21 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	return -EINPROGRESS;
 }
 
+static __be32 get_request_hdr(struct talitos_request *request, bool is_sec1)
+{
+	struct talitos_edesc *edesc;
+
+	if (!is_sec1)
+		return request->desc->hdr;
+
+	if (!request->desc->next_desc)
+		return request->desc->hdr1;
+
+	edesc = container_of(request->desc, struct talitos_edesc, desc);
+
+	return ((struct talitos_desc *)(edesc->buf + edesc->dma_len))->hdr1;
+}
+
 /*
  * process what was done, notify callback of error if not
  */
@@ -341,12 +356,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		if (!is_sec1)
-			hdr = request->desc->hdr;
-		else if (request->desc->next_desc)
-			hdr = (request->desc + 1)->hdr1;
-		else
-			hdr = request->desc->hdr1;
+		hdr = get_request_hdr(request, is_sec1);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;
@@ -476,8 +486,14 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
-	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc)
-		return (priv->chan[ch].fifo[iter].desc + 1)->hdr;
+	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc) {
+		struct talitos_edesc *edesc;
+
+		edesc = container_of(priv->chan[ch].fifo[iter].desc,
+				     struct talitos_edesc, desc);
+		return ((struct talitos_desc *)
+			(edesc->buf + edesc->dma_len))->hdr;
+	}
 
 	return priv->chan[ch].fifo[iter].desc->hdr;
 }
@@ -1402,15 +1418,11 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
 	edesc->dma_len = dma_len;
-	if (dma_len) {
-		void *addr = &edesc->link_tbl[0];
-
-		if (is_sec1 && !dst)
-			addr += sizeof(struct talitos_desc);
-		edesc->dma_link_tbl = dma_map_single(dev, addr,
+	if (dma_len)
+		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
 						     edesc->dma_len,
 						     DMA_BIDIRECTIONAL);
-	}
+
 	return edesc;
 }
 
@@ -1722,14 +1734,16 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
-	struct talitos_desc *desc2 = desc + 1;
+	struct talitos_desc *desc2 = (struct talitos_desc *)
+				     (edesc->buf + edesc->dma_len);
 
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 	if (desc->next_desc &&
 	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
 		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
+	if (req_ctx->psrc)
+		talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
 	if (from_talitos_ptr_len(&edesc->desc.ptr[1], is_sec1))
@@ -1796,7 +1810,6 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
 
 static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				struct ahash_request *areq, unsigned int length,
-				unsigned int offset,
 				void (*callback) (struct device *dev,
 						  struct talitos_desc *desc,
 						  void *context, int error))
@@ -1835,9 +1848,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
-		sg_pcopy_to_buffer(req_ctx->psrc, sg_count,
-				   edesc->buf + sizeof(struct talitos_desc),
-				   length, req_ctx->nbuf);
+		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
 	else if (length)
 		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
 				      DMA_TO_DEVICE);
@@ -1850,7 +1861,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       DMA_TO_DEVICE);
 	} else {
 		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc->ptr[3], sg_count, offset, 0);
+					  &desc->ptr[3], sg_count, 0, 0);
 		if (sg_count > 1)
 			sync_needed = true;
 	}
@@ -1874,7 +1885,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
 	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_desc *desc2 = desc + 1;
+		struct talitos_desc *desc2 = (struct talitos_desc *)
+					     (edesc->buf + edesc->dma_len);
 		dma_addr_t next_desc;
 
 		memset(desc2, 0, sizeof(*desc2));
@@ -1895,7 +1907,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 						      DMA_TO_DEVICE);
 		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
 		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc2->ptr[3], sg_count, offset, 0);
+					  &desc2->ptr[3], sg_count, 0, 0);
 		if (sg_count > 1)
 			sync_needed = true;
 		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
@@ -2006,7 +2018,6 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	struct device *dev = ctx->dev;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
-	int offset = 0;
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
@@ -2046,6 +2057,8 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
+		int offset;
+
 		if (nbytes_to_hash > blocksize)
 			offset = blocksize - req_ctx->nbuf;
 		else
@@ -2058,7 +2071,8 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, offset);
 		req_ctx->nbuf += offset;
-		req_ctx->psrc = areq->src;
+		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, areq->src,
+						 offset);
 	} else
 		req_ctx->psrc = areq->src;
 
@@ -2098,8 +2112,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
-	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, offset,
-				    ahash_done);
+	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, ahash_done);
 }
 
 static int ahash_update(struct ahash_request *areq)

