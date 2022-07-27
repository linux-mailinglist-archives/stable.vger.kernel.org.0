Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B054C582EF7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiG0RTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241953AbiG0RTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5AE2DB;
        Wed, 27 Jul 2022 09:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89348614DE;
        Wed, 27 Jul 2022 16:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EE9C433C1;
        Wed, 27 Jul 2022 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940269;
        bh=7upjMH8v1lO5gmKMhprbMT2ertIoz1OLzCcHbMIlJ5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9wrgTcGpwHM3xK0wXXvLh07g1SZMGfLtKODCqvvPQzB4QCNiw8Fn28FXB91DpHEZ
         B7GoRlBvFYSRPFXWewA/6RYgzS8GfupSgnq4rCLiq5QLmPasflwDiVfzOQeJqvkZaN
         LK3SweJX3WzODq3eg2ZtwogwGYaxkbkonR/YlKto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/201] crypto: qat - remove dma_free_coherent() for DH
Date:   Wed, 27 Jul 2022 18:11:08 +0200
Message-Id: <20220727161034.637741056@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 029aa4624a7fe35233bdd3d1354dc7be260380bf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 83 ++++++++-----------
 1 file changed, 34 insertions(+), 49 deletions(-)

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
-- 
2.35.1



