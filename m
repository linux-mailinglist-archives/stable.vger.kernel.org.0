Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C8C344238
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhCVMjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231415AbhCVMiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C4CF61992;
        Mon, 22 Mar 2021 12:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416641;
        bh=h4SJ0q7CQZpULS+B/Rxd+hzQIKpbDx059ZS0Vq0PIrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tko7q3J65LEwNVfx+I2PD0dcAtcONmypAv2ScenRAiuCR280+vjuZf2De0o1PAhIp
         lbH/yJemJCLeuTkgppRFxhzdKVoOE74wvrH50uZBmZCSx23vEB3a39jx9R9P8Ajukj
         XurS9Y55YiZ4NyBEv+naacE5M+SbwT3Kv3vulP7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/157] ibmvnic: add some debugs
Date:   Mon, 22 Mar 2021 13:27:00 +0100
Message-Id: <20210322121935.766451657@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 38bd5cec76e2282986b1bf2f8e7d2d05ffe68b22 ]

We sometimes run into situations where a soft/hard reset of the adapter
takes a long time or fails to complete. Having additional messages that
include important adapter state info will hopefully help understand what
is happening, reduce the guess work and minimize requests to reproduce
problems with debug patches.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Link: https://lore.kernel.org/r/20201205022235.2414110-1-sukadev@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f184f4a79cc3..1207007d8e46 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -409,6 +409,8 @@ static void replenish_pools(struct ibmvnic_adapter *adapter)
 		if (adapter->rx_pool[i].active)
 			replenish_rx_pool(adapter, &adapter->rx_pool[i]);
 	}
+
+	netdev_dbg(adapter->netdev, "Replenished %d pools\n", i);
 }
 
 static void release_stats_buffers(struct ibmvnic_adapter *adapter)
@@ -914,6 +916,7 @@ static int ibmvnic_login(struct net_device *netdev)
 
 	__ibmvnic_set_mac(netdev, adapter->mac_addr);
 
+	netdev_dbg(netdev, "[S:%d] Login succeeded\n", adapter->state);
 	return 0;
 }
 
@@ -1343,6 +1346,10 @@ static int ibmvnic_close(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	int rc;
 
+	netdev_dbg(netdev, "[S:%d FOP:%d FRR:%d] Closing\n",
+		   adapter->state, adapter->failover_pending,
+		   adapter->force_reset_recovery);
+
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
 	 */
@@ -1937,8 +1944,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	struct net_device *netdev = adapter->netdev;
 	int i, rc;
 
-	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
-		   rwi->reset_reason);
+	netdev_dbg(adapter->netdev,
+		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
+		   adapter->state, adapter->failover_pending,
+		   rwi->reset_reason, reset_state);
 
 	rtnl_lock();
 	/*
@@ -2097,6 +2106,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		adapter->state = reset_state;
 	rtnl_unlock();
 
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2166,6 +2177,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	/* restore adapter state if reset failed */
 	if (rc)
 		adapter->state = reset_state;
+	netdev_dbg(adapter->netdev, "[S:%d FOP:%d] Hard reset done, rc %d\n",
+		   adapter->state, adapter->failover_pending, rc);
 	return rc;
 }
 
@@ -2275,6 +2288,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	clear_bit_unlock(0, &adapter->resetting);
+
+	netdev_dbg(adapter->netdev,
+		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
+		   adapter->state, adapter->force_reset_recovery,
+		   adapter->wait_for_reset);
 }
 
 static void __ibmvnic_delayed_reset(struct work_struct *work)
@@ -2320,7 +2338,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	list_for_each(entry, &adapter->rwi_list) {
 		tmp = list_entry(entry, struct ibmvnic_rwi, list);
 		if (tmp->reset_reason == reason) {
-			netdev_dbg(netdev, "Skipping matching reset\n");
+			netdev_dbg(netdev, "Skipping matching reset, reason=%d\n",
+				   reason);
 			spin_unlock_irqrestore(&adapter->rwi_lock, flags);
 			ret = EBUSY;
 			goto err;
-- 
2.30.1



