Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB18456FC4D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiGKJmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiGKJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:41:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936E997A29;
        Mon, 11 Jul 2022 02:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79F57CE1256;
        Mon, 11 Jul 2022 09:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A72C34115;
        Mon, 11 Jul 2022 09:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531258;
        bh=6wpvfPx7HWP4AWB4A4y3rp0pXm8akVz7duV++56Giq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEE1L3foD8tR2ox2gg+h1kneYCBqSzjRNDgK7jtqEXbzeXSAekae6xY5wcoCfssos
         kxEehL8NDC+5EjHMyMAa2hncCQv8ofSQSLuWmc7UOBQkn68Kz1f0ff31vmk7qYzzH9
         bc48TE2tmokEXhAiiIpHihj+a4zLdDj3tO4+1ai0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/230] qed: Improve the stack space of filter_config()
Date:   Mon, 11 Jul 2022 11:04:55 +0200
Message-Id: <20220711090605.192560383@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit f55e36d5ab76c3097ff36ecea60b91c6b0d80fc8 ]

As it was reported and discussed in: https://lore.kernel.org/lkml/CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com/
This patch improves the stack space of qede_config_rx_mode() by
splitting filter_config() to 3 functions and removing the
union qed_filter_type_params.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c      | 23 ++-------
 .../net/ethernet/qlogic/qede/qede_filter.c    | 47 ++++++++-----------
 include/linux/qed/qed_eth_if.h                | 21 ++++-----
 3 files changed, 30 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index dfaf10edfabf..ba8c7a31cce1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2763,25 +2763,6 @@ static int qed_configure_filter_mcast(struct qed_dev *cdev,
 	return qed_filter_mcast_cmd(cdev, &mcast, QED_SPQ_MODE_CB, NULL);
 }
 
-static int qed_configure_filter(struct qed_dev *cdev,
-				struct qed_filter_params *params)
-{
-	enum qed_filter_rx_mode_type accept_flags;
-
-	switch (params->type) {
-	case QED_FILTER_TYPE_UCAST:
-		return qed_configure_filter_ucast(cdev, &params->filter.ucast);
-	case QED_FILTER_TYPE_MCAST:
-		return qed_configure_filter_mcast(cdev, &params->filter.mcast);
-	case QED_FILTER_TYPE_RX_MODE:
-		accept_flags = params->filter.accept_flags;
-		return qed_configure_filter_rx_mode(cdev, accept_flags);
-	default:
-		DP_NOTICE(cdev, "Unknown filter type %d\n", (int)params->type);
-		return -EINVAL;
-	}
-}
-
 static int qed_configure_arfs_searcher(struct qed_dev *cdev,
 				       enum qed_filter_config_mode mode)
 {
@@ -2904,7 +2885,9 @@ static const struct qed_eth_ops qed_eth_ops_pass = {
 	.q_rx_stop = &qed_stop_rxq,
 	.q_tx_start = &qed_start_txq,
 	.q_tx_stop = &qed_stop_txq,
-	.filter_config = &qed_configure_filter,
+	.filter_config_rx_mode = &qed_configure_filter_rx_mode,
+	.filter_config_ucast = &qed_configure_filter_ucast,
+	.filter_config_mcast = &qed_configure_filter_mcast,
 	.fastpath_stop = &qed_fastpath_stop,
 	.eth_cqe_completion = &qed_fp_cqe_completion,
 	.get_vport_stats = &qed_get_vport_stats,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index a2e4dfb5cb44..f99b085b56a5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -619,30 +619,28 @@ static int qede_set_ucast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
 				 unsigned char mac[ETH_ALEN])
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_ucast_params ucast;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_UCAST;
-	filter_cmd.filter.ucast.type = opcode;
-	filter_cmd.filter.ucast.mac_valid = 1;
-	ether_addr_copy(filter_cmd.filter.ucast.mac, mac);
+	memset(&ucast, 0, sizeof(ucast));
+	ucast.type = opcode;
+	ucast.mac_valid = 1;
+	ether_addr_copy(ucast.mac, mac);
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_ucast(edev->cdev, &ucast);
 }
 
 static int qede_set_ucast_rx_vlan(struct qede_dev *edev,
 				  enum qed_filter_xcast_params_type opcode,
 				  u16 vid)
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_ucast_params ucast;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_UCAST;
-	filter_cmd.filter.ucast.type = opcode;
-	filter_cmd.filter.ucast.vlan_valid = 1;
-	filter_cmd.filter.ucast.vlan = vid;
+	memset(&ucast, 0, sizeof(ucast));
+	ucast.type = opcode;
+	ucast.vlan_valid = 1;
+	ucast.vlan = vid;
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_ucast(edev->cdev, &ucast);
 }
 
 static int qede_config_accept_any_vlan(struct qede_dev *edev, bool action)
@@ -1057,18 +1055,17 @@ static int qede_set_mcast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
 				 unsigned char *mac, int num_macs)
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_mcast_params mcast;
 	int i;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_MCAST;
-	filter_cmd.filter.mcast.type = opcode;
-	filter_cmd.filter.mcast.num = num_macs;
+	memset(&mcast, 0, sizeof(mcast));
+	mcast.type = opcode;
+	mcast.num = num_macs;
 
 	for (i = 0; i < num_macs; i++, mac += ETH_ALEN)
-		ether_addr_copy(filter_cmd.filter.mcast.mac[i], mac);
+		ether_addr_copy(mcast.mac[i], mac);
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_mcast(edev->cdev, &mcast);
 }
 
 int qede_set_mac_addr(struct net_device *ndev, void *p)
@@ -1194,7 +1191,6 @@ void qede_config_rx_mode(struct net_device *ndev)
 {
 	enum qed_filter_rx_mode_type accept_flags;
 	struct qede_dev *edev = netdev_priv(ndev);
-	struct qed_filter_params rx_mode;
 	unsigned char *uc_macs, *temp;
 	struct netdev_hw_addr *ha;
 	int rc, uc_count;
@@ -1220,10 +1216,6 @@ void qede_config_rx_mode(struct net_device *ndev)
 
 	netif_addr_unlock_bh(ndev);
 
-	/* Configure the struct for the Rx mode */
-	memset(&rx_mode, 0, sizeof(struct qed_filter_params));
-	rx_mode.type = QED_FILTER_TYPE_RX_MODE;
-
 	/* Remove all previous unicast secondary macs and multicast macs
 	 * (configure / leave the primary mac)
 	 */
@@ -1271,8 +1263,7 @@ void qede_config_rx_mode(struct net_device *ndev)
 		qede_config_accept_any_vlan(edev, false);
 	}
 
-	rx_mode.filter.accept_flags = accept_flags;
-	edev->ops->filter_config(edev->cdev, &rx_mode);
+	edev->ops->filter_config_rx_mode(edev->cdev, accept_flags);
 out:
 	kfree(uc_macs);
 }
diff --git a/include/linux/qed/qed_eth_if.h b/include/linux/qed/qed_eth_if.h
index 812a4d751163..4df0bf0a0864 100644
--- a/include/linux/qed/qed_eth_if.h
+++ b/include/linux/qed/qed_eth_if.h
@@ -145,12 +145,6 @@ struct qed_filter_mcast_params {
 	unsigned char mac[64][ETH_ALEN];
 };
 
-union qed_filter_type_params {
-	enum qed_filter_rx_mode_type accept_flags;
-	struct qed_filter_ucast_params ucast;
-	struct qed_filter_mcast_params mcast;
-};
-
 enum qed_filter_type {
 	QED_FILTER_TYPE_UCAST,
 	QED_FILTER_TYPE_MCAST,
@@ -158,11 +152,6 @@ enum qed_filter_type {
 	QED_MAX_FILTER_TYPES,
 };
 
-struct qed_filter_params {
-	enum qed_filter_type type;
-	union qed_filter_type_params filter;
-};
-
 struct qed_tunn_params {
 	u16 vxlan_port;
 	u8 update_vxlan_port;
@@ -314,8 +303,14 @@ struct qed_eth_ops {
 
 	int (*q_tx_stop)(struct qed_dev *cdev, u8 rss_id, void *handle);
 
-	int (*filter_config)(struct qed_dev *cdev,
-			     struct qed_filter_params *params);
+	int (*filter_config_rx_mode)(struct qed_dev *cdev,
+				     enum qed_filter_rx_mode_type type);
+
+	int (*filter_config_ucast)(struct qed_dev *cdev,
+				   struct qed_filter_ucast_params *params);
+
+	int (*filter_config_mcast)(struct qed_dev *cdev,
+				   struct qed_filter_mcast_params *params);
 
 	int (*fastpath_stop)(struct qed_dev *cdev);
 
-- 
2.35.1



