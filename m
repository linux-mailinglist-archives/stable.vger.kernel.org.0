Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58DB4CF9DD
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbiCGKM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242751AbiCGKLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E43078924;
        Mon,  7 Mar 2022 01:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DFB4B8102B;
        Mon,  7 Mar 2022 09:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603CC340E9;
        Mon,  7 Mar 2022 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646950;
        bh=RFy/TVB0mDsKcCoPgg6F2kYx+5aw6gItLBwf3kzzL4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jtg04GneeXD9MuZxO/c5yZihoEB/ekyboocEA5Yaen6PA1O2tvno61VwH2un4D3Le
         7iMJKPvnRSfd3WmxOZ3ZLGnD3Ro6mr2Nt9aJJFcl/Fwo9Wg/1pa0abCcHHeVjFpPnx
         F2fFlKoMNP9HRYRLVpyg2AZgzpHpI2vK0JyDkAVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Root <otis@otisroot.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 143/186] ibmvnic: Update driver return codes
Date:   Mon,  7 Mar 2022 10:19:41 +0100
Message-Id: <20220307091658.075456511@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit b6ee566cf3940883d67c0d142fae8d410e975f47 ]

Update return codes to be more informative.

Signed-off-by: Jacob Root <otis@otisroot.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 64 ++++++++++++++++--------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 16e772f80ec5..7bd0ad590898 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -309,7 +309,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	if (adapter->fw_done_rc) {
 		dev_err(dev, "Couldn't map LTB, rc = %d\n",
 			adapter->fw_done_rc);
-		rc = -1;
+		rc = -EIO;
 		goto out;
 	}
 	rc = 0;
@@ -541,13 +541,15 @@ static int init_stats_token(struct ibmvnic_adapter *adapter)
 {
 	struct device *dev = &adapter->vdev->dev;
 	dma_addr_t stok;
+	int rc;
 
 	stok = dma_map_single(dev, &adapter->stats,
 			      sizeof(struct ibmvnic_statistics),
 			      DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, stok)) {
-		dev_err(dev, "Couldn't map stats buffer\n");
-		return -1;
+	rc = dma_mapping_error(dev, stok);
+	if (rc) {
+		dev_err(dev, "Couldn't map stats buffer, rc = %d\n", rc);
+		return rc;
 	}
 
 	adapter->stats_token = stok;
@@ -656,7 +658,7 @@ static int init_rx_pools(struct net_device *netdev)
 	u64 num_pools;
 	u64 pool_size;		/* # of buffers in one pool */
 	u64 buff_size;
-	int i, j;
+	int i, j, rc;
 
 	pool_size = adapter->req_rx_add_entries_per_subcrq;
 	num_pools = adapter->req_rx_queues;
@@ -675,7 +677,7 @@ static int init_rx_pools(struct net_device *netdev)
 				   GFP_KERNEL);
 	if (!adapter->rx_pool) {
 		dev_err(dev, "Failed to allocate rx pools\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Set num_active_rx_pools early. If we fail below after partial
@@ -698,6 +700,7 @@ static int init_rx_pools(struct net_device *netdev)
 					    GFP_KERNEL);
 		if (!rx_pool->free_map) {
 			dev_err(dev, "Couldn't alloc free_map %d\n", i);
+			rc = -ENOMEM;
 			goto out_release;
 		}
 
@@ -706,6 +709,7 @@ static int init_rx_pools(struct net_device *netdev)
 					   GFP_KERNEL);
 		if (!rx_pool->rx_buff) {
 			dev_err(dev, "Couldn't alloc rx buffers\n");
+			rc = -ENOMEM;
 			goto out_release;
 		}
 	}
@@ -719,8 +723,9 @@ static int init_rx_pools(struct net_device *netdev)
 		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
 			i, rx_pool->size, rx_pool->buff_size);
 
-		if (alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
-					 rx_pool->size * rx_pool->buff_size))
+		rc = alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
+					  rx_pool->size * rx_pool->buff_size);
+		if (rc)
 			goto out;
 
 		for (j = 0; j < rx_pool->size; ++j) {
@@ -757,7 +762,7 @@ static int init_rx_pools(struct net_device *netdev)
 	/* We failed to allocate one or more LTBs or map them on the VIOS.
 	 * Hold onto the pools and any LTBs that we did allocate/map.
 	 */
-	return -1;
+	return rc;
 }
 
 static void release_vpd_data(struct ibmvnic_adapter *adapter)
@@ -818,13 +823,13 @@ static int init_one_tx_pool(struct net_device *netdev,
 				   sizeof(struct ibmvnic_tx_buff),
 				   GFP_KERNEL);
 	if (!tx_pool->tx_buff)
-		return -1;
+		return -ENOMEM;
 
 	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
 	if (!tx_pool->free_map) {
 		kfree(tx_pool->tx_buff);
 		tx_pool->tx_buff = NULL;
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < pool_size; i++)
@@ -915,7 +920,7 @@ static int init_tx_pools(struct net_device *netdev)
 	adapter->tx_pool = kcalloc(num_pools,
 				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
 	if (!adapter->tx_pool)
-		return -1;
+		return -ENOMEM;
 
 	adapter->tso_pool = kcalloc(num_pools,
 				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
@@ -925,7 +930,7 @@ static int init_tx_pools(struct net_device *netdev)
 	if (!adapter->tso_pool) {
 		kfree(adapter->tx_pool);
 		adapter->tx_pool = NULL;
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Set num_active_tx_pools early. If we fail below after partial
@@ -1114,7 +1119,7 @@ static int ibmvnic_login(struct net_device *netdev)
 		retry = false;
 		if (retry_count > retries) {
 			netdev_warn(netdev, "Login attempts exceeded\n");
-			return -1;
+			return -EACCES;
 		}
 
 		adapter->init_done_rc = 0;
@@ -1155,25 +1160,26 @@ static int ibmvnic_login(struct net_device *netdev)
 							 timeout)) {
 				netdev_warn(netdev,
 					    "Capabilities query timed out\n");
-				return -1;
+				return -ETIMEDOUT;
 			}
 
 			rc = init_sub_crqs(adapter);
 			if (rc) {
 				netdev_warn(netdev,
 					    "SCRQ initialization failed\n");
-				return -1;
+				return rc;
 			}
 
 			rc = init_sub_crq_irqs(adapter);
 			if (rc) {
 				netdev_warn(netdev,
 					    "SCRQ irq initialization failed\n");
-				return -1;
+				return rc;
 			}
 		} else if (adapter->init_done_rc) {
-			netdev_warn(netdev, "Adapter login failed\n");
-			return -1;
+			netdev_warn(netdev, "Adapter login failed, init_done_rc = %d\n",
+				    adapter->init_done_rc);
+			return -EIO;
 		}
 	} while (retry);
 
@@ -1232,7 +1238,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 		if (!wait_for_completion_timeout(&adapter->init_done,
 						 timeout)) {
 			netdev_err(netdev, "timeout setting link state\n");
-			return -1;
+			return -ETIMEDOUT;
 		}
 
 		if (adapter->init_done_rc == PARTIALSUCCESS) {
@@ -2293,7 +2299,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 				/* If someone else changed the adapter state
 				 * when we dropped the rtnl, fail the reset
 				 */
-				rc = -1;
+				rc = -EAGAIN;
 				goto out;
 			}
 			adapter->state = VNIC_CLOSED;
@@ -2335,10 +2341,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		}
 
 		rc = ibmvnic_reset_init(adapter, true);
-		if (rc) {
-			rc = IBMVNIC_INIT_FAILED;
+		if (rc)
 			goto out;
-		}
 
 		/* If the adapter was in PROBE or DOWN state prior to the reset,
 		 * exit here.
@@ -3787,7 +3791,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 
 	allqueues = kcalloc(total_queues, sizeof(*allqueues), GFP_KERNEL);
 	if (!allqueues)
-		return -1;
+		return -ENOMEM;
 
 	for (i = 0; i < total_queues; i++) {
 		allqueues[i] = init_sub_crq_queue(adapter);
@@ -3856,7 +3860,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 	for (i = 0; i < registered_queues; i++)
 		release_sub_crq_queue(adapter, allqueues[i], 1);
 	kfree(allqueues);
-	return -1;
+	return -ENOMEM;
 }
 
 static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
@@ -4235,7 +4239,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	if (!adapter->tx_scrq || !adapter->rx_scrq) {
 		netdev_err(adapter->netdev,
 			   "RX or TX queues are not allocated, device login failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	release_login_buffer(adapter);
@@ -4355,7 +4359,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	kfree(login_buffer);
 	adapter->login_buf = NULL;
 buf_alloc_failed:
-	return -1;
+	return -ENOMEM;
 }
 
 static int send_request_map(struct ibmvnic_adapter *adapter, dma_addr_t addr,
@@ -5693,7 +5697,7 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
 		dev_err(dev, "Initialization sequence timed out\n");
-		return -1;
+		return -ETIMEDOUT;
 	}
 
 	if (adapter->init_done_rc) {
@@ -5704,7 +5708,7 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 	if (adapter->from_passive_init) {
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
-		return -1;
+		return -EINVAL;
 	}
 
 	if (reset &&
-- 
2.34.1



