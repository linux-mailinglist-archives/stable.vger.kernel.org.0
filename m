Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3ABE51DABC
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442289AbiEFOnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442315AbiEFOnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:43:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C912D6AA54;
        Fri,  6 May 2022 07:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847960; x=1683383960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r0b11JWbKiI5MwzriOTpJoV+O6qBF/+l1rq4a/j8JSE=;
  b=FZ2/JB1Pn5FDq97VpVFSvsz1/UP8uZRX+/Rb82gDIqtgN+BRXU4HH2/U
   OXetzw9/pY2lAwYQpc3tsinB6bQl9luOHOU4ljLuc6bqtaNEqWoA3mGLu
   +snbyztph0W+FEhIcK38ldPml7M84trGxFYlBYMAPCIjaaDhBSikodEPh
   CN5hLVWrFMijoX03J57g9dafZlj4QLKHPRA2DCu6I5GV0rbe4faTqpYg3
   K/q+ggvtmE2GxyR2eP1Q0O+8AGrT75uM0Txnr4d6x3bDpxP+P0TLqaNeI
   o74Ar1nEbTyu00vfQ316Mg5G+T6JIOzdmZEqnxDLyJ2KySArpn0ilInKf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387484"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387484"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914851"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:18 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 06/11] crypto: qat - remove dma_free_coherent() for DH
Date:   Fri,  6 May 2022 15:38:58 +0100
Message-Id: <20220506143903.31776-7-giovanni.cabiddu@intel.com>
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

The functions qat_dh_compute_value() allocates memory with
dma_alloc_coherent() if the source or the destination buffers are made
of multiple flat buffers or of a size that is not compatible with the
hardware.
This memory is then freed with dma_free_coherent() in the context of a
tasklet invoked to handle the response for the corresponding request.

According to Documentation/core-api/dma-api-howto.rst, the function
dma_free_coherent() cannot be called in an interrupt context.

Replace allocations with dma_alloc_coherent() in the function
qat_dh_compute_value() with kmalloc() + dma_map_single().

Cc: stable@vger.kernel.org
Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 83 ++++++++-----------
 1 file changed, 34 insertions(+), 49 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index bba4b4d99e94..d75eb77c9fb9 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -164,26 +164,21 @@ static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
 	if (areq->src) {
-		if (req->src_align)
-			dma_free_coherent(dev, req->ctx.dh->p_size,
-					  req->src_align, req->in.dh.in.b);
-		else
-			dma_unmap_single(dev, req->in.dh.in.b,
-					 req->ctx.dh->p_size, DMA_TO_DEVICE);
+		dma_unmap_single(dev, req->in.dh.in.b, req->ctx.dh->p_size,
+				 DMA_TO_DEVICE);
+		kfree_sensitive(req->src_align);
 	}
 
 	areq->dst_len = req->ctx.dh->p_size;
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
-
-		dma_free_coherent(dev, req->ctx.dh->p_size, req->dst_align,
-				  req->out.dh.r);
-	} else {
-		dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
-				 DMA_FROM_DEVICE);
+		kfree_sensitive(req->dst_align);
 	}
 
+	dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
+			 DMA_FROM_DEVICE);
+
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_dh_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
@@ -231,6 +226,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
 	int ret;
 	int n_input_params = 0;
+	u8 *vaddr;
 
 	if (unlikely(!ctx->xa))
 		return -EINVAL;
@@ -287,27 +283,24 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		 */
 		if (sg_is_last(req->src) && req->src_len == ctx->p_size) {
 			qat_req->src_align = NULL;
-			qat_req->in.dh.in.b = dma_map_single(dev,
-							     sg_virt(req->src),
-							     req->src_len,
-							     DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(dev,
-						       qat_req->in.dh.in.b)))
-				return ret;
-
+			vaddr = sg_virt(req->src);
 		} else {
 			int shift = ctx->p_size - req->src_len;
 
-			qat_req->src_align = dma_alloc_coherent(dev,
-								ctx->p_size,
-								&qat_req->in.dh.in.b,
-								GFP_KERNEL);
+			qat_req->src_align = kzalloc(ctx->p_size, GFP_KERNEL);
 			if (unlikely(!qat_req->src_align))
 				return ret;
 
 			scatterwalk_map_and_copy(qat_req->src_align + shift,
 						 req->src, 0, req->src_len, 0);
+
+			vaddr = qat_req->src_align;
 		}
+
+		qat_req->in.dh.in.b = dma_map_single(dev, vaddr, ctx->p_size,
+						     DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, qat_req->in.dh.in.b)))
+			goto unmap_src;
 	}
 	/*
 	 * dst can be of any size in valid range, but HW expects it to be the
@@ -318,20 +311,18 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	 */
 	if (sg_is_last(req->dst) && req->dst_len == ctx->p_size) {
 		qat_req->dst_align = NULL;
-		qat_req->out.dh.r = dma_map_single(dev, sg_virt(req->dst),
-						   req->dst_len,
-						   DMA_FROM_DEVICE);
-
-		if (unlikely(dma_mapping_error(dev, qat_req->out.dh.r)))
-			goto unmap_src;
-
+		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = dma_alloc_coherent(dev, ctx->p_size,
-							&qat_req->out.dh.r,
-							GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->p_size, GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
+
+		vaddr = qat_req->dst_align;
 	}
+	qat_req->out.dh.r = dma_map_single(dev, vaddr, ctx->p_size,
+					   DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->out.dh.r)))
+		goto unmap_dst;
 
 	qat_req->in.dh.in_tab[n_input_params] = 0;
 	qat_req->out.dh.out_tab[1] = 0;
@@ -371,23 +362,17 @@ static int qat_dh_compute_value(struct kpp_request *req)
 				 sizeof(struct qat_dh_input_params),
 				 DMA_TO_DEVICE);
 unmap_dst:
-	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->p_size, qat_req->dst_align,
-				  qat_req->out.dh.r);
-	else
-		if (!dma_mapping_error(dev, qat_req->out.dh.r))
-			dma_unmap_single(dev, qat_req->out.dh.r, ctx->p_size,
-					 DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.dh.r))
+		dma_unmap_single(dev, qat_req->out.dh.r, ctx->p_size,
+				 DMA_FROM_DEVICE);
+	kfree_sensitive(qat_req->dst_align);
 unmap_src:
 	if (req->src) {
-		if (qat_req->src_align)
-			dma_free_coherent(dev, ctx->p_size, qat_req->src_align,
-					  qat_req->in.dh.in.b);
-		else
-			if (!dma_mapping_error(dev, qat_req->in.dh.in.b))
-				dma_unmap_single(dev, qat_req->in.dh.in.b,
-						 ctx->p_size,
-						 DMA_TO_DEVICE);
+		if (!dma_mapping_error(dev, qat_req->in.dh.in.b))
+			dma_unmap_single(dev, qat_req->in.dh.in.b,
+					 ctx->p_size,
+					 DMA_TO_DEVICE);
+		kfree_sensitive(qat_req->src_align);
 	}
 	return ret;
 }
-- 
2.35.1

