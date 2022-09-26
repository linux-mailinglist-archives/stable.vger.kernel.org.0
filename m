Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6945EA4CA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbiIZLwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiIZLwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429835756E;
        Mon, 26 Sep 2022 03:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 205D5B80921;
        Mon, 26 Sep 2022 10:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FB6C433D6;
        Mon, 26 Sep 2022 10:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189274;
        bh=dajcyQw4EKzAi3lbGMv0e5CKmbyuC3ASPAqjMqLa+CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frsfYrKgNGiNUOx5pyGFBlIVHsiwgN8B1unLbU83XIG6xRnZCpi7Bq/RKwn22L+f1
         X7ZGt4n6stkCUg3SXU+lrEWGDdeaL6RlBKcU0B/EGl9zi9t6EawHEBIHObUYzIOIOr
         ut6nOJXO0kazMkMtbZla+BzuedL03KW51kFLGgqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 130/207] net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
Date:   Mon, 26 Sep 2022 12:11:59 +0200
Message-Id: <20220926100812.350004847@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
index 4470a4a3e4c3..3df099f6cbe0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2600,29 +2600,6 @@ static int enetc_set_rss(struct net_device *ndev, int en)
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
@@ -2641,11 +2618,9 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
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
@@ -2657,11 +2632,6 @@ int enetc_set_features(struct net_device *ndev,
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
index 29922c20531f..caa12509d06b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -393,8 +393,7 @@ void enetc_start(struct net_device *ndev);
 void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features);
+void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
@@ -465,6 +464,7 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
 int enetc_psfp_init(struct enetc_ndev_priv *priv);
 int enetc_psfp_clean(struct enetc_ndev_priv *priv);
+int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
@@ -540,4 +540,9 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
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
index c4a0e836d4f0..201b5f3f634e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -709,6 +709,13 @@ static int enetc_pf_set_features(struct net_device *ndev,
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
@@ -722,7 +729,9 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
 
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
 }
 
 static const struct net_device_ops enetc_ndev_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 582a663ed0ba..f8a2f02ce22d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1517,6 +1517,29 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
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
index 17924305afa2..4048101c42be 100644
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



