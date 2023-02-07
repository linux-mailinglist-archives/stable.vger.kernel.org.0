Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D559C68D783
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjBGNAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjBGNAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:00:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B933A5A2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2824861403
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283C1C433D2;
        Tue,  7 Feb 2023 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774809;
        bh=yIVqKU/sBoCodY1C6f6cdDCzKfdCkVw3qkytyg+8FSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BApiFMyWDlMFoSi1PtYVRSdnSss9Js+ZiyHfL+1qOWKLIlXn+Cb58LanEt/RqJMZY
         HrWIR1zZ/hIE7SUmr+MDBgtlbNp9JL1+uuqUKM5yDRTd+7NgIUbXp14onv0dndASUC
         zfy7GS4A3KQat32XGBSmjlSMhEJFcYu61RGF/530=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Ertman <david.m.ertman@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 040/208] ice: Prevent set_channel from changing queues while RDMA active
Date:   Tue,  7 Feb 2023 13:54:54 +0100
Message-Id: <20230207125636.114573383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit a6a0974aae4209d039ba81226ded5246eea14961 ]

The PF controls the set of queues that the RDMA auxiliary_driver requests
resources from.  The set_channel command will alter that pool and trigger a
reconfiguration of the VSI, which breaks RDMA functionality.

Prevent set_channel from executing when RDMA driver bound to auxiliary
device.

Adding a locked variable to pass down the call chain to avoid double
locking the device_lock.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h         |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 23 +++++++++-------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  4 +--
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 28 +++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c    |  5 ++--
 5 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 001500afc4a6..e04871379baa 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -856,7 +856,7 @@ void ice_set_ethtool_repr_ops(struct net_device *netdev);
 void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
 u16 ice_get_avail_rxq_count(struct ice_pf *pf);
-int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx);
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
 void ice_update_pf_stats(struct ice_pf *pf);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index add90e75f05c..9aa0437aa598 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -434,7 +434,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		goto out;
 	}
 
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, false);
 
 out:
 	/* enable previously downed VSIs */
@@ -724,12 +724,13 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 /**
  * ice_pf_dcb_recfg - Reconfigure all VEBs and VSIs
  * @pf: pointer to the PF struct
+ * @locked: is adev device lock held
  *
  * Assumed caller has already disabled all VSIs before
  * calling this function. Reconfiguring DCB based on
  * local_dcbx_cfg.
  */
-void ice_pf_dcb_recfg(struct ice_pf *pf)
+void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
 	struct iidc_event *event;
@@ -776,14 +777,16 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
-	/* Notify the AUX drivers that TC change is finished */
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return;
+	if (!locked) {
+		/* Notify the AUX drivers that TC change is finished */
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (!event)
+			return;
 
-	set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	kfree(event);
+		set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
+		ice_send_event_to_aux(pf, event);
+		kfree(event);
+	}
 }
 
 /**
@@ -1034,7 +1037,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	}
 
 	/* changes in configuration update VSI */
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, false);
 
 	/* enable previously downed VSIs */
 	ice_dcb_ena_dis_vsi(pf, true, true);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 4c421c842a13..800879a88c5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -23,7 +23,7 @@ u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 int
 ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
 int ice_dcb_bwchk(struct ice_pf *pf, struct ice_dcbx_cfg *dcbcfg);
-void ice_pf_dcb_recfg(struct ice_pf *pf);
+void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -128,7 +128,7 @@ static inline u8 ice_get_pfc_mode(struct ice_pf *pf)
 	return 0;
 }
 
-static inline void ice_pf_dcb_recfg(struct ice_pf *pf) { }
+static inline void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked) { }
 static inline void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi) { }
 static inline void ice_update_dcb_stats(struct ice_pf *pf) { }
 static inline void
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b7be84bbe72d..e1f6373a3a2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3472,7 +3472,9 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int new_rx = 0, new_tx = 0;
+	bool locked = false;
 	u32 curr_combined;
+	int ret = 0;
 
 	/* do not support changing channels in Safe Mode */
 	if (ice_is_safe_mode(pf)) {
@@ -3536,15 +3538,33 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EINVAL;
 	}
 
-	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
+	if (pf->adev) {
+		mutex_lock(&pf->adev_mutex);
+		device_lock(&pf->adev->dev);
+		locked = true;
+		if (pf->adev->dev.driver) {
+			netdev_err(dev, "Cannot change channels when RDMA is active\n");
+			ret = -EBUSY;
+			goto adev_unlock;
+		}
+	}
+
+	ice_vsi_recfg_qs(vsi, new_rx, new_tx, locked);
 
-	if (!netif_is_rxfh_configured(dev))
-		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+	if (!netif_is_rxfh_configured(dev)) {
+		ret = ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+		goto adev_unlock;
+	}
 
 	/* Update rss_size due to change in Rx queues */
 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
 
-	return 0;
+adev_unlock:
+	if (locked) {
+		device_unlock(&pf->adev->dev);
+		mutex_unlock(&pf->adev_mutex);
+	}
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ca2898467dcb..1ac5f0018c7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4192,12 +4192,13 @@ bool ice_is_wol_supported(struct ice_hw *hw)
  * @vsi: VSI being changed
  * @new_rx: new number of Rx queues
  * @new_tx: new number of Tx queues
+ * @locked: is adev device_lock held
  *
  * Only change the number of queues if new_tx, or new_rx is non-0.
  *
  * Returns 0 on success.
  */
-int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 {
 	struct ice_pf *pf = vsi->back;
 	int err = 0, timeout = 50;
@@ -4226,7 +4227,7 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 
 	ice_vsi_close(vsi);
 	ice_vsi_rebuild(vsi, false);
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
 done:
 	clear_bit(ICE_CFG_BUSY, pf->state);
-- 
2.39.0



