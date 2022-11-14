Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C91662804C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiKNNEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbiKNNEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467FA2A245
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED763B80EB8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516CFC433D6;
        Mon, 14 Nov 2022 13:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431084;
        bh=fW0HhgbLl1WejQihyK82M0yI18BivMu+GM7xjAtVX80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2EbWsytDdLdXrlJ6YmdqLxQnHLADPk2SIeo000bB2+l3m+Lz20o4+wtPuKz8eNXj
         wCdE2fHnvw3r3tpppzgqy2pHg2tu0Ht+dO4x+Xv5h22Ay2eGTh8sxzmgw/lFAJL4DY
         N0X2u1JCwEEEhCHXv6jGQutnlt6dXCnp4zyqWvU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 094/190] ice: Fix spurious interrupt during removal of trusted VF
Date:   Mon, 14 Nov 2022 13:45:18 +0100
Message-Id: <20221114124502.816568840@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Zulinski <norbertx.zulinski@intel.com>

[ Upstream commit f23df5220d2bf8d5e639f074b76f206a736d09e1 ]

Previously, during removal of trusted VF when VF is down there was
number of spurious interrupt equal to number of queues on VF.

Add check if VF already has inactive queues. If VF is disabled and
has inactive rx queues then do not disable rx queues.
Add check in ice_vsi_stop_tx_ring if it's VF's vsi and if VF is
disabled.

Fixes: efe41860008e ("ice: Fix memory corruption in VF driver")
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c    | 25 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c |  5 ++++-
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1e3243808178..9ee022bb8ec2 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -959,7 +959,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	 * associated to the queue to schedule NAPI handler
 	 */
 	q_vector = ring->q_vector;
-	if (q_vector)
+	if (q_vector && !(vsi->vf && ice_is_vf_disabled(vsi->vf)))
 		ice_trigger_sw_intr(hw, q_vector);
 
 	status = ice_dis_vsi_txq(vsi->port_info, txq_meta->vsi_idx,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 58d483e2f539..11399f55e647 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2222,6 +2222,31 @@ int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
 	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings, vsi->num_xdp_txq);
 }
 
+/**
+ * ice_vsi_is_rx_queue_active
+ * @vsi: the VSI being configured
+ *
+ * Return true if at least one queue is active.
+ */
+bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	int i;
+
+	ice_for_each_rxq(vsi, i) {
+		u32 rx_reg;
+		int pf_q;
+
+		pf_q = vsi->rxq_map[i];
+		rx_reg = rd32(hw, QRX_CTRL(pf_q));
+		if (rx_reg & QRX_CTRL_QENA_STAT_M)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * ice_vsi_is_vlan_pruning_ena - check if VLAN pruning is enabled or not
  * @vsi: VSI to check whether or not VLAN pruning is enabled.
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 8712b1d2ceec..441fb132f194 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -127,4 +127,5 @@ u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi);
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
+bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 0abeed092de1..1c51778db951 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -576,7 +576,10 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 			return -EINVAL;
 		}
 		ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
-		ice_vsi_stop_all_rx_rings(vsi);
+
+		if (ice_vsi_is_rx_queue_active(vsi))
+			ice_vsi_stop_all_rx_rings(vsi);
+
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
 			vf->vf_id);
 		return 0;
-- 
2.35.1



