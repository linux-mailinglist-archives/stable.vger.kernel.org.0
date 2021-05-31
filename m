Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ABF3962B8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhEaPAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234285AbhEaO5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CCF961CC8;
        Mon, 31 May 2021 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469652;
        bh=DW5pPn8KdGFFkyp931xg51AEm3yvu2OwxuUlQBsFhqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N385h6Eq7WynQizig96U1yCf+F+s2ap3TAfAsvQyEYXDVpbYEApycF8BEOU0W8xIg
         W/jCcyBSIV5xRJ+wBqL7UefOLQYAdwEfq2vHnglKmAO8DUxx5fKZzdSuE4LbtAzpra
         gdKyQBue3p29SpJ8jgAtngdrG1jZVpslgyFa205s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Reto Schneider <code@reto-schneider.ch>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 278/296] net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88
Date:   Mon, 31 May 2021 15:15:33 +0200
Message-Id: <20210531130713.074944828@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roese <sr@denx.de>

[ Upstream commit ad79fd2c42f7626bdf6935cd72134c2a5a59ff2d ]

The MT7628/88 SoC(s) have other (limited) packet counter registers than
currently supported in the mtk_eth_soc driver. This patch adds support
for reading these registers, so that the packet statistics are correctly
updated.

Additionally the defines for the non-MT7628 variant packet counter
registers are added and used in this patch instead of using hard coded
values.

Signed-off-by: Stefan Roese <sr@denx.de>
Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
Cc: Felix Fietkau <nbd@nbd.name>
Cc: John Crispin <john@phrozen.org>
Cc: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Reto Schneider <code@reto-schneider.ch>
Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 67 ++++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 24 +++++++-
 2 files changed, 66 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bcd5e7ae8482..10e30efa775d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -679,32 +679,53 @@ static int mtk_set_mac_address(struct net_device *dev, void *p)
 void mtk_stats_update_mac(struct mtk_mac *mac)
 {
 	struct mtk_hw_stats *hw_stats = mac->hw_stats;
-	unsigned int base = MTK_GDM1_TX_GBCNT;
-	u64 stats;
-
-	base += hw_stats->reg_offset;
+	struct mtk_eth *eth = mac->hw;
 
 	u64_stats_update_begin(&hw_stats->syncp);
 
-	hw_stats->rx_bytes += mtk_r32(mac->hw, base);
-	stats =  mtk_r32(mac->hw, base + 0x04);
-	if (stats)
-		hw_stats->rx_bytes += (stats << 32);
-	hw_stats->rx_packets += mtk_r32(mac->hw, base + 0x08);
-	hw_stats->rx_overflow += mtk_r32(mac->hw, base + 0x10);
-	hw_stats->rx_fcs_errors += mtk_r32(mac->hw, base + 0x14);
-	hw_stats->rx_short_errors += mtk_r32(mac->hw, base + 0x18);
-	hw_stats->rx_long_errors += mtk_r32(mac->hw, base + 0x1c);
-	hw_stats->rx_checksum_errors += mtk_r32(mac->hw, base + 0x20);
-	hw_stats->rx_flow_control_packets +=
-					mtk_r32(mac->hw, base + 0x24);
-	hw_stats->tx_skip += mtk_r32(mac->hw, base + 0x28);
-	hw_stats->tx_collisions += mtk_r32(mac->hw, base + 0x2c);
-	hw_stats->tx_bytes += mtk_r32(mac->hw, base + 0x30);
-	stats =  mtk_r32(mac->hw, base + 0x34);
-	if (stats)
-		hw_stats->tx_bytes += (stats << 32);
-	hw_stats->tx_packets += mtk_r32(mac->hw, base + 0x38);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		hw_stats->tx_packets += mtk_r32(mac->hw, MT7628_SDM_TPCNT);
+		hw_stats->tx_bytes += mtk_r32(mac->hw, MT7628_SDM_TBCNT);
+		hw_stats->rx_packets += mtk_r32(mac->hw, MT7628_SDM_RPCNT);
+		hw_stats->rx_bytes += mtk_r32(mac->hw, MT7628_SDM_RBCNT);
+		hw_stats->rx_checksum_errors +=
+			mtk_r32(mac->hw, MT7628_SDM_CS_ERR);
+	} else {
+		unsigned int offs = hw_stats->reg_offset;
+		u64 stats;
+
+		hw_stats->rx_bytes += mtk_r32(mac->hw,
+					      MTK_GDM1_RX_GBCNT_L + offs);
+		stats = mtk_r32(mac->hw, MTK_GDM1_RX_GBCNT_H + offs);
+		if (stats)
+			hw_stats->rx_bytes += (stats << 32);
+		hw_stats->rx_packets +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_GPCNT + offs);
+		hw_stats->rx_overflow +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_OERCNT + offs);
+		hw_stats->rx_fcs_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_FERCNT + offs);
+		hw_stats->rx_short_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_SERCNT + offs);
+		hw_stats->rx_long_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_LENCNT + offs);
+		hw_stats->rx_checksum_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_CERCNT + offs);
+		hw_stats->rx_flow_control_packets +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_FCCNT + offs);
+		hw_stats->tx_skip +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_SKIPCNT + offs);
+		hw_stats->tx_collisions +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_COLCNT + offs);
+		hw_stats->tx_bytes +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_GBCNT_L + offs);
+		stats =  mtk_r32(mac->hw, MTK_GDM1_TX_GBCNT_H + offs);
+		if (stats)
+			hw_stats->tx_bytes += (stats << 32);
+		hw_stats->tx_packets +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_GPCNT + offs);
+	}
+
 	u64_stats_update_end(&hw_stats->syncp);
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index c47272100615..e02e21cba828 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -267,8 +267,21 @@
 /* QDMA FQ Free Page Buffer Length Register */
 #define MTK_QDMA_FQ_BLEN	0x1B2C
 
-/* GMA1 Received Good Byte Count Register */
-#define MTK_GDM1_TX_GBCNT	0x2400
+/* GMA1 counter / statics register */
+#define MTK_GDM1_RX_GBCNT_L	0x2400
+#define MTK_GDM1_RX_GBCNT_H	0x2404
+#define MTK_GDM1_RX_GPCNT	0x2408
+#define MTK_GDM1_RX_OERCNT	0x2410
+#define MTK_GDM1_RX_FERCNT	0x2414
+#define MTK_GDM1_RX_SERCNT	0x2418
+#define MTK_GDM1_RX_LENCNT	0x241c
+#define MTK_GDM1_RX_CERCNT	0x2420
+#define MTK_GDM1_RX_FCCNT	0x2424
+#define MTK_GDM1_TX_SKIPCNT	0x2428
+#define MTK_GDM1_TX_COLCNT	0x242c
+#define MTK_GDM1_TX_GBCNT_L	0x2430
+#define MTK_GDM1_TX_GBCNT_H	0x2434
+#define MTK_GDM1_TX_GPCNT	0x2438
 #define MTK_STAT_OFFSET		0x40
 
 /* QDMA descriptor txd4 */
@@ -484,6 +497,13 @@
 #define MT7628_SDM_MAC_ADRL	(MT7628_SDM_OFFSET + 0x0c)
 #define MT7628_SDM_MAC_ADRH	(MT7628_SDM_OFFSET + 0x10)
 
+/* Counter / stat register */
+#define MT7628_SDM_TPCNT	(MT7628_SDM_OFFSET + 0x100)
+#define MT7628_SDM_TBCNT	(MT7628_SDM_OFFSET + 0x104)
+#define MT7628_SDM_RPCNT	(MT7628_SDM_OFFSET + 0x108)
+#define MT7628_SDM_RBCNT	(MT7628_SDM_OFFSET + 0x10c)
+#define MT7628_SDM_CS_ERR	(MT7628_SDM_OFFSET + 0x110)
+
 struct mtk_rx_dma {
 	unsigned int rxd1;
 	unsigned int rxd2;
-- 
2.30.2



