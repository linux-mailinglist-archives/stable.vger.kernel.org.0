Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327C9344239
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhCVMjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhCVMiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D145C619AC;
        Mon, 22 Mar 2021 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416644;
        bh=Vwg06KCnGZOlvOsD4kQBsrN2hf603lBzmjeZ35OUAM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhwpZqV9hXgymBvPs6K1IyE8JuhmjysO97WT8TrY3+V91mJF9y87Xueic72xglCSE
         CaFPhPB/y/3eRw2rcyIao05n2rwaQy4sPricje0vcaa2yQMWoNMQfjAQYu5fHcIwgX
         ck1FleMPlWEzH1sA0MbxKSIG0hyqsNv2N4UENImY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/157] ibmvnic: serialize access to work queue on remove
Date:   Mon, 22 Mar 2021 13:27:01 +0100
Message-Id: <20210322121935.797554201@linuxfoundation.org>
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

[ Upstream commit 4a41c421f3676fdeea91733cf434dcf319c4c351 ]

The work queue is used to queue reset requests like CHANGE-PARAM or
FAILOVER resets for the worker thread. When the adapter is being removed
the adapter state is set to VNIC_REMOVING and the work queue is flushed
so no new work is added. However the check for adapter being removed is
racy in that the adapter can go into REMOVING state just after we check
and we might end up adding work just as it is being flushed (or after).

The ->rwi_lock is already being used to serialize queue/dequeue work.
Extend its usage ensure there is no race when scheduling/flushing work.

Fixes: 6954a9e4192b ("ibmvnic: Flush existing work items before device removal")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:Uwe Kleine-König <uwe@kleine-koenig.org>
Cc:Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 27 ++++++++++++++++++++-------
 drivers/net/ethernet/ibm/ibmvnic.h |  5 ++++-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1207007d8e46..2aee81496ffa 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2313,6 +2313,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&adapter->rwi_lock, flags);
+
 	/*
 	 * If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
@@ -2333,14 +2335,11 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
-	spin_lock_irqsave(&adapter->rwi_lock, flags);
-
 	list_for_each(entry, &adapter->rwi_list) {
 		tmp = list_entry(entry, struct ibmvnic_rwi, list);
 		if (tmp->reset_reason == reason) {
 			netdev_dbg(netdev, "Skipping matching reset, reason=%d\n",
 				   reason);
-			spin_unlock_irqrestore(&adapter->rwi_lock, flags);
 			ret = EBUSY;
 			goto err;
 		}
@@ -2348,8 +2347,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	rwi = kzalloc(sizeof(*rwi), GFP_ATOMIC);
 	if (!rwi) {
-		spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-		ibmvnic_close(netdev);
 		ret = ENOMEM;
 		goto err;
 	}
@@ -2362,12 +2359,17 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	}
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
-	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
 	schedule_work(&adapter->ibmvnic_reset);
 
-	return 0;
+	ret = 0;
 err:
+	/* ibmvnic_close() below can block, so drop the lock first */
+	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+
+	if (ret == ENOMEM)
+		ibmvnic_close(netdev);
+
 	return -ret;
 }
 
@@ -5378,7 +5380,18 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->state_lock, flags);
+
+	/* If ibmvnic_reset() is scheduling a reset, wait for it to
+	 * finish. Then, set the state to REMOVING to prevent it from
+	 * scheduling any more work and to have reset functions ignore
+	 * any resets that have already been scheduled. Drop the lock
+	 * after setting state, so __ibmvnic_reset() which is called
+	 * from the flush_work() below, can make progress.
+	 */
+	spin_lock_irqsave(&adapter->rwi_lock, flags);
 	adapter->state = VNIC_REMOVING;
+	spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+
 	spin_unlock_irqrestore(&adapter->state_lock, flags);
 
 	flush_work(&adapter->ibmvnic_reset);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 21e7ea858cda..b27211063c64 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1080,6 +1080,7 @@ struct ibmvnic_adapter {
 	struct tasklet_struct tasklet;
 	enum vnic_state state;
 	enum ibmvnic_reset_reason reset_reason;
+	/* when taking both state and rwi locks, take state lock first */
 	spinlock_t rwi_lock;
 	struct list_head rwi_list;
 	struct work_struct ibmvnic_reset;
@@ -1096,6 +1097,8 @@ struct ibmvnic_adapter {
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
 
-	/* Used for serializatin of state field */
+	/* Used for serialization of state field. When taking both state
+	 * and rwi locks, take state lock first.
+	 */
 	spinlock_t state_lock;
 };
-- 
2.30.1



