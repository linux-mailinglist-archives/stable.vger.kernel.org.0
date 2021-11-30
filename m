Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A905462774
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhK2XF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbhK2XFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5BAC1A25D4;
        Mon, 29 Nov 2021 10:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E55B815E9;
        Mon, 29 Nov 2021 18:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8182C53FAD;
        Mon, 29 Nov 2021 18:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211088;
        bh=v43x3cy3qjf1sHutGq8J7GtRBlwd6NZ96Z2acG/BFyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vw3KX16DuL3Tp4yO+3Q7B9yKLph1pvPE6klrZFCJ2gPCqTYO9bm8qy0CLjw/36jI4
         0Jiu0/DflJ7WYBQN/9U4Eib1RweLkOkLsMEOSI1Y0g6Hm5Ad/96HQHSgz2EBpejtMB
         sLRmmnQ/XvTxzHl9VByIDUFvWkoynKqhEzvYxAsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/179] iavf: Fix VLAN feature flags after VFR
Date:   Mon, 29 Nov 2021 19:18:14 +0100
Message-Id: <20211129181722.219369760@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 5951a2b9812d8227d33f20d1899fae60e4f72c04 ]

When a VF goes through a reset, it's possible for the VF's feature set
to change. For example it may lose the VIRTCHNL_VF_OFFLOAD_VLAN
capability after VF reset. Unfortunately, the driver doesn't correctly
deal with this situation and errors are seen from downing/upping the
interface and/or moving the interface in/out of a network namespace.

When setting the interface down/up we see the following errors after the
VIRTCHNL_VF_OFFLOAD_VLAN capability was taken away from the VF:

ice 0000:51:00.1: VF 1 failed opcode 12, retval: -64 iavf 0000:51:09.1:
Failed to add VLAN filter, error IAVF_NOT_SUPPORTED ice 0000:51:00.1: VF
1 failed opcode 13, retval: -64 iavf 0000:51:09.1: Failed to delete VLAN
filter, error IAVF_NOT_SUPPORTED

These add/delete errors are happening because the VLAN filters are
tracked internally to the driver and regardless of the VLAN_ALLOWED()
setting the driver tries to delete/re-add them over virtchnl.

Fix the delete failure by making sure to delete any VLAN filter tracking
in the driver when a removal request is made, while preventing the
virtchnl request.  This makes it so the driver's VLAN list is up to date
and the errors are

Fix the add failure by making sure the check for VLAN_ALLOWED() during
reset is done after the VF receives its capability list from the PF via
VIRTCHNL_OP_GET_VF_RESOURCES. If VLAN functionality is not allowed, then
prevent requesting re-adding the filters over virtchnl.

When moving the interface into a network namespace we see the following
errors after the VIRTCHNL_VF_OFFLOAD_VLAN capability was taken away from
the VF:

iavf 0000:51:09.1 enp81s0f1v1: NIC Link is Up Speed is 25 Gbps Full Duplex
iavf 0000:51:09.1 temp_27: renamed from enp81s0f1v1
iavf 0000:51:09.1 mgmt: renamed from temp_27
iavf 0000:51:09.1 dev27: set_features() failed (-22); wanted 0x020190001fd54833, left 0x020190001fd54bb3

These errors are happening because we aren't correctly updating the
netdev capabilities and dealing with ndo_fix_features() and
ndo_set_features() correctly.

Fix this by only reporting errors in the driver's ndo_set_features()
callback when VIRTCHNL_VF_OFFLOAD_VLAN is not allowed and any attempt to
enable the VLAN features is made. Also, make sure to disable VLAN
insertion, filtering, and stripping since the VIRTCHNL_VF_OFFLOAD_VLAN
flag applies to all of them and not just VLAN stripping.

Also, after we process the capabilities in the VF reset path, make sure
to call netdev_update_features() in case the capabilities have changed
in order to update the netdev's feature set to match the VF's actual
capabilities.

Lastly, make sure to always report success on VLAN filter delete when
VIRTCHNL_VF_OFFLOAD_VLAN is not supported. The changed flow in
iavf_del_vlans() allows the stack to delete previosly existing VLAN
filters even if VLAN filtering is not allowed. This makes it so the VLAN
filter list is up to date.

Fixes: 8774370d268f ("i40e/i40evf: support for VF VLAN tag stripping control")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 33 ++++++--------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 45 +++++++++++++++++--
 3 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index dd81698f0d596..0ae6da2992d01 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -457,4 +457,5 @@ void iavf_add_adv_rss_cfg(struct iavf_adapter *adapter);
 void iavf_del_adv_rss_cfg(struct iavf_adapter *adapter);
 struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 					const u8 *macaddr);
+int iavf_lock_timeout(struct mutex *lock, unsigned int msecs);
 #endif /* _IAVF_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5173b6293c6d9..fd3717ae70ab1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -138,7 +138,7 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
  *
  * Returns 0 on success, negative on failure
  **/
-static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
+int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
 {
 	unsigned int wait, delay = 10;
 
@@ -708,13 +708,11 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, u16 vlan)
  **/
 static void iavf_restore_filters(struct iavf_adapter *adapter)
 {
-	/* re-add all VLAN filters */
-	if (VLAN_ALLOWED(adapter)) {
-		u16 vid;
+	u16 vid;
 
-		for_each_set_bit(vid, adapter->vsi.active_vlans, VLAN_N_VID)
-			iavf_add_vlan(adapter, vid);
-	}
+	/* re-add all VLAN filters */
+	for_each_set_bit(vid, adapter->vsi.active_vlans, VLAN_N_VID)
+		iavf_add_vlan(adapter, vid);
 }
 
 /**
@@ -749,9 +747,6 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (!VLAN_ALLOWED(adapter))
-		return -EIO;
-
 	iavf_del_vlan(adapter, vid);
 	clear_bit(vid, adapter->vsi.active_vlans);
 
@@ -2142,7 +2137,6 @@ static void iavf_reset_task(struct work_struct *work)
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_mac_filter *f, *ftmp;
-	struct iavf_vlan_filter *vlf;
 	struct iavf_cloud_filter *cf;
 	u32 reg_val;
 	int i = 0, err;
@@ -2282,11 +2276,6 @@ static void iavf_reset_task(struct work_struct *work)
 	list_for_each_entry(f, &adapter->mac_filter_list, list) {
 		f->add = true;
 	}
-	/* re-add all VLAN filters */
-	list_for_each_entry(vlf, &adapter->vlan_filter_list, list) {
-		vlf->add = true;
-	}
-
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
 	/* check if TCs are running and re-add all cloud filters */
@@ -2300,7 +2289,6 @@ static void iavf_reset_task(struct work_struct *work)
 	spin_unlock_bh(&adapter->cloud_filter_list_lock);
 
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
-	adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_CLOUD_FILTER;
 	iavf_misc_irq_enable(adapter);
 
@@ -3398,11 +3386,16 @@ static int iavf_set_features(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	/* Don't allow changing VLAN_RX flag when adapter is not capable
-	 * of VLAN offload
+	/* Don't allow enabling VLAN features when adapter is not capable
+	 * of VLAN offload/filtering
 	 */
 	if (!VLAN_ALLOWED(adapter)) {
-		if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX)
+		netdev->hw_features &= ~(NETIF_F_HW_VLAN_CTAG_RX |
+					 NETIF_F_HW_VLAN_CTAG_TX |
+					 NETIF_F_HW_VLAN_CTAG_FILTER);
+		if (features & (NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_FILTER))
 			return -EINVAL;
 	} else if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 33bde032ca37e..08302ab35d687 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -607,7 +607,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		if (f->add)
 			count++;
 	}
-	if (!count) {
+	if (!count || !VLAN_ALLOWED(adapter)) {
 		adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		return;
@@ -673,9 +673,19 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
-	list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-		if (f->remove)
+	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
+		/* since VLAN capabilities are not allowed, we dont want to send
+		 * a VLAN delete request because it will most likely fail and
+		 * create unnecessary errors/noise, so just free the VLAN
+		 * filters marked for removal to enable bailing out before
+		 * sending a virtchnl message
+		 */
+		if (f->remove && !VLAN_ALLOWED(adapter)) {
+			list_del(&f->list);
+			kfree(f);
+		} else if (f->remove) {
 			count++;
+		}
 	}
 	if (!count) {
 		adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_VLAN_FILTER;
@@ -1724,8 +1734,37 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		iavf_add_filter(adapter, adapter->hw.mac.addr);
+
+		if (VLAN_ALLOWED(adapter)) {
+			if (!list_empty(&adapter->vlan_filter_list)) {
+				struct iavf_vlan_filter *vlf;
+
+				/* re-add all VLAN filters over virtchnl */
+				list_for_each_entry(vlf,
+						    &adapter->vlan_filter_list,
+						    list)
+					vlf->add = true;
+
+				adapter->aq_required |=
+					IAVF_FLAG_AQ_ADD_VLAN_FILTER;
+			}
+		}
+
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		iavf_process_config(adapter);
+
+		/* unlock crit_lock before acquiring rtnl_lock as other
+		 * processes holding rtnl_lock could be waiting for the same
+		 * crit_lock
+		 */
+		mutex_unlock(&adapter->crit_lock);
+		rtnl_lock();
+		netdev_update_features(adapter->netdev);
+		rtnl_unlock();
+		if (iavf_lock_timeout(&adapter->crit_lock, 10000))
+			dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",
+				 __FUNCTION__);
+
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-- 
2.33.0



