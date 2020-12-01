Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858932C9C02
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390176AbgLAJOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390169AbgLAJNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8308520770;
        Tue,  1 Dec 2020 09:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814019;
        bh=6TvL/hUeQqKv6hDCPBdWHDaRD5UHa64vcBKjcH3i18s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLFjtH0lllITPy7gz1Ghmh35OK7i7/90NlTZiQ8oczlopFkblclzxLp7cmtfeYhoW
         4COwVGw8t0WJU65qpkITibLEXkHFFGTXpBZuKzxXOEB0CufyHJbLZ2IOQ9JDFSvIQi
         MxvzdBd/FrHocYP3ifo8zjLbbAyS8QWIZYlaZSpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Segev <idose@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 111/152] net: ena: handle bad request id in ena_netdev
Date:   Tue,  1 Dec 2020 09:53:46 +0100
Message-Id: <20201201084726.383820177@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit 5b7022cf1dc0d721bd4b5f3bada05bd8ced82fe0 ]

After request id is checked in validate_rx_req_id() its value is still
used in the line
	rx_ring->free_ids[next_to_clean] =
					rx_ring->ena_bufs[i].req_id;
even if it was found to be out-of-bound for the array free_ids.

The patch moves the request id to an earlier stage in the napi routine and
makes sure its value isn't used if it's found out-of-bounds.

Fixes: 30623e1ed116 ("net: ena: avoid memory access violation by validating req_id properly")
Signed-off-by: Ido Segev <idose@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  3 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 43 +++++--------------
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index ccd4405895651..336f115e8091f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -538,6 +538,7 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 {
 	struct ena_com_rx_buf_info *ena_buf = &ena_rx_ctx->ena_bufs[0];
 	struct ena_eth_io_rx_cdesc_base *cdesc = NULL;
+	u16 q_depth = io_cq->q_depth;
 	u16 cdesc_idx = 0;
 	u16 nb_hw_desc;
 	u16 i = 0;
@@ -565,6 +566,8 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 	do {
 		ena_buf[i].len = cdesc->length;
 		ena_buf[i].req_id = cdesc->req_id;
+		if (unlikely(ena_buf[i].req_id >= q_depth))
+			return -EIO;
 
 		if (++i >= nb_hw_desc)
 			break;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a3a8edf9a734d..0a8520a2e4649 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -801,24 +801,6 @@ static void ena_free_all_io_tx_resources(struct ena_adapter *adapter)
 					      adapter->num_io_queues);
 }
 
-static int validate_rx_req_id(struct ena_ring *rx_ring, u16 req_id)
-{
-	if (likely(req_id < rx_ring->ring_size))
-		return 0;
-
-	netif_err(rx_ring->adapter, rx_err, rx_ring->netdev,
-		  "Invalid rx req_id: %hu\n", req_id);
-
-	u64_stats_update_begin(&rx_ring->syncp);
-	rx_ring->rx_stats.bad_req_id++;
-	u64_stats_update_end(&rx_ring->syncp);
-
-	/* Trigger device reset */
-	rx_ring->adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
-	set_bit(ENA_FLAG_TRIGGER_RESET, &rx_ring->adapter->flags);
-	return -EFAULT;
-}
-
 /* ena_setup_rx_resources - allocate I/O Rx resources (Descriptors)
  * @adapter: network interface device structure
  * @qid: queue index
@@ -1368,15 +1350,10 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	struct ena_rx_buffer *rx_info;
 	u16 len, req_id, buf = 0;
 	void *va;
-	int rc;
 
 	len = ena_bufs[buf].len;
 	req_id = ena_bufs[buf].req_id;
 
-	rc = validate_rx_req_id(rx_ring, req_id);
-	if (unlikely(rc < 0))
-		return NULL;
-
 	rx_info = &rx_ring->rx_buffer_info[req_id];
 
 	if (unlikely(!rx_info->page)) {
@@ -1452,10 +1429,6 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		len = ena_bufs[buf].len;
 		req_id = ena_bufs[buf].req_id;
 
-		rc = validate_rx_req_id(rx_ring, req_id);
-		if (unlikely(rc < 0))
-			return NULL;
-
 		rx_info = &rx_ring->rx_buffer_info[req_id];
 	} while (1);
 
@@ -1704,12 +1677,18 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 error:
 	adapter = netdev_priv(rx_ring->netdev);
 
-	u64_stats_update_begin(&rx_ring->syncp);
-	rx_ring->rx_stats.bad_desc_num++;
-	u64_stats_update_end(&rx_ring->syncp);
+	if (rc == -ENOSPC) {
+		u64_stats_update_begin(&rx_ring->syncp);
+		rx_ring->rx_stats.bad_desc_num++;
+		u64_stats_update_end(&rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
+	} else {
+		u64_stats_update_begin(&rx_ring->syncp);
+		rx_ring->rx_stats.bad_req_id++;
+		u64_stats_update_end(&rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
+	}
 
-	/* Too many desc from the device. Trigger reset */
-	adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
 	set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 
 	return 0;
-- 
2.27.0



