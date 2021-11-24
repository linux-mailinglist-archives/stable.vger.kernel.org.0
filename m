Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7D445C680
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352259AbhKXOKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354166AbhKXOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 644D061250;
        Wed, 24 Nov 2021 13:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759538;
        bh=xSBZ8Mq8P12rQ/RVyTY/uWr8p1BS2iqM9TvzQiwL16Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWrsdomhy/+mpYXQpAUyti1lTS8MP5yrl0b+1s58JLIVA9cD6B6DuNn2xLhURPaEk
         zD/Jl1iPaQd+s7DfenmlT0XOdC18lZzQppj1UIvllSDkVyVWSxX6+7yz3uGL6+qfOF
         MZ5zDOA17LH8iitvAqSyMvtwUbjbMcx5wH1290Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 274/279] ice: Fix VF true promiscuous mode
Date:   Wed, 24 Nov 2021 12:59:21 +0100
Message-Id: <20211124115728.156766494@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

commit 1a8c7778bcde5981463a5b9f9b2caa44a327ff93 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h             |    5 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |   78 +++++++++++------------
 2 files changed, 40 insertions(+), 43 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -139,13 +139,10 @@
 #define ice_for_each_q_vector(vsi, i) \
 	for ((i) = 0; (i) < (vsi)->num_q_vectors; (i)++)
 
-#define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_MCAST_TX | \
-				ICE_PROMISC_UCAST_RX | ICE_PROMISC_MCAST_RX)
+#define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_UCAST_RX)
 
 #define ICE_UCAST_VLAN_PROMISC_BITS (ICE_PROMISC_UCAST_TX | \
-				     ICE_PROMISC_MCAST_TX | \
 				     ICE_PROMISC_UCAST_RX | \
-				     ICE_PROMISC_MCAST_RX | \
 				     ICE_PROMISC_VLAN_TX  | \
 				     ICE_PROMISC_VLAN_RX)
 
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2952,6 +2952,7 @@ bool ice_is_any_vf_in_promisc(struct ice
 static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	enum ice_status mcast_status = 0, ucast_status = 0;
 	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
@@ -3041,52 +3042,51 @@ static int ice_vc_cfg_promiscuous_mode_m
 			goto error_param;
 		}
 	} else {
-		enum ice_status status;
-		u8 promisc_m;
+		u8 mcast_m, ucast_m;
 
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
-
-	if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully set unicast promiscuous mode\n", vf->vf_id);
-	else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n", vf->vf_id);
+	if (!mcast_status) {
+		if (allmulti &&
+		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
+				 vf->vf_id);
+	}
+
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


