Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3649F579DF6
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiGSM4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242100AbiGSMzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F4E4D833;
        Tue, 19 Jul 2022 05:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96BA16177D;
        Tue, 19 Jul 2022 12:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664AFC341C6;
        Tue, 19 Jul 2022 12:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233332;
        bh=//5AZjtwiCSLnW9fEPDNldUcgJn2J5C6jZWQwKamqco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzqBXRNxRxo5f5SXo24vA4bleGvo+Q07aUpNicHkDOixX0gxkxA7aVSWSQW7Ql7JI
         thBcVVHGkTxF1VOf46E1CVOrB9UKoTx9MIY8wMzw1N5ctMrPFV5MVrim54R6WEKDZy
         ZICX3V+eB1RTs9yLDsSYBI9YuXLK0JEFy47rnUn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 086/231] nfp: fix issue of skb segments exceeds descriptor limitation
Date:   Tue, 19 Jul 2022 13:52:51 +0200
Message-Id: <20220719114722.043871831@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

[ Upstream commit 9c840d5f9aaef87e65db900bae21c70b059aba5f ]

TCP packets will be dropped if the segments number in the tx skb
exceeds limitation when sending iperf3 traffic with --zerocopy option.

we make the following changes:

Get nr_frags in nfp_nfdk_tx_maybe_close_block instead of passing from
outside because it will be changed after skb_linearize operation.

Fill maximum dma_len in first tx descriptor to make sure the whole
head is included in the first descriptor.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 33 +++++++++++++++-----
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index e509d6dcba5c..805071d64a20 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -125,17 +125,18 @@ nfp_nfdk_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 
 static int
 nfp_nfdk_tx_maybe_close_block(struct nfp_net_tx_ring *tx_ring,
-			      unsigned int nr_frags, struct sk_buff *skb)
+			      struct sk_buff *skb)
 {
 	unsigned int n_descs, wr_p, nop_slots;
 	const skb_frag_t *frag, *fend;
 	struct nfp_nfdk_tx_desc *txd;
+	unsigned int nr_frags;
 	unsigned int wr_idx;
 	int err;
 
 recount_descs:
 	n_descs = nfp_nfdk_headlen_to_segs(skb_headlen(skb));
-
+	nr_frags = skb_shinfo(skb)->nr_frags;
 	frag = skb_shinfo(skb)->frags;
 	fend = frag + nr_frags;
 	for (; frag < fend; frag++)
@@ -281,10 +282,13 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	if (unlikely((int)metadata < 0))
 		goto err_flush;
 
-	nr_frags = skb_shinfo(skb)->nr_frags;
-	if (nfp_nfdk_tx_maybe_close_block(tx_ring, nr_frags, skb))
+	if (nfp_nfdk_tx_maybe_close_block(tx_ring, skb))
 		goto err_flush;
 
+	/* nr_frags will change after skb_linearize so we get nr_frags after
+	 * nfp_nfdk_tx_maybe_close_block function
+	 */
+	nr_frags = skb_shinfo(skb)->nr_frags;
 	/* DMA map all */
 	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
 	txd = &tx_ring->ktxds[wr_idx];
@@ -310,7 +314,16 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	/* FIELD_PREP() implicitly truncates to chunk */
 	dma_len -= 1;
-	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+
+	/* We will do our best to pass as much data as we can in descriptor
+	 * and we need to make sure the first descriptor includes whole head
+	 * since there is limitation in firmware side. Sometimes the value of
+	 * dma_len bitwise and NFDK_DESC_TX_DMA_LEN_HEAD will less than
+	 * headlen.
+	 */
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD,
+			       dma_len > NFDK_DESC_TX_DMA_LEN_HEAD ?
+			       NFDK_DESC_TX_DMA_LEN_HEAD : dma_len) |
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
@@ -925,7 +938,9 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 
 	/* FIELD_PREP() implicitly truncates to chunk */
 	dma_len -= 1;
-	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD,
+			       dma_len > NFDK_DESC_TX_DMA_LEN_HEAD ?
+			       NFDK_DESC_TX_DMA_LEN_HEAD : dma_len) |
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
@@ -1303,7 +1318,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 				   skb_push(skb, 4));
 	}
 
-	if (nfp_nfdk_tx_maybe_close_block(tx_ring, 0, skb))
+	if (nfp_nfdk_tx_maybe_close_block(tx_ring, skb))
 		goto err_free;
 
 	/* DMA map all */
@@ -1328,7 +1343,9 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txbuf++;
 
 	dma_len -= 1;
-	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD,
+			       dma_len > NFDK_DESC_TX_DMA_LEN_HEAD ?
+			       NFDK_DESC_TX_DMA_LEN_HEAD : dma_len) |
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-- 
2.35.1



