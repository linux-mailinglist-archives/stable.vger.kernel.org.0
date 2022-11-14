Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F64628048
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbiKNNEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiKNNEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345AF29CAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FA4A61186
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDF7C433D6;
        Mon, 14 Nov 2022 13:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431073;
        bh=tPTQFaBJGt4tEkSTt6RT6CNsifD/thp5wMo8MQM7lu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fR/Nuf+FqK8MSH6+qj3paOd9coOjqe4Bg0RxADQsC+NseT5bauUhcwXWW/mLFjXT9
         50UPKsHP5rtVCg0bKBQnRe7Ukh5TC8iXNRzhiHQ87i3OU10L+/ACdlS/xPsD1M//T2
         KAhAg2nyShqV3j7najSKwESfJXj8EeRVbZSMduf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ratheesh Kannoth <rkannoth@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 073/190] octeontx2-pf: Fix SQE threshold checking
Date:   Mon, 14 Nov 2022 13:44:57 +0100
Message-Id: <20221114124501.883965465@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit f0dfc4c88ef39be0ba736aa0ce6119263fc19aeb ]

Current way of checking available SQE count which is based on
HW updated SQB count could result in driver submitting an SQE
even before CQE for the previously transmitted SQE at the same
index is processed in NAPI resulting losing SKB pointers,
hence a leak. Fix this by checking a consumer index which
is updated once CQE is processed.

Fixes: 3ca6c4c882a7 ("octeontx2-pf: Add packet transmission support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Link: https://lore.kernel.org/r/20221107033505.2491464-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.c       |  1 +
 .../marvell/octeontx2/nic/otx2_txrx.c         | 32 +++++++++++--------
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index d686c7b6252f..9c2baa437c23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -863,6 +863,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	}
 
 	sq->head = 0;
+	sq->cons_head = 0;
 	sq->sqe_per_sqb = (pfvf->hw.sqb_size / sq->sqe_size) - 1;
 	sq->num_sqbs = (qset->sqe_cnt + sq->sqe_per_sqb) / sq->sqe_per_sqb;
 	/* Set SQE threshold to 10% of total SQEs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index a18e8efd0f1e..664f977433f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -435,6 +435,7 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 				struct otx2_cq_queue *cq, int budget)
 {
 	int tx_pkts = 0, tx_bytes = 0, qidx;
+	struct otx2_snd_queue *sq;
 	struct nix_cqe_tx_s *cqe;
 	int processed_cqe = 0;
 
@@ -445,6 +446,9 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 		return 0;
 
 process_cqe:
+	qidx = cq->cq_idx - pfvf->hw.rx_queues;
+	sq = &pfvf->qset.sq[qidx];
+
 	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
 		if (unlikely(!cqe)) {
@@ -452,18 +456,20 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 				return 0;
 			break;
 		}
+
 		if (cq->cq_type == CQ_XDP) {
-			qidx = cq->cq_idx - pfvf->hw.rx_queues;
-			otx2_xdp_snd_pkt_handler(pfvf, &pfvf->qset.sq[qidx],
-						 cqe);
+			otx2_xdp_snd_pkt_handler(pfvf, sq, cqe);
 		} else {
-			otx2_snd_pkt_handler(pfvf, cq,
-					     &pfvf->qset.sq[cq->cint_idx],
-					     cqe, budget, &tx_pkts, &tx_bytes);
+			otx2_snd_pkt_handler(pfvf, cq, sq, cqe, budget,
+					     &tx_pkts, &tx_bytes);
 		}
+
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		processed_cqe++;
 		cq->pend_cqe--;
+
+		sq->cons_head++;
+		sq->cons_head &= (sq->sqe_cnt - 1);
 	}
 
 	/* Free CQEs to HW */
@@ -972,17 +978,17 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(netdev, qidx);
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	int offset, num_segs, free_sqe;
+	int offset, num_segs, free_desc;
 	struct nix_sqe_hdr_s *sqe_hdr;
 
-	/* Check if there is room for new SQE.
-	 * 'Num of SQBs freed to SQ's pool - SQ's Aura count'
-	 * will give free SQE count.
+	/* Check if there is enough room between producer
+	 * and consumer index.
 	 */
-	free_sqe = (sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb;
+	free_desc = (sq->cons_head - sq->head - 1 + sq->sqe_cnt) & (sq->sqe_cnt - 1);
+	if (free_desc < sq->sqe_thresh)
+		return false;
 
-	if (free_sqe < sq->sqe_thresh ||
-	    free_sqe < otx2_get_sqe_count(pfvf, skb))
+	if (free_desc < otx2_get_sqe_count(pfvf, skb))
 		return false;
 
 	num_segs = skb_shinfo(skb)->nr_frags + 1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index fbe62bbfb789..93cac2c2664c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -79,6 +79,7 @@ struct sg_list {
 struct otx2_snd_queue {
 	u8			aura_id;
 	u16			head;
+	u16			cons_head;
 	u16			sqe_size;
 	u32			sqe_cnt;
 	u16			num_sqbs;
-- 
2.35.1



