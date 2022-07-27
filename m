Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0364582F13
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiG0RUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241948AbiG0RTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA845FCF;
        Wed, 27 Jul 2022 09:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE48660DDB;
        Wed, 27 Jul 2022 16:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD377C433D6;
        Wed, 27 Jul 2022 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940266;
        bh=IWqERPbPXuzAJi43HWMg9GWZIDPCSP25alnEokDZ0nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2zhw20u7yt1LsqR5otxUMzsMD5eq/tiMiUmEyxAyBc+8Y+uc0x9NQBQph/7YbXcO
         cIFe1XSTY647FR+1VG3l3w2XtJrJEf3JYNpSQcCmY1sclCISwYyMQ5w4oaGL/SSHLZ
         LWD3skAvBnVzG0Nbtdnr2AfE9vLNbuhDyHcSygPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/201] crypto: qat - remove dma_free_coherent() for RSA
Date:   Wed, 27 Jul 2022 18:11:07 +0200
Message-Id: <20220727161034.597326974@linuxfoundation.org>
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

[ Upstream commit 3dfaf0071ed74d7a9c6b3c9ea4df7a6f8e423c2a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 137 ++++++++----------
 1 file changed, 60 insertions(+), 77 deletions(-)

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
 
-- 
2.35.1



