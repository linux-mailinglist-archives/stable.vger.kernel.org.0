Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50E74CE6AB
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 21:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiCEUCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 15:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiCEUCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 15:02:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5DF21B4
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73BE6B80C75
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 20:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70F6C004E1;
        Sat,  5 Mar 2022 20:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646510480;
        bh=TEY46aM6vt7D+6Se4dcfdpJOlZ0DyWcGNAXL9zE6nfg=;
        h=Subject:To:Cc:From:Date:From;
        b=t7XfCUuJ0EvtegruUw4OcSklgeED2oQl1rTuv4WPpZe6nHxCuKGtMm63ID4dX109+
         hLTfNDIXjuDZJfDKt8ZepIkqgzc1W/40DXoOjvfg8BF3fhSYYYThqaquvtddAj1gH+
         jtK4jPCHiTDIdwqyQHHRBa90mE/CW7/LhvwvVgLg=
Subject: FAILED: patch "[PATCH] iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS" failed to apply to 5.16-stable tree
To:     slawomirx.laba@intel.com, anthony.l.nguyen@intel.com,
        jacob.e.keller@intel.com, konrad0.jankowski@intel.com,
        mateusz.palczewski@intel.com, phani.r.burra@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 21:01:09 +0100
Message-ID: <16465104691251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0579fafd37fb7efe091f0e6c8ccf968864f40f3e Mon Sep 17 00:00:00 2001
From: Slawomir Laba <slawomirx.laba@intel.com>
Date: Wed, 23 Feb 2022 13:37:50 +0100
Subject: [PATCH] iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS

iavf_virtchnl_completion is called under crit_lock but when
the code for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS is called,
this lock is released in order to obtain rtnl_lock to avoid
ABBA deadlock with unregister_netdev.

Along with the new way iavf_remove behaves, there exist
many risks related to the lock release and attmepts to regrab
it. The driver faces crashes related to races between
unregister_netdev and netdev_update_features. Yet another
risk is that the driver could already obtain the crit_lock
in order to destroy it and iavf_virtchnl_completion could
crash or block forever.

Make iavf_virtchnl_completion never relock crit_lock in it's
call paths.

Extract rtnl_lock locking logic to the driver for
unregister_netdev in order to set the netdev_registered flag
inside the lock.

Introduce a new flag that will inform adminq_task to perform
the code from VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS right after
it finishes processing messages. Guard this code with remove
flags so it's never called when the driver is in remove state.

Fixes: 5951a2b9812d ("iavf: Fix VLAN feature flags after VFR")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index f259fd517b2c..89423947ee65 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -287,6 +287,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_LEGACY_RX			BIT(15)
 #define IAVF_FLAG_REINIT_ITR_NEEDED		BIT(16)
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
+#define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index be51da978e7c..67349d24dc90 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2879,6 +2879,24 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
+	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
+		if (adapter->netdev_registered ||
+		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
+			struct net_device *netdev = adapter->netdev;
+
+			rtnl_lock();
+			netdev_update_features(netdev);
+			rtnl_unlock();
+			/* Request VLAN offload settings */
+			if (VLAN_V2_ALLOWED(adapter))
+				iavf_set_vlan_offload_features
+					(adapter, 0, netdev->features);
+
+			iavf_set_queue_vlan_tag_loc(adapter);
+		}
+
+		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
+	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
@@ -4606,8 +4624,10 @@ static void iavf_remove(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&adapter->watchdog_task);
 
 	if (adapter->netdev_registered) {
-		unregister_netdev(netdev);
+		rtnl_lock();
+		unregister_netdevice(netdev);
 		adapter->netdev_registered = false;
+		rtnl_unlock();
 	}
 	if (CLIENT_ALLOWED(adapter)) {
 		err = iavf_lan_del_device(adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 5ee1d118fd30..88844d68e150 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2146,29 +2146,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				     sizeof(adapter->vlan_v2_caps)));
 
 		iavf_process_config(adapter);
-
-		/* unlock crit_lock before acquiring rtnl_lock as other
-		 * processes holding rtnl_lock could be waiting for the same
-		 * crit_lock
-		 */
-		mutex_unlock(&adapter->crit_lock);
-		/* VLAN capabilities can change during VFR, so make sure to
-		 * update the netdev features with the new capabilities
-		 */
-		rtnl_lock();
-		netdev_update_features(netdev);
-		rtnl_unlock();
-		if (iavf_lock_timeout(&adapter->crit_lock, 10000))
-			dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",
-				 __FUNCTION__);
-
-		/* Request VLAN offload settings */
-		if (VLAN_V2_ALLOWED(adapter))
-			iavf_set_vlan_offload_features(adapter, 0,
-						       netdev->features);
-
-		iavf_set_queue_vlan_tag_loc(adapter);
-
+		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:

