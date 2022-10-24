Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC76160B928
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiJXUFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiJXUE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:04:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EC0220FAF;
        Mon, 24 Oct 2022 11:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B3C1CE1322;
        Mon, 24 Oct 2022 12:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA81C433C1;
        Mon, 24 Oct 2022 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614494;
        bh=K6gjyBoTvmkgn/KUrwOSZN1zLh0dTQkQIO3cap4BIT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJuFj7DF93KDU/UIKzn+tAzkAVr/5YwnkaBgHGtXwUesRcBOvIv5vaZJfdZGUNAx0
         83SLYbDuqcmmw3D85+EximncPsWBOGlU8DyfvYQDr5wLtcyEAgeqqFlmTW4pKJJtN5
         cS04hgT4woQmTKbMDrc+8nq8YNg5QFCR/YRF0nGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/390] crypto: qat - fix DMA transfer direction
Date:   Mon, 24 Oct 2022 13:31:18 +0200
Message-Id: <20221024113034.918728355@linuxfoundation.org>
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

From: Damian Muszynski <damian.muszynski@intel.com>

[ Upstream commit cf5bb835b7c8a5fee7f26455099cca7feb57f5e9 ]

When CONFIG_DMA_API_DEBUG is selected, while running the crypto self
test on the QAT crypto algorithms, the function add_dma_entry() reports
a warning similar to the one below, saying that overlapping mappings
are not supported. This occurs in tests where the input and the output
scatter list point to the same buffers (i.e. two different scatter lists
which point to the same chunks of memory).

The logic that implements the mapping uses the flag DMA_BIDIRECTIONAL
for both the input and the output scatter lists which leads to
overlapped write mappings. These are not supported by the DMA layer.

Fix by specifying the correct DMA transfer directions when mapping
buffers. For in-place operations where the input scatter list
matches the output scatter list, buffers are mapped once with
DMA_BIDIRECTIONAL, otherwise input buffers are mapped using the flag
DMA_TO_DEVICE and output buffers are mapped with DMA_FROM_DEVICE.
Overlapping a read mapping with a write mapping is a valid case in
dma-coherent devices like QAT.
The function that frees and unmaps the buffers, qat_alg_free_bufl()
has been changed accordingly to the changes to the mapping function.

   DMA-API: 4xxx 0000:06:00.0: cacheline tracking EEXIST, overlapping mappings aren't supported
   WARNING: CPU: 53 PID: 4362 at kernel/dma/debug.c:570 add_dma_entry+0x1e9/0x270
   ...
   Call Trace:
   dma_map_page_attrs+0x82/0x2d0
   ? preempt_count_add+0x6a/0xa0
   qat_alg_sgl_to_bufl+0x45b/0x990 [intel_qat]
   qat_alg_aead_dec+0x71/0x250 [intel_qat]
   crypto_aead_decrypt+0x3d/0x70
   test_aead_vec_cfg+0x649/0x810
   ? number+0x310/0x3a0
   ? vsnprintf+0x2a3/0x550
   ? scnprintf+0x42/0x70
   ? valid_sg_divisions.constprop.0+0x86/0xa0
   ? test_aead_vec+0xdf/0x120
   test_aead_vec+0xdf/0x120
   alg_test_aead+0x185/0x400
   alg_test+0x3d8/0x500
   ? crypto_acomp_scomp_free_ctx+0x30/0x30
   ? __schedule+0x32a/0x12a0
   ? ttwu_queue_wakelist+0xbf/0x110
   ? _raw_spin_unlock_irqrestore+0x23/0x40
   ? try_to_wake_up+0x83/0x570
   ? _raw_spin_unlock_irqrestore+0x23/0x40
   ? __set_cpus_allowed_ptr_locked+0xea/0x1b0
   ? crypto_acomp_scomp_free_ctx+0x30/0x30
   cryptomgr_test+0x27/0x50
   kthread+0xe6/0x110
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x1f/0x30

Fixes: d370cec ("crypto: qat - Intel(R) QAT crypto interface")
Link: https://lore.kernel.org/linux-crypto/20220223080400.139367-1-gilad@benyossef.com/
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2e2c2ac53609..5b71768fc0c7 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -624,11 +624,14 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blpout = qat_req->buf.bloutp;
 	size_t sz = qat_req->buf.sz;
 	size_t sz_out = qat_req->buf.sz_out;
+	int bl_dma_dir;
 	int i;
 
+	bl_dma_dir = blp != blpout ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+
 	for (i = 0; i < bl->num_bufs; i++)
 		dma_unmap_single(dev, bl->bufers[i].addr,
-				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
+				 bl->bufers[i].len, bl_dma_dir);
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
 
@@ -642,7 +645,7 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 		for (i = bufless; i < blout->num_bufs; i++) {
 			dma_unmap_single(dev, blout->bufers[i].addr,
 					 blout->bufers[i].len,
-					 DMA_BIDIRECTIONAL);
+					 DMA_FROM_DEVICE);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
 
@@ -666,6 +669,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	struct scatterlist *sg;
 	size_t sz_out, sz = struct_size(bufl, bufers, n);
 	int node = dev_to_node(&GET_DEV(inst->accel_dev));
+	int bufl_dma_dir;
 
 	if (unlikely(!n))
 		return -EINVAL;
@@ -683,6 +687,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		qat_req->buf.sgl_src_valid = true;
 	}
 
+	bufl_dma_dir = sgl != sglout ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
 
@@ -694,7 +700,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 
 		bufl->bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 						      sg->length,
-						      DMA_BIDIRECTIONAL);
+						      bufl_dma_dir);
 		bufl->bufers[y].len = sg->length;
 		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
 			goto err_in;
@@ -737,7 +743,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 
 			bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 							sg->length,
-							DMA_BIDIRECTIONAL);
+							DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
 				goto err_out;
 			bufers[y].len = sg->length;
@@ -767,7 +773,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
-					 DMA_BIDIRECTIONAL);
+					 DMA_FROM_DEVICE);
 
 	if (!qat_req->buf.sgl_dst_valid)
 		kfree(buflout);
@@ -781,7 +787,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
 			dma_unmap_single(dev, bufl->bufers[i].addr,
 					 bufl->bufers[i].len,
-					 DMA_BIDIRECTIONAL);
+					 bufl_dma_dir);
 
 	if (!qat_req->buf.sgl_src_valid)
 		kfree(bufl);
-- 
2.35.1



