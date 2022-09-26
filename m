Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFB25EA349
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiIZLW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiIZLVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0922C67164;
        Mon, 26 Sep 2022 03:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D734260BB7;
        Mon, 26 Sep 2022 10:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E30C433D6;
        Mon, 26 Sep 2022 10:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188707;
        bh=NI1KVVdpCcaD/rkhIBvb6loFYvP+w155ya0gBH6kW10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L42KWepWKCu5QCscxMB4UZxmH2vmB9w1ZAUNiFfxWTs2djjC3gTSRzAbcoxj7u/cB
         UKLubkCbNSlh2ssBq3eGXVPc7ran/z9tHQkWhACG+5E0Uita3w0Y+F/a29ncw15Ty1
         r37lnZXb8he2uPLGlBj9o6KfQGRfOkHtuMawNbxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/148] net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
Date:   Mon, 26 Sep 2022 12:12:10 +0200
Message-Id: <20220926100759.677969818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
index 042327b9981f..bd840061ba8f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2307,29 +2307,6 @@ static int enetc_set_rss(struct net_device *ndev, int en)
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
@@ -2348,11 +2325,9 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
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
@@ -2364,11 +2339,6 @@ int enetc_set_features(struct net_device *ndev,
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
index 08b283347d9c..5cacda8b4ef0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -385,8 +385,7 @@ void enetc_start(struct net_device *ndev);
 void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features);
+void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
@@ -421,6 +420,7 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
 int enetc_psfp_init(struct enetc_ndev_priv *priv);
 int enetc_psfp_clean(struct enetc_ndev_priv *priv);
+int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
@@ -496,4 +496,9 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
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
index d522bd5c90b4..36f5abd1c61b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -708,6 +708,13 @@ static int enetc_pf_set_features(struct net_device *ndev,
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
@@ -721,7 +728,9 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
 
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
 }
 
 static const struct net_device_ops enetc_ndev_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index d779dde522c8..6b236e0fd806 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1529,6 +1529,29 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
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
index 1a9d1e8b772c..8daea3a776b5 100644
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



