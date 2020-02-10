Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242A21579C5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgBJMhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbgBJMhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:53 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63442080C;
        Mon, 10 Feb 2020 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338272;
        bh=iZO5aaR3qMpMM/lKFQk1EjyD5n4QLLKHRDsYb5baK+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjB1Sh8ewwHmLC6gyl04eBaLY73ktzy1S3Pq2ArLG6kfkw3CS7fQ+nFyFj2Ic6OEk
         fQBo8boDRCmQkZmgAF7nAStAnqO+kW5lU+nK9nmG1MmFhDIxk6oGGhCBjS5DLV0KLy
         A1fsCJ8fUxNx2yRPyLk1lGCTt+2/jNRsoy9NFQww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 156/309] crypto: hisilicon - Use the offset fields in sqe to avoid need to split scatterlists
Date:   Mon, 10 Feb 2020 04:31:52 -0800
Message-Id: <20200210122421.215119749@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 484a897ffa3005f16cd9a31efd747bcf8155826f upstream.

We can configure sgl offset fields in ZIP sqe to let ZIP engine read/write
sgl data with skipped data. Hence no need to splite the sgl.

Fixes: 62c455ca853e (crypto: hisilicon - add HiSilicon ZIP accelerator support)
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/hisilicon/Kconfig          |    1 
 drivers/crypto/hisilicon/zip/zip.h        |    4 +
 drivers/crypto/hisilicon/zip/zip_crypto.c |   92 +++++++-----------------------
 3 files changed, 27 insertions(+), 70 deletions(-)

--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -35,6 +35,5 @@ config CRYPTO_DEV_HISI_ZIP
 	depends on ARM64 && PCI && PCI_MSI
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_HISI_SGL
-	select SG_SPLIT
 	help
 	  Support for HiSilicon ZIP Driver
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -12,6 +12,10 @@
 
 /* hisi_zip_sqe dw3 */
 #define HZIP_BD_STATUS_M			GENMASK(7, 0)
+/* hisi_zip_sqe dw7 */
+#define HZIP_IN_SGE_DATA_OFFSET_M		GENMASK(23, 0)
+/* hisi_zip_sqe dw8 */
+#define HZIP_OUT_SGE_DATA_OFFSET_M		GENMASK(23, 0)
 /* hisi_zip_sqe dw9 */
 #define HZIP_REQ_TYPE_M				GENMASK(7, 0)
 #define HZIP_ALG_TYPE_ZLIB			0x02
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -45,10 +45,8 @@ enum hisi_zip_alg_type {
 
 struct hisi_zip_req {
 	struct acomp_req *req;
-	struct scatterlist *src;
-	struct scatterlist *dst;
-	size_t slen;
-	size_t dlen;
+	int sskip;
+	int dskip;
 	struct hisi_acc_hw_sgl *hw_src;
 	struct hisi_acc_hw_sgl *hw_dst;
 	dma_addr_t dma_src;
@@ -94,13 +92,15 @@ static void hisi_zip_config_tag(struct h
 
 static void hisi_zip_fill_sqe(struct hisi_zip_sqe *sqe, u8 req_type,
 			      dma_addr_t s_addr, dma_addr_t d_addr, u32 slen,
-			      u32 dlen)
+			      u32 dlen, int sskip, int dskip)
 {
 	memset(sqe, 0, sizeof(struct hisi_zip_sqe));
 
-	sqe->input_data_length = slen;
+	sqe->input_data_length = slen - sskip;
+	sqe->dw7 = FIELD_PREP(HZIP_IN_SGE_DATA_OFFSET_M, sskip);
+	sqe->dw8 = FIELD_PREP(HZIP_OUT_SGE_DATA_OFFSET_M, dskip);
 	sqe->dw9 = FIELD_PREP(HZIP_REQ_TYPE_M, req_type);
-	sqe->dest_avail_out = dlen;
+	sqe->dest_avail_out = dlen - dskip;
 	sqe->source_addr_l = lower_32_bits(s_addr);
 	sqe->source_addr_h = upper_32_bits(s_addr);
 	sqe->dest_addr_l = lower_32_bits(d_addr);
@@ -301,11 +301,6 @@ static void hisi_zip_remove_req(struct h
 {
 	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 
-	if (qp_ctx->qp->alg_type == HZIP_ALG_TYPE_COMP)
-		kfree(req->dst);
-	else
-		kfree(req->src);
-
 	write_lock(&req_q->req_lock);
 	clear_bit(req->req_id, req_q->req_bitmap);
 	memset(req, 0, sizeof(struct hisi_zip_req));
@@ -333,8 +328,8 @@ static void hisi_zip_acomp_cb(struct his
 	}
 	dlen = sqe->produced;
 
-	hisi_acc_sg_buf_unmap(dev, req->src, req->hw_src);
-	hisi_acc_sg_buf_unmap(dev, req->dst, req->hw_dst);
+	hisi_acc_sg_buf_unmap(dev, acomp_req->src, req->hw_src);
+	hisi_acc_sg_buf_unmap(dev, acomp_req->dst, req->hw_dst);
 
 	head_size = (qp->alg_type == 0) ? TO_HEAD_SIZE(qp->req_type) : 0;
 	acomp_req->dlen = dlen + head_size;
@@ -428,20 +423,6 @@ static size_t get_comp_head_size(struct
 	}
 }
 
-static int get_sg_skip_bytes(struct scatterlist *sgl, size_t bytes,
-			     size_t remains, struct scatterlist **out)
-{
-#define SPLIT_NUM 2
-	size_t split_sizes[SPLIT_NUM];
-	int out_mapped_nents[SPLIT_NUM];
-
-	split_sizes[0] = bytes;
-	split_sizes[1] = remains;
-
-	return sg_split(sgl, 0, 0, SPLIT_NUM, split_sizes, out,
-			out_mapped_nents, GFP_KERNEL);
-}
-
 static struct hisi_zip_req *hisi_zip_create_req(struct acomp_req *req,
 						struct hisi_zip_qp_ctx *qp_ctx,
 						size_t head_size, bool is_comp)
@@ -449,31 +430,7 @@ static struct hisi_zip_req *hisi_zip_cre
 	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct hisi_zip_req *q = req_q->q;
 	struct hisi_zip_req *req_cache;
-	struct scatterlist *out[2];
-	struct scatterlist *sgl;
-	size_t len;
-	int ret, req_id;
-
-	/*
-	 * remove/add zlib/gzip head, as hardware operations do not include
-	 * comp head. so split req->src to get sgl without heads in acomp, or
-	 * add comp head to req->dst ahead of that hardware output compressed
-	 * data in sgl splited from req->dst without comp head.
-	 */
-	if (is_comp) {
-		sgl = req->dst;
-		len = req->dlen - head_size;
-	} else {
-		sgl = req->src;
-		len = req->slen - head_size;
-	}
-
-	ret = get_sg_skip_bytes(sgl, head_size, len, out);
-	if (ret)
-		return ERR_PTR(ret);
-
-	/* sgl for comp head is useless, so free it now */
-	kfree(out[0]);
+	int req_id;
 
 	write_lock(&req_q->req_lock);
 
@@ -481,7 +438,6 @@ static struct hisi_zip_req *hisi_zip_cre
 	if (req_id >= req_q->size) {
 		write_unlock(&req_q->req_lock);
 		dev_dbg(&qp_ctx->qp->qm->pdev->dev, "req cache is full!\n");
-		kfree(out[1]);
 		return ERR_PTR(-EBUSY);
 	}
 	set_bit(req_id, req_q->req_bitmap);
@@ -489,16 +445,13 @@ static struct hisi_zip_req *hisi_zip_cre
 	req_cache = q + req_id;
 	req_cache->req_id = req_id;
 	req_cache->req = req;
+
 	if (is_comp) {
-		req_cache->src = req->src;
-		req_cache->dst = out[1];
-		req_cache->slen = req->slen;
-		req_cache->dlen = req->dlen - head_size;
+		req_cache->sskip = 0;
+		req_cache->dskip = head_size;
 	} else {
-		req_cache->src = out[1];
-		req_cache->dst = req->dst;
-		req_cache->slen = req->slen - head_size;
-		req_cache->dlen = req->dlen;
+		req_cache->sskip = head_size;
+		req_cache->dskip = 0;
 	}
 
 	write_unlock(&req_q->req_lock);
@@ -510,6 +463,7 @@ static int hisi_zip_do_work(struct hisi_
 			    struct hisi_zip_qp_ctx *qp_ctx)
 {
 	struct hisi_zip_sqe *zip_sqe = &qp_ctx->zip_sqe;
+	struct acomp_req *a_req = req->req;
 	struct hisi_qp *qp = qp_ctx->qp;
 	struct device *dev = &qp->qm->pdev->dev;
 	struct hisi_acc_sgl_pool *pool = &qp_ctx->sgl_pool;
@@ -517,16 +471,16 @@ static int hisi_zip_do_work(struct hisi_
 	dma_addr_t output;
 	int ret;
 
-	if (!req->src || !req->slen || !req->dst || !req->dlen)
+	if (!a_req->src || !a_req->slen || !a_req->dst || !a_req->dlen)
 		return -EINVAL;
 
-	req->hw_src = hisi_acc_sg_buf_map_to_hw_sgl(dev, req->src, pool,
+	req->hw_src = hisi_acc_sg_buf_map_to_hw_sgl(dev, a_req->src, pool,
 						    req->req_id << 1, &input);
 	if (IS_ERR(req->hw_src))
 		return PTR_ERR(req->hw_src);
 	req->dma_src = input;
 
-	req->hw_dst = hisi_acc_sg_buf_map_to_hw_sgl(dev, req->dst, pool,
+	req->hw_dst = hisi_acc_sg_buf_map_to_hw_sgl(dev, a_req->dst, pool,
 						    (req->req_id << 1) + 1,
 						    &output);
 	if (IS_ERR(req->hw_dst)) {
@@ -535,8 +489,8 @@ static int hisi_zip_do_work(struct hisi_
 	}
 	req->dma_dst = output;
 
-	hisi_zip_fill_sqe(zip_sqe, qp->req_type, input, output, req->slen,
-			  req->dlen);
+	hisi_zip_fill_sqe(zip_sqe, qp->req_type, input, output, a_req->slen,
+			  a_req->dlen, req->sskip, req->dskip);
 	hisi_zip_config_buf_type(zip_sqe, HZIP_SGL);
 	hisi_zip_config_tag(zip_sqe, req->req_id);
 
@@ -548,9 +502,9 @@ static int hisi_zip_do_work(struct hisi_
 	return -EINPROGRESS;
 
 err_unmap_output:
-	hisi_acc_sg_buf_unmap(dev, req->dst, req->hw_dst);
+	hisi_acc_sg_buf_unmap(dev, a_req->dst, req->hw_dst);
 err_unmap_input:
-	hisi_acc_sg_buf_unmap(dev, req->src, req->hw_src);
+	hisi_acc_sg_buf_unmap(dev, a_req->src, req->hw_src);
 	return ret;
 }
 


