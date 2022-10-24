Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8756160AA33
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiJXNbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbiJXN3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E324AC284;
        Mon, 24 Oct 2022 05:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CBE4612EA;
        Mon, 24 Oct 2022 12:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE4FC433C1;
        Mon, 24 Oct 2022 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614486;
        bh=rOZy5jmHipFrh/N8gaOxnhHAc/Cy3p/sYUSneBQ699w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3Gk6v6H8Dy3idm1DU5qyn20PdnWM1EvN/GYXvmFAf5dsaoJxJJ2uyrX+pwteSEsm
         r136orKZXkPrZEWlRQm11IFdZalV/try7mAKzZojdU83RqXRM8S6pS+Sf/ytXD/GUh
         8OQiP2V31H6pBb94/Udvfe0aa3CoOEd81f+gVE8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/390] crypto: qat - fix use of dma_map_single
Date:   Mon, 24 Oct 2022 13:31:16 +0200
Message-Id: <20221024113034.829454728@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 7cc05071f930a631040fea16a41f9d78771edc49 ]

DMA_TO_DEVICE synchronisation must be done after the last modification
of the memory region by the software and before it is handed off to
the device.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: cf5bb835b7c8 ("crypto: qat - fix DMA transfer direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 27 ++++++++++++------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 06abe1e2074e..8625e299d445 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -669,8 +669,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	int n = sg_nents(sgl);
 	struct qat_alg_buf_list *bufl;
 	struct qat_alg_buf_list *buflout = NULL;
-	dma_addr_t blp;
-	dma_addr_t bloutp;
+	dma_addr_t blp = DMA_MAPPING_ERROR;
+	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
 	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
 
@@ -685,10 +685,6 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
 
-	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, blp)))
-		goto err_in;
-
 	for_each_sg(sgl, sg, n, i) {
 		int y = sg_nctr;
 
@@ -704,6 +700,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		sg_nctr++;
 	}
 	bufl->num_bufs = sg_nctr;
+	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, blp)))
+		goto err_in;
 	qat_req->buf.bl = bufl;
 	qat_req->buf.blp = blp;
 	qat_req->buf.sz = sz;
@@ -723,9 +722,6 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		for_each_sg(sglout, sg, n, i)
 			bufers[i].addr = DMA_MAPPING_ERROR;
 
-		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, bloutp)))
-			goto err_out;
 		for_each_sg(sglout, sg, n, i) {
 			int y = sg_nctr;
 
@@ -742,6 +738,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		}
 		buflout->num_bufs = sg_nctr;
 		buflout->num_mapped_bufs = sg_nctr;
+		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, bloutp)))
+			goto err_out;
 		qat_req->buf.blout = buflout;
 		qat_req->buf.bloutp = bloutp;
 		qat_req->buf.sz_out = sz_out;
@@ -753,17 +752,21 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	return 0;
 
 err_out:
+	if (!dma_mapping_error(dev, bloutp))
+		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
+
 	n = sg_nents(sglout);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-	if (!dma_mapping_error(dev, bloutp))
-		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
 	kfree(buflout);
 
 err_in:
+	if (!dma_mapping_error(dev, blp))
+		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
+
 	n = sg_nents(sgl);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
@@ -771,8 +774,6 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	if (!dma_mapping_error(dev, blp))
-		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
 	kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
-- 
2.35.1



