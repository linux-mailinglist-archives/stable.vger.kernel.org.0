Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41B7396293
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhEaO6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhEaOzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 078B561CBA;
        Mon, 31 May 2021 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469598;
        bh=Hi+30ExrblWobhdBbN9mRWshWlplx/CZTcmdSV/PDdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cnci77VpT/UP4ZAtOLdpT7sUXS7xYh8UzcAJDBvY63EtL0uq14pp9OyMsn7FB1Y/Y
         GMVy5omOkxw5aJPy2F8+vXJnmtwW+0ZkkDZL59deeDisHfcGbpVdQ1dx2oCAl7f2Uy
         UeQGKaDEvYBsnWHmCCinrgtP0stVxTeQkxnoiGcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 260/296] net: hns3: fix users coalesce configuration lost issue
Date:   Mon, 31 May 2021 15:15:15 +0200
Message-Id: <20210531130712.496027235@linuxfoundation.org>
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

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 73a13d8dbe33e53a12400f2be0f5af169816c67f ]

Currently, when adaptive is on, the user's coalesce configuration
may be overwritten by the dynamic one. The reason is that user's
configurations are saved in struct hns3_enet_tqp_vector whose
value maybe changed by the dynamic algorithm. To fix it, use
struct hns3_nic_priv instead of struct hns3_enet_tqp_vector to
save and get the user's configuration.

BTW, operations of storing and restoring coalesce info in the reset
process are unnecessary now, so remove them as well.

Fixes: 434776a5fae2 ("net: hns3: add ethtool_ops.set_coalesce support to PF")
Fixes: 7e96adc46633 ("net: hns3: add ethtool_ops.get_coalesce support to PF")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 84 +++++++++----------
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 64 +++++---------
 2 files changed, 63 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cd37f0e35431..46baf282fe0a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -265,22 +265,17 @@ static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
 	struct hns3_enet_coalesce *tx_coal = &tqp_vector->tx_group.coal;
 	struct hns3_enet_coalesce *rx_coal = &tqp_vector->rx_group.coal;
+	struct hns3_enet_coalesce *ptx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *prx_coal = &priv->rx_coal;
 
-	/* initialize the configuration for interrupt coalescing.
-	 * 1. GL (Interrupt Gap Limiter)
-	 * 2. RL (Interrupt Rate Limiter)
-	 * 3. QL (Interrupt Quantity Limiter)
-	 *
-	 * Default: enable interrupt coalescing self-adaptive and GL
-	 */
-	tx_coal->adapt_enable = 1;
-	rx_coal->adapt_enable = 1;
+	tx_coal->adapt_enable = ptx_coal->adapt_enable;
+	rx_coal->adapt_enable = prx_coal->adapt_enable;
 
-	tx_coal->int_gl = HNS3_INT_GL_50K;
-	rx_coal->int_gl = HNS3_INT_GL_50K;
+	tx_coal->int_gl = ptx_coal->int_gl;
+	rx_coal->int_gl = prx_coal->int_gl;
 
-	rx_coal->flow_level = HNS3_FLOW_LOW;
-	tx_coal->flow_level = HNS3_FLOW_LOW;
+	rx_coal->flow_level = prx_coal->flow_level;
+	tx_coal->flow_level = ptx_coal->flow_level;
 
 	/* device version above V3(include V3), GL can configure 1us
 	 * unit, so uses 1us unit.
@@ -295,8 +290,8 @@ static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
 		rx_coal->ql_enable = 1;
 		tx_coal->int_ql_max = ae_dev->dev_specs.int_ql_max;
 		rx_coal->int_ql_max = ae_dev->dev_specs.int_ql_max;
-		tx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
-		rx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+		tx_coal->int_ql = ptx_coal->int_ql;
+		rx_coal->int_ql = prx_coal->int_ql;
 	}
 }
 
@@ -3805,6 +3800,34 @@ map_ring_fail:
 	return ret;
 }
 
+static void hns3_nic_init_coal_cfg(struct hns3_nic_priv *priv)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
+	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
+
+	/* initialize the configuration for interrupt coalescing.
+	 * 1. GL (Interrupt Gap Limiter)
+	 * 2. RL (Interrupt Rate Limiter)
+	 * 3. QL (Interrupt Quantity Limiter)
+	 *
+	 * Default: enable interrupt coalescing self-adaptive and GL
+	 */
+	tx_coal->adapt_enable = 1;
+	rx_coal->adapt_enable = 1;
+
+	tx_coal->int_gl = HNS3_INT_GL_50K;
+	rx_coal->int_gl = HNS3_INT_GL_50K;
+
+	rx_coal->flow_level = HNS3_FLOW_LOW;
+	tx_coal->flow_level = HNS3_FLOW_LOW;
+
+	if (ae_dev->dev_specs.int_ql_max) {
+		tx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+		rx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+	}
+}
+
 static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
 {
 	struct hnae3_handle *h = priv->ae_handle;
@@ -4265,6 +4288,8 @@ static int hns3_client_init(struct hnae3_handle *handle)
 		goto out_get_ring_cfg;
 	}
 
+	hns3_nic_init_coal_cfg(priv);
+
 	ret = hns3_nic_alloc_vector_data(priv);
 	if (ret) {
 		ret = -ENOMEM;
@@ -4543,31 +4568,6 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 	return 0;
 }
 
-static void hns3_store_coal(struct hns3_nic_priv *priv)
-{
-	/* ethtool only support setting and querying one coal
-	 * configuration for now, so save the vector 0' coal
-	 * configuration here in order to restore it.
-	 */
-	memcpy(&priv->tx_coal, &priv->tqp_vector[0].tx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
-	memcpy(&priv->rx_coal, &priv->tqp_vector[0].rx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
-}
-
-static void hns3_restore_coal(struct hns3_nic_priv *priv)
-{
-	u16 vector_num = priv->vector_num;
-	int i;
-
-	for (i = 0; i < vector_num; i++) {
-		memcpy(&priv->tqp_vector[i].tx_group.coal, &priv->tx_coal,
-		       sizeof(struct hns3_enet_coalesce));
-		memcpy(&priv->tqp_vector[i].rx_group.coal, &priv->rx_coal,
-		       sizeof(struct hns3_enet_coalesce));
-	}
-}
-
 static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
@@ -4626,8 +4626,6 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	if (ret)
 		goto err_put_ring;
 
-	hns3_restore_coal(priv);
-
 	ret = hns3_nic_init_vector_data(priv);
 	if (ret)
 		goto err_dealloc_vector;
@@ -4693,8 +4691,6 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 
 	hns3_nic_uninit_vector_data(priv);
 
-	hns3_store_coal(priv);
-
 	hns3_nic_dealloc_vector_data(priv);
 
 	hns3_uninit_all_ring(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index d20f2e246017..5b051df3429f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1119,50 +1119,32 @@ static void hns3_get_channels(struct net_device *netdev,
 		h->ae_algo->ops->get_channels(h, ch);
 }
 
-static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
-				       struct ethtool_coalesce *cmd)
+static int hns3_get_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *cmd)
 {
-	struct hns3_enet_tqp_vector *tx_vector, *rx_vector;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
 	struct hnae3_handle *h = priv->ae_handle;
-	u16 queue_num = h->kinfo.num_tqps;
 
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
-	if (queue >= queue_num) {
-		netdev_err(netdev,
-			   "Invalid queue value %u! Queue max id=%u\n",
-			   queue, queue_num - 1);
-		return -EINVAL;
-	}
-
-	tx_vector = priv->ring[queue].tqp_vector;
-	rx_vector = priv->ring[queue_num + queue].tqp_vector;
+	cmd->use_adaptive_tx_coalesce = tx_coal->adapt_enable;
+	cmd->use_adaptive_rx_coalesce = rx_coal->adapt_enable;
 
-	cmd->use_adaptive_tx_coalesce =
-			tx_vector->tx_group.coal.adapt_enable;
-	cmd->use_adaptive_rx_coalesce =
-			rx_vector->rx_group.coal.adapt_enable;
-
-	cmd->tx_coalesce_usecs = tx_vector->tx_group.coal.int_gl;
-	cmd->rx_coalesce_usecs = rx_vector->rx_group.coal.int_gl;
+	cmd->tx_coalesce_usecs = tx_coal->int_gl;
+	cmd->rx_coalesce_usecs = rx_coal->int_gl;
 
 	cmd->tx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 	cmd->rx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 
-	cmd->tx_max_coalesced_frames = tx_vector->tx_group.coal.int_ql;
-	cmd->rx_max_coalesced_frames = rx_vector->rx_group.coal.int_ql;
+	cmd->tx_max_coalesced_frames = tx_coal->int_ql;
+	cmd->rx_max_coalesced_frames = rx_coal->int_ql;
 
 	return 0;
 }
 
-static int hns3_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
-{
-	return hns3_get_coalesce_per_queue(netdev, 0, cmd);
-}
-
 static int hns3_check_gl_coalesce_para(struct net_device *netdev,
 				       struct ethtool_coalesce *cmd)
 {
@@ -1277,19 +1259,7 @@ static int hns3_check_coalesce_para(struct net_device *netdev,
 		return ret;
 	}
 
-	ret = hns3_check_ql_coalesce_param(netdev, cmd);
-	if (ret)
-		return ret;
-
-	if (cmd->use_adaptive_tx_coalesce == 1 ||
-	    cmd->use_adaptive_rx_coalesce == 1) {
-		netdev_info(netdev,
-			    "adaptive-tx=%u and adaptive-rx=%u, tx_usecs or rx_usecs will changed dynamically.\n",
-			    cmd->use_adaptive_tx_coalesce,
-			    cmd->use_adaptive_rx_coalesce);
-	}
-
-	return 0;
+	return hns3_check_ql_coalesce_param(netdev, cmd);
 }
 
 static void hns3_set_coalesce_per_queue(struct net_device *netdev,
@@ -1335,6 +1305,9 @@ static int hns3_set_coalesce(struct net_device *netdev,
 			     struct ethtool_coalesce *cmd)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
 	u16 queue_num = h->kinfo.num_tqps;
 	int ret;
 	int i;
@@ -1349,6 +1322,15 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	h->kinfo.int_rl_setting =
 		hns3_rl_round_down(cmd->rx_coalesce_usecs_high);
 
+	tx_coal->adapt_enable = cmd->use_adaptive_tx_coalesce;
+	rx_coal->adapt_enable = cmd->use_adaptive_rx_coalesce;
+
+	tx_coal->int_gl = cmd->tx_coalesce_usecs;
+	rx_coal->int_gl = cmd->rx_coalesce_usecs;
+
+	tx_coal->int_ql = cmd->tx_max_coalesced_frames;
+	rx_coal->int_ql = cmd->rx_max_coalesced_frames;
+
 	for (i = 0; i < queue_num; i++)
 		hns3_set_coalesce_per_queue(netdev, cmd, i);
 
-- 
2.30.2



