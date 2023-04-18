Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335886E6482
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjDRMtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjDRMtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6CC9EDB
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 617D563403
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F53C433EF;
        Tue, 18 Apr 2023 12:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822182;
        bh=wEgsZc06oArpxDnWfdbtJsOT8u7d4WnWNfpZnahyaTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMUqCiWl+kk1C7ovYChwe/yOHYxT5kLcZ0mx9b0nfv7Lom6/hDES5ISux+6gFc/02
         ccDRegdwB8yrzmzv2zXc+QIDK8CgoDiZ28XIiPlrjuPBlr5IOubzmDSrRXSDj+HC3R
         GlK1/GLG5UzYF0YDGYplSxPsuV5zrU2yLlejo11c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ahmed Zaki <ahmed.zaki@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 054/139] iavf: remove active_cvlans and active_svlans bitmaps
Date:   Tue, 18 Apr 2023 14:21:59 +0200
Message-Id: <20230418120315.760429203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit 9c85b7fa12ef2e4fc11a4e31ac595fb5f9d0ddf9 ]

The VLAN filters info is currently being held in a list and 2 bitmaps
(active_cvlans and active_svlans). We are experiencing some racing where
data is not in sync in the list and bitmaps. For example, the VLAN is
initially added to the list but only when the PF replies, it is added to
the bitmap. If a user adds many V2 VLANS before the PF responds:

    while [ $((i++)) ]
        ip l add l eth0 name eth0.$i type vlan id $i

we might end up with more VLAN list entries than the designated limit.
Also, The "ip link show" will show more links added than the PF limit.

On the other and, the bitmaps are only used to check the number of VLAN
filters and to re-enable the filters when the interface goes from DOWN to
UP.

This patch gets rid of the bitmaps and uses the list only. To do that,
the states of the VLAN filter are modified:
1 - IAVF_VLAN_REMOVE: the entry needs to be totally removed after informing
  the PF. This is the "ip link del eth0.$i" path.
2 - IAVF_VLAN_DISABLE: (new) the netdev went down. The filter needs to be
  removed from the PF and then marked INACTIVE.
3 - IAVF_VLAN_INACTIVE: (new) no PF filter exists, but the user did not
  delete the VLAN.

Fixes: 48ccc43ecf10 ("iavf: Add support VIRTCHNL_VF_OFFLOAD_VLAN_V2 during netdev config")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  7 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 40 +++++++----------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 45 ++++++++++---------
 3 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index fdbb5d9a554cf..93a998f169de7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -58,8 +58,6 @@ enum iavf_vsi_state_t {
 struct iavf_vsi {
 	struct iavf_adapter *back;
 	struct net_device *netdev;
-	unsigned long active_cvlans[BITS_TO_LONGS(VLAN_N_VID)];
-	unsigned long active_svlans[BITS_TO_LONGS(VLAN_N_VID)];
 	u16 seid;
 	u16 id;
 	DECLARE_BITMAP(state, __IAVF_VSI_STATE_SIZE__);
@@ -162,7 +160,9 @@ enum iavf_vlan_state_t {
 	IAVF_VLAN_ADD,		/* filter needs to be added */
 	IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
 	IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
-	IAVF_VLAN_REMOVE,	/* filter needs to be removed */
+	IAVF_VLAN_DISABLE,	/* filter needs to be deleted by PF, then marked INACTIVE */
+	IAVF_VLAN_INACTIVE,	/* filter is inactive, we are in IFF_DOWN */
+	IAVF_VLAN_REMOVE,	/* filter needs to be removed from list */
 };
 
 struct iavf_vlan_filter {
@@ -260,6 +260,7 @@ struct iavf_adapter {
 	wait_queue_head_t vc_waitqueue;
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
+	int num_vlan_filters;
 	struct list_head mac_filter_list;
 	struct mutex crit_lock;
 	struct mutex client_lock;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3faa9e4d0ba5b..05a0ea96dd11a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -792,6 +792,7 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
 
 		list_add_tail(&f->list, &adapter->vlan_filter_list);
 		f->state = IAVF_VLAN_ADD;
+		adapter->num_vlan_filters++;
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 	}
 
@@ -828,14 +829,18 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, struct iavf_vlan vlan)
  **/
 static void iavf_restore_filters(struct iavf_adapter *adapter)
 {
-	u16 vid;
+	struct iavf_vlan_filter *f;
 
 	/* re-add all VLAN filters */
-	for_each_set_bit(vid, adapter->vsi.active_cvlans, VLAN_N_VID)
-		iavf_add_vlan(adapter, IAVF_VLAN(vid, ETH_P_8021Q));
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
-	for_each_set_bit(vid, adapter->vsi.active_svlans, VLAN_N_VID)
-		iavf_add_vlan(adapter, IAVF_VLAN(vid, ETH_P_8021AD));
+	list_for_each_entry(f, &adapter->vlan_filter_list, list) {
+		if (f->state == IAVF_VLAN_INACTIVE)
+			f->state = IAVF_VLAN_ADD;
+	}
+
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+	adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 }
 
 /**
@@ -844,8 +849,7 @@ static void iavf_restore_filters(struct iavf_adapter *adapter)
  */
 u16 iavf_get_num_vlans_added(struct iavf_adapter *adapter)
 {
-	return bitmap_weight(adapter->vsi.active_cvlans, VLAN_N_VID) +
-		bitmap_weight(adapter->vsi.active_svlans, VLAN_N_VID);
+	return adapter->num_vlan_filters;
 }
 
 /**
@@ -928,11 +932,6 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 		return 0;
 
 	iavf_del_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto)));
-	if (proto == cpu_to_be16(ETH_P_8021Q))
-		clear_bit(vid, adapter->vsi.active_cvlans);
-	else
-		clear_bit(vid, adapter->vsi.active_svlans);
-
 	return 0;
 }
 
@@ -1293,16 +1292,11 @@ static void iavf_clear_mac_vlan_filters(struct iavf_adapter *adapter)
 		}
 	}
 
-	/* remove all VLAN filters */
+	/* disable all VLAN filters */
 	list_for_each_entry_safe(vlf, vlftmp, &adapter->vlan_filter_list,
-				 list) {
-		if (vlf->state == IAVF_VLAN_ADD) {
-			list_del(&vlf->list);
-			kfree(vlf);
-		} else {
-			vlf->state = IAVF_VLAN_REMOVE;
-		}
-	}
+				 list)
+		vlf->state = IAVF_VLAN_DISABLE;
+
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 }
 
@@ -2914,6 +2908,7 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 		list_del(&fv->list);
 		kfree(fv);
 	}
+	adapter->num_vlan_filters = 0;
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
@@ -3131,9 +3126,6 @@ static void iavf_reset_task(struct work_struct *work)
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_CLOUD_FILTER;
 	iavf_misc_irq_enable(adapter);
 
-	bitmap_clear(adapter->vsi.active_cvlans, 0, VLAN_N_VID);
-	bitmap_clear(adapter->vsi.active_svlans, 0, VLAN_N_VID);
-
 	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 2);
 
 	/* We were running when the reset started, so we need to restore some
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index fd0239832ffc7..07d37402a0df5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -643,15 +643,9 @@ static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
 		if (f->state == IAVF_VLAN_IS_NEW) {
-			if (f->vlan.tpid == ETH_P_8021Q)
-				clear_bit(f->vlan.vid,
-					  adapter->vsi.active_cvlans);
-			else
-				clear_bit(f->vlan.vid,
-					  adapter->vsi.active_svlans);
-
 			list_del(&f->list);
 			kfree(f);
+			adapter->num_vlan_filters--;
 		}
 	}
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
@@ -824,7 +818,12 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		    !VLAN_FILTERING_ALLOWED(adapter)) {
 			list_del(&f->list);
 			kfree(f);
-		} else if (f->state == IAVF_VLAN_REMOVE) {
+			adapter->num_vlan_filters--;
+		} else if (f->state == IAVF_VLAN_DISABLE &&
+		    !VLAN_FILTERING_ALLOWED(adapter)) {
+			f->state = IAVF_VLAN_INACTIVE;
+		} else if (f->state == IAVF_VLAN_REMOVE ||
+			   f->state == IAVF_VLAN_DISABLE) {
 			count++;
 		}
 	}
@@ -856,11 +855,18 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		vvfl->vsi_id = adapter->vsi_res->vsi_id;
 		vvfl->num_elements = count;
 		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-			if (f->state == IAVF_VLAN_REMOVE) {
+			if (f->state == IAVF_VLAN_DISABLE) {
 				vvfl->vlan_id[i] = f->vlan.vid;
+				f->state = IAVF_VLAN_INACTIVE;
 				i++;
+				if (i == count)
+					break;
+			} else if (f->state == IAVF_VLAN_REMOVE) {
+				vvfl->vlan_id[i] = f->vlan.vid;
 				list_del(&f->list);
 				kfree(f);
+				adapter->num_vlan_filters--;
+				i++;
 				if (i == count)
 					break;
 			}
@@ -900,7 +906,8 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
 		vvfl_v2->num_elements = count;
 		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-			if (f->state == IAVF_VLAN_REMOVE) {
+			if (f->state == IAVF_VLAN_DISABLE ||
+			    f->state == IAVF_VLAN_REMOVE) {
 				struct virtchnl_vlan_supported_caps *filtering_support =
 					&adapter->vlan_v2_caps.filtering.filtering_support;
 				struct virtchnl_vlan *vlan;
@@ -914,8 +921,13 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 				vlan->tci = f->vlan.vid;
 				vlan->tpid = f->vlan.tpid;
 
-				list_del(&f->list);
-				kfree(f);
+				if (f->state == IAVF_VLAN_DISABLE) {
+					f->state = IAVF_VLAN_INACTIVE;
+				} else {
+					list_del(&f->list);
+					kfree(f);
+					adapter->num_vlan_filters--;
+				}
 				i++;
 				if (i == count)
 					break;
@@ -2443,15 +2455,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->state == IAVF_VLAN_IS_NEW) {
+			if (f->state == IAVF_VLAN_IS_NEW)
 				f->state = IAVF_VLAN_ACTIVE;
-				if (f->vlan.tpid == ETH_P_8021Q)
-					set_bit(f->vlan.vid,
-						adapter->vsi.active_cvlans);
-				else
-					set_bit(f->vlan.vid,
-						adapter->vsi.active_svlans);
-			}
 		}
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		}
-- 
2.39.2



