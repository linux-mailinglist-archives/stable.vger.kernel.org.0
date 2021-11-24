Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EED45C226
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350381AbhKXNZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350057AbhKXNXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:23:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DF861B93;
        Wed, 24 Nov 2021 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758117;
        bh=TB+7Pp67Ai0ZR4iuANSAKRj42AlMEOce4vKddVP7ZM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLrC/KIlZHH4xfn9PIaQ2npr3360irU2Bsd6LO9CaEeYQ+tRJZ/pjbtkCafYrroJw
         HpxsVmORrDVID/01ZRrQeZ0pmOUr/aMau+8J+Lsp3RX7HLlhNhh5b2pCUhzXyxv1/v
         Vds4CrvNQCeSmB6w9Bxn6RtqLQzGrDqWQwI8E6IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Eryk Rybak <eryk.roch.rybak@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/100] i40e: Fix ping is lost after configuring ADq on VF
Date:   Wed, 24 Nov 2021 12:58:21 +0100
Message-Id: <20211124115656.978064244@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

[ Upstream commit 9e0a603cb7dce2a19d98116d42de84b6db26d716 ]

Properly reconfigure VF VSIs after VF request ADQ.
Created new function to update queue mapping and queue pairs per TC
with AQ update VSI. This sets proper RSS size on NIC.
VFs num_queue_pairs should not be changed during setup of queue maps.
Previously, VF main VSI in ADQ had configured too many queues and had
wrong RSS size, which lead to packets not being consumed and drops in
connectivity.

Fixes: bc6d33c8d93f ("i40e: Fix the number of queues available to be mapped for use")
Co-developed-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 64 ++++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 17 +++--
 3 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index e7e61b9a75ecd..f8422dbfd54e6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1147,6 +1147,7 @@ void i40e_ptp_save_hw_time(struct i40e_pf *pf);
 void i40e_ptp_restore_hw_time(struct i40e_pf *pf);
 void i40e_ptp_init(struct i40e_pf *pf);
 void i40e_ptp_stop(struct i40e_pf *pf);
+int i40e_update_adq_vsi_queues(struct i40e_vsi *vsi, int vsi_offset);
 int i40e_is_vsi_uplink_mode_veb(struct i40e_vsi *vsi);
 i40e_status i40e_get_partition_bw_setting(struct i40e_pf *pf);
 i40e_status i40e_set_partition_bw_setting(struct i40e_pf *pf);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 34c453c2b22da..5dbbb87423a52 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1787,6 +1787,8 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 
 	sections = I40E_AQ_VSI_PROP_QUEUE_MAP_VALID;
 	offset = 0;
+	/* zero out queue mapping, it will get updated on the end of the function */
+	memset(ctxt->info.queue_mapping, 0, sizeof(ctxt->info.queue_mapping));
 
 	if (vsi->type == I40E_VSI_MAIN) {
 		/* This code helps add more queue to the VSI if we have
@@ -1803,10 +1805,12 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 	}
 
 	/* Number of queues per enabled TC */
-	if (vsi->type == I40E_VSI_MAIN)
+	if (vsi->type == I40E_VSI_MAIN ||
+	    (vsi->type == I40E_VSI_SRIOV && vsi->num_queue_pairs != 0))
 		num_tc_qps = vsi->num_queue_pairs;
 	else
 		num_tc_qps = vsi->alloc_queue_pairs;
+
 	if (enabled_tc && (vsi->back->flags & I40E_FLAG_DCB_ENABLED)) {
 		/* Find numtc from enabled TC bitmap */
 		for (i = 0, numtc = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
@@ -1884,10 +1888,12 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 		}
 		ctxt->info.tc_mapping[i] = cpu_to_le16(qmap);
 	}
-	/* Do not change previously set num_queue_pairs for PFs */
+	/* Do not change previously set num_queue_pairs for PFs and VFs*/
 	if ((vsi->type == I40E_VSI_MAIN && numtc != 1) ||
-	    vsi->type != I40E_VSI_MAIN)
+	    (vsi->type == I40E_VSI_SRIOV && vsi->num_queue_pairs == 0) ||
+	    (vsi->type != I40E_VSI_MAIN && vsi->type != I40E_VSI_SRIOV))
 		vsi->num_queue_pairs = offset;
+
 	/* Scheduler section valid can only be set for ADD VSI */
 	if (is_add) {
 		sections |= I40E_AQ_VSI_PROP_SCHED_VALID;
@@ -5383,6 +5389,58 @@ static void i40e_vsi_update_queue_map(struct i40e_vsi *vsi,
 	       sizeof(vsi->info.tc_mapping));
 }
 
+/**
+ * i40e_update_adq_vsi_queues - update queue mapping for ADq VSI
+ * @vsi: the VSI being reconfigured
+ * @vsi_offset: offset from main VF VSI
+ */
+int i40e_update_adq_vsi_queues(struct i40e_vsi *vsi, int vsi_offset)
+{
+	struct i40e_vsi_context ctxt = {};
+	struct i40e_pf *pf;
+	struct i40e_hw *hw;
+	int ret;
+
+	if (!vsi)
+		return I40E_ERR_PARAM;
+	pf = vsi->back;
+	hw = &pf->hw;
+
+	ctxt.seid = vsi->seid;
+	ctxt.pf_num = hw->pf_id;
+	ctxt.vf_num = vsi->vf_id + hw->func_caps.vf_base_id + vsi_offset;
+	ctxt.uplink_seid = vsi->uplink_seid;
+	ctxt.connection_type = I40E_AQ_VSI_CONN_TYPE_NORMAL;
+	ctxt.flags = I40E_AQ_VSI_TYPE_VF;
+	ctxt.info = vsi->info;
+
+	i40e_vsi_setup_queue_map(vsi, &ctxt, vsi->tc_config.enabled_tc,
+				 false);
+	if (vsi->reconfig_rss) {
+		vsi->rss_size = min_t(int, pf->alloc_rss_size,
+				      vsi->num_queue_pairs);
+		ret = i40e_vsi_config_rss(vsi);
+		if (ret) {
+			dev_info(&pf->pdev->dev, "Failed to reconfig rss for num_queues\n");
+			return ret;
+		}
+		vsi->reconfig_rss = false;
+	}
+
+	ret = i40e_aq_update_vsi_params(hw, &ctxt, NULL);
+	if (ret) {
+		dev_info(&pf->pdev->dev, "Update vsi config failed, err %s aq_err %s\n",
+			 i40e_stat_str(hw, ret),
+			 i40e_aq_str(hw, hw->aq.asq_last_status));
+		return ret;
+	}
+	/* update the local VSI info with updated queue map */
+	i40e_vsi_update_queue_map(vsi, &ctxt);
+	vsi->info.valid_sections = 0;
+
+	return ret;
+}
+
 /**
  * i40e_vsi_config_tc - Configure VSI Tx Scheduler for given TC map
  * @vsi: VSI to be configured
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 16641c19b7f73..6e61aea42a0dd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2100,11 +2100,12 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct virtchnl_vsi_queue_config_info *qci =
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
-	struct i40e_pf *pf = vf->pf;
 	u16 vsi_id, vsi_queue_id = 0;
-	u16 num_qps_all = 0;
+	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 	int i, j = 0, idx = 0;
+	struct i40e_vsi *vsi;
+	u16 num_qps_all = 0;
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
@@ -2193,9 +2194,15 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 		pf->vsi[vf->lan_vsi_idx]->num_queue_pairs =
 			qci->num_queue_pairs;
 	} else {
-		for (i = 0; i < vf->num_tc; i++)
-			pf->vsi[vf->ch[i].vsi_idx]->num_queue_pairs =
-			       vf->ch[i].num_qps;
+		for (i = 0; i < vf->num_tc; i++) {
+			vsi = pf->vsi[vf->ch[i].vsi_idx];
+			vsi->num_queue_pairs = vf->ch[i].num_qps;
+
+			if (i40e_update_adq_vsi_queues(vsi, i)) {
+				aq_ret = I40E_ERR_CONFIG;
+				goto error_param;
+			}
+		}
 	}
 
 error_param:
-- 
2.33.0



