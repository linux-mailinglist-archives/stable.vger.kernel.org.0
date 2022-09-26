Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0576C5EA215
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiIZLBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbiIZK7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC3146DB8;
        Mon, 26 Sep 2022 03:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C432EB8055F;
        Mon, 26 Sep 2022 10:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B67C433D7;
        Mon, 26 Sep 2022 10:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188285;
        bh=WQ/oCw0ahJH1olkyIOgr+AT9jHcDahmXUClJAqXf9hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGl4q41nf4wrRflv/z392a19Lch6irsh4i/84+e1czTfIgdtOXPquPtV1iNozDoZ+
         PojAitYw/lmS1ZZPmtQBY5zLO0hRJ/KehLAERiDAHdboaLfuZEnw4akZHYH99bCbck
         rSrNZhUj62AbvOvNPQBcfjrkfQDck/enB7jAqL0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/141] net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
Date:   Mon, 26 Sep 2022 12:12:07 +0200
Message-Id: <20220926100758.080501516@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit fed38e64d9b99d65a36c0dbadc3d3f8ddd9ea030 ]

The VF netdev driver shouldn't respond to changes in the NETIF_F_HW_TC
flag; only PFs should. Moreover, TSN-specific code should go to
enetc_qos.c, which should not be included in the VF driver.

Fixes: 79e499829f3f ("net: enetc: add hw tc hw offload features for PSPF capability")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220916133209.3351399-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 32 +------------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 ++++--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 11 ++++++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 23 +++++++++++++
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  4 ++-
 5 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 15aa3b3c0089..4af253825957 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1671,29 +1671,6 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 	return 0;
 }
 
-static int enetc_set_psfp(struct net_device *ndev, int en)
-{
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int err;
-
-	if (en) {
-		err = enetc_psfp_enable(priv);
-		if (err)
-			return err;
-
-		priv->active_offloads |= ENETC_F_QCI;
-		return 0;
-	}
-
-	err = enetc_psfp_disable(priv);
-	if (err)
-		return err;
-
-	priv->active_offloads &= ~ENETC_F_QCI;
-
-	return 0;
-}
-
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -1712,11 +1689,9 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
 }
 
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features)
+void enetc_set_features(struct net_device *ndev, netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
-	int err = 0;
 
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
@@ -1728,11 +1703,6 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
 		enetc_enable_txvlan(ndev,
 				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
-
-	if (changed & NETIF_F_HW_TC)
-		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
-
-	return err;
 }
 
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 15d19cbd5a95..00386c5d3cde 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -301,8 +301,7 @@ void enetc_start(struct net_device *ndev);
 void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features);
+void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
@@ -335,6 +334,7 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
 int enetc_psfp_init(struct enetc_ndev_priv *priv);
 int enetc_psfp_clean(struct enetc_ndev_priv *priv);
+int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
@@ -410,4 +410,9 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 {
 	return 0;
 }
+
+static inline int enetc_set_psfp(struct net_device *ndev, bool en)
+{
+	return 0;
+}
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 716b396bf094..6904e10dd46b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -671,6 +671,13 @@ static int enetc_pf_set_features(struct net_device *ndev,
 {
 	netdev_features_t changed = ndev->features ^ features;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (changed & NETIF_F_HW_TC) {
+		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+		if (err)
+			return err;
+	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
@@ -684,7 +691,9 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
 
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
 }
 
 static const struct net_device_ops enetc_ndev_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 9e6988fd3787..62efe1aebf86 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1525,6 +1525,29 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+int enetc_set_psfp(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (en) {
+		err = enetc_psfp_enable(priv);
+		if (err)
+			return err;
+
+		priv->active_offloads |= ENETC_F_QCI;
+		return 0;
+	}
+
+	err = enetc_psfp_disable(priv);
+	if (err)
+		return err;
+
+	priv->active_offloads &= ~ENETC_F_QCI;
+
+	return 0;
+}
+
 int enetc_psfp_init(struct enetc_ndev_priv *priv)
 {
 	if (epsfp.psfp_sfi_bitmap)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 33c125735db7..5ce3e2593bdd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -88,7 +88,9 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 static int enetc_vf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
 }
 
 /* Probing/ Init */
-- 
2.35.1



