Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673C651DABB
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442292AbiEFOnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442309AbiEFOnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:43:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D66AA57;
        Fri,  6 May 2022 07:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847958; x=1683383958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mujSkUPHrLebgIK/zlCc2BUoPC4hMv/CGqODJfcr1Hg=;
  b=A8hwHZUpJ6guCPuqTVHEqwzXM9u+4G7U7Xbo/+BE0r12Xhx/5kbixa9I
   13QxAqj4A0zHfZIQWyYtDg26/rmZj2pOX53fnwSfCM+eiFI0SNtAUOPSF
   PMlax7+sTNjNEYqoPUBfx3BStZ0smiJwHW3rGgwsPSeKyDg/F5tgAn7HA
   aez60NG/ZbNsQdhRguPUPlgGYMw+aO23URXC63xz+sorV+k08nvoYIecf
   ddVkJXIMIFO5fvA0aBlZV4I467DPU2tL6cI2QQsp8QmRbzw2OrJ8/ZOFq
   BGoIkzQyUKLQnMOZ+kjFDO0AY4t9IMyi6r9XybFuJFwjLLxxA7EHZSZTJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387479"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387479"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914836"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:16 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 05/11] crypto: qat - remove dma_free_coherent() for RSA
Date:   Fri,  6 May 2022 15:38:57 +0100
Message-Id: <20220506143903.31776-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
References: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP"), if
the algorithms are enabled, the driver crashes with a BUG_ON while
executing vunmap() in the context of a tasklet. This is due to the fact
that the function dma_free_coherent() cannot be called in an interrupt
context (see Documentation/core-api/dma-api-howto.rst).

The functions qat_rsa_enc() and qat_rsa_dec() allocate memory with
dma_alloc_coherent() if the source or the destination buffers are made
of multiple flat buffers or of a size that is not compatible with the
hardware.
This memory is then freed with dma_free_coherent() in the context of a
tasklet invoked to handle the response for the corresponding request.

Replace allocations with dma_alloc_coherent() in the functions
qat_rsa_enc() and qat_rsa_dec() with kmalloc() + dma_map_single().

Cc: stable@vger.kernel.org
Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 137 ++++++++----------
 1 file changed, 60 insertions(+), 77 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 9be972430f11..bba4b4d99e94 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -526,25 +526,22 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
-	if (req->src_align)
-		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->src_align,
-				  req->in.rsa.enc.m);
-	else
-		dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
-				 DMA_TO_DEVICE);
+	kfree_sensitive(req->src_align);
+
+	dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
+			 DMA_TO_DEVICE);
 
 	areq->dst_len = req->ctx.rsa->key_sz;
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
 
-		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->dst_align,
-				  req->out.rsa.enc.c);
-	} else {
-		dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
-				 DMA_FROM_DEVICE);
+		kfree_sensitive(req->dst_align);
 	}
 
+	dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
+			 DMA_FROM_DEVICE);
+
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
@@ -661,6 +658,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	u8 *vaddr;
 	int ret;
 
 	if (unlikely(!ctx->n || !ctx->e))
@@ -698,40 +696,39 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	 */
 	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
 		qat_req->src_align = NULL;
-		qat_req->in.rsa.enc.m = dma_map_single(dev, sg_virt(req->src),
-						   req->src_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.enc.m)))
-			return ret;
-
+		vaddr = sg_virt(req->src);
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
-		qat_req->src_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->in.rsa.enc.m,
-							GFP_KERNEL);
+		qat_req->src_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
 		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
 					 0, req->src_len, 0);
+		vaddr = qat_req->src_align;
 	}
-	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
-		qat_req->dst_align = NULL;
-		qat_req->out.rsa.enc.c = dma_map_single(dev, sg_virt(req->dst),
-							req->dst_len,
-							DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.enc.c)))
-			goto unmap_src;
+	qat_req->in.rsa.enc.m = dma_map_single(dev, vaddr, ctx->key_sz,
+					       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.enc.m)))
+		goto unmap_src;
 
+	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->out.rsa.enc.c,
-							GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
-
+		vaddr = qat_req->dst_align;
 	}
+
+	qat_req->out.rsa.enc.c = dma_map_single(dev, vaddr, ctx->key_sz,
+						DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.enc.c)))
+		goto unmap_dst;
+
 	qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
@@ -769,21 +766,15 @@ static int qat_rsa_enc(struct akcipher_request *req)
 				 sizeof(struct qat_rsa_input_params),
 				 DMA_TO_DEVICE);
 unmap_dst:
-	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
-				  qat_req->out.rsa.enc.c);
-	else
-		if (!dma_mapping_error(dev, qat_req->out.rsa.enc.c))
-			dma_unmap_single(dev, qat_req->out.rsa.enc.c,
-					 ctx->key_sz, DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.rsa.enc.c))
+		dma_unmap_single(dev, qat_req->out.rsa.enc.c,
+				 ctx->key_sz, DMA_FROM_DEVICE);
+	kfree_sensitive(qat_req->dst_align);
 unmap_src:
-	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.rsa.enc.m);
-	else
-		if (!dma_mapping_error(dev, qat_req->in.rsa.enc.m))
-			dma_unmap_single(dev, qat_req->in.rsa.enc.m,
-					 ctx->key_sz, DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->in.rsa.enc.m))
+		dma_unmap_single(dev, qat_req->in.rsa.enc.m, ctx->key_sz,
+				 DMA_TO_DEVICE);
+	kfree_sensitive(qat_req->src_align);
 	return ret;
 }
 
@@ -796,6 +787,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	u8 *vaddr;
 	int ret;
 
 	if (unlikely(!ctx->n || !ctx->d))
@@ -843,40 +835,37 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	 */
 	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
 		qat_req->src_align = NULL;
-		qat_req->in.rsa.dec.c = dma_map_single(dev, sg_virt(req->src),
-						   req->dst_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.dec.c)))
-			return ret;
-
+		vaddr = sg_virt(req->src);
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
-		qat_req->src_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->in.rsa.dec.c,
-							GFP_KERNEL);
+		qat_req->src_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
 		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
 					 0, req->src_len, 0);
+		vaddr = qat_req->src_align;
 	}
-	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
-		qat_req->dst_align = NULL;
-		qat_req->out.rsa.dec.m = dma_map_single(dev, sg_virt(req->dst),
-						    req->dst_len,
-						    DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.dec.m)))
-			goto unmap_src;
+	qat_req->in.rsa.dec.c = dma_map_single(dev, vaddr, ctx->key_sz,
+					       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.dec.c)))
+		goto unmap_src;
 
+	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->out.rsa.dec.m,
-							GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
-
+		vaddr = qat_req->dst_align;
 	}
+	qat_req->out.rsa.dec.m = dma_map_single(dev, vaddr, ctx->key_sz,
+						DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.dec.m)))
+		goto unmap_dst;
 
 	if (ctx->crt_mode)
 		qat_req->in.rsa.in_tab[6] = 0;
@@ -922,21 +911,15 @@ static int qat_rsa_dec(struct akcipher_request *req)
 				 sizeof(struct qat_rsa_input_params),
 				 DMA_TO_DEVICE);
 unmap_dst:
-	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
-				  qat_req->out.rsa.dec.m);
-	else
-		if (!dma_mapping_error(dev, qat_req->out.rsa.dec.m))
-			dma_unmap_single(dev, qat_req->out.rsa.dec.m,
-					 ctx->key_sz, DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.rsa.dec.m))
+		dma_unmap_single(dev, qat_req->out.rsa.dec.m,
+				 ctx->key_sz, DMA_FROM_DEVICE);
+	kfree_sensitive(qat_req->dst_align);
 unmap_src:
-	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.rsa.dec.c);
-	else
-		if (!dma_mapping_error(dev, qat_req->in.rsa.dec.c))
-			dma_unmap_single(dev, qat_req->in.rsa.dec.c,
-					 ctx->key_sz, DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->in.rsa.dec.c))
+		dma_unmap_single(dev, qat_req->in.rsa.dec.c, ctx->key_sz,
+				 DMA_TO_DEVICE);
+	kfree_sensitive(qat_req->src_align);
 	return ret;
 }
 
-- 
2.35.1

