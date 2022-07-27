Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C41582F05
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiG0RUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241925AbiG0RTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734F150721;
        Wed, 27 Jul 2022 09:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 057E4B821AC;
        Wed, 27 Jul 2022 16:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3BAC433C1;
        Wed, 27 Jul 2022 16:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940254;
        bh=ExWebhwnzEVWFIDCEFYoZ68tGImeblCF9aJvnPOKp+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P70lwEOTvRwp/7j88lmbR4yMy+DRIrBVxSlfO6LxjDZ6wPPsnhOD2LT6LzvP+Wozw
         SzkK87BK7l34QvnDcD7NFGO+K+gxF0P3HumI7fpP1/xrXbrC+kSIxMDhURnNPOLm9V
         isJ5oHlHaryGtupVPzKZdp7Rz8S8NYeCOFoJLkVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/201] crypto: qat - use pre-allocated buffers in datapath
Date:   Wed, 27 Jul 2022 18:11:03 +0200
Message-Id: <20220727161034.418781055@linuxfoundation.org>
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

[ Upstream commit e0831e7af4e03f2715de102e18e9179ec0a81562 ]

In order to do DMAs, the QAT device requires that the scatterlist
structures are mapped and translated into a format that the firmware can
understand. This is defined as the composition of a scatter gather list
(SGL) descriptor header, the struct qat_alg_buf_list, plus a variable
number of flat buffer descriptors, the struct qat_alg_buf.

The allocation and mapping of these data structures is done each time a
request is received from the skcipher and aead APIs.
In an OOM situation, this behaviour might lead to a dead-lock if an
allocation fails.

Based on the conversation in [1], increase the size of the aead and
skcipher request contexts to include an SGL descriptor that can handle
a maximum of 4 flat buffers.
If requests exceed 4 entries buffers, memory is allocated dynamically.

[1] https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/

Cc: stable@vger.kernel.org
Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c   | 64 +++++++++++++---------
 drivers/crypto/qat/qat_common/qat_crypto.h | 24 ++++++++
 2 files changed, 61 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f998ed58457c..ec635fe44c1f 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -46,19 +46,6 @@
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed __aligned(64);
-
 /* Common content descriptor */
 struct qat_alg_cd {
 	union {
@@ -693,7 +680,10 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
-	kfree(bl);
+
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bl);
+
 	if (blp != blpout) {
 		/* If out of place operation dma unmap only data */
 		int bufless = blout->num_bufs - blout->num_mapped_bufs;
@@ -704,7 +694,9 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 					 DMA_BIDIRECTIONAL);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
-		kfree(blout);
+
+		if (!qat_req->buf.sgl_dst_valid)
+			kfree(blout);
 	}
 }
 
@@ -721,15 +713,24 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blp = DMA_MAPPING_ERROR;
 	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
-	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
+	size_t sz_out, sz = struct_size(bufl, bufers, n);
+	int node = dev_to_node(&GET_DEV(inst->accel_dev));
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kzalloc_node(sz, GFP_ATOMIC,
-			    dev_to_node(&GET_DEV(inst->accel_dev)));
-	if (unlikely(!bufl))
-		return -ENOMEM;
+	qat_req->buf.sgl_src_valid = false;
+	qat_req->buf.sgl_dst_valid = false;
+
+	if (n > QAT_MAX_BUFF_DESC) {
+		bufl = kzalloc_node(sz, GFP_ATOMIC, node);
+		if (unlikely(!bufl))
+			return -ENOMEM;
+	} else {
+		bufl = &qat_req->buf.sgl_src.sgl_hdr;
+		memset(bufl, 0, sizeof(struct qat_alg_buf_list));
+		qat_req->buf.sgl_src_valid = true;
+	}
 
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
@@ -760,12 +761,18 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		struct qat_alg_buf *bufers;
 
 		n = sg_nents(sglout);
-		sz_out = struct_size(buflout, bufers, n + 1);
+		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
-		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
-				       dev_to_node(&GET_DEV(inst->accel_dev)));
-		if (unlikely(!buflout))
-			goto err_in;
+
+		if (n > QAT_MAX_BUFF_DESC) {
+			buflout = kzalloc_node(sz_out, GFP_ATOMIC, node);
+			if (unlikely(!buflout))
+				goto err_in;
+		} else {
+			buflout = &qat_req->buf.sgl_dst.sgl_hdr;
+			memset(buflout, 0, sizeof(struct qat_alg_buf_list));
+			qat_req->buf.sgl_dst_valid = true;
+		}
 
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i)
@@ -810,7 +817,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-	kfree(buflout);
+
+	if (!qat_req->buf.sgl_dst_valid)
+		kfree(buflout);
 
 err_in:
 	if (!dma_mapping_error(dev, blp))
@@ -823,7 +832,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	kfree(bufl);
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index b6a4c95ae003..0928f159ea99 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -21,6 +21,26 @@ struct qat_crypto_instance {
 	atomic_t refctr;
 };
 
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed;
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
 struct qat_crypto_request_buffs {
 	struct qat_alg_buf_list *bl;
 	dma_addr_t blp;
@@ -28,6 +48,10 @@ struct qat_crypto_request_buffs {
 	dma_addr_t bloutp;
 	size_t sz;
 	size_t sz_out;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
 struct qat_crypto_request;
-- 
2.35.1



