Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3A023528
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390714AbfETMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390709AbfETMd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D69720645;
        Mon, 20 May 2019 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355605;
        bh=L/6tdLBJz6PHwDWIwjuuHuLjOey7H1pd/wofkzIbx3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoOkPwLb/DJOC6R7D4JG5iTD6WyXxMm4LL06vs9RWsQ85GdhnawTm7ZrDjGBW5i1b
         fKlhhKHhBPXSsYV2e4QyxPTOJSRdIeIM4SPI0n6Ee6K78Rc8JahxlSffOQGEWtwtIt
         /hNjdf/XZk5NbceQh5qp7LfQ5F89ac36Pa3/lz0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 039/128] crypto: caam/qi2 - fix DMA mapping of stack memory
Date:   Mon, 20 May 2019 14:13:46 +0200
Message-Id: <20190520115252.351649391@linuxfoundation.org>
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

From: Horia Geantă <horia.geanta@nxp.com>

commit 5965dc745287bebf7a2eba91a66f017537fa4c54 upstream.

Commits c19650d6ea99 ("crypto: caam - fix DMA mapping of stack memory")
and 65055e210884 ("crypto: caam - fix hash context DMA unmap size")
fixed the ahash implementation in caam/jr driver such that req->result
is not DMA-mapped (since it's not guaranteed to be DMA-able).

Apply a similar fix for ahash implementation in caam/qi2 driver.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_qi2.c |  111 +++++++++++++++-----------------------
 drivers/crypto/caam/caamalg_qi2.h |    2 
 2 files changed, 45 insertions(+), 68 deletions(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -2854,6 +2854,7 @@ struct caam_hash_state {
 	struct caam_request caam_req;
 	dma_addr_t buf_dma;
 	dma_addr_t ctx_dma;
+	int ctx_dma_len;
 	u8 buf_0[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
 	int buflen_0;
 	u8 buf_1[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
@@ -2927,6 +2928,7 @@ static inline int ctx_map_to_qm_sg(struc
 				   struct caam_hash_state *state, int ctx_len,
 				   struct dpaa2_sg_entry *qm_sg, u32 flag)
 {
+	state->ctx_dma_len = ctx_len;
 	state->ctx_dma = dma_map_single(dev, state->caam_ctx, ctx_len, flag);
 	if (dma_mapping_error(dev, state->ctx_dma)) {
 		dev_err(dev, "unable to map ctx\n");
@@ -3165,14 +3167,12 @@ bad_free_key:
 }
 
 static inline void ahash_unmap(struct device *dev, struct ahash_edesc *edesc,
-			       struct ahash_request *req, int dst_len)
+			       struct ahash_request *req)
 {
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
 	if (edesc->src_nents)
 		dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
-	if (edesc->dst_dma)
-		dma_unmap_single(dev, edesc->dst_dma, dst_len, DMA_FROM_DEVICE);
 
 	if (edesc->qm_sg_bytes)
 		dma_unmap_single(dev, edesc->qm_sg_dma, edesc->qm_sg_bytes,
@@ -3187,18 +3187,15 @@ static inline void ahash_unmap(struct de
 
 static inline void ahash_unmap_ctx(struct device *dev,
 				   struct ahash_edesc *edesc,
-				   struct ahash_request *req, int dst_len,
-				   u32 flag)
+				   struct ahash_request *req, u32 flag)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
 	if (state->ctx_dma) {
-		dma_unmap_single(dev, state->ctx_dma, ctx->ctx_len, flag);
+		dma_unmap_single(dev, state->ctx_dma, state->ctx_dma_len, flag);
 		state->ctx_dma = 0;
 	}
-	ahash_unmap(dev, edesc, req, dst_len);
+	ahash_unmap(dev, edesc, req);
 }
 
 static void ahash_done(void *cbk_ctx, u32 status)
@@ -3219,16 +3216,13 @@ static void ahash_done(void *cbk_ctx, u3
 		ecode = -EIO;
 	}
 
-	ahash_unmap(ctx->dev, edesc, req, digestsize);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
+	memcpy(req->result, state->caam_ctx, digestsize);
 	qi_cache_free(edesc);
 
 	print_hex_dump_debug("ctx@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
-	if (req->result)
-		print_hex_dump_debug("result@" __stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, req->result,
-				     digestsize, 1);
 
 	req->base.complete(&req->base, ecode);
 }
@@ -3250,7 +3244,7 @@ static void ahash_done_bi(void *cbk_ctx,
 		ecode = -EIO;
 	}
 
-	ahash_unmap_ctx(ctx->dev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
 	switch_buf(state);
 	qi_cache_free(edesc);
 
@@ -3283,16 +3277,13 @@ static void ahash_done_ctx_src(void *cbk
 		ecode = -EIO;
 	}
 
-	ahash_unmap_ctx(ctx->dev, edesc, req, digestsize, DMA_TO_DEVICE);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
+	memcpy(req->result, state->caam_ctx, digestsize);
 	qi_cache_free(edesc);
 
 	print_hex_dump_debug("ctx@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
-	if (req->result)
-		print_hex_dump_debug("result@" __stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, req->result,
-				     digestsize, 1);
 
 	req->base.complete(&req->base, ecode);
 }
@@ -3314,7 +3305,7 @@ static void ahash_done_ctx_dst(void *cbk
 		ecode = -EIO;
 	}
 
-	ahash_unmap_ctx(ctx->dev, edesc, req, ctx->ctx_len, DMA_FROM_DEVICE);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
 	switch_buf(state);
 	qi_cache_free(edesc);
 
@@ -3452,7 +3443,7 @@ static int ahash_update_ctx(struct ahash
 
 	return ret;
 unmap_ctx:
-	ahash_unmap_ctx(ctx->dev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -3484,7 +3475,7 @@ static int ahash_final_ctx(struct ahash_
 	sg_table = &edesc->sgt[0];
 
 	ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
-			       DMA_TO_DEVICE);
+			       DMA_BIDIRECTIONAL);
 	if (ret)
 		goto unmap_ctx;
 
@@ -3503,22 +3494,13 @@ static int ahash_final_ctx(struct ahash_
 	}
 	edesc->qm_sg_bytes = qm_sg_bytes;
 
-	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
-					DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, edesc->dst_dma)) {
-		dev_err(ctx->dev, "unable to map dst\n");
-		edesc->dst_dma = 0;
-		ret = -ENOMEM;
-		goto unmap_ctx;
-	}
-
 	memset(&req_ctx->fd_flt, 0, sizeof(req_ctx->fd_flt));
 	dpaa2_fl_set_final(in_fle, true);
 	dpaa2_fl_set_format(in_fle, dpaa2_fl_sg);
 	dpaa2_fl_set_addr(in_fle, edesc->qm_sg_dma);
 	dpaa2_fl_set_len(in_fle, ctx->ctx_len + buflen);
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
+	dpaa2_fl_set_addr(out_fle, state->ctx_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	req_ctx->flc = &ctx->flc[FINALIZE];
@@ -3533,7 +3515,7 @@ static int ahash_final_ctx(struct ahash_
 		return ret;
 
 unmap_ctx:
-	ahash_unmap_ctx(ctx->dev, edesc, req, digestsize, DMA_FROM_DEVICE);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -3586,7 +3568,7 @@ static int ahash_finup_ctx(struct ahash_
 	sg_table = &edesc->sgt[0];
 
 	ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
-			       DMA_TO_DEVICE);
+			       DMA_BIDIRECTIONAL);
 	if (ret)
 		goto unmap_ctx;
 
@@ -3605,22 +3587,13 @@ static int ahash_finup_ctx(struct ahash_
 	}
 	edesc->qm_sg_bytes = qm_sg_bytes;
 
-	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
-					DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, edesc->dst_dma)) {
-		dev_err(ctx->dev, "unable to map dst\n");
-		edesc->dst_dma = 0;
-		ret = -ENOMEM;
-		goto unmap_ctx;
-	}
-
 	memset(&req_ctx->fd_flt, 0, sizeof(req_ctx->fd_flt));
 	dpaa2_fl_set_final(in_fle, true);
 	dpaa2_fl_set_format(in_fle, dpaa2_fl_sg);
 	dpaa2_fl_set_addr(in_fle, edesc->qm_sg_dma);
 	dpaa2_fl_set_len(in_fle, ctx->ctx_len + buflen + req->nbytes);
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
+	dpaa2_fl_set_addr(out_fle, state->ctx_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	req_ctx->flc = &ctx->flc[FINALIZE];
@@ -3635,7 +3608,7 @@ static int ahash_finup_ctx(struct ahash_
 		return ret;
 
 unmap_ctx:
-	ahash_unmap_ctx(ctx->dev, edesc, req, digestsize, DMA_FROM_DEVICE);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -3704,18 +3677,19 @@ static int ahash_digest(struct ahash_req
 		dpaa2_fl_set_addr(in_fle, sg_dma_address(req->src));
 	}
 
-	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
+	state->ctx_dma_len = digestsize;
+	state->ctx_dma = dma_map_single(ctx->dev, state->caam_ctx, digestsize,
 					DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, edesc->dst_dma)) {
-		dev_err(ctx->dev, "unable to map dst\n");
-		edesc->dst_dma = 0;
+	if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
+		dev_err(ctx->dev, "unable to map ctx\n");
+		state->ctx_dma = 0;
 		goto unmap;
 	}
 
 	dpaa2_fl_set_final(in_fle, true);
 	dpaa2_fl_set_len(in_fle, req->nbytes);
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
+	dpaa2_fl_set_addr(out_fle, state->ctx_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	req_ctx->flc = &ctx->flc[DIGEST];
@@ -3729,7 +3703,7 @@ static int ahash_digest(struct ahash_req
 		return ret;
 
 unmap:
-	ahash_unmap(ctx->dev, edesc, req, digestsize);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -3764,11 +3738,12 @@ static int ahash_final_no_ctx(struct aha
 		}
 	}
 
-	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
+	state->ctx_dma_len = digestsize;
+	state->ctx_dma = dma_map_single(ctx->dev, state->caam_ctx, digestsize,
 					DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, edesc->dst_dma)) {
-		dev_err(ctx->dev, "unable to map dst\n");
-		edesc->dst_dma = 0;
+	if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
+		dev_err(ctx->dev, "unable to map ctx\n");
+		state->ctx_dma = 0;
 		goto unmap;
 	}
 
@@ -3786,7 +3761,7 @@ static int ahash_final_no_ctx(struct aha
 		dpaa2_fl_set_len(in_fle, buflen);
 	}
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
+	dpaa2_fl_set_addr(out_fle, state->ctx_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	req_ctx->flc = &ctx->flc[DIGEST];
@@ -3801,7 +3776,7 @@ static int ahash_final_no_ctx(struct aha
 		return ret;
 
 unmap:
-	ahash_unmap(ctx->dev, edesc, req, digestsize);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -3881,6 +3856,7 @@ static int ahash_update_no_ctx(struct ah
 		}
 		edesc->qm_sg_bytes = qm_sg_bytes;
 
+		state->ctx_dma_len = ctx->ctx_len;
 		state->ctx_dma = dma_map_single(ctx->dev, state->caam_ctx,
 						ctx->ctx_len, DMA_FROM_DEVICE);
 		if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
@@ -3929,7 +3905,7 @@ static int ahash_update_no_ctx(struct ah
 
 	return ret;
 unmap_ctx:
-	ahash_unmap_ctx(ctx->dev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_TO_DEVICE);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -3994,11 +3970,12 @@ static int ahash_finup_no_ctx(struct aha
 	}
 	edesc->qm_sg_bytes = qm_sg_bytes;
 
-	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
+	state->ctx_dma_len = digestsize;
+	state->ctx_dma = dma_map_single(ctx->dev, state->caam_ctx, digestsize,
 					DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, edesc->dst_dma)) {
-		dev_err(ctx->dev, "unable to map dst\n");
-		edesc->dst_dma = 0;
+	if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
+		dev_err(ctx->dev, "unable to map ctx\n");
+		state->ctx_dma = 0;
 		ret = -ENOMEM;
 		goto unmap;
 	}
@@ -4009,7 +3986,7 @@ static int ahash_finup_no_ctx(struct aha
 	dpaa2_fl_set_addr(in_fle, edesc->qm_sg_dma);
 	dpaa2_fl_set_len(in_fle, buflen + req->nbytes);
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
+	dpaa2_fl_set_addr(out_fle, state->ctx_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	req_ctx->flc = &ctx->flc[DIGEST];
@@ -4024,7 +4001,7 @@ static int ahash_finup_no_ctx(struct aha
 
 	return ret;
 unmap:
-	ahash_unmap(ctx->dev, edesc, req, digestsize);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
 	qi_cache_free(edesc);
 	return -ENOMEM;
 }
@@ -4111,6 +4088,7 @@ static int ahash_update_first(struct aha
 			scatterwalk_map_and_copy(next_buf, req->src, to_hash,
 						 *next_buflen, 0);
 
+		state->ctx_dma_len = ctx->ctx_len;
 		state->ctx_dma = dma_map_single(ctx->dev, state->caam_ctx,
 						ctx->ctx_len, DMA_FROM_DEVICE);
 		if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
@@ -4154,7 +4132,7 @@ static int ahash_update_first(struct aha
 
 	return ret;
 unmap_ctx:
-	ahash_unmap_ctx(ctx->dev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
+	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_TO_DEVICE);
 	qi_cache_free(edesc);
 	return ret;
 }
@@ -4173,6 +4151,7 @@ static int ahash_init(struct ahash_reque
 	state->final = ahash_final_no_ctx;
 
 	state->ctx_dma = 0;
+	state->ctx_dma_len = 0;
 	state->current_buf = 0;
 	state->buf_dma = 0;
 	state->buflen_0 = 0;
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -162,14 +162,12 @@ struct skcipher_edesc {
 
 /*
  * ahash_edesc - s/w-extended ahash descriptor
- * @dst_dma: I/O virtual address of req->result
  * @qm_sg_dma: I/O virtual address of h/w link table
  * @src_nents: number of segments in input scatterlist
  * @qm_sg_bytes: length of dma mapped qm_sg space
  * @sgt: pointer to h/w link table
  */
 struct ahash_edesc {
-	dma_addr_t dst_dma;
 	dma_addr_t qm_sg_dma;
 	int src_nents;
 	int qm_sg_bytes;


