Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223C83960E6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhEaOdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233210AbhEaObF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B9861585;
        Mon, 31 May 2021 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468930;
        bh=z6NA4bIa26BOxeOeMk+KqbOxp4/JoT64XtlLNQrmsEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUFLcQ+UxTLi7UndY+bXjNjw5pZjXOEeQ+cazOYexhV8Gk0sSfwuNNz8+NC0Oh82k
         i54VkI+YR3L2zU7LiGjiUBI3/nZtgDJzeu3B0DjW7MyBXIs+NGT43+0LUW2WxQSEMT
         i5BoLWM+ko2Pq92jk9whwY/bJjDxX0whOYaxxMak=
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
Subject: [PATCH 5.4 166/177] net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88
Date:   Mon, 31 May 2021 15:15:23 +0200
Message-Id: <20210531130653.655300340@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index 7e3806fd70b2..48b395b9c15a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -675,32 +675,53 @@ static int mtk_set_mac_address(struct net_device *dev, void *p)
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
index 1e9202b34d35..c0b2768b480f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -264,8 +264,21 @@
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
@@ -476,6 +489,13 @@
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



