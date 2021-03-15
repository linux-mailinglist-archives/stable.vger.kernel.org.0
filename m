Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D0533B717
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhCON7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhCON5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A01BA64F04;
        Mon, 15 Mar 2021 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816659;
        bh=r8HtgbF/cQ95EDCg2oD8jnD5gZUGEGfHeB9xaTP444E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qByLqHLnfjzxqf1YUG5KdGwk+psZmL3XaznpsX8ffEwOSs5a9QPKtUryQjofLDVOG
         wDPr5NV3NNJpZH1O5Tc0HNW1OdpVC2fHgerVUTTrQLW//B3Ka4jx3cPwh0sxvhg1AS
         qcJ1Ae8IWIa7mN5V9CBoVrTIEkGQLEsYsX/VLmIk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 039/290] net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
Date:   Mon, 15 Mar 2021 14:52:12 +0100
Message-Id: <20210315135543.245756061@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 827b6fd046516af605e190c872949f22208b5d41 upstream.

When the enetc ports have rx-vlan-offload enabled, they report a TPID of
ETH_P_8021Q regardless of what was actually in the packet. When
rx-vlan-offload is disabled, packets have the proper TPID. Fix this
inconsistency by finishing the TODO left in the code.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    |   34 ++++++++++++++++++------
 drivers/net/ethernet/freescale/enetc/enetc_hw.h |    3 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -563,9 +563,8 @@ static void enetc_get_rx_tstamp(struct n
 static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 			       union enetc_rx_bd *rxbd, struct sk_buff *skb)
 {
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
-#endif
+
 	/* TODO: hashing */
 	if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
 		u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
@@ -574,12 +573,31 @@ static void enetc_get_offloads(struct en
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
 
-	/* copy VLAN to skb, if one is extracted, for now we assume it's a
-	 * standard TPID, but HW also supports custom values
-	 */
-	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       le16_to_cpu(rxbd->r.vlan_opt));
+	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN) {
+		__be16 tpid = 0;
+
+		switch (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TPID) {
+		case 0:
+			tpid = htons(ETH_P_8021Q);
+			break;
+		case 1:
+			tpid = htons(ETH_P_8021AD);
+			break;
+		case 2:
+			tpid = htons(enetc_port_rd(&priv->si->hw,
+						   ENETC_PCVLANR1));
+			break;
+		case 3:
+			tpid = htons(enetc_port_rd(&priv->si->hw,
+						   ENETC_PCVLANR2));
+			break;
+		default:
+			break;
+		}
+
+		__vlan_hwaccel_put_tag(skb, tpid, le16_to_cpu(rxbd->r.vlan_opt));
+	}
+
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (priv->active_offloads & ENETC_F_RX_TSTAMP)
 		enetc_get_rx_tstamp(rx_ring->ndev, rxbd, skb);
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -172,6 +172,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIPMAR0(n)	(0x0100 + (n) * 0x8) /* n = SI index */
 #define ENETC_PSIPMAR1(n)	(0x0104 + (n) * 0x8)
 #define ENETC_PVCLCTR		0x0208
+#define ENETC_PCVLANR1		0x0210
+#define ENETC_PCVLANR2		0x0214
 #define ENETC_VLAN_TYPE_C	BIT(0)
 #define ENETC_VLAN_TYPE_S	BIT(1)
 #define ENETC_PVCLCTR_OVTPIDL(bmp)	((bmp) & 0xff) /* VLAN_TYPE */
@@ -575,6 +577,7 @@ union enetc_rx_bd {
 #define ENETC_RXBD_LSTATUS(flags)	((flags) << 16)
 #define ENETC_RXBD_FLAG_VLAN	BIT(9)
 #define ENETC_RXBD_FLAG_TSTMP	BIT(10)
+#define ENETC_RXBD_FLAG_TPID	GENMASK(1, 0)
 
 #define ENETC_MAC_ADDR_FILT_CNT	8 /* # of supported entries per port */
 #define EMETC_MAC_ADDR_FILT_RES	3 /* # of reserved entries at the beginning */


