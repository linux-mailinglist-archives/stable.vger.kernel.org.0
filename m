Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7B82171B6
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgGGPY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbgGGPY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8102078D;
        Tue,  7 Jul 2020 15:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135467;
        bh=UwEqrjqoTq75tKEp9ZpwiITGAJv3OcuzNOfpj83czJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VnJU+D9rud0zzNiQggBpguim3oqZoNCY5YGcxLV2izNN6+UqIaXGgxP338+fTt/r
         1ir9D3sSykx+BIZUOyJQJfuUi+z7CLpJjvts/Sk5stHiwk6iAeUwvYL5yxtUWpCrIe
         jm5bzf8J4YshHQJzPVX08EWc20vK3jIeQBFmWoMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 052/112] enetc: Fix HW_VLAN_CTAG_TX|RX toggling
Date:   Tue,  7 Jul 2020 17:16:57 +0200
Message-Id: <20200707145803.476183728@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 9deba33f1b7266a3870c9da31f787b605748fc0c ]

VLAN tag insertion/extraction offload is correctly
activated at probe time but deactivation of this feature
(i.e. via ethtool) is broken.  Toggling works only for
Tx/Rx ring 0 of a PF, and is ignored for the other rings,
including the VF rings.
To fix this, the existing VLAN offload toggling code
was extended to all the rings assigned to a netdevice,
instead of the default ring 0 (likely a leftover from the
early validation days of this feature).  And the code was
moved to the common set_features() function to fix toggling
for the VF driver too.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 26 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 16 ++++++------
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  9 -------
 3 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9ac5cccfe0204..a7e4274d3f402 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1587,6 +1587,24 @@ static int enetc_set_psfp(struct net_device *ndev, int en)
 	return 0;
 }
 
+static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int i;
+
+	for (i = 0; i < priv->num_rx_rings; i++)
+		enetc_bdr_enable_rxvlan(&priv->si->hw, i, en);
+}
+
+static void enetc_enable_txvlan(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
+}
+
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
@@ -1595,6 +1613,14 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+		enetc_enable_rxvlan(ndev,
+				    !!(features & NETIF_F_HW_VLAN_CTAG_RX));
+
+	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
+		enetc_enable_txvlan(ndev,
+				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
+
 	if (changed & NETIF_F_HW_TC)
 		enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 587974862f488..02efda266c468 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -531,22 +531,22 @@ struct enetc_msg_cmd_header {
 
 /* Common H/W utility functions */
 
-static inline void enetc_enable_rxvlan(struct enetc_hw *hw, int si_idx,
-				       bool en)
+static inline void enetc_bdr_enable_rxvlan(struct enetc_hw *hw, int idx,
+					   bool en)
 {
-	u32 val = enetc_rxbdr_rd(hw, si_idx, ENETC_RBMR);
+	u32 val = enetc_rxbdr_rd(hw, idx, ENETC_RBMR);
 
 	val = (val & ~ENETC_RBMR_VTE) | (en ? ENETC_RBMR_VTE : 0);
-	enetc_rxbdr_wr(hw, si_idx, ENETC_RBMR, val);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, val);
 }
 
-static inline void enetc_enable_txvlan(struct enetc_hw *hw, int si_idx,
-				       bool en)
+static inline void enetc_bdr_enable_txvlan(struct enetc_hw *hw, int idx,
+					   bool en)
 {
-	u32 val = enetc_txbdr_rd(hw, si_idx, ENETC_TBMR);
+	u32 val = enetc_txbdr_rd(hw, idx, ENETC_TBMR);
 
 	val = (val & ~ENETC_TBMR_VIH) | (en ? ENETC_TBMR_VIH : 0);
-	enetc_txbdr_wr(hw, si_idx, ENETC_TBMR, val);
+	enetc_txbdr_wr(hw, idx, ENETC_TBMR, val);
 }
 
 static inline void enetc_set_bdr_prio(struct enetc_hw *hw, int bdr_idx,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index eacd597b55f22..438648a06f2ae 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -667,15 +667,6 @@ static int enetc_pf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
-		enetc_enable_rxvlan(&priv->si->hw, 0,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_RX));
-
-	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
-		enetc_enable_txvlan(&priv->si->hw, 0,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
 
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
-- 
2.25.1



