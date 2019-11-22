Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F27106CF5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfKVK4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730574AbfKVK4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1551620706;
        Fri, 22 Nov 2019 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420180;
        bh=WNsF6Bm/ucOCzZ4B1FgoNMBmvHRd5PQZhX2EkWDEkZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0Wnp1xD60qiLbMK9db9c1hMFz6dSRxJBdq3vNYABen1+HTbDHxFCM5MtIbZL4P4l
         dixfCTmKJYW82UUhDn/Rt9pX7fPiL7/Kuk8wddDyYcNeFoCQ5X1Qa7qphg5F4P0l/4
         eh4oFcErYn9hAWRaIdjNiZJ7CbnhaNm/y4g6y3yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/220] net: hns3: Fix loss of coal configuration while doing reset
Date:   Fri, 22 Nov 2019 11:26:25 +0100
Message-Id: <20191122100913.970593305@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit e4fd75022c24eb28cc1034e97e60cecc24f325f3 ]

The user's coal configuration will be lost after reset, so the tx_coal
and rx_coal fields are added to the struct hns_nic_priv to save the coal
configuration and used to restore the user's configuration after the reset
is complete.

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 71 +++++++++----------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 +
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a5e3d38f18230..15030df574a8b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -195,8 +195,6 @@ void hns3_set_vector_coalesce_tx_gl(struct hns3_enet_tqp_vector *tqp_vector,
 static void hns3_vector_gl_rl_init(struct hns3_enet_tqp_vector *tqp_vector,
 				   struct hns3_nic_priv *priv)
 {
-	struct hnae3_handle *h = priv->ae_handle;
-
 	/* initialize the configuration for interrupt coalescing.
 	 * 1. GL (Interrupt Gap Limiter)
 	 * 2. RL (Interrupt Rate Limiter)
@@ -209,9 +207,6 @@ static void hns3_vector_gl_rl_init(struct hns3_enet_tqp_vector *tqp_vector,
 	tqp_vector->tx_group.coal.int_gl = HNS3_INT_GL_50K;
 	tqp_vector->rx_group.coal.int_gl = HNS3_INT_GL_50K;
 
-	/* Default: disable RL */
-	h->kinfo.int_rl_setting = 0;
-
 	tqp_vector->int_adapt_down = HNS3_INT_ADAPT_DOWN_START;
 	tqp_vector->rx_group.coal.flow_level = HNS3_FLOW_LOW;
 	tqp_vector->tx_group.coal.flow_level = HNS3_FLOW_LOW;
@@ -3423,6 +3418,31 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 	return 0;
 }
 
+static void hns3_store_coal(struct hns3_nic_priv *priv)
+{
+	/* ethtool only support setting and querying one coal
+	 * configuation for now, so save the vector 0' coal
+	 * configuation here in order to restore it.
+	 */
+	memcpy(&priv->tx_coal, &priv->tqp_vector[0].tx_group.coal,
+	       sizeof(struct hns3_enet_coalesce));
+	memcpy(&priv->rx_coal, &priv->tqp_vector[0].rx_group.coal,
+	       sizeof(struct hns3_enet_coalesce));
+}
+
+static void hns3_restore_coal(struct hns3_nic_priv *priv)
+{
+	u16 vector_num = priv->vector_num;
+	int i;
+
+	for (i = 0; i < vector_num; i++) {
+		memcpy(&priv->tqp_vector[i].tx_group.coal, &priv->tx_coal,
+		       sizeof(struct hns3_enet_coalesce));
+		memcpy(&priv->tqp_vector[i].rx_group.coal, &priv->rx_coal,
+		       sizeof(struct hns3_enet_coalesce));
+	}
+}
+
 static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
@@ -3469,6 +3489,8 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	/* Carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
 
+	hns3_restore_coal(priv);
+
 	ret = hns3_nic_init_vector_data(priv);
 	if (ret)
 		return ret;
@@ -3496,6 +3518,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return ret;
 	}
 
+	hns3_store_coal(priv);
+
 	ret = hns3_uninit_all_ring(priv);
 	if (ret)
 		netdev_err(netdev, "uninit ring error\n");
@@ -3530,24 +3554,7 @@ static int hns3_reset_notify(struct hnae3_handle *handle,
 	return ret;
 }
 
-static void hns3_restore_coal(struct hns3_nic_priv *priv,
-			      struct hns3_enet_coalesce *tx,
-			      struct hns3_enet_coalesce *rx)
-{
-	u16 vector_num = priv->vector_num;
-	int i;
-
-	for (i = 0; i < vector_num; i++) {
-		memcpy(&priv->tqp_vector[i].tx_group.coal, tx,
-		       sizeof(struct hns3_enet_coalesce));
-		memcpy(&priv->tqp_vector[i].rx_group.coal, rx,
-		       sizeof(struct hns3_enet_coalesce));
-	}
-}
-
-static int hns3_modify_tqp_num(struct net_device *netdev, u16 new_tqp_num,
-			       struct hns3_enet_coalesce *tx,
-			       struct hns3_enet_coalesce *rx)
+static int hns3_modify_tqp_num(struct net_device *netdev, u16 new_tqp_num)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -3565,7 +3572,7 @@ static int hns3_modify_tqp_num(struct net_device *netdev, u16 new_tqp_num,
 	if (ret)
 		goto err_alloc_vector;
 
-	hns3_restore_coal(priv, tx, rx);
+	hns3_restore_coal(priv);
 
 	ret = hns3_nic_init_vector_data(priv);
 	if (ret)
@@ -3597,7 +3604,6 @@ int hns3_set_channels(struct net_device *netdev,
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_knic_private_info *kinfo = &h->kinfo;
-	struct hns3_enet_coalesce tx_coal, rx_coal;
 	bool if_running = netif_running(netdev);
 	u32 new_tqp_num = ch->combined_count;
 	u16 org_tqp_num;
@@ -3629,15 +3635,7 @@ int hns3_set_channels(struct net_device *netdev,
 		goto open_netdev;
 	}
 
-	/* Changing the tqp num may also change the vector num,
-	 * ethtool only support setting and querying one coal
-	 * configuation for now, so save the vector 0' coal
-	 * configuation here in order to restore it.
-	 */
-	memcpy(&tx_coal, &priv->tqp_vector[0].tx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
-	memcpy(&rx_coal, &priv->tqp_vector[0].rx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
+	hns3_store_coal(priv);
 
 	hns3_nic_dealloc_vector_data(priv);
 
@@ -3645,10 +3643,9 @@ int hns3_set_channels(struct net_device *netdev,
 	hns3_put_ring_config(priv);
 
 	org_tqp_num = h->kinfo.num_tqps;
-	ret = hns3_modify_tqp_num(netdev, new_tqp_num, &tx_coal, &rx_coal);
+	ret = hns3_modify_tqp_num(netdev, new_tqp_num);
 	if (ret) {
-		ret = hns3_modify_tqp_num(netdev, org_tqp_num,
-					  &tx_coal, &rx_coal);
+		ret = hns3_modify_tqp_num(netdev, org_tqp_num);
 		if (ret) {
 			/* If revert to old tqp failed, fatal error occurred */
 			dev_err(&netdev->dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index cb450d7ec8c16..94d7446811d5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -541,6 +541,8 @@ struct hns3_nic_priv {
 	/* Vxlan/Geneve information */
 	struct hns3_udp_tunnel udp_tnl[HNS3_UDP_TNL_MAX];
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+	struct hns3_enet_coalesce tx_coal;
+	struct hns3_enet_coalesce rx_coal;
 };
 
 union l3_hdr_info {
-- 
2.20.1



