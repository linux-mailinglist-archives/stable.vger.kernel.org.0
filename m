Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0671D217120
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgGGPY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgGGPYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38DB1207D0;
        Tue,  7 Jul 2020 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135464;
        bh=G+rAMT6LhkOWlncqszbebKQ70fqYSaj8mZENtE+BSoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRB6qZ0Wf+uK1Zs/uppBtoHqvG21VYQD0qRtW7wE7/vvIg8WjMDkP8mk40Hnazneg
         Lc6fJ36iky+UL08ouDKHkCje6swb9EZcf1lkuVixTsUzWRRIkbWzWmGebtbm1JIHd7
         mx1StRSw0p/WMGRWTLc95JGM4C9qazDVZfbTJcZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po Liu <Po.Liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 051/112] net: enetc: add hw tc hw offload features for PSPF capability
Date:   Tue,  7 Jul 2020 17:16:56 +0200
Message-Id: <20200707145803.429515727@linuxfoundation.org>
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

From: Po Liu <Po.Liu@nxp.com>

[ Upstream commit 79e499829f3ff5b8f70c87baf1b03ebb3401a3e4 ]

This patch is to let ethtool enable/disable the tc flower offload
features. Hardware ENETC has the feature of PSFP which is for per-stream
policing. When enable the tc hw offloading feature, driver would enable
the IEEE 802.1Qci feature. It is only set the register enable bit for
this feature not enable for any entry of per stream filtering and stream
gate or stream identify but get how much capabilities for each feature.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 23 +++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  | 48 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 17 +++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  8 ++++
 4 files changed, 96 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4486a0db8ef0c..9ac5cccfe0204 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -756,6 +756,9 @@ void enetc_get_si_caps(struct enetc_si *si)
 
 	if (val & ENETC_SIPCAPR0_QBV)
 		si->hw_features |= ENETC_SI_F_QBV;
+
+	if (val & ENETC_SIPCAPR0_PSFP)
+		si->hw_features |= ENETC_SI_F_PSFP;
 }
 
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
@@ -1567,6 +1570,23 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 	return 0;
 }
 
+static int enetc_set_psfp(struct net_device *ndev, int en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+
+	if (en) {
+		priv->active_offloads |= ENETC_F_QCI;
+		enetc_get_max_cap(priv);
+		enetc_psfp_enable(&priv->si->hw);
+	} else {
+		priv->active_offloads &= ~ENETC_F_QCI;
+		memset(&priv->psfp_cap, 0, sizeof(struct psfp_cap));
+		enetc_psfp_disable(&priv->si->hw);
+	}
+
+	return 0;
+}
+
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
@@ -1575,6 +1595,9 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
+	if (changed & NETIF_F_HW_TC)
+		enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 56c43f35b633b..2cfe877c37786 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -151,6 +151,7 @@ enum enetc_errata {
 };
 
 #define ENETC_SI_F_QBV BIT(0)
+#define ENETC_SI_F_PSFP BIT(1)
 
 /* PCI IEP device data */
 struct enetc_si {
@@ -203,12 +204,20 @@ struct enetc_cls_rule {
 };
 
 #define ENETC_MAX_BDR_INT	2 /* fixed to max # of available cpus */
+struct psfp_cap {
+	u32 max_streamid;
+	u32 max_psfp_filter;
+	u32 max_psfp_gate;
+	u32 max_psfp_gatelist;
+	u32 max_psfp_meter;
+};
 
 /* TODO: more hardware offloads */
 enum enetc_active_offloads {
 	ENETC_F_RX_TSTAMP	= BIT(0),
 	ENETC_F_TX_TSTAMP	= BIT(1),
 	ENETC_F_QBV             = BIT(2),
+	ENETC_F_QCI		= BIT(3),
 };
 
 struct enetc_ndev_priv {
@@ -231,6 +240,8 @@ struct enetc_ndev_priv {
 
 	struct enetc_cls_rule *cls_rules;
 
+	struct psfp_cap psfp_cap;
+
 	struct device_node *phy_node;
 	phy_interface_t if_mode;
 };
@@ -289,9 +300,46 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
+
+static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
+{
+	u32 reg;
+
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PSIDCAPR);
+	priv->psfp_cap.max_streamid = reg & ENETC_PSIDCAPR_MSK;
+	/* Port stream filter capability */
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PSFCAPR);
+	priv->psfp_cap.max_psfp_filter = reg & ENETC_PSFCAPR_MSK;
+	/* Port stream gate capability */
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PSGCAPR);
+	priv->psfp_cap.max_psfp_gate = (reg & ENETC_PSGCAPR_SGIT_MSK);
+	priv->psfp_cap.max_psfp_gatelist = (reg & ENETC_PSGCAPR_GCL_MSK) >> 16;
+	/* Port flow meter capability */
+	reg = enetc_port_rd(&priv->si->hw, ENETC_PFMCAPR);
+	priv->psfp_cap.max_psfp_meter = reg & ENETC_PFMCAPR_MSK;
+}
+
+static inline void enetc_psfp_enable(struct enetc_hw *hw)
+{
+	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR) |
+		 ENETC_PPSFPMR_PSFPEN | ENETC_PPSFPMR_VS |
+		 ENETC_PPSFPMR_PVC | ENETC_PPSFPMR_PVZC);
+}
+
+static inline void enetc_psfp_disable(struct enetc_hw *hw)
+{
+	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR) &
+		 ~ENETC_PPSFPMR_PSFPEN & ~ENETC_PPSFPMR_VS &
+		 ~ENETC_PPSFPMR_PVC & ~ENETC_PPSFPMR_PVZC);
+}
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
+#define enetc_get_max_cap(p)		\
+	memset(&((p)->psfp_cap), 0, sizeof(struct psfp_cap))
+
+#define enetc_psfp_enable(hw) (void)0
+#define enetc_psfp_disable(hw) (void)0
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 2a6523136947d..587974862f488 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -19,6 +19,7 @@
 #define ENETC_SICTR1	0x1c
 #define ENETC_SIPCAPR0	0x20
 #define ENETC_SIPCAPR0_QBV	BIT(4)
+#define ENETC_SIPCAPR0_PSFP	BIT(9)
 #define ENETC_SIPCAPR0_RSS	BIT(8)
 #define ENETC_SIPCAPR1	0x24
 #define ENETC_SITGTGR	0x30
@@ -228,6 +229,15 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
 #define ENETC_PM0_IFM_RGAUTO	(BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
 #define ENETC_PM0_IFM_XGMII	BIT(12)
+#define ENETC_PSIDCAPR		0x1b08
+#define ENETC_PSIDCAPR_MSK	GENMASK(15, 0)
+#define ENETC_PSFCAPR		0x1b18
+#define ENETC_PSFCAPR_MSK	GENMASK(15, 0)
+#define ENETC_PSGCAPR		0x1b28
+#define ENETC_PSGCAPR_GCL_MSK	GENMASK(18, 16)
+#define ENETC_PSGCAPR_SGIT_MSK	GENMASK(15, 0)
+#define ENETC_PFMCAPR		0x1b38
+#define ENETC_PFMCAPR_MSK	GENMASK(15, 0)
 
 /* MAC counters */
 #define ENETC_PM0_REOCT		0x8100
@@ -621,3 +631,10 @@ struct enetc_cbd {
 /* Port time specific departure */
 #define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
 #define ENETC_TSDE		BIT(31)
+
+/* PSFP setting */
+#define ENETC_PPSFPMR 0x11b00
+#define ENETC_PPSFPMR_PSFPEN BIT(0)
+#define ENETC_PPSFPMR_VS BIT(1)
+#define ENETC_PPSFPMR_PVC BIT(2)
+#define ENETC_PPSFPMR_PVZC BIT(3)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 85e2b741df414..eacd597b55f22 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -739,6 +739,14 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	if (si->hw_features & ENETC_SI_F_QBV)
 		priv->active_offloads |= ENETC_F_QBV;
 
+	if (si->hw_features & ENETC_SI_F_PSFP) {
+		priv->active_offloads |= ENETC_F_QCI;
+		ndev->features |= NETIF_F_HW_TC;
+		ndev->hw_features |= NETIF_F_HW_TC;
+		enetc_get_max_cap(priv);
+		enetc_psfp_enable(&si->hw);
+	}
+
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
-- 
2.25.1



