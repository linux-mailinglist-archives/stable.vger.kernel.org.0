Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE196E63F5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjDRMo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjDRMoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37F91563D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7AD63379
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5DDC433EF;
        Tue, 18 Apr 2023 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821891;
        bh=BOMOa3HU8GtioO/6eIjetEj0GhnIOepnbEndJrNkLx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2at11C8csBrjq7Os++CS+tGVIe3Czi6nU0m9hyPOx8NNeCvpyZleVP+6lkli0Fms
         Ba8Ehy67aSjJ/3ZCYNHI05R12hRpyBe5YmutmU/kC3X2o/MMH6kPRv5lXaQawt+Vh6
         WCk3/IPWs2l2t/wMA2wSdXBtpdFovCzmOh9WadXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ahmed Zaki <ahmed.zaki@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/134] iavf: refactor VLAN filter states
Date:   Tue, 18 Apr 2023 14:21:47 +0200
Message-Id: <20230418120314.733160721@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit 0c0da0e951053fda20412cd284e2714bbbb31bff ]

The VLAN filter states are currently being saved as individual bits.
This is error prone as multiple bits might be mistakenly set.

Fix by replacing the bits with a single state enum. Also, add an
"ACTIVE" state for filters that are accepted by the PF.

Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 9c85b7fa12ef ("iavf: remove active_cvlans and active_svlans bitmaps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        | 15 +++++----
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 ++---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 31 +++++++++----------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 2a9f1eeeb7015..fdbb5d9a554cf 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -157,15 +157,18 @@ struct iavf_vlan {
 	u16 tpid;
 };
 
+enum iavf_vlan_state_t {
+	IAVF_VLAN_INVALID,
+	IAVF_VLAN_ADD,		/* filter needs to be added */
+	IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
+	IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
+	IAVF_VLAN_REMOVE,	/* filter needs to be removed */
+};
+
 struct iavf_vlan_filter {
 	struct list_head list;
 	struct iavf_vlan vlan;
-	struct {
-		u8 is_new_vlan:1;	/* filter is new, wait for PF answer */
-		u8 remove:1;		/* filter needs to be removed */
-		u8 add:1;		/* filter needs to be added */
-		u8 padding:5;
-	};
+	enum iavf_vlan_state_t state;
 };
 
 #define IAVF_MAX_TRAFFIC_CLASS	4
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5f8fff6c701fc..8e4d0b0644e4a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -791,7 +791,7 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
 		f->vlan = vlan;
 
 		list_add_tail(&f->list, &adapter->vlan_filter_list);
-		f->add = true;
+		f->state = IAVF_VLAN_ADD;
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 	}
 
@@ -813,7 +813,7 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, struct iavf_vlan vlan)
 
 	f = iavf_find_vlan(adapter, vlan);
 	if (f) {
-		f->remove = true;
+		f->state = IAVF_VLAN_REMOVE;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
 	}
 
@@ -1296,11 +1296,11 @@ static void iavf_clear_mac_vlan_filters(struct iavf_adapter *adapter)
 	/* remove all VLAN filters */
 	list_for_each_entry_safe(vlf, vlftmp, &adapter->vlan_filter_list,
 				 list) {
-		if (vlf->add) {
+		if (vlf->state == IAVF_VLAN_ADD) {
 			list_del(&vlf->list);
 			kfree(vlf);
 		} else {
-			vlf->remove = true;
+			vlf->state = IAVF_VLAN_REMOVE;
 		}
 	}
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 2c03ca01fdd9c..68d6e7c1e52b1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -642,7 +642,7 @@ static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-		if (f->is_new_vlan) {
+		if (f->state == IAVF_VLAN_IS_NEW) {
 			if (f->vlan.tpid == ETH_P_8021Q)
 				clear_bit(f->vlan.vid,
 					  adapter->vsi.active_cvlans);
@@ -679,7 +679,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
 	list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-		if (f->add)
+		if (f->state == IAVF_VLAN_ADD)
 			count++;
 	}
 	if (!count || !VLAN_FILTERING_ALLOWED(adapter)) {
@@ -710,11 +710,10 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		vvfl->vsi_id = adapter->vsi_res->vsi_id;
 		vvfl->num_elements = count;
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->add) {
+			if (f->state == IAVF_VLAN_ADD) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
-				f->add = false;
-				f->is_new_vlan = true;
+				f->state = IAVF_VLAN_IS_NEW;
 				if (i == count)
 					break;
 			}
@@ -760,7 +759,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
 		vvfl_v2->num_elements = count;
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->add) {
+			if (f->state == IAVF_VLAN_ADD) {
 				struct virtchnl_vlan_supported_caps *filtering_support =
 					&adapter->vlan_v2_caps.filtering.filtering_support;
 				struct virtchnl_vlan *vlan;
@@ -778,8 +777,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 				vlan->tpid = f->vlan.tpid;
 
 				i++;
-				f->add = false;
-				f->is_new_vlan = true;
+				f->state = IAVF_VLAN_IS_NEW;
 			}
 		}
 
@@ -822,10 +820,11 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		 * filters marked for removal to enable bailing out before
 		 * sending a virtchnl message
 		 */
-		if (f->remove && !VLAN_FILTERING_ALLOWED(adapter)) {
+		if (f->state == IAVF_VLAN_REMOVE &&
+		    !VLAN_FILTERING_ALLOWED(adapter)) {
 			list_del(&f->list);
 			kfree(f);
-		} else if (f->remove) {
+		} else if (f->state == IAVF_VLAN_REMOVE) {
 			count++;
 		}
 	}
@@ -857,7 +856,7 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		vvfl->vsi_id = adapter->vsi_res->vsi_id;
 		vvfl->num_elements = count;
 		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-			if (f->remove) {
+			if (f->state == IAVF_VLAN_REMOVE) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
 				list_del(&f->list);
@@ -901,7 +900,7 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
 		vvfl_v2->num_elements = count;
 		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-			if (f->remove) {
+			if (f->state == IAVF_VLAN_REMOVE) {
 				struct virtchnl_vlan_supported_caps *filtering_support =
 					&adapter->vlan_v2_caps.filtering.filtering_support;
 				struct virtchnl_vlan *vlan;
@@ -2192,7 +2191,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				list_for_each_entry(vlf,
 						    &adapter->vlan_filter_list,
 						    list)
-					vlf->add = true;
+					vlf->state = IAVF_VLAN_ADD;
 
 				adapter->aq_required |=
 					IAVF_FLAG_AQ_ADD_VLAN_FILTER;
@@ -2252,7 +2251,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				list_for_each_entry(vlf,
 						    &adapter->vlan_filter_list,
 						    list)
-					vlf->add = true;
+					vlf->state = IAVF_VLAN_ADD;
 
 				aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 			}
@@ -2436,8 +2435,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->is_new_vlan) {
-				f->is_new_vlan = false;
+			if (f->state == IAVF_VLAN_IS_NEW) {
+				f->state = IAVF_VLAN_ACTIVE;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
-- 
2.39.2



