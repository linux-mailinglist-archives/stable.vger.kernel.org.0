Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94064CF8CA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbiCGKC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239787AbiCGKAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247757CDD1;
        Mon,  7 Mar 2022 01:46:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF10B8102B;
        Mon,  7 Mar 2022 09:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74691C36AE9;
        Mon,  7 Mar 2022 09:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646378;
        bh=4Irywx2X3tkVd8vaupgjI9ak5hpRtJazXdKtTjI0760=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsAOvsZXiOTm04UHyoXRrL96VvYwxhgnggsDvlu397LSoSPEyOzc04gzilNtCILie
         YyRPBEJP9/27u4sc5n+2AgwAAjPJ6goyaj+cUElmCf8HyTIu7pzOkI9dF/qLoEBPeL
         ps8O/pHDIZsCZjPcwKZO/l4xEwJpyyQl0VQfJdg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Pawlak <jakub.pawlak@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/262] iavf: Combine init and watchdog state machines
Date:   Mon,  7 Mar 2022 10:19:29 +0100
Message-Id: <20220307091709.475536877@linuxfoundation.org>
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

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 898ef1cb1cb24040c3e89263e02c605af70c776a ]

Use single state machine for driver initialization and for service
initialized driver. The init state machine implemented in init_task()
is merged into the watchdog_task(). The init_task() function is
removed.

Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |   1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 136 ++++++++------------
 2 files changed, 57 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 9eb86c86f454..00d1ea313918 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -227,7 +227,6 @@ struct iavf_adapter {
 	struct work_struct reset_task;
 	struct work_struct adminq_task;
 	struct delayed_work client_task;
-	struct delayed_work init_task;
 	wait_queue_head_t down_waitqueue;
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 181d17945bbe..7bc8b646e37c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1978,7 +1978,48 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
+	if (adapter->flags & IAVF_FLAG_RESET_NEEDED &&
+	    adapter->state != __IAVF_RESETTING) {
+		iavf_change_state(adapter, __IAVF_RESETTING);
+		adapter->aq_required = 0;
+		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+	}
+
 	switch (adapter->state) {
+	case __IAVF_STARTUP:
+		iavf_startup(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(30));
+		return;
+	case __IAVF_INIT_VERSION_CHECK:
+		iavf_init_version_check(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(30));
+		return;
+	case __IAVF_INIT_GET_RESOURCES:
+		iavf_init_get_resources(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(1));
+		return;
+	case __IAVF_INIT_FAILED:
+		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
+			dev_err(&adapter->pdev->dev,
+				"Failed to communicate with PF; waiting before retry\n");
+			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
+			iavf_shutdown_adminq(hw);
+			mutex_unlock(&adapter->crit_lock);
+			queue_delayed_work(iavf_wq,
+					   &adapter->watchdog_task, (5 * HZ));
+			return;
+		}
+		/* Try again from failed step*/
+		iavf_change_state(adapter, adapter->last_state);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ);
+		return;
 	case __IAVF_COMM_FAILED:
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
@@ -1987,23 +2028,19 @@ static void iavf_watchdog_task(struct work_struct *work)
 			/* A chance for redemption! */
 			dev_err(&adapter->pdev->dev,
 				"Hardware came out of reset. Attempting reinit.\n");
-			iavf_change_state(adapter, __IAVF_STARTUP);
-			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
-			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
-			mutex_unlock(&adapter->crit_lock);
-			/* Don't reschedule the watchdog, since we've restarted
-			 * the init task. When init_task contacts the PF and
+			/* When init task contacts the PF and
 			 * gets everything set up again, it'll restart the
 			 * watchdog for us. Down, boy. Sit. Stay. Woof.
 			 */
-			return;
+			iavf_change_state(adapter, __IAVF_STARTUP);
+			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
-		goto watchdog_done;
+		return;
 	case __IAVF_RESETTING:
 		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
@@ -2026,12 +2063,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 			    adapter->state == __IAVF_RUNNING)
 				iavf_request_stats(adapter);
 		}
+		if (adapter->state == __IAVF_RUNNING)
+			iavf_detect_recover_hung(&adapter->vsi);
 		break;
 	case __IAVF_REMOVE:
 		mutex_unlock(&adapter->crit_lock);
 		return;
 	default:
-		goto restart_watchdog;
+		return;
 	}
 
 	/* check for hw reset */
@@ -2043,22 +2082,21 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		queue_work(iavf_wq, &adapter->reset_task);
-		goto watchdog_done;
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq,
+				   &adapter->watchdog_task, HZ * 2);
+		return;
 	}
 
 	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
-watchdog_done:
-	if (adapter->state == __IAVF_RUNNING ||
-	    adapter->state == __IAVF_COMM_FAILED)
-		iavf_detect_recover_hung(&adapter->vsi);
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
+	queue_work(iavf_wq, &adapter->adminq_task);
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
 	else
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
-	queue_work(iavf_wq, &adapter->adminq_task);
 }
 
 static void iavf_disable_vf(struct iavf_adapter *adapter)
@@ -2339,6 +2377,8 @@ static void iavf_reset_task(struct work_struct *work)
 reset_err:
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
+	if (running)
+		iavf_change_state(adapter, __IAVF_RUNNING);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }
@@ -3681,67 +3721,6 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	return 0;
 }
 
-/**
- * iavf_init_task - worker thread to perform delayed initialization
- * @work: pointer to work_struct containing our data
- *
- * This task completes the work that was begun in probe. Due to the nature
- * of VF-PF communications, we may need to wait tens of milliseconds to get
- * responses back from the PF. Rather than busy-wait in probe and bog down the
- * whole system, we'll do it in a task so we can sleep.
- * This task only runs during driver init. Once we've established
- * communications with the PF driver and set up our netdev, the watchdog
- * takes over.
- **/
-static void iavf_init_task(struct work_struct *work)
-{
-	struct iavf_adapter *adapter = container_of(work,
-						    struct iavf_adapter,
-						    init_task.work);
-	struct iavf_hw *hw = &adapter->hw;
-
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000)) {
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
-		return;
-	}
-	switch (adapter->state) {
-	case __IAVF_STARTUP:
-		iavf_startup(adapter);
-		if (adapter->state == __IAVF_INIT_FAILED)
-			goto init_failed;
-		break;
-	case __IAVF_INIT_VERSION_CHECK:
-		iavf_init_version_check(adapter);
-		if (adapter->state == __IAVF_INIT_FAILED)
-			goto init_failed;
-		break;
-	case __IAVF_INIT_GET_RESOURCES:
-		iavf_init_get_resources(adapter);
-		if (adapter->state == __IAVF_INIT_FAILED)
-			goto init_failed;
-		goto out;
-	default:
-		goto init_failed;
-	}
-
-	queue_delayed_work(iavf_wq, &adapter->init_task,
-			   msecs_to_jiffies(30));
-	goto out;
-init_failed:
-	if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
-		dev_err(&adapter->pdev->dev,
-			"Failed to communicate with PF; waiting before retry\n");
-		adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
-		iavf_shutdown_adminq(hw);
-		iavf_change_state(adapter, __IAVF_STARTUP);
-		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
-		goto out;
-	}
-	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
-out:
-	mutex_unlock(&adapter->crit_lock);
-}
-
 /**
  * iavf_shutdown - Shutdown the device in preparation for a reboot
  * @pdev: pci device structure
@@ -3876,8 +3855,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
 	INIT_DELAYED_WORK(&adapter->watchdog_task, iavf_watchdog_task);
 	INIT_DELAYED_WORK(&adapter->client_task, iavf_client_task);
-	INIT_DELAYED_WORK(&adapter->init_task, iavf_init_task);
-	queue_delayed_work(iavf_wq, &adapter->init_task,
+	queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
 
 	/* Setup the wait queue for indicating transition to down status */
@@ -3983,8 +3961,8 @@ static void iavf_remove(struct pci_dev *pdev)
 	int err;
 	/* Indicate we are in remove and not to run reset_task */
 	mutex_lock(&adapter->remove_lock);
-	cancel_delayed_work_sync(&adapter->init_task);
 	cancel_work_sync(&adapter->reset_task);
+	cancel_delayed_work_sync(&adapter->watchdog_task);
 	cancel_delayed_work_sync(&adapter->client_task);
 	if (adapter->netdev_registered) {
 		unregister_netdev(netdev);
-- 
2.34.1



