Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92E2157B64
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgBJN3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgBJMgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:20 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205342168B;
        Mon, 10 Feb 2020 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338179;
        bh=jQBaY2oTGNxezyFeJkP+neRupsL6zDvoxiDmGD5W3/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0utG1sqKEpdGZwWKiGcFQVQwT6OZSRi4ZW2mfuYH/+hkW1eNYWFRB+VjjGnIE+1XD
         U2Ei5LUGVJllxgnkQdw3AzeDFHSNom/JF+IbCp0iq4nii8wHrFw9Tazby3arA0F1am
         9wVQHlhCLwhw9w0Ibxxgqy+gEEtA0Um8cbsLdkT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 168/195] net: mvneta: move rx_dropped and rx_errors in per-cpu stats
Date:   Mon, 10 Feb 2020 04:33:46 -0800
Message-Id: <20200210122321.643649722@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c35947b8ff8acca33134ee39c31708233765c31a ]

Move rx_dropped and rx_errors counters in mvneta_pcpu_stats in order to
avoid possible races updating statistics

Fixes: 562e2f467e71 ("net: mvneta: Improve the buffer allocation method for SWBM")
Fixes: dc35a10f68d3 ("net: mvneta: bm: add support for hardware buffer management")
Fixes: c5aff18204da ("net: mvneta: driver for Marvell Armada 370/XP network unit")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -385,6 +385,8 @@ struct mvneta_pcpu_stats {
 	struct	u64_stats_sync syncp;
 	u64	rx_packets;
 	u64	rx_bytes;
+	u64	rx_dropped;
+	u64	rx_errors;
 	u64	tx_packets;
 	u64	tx_bytes;
 };
@@ -701,6 +703,8 @@ mvneta_get_stats64(struct net_device *de
 		struct mvneta_pcpu_stats *cpu_stats;
 		u64 rx_packets;
 		u64 rx_bytes;
+		u64 rx_dropped;
+		u64 rx_errors;
 		u64 tx_packets;
 		u64 tx_bytes;
 
@@ -709,19 +713,20 @@ mvneta_get_stats64(struct net_device *de
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
 			rx_packets = cpu_stats->rx_packets;
 			rx_bytes   = cpu_stats->rx_bytes;
+			rx_dropped = cpu_stats->rx_dropped;
+			rx_errors  = cpu_stats->rx_errors;
 			tx_packets = cpu_stats->tx_packets;
 			tx_bytes   = cpu_stats->tx_bytes;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
+		stats->rx_dropped += rx_dropped;
+		stats->rx_errors  += rx_errors;
 		stats->tx_packets += tx_packets;
 		stats->tx_bytes   += tx_bytes;
 	}
 
-	stats->rx_errors	= dev->stats.rx_errors;
-	stats->rx_dropped	= dev->stats.rx_dropped;
-
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
@@ -1698,8 +1703,14 @@ static u32 mvneta_txq_desc_csum(int l3_o
 static void mvneta_rx_error(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc)
 {
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	u32 status = rx_desc->status;
 
+	/* update per-cpu counter */
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_errors++;
+	u64_stats_update_end(&stats->syncp);
+
 	switch (status & MVNETA_RXD_ERR_CODE_MASK) {
 	case MVNETA_RXD_ERR_CRC:
 		netdev_err(pp->dev, "bad rx status %08x (crc error), size=%d\n",
@@ -1960,7 +1971,6 @@ static int mvneta_rx_swbm(struct napi_st
 			/* Check errors only for FIRST descriptor */
 			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
 				mvneta_rx_error(pp, rx_desc);
-				dev->stats.rx_errors++;
 				/* leave the descriptor untouched */
 				continue;
 			}
@@ -1971,11 +1981,17 @@ static int mvneta_rx_swbm(struct napi_st
 			skb_size = max(rx_copybreak, rx_header_size);
 			rxq->skb = netdev_alloc_skb_ip_align(dev, skb_size);
 			if (unlikely(!rxq->skb)) {
+				struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+
 				netdev_err(dev,
 					   "Can't allocate skb on queue %d\n",
 					   rxq->id);
-				dev->stats.rx_dropped++;
+
 				rxq->skb_alloc_err++;
+
+				u64_stats_update_begin(&stats->syncp);
+				stats->rx_dropped++;
+				u64_stats_update_end(&stats->syncp);
 				continue;
 			}
 			copy_size = min(skb_size, rx_bytes);
@@ -2135,7 +2151,6 @@ err_drop_frame_ret_pool:
 			mvneta_bm_pool_put_bp(pp->bm_priv, bm_pool,
 					      rx_desc->buf_phys_addr);
 err_drop_frame:
-			dev->stats.rx_errors++;
 			mvneta_rx_error(pp, rx_desc);
 			/* leave the descriptor untouched */
 			continue;


