Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFE653EBCB
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbiFFLmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbiFFLmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D873C389E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7335B60F87
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D49C3411D;
        Mon,  6 Jun 2022 11:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654515732;
        bh=R0bShPwYH6NkHW/Uezis6Q1tXhN4emPHqGgBuLnVb6c=;
        h=Subject:To:Cc:From:Date:From;
        b=xcS1td+ldqJY2lJaDNSc4NxvPJnMeW5MPSaXxjP4+D8v9Wj1StBDFvnWqeK0Pb/n8
         A+AlYoFiwmoKNi7qA+szmRbiT+Q8LopyNF4jh4h9PMLcAzuZRZJxE9xVXb73Ralu8h
         uh9kd+FyIJDe++gJOng2EbgVlA05TB3rOHf+0nP8=
Subject: WTF: patch "[PATCH] crypto: qat - remove dma_free_coherent() for DH" was seriously submitted to be applied to the 5.18-stable tree?
To:     giovanni.cabiddu@intel.com, adam.guerin@intel.com,
        herbert@gondor.apana.org.au, wojciech.ziemba@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:42:06 +0200
Message-ID: <165451572611825@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 029aa4624a7fe35233bdd3d1354dc7be260380bf Mon Sep 17 00:00:00 2001
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Mon, 9 May 2022 14:34:13 +0100
Subject: [PATCH] crypto: qat - remove dma_free_coherent() for DH

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index b31372bddb96..25bbd22085c3 100644
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

