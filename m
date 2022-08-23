Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CEC59D4D5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbiHWJDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347638AbiHWJCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:02:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A622AE39;
        Tue, 23 Aug 2022 01:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4218361496;
        Tue, 23 Aug 2022 08:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF5AC433C1;
        Tue, 23 Aug 2022 08:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243270;
        bh=hmBBC3rXmDgnAJTGGbM1FP0s6fS3OG2Gq1iLirJXgSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAr98klI0YjJ+k+Cpfv42BtstAe0QPHKUB169wiIdBb5okqTPP7z9AqPhAooFi/FE
         kIWLsUO0gfYRQL36Va+gplwNmxLL3Hem2XdymTAF+yrcs8Gi6VpSynfsB2f6ycTfQ1
         AeE0rOQn1sWvPeWXS8B1jrWlK/eCNPXa3q+uhRnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.19 223/365] ice: Fix VF not able to send tagged traffic with no VLAN filters
Date:   Tue, 23 Aug 2022 10:02:04 +0200
Message-Id: <20220823080127.530680795@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

commit 664d4646184ed986f8195df684cc4660563fb02a upstream.

VF was not able to send tagged traffic when it didn't
have any VLAN interfaces and VLAN anti-spoofing was enabled.
Fix this by allowing VFs with no VLAN filters to send tagged
traffic. After VF adds a VLAN interface it will be able to
send tagged traffic matching VLAN filters only.

Testing hints:
1. Spawn VF
2. Send tagged packet from a VF
3. The packet should be sent out and not dropped
4. Add a VLAN interface on VF
5. Send tagged packet on that VLAN interface
6. Packet should be sent out and not dropped
7. Send tagged packet with id different than VLAN interface
8. Packet should be dropped

Fixes: daf4dd16438b ("ice: Refactor spoofcheck configuration functions")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |   11 +++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |   57 ++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -707,13 +707,16 @@ static int ice_cfg_mac_antispoof(struct
 static int ice_vsi_ena_spoofchk(struct ice_vsi *vsi)
 {
 	struct ice_vsi_vlan_ops *vlan_ops;
-	int err;
+	int err = 0;
 
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
-	err = vlan_ops->ena_tx_filtering(vsi);
-	if (err)
-		return err;
+	/* Allow VF with VLAN 0 only to send all tagged traffic */
+	if (vsi->type != ICE_VSI_VF || ice_vsi_has_non_zero_vlans(vsi)) {
+		err = vlan_ops->ena_tx_filtering(vsi);
+		if (err)
+			return err;
+	}
 
 	return ice_cfg_mac_antispoof(vsi, true);
 }
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -2264,6 +2264,15 @@ static int ice_vc_process_vlan_msg(struc
 
 			/* Enable VLAN filtering on first non-zero VLAN */
 			if (!vlan_promisc && vid && !ice_is_dvm_ena(&pf->hw)) {
+				if (vf->spoofchk) {
+					status = vsi->inner_vlan_ops.ena_tx_filtering(vsi);
+					if (status) {
+						v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+						dev_err(dev, "Enable VLAN anti-spoofing on VLAN ID: %d failed error-%d\n",
+							vid, status);
+						goto error_param;
+					}
+				}
 				if (vsi->inner_vlan_ops.ena_rx_filtering(vsi)) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
@@ -2309,8 +2318,10 @@ static int ice_vc_process_vlan_msg(struc
 			}
 
 			/* Disable VLAN filtering when only VLAN 0 is left */
-			if (!ice_vsi_has_non_zero_vlans(vsi))
+			if (!ice_vsi_has_non_zero_vlans(vsi)) {
+				vsi->inner_vlan_ops.dis_tx_filtering(vsi);
 				vsi->inner_vlan_ops.dis_rx_filtering(vsi);
+			}
 
 			if (vlan_promisc)
 				ice_vf_dis_vlan_promisc(vsi, &vlan);
@@ -2814,6 +2825,13 @@ ice_vc_del_vlans(struct ice_vf *vf, stru
 
 			if (vlan_promisc)
 				ice_vf_dis_vlan_promisc(vsi, &vlan);
+
+			/* Disable VLAN filtering when only VLAN 0 is left */
+			if (!ice_vsi_has_non_zero_vlans(vsi) && ice_is_dvm_ena(&vsi->back->hw)) {
+				err = vsi->outer_vlan_ops.dis_tx_filtering(vsi);
+				if (err)
+					return err;
+			}
 		}
 
 		vc_vlan = &vlan_fltr->inner;
@@ -2829,8 +2847,17 @@ ice_vc_del_vlans(struct ice_vf *vf, stru
 			/* no support for VLAN promiscuous on inner VLAN unless
 			 * we are in Single VLAN Mode (SVM)
 			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
+			if (!ice_is_dvm_ena(&vsi->back->hw)) {
+				if (vlan_promisc)
+					ice_vf_dis_vlan_promisc(vsi, &vlan);
+
+				/* Disable VLAN filtering when only VLAN 0 is left */
+				if (!ice_vsi_has_non_zero_vlans(vsi)) {
+					err = vsi->inner_vlan_ops.dis_tx_filtering(vsi);
+					if (err)
+						return err;
+				}
+			}
 		}
 	}
 
@@ -2907,6 +2934,13 @@ ice_vc_add_vlans(struct ice_vf *vf, stru
 				if (err)
 					return err;
 			}
+
+			/* Enable VLAN filtering on first non-zero VLAN */
+			if (vf->spoofchk && vlan.vid && ice_is_dvm_ena(&vsi->back->hw)) {
+				err = vsi->outer_vlan_ops.ena_tx_filtering(vsi);
+				if (err)
+					return err;
+			}
 		}
 
 		vc_vlan = &vlan_fltr->inner;
@@ -2922,10 +2956,19 @@ ice_vc_add_vlans(struct ice_vf *vf, stru
 			/* no support for VLAN promiscuous on inner VLAN unless
 			 * we are in Single VLAN Mode (SVM)
 			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc) {
-				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (err)
-					return err;
+			if (!ice_is_dvm_ena(&vsi->back->hw)) {
+				if (vlan_promisc) {
+					err = ice_vf_ena_vlan_promisc(vsi, &vlan);
+					if (err)
+						return err;
+				}
+
+				/* Enable VLAN filtering on first non-zero VLAN */
+				if (vf->spoofchk && vlan.vid) {
+					err = vsi->inner_vlan_ops.ena_tx_filtering(vsi);
+					if (err)
+						return err;
+				}
 			}
 		}
 	}


