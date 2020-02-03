Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766CD150C3A
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgBCQe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730786AbgBCQe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:26 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F6C2051A;
        Mon,  3 Feb 2020 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747665;
        bh=LES+YNt23SVFzitgeegj8ax90xxyBOX+vGMxfEd3OS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7+2AkSB1GCx6jgCu0/+74ckcvS+3pCaB6JvdkSUlz39675UwmXCnDDEQID8iDaCd
         fvKKBf5ZCPtjTcwGzxklVBdMYlnnGix0hB09tBhvFh5wVC9zIQdvYjOF4C1rPCoJ/e
         0elYgxfXNXZOGpm7vnyfpYuBTYRlCyFHHsmA4i58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/90] e1000e: Revert "e1000e: Make watchdog use delayed work"
Date:   Mon,  3 Feb 2020 16:19:10 +0000
Message-Id: <20200203161918.551273833@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

[ Upstream commit d5ad7a6a7f3c87b278d7e4973b65682be4e588dd ]

This reverts commit 59653e6497d16f7ac1d9db088f3959f57ee8c3db.

This is due to this commit causing driver crashes and connections to
reset unexpectedly.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/e1000.h  |  5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c | 54 ++++++++++------------
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 6c51b1bad8c42..37a2314d3e6b1 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -185,13 +185,12 @@ struct e1000_phy_regs {
 
 /* board specific private data structure */
 struct e1000_adapter {
+	struct timer_list watchdog_timer;
 	struct timer_list phy_info_timer;
 	struct timer_list blink_timer;
 
 	struct work_struct reset_task;
-	struct delayed_work watchdog_task;
-
-	struct workqueue_struct *e1000_workqueue;
+	struct work_struct watchdog_task;
 
 	const struct e1000_info *ei;
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index aa9fdda839148..c27ed7363768c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1780,8 +1780,7 @@ static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_delayed_work(adapter->e1000_workqueue,
-					 &adapter->watchdog_task, HZ);
+			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1861,8 +1860,7 @@ static irqreturn_t e1000_intr(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_delayed_work(adapter->e1000_workqueue,
-					 &adapter->watchdog_task, HZ);
+			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1907,8 +1905,7 @@ static irqreturn_t e1000_msix_other(int __always_unused irq, void *data)
 		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_delayed_work(adapter->e1000_workqueue,
-					 &adapter->watchdog_task, HZ);
+			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
 	if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -4281,6 +4278,7 @@ void e1000e_down(struct e1000_adapter *adapter, bool reset)
 
 	napi_synchronize(&adapter->napi);
 
+	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	spin_lock(&adapter->stats64_lock);
@@ -5152,11 +5150,25 @@ static void e1000e_check_82574_phy_workaround(struct e1000_adapter *adapter)
 	}
 }
 
+/**
+ * e1000_watchdog - Timer Call-back
+ * @data: pointer to adapter cast into an unsigned long
+ **/
+static void e1000_watchdog(struct timer_list *t)
+{
+	struct e1000_adapter *adapter = from_timer(adapter, t, watchdog_timer);
+
+	/* Do the rest outside of interrupt context */
+	schedule_work(&adapter->watchdog_task);
+
+	/* TODO: make this use queue_delayed_work() */
+}
+
 static void e1000_watchdog_task(struct work_struct *work)
 {
 	struct e1000_adapter *adapter = container_of(work,
 						     struct e1000_adapter,
-						     watchdog_task.work);
+						     watchdog_task);
 	struct net_device *netdev = adapter->netdev;
 	struct e1000_mac_info *mac = &adapter->hw.mac;
 	struct e1000_phy_info *phy = &adapter->hw.phy;
@@ -5404,9 +5416,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 
 	/* Reset the timer */
 	if (!test_bit(__E1000_DOWN, &adapter->state))
-		queue_delayed_work(adapter->e1000_workqueue,
-				   &adapter->watchdog_task,
-				   round_jiffies(2 * HZ));
+		mod_timer(&adapter->watchdog_timer,
+			  round_jiffies(jiffies + 2 * HZ));
 }
 
 #define E1000_TX_FLAGS_CSUM		0x00000001
@@ -7259,21 +7270,11 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_eeprom;
 	}
 
-	adapter->e1000_workqueue = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0,
-						   e1000e_driver_name);
-
-	if (!adapter->e1000_workqueue) {
-		err = -ENOMEM;
-		goto err_workqueue;
-	}
-
-	INIT_DELAYED_WORK(&adapter->watchdog_task, e1000_watchdog_task);
-	queue_delayed_work(adapter->e1000_workqueue, &adapter->watchdog_task,
-			   0);
-
+	timer_setup(&adapter->watchdog_timer, e1000_watchdog, 0);
 	timer_setup(&adapter->phy_info_timer, e1000_update_phy_info, 0);
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
+	INIT_WORK(&adapter->watchdog_task, e1000_watchdog_task);
 	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
 	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 	INIT_WORK(&adapter->print_hang_task, e1000_print_hw_hang);
@@ -7367,9 +7368,6 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_register:
-	flush_workqueue(adapter->e1000_workqueue);
-	destroy_workqueue(adapter->e1000_workqueue);
-err_workqueue:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
 err_eeprom:
@@ -7414,17 +7412,15 @@ static void e1000_remove(struct pci_dev *pdev)
 	 * from being rescheduled.
 	 */
 	set_bit(__E1000_DOWN, &adapter->state);
+	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	cancel_work_sync(&adapter->reset_task);
+	cancel_work_sync(&adapter->watchdog_task);
 	cancel_work_sync(&adapter->downshift_task);
 	cancel_work_sync(&adapter->update_phy_task);
 	cancel_work_sync(&adapter->print_hang_task);
 
-	cancel_delayed_work(&adapter->watchdog_task);
-	flush_workqueue(adapter->e1000_workqueue);
-	destroy_workqueue(adapter->e1000_workqueue);
-
 	if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
 		cancel_work_sync(&adapter->tx_hwtstamp_work);
 		if (adapter->tx_hwtstamp_skb) {
-- 
2.20.1



