Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66A1586A86
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiHAMSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbiHAMQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:16:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F547E022;
        Mon,  1 Aug 2022 04:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E0FAB80E8F;
        Mon,  1 Aug 2022 11:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ED3C433D6;
        Mon,  1 Aug 2022 11:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355138;
        bh=501OjYb5HYrJrfCdqJVm4WnrudaBA4TQcWrbApMwIqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXtt9CvBA+zBrkgEKMLjFbxo+2efwRy9Q1VPtcJ9apw5U3aRTDZF/xOYsBAhGQNmT
         D6CJ95CQb9BInoPdY2zTsbPhM/gtXO17s/aBWyOeg+XuC1pT3IjPs+0IFGw+XBzAkj
         poWqnTnVFIuSmrbMcM7F4mHvd/hjN7J87pc76z58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dimitris Michailidis <dmichail@fungible.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 77/88] net/funeth: Fix fun_xdp_tx() and XDP packet reclaim
Date:   Mon,  1 Aug 2022 13:47:31 +0200
Message-Id: <20220801114141.551590329@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

From: Dimitris Michailidis <d.michailidis@fungible.com>

[ Upstream commit 51a83391d77bb0f7ff0aef06ca4c7f5aa9e80b4c ]

The current implementation of fun_xdp_tx(), used for XPD_TX, is
incorrect in that it takes an address/length pair and later releases it
with page_frag_free(). It is OK for XDP_TX but the same code is used by
ndo_xdp_xmit. In that case it loses the XDP memory type and releases the
packet incorrectly for some of the types. Assorted breakage follows.

Change fun_xdp_tx() to take xdp_frame and rely on xdp_return_frame() in
reclaim.

Fixes: db37bc177dae ("net/funeth: add the data path")
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
Link: https://lore.kernel.org/r/20220726215923.7887-1-dmichail@fungible.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  5 ++++-
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 20 +++++++++----------
 .../ethernet/fungible/funeth/funeth_txrx.h    |  6 +++---
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 0f6a549b9f67..29a6c2ede43a 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -142,6 +142,7 @@ static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
 			 int ref_ok, struct funeth_txq *xdp_q)
 {
 	struct bpf_prog *xdp_prog;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -163,7 +164,9 @@ static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
 	case XDP_TX:
 		if (unlikely(!ref_ok))
 			goto pass;
-		if (!fun_xdp_tx(xdp_q, xdp.data, xdp.data_end - xdp.data))
+
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (!xdpf || !fun_xdp_tx(xdp_q, xdpf))
 			goto xdp_error;
 		FUN_QSTAT_INC(q, xdp_tx);
 		q->xdp_flush |= FUN_XDP_FLUSH_TX;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index ff6e29237253..2f6698b98b03 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -466,7 +466,7 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 
 		do {
 			fun_xdp_unmap(q, reclaim_idx);
-			page_frag_free(q->info[reclaim_idx].vaddr);
+			xdp_return_frame(q->info[reclaim_idx].xdpf);
 
 			trace_funeth_tx_free(q, reclaim_idx, 1, head);
 
@@ -479,11 +479,11 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 	return npkts;
 }
 
-bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
+bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 {
 	struct fun_eth_tx_req *req;
 	struct fun_dataop_gl *gle;
-	unsigned int idx;
+	unsigned int idx, len;
 	dma_addr_t dma;
 
 	if (fun_txq_avail(q) < FUN_XDP_CLEAN_THRES)
@@ -494,7 +494,8 @@ bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
 		return false;
 	}
 
-	dma = dma_map_single(q->dma_dev, data, len, DMA_TO_DEVICE);
+	len = xdpf->len;
+	dma = dma_map_single(q->dma_dev, xdpf->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(q->dma_dev, dma))) {
 		FUN_QSTAT_INC(q, tx_map_err);
 		return false;
@@ -514,7 +515,7 @@ bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
 	gle = (struct fun_dataop_gl *)req->dataop.imm;
 	fun_dataop_gl_init(gle, 0, 0, len, dma);
 
-	q->info[idx].vaddr = data;
+	q->info[idx].xdpf = xdpf;
 
 	u64_stats_update_begin(&q->syncp);
 	q->stats.tx_bytes += len;
@@ -545,12 +546,9 @@ int fun_xdp_xmit_frames(struct net_device *dev, int n,
 	if (unlikely(q_idx >= fp->num_xdpqs))
 		return -ENXIO;
 
-	for (q = xdpqs[q_idx], i = 0; i < n; i++) {
-		const struct xdp_frame *xdpf = frames[i];
-
-		if (!fun_xdp_tx(q, xdpf->data, xdpf->len))
+	for (q = xdpqs[q_idx], i = 0; i < n; i++)
+		if (!fun_xdp_tx(q, frames[i]))
 			break;
-	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		fun_txq_wr_db(q);
@@ -577,7 +575,7 @@ static void fun_xdpq_purge(struct funeth_txq *q)
 		unsigned int idx = q->cons_cnt & q->mask;
 
 		fun_xdp_unmap(q, idx);
-		page_frag_free(q->info[idx].vaddr);
+		xdp_return_frame(q->info[idx].xdpf);
 		q->cons_cnt++;
 	}
 }
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
index 04c9f91b7489..8708e2895946 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -95,8 +95,8 @@ struct funeth_txq_stats {  /* per Tx queue SW counters */
 
 struct funeth_tx_info {      /* per Tx descriptor state */
 	union {
-		struct sk_buff *skb; /* associated packet */
-		void *vaddr;         /* start address for XDP */
+		struct sk_buff *skb;    /* associated packet (sk_buff path) */
+		struct xdp_frame *xdpf; /* associated XDP frame (XDP path) */
 	};
 };
 
@@ -245,7 +245,7 @@ static inline int fun_irq_node(const struct fun_irq *p)
 int fun_rxq_napi_poll(struct napi_struct *napi, int budget);
 int fun_txq_napi_poll(struct napi_struct *napi, int budget);
 netdev_tx_t fun_start_xmit(struct sk_buff *skb, struct net_device *netdev);
-bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len);
+bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf);
 int fun_xdp_xmit_frames(struct net_device *dev, int n,
 			struct xdp_frame **frames, u32 flags);
 
-- 
2.35.1



