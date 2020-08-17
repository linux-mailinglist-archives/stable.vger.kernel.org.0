Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C49246A87
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgHQPiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgHQPhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16CB222C9F;
        Mon, 17 Aug 2020 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678659;
        bh=S7j7YsTvV1ENChbM9ZZxsKF51FQ4HIe8f8rjCrA/2J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PE0T1+76CbCABtsq6URX7fMdKQjvUl6iXHNjb1TCCdtnxXA2WfOYxgBVV8RNYZxdH
         o6ZJxhNN7Y1jL/myq4qIHbqTJGJAFkTfTt3R1HF+okFfMXiGPbZ8L01eTB2RDqxdCn
         fv1E2D3UBGqZHT+9sc3+k1iI0ukht0ECdJCGFT8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.8 410/464] crypto: hisilicon - dont sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
Date:   Mon, 17 Aug 2020 17:16:03 +0200
Message-Id: <20200817143853.419190653@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5ead051780404b5cb22147170acadd1994dc3236 upstream.

There is this call chain:
sec_alg_skcipher_encrypt -> sec_alg_skcipher_crypto ->
sec_alg_alloc_and_calc_split_sizes -> kcalloc
where we call sleeping allocator function even if CRYPTO_TFM_REQ_MAY_SLEEP
was not specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.19+
Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/hisilicon/sec/sec_algs.c |   34 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -175,7 +175,8 @@ static int sec_alloc_and_fill_hw_sgl(str
 				     dma_addr_t *psec_sgl,
 				     struct scatterlist *sgl,
 				     int count,
-				     struct sec_dev_info *info)
+				     struct sec_dev_info *info,
+				     gfp_t gfp)
 {
 	struct sec_hw_sgl *sgl_current = NULL;
 	struct sec_hw_sgl *sgl_next;
@@ -190,7 +191,7 @@ static int sec_alloc_and_fill_hw_sgl(str
 		sge_index = i % SEC_MAX_SGE_NUM;
 		if (sge_index == 0) {
 			sgl_next = dma_pool_zalloc(info->hw_sgl_pool,
-						   GFP_KERNEL, &sgl_next_dma);
+						   gfp, &sgl_next_dma);
 			if (!sgl_next) {
 				ret = -ENOMEM;
 				goto err_free_hw_sgls;
@@ -545,14 +546,14 @@ void sec_alg_callback(struct sec_bd_info
 }
 
 static int sec_alg_alloc_and_calc_split_sizes(int length, size_t **split_sizes,
-					      int *steps)
+					      int *steps, gfp_t gfp)
 {
 	size_t *sizes;
 	int i;
 
 	/* Split into suitable sized blocks */
 	*steps = roundup(length, SEC_REQ_LIMIT) / SEC_REQ_LIMIT;
-	sizes = kcalloc(*steps, sizeof(*sizes), GFP_KERNEL);
+	sizes = kcalloc(*steps, sizeof(*sizes), gfp);
 	if (!sizes)
 		return -ENOMEM;
 
@@ -568,7 +569,7 @@ static int sec_map_and_split_sg(struct s
 				int steps, struct scatterlist ***splits,
 				int **splits_nents,
 				int sgl_len_in,
-				struct device *dev)
+				struct device *dev, gfp_t gfp)
 {
 	int ret, count;
 
@@ -576,12 +577,12 @@ static int sec_map_and_split_sg(struct s
 	if (!count)
 		return -EINVAL;
 
-	*splits = kcalloc(steps, sizeof(struct scatterlist *), GFP_KERNEL);
+	*splits = kcalloc(steps, sizeof(struct scatterlist *), gfp);
 	if (!*splits) {
 		ret = -ENOMEM;
 		goto err_unmap_sg;
 	}
-	*splits_nents = kcalloc(steps, sizeof(int), GFP_KERNEL);
+	*splits_nents = kcalloc(steps, sizeof(int), gfp);
 	if (!*splits_nents) {
 		ret = -ENOMEM;
 		goto err_free_splits;
@@ -589,7 +590,7 @@ static int sec_map_and_split_sg(struct s
 
 	/* output the scatter list before and after this */
 	ret = sg_split(sgl, count, 0, steps, split_sizes,
-		       *splits, *splits_nents, GFP_KERNEL);
+		       *splits, *splits_nents, gfp);
 	if (ret) {
 		ret = -ENOMEM;
 		goto err_free_splits_nents;
@@ -630,13 +631,13 @@ static struct sec_request_el
 			   int el_size, bool different_dest,
 			   struct scatterlist *sgl_in, int n_ents_in,
 			   struct scatterlist *sgl_out, int n_ents_out,
-			   struct sec_dev_info *info)
+			   struct sec_dev_info *info, gfp_t gfp)
 {
 	struct sec_request_el *el;
 	struct sec_bd_info *req;
 	int ret;
 
-	el = kzalloc(sizeof(*el), GFP_KERNEL);
+	el = kzalloc(sizeof(*el), gfp);
 	if (!el)
 		return ERR_PTR(-ENOMEM);
 	el->el_length = el_size;
@@ -668,7 +669,7 @@ static struct sec_request_el
 	el->sgl_in = sgl_in;
 
 	ret = sec_alloc_and_fill_hw_sgl(&el->in, &el->dma_in, el->sgl_in,
-					n_ents_in, info);
+					n_ents_in, info, gfp);
 	if (ret)
 		goto err_free_el;
 
@@ -679,7 +680,7 @@ static struct sec_request_el
 		el->sgl_out = sgl_out;
 		ret = sec_alloc_and_fill_hw_sgl(&el->out, &el->dma_out,
 						el->sgl_out,
-						n_ents_out, info);
+						n_ents_out, info, gfp);
 		if (ret)
 			goto err_free_hw_sgl_in;
 
@@ -720,6 +721,7 @@ static int sec_alg_skcipher_crypto(struc
 	int *splits_out_nents = NULL;
 	struct sec_request_el *el, *temp;
 	bool split = skreq->src != skreq->dst;
+	gfp_t gfp = skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
 	mutex_init(&sec_req->lock);
 	sec_req->req_base = &skreq->base;
@@ -728,13 +730,13 @@ static int sec_alg_skcipher_crypto(struc
 	sec_req->len_in = sg_nents(skreq->src);
 
 	ret = sec_alg_alloc_and_calc_split_sizes(skreq->cryptlen, &split_sizes,
-						 &steps);
+						 &steps, gfp);
 	if (ret)
 		return ret;
 	sec_req->num_elements = steps;
 	ret = sec_map_and_split_sg(skreq->src, split_sizes, steps, &splits_in,
 				   &splits_in_nents, sec_req->len_in,
-				   info->dev);
+				   info->dev, gfp);
 	if (ret)
 		goto err_free_split_sizes;
 
@@ -742,7 +744,7 @@ static int sec_alg_skcipher_crypto(struc
 		sec_req->len_out = sg_nents(skreq->dst);
 		ret = sec_map_and_split_sg(skreq->dst, split_sizes, steps,
 					   &splits_out, &splits_out_nents,
-					   sec_req->len_out, info->dev);
+					   sec_req->len_out, info->dev, gfp);
 		if (ret)
 			goto err_unmap_in_sg;
 	}
@@ -775,7 +777,7 @@ static int sec_alg_skcipher_crypto(struc
 					       splits_in[i], splits_in_nents[i],
 					       split ? splits_out[i] : NULL,
 					       split ? splits_out_nents[i] : 0,
-					       info);
+					       info, gfp);
 		if (IS_ERR(el)) {
 			ret = PTR_ERR(el);
 			goto err_free_elements;


