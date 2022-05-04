Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F7951A73B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354487AbiEDRCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355581AbiEDRAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE5C4B85D;
        Wed,  4 May 2022 09:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64397B827A0;
        Wed,  4 May 2022 16:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D27C385B0;
        Wed,  4 May 2022 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683105;
        bh=MgUSPGC8XAwqCIX5ru8uKpmwPXqDBDFmXLpraWqumLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6epOYcgJOJaHPztNBqE+hlAfIl3ovhQfXm5SKdKcPyTCarQxHhfJAhLxdJeMNjVa
         j/MjHBPxchN0CUAOfO2Z4aZ1xsS/dBQZwbcRtGW9AyWoHfweSAkbqLP0j3l8cVF1tu
         t6O7vYbv7T3Q2/VVxVT3igL+YkFAd6RX3Uz8D8sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/129] Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"
Date:   Wed,  4 May 2022 18:44:49 +0200
Message-Id: <20220504153028.632338410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit aeaf59b78712c7a1827c76f086acff4f586e072f ]

This reverts commit 723ad916134784b317b72f3f6cf0f7ba774e5dae

When client requests channel or ring size larger than what the server
can support the server will cap the request to the supported max. So,
the client would not be able to successfully request resources that
exceed the server limit.

Fixes: 723ad9161347 ("ibmvnic: Add ethtool private flag for driver-defined queue limits")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Link: https://lore.kernel.org/r/20220427235146.23189-1-drt@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 129 ++++++++---------------------
 drivers/net/ethernet/ibm/ibmvnic.h |   6 --
 2 files changed, 35 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2cd849215913..61fb2a092451 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2666,13 +2666,8 @@ static void ibmvnic_get_ringparam(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->priv_flags & IBMVNIC_USE_SERVER_MAXES) {
-		ring->rx_max_pending = adapter->max_rx_add_entries_per_subcrq;
-		ring->tx_max_pending = adapter->max_tx_entries_per_subcrq;
-	} else {
-		ring->rx_max_pending = IBMVNIC_MAX_QUEUE_SZ;
-		ring->tx_max_pending = IBMVNIC_MAX_QUEUE_SZ;
-	}
+	ring->rx_max_pending = adapter->max_rx_add_entries_per_subcrq;
+	ring->tx_max_pending = adapter->max_tx_entries_per_subcrq;
 	ring->rx_mini_max_pending = 0;
 	ring->rx_jumbo_max_pending = 0;
 	ring->rx_pending = adapter->req_rx_add_entries_per_subcrq;
@@ -2685,23 +2680,21 @@ static int ibmvnic_set_ringparam(struct net_device *netdev,
 				 struct ethtool_ringparam *ring)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
-	ret = 0;
+	if (ring->rx_pending > adapter->max_rx_add_entries_per_subcrq  ||
+	    ring->tx_pending > adapter->max_tx_entries_per_subcrq) {
+		netdev_err(netdev, "Invalid request.\n");
+		netdev_err(netdev, "Max tx buffers = %llu\n",
+			   adapter->max_rx_add_entries_per_subcrq);
+		netdev_err(netdev, "Max rx buffers = %llu\n",
+			   adapter->max_tx_entries_per_subcrq);
+		return -EINVAL;
+	}
+
 	adapter->desired.rx_entries = ring->rx_pending;
 	adapter->desired.tx_entries = ring->tx_pending;
 
-	ret = wait_for_reset(adapter);
-
-	if (!ret &&
-	    (adapter->req_rx_add_entries_per_subcrq != ring->rx_pending ||
-	     adapter->req_tx_entries_per_subcrq != ring->tx_pending))
-		netdev_info(netdev,
-			    "Could not match full ringsize request. Requested: RX %d, TX %d; Allowed: RX %llu, TX %llu\n",
-			    ring->rx_pending, ring->tx_pending,
-			    adapter->req_rx_add_entries_per_subcrq,
-			    adapter->req_tx_entries_per_subcrq);
-	return ret;
+	return wait_for_reset(adapter);
 }
 
 static void ibmvnic_get_channels(struct net_device *netdev,
@@ -2709,14 +2702,8 @@ static void ibmvnic_get_channels(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->priv_flags & IBMVNIC_USE_SERVER_MAXES) {
-		channels->max_rx = adapter->max_rx_queues;
-		channels->max_tx = adapter->max_tx_queues;
-	} else {
-		channels->max_rx = IBMVNIC_MAX_QUEUES;
-		channels->max_tx = IBMVNIC_MAX_QUEUES;
-	}
-
+	channels->max_rx = adapter->max_rx_queues;
+	channels->max_tx = adapter->max_tx_queues;
 	channels->max_other = 0;
 	channels->max_combined = 0;
 	channels->rx_count = adapter->req_rx_queues;
@@ -2729,22 +2716,11 @@ static int ibmvnic_set_channels(struct net_device *netdev,
 				struct ethtool_channels *channels)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
-	ret = 0;
 	adapter->desired.rx_queues = channels->rx_count;
 	adapter->desired.tx_queues = channels->tx_count;
 
-	ret = wait_for_reset(adapter);
-
-	if (!ret &&
-	    (adapter->req_rx_queues != channels->rx_count ||
-	     adapter->req_tx_queues != channels->tx_count))
-		netdev_info(netdev,
-			    "Could not match full channels request. Requested: RX %d, TX %d; Allowed: RX %llu, TX %llu\n",
-			    channels->rx_count, channels->tx_count,
-			    adapter->req_rx_queues, adapter->req_tx_queues);
-	return ret;
+	return wait_for_reset(adapter);
 }
 
 static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -2752,43 +2728,32 @@ static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 	int i;
 
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(ibmvnic_stats);
-				i++, data += ETH_GSTRING_LEN)
-			memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
+	if (stringset != ETH_SS_STATS)
+		return;
 
-		for (i = 0; i < adapter->req_tx_queues; i++) {
-			snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++, data += ETH_GSTRING_LEN)
+		memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
 
-			snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < adapter->req_tx_queues; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
+		data += ETH_GSTRING_LEN;
 
-			snprintf(data, ETH_GSTRING_LEN,
-				 "tx%d_dropped_packets", i);
-			data += ETH_GSTRING_LEN;
-		}
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
+		data += ETH_GSTRING_LEN;
 
-		for (i = 0; i < adapter->req_rx_queues; i++) {
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_packets", i);
-			data += ETH_GSTRING_LEN;
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_dropped_packets", i);
+		data += ETH_GSTRING_LEN;
+	}
 
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_bytes", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < adapter->req_rx_queues; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_packets", i);
+		data += ETH_GSTRING_LEN;
 
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_interrupts", i);
-			data += ETH_GSTRING_LEN;
-		}
-		break;
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_bytes", i);
+		data += ETH_GSTRING_LEN;
 
-	case ETH_SS_PRIV_FLAGS:
-		for (i = 0; i < ARRAY_SIZE(ibmvnic_priv_flags); i++)
-			strcpy(data + i * ETH_GSTRING_LEN,
-			       ibmvnic_priv_flags[i]);
-		break;
-	default:
-		return;
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_interrupts", i);
+		data += ETH_GSTRING_LEN;
 	}
 }
 
@@ -2801,8 +2766,6 @@ static int ibmvnic_get_sset_count(struct net_device *dev, int sset)
 		return ARRAY_SIZE(ibmvnic_stats) +
 		       adapter->req_tx_queues * NUM_TX_STATS +
 		       adapter->req_rx_queues * NUM_RX_STATS;
-	case ETH_SS_PRIV_FLAGS:
-		return ARRAY_SIZE(ibmvnic_priv_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2855,26 +2818,6 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-static u32 ibmvnic_get_priv_flags(struct net_device *netdev)
-{
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-
-	return adapter->priv_flags;
-}
-
-static int ibmvnic_set_priv_flags(struct net_device *netdev, u32 flags)
-{
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	bool which_maxes = !!(flags & IBMVNIC_USE_SERVER_MAXES);
-
-	if (which_maxes)
-		adapter->priv_flags |= IBMVNIC_USE_SERVER_MAXES;
-	else
-		adapter->priv_flags &= ~IBMVNIC_USE_SERVER_MAXES;
-
-	return 0;
-}
-
 static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_drvinfo		= ibmvnic_get_drvinfo,
 	.get_msglevel		= ibmvnic_get_msglevel,
@@ -2888,8 +2831,6 @@ static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_sset_count         = ibmvnic_get_sset_count,
 	.get_ethtool_stats	= ibmvnic_get_ethtool_stats,
 	.get_link_ksettings	= ibmvnic_get_link_ksettings,
-	.get_priv_flags		= ibmvnic_get_priv_flags,
-	.set_priv_flags		= ibmvnic_set_priv_flags,
 };
 
 /* Routines for managing CRQs/sCRQs  */
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b27211063c64..2eb9a4d5533a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -41,11 +41,6 @@
 
 #define IBMVNIC_RESET_DELAY 100
 
-static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
-#define IBMVNIC_USE_SERVER_MAXES 0x1
-	"use-server-maxes"
-};
-
 struct ibmvnic_login_buffer {
 	__be32 len;
 	__be32 version;
@@ -974,7 +969,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_control_ip_offload_buffer ip_offload_ctrl;
 	dma_addr_t ip_offload_ctrl_tok;
 	u32 msg_enable;
-	u32 priv_flags;
 
 	/* Vital Product Data (VPD) */
 	struct ibmvnic_vpd *vpd;
-- 
2.35.1



