Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69262462286
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhK2Uxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 15:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbhK2Uvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 15:51:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6966AC0F4B16;
        Mon, 29 Nov 2021 10:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B608CCE1411;
        Mon, 29 Nov 2021 18:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607CDC53FCD;
        Mon, 29 Nov 2021 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210351;
        bh=vmEEyyzlSFKQmbAs+frcmyUnGqjJGuIxJOW0YBZG9fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZMVYe7jRYTQa3sAAgnhC5MJOw/ZzgyAhz/qGcUqGVlW50eOTrJypmNsWWr/lSr8N
         tPg/Is+D9SW6HwoXOxFOgaTUUD7wrVPUKNwPfJhCR/KcYjG9x1sE/16yqdytqA0Uns
         AhkzSZxrG8eRU8ZkCub9NpbjyH9sOmjq9LmxVbls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/92] iavf: Prevent changing static ITR values if adaptive moderation is on
Date:   Mon, 29 Nov 2021 19:18:26 +0100
Message-Id: <20211129181709.318414783@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>

[ Upstream commit e792779e6b639c182df91b46ac1e5803460b0b15 ]

Resolve being able to change static values on VF when adaptive interrupt
moderation is enabled.

This problem is fixed by checking the interrupt settings is not
a combination of change of static value while adaptive interrupt
moderation is turned on.

Without this fix, the user would be able to change static values
on VF with adaptive moderation enabled.

Fixes: 65e87c0398f5 ("i40evf: support queue-specific settings for interrupt moderation")
Signed-off-by: Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index ad1e796e5544a..4e0e1b02d615e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -719,12 +719,31 @@ static int iavf_get_per_queue_coalesce(struct net_device *netdev, u32 queue,
  *
  * Change the ITR settings for a specific queue.
  **/
-static void iavf_set_itr_per_queue(struct iavf_adapter *adapter,
-				   struct ethtool_coalesce *ec, int queue)
+static int iavf_set_itr_per_queue(struct iavf_adapter *adapter,
+				  struct ethtool_coalesce *ec, int queue)
 {
 	struct iavf_ring *rx_ring = &adapter->rx_rings[queue];
 	struct iavf_ring *tx_ring = &adapter->tx_rings[queue];
 	struct iavf_q_vector *q_vector;
+	u16 itr_setting;
+
+	itr_setting = rx_ring->itr_setting & ~IAVF_ITR_DYNAMIC;
+
+	if (ec->rx_coalesce_usecs != itr_setting &&
+	    ec->use_adaptive_rx_coalesce) {
+		netif_info(adapter, drv, adapter->netdev,
+			   "Rx interrupt throttling cannot be changed if adaptive-rx is enabled\n");
+		return -EINVAL;
+	}
+
+	itr_setting = tx_ring->itr_setting & ~IAVF_ITR_DYNAMIC;
+
+	if (ec->tx_coalesce_usecs != itr_setting &&
+	    ec->use_adaptive_tx_coalesce) {
+		netif_info(adapter, drv, adapter->netdev,
+			   "Tx interrupt throttling cannot be changed if adaptive-tx is enabled\n");
+		return -EINVAL;
+	}
 
 	rx_ring->itr_setting = ITR_REG_ALIGN(ec->rx_coalesce_usecs);
 	tx_ring->itr_setting = ITR_REG_ALIGN(ec->tx_coalesce_usecs);
@@ -747,6 +766,7 @@ static void iavf_set_itr_per_queue(struct iavf_adapter *adapter,
 	 * the Tx and Rx ITR values based on the values we have entered
 	 * into the q_vector, no need to write the values now.
 	 */
+	return 0;
 }
 
 /**
@@ -788,9 +808,11 @@ static int __iavf_set_coalesce(struct net_device *netdev,
 	 */
 	if (queue < 0) {
 		for (i = 0; i < adapter->num_active_queues; i++)
-			iavf_set_itr_per_queue(adapter, ec, i);
+			if (iavf_set_itr_per_queue(adapter, ec, i))
+				return -EINVAL;
 	} else if (queue < adapter->num_active_queues) {
-		iavf_set_itr_per_queue(adapter, ec, queue);
+		if (iavf_set_itr_per_queue(adapter, ec, queue))
+			return -EINVAL;
 	} else {
 		netif_info(adapter, drv, netdev, "Invalid queue value, queue range is 0 - %d\n",
 			   adapter->num_active_queues - 1);
-- 
2.33.0



