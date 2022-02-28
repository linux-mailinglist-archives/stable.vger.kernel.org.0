Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721AD4C7B00
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiB1UwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiB1Uv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:51:59 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EDC1166
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646081480; x=1677617480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xEb2idAH/lmibWMoECwh8vsAt7RdrKJzOul7Pm26Azc=;
  b=GtMXzEMCE719nUpyJ9e+aRCDm9O97TOX57xw+JvKPJKPn5p/CybJLOmF
   /DgoT7PBWAFhEJRMiNgiHl5wapbbIpsYGp5ZERHDS9BQCx/p7VaUGUPn3
   E1yvfu4w9C0yepkaiNU/X/UX6iM6yYCKN1Dfg7vKnPjFwrWzpBq++GTb5
   qvSjy8VOx9f+dbSd5rrO9f+LujZ1UPhqE5sbGLex4jFpQeu/T4Ualyn4A
   qqF/hB5isbdG32Je3nZl83ceFzps4YL/3o6LGyqZqNrkiwCj+wsRzwfyv
   1YFVmJW+QZibH9CaRWrJ5Rpt2PKglo5NNNnSSoHU7DZWrVbHAQut+KXAN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="277646467"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="277646467"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:51:19 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="534616386"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.10])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:51:19 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 3/3] ice: fix concurrent reset and removal of VFs
Date:   Mon, 28 Feb 2022 12:51:14 -0800
Message-Id: <20220228205114.3262532-3-jacob.e.keller@intel.com>
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

commit fadead80fe4c033b5e514fcbadd20b55c4494112 upstream.

[ The original upstream commit fixed c503e63200c6 ("ice: Stop processing
VF messages during teardown"). This change is not in the 5.8 through 5.12
stable trees. However, that commit was itself a fix for ddf30f7ff840 ("ice:
Add handler to configure SR-IOV"). This fix originally reverted c503e63200c6
and supplied this more complete fix based on properly locking reset and
remove. This backport only applies the new fix, rather than applying the
broken inbetween fix and then reverting it. ]

Commit c503e63200c6 ("ice: Stop processing VF messages during teardown")
introduced a driver state flag, ICE_VF_DEINIT_IN_PROGRESS, which is
intended to prevent some issues with concurrently handling messages from
VFs while tearing down the VFs.

This change was motivated by crashes caused while tearing down and
bringing up VFs in rapid succession.

It turns out that the fix actually introduces issues with the VF driver
caused because the PF no longer responds to any messages sent by the VF
during its .remove routine. This results in the VF potentially removing
its DMA memory before the PF has shut down the device queues.

Additionally, the fix doesn't actually resolve concurrency issues within
the ice driver. It is possible for a VF to initiate a reset just prior
to the ice driver removing VFs. This can result in the remove task
concurrently operating while the VF is being reset. This results in
similar memory corruption and panics purportedly fixed by that commit.

Fix this concurrency at its root by protecting both the reset and
removal flows using the existing VF cfg_lock. This ensures that we
cannot remove the VF while any outstanding critical tasks such as a
virtchnl message or a reset are occurring.

This locking change also fixes the root cause originally fixed by commit
c503e63200c6 ("ice: Stop processing VF messages during teardown"), so we
can simply revert it.

Note that I kept these two changes together because simply reverting the
original commit alone would leave the driver vulnerable to worse race
conditions.

Fixes: c503e63200c6 ("ice: Stop processing VF messages during teardown")
Cc: <stable@vger.kernel.org> # 5.8.x: e6ba5273d4ed: ice: Fix race conditions between virtchnl handling and VF ndo ops
Cc: <stable@vger.kernel.org> # 5.8.x: b385cca47363: ice: Fix not stopping Tx queues for VF
Cc: <stable@vger.kernel.org> # 5.8.x
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
This is for stable trees 5.8 through 5.12. I sent a series with this fix for
5.13 and 5.14 separately since they have slightly different context.

 drivers/net/ethernet/intel/ice/ice_main.c     |  2 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 35 +++++++++++++------
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b61cd84be97f..171cb9198c8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1601,7 +1601,9 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				 * reset, so print the event prior to reset.
 				 */
 				ice_print_vf_rx_mdd_event(vf);
+				mutex_lock(&pf->vf[i].cfg_lock);
 				ice_reset_vf(&pf->vf[i], false);
+				mutex_unlock(&pf->vf[i].cfg_lock);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 8fa941231500..af1fbb2c1479 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -360,22 +360,26 @@ void ice_free_vfs(struct ice_pf *pf)
 	else
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
-	/* Avoid wait time by stopping all VFs at the same time */
-	ice_for_each_vf(pf, i)
-		ice_dis_vf_qs(&pf->vf[i]);
-
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
 	pf->num_alloc_vfs = 0;
 	for (i = 0; i < tmp; i++) {
-		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		mutex_lock(&vf->cfg_lock);
+
+		ice_dis_vf_qs(vf);
+
+		if (test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
 			/* disable VF qp mappings and set VF disable state */
-			ice_dis_vf_mappings(&pf->vf[i]);
-			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
-			ice_free_vf_res(&pf->vf[i]);
+			ice_dis_vf_mappings(vf);
+			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
+			ice_free_vf_res(vf);
 		}
 
-		mutex_destroy(&pf->vf[i].cfg_lock);
+		mutex_unlock(&vf->cfg_lock);
+
+		mutex_destroy(&vf->cfg_lock);
 	}
 
 	if (ice_sriov_free_msix_res(pf))
@@ -1259,9 +1263,13 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
+		mutex_lock(&vf->cfg_lock);
+
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
 		ice_vf_post_vsi_rebuild(vf);
+
+		mutex_unlock(&vf->cfg_lock);
 	}
 
 	ice_flush(hw);
@@ -1308,6 +1316,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	u32 reg;
 	int i;
 
+	lockdep_assert_held(&vf->cfg_lock);
+
 	dev = ice_pf_to_dev(pf);
 
 	if (test_bit(__ICE_VF_RESETS_DISABLED, pf->state)) {
@@ -1765,9 +1775,12 @@ void ice_process_vflr_event(struct ice_pf *pf)
 		bit_idx = (hw->func_caps.vf_base_id + vf_id) % 32;
 		/* read GLGEN_VFLRSTAT register to find out the flr VFs */
 		reg = rd32(hw, GLGEN_VFLRSTAT(reg_idx));
-		if (reg & BIT(bit_idx))
+		if (reg & BIT(bit_idx)) {
 			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
+			mutex_lock(&vf->cfg_lock);
 			ice_reset_vf(vf, true);
+			mutex_unlock(&vf->cfg_lock);
+		}
 	}
 }
 
@@ -1844,7 +1857,9 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 	if (!vf)
 		return;
 
+	mutex_lock(&vf->cfg_lock);
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
-- 
2.35.1.355.ge7e302376dd6

