Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D634FC0FD
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348059AbiDKPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348077AbiDKPi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:38:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82393A715
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D1EB816C8
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97147C385A4;
        Mon, 11 Apr 2022 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649691399;
        bh=2KGDaLr6Gy8CNFZzh7nqhoNbK8sIMMJWBeyElgLxz/o=;
        h=Subject:To:Cc:From:Date:From;
        b=p+R3PkKAbflbm5ocHpMX7C+/gbOczMv9m1qf6vY1178s+Nh+y3zZYWMPm5cg7ro2h
         R7Iu6FI4XmqyegbQVgNQsiLirDTuZVWJiRui4qij1jpFoBVu++ekf3i5tSy6RSkdEi
         np4TQJi9d/5FgX/bXK5Zox+qIn3oDBDJTQAyklJ8=
Subject: FAILED: patch "[PATCH] ice: Fix broken IFF_ALLMULTI handling" failed to apply to 5.15-stable tree
To:     ivecera@redhat.com, alice.michael@intel.com, davem@davemloft.net,
        jacob.e.keller@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 17:36:32 +0200
Message-ID: <164969139221115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1273f89578f268ea705ddbad60c4bd2dcff80611 Mon Sep 17 00:00:00 2001
From: Ivan Vecera <ivecera@redhat.com>
Date: Thu, 31 Mar 2022 09:20:08 -0700
Subject: [PATCH] ice: Fix broken IFF_ALLMULTI handling

Handling of all-multicast flag and associated multicast promiscuous
mode is broken in ice driver. When an user switches allmulticast
flag on or off the driver checks whether any VLANs are configured
over the interface (except default VLAN 0).

If any extra VLANs are registered it enables multicast promiscuous
mode for all these VLANs (including default VLAN 0) using
ICE_SW_LKUP_PROMISC_VLAN look-up type. In this situation all
multicast packets tagged with known VLAN ID or untagged are received
and multicast packets tagged with unknown VLAN ID ignored.

If no extra VLANs are registered (so only VLAN 0 exists) it enables
multicast promiscuous mode for VLAN 0 and uses ICE_SW_LKUP_PROMISC
look-up type. In this situation any multicast packets including
tagged ones are received.

The driver handles IFF_ALLMULTI in ice_vsi_sync_fltr() this way:

ice_vsi_sync_fltr() {
  ...
  if (changed_flags & IFF_ALLMULTI) {
    if (netdev->flags & IFF_ALLMULTI) {
      if (vsi->num_vlans > 1)
        ice_set_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS);
      else
        ice_set_promisc(..., ICE_MCAST_PROMISC_BITS);
    } else {
      if (vsi->num_vlans > 1)
        ice_clear_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS);
      else
        ice_clear_promisc(..., ICE_MCAST_PROMISC_BITS);
    }
  }
  ...
}

The code above depends on value vsi->num_vlan that specifies number
of VLANs configured over the interface (including VLAN 0) and
this is problem because that value is modified in NDO callbacks
ice_vlan_rx_add_vid() and ice_vlan_rx_kill_vid().

Scenario 1:
1. ip link set ens7f0 allmulticast on
2. ip link add vlan10 link ens7f0 type vlan id 10
3. ip link set ens7f0 allmulticast off
4. ip link set ens7f0 allmulticast on

[1] In this scenario IFF_ALLMULTI is enabled and the driver calls
    ice_set_promisc(..., ICE_MCAST_PROMISC_BITS) that installs
    multicast promisc rule with non-VLAN look-up type.
[2] Then VLAN with ID 10 is added and vsi->num_vlan incremented to 2
[3] Command switches IFF_ALLMULTI off and the driver calls
    ice_clear_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS) but this
    call is effectively NOP because it looks for multicast promisc
    rules for VLAN 0 and VLAN 10 with VLAN look-up type but no such
    rules exist. So the all-multicast remains enabled silently
    in hardware.
[4] Command tries to switch IFF_ALLMULTI on and the driver calls
    ice_clear_promisc(..., ICE_MCAST_PROMISC_BITS) but this call
    fails (-EEXIST) because non-VLAN multicast promisc rule already
    exists.

Scenario 2:
1. ip link add vlan10 link ens7f0 type vlan id 10
2. ip link set ens7f0 allmulticast on
3. ip link add vlan20 link ens7f0 type vlan id 20
4. ip link del vlan10 ; ip link del vlan20
5. ip link set ens7f0 allmulticast off

[1] VLAN with ID 10 is added and vsi->num_vlan==2
[2] Command switches IFF_ALLMULTI on and driver installs multicast
    promisc rules with VLAN look-up type for VLAN 0 and 10
[3] VLAN with ID 20 is added and vsi->num_vlan==3 but no multicast
    promisc rules is added for this new VLAN so the interface does
    not receive MC packets from VLAN 20
[4] Both VLANs are removed but multicast rule for VLAN 10 remains
    installed so interface receives multicast packets from VLAN 10
[5] Command switches IFF_ALLMULTI off and because vsi->num_vlan is 1
    the driver tries to remove multicast promisc rule for VLAN 0
    with non-VLAN look-up that does not exist.
    All-multicast looks disabled from user point of view but it
    is partially enabled in HW (interface receives all multicast
    packets either untagged or tagged with VLAN ID 10)

To resolve these issues the patch introduces these changes:
1. Adds handling for IFF_ALLMULTI to ice_vlan_rx_add_vid() and
   ice_vlan_rx_kill_vid() callbacks. So when VLAN is added/removed
   and IFF_ALLMULTI is enabled an appropriate multicast promisc
   rule for that VLAN ID is added/removed.
2. In ice_vlan_rx_add_vid() when first VLAN besides VLAN 0 is added
   so (vsi->num_vlan == 2) and IFF_ALLMULTI is enabled then look-up
   type for existing multicast promisc rule for VLAN 0 is updated
   to ICE_MCAST_VLAN_PROMISC_BITS.
3. In ice_vlan_rx_kill_vid() when last VLAN besides VLAN 0 is removed
   so (vsi->num_vlan == 1) and IFF_ALLMULTI is enabled then look-up
   type for existing multicast promisc rule for VLAN 0 is updated
   to ICE_MCAST_PROMISC_BITS.
4. Both ice_vlan_rx_{add,kill}_vid() have to run under ICE_CFG_BUSY
   bit protection to avoid races with ice_vsi_sync_fltr() that runs
   in ice_service_task() context.
5. Bit ICE_VSI_VLAN_FLTR_CHANGED is use-less and can be removed.
6. Error messages added to ice_fltr_*_vsi_promisc() helper functions
   to avoid them in their callers
7. Small improvements to increase readability

Fixes: 5eda8afd6bcc ("ice: Add support for PF/VF promiscuous mode")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index d4f1874df7d0..26eaee0b6503 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -301,7 +301,6 @@ enum ice_vsi_state {
 	ICE_VSI_NETDEV_REGISTERED,
 	ICE_VSI_UMAC_FLTR_CHANGED,
 	ICE_VSI_MMAC_FLTR_CHANGED,
-	ICE_VSI_VLAN_FLTR_CHANGED,
 	ICE_VSI_PROMISC_CHANGED,
 	ICE_VSI_STATE_NBITS		/* must be last */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index af57eb114966..85a94483c2ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -58,7 +58,16 @@ int
 ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
 			      u8 promisc_mask)
 {
-	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error setting promisc mode on VSI %i (rc=%d)\n",
+			vsi->vsi_num, result);
+
+	return result;
 }
 
 /**
@@ -73,7 +82,16 @@ int
 ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
 				u8 promisc_mask)
 {
-	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error clearing promisc mode on VSI %i (rc=%d)\n",
+			vsi->vsi_num, result);
+
+	return result;
 }
 
 /**
@@ -87,7 +105,16 @@ int
 ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 			   u16 vid)
 {
-	return ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error clearing promisc mode on VSI %i for VID %u (rc=%d)\n",
+			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
+
+	return result;
 }
 
 /**
@@ -101,7 +128,16 @@ int
 ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 			 u16 vid)
 {
-	return ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error setting promisc mode on VSI %i for VID %u (rc=%d)\n",
+			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
+
+	return result;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d755ce07869f..1d2ca39add95 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -243,8 +243,7 @@ static int ice_add_mac_to_unsync_list(struct net_device *netdev, const u8 *addr)
 static bool ice_vsi_fltr_changed(struct ice_vsi *vsi)
 {
 	return test_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state) ||
-	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state) ||
-	       test_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
+	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
 }
 
 /**
@@ -260,10 +259,15 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (ice_vsi_has_non_zero_vlans(vsi))
-		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
-	else
-		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
+	if (ice_vsi_has_non_zero_vlans(vsi)) {
+		promisc_m |= (ICE_PROMISC_VLAN_RX | ICE_PROMISC_VLAN_TX);
+		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi,
+						       promisc_m);
+	} else {
+		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+						  promisc_m, 0);
+	}
+
 	return status;
 }
 
@@ -280,10 +284,15 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (ice_vsi_has_non_zero_vlans(vsi))
-		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
-	else
-		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
+	if (ice_vsi_has_non_zero_vlans(vsi)) {
+		promisc_m |= (ICE_PROMISC_VLAN_RX | ICE_PROMISC_VLAN_TX);
+		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi,
+							 promisc_m);
+	} else {
+		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+						    promisc_m, 0);
+	}
+
 	return status;
 }
 
@@ -302,7 +311,6 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	u32 changed_flags = 0;
-	u8 promisc_m;
 	int err;
 
 	if (!vsi->netdev)
@@ -320,7 +328,6 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	if (ice_vsi_fltr_changed(vsi)) {
 		clear_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
 		clear_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
-		clear_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 
 		/* grab the netdev's addr_list_lock */
 		netif_addr_lock_bh(netdev);
@@ -369,29 +376,15 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	/* check for changes in promiscuous modes */
 	if (changed_flags & IFF_ALLMULTI) {
 		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
-			if (ice_vsi_has_non_zero_vlans(vsi))
-				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_MCAST_PROMISC_BITS;
-
-			err = ice_set_promisc(vsi, promisc_m);
+			err = ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
 			if (err) {
-				netdev_err(netdev, "Error setting Multicast promiscuous mode on VSI %i\n",
-					   vsi->vsi_num);
 				vsi->current_netdev_flags &= ~IFF_ALLMULTI;
 				goto out_promisc;
 			}
 		} else {
 			/* !(vsi->current_netdev_flags & IFF_ALLMULTI) */
-			if (ice_vsi_has_non_zero_vlans(vsi))
-				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_MCAST_PROMISC_BITS;
-
-			err = ice_clear_promisc(vsi, promisc_m);
+			err = ice_clear_promisc(vsi, ICE_MCAST_PROMISC_BITS);
 			if (err) {
-				netdev_err(netdev, "Error clearing Multicast promiscuous mode on VSI %i\n",
-					   vsi->vsi_num);
 				vsi->current_netdev_flags |= IFF_ALLMULTI;
 				goto out_promisc;
 			}
@@ -3488,6 +3481,20 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	if (!vid)
 		return 0;
 
+	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
+		usleep_range(1000, 2000);
+
+	/* Add multicast promisc rule for the VLAN ID to be added if
+	 * all-multicast is currently enabled.
+	 */
+	if (vsi->current_netdev_flags & IFF_ALLMULTI) {
+		ret = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+					       ICE_MCAST_VLAN_PROMISC_BITS,
+					       vid);
+		if (ret)
+			goto finish;
+	}
+
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	/* Add a switch rule for this VLAN ID so its corresponding VLAN tagged
@@ -3495,8 +3502,23 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	 */
 	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
 	ret = vlan_ops->add_vlan(vsi, &vlan);
-	if (!ret)
-		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
+	if (ret)
+		goto finish;
+
+	/* If all-multicast is currently enabled and this VLAN ID is only one
+	 * besides VLAN-0 we have to update look-up type of multicast promisc
+	 * rule for VLAN-0 from ICE_SW_LKUP_PROMISC to ICE_SW_LKUP_PROMISC_VLAN.
+	 */
+	if ((vsi->current_netdev_flags & IFF_ALLMULTI) &&
+	    ice_vsi_num_non_zero_vlans(vsi) == 1) {
+		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+					   ICE_MCAST_PROMISC_BITS, 0);
+		ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+					 ICE_MCAST_VLAN_PROMISC_BITS, 0);
+	}
+
+finish:
+	clear_bit(ICE_CFG_BUSY, vsi->state);
 
 	return ret;
 }
@@ -3522,6 +3544,9 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	if (!vid)
 		return 0;
 
+	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
+		usleep_range(1000, 2000);
+
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	/* Make sure VLAN delete is successful before updating VLAN
@@ -3530,10 +3555,33 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
 	ret = vlan_ops->del_vlan(vsi, &vlan);
 	if (ret)
-		return ret;
+		goto finish;
 
-	set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
-	return 0;
+	/* Remove multicast promisc rule for the removed VLAN ID if
+	 * all-multicast is enabled.
+	 */
+	if (vsi->current_netdev_flags & IFF_ALLMULTI)
+		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+					   ICE_MCAST_VLAN_PROMISC_BITS, vid);
+
+	if (!ice_vsi_has_non_zero_vlans(vsi)) {
+		/* Update look-up type of multicast promisc rule for VLAN 0
+		 * from ICE_SW_LKUP_PROMISC_VLAN to ICE_SW_LKUP_PROMISC when
+		 * all-multicast is enabled and VLAN 0 is the only VLAN rule.
+		 */
+		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
+			ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+						   ICE_MCAST_VLAN_PROMISC_BITS,
+						   0);
+			ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+						 ICE_MCAST_PROMISC_BITS, 0);
+		}
+	}
+
+finish:
+	clear_bit(ICE_CFG_BUSY, vsi->state);
+
+	return ret;
 }
 
 /**

