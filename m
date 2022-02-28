Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE2D4C7AFE
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiB1UuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiB1UuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:50:06 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EC95A15C
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646081366; x=1677617366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wyz7ktR6JI94TQVZx4y+JBL/eWEEWtRAFzj3wfl5XBE=;
  b=kjpNzMH669AYDSVmZPX9Obhd/1QMkaHnAbWcZwGzdIH98TpRQK2dWPiN
   DAnLCmfgKfpiw6D72MYDPIrTFYflsCH0S+s8f25fwAMgAoRwPtxjyBZ9O
   Qp6iF3AIsftXEIyUuuFt5JqwjW4tTMdvYp451syr/q1RflKW2tSrcENdv
   7opx6bQfmGVsnPjHm82KtVhLO3i3Dm/8z1gIXO6PuDkyKM957MFiQ/8XU
   BnDlo+A1KEQVrAELWVWylbw/DmxFSHyAN9S/EaGNaRMCycIE6ORSBLXrS
   V1+EbWAU1O6QxCy8FPizD/rKJQMkCUNs56rVAoYmbcQiHBOI8QRYBdG+m
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="232955244"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="232955244"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:49:21 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="685475548"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.10])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:49:20 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 2/3] ice: Fix not stopping Tx queues for VFs
Date:   Mon, 28 Feb 2022 12:49:14 -0800
Message-Id: <20220228204915.3261623-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.355.ge7e302376dd6
In-Reply-To: <20220228204915.3261623-1-jacob.e.keller@intel.com>
References: <20220228204915.3261623-1-jacob.e.keller@intel.com>
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

commit b385cca47363316c6d9a74ae9db407bbc281f815 upstream.

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
Cc: stable@vger.kernel.org # 5.13.x
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
This should apply to 5.13

 drivers/net/ethernet/intel/ice/ice_base.c        | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 5985a7e5ca8a..5f1e2b8bf006 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -873,7 +873,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
 		dev_dbg(ice_pf_to_dev(vsi->back), "LAN Tx queues do not exist, nothing to disable\n");
 	} else if (status) {
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
+		dev_dbg(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
 			ice_stat_str(status));
 		return -ENODEV;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2629d670bbbf..2b7e52e8bcae 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -634,8 +634,7 @@ void ice_free_vfs(struct ice_pf *pf)
 
 	/* Avoid wait time by stopping all VFs at the same time */
 	ice_for_each_vf(pf, i)
-		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
-			ice_dis_vf_qs(&pf->vf[i]);
+		ice_dis_vf_qs(&pf->vf[i]);
 
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
@@ -1645,8 +1644,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	vsi = ice_get_vf_vsi(vf);
 
-	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
-		ice_dis_vf_qs(vf);
+	ice_dis_vf_qs(vf);
 
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
-- 
2.35.1.355.ge7e302376dd6

