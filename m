Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9344C4CF8C8
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbiCGKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiCGKAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0196B7D01F;
        Mon,  7 Mar 2022 01:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 139FDB8102B;
        Mon,  7 Mar 2022 09:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E40C340E9;
        Mon,  7 Mar 2022 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646399;
        bh=vr8mNEQM1Q6qXcOOY94Mo84hOwzAVDPBT4c+/c+S1tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzgTAQC09wpWvp4TyhZRMgxDjeTGWM7urC1FS/hk/2M34JEX3s6ILM1oISLtZFLB0
         aS36eJVs66o1S+rSiLRORy71mgNfH43bQLP9Q4FgoND++YVKduT+v+hSv2CchmMK4w
         ClFnCk4aua8o+10FXnazptIdTQZDPfvsen34FfSw=
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
Subject: [PATCH 5.15 232/262] iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
Date:   Mon,  7 Mar 2022 10:19:36 +0100
Message-Id: <20220307091709.804962207@linuxfoundation.org>
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

[ Upstream commit 0579fafd37fb7efe091f0e6c8ccf968864f40f3e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h          |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 16 +++++++++++++++-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 14 +-------------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index ffc61993019b..9a122aea6979 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -274,6 +274,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_LEGACY_RX			BIT(15)
 #define IAVF_FLAG_REINIT_ITR_NEEDED		BIT(16)
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
+#define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 57ecdff870a1..d11e172252b4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2463,6 +2463,18 @@ static void iavf_adminq_task(struct work_struct *work)
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
+		}
+
+		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
+	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
@@ -4027,8 +4039,10 @@ static void iavf_remove(struct pci_dev *pdev)
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
index 845976a9ec5f..8a1c293b8c7a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1752,19 +1752,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		iavf_process_config(adapter);
-
-		/* unlock crit_lock before acquiring rtnl_lock as other
-		 * processes holding rtnl_lock could be waiting for the same
-		 * crit_lock
-		 */
-		mutex_unlock(&adapter->crit_lock);
-		rtnl_lock();
-		netdev_update_features(adapter->netdev);
-		rtnl_unlock();
-		if (iavf_lock_timeout(&adapter->crit_lock, 10000))
-			dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",
-				 __FUNCTION__);
-
+		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-- 
2.34.1



