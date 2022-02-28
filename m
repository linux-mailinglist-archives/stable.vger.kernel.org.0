Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A924C7AFF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiB1UuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiB1UuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:50:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E35A15C
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646081367; x=1677617367;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EY0s26G0CnDhjzaqjQ7YudJ/DKXnkaIGAkSQB6QAiAg=;
  b=Pysvc46El6vsm7k/aWh7WFNK6+tF+UlLCmkCpNcc0Vi2fFhVaDHJSC9u
   67keAzOD5GjduuwBpupTvEZRtKxiKDgBzyuhKCQmCRUWCRUdLOvPGxzWP
   4SYJePw2VDl1nFsy33Lf62VqcKlFqj7B7rs49qIYoQ060hxpdxh9swz3D
   124kq0nXPUB/wTFZLee9jpTrRpU0Lrfs7zGTr6USHvN4Uh3JJkswu4UAR
   6y9RtzDPsH4MHlaw66liKHNfemYY7j1n8BPGvdZwIkZ/S9p6d5hs8MEWo
   lu47S0lWwldUZ4UvPY0DvMWzyK5Gz11bO5tvGGG8g7wqvxXjGGZ1w0wEO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="232955243"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="232955243"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:49:21 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="685475545"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.10])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:49:20 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 1/3] ice: Fix race conditions between virtchnl handling and VF ndo ops
Date:   Mon, 28 Feb 2022 12:49:13 -0800
Message-Id: <20220228204915.3261623-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.355.ge7e302376dd6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.

[I had to fix the cherry-pick manually as the patch added a line around
some context that was missing.]

The VF can be configured via the PF's ndo ops at the same time the PF is
receiving/handling virtchnl messages. This has many issues, with
one of them being the ndo op could be actively resetting a VF (i.e.
resetting it to the default state and deleting/re-adding the VF's VSI)
while a virtchnl message is being handled. The following error was seen
because a VF ndo op was used to change a VF's trust setting while the
VIRTCHNL_OP_CONFIG_VSI_QUEUES was ongoing:

[35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
[35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
[35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6

Fix this by making sure the virtchnl handling and VF ndo ops that
trigger VF resets cannot run concurrently. This is done by adding a
struct mutex cfg_lock to each VF structure. For VF ndo ops, the mutex
will be locked around the critical operations and VFR. Since the ndo ops
will trigger a VFR, the virtchnl thread will use mutex_trylock(). This
is done because if any other thread (i.e. VF ndo op) has the mutex, then
that means the current VF message being handled is no longer valid, so
just ignore it.

This issue can be seen using the following commands:

for i in {0..50}; do
        rmmod ice
        modprobe ice

        sleep 1

        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on

        sleep 2

        echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
        sleep 1
        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on
done

Fixes: 7c710869d64e ("ice: Add handlers for VF netdevice operations")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
This should apply to 5.13

 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 25 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  5 ++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 671902d9fc35..2629d670bbbf 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -647,6 +647,8 @@ void ice_free_vfs(struct ice_pf *pf)
 			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
 			ice_free_vf_res(&pf->vf[i]);
 		}
+
+		mutex_destroy(&pf->vf[i].cfg_lock);
 	}
 
 	if (ice_sriov_free_msix_res(pf))
@@ -1893,6 +1895,8 @@ static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
 		 */
 		ice_vf_ctrl_invalidate_vsi(vf);
 		ice_vf_fdir_init(vf);
+
+		mutex_init(&vf->cfg_lock);
 	}
 }
 
@@ -3955,6 +3959,8 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return 0;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	vf->port_vlan_info = vlanprio;
 
 	if (vf->port_vlan_info)
@@ -3964,6 +3970,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
 
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 
 	return 0;
 }
@@ -4338,6 +4345,15 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
+	/* VF is being configured in another context that triggers a VFR, so no
+	 * need to process this message
+	 */
+	if (!mutex_trylock(&vf->cfg_lock)) {
+		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
+			 vf->vf_id);
+		return;
+	}
+
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
 		err = ice_vc_get_ver_msg(vf, msg);
@@ -4426,6 +4442,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
 			 vf_id, v_opcode, err);
 	}
+
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
@@ -4540,6 +4558,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		return -EINVAL;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	/* VF is notified of its new MAC via the PF's response to the
 	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
@@ -4557,6 +4577,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	}
 
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 	return 0;
 }
 
@@ -4586,11 +4607,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	if (trusted == vf->trusted)
 		return 0;
 
+	mutex_lock(&vf->cfg_lock);
+
 	vf->trusted = trusted;
 	ice_vc_reset_vf(vf);
 	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
+	mutex_unlock(&vf->cfg_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index d800ed83d6c3..3da39d63a24b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -69,6 +69,11 @@ struct ice_mdd_vf_events {
 struct ice_vf {
 	struct ice_pf *pf;
 
+	/* Used during virtchnl message handling and NDO ops against the VF
+	 * that will trigger a VFR
+	 */
+	struct mutex cfg_lock;
+
 	u16 vf_id;			/* VF ID in the PF space */
 	u16 lan_vsi_idx;		/* index into PF struct */
 	u16 ctrl_vsi_idx;
-- 
2.35.1.355.ge7e302376dd6

