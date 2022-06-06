Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912DD53E5F9
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbiFFLmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbiFFLmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:42:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344663054A
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C60C2B81811
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A169C3411C;
        Mon,  6 Jun 2022 11:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654515736;
        bh=Qy8TAFMFmx+1ff4MLqG8euMz6kIANzgK5R/iD/1FyWg=;
        h=Subject:To:Cc:From:Date:From;
        b=ElwsBzFPw/mwb2Z23nfI+8tQwNTvL/ItGG8A0KkuZFjaeWjXCOUUXss7EBAbFaTRj
         uHBG6Ek5tYuNuTaa2aFz+x6w6H4STBpHqPOLhw+tgBP5pyGe/1JcjQ4FOSluNDj7KP
         WYJ+pfL5GFfh+S4qlmi+6JJl3FwAA0TL1g4V0xVc=
Subject: WTF: patch "[PATCH] crypto: qat - remove dma_free_coherent() for RSA" was seriously submitted to be applied to the 5.18-stable tree?
To:     giovanni.cabiddu@intel.com, adam.guerin@intel.com,
        herbert@gondor.apana.org.au, wojciech.ziemba@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:42:10 +0200
Message-ID: <1654515730220151@kroah.com>
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

From 3dfaf0071ed74d7a9c6b3c9ea4df7a6f8e423c2a Mon Sep 17 00:00:00 2001
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Mon, 9 May 2022 14:34:12 +0100
Subject: [PATCH] crypto: qat - remove dma_free_coherent() for RSA

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 2bc02c75398e..b31372bddb96 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -529,25 +529,22 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 
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
@@ -664,6 +661,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	u8 *vaddr;
 	int ret;
 
 	if (unlikely(!ctx->n || !ctx->e))
@@ -701,40 +699,39 @@ static int qat_rsa_enc(struct akcipher_request *req)
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
@@ -772,21 +769,15 @@ static int qat_rsa_enc(struct akcipher_request *req)
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
 
@@ -799,6 +790,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	u8 *vaddr;
 	int ret;
 
 	if (unlikely(!ctx->n || !ctx->d))
@@ -846,40 +838,37 @@ static int qat_rsa_dec(struct akcipher_request *req)
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
@@ -925,21 +914,15 @@ static int qat_rsa_dec(struct akcipher_request *req)
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
 

