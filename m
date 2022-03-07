Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE184CF966
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbiCGKEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbiCGJ7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:59:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171077C7B5;
        Mon,  7 Mar 2022 01:46:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614176116E;
        Mon,  7 Mar 2022 09:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D4AC340E9;
        Mon,  7 Mar 2022 09:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646384;
        bh=WVezb1xqfO/jUE0GkQ2sDOidjj4zerByrLF7Pq3heH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCmy6sTDA5ijJQGkbbi86fQFNIT5rWmF6BlRZWgBUKbC61QgTDCaqYwBPaR57JUTL
         pNi47iUVWHVQxQFXgi2BACJ3x6T1O4BYoxQirC5ZvKXTXEmkkhgYyzLNGM6/OWjZ2s
         DG7cbuUsvHNEzBudt/s+9NUzIYh90CLwj1nIU4DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/262] iavf: Rework mutexes for better synchronisation
Date:   Mon,  7 Mar 2022 10:19:31 +0100
Message-Id: <20220307091709.571487404@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit fc2e6b3b132a907378f6af08356b105a4139c4fb ]

The driver used to crash in multiple spots when put to stress testing
of the init, reset and remove paths.

The user would experience call traces or hangs when creating,
resetting, removing VFs. Depending on the machines, the call traces
are happening in random spots, like reset restoring resources racing
with driver remove.

Make adapter->crit_lock mutex a mandatory lock for guarding the
operations performed on all workqueues and functions dealing with
resource allocation and disposal.

Make __IAVF_REMOVE a final state of the driver respected by
workqueues that shall not requeue, when they fail to obtain the
crit_lock.

Make the IRQ handler not to queue the new work for adminq_task
when the __IAVF_REMOVE state is set.

Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 66 +++++++++++----------
 2 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 00d1ea313918..997c45f2c542 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -233,7 +233,6 @@ struct iavf_adapter {
 	struct list_head mac_filter_list;
 	struct mutex crit_lock;
 	struct mutex client_lock;
-	struct mutex remove_lock;
 	/* Lock to protect accesses to MAC and VLAN lists */
 	spinlock_t mac_vlan_list_lock;
 	char misc_vector_name[IFNAMSIZ + 9];
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 75fab4ea42b6..3aa21568686d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -293,8 +293,9 @@ static irqreturn_t iavf_msix_aq(int irq, void *data)
 	rd32(hw, IAVF_VFINT_ICR01);
 	rd32(hw, IAVF_VFINT_ICR0_ENA1);
 
-	/* schedule work on the private workqueue */
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state != __IAVF_REMOVE)
+		/* schedule work on the private workqueue */
+		queue_work(iavf_wq, &adapter->adminq_task);
 
 	return IRQ_HANDLED;
 }
@@ -1972,8 +1973,12 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
-	if (!mutex_trylock(&adapter->crit_lock))
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE)
+			return;
+
 		goto restart_watchdog;
+	}
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
@@ -2185,13 +2190,13 @@ static void iavf_reset_task(struct work_struct *work)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	if (mutex_is_locked(&adapter->remove_lock))
-		return;
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state != __IAVF_REMOVE)
+			queue_work(iavf_wq, &adapter->reset_task);
 
-	if (iavf_lock_timeout(&adapter->crit_lock, 200)) {
-		schedule_work(&adapter->reset_task);
 		return;
 	}
+
 	while (!mutex_trylock(&adapter->client_lock))
 		usleep_range(500, 1000);
 	if (CLIENT_ENABLED(adapter)) {
@@ -2401,13 +2406,19 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		goto out;
 
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE)
+			return;
+
+		queue_work(iavf_wq, &adapter->adminq_task);
+		goto out;
+	}
+
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf)
 		goto out;
 
-	if (iavf_lock_timeout(&adapter->crit_lock, 200))
-		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
@@ -3368,11 +3379,12 @@ static int iavf_close(struct net_device *netdev)
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	int status;
 
-	if (adapter->state <= __IAVF_DOWN_PENDING)
-		return 0;
+	mutex_lock(&adapter->crit_lock);
 
-	while (!mutex_trylock(&adapter->crit_lock))
-		usleep_range(500, 1000);
+	if (adapter->state <= __IAVF_DOWN_PENDING) {
+		mutex_unlock(&adapter->crit_lock);
+		return 0;
+	}
 
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	if (CLIENT_ENABLED(adapter))
@@ -3836,7 +3848,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	mutex_init(&adapter->crit_lock);
 	mutex_init(&adapter->client_lock);
-	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
 
@@ -3959,11 +3970,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
-	/* Indicate we are in remove and not to run reset_task */
-	mutex_lock(&adapter->remove_lock);
-	cancel_work_sync(&adapter->reset_task);
-	cancel_delayed_work_sync(&adapter->watchdog_task);
-	cancel_delayed_work_sync(&adapter->client_task);
+
 	if (adapter->netdev_registered) {
 		unregister_netdev(netdev);
 		adapter->netdev_registered = false;
@@ -3975,6 +3982,10 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
+	mutex_lock(&adapter->crit_lock);
+	dev_info(&adapter->pdev->dev, "Remove device\n");
+	iavf_change_state(adapter, __IAVF_REMOVE);
+
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -3982,25 +3993,22 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
-	dev_info(&adapter->pdev->dev, "Removing device\n");
+	iavf_misc_irq_disable(adapter);
 	/* Shut down all the garbage mashers on the detention level */
-	iavf_change_state(adapter, __IAVF_REMOVE);
+	cancel_work_sync(&adapter->reset_task);
+	cancel_delayed_work_sync(&adapter->watchdog_task);
+	cancel_work_sync(&adapter->adminq_task);
+	cancel_delayed_work_sync(&adapter->client_task);
+
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
-	iavf_misc_irq_disable(adapter);
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-	cancel_delayed_work_sync(&adapter->watchdog_task);
-
-	cancel_work_sync(&adapter->adminq_task);
-
 	iavf_free_rss(adapter);
 
 	if (hw->aq.asq.count)
@@ -4012,8 +4020,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	mutex_destroy(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	mutex_destroy(&adapter->crit_lock);
-	mutex_unlock(&adapter->remove_lock);
-	mutex_destroy(&adapter->remove_lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-- 
2.34.1



