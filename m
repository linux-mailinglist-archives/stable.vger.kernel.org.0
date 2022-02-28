Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D624C7B02
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiB1UwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiB1UwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:52:01 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C23C12C0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646081481; x=1677617481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V2AdQN+owiRKbPacz9IgsoQDV8p/sLkgarNPaaNGqas=;
  b=kP6vAsA9TIylbk+ZC6/TMLI6ea7dfqLE5b/JWkPN5DXWuqj/OFyJuOC0
   heq3z+6zcLuYvDDH/+taG8F0be5IIPyLYqzwZ1IO5vBCo/Nt6e3JcAch/
   63hcGaJ5gJqwotBrdY2r5XkBGtA8ViBLk3tphlmp3XLALsMxc87eIKZsV
   Fg8TwKxsJ+ts03iHi85isTsCDBcnMpb8bC3yt16RAD+emBElORCXhWCe9
   PgtV8C6+rjfgttDr5IuILIftVzPhbwhWj1fBoR5aP6u+jBpeq83hayc9I
   MHFJhOYyPa8bY11ul+x1hqTX6DldrGnWbBM/bd3XtzQwiZHJ4JeD81005
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="277646469"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="277646469"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:51:20 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="534616383"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.10])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:51:19 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 2/3] ice: Fix not stopping Tx queues for VFs
Date:   Mon, 28 Feb 2022 12:51:13 -0800
Message-Id: <20220228205114.3262532-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.355.ge7e302376dd6
In-Reply-To: <20220228205114.3262532-1-jacob.e.keller@intel.com>
References: <20220228205114.3262532-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

commit b385cca47363316c6d9a74ae9db407bbc281f815 upstream.

[ This commit is already in stable/linux-5.10.y as d83832d4a838 ("ice: Fix
not stopping Tx queues for VFs"). It's missing from v5.8, v5.9, v5.11, and
v5.12 ]

When a VF is removed and/or reset its Tx queues need to be
stopped from the PF. This is done by calling the ice_dis_vf_qs()
function, which calls ice_vsi_stop_lan_tx_rings(). Currently
ice_dis_vf_qs() is protected by the VF state bit ICE_VF_STATE_QS_ENA.
Unfortunately, this is causing the Tx queues to not be disabled in some
cases and when the VF tries to re-enable/reconfigure its Tx queues over
virtchnl the op is failing. This is because a VF can be reset and/or
removed before the ICE_VF_STATE_QS_ENA bit is set, but the Tx queues
were already configured via ice_vsi_cfg_single_txq() in the
VIRTCHNL_OP_CONFIG_VSI_QUEUES op. However, the ICE_VF_STATE_QS_ENA bit
is set on a successful VIRTCHNL_OP_ENABLE_QUEUES, which will always
happen after the VIRTCHNL_OP_CONFIG_VSI_QUEUES op.

This was causing the following error message when loading the ice
driver, creating VFs, and modifying VF trust in an endless loop:

[35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
[35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
[35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6

Fix this by always calling ice_dis_vf_qs() and silencing the error
message in ice_vsi_stop_tx_ring() since the calling code ignores the
return anyway. Also, all other places that call ice_vsi_stop_tx_ring()
catch the error, so this doesn't affect those flows since there was no
change to the values the function returns.

Other solutions were considered (i.e. tracking which VF queues had been
"started/configured" in VIRTCHNL_OP_CONFIG_VSI_QUEUES, but it seemed
more complicated than it was worth. This solution also brings in the
chance for other unexpected conditions due to invalid state bit checks.
So, the proposed solution seemed like the best option since there is no
harm in failing to stop Tx queues that were never started.

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

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Cc: stable@vger.kernel.org # 5.8.x
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
This is for stable trees 5.8 through 5.12, excepting 5.10 which already has
it. I sent a series with these fixes for 5.13 and 5.14 separately.

 drivers/net/ethernet/intel/ice/ice_base.c        | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1148d768f8ed..203a3b21adc8 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -859,7 +859,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
 		dev_dbg(ice_pf_to_dev(vsi->back), "LAN Tx queues do not exist, nothing to disable\n");
 	} else if (status) {
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
+		dev_dbg(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
 			ice_stat_str(status));
 		return -ENODEV;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 66da8f540454..8fa941231500 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -362,8 +362,7 @@ void ice_free_vfs(struct ice_pf *pf)
 
 	/* Avoid wait time by stopping all VFs at the same time */
 	ice_for_each_vf(pf, i)
-		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
-			ice_dis_vf_qs(&pf->vf[i]);
+		ice_dis_vf_qs(&pf->vf[i]);
 
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
@@ -1329,8 +1328,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
-		ice_dis_vf_qs(vf);
+	ice_dis_vf_qs(vf);
 
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
-- 
2.35.1.355.ge7e302376dd6

