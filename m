Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970F96C77D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390116AbfGRDGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389524AbfGRDF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:59 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A5921848;
        Thu, 18 Jul 2019 03:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419158;
        bh=3ZLHHXGni8QyzHRkyFuffBIIQe3ln5o3glY4VQOh9ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USeYLP8bQpgiw4D2YjVO3EQaY0VM6vD/z3E/ZTdYQkJ6CPrtZaRgkRU4RNZ6Z6U7c
         dv+nFawXotMCilwhmy89eP74mbDgzyoEFF8azt85rhx/EKXQrhq1KHWo2CWK8FvBhE
         Vhu3mfyAGuPOzVdB57wcBm5N3dGWaD+p4dFTY7V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 52/54] crypto: talitos - fix hash on SEC1.
Date:   Thu, 18 Jul 2019 12:01:47 +0900
Message-Id: <20190718030057.223827730@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 58cdbc6d2263beb36954408522762bbe73169306 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |   69 +++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 28 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -334,6 +334,21 @@ int talitos_submit(struct device *dev, i
 }
 EXPORT_SYMBOL(talitos_submit);
 
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
@@ -355,12 +370,7 @@ static void flush_channel(struct device
 
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
@@ -490,8 +500,14 @@ static u32 current_desc_hdr(struct devic
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
@@ -1401,15 +1417,11 @@ static struct talitos_edesc *talitos_ede
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
 
@@ -1676,14 +1688,16 @@ static void common_nonsnoop_hash_unmap(s
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
@@ -1750,7 +1764,6 @@ static void talitos_handle_buggy_hash(st
 
 static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				struct ahash_request *areq, unsigned int length,
-				unsigned int offset,
 				void (*callback) (struct device *dev,
 						  struct talitos_desc *desc,
 						  void *context, int error))
@@ -1789,9 +1802,7 @@ static int common_nonsnoop_hash(struct t
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
-		sg_pcopy_to_buffer(req_ctx->psrc, sg_count,
-				   edesc->buf + sizeof(struct talitos_desc),
-				   length, req_ctx->nbuf);
+		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
 	else if (length)
 		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
 				      DMA_TO_DEVICE);
@@ -1804,7 +1815,7 @@ static int common_nonsnoop_hash(struct t
 				       DMA_TO_DEVICE);
 	} else {
 		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc->ptr[3], sg_count, offset, 0);
+					  &desc->ptr[3], sg_count, 0, 0);
 		if (sg_count > 1)
 			sync_needed = true;
 	}
@@ -1828,7 +1839,8 @@ static int common_nonsnoop_hash(struct t
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
 	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_desc *desc2 = desc + 1;
+		struct talitos_desc *desc2 = (struct talitos_desc *)
+					     (edesc->buf + edesc->dma_len);
 		dma_addr_t next_desc;
 
 		memset(desc2, 0, sizeof(*desc2));
@@ -1849,7 +1861,7 @@ static int common_nonsnoop_hash(struct t
 						      DMA_TO_DEVICE);
 		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
 		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc2->ptr[3], sg_count, offset, 0);
+					  &desc2->ptr[3], sg_count, 0, 0);
 		if (sg_count > 1)
 			sync_needed = true;
 		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
@@ -1960,7 +1972,6 @@ static int ahash_process_req(struct ahas
 	struct device *dev = ctx->dev;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
-	int offset = 0;
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
@@ -2000,6 +2011,8 @@ static int ahash_process_req(struct ahas
 			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
+		int offset;
+
 		if (nbytes_to_hash > blocksize)
 			offset = blocksize - req_ctx->nbuf;
 		else
@@ -2012,7 +2025,8 @@ static int ahash_process_req(struct ahas
 		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, offset);
 		req_ctx->nbuf += offset;
-		req_ctx->psrc = areq->src;
+		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, areq->src,
+						 offset);
 	} else
 		req_ctx->psrc = areq->src;
 
@@ -2052,8 +2066,7 @@ static int ahash_process_req(struct ahas
 	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
-	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, offset,
-				    ahash_done);
+	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, ahash_done);
 }
 
 static int ahash_update(struct ahash_request *areq)


