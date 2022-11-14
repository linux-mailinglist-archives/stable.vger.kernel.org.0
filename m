Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0DE627F2E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbiKNM4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbiKNM4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:56:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E64F27DD2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF8CB61154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13BBC433C1;
        Mon, 14 Nov 2022 12:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430576;
        bh=XKFuDxKzlnZEInejACp0t4dyP7eXoiNrcFbc3edZBVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4dg0REjOZbrqA3bx7NLARlijHdgGmLYXSxRiSl7y7qAqYEuPr4DfH/yTYbt+JTh4
         pgfFkLUHl2y9+tBJ823PEGeAWB8MkcmTm2KhRJuR8OcDBcjRK1ndcIBm0Rk3rJ8ucf
         8ASYmQsVTwiJB6v8qdRGyFiCmJFv5jCBsw6QGE/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/131] octeontx2-pf: Use hardware register for CQE count
Date:   Mon, 14 Nov 2022 13:44:57 +0100
Message-Id: <20221114124449.868344273@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit af3826db74d184bc9c2c9d3ff34548e5f317a6f3 ]

Current driver uses software CQ head pointer to poll on CQE
header in memory to determine if CQE is valid. Software needs
to make sure, that the reads of the CQE do not get re-ordered
so much that it ends up with an inconsistent view of the CQE.
To ensure that DMB barrier after read to first CQE cacheline
and before reading of the rest of the CQE is needed.
But having barrier for every CQE read will impact the performance,
instead use hardware CQ head and tail pointers to find the
valid number of CQEs.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 51afe9026d0c ("octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.c       |  3 +
 .../marvell/octeontx2/nic/otx2_common.h       |  1 +
 .../marvell/octeontx2/nic/otx2_txrx.c         | 69 +++++++++++++++++--
 .../marvell/octeontx2/nic/otx2_txrx.h         |  5 ++
 include/linux/soc/marvell/octeontx2/asm.h     | 14 ++++
 5 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 7cf24dd5c878..e14624caddc6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1013,6 +1013,9 @@ int otx2_config_nix_queues(struct otx2_nic *pfvf)
 			return err;
 	}
 
+	pfvf->cq_op_addr = (__force u64 *)otx2_get_regaddr(pfvf,
+							   NIX_LF_CQ_OP_STATUS);
+
 	/* Initialize work queue for receive buffer refill */
 	pfvf->refill_wrk = devm_kcalloc(pfvf->dev, pfvf->qset.cq_cnt,
 					sizeof(struct refill_work), GFP_KERNEL);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4ecd0ef05f3b..095e5de78c0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -337,6 +337,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
 	u64			flags;
+	u64			*cq_op_addr;
 
 	struct otx2_qset	qset;
 	struct otx2_hw		hw;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index f42b1d4e0c67..3f3ec8ffc4dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -18,6 +18,31 @@
 
 #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
 
+static int otx2_nix_cq_op_status(struct otx2_nic *pfvf,
+				 struct otx2_cq_queue *cq)
+{
+	u64 incr = (u64)(cq->cq_idx) << 32;
+	u64 status;
+
+	status = otx2_atomic64_fetch_add(incr, pfvf->cq_op_addr);
+
+	if (unlikely(status & BIT_ULL(CQ_OP_STAT_OP_ERR) ||
+		     status & BIT_ULL(CQ_OP_STAT_CQ_ERR))) {
+		dev_err(pfvf->dev, "CQ stopped due to error");
+		return -EINVAL;
+	}
+
+	cq->cq_tail = status & 0xFFFFF;
+	cq->cq_head = (status >> 20) & 0xFFFFF;
+	if (cq->cq_tail < cq->cq_head)
+		cq->pend_cqe = (cq->cqe_cnt - cq->cq_head) +
+				cq->cq_tail;
+	else
+		cq->pend_cqe = cq->cq_tail - cq->cq_head;
+
+	return 0;
+}
+
 static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
 {
 	struct nix_cqe_hdr_s *cqe_hdr;
@@ -318,7 +343,14 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
 
-	while (likely(processed_cqe < budget)) {
+	if (cq->pend_cqe >= budget)
+		goto process_cqe;
+
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return 0;
+
+process_cqe:
+	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
 		if (cqe->hdr.cqe_type == NIX_XQE_TYPE_INVALID ||
 		    !cqe->sg.seg_addr) {
@@ -334,6 +366,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		cqe->sg.seg_addr = 0x00;
 		processed_cqe++;
+		cq->pend_cqe--;
 	}
 
 	/* Free CQEs to HW */
@@ -368,7 +401,14 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 	struct nix_cqe_tx_s *cqe;
 	int processed_cqe = 0;
 
-	while (likely(processed_cqe < budget)) {
+	if (cq->pend_cqe >= budget)
+		goto process_cqe;
+
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return 0;
+
+process_cqe:
+	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
 		if (unlikely(!cqe)) {
 			if (!processed_cqe)
@@ -380,6 +420,7 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		processed_cqe++;
+		cq->pend_cqe--;
 	}
 
 	/* Free CQEs to HW */
@@ -936,10 +977,16 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	int processed_cqe = 0;
 	u64 iova, pa;
 
-	while ((cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq))) {
-		if (!cqe->sg.subdc)
-			continue;
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return;
+
+	while (cq->pend_cqe) {
+		cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq);
 		processed_cqe++;
+		cq->pend_cqe--;
+
+		if (!cqe)
+			continue;
 		if (cqe->sg.segs > 1) {
 			otx2_free_rcv_seg(pfvf, cqe, cq->cq_idx);
 			continue;
@@ -965,7 +1012,16 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 
 	sq = &pfvf->qset.sq[cq->cint_idx];
 
-	while ((cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq))) {
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return;
+
+	while (cq->pend_cqe) {
+		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
+		processed_cqe++;
+		cq->pend_cqe--;
+
+		if (!cqe)
+			continue;
 		sg = &sq->sg[cqe->comp.sqe_id];
 		skb = (struct sk_buff *)sg->skb;
 		if (skb) {
@@ -973,7 +1029,6 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 			dev_kfree_skb_any(skb);
 			sg->skb = (u64)NULL;
 		}
-		processed_cqe++;
 	}
 
 	/* Free CQEs to HW */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 3ff1ad79c001..6a97631ff226 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -56,6 +56,9 @@
  */
 #define CQ_QCOUNT_DEFAULT	1
 
+#define CQ_OP_STAT_OP_ERR       63
+#define CQ_OP_STAT_CQ_ERR       46
+
 struct queue_stats {
 	u64	bytes;
 	u64	pkts;
@@ -122,6 +125,8 @@ struct otx2_cq_queue {
 	u16			pool_ptrs;
 	u32			cqe_cnt;
 	u32			cq_head;
+	u32			cq_tail;
+	u32			pend_cqe;
 	void			*cqe_base;
 	struct qmem		*cqe;
 	struct otx2_pool	*rbpool;
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
index fa1d6af0164e..0f79fd7f81a1 100644
--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -34,9 +34,23 @@
 			 : [rf] "+r"(val)		\
 			 : [rs] "r"(addr));		\
 })
+
+static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
+{
+	u64 result;
+
+	asm volatile (".cpu  generic+lse\n"
+		      "ldadda %x[i], %x[r], [%[b]]"
+		      : [r] "=r" (result), "+m" (*ptr)
+		      : [i] "r" (incr), [b] "r" (ptr)
+		      : "memory");
+	return result;
+}
+
 #else
 #define otx2_lmt_flush(ioaddr)          ({ 0; })
 #define cn10k_lmt_flush(val, addr)	({ addr = val; })
+#define otx2_atomic64_fetch_add(incr, ptr)	({ incr; })
 #endif
 
 #endif /* __SOC_OTX2_ASM_H */
-- 
2.35.1



