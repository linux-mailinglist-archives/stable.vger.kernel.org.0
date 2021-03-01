Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D277E328EE5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbhCATkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241616AbhCATcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B05652E5;
        Mon,  1 Mar 2021 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620378;
        bh=DmwiiAz2LEGb00ZXlPhV8U0kVQT7FBfbjKdMBCK/zDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9/vGhh7IUtmjAADX9JwJkRuilfVJApMp6u+MCKXPVbSiJP68/Iunr3bYc5+xfoYK
         NT/Np4b8HsyDilCuyRsvCUSqWmArENWalvfXF/gCRWUnEWjXHtRcMJcEtowpEHyvqE
         mlwzVnDAF6P+yi7s0WEvPpDxiLLyuAkn5e5hDwg4=
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
Subject: [PATCH 5.11 130/775] ibmvnic: serialize access to work queue on remove
Date:   Mon,  1 Mar 2021 17:04:58 +0100
Message-Id: <20210301161208.086435792@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index cd201f89ce6c0..13ae7eee7ef5f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2395,6 +2395,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&adapter->rwi_lock, flags);
+
 	/*
 	 * If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
@@ -2415,14 +2417,11 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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
@@ -2430,8 +2429,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	rwi = kzalloc(sizeof(*rwi), GFP_ATOMIC);
 	if (!rwi) {
-		spin_unlock_irqrestore(&adapter->rwi_lock, flags);
-		ibmvnic_close(netdev);
 		ret = ENOMEM;
 		goto err;
 	}
@@ -2444,12 +2441,17 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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
 
@@ -5467,7 +5469,18 @@ static int ibmvnic_remove(struct vio_dev *dev)
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
index c09c3f6bba9f2..3cccbba703658 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1081,6 +1081,7 @@ struct ibmvnic_adapter {
 	struct tasklet_struct tasklet;
 	enum vnic_state state;
 	enum ibmvnic_reset_reason reset_reason;
+	/* when taking both state and rwi locks, take state lock first */
 	spinlock_t rwi_lock;
 	struct list_head rwi_list;
 	struct work_struct ibmvnic_reset;
@@ -1097,6 +1098,8 @@ struct ibmvnic_adapter {
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
 
-	/* Used for serializatin of state field */
+	/* Used for serialization of state field. When taking both state
+	 * and rwi locks, take state lock first.
+	 */
 	spinlock_t state_lock;
 };
-- 
2.27.0



