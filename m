Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0468C45B619
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 09:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbhKXIEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 03:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240955AbhKXIEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 03:04:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D2A260F5B;
        Wed, 24 Nov 2021 08:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637740882;
        bh=7+YZR3bT2LD5q/WVzbhDqY1RgzYyyXbcXTRaPw/R6nM=;
        h=Subject:To:Cc:From:Date:From;
        b=djjot7YVQKaQVgePYbCqpqlWmJ9XviNk5KtrLZ8FYFYFiej7pZcDXeZC/yad8bb1h
         j+V/xICkpHc3Fb1mD2+GJR4rNCQUi2tof370UYThSka66HA0FlyDHJvInx6Yg+UZJ1
         QZY8yO0LCYITNFrDG6XVs3n26YTlsTnMNEJyizZ4=
Subject: FAILED: patch "[PATCH] ice: Fix VF true promiscuous mode" failed to apply to 5.10-stable tree
To:     brett.creeley@intel.com, anthony.l.nguyen@intel.com,
        tony.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Nov 2021 09:01:19 +0100
Message-ID: <1637740879053@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1a8c7778bcde5981463a5b9f9b2caa44a327ff93 Mon Sep 17 00:00:00 2001
From: Brett Creeley <brett.creeley@intel.com>
Date: Fri, 26 Feb 2021 13:19:23 -0800
Subject: [PATCH] ice: Fix VF true promiscuous mode

When a VF requests promiscuous mode and it's trusted and true promiscuous
mode is enabled the PF driver attempts to enable unicast and/or
multicast promiscuous mode filters based on the request. This is fine,
but there are a couple issues with the current code.

[1] The define to configure the unicast promiscuous mode mask also
    includes bits to configure the multicast promiscuous mode mask, which
    causes multicast to be set/cleared unintentionally.
[2] All 4 cases for enable/disable unicast/multicast mode are not
    handled in the promiscuous mode message handler, which causes
    unexpected results regarding the current promiscuous mode settings.

To fix [1] make sure any promiscuous mask defines include the correct
bits for each of the promiscuous modes.

To fix [2] make sure that all 4 cases are handled since there are 2 bits
(FLAG_VF_UNICAST_PROMISC and FLAG_VF_MULTICAST_PROMISC) that can be
either set or cleared. Also, since either unicast and/or multicast
promiscuous configuration can fail, introduce two separate error values
to handle each of these cases.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bf4ecd9a517c..b2db39ee5f85 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -165,13 +165,10 @@
 #define ice_for_each_chnl_tc(i)	\
 	for ((i) = ICE_CHNL_START_TC; (i) < ICE_CHNL_MAX_TC; (i)++)
 
-#define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_MCAST_TX | \
-				ICE_PROMISC_UCAST_RX | ICE_PROMISC_MCAST_RX)
+#define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_UCAST_RX)
 
 #define ICE_UCAST_VLAN_PROMISC_BITS (ICE_PROMISC_UCAST_TX | \
-				     ICE_PROMISC_MCAST_TX | \
 				     ICE_PROMISC_UCAST_RX | \
-				     ICE_PROMISC_MCAST_RX | \
 				     ICE_PROMISC_VLAN_TX  | \
 				     ICE_PROMISC_VLAN_RX)
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2ac21484b876..9b699419c933 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3013,6 +3013,7 @@ bool ice_is_any_vf_in_promisc(struct ice_pf *pf)
 static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	enum ice_status mcast_status = 0, ucast_status = 0;
 	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
@@ -3105,52 +3106,51 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 			goto error_param;
 		}
 	} else {
-		enum ice_status status;
-		u8 promisc_m;
-
-		if (alluni) {
-			if (vf->port_vlan_info || vsi->num_vlan)
-				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_UCAST_PROMISC_BITS;
-		} else if (allmulti) {
-			if (vf->port_vlan_info || vsi->num_vlan)
-				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_MCAST_PROMISC_BITS;
+		u8 mcast_m, ucast_m;
+
+		if (vf->port_vlan_info || vsi->num_vlan > 1) {
+			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
+			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
 		} else {
-			if (vf->port_vlan_info || vsi->num_vlan)
-				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_UCAST_PROMISC_BITS;
+			mcast_m = ICE_MCAST_PROMISC_BITS;
+			ucast_m = ICE_UCAST_PROMISC_BITS;
 		}
 
-		/* Configure multicast/unicast with or without VLAN promiscuous
-		 * mode
-		 */
-		status = ice_vf_set_vsi_promisc(vf, vsi, promisc_m, rm_promisc);
-		if (status) {
-			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed, error: %s\n",
-				rm_promisc ? "dis" : "en", vf->vf_id,
-				ice_stat_str(status));
-			v_ret = ice_err_to_virt_err(status);
-			goto error_param;
-		} else {
-			dev_dbg(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d succeeded\n",
-				rm_promisc ? "dis" : "en", vf->vf_id);
+		ucast_status = ice_vf_set_vsi_promisc(vf, vsi, ucast_m,
+						      !alluni);
+		if (ucast_status) {
+			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
+				alluni ? "en" : "dis", vf->vf_id);
+			v_ret = ice_err_to_virt_err(ucast_status);
+		}
+
+		mcast_status = ice_vf_set_vsi_promisc(vf, vsi, mcast_m,
+						      !allmulti);
+		if (mcast_status) {
+			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
+				allmulti ? "en" : "dis", vf->vf_id);
+			v_ret = ice_err_to_virt_err(mcast_status);
 		}
 	}
 
-	if (allmulti &&
-	    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully set multicast promiscuous mode\n", vf->vf_id);
-	else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n", vf->vf_id);
+	if (!mcast_status) {
+		if (allmulti &&
+		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
+				 vf->vf_id);
+	}
 
-	if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully set unicast promiscuous mode\n", vf->vf_id);
-	else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n", vf->vf_id);
+	if (!ucast_status) {
+		if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n",
+				 vf->vf_id);
+	}
 
 error_param:
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,

