Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DF94C758D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbiB1Rz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240512AbiB1RyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256F795499;
        Mon, 28 Feb 2022 09:42:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6765CE17C4;
        Mon, 28 Feb 2022 17:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3474C340E7;
        Mon, 28 Feb 2022 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070135;
        bh=Y/HwuWoVeX6s5vjmTTbWIMIxw4Y0IfWt9Ob2FSFADWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkhPLyWVS7rKohtYorrfC/bbYx6JKOKoCyMLKV67VUt7g3llr2gSX0C0wn55FF2C6
         5YbHSFf20UrUDjoquTw/oVe7WxIkUvhUg8xRroPXxbO1ZRn7S4bGuyEj4d+WmA22e0
         iMzU8n9vE3cEQroDX4eGE3vVIy8fuaXeIxrcre3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 139/139] ice: fix concurrent reset and removal of VFs
Date:   Mon, 28 Feb 2022 18:25:13 +0100
Message-Id: <20220228172402.329445589@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

commit fadead80fe4c033b5e514fcbadd20b55c4494112 upstream.

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
Cc: <stable@vger.kernel.org> # e6ba5273d4ed: ice: Fix race conditions between virtchnl handling and VF ndo ops
Cc: <stable@vger.kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h             |    1 
 drivers/net/ethernet/intel/ice/ice_main.c        |    2 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |   42 +++++++++++++----------
 3 files changed, 27 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -231,7 +231,6 @@ enum ice_pf_state {
 	ICE_VFLR_EVENT_PENDING,
 	ICE_FLTR_OVERFLOW_PROMISC,
 	ICE_VF_DIS,
-	ICE_VF_DEINIT_IN_PROGRESS,
 	ICE_CFG_BUSY,
 	ICE_SERVICE_SCHED,
 	ICE_SERVICE_DIS,
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1679,7 +1679,9 @@ static void ice_handle_mdd_event(struct
 				 * reset, so print the event prior to reset.
 				 */
 				ice_print_vf_rx_mdd_event(vf);
+				mutex_lock(&pf->vf[i].cfg_lock);
 				ice_reset_vf(&pf->vf[i], false);
+				mutex_unlock(&pf->vf[i].cfg_lock);
 			}
 		}
 	}
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -615,8 +615,6 @@ void ice_free_vfs(struct ice_pf *pf)
 	struct ice_hw *hw = &pf->hw;
 	unsigned int tmp, i;
 
-	set_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
-
 	if (!pf->vf)
 		return;
 
@@ -632,22 +630,26 @@ void ice_free_vfs(struct ice_pf *pf)
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
@@ -683,7 +685,6 @@ void ice_free_vfs(struct ice_pf *pf)
 				i);
 
 	clear_bit(ICE_VF_DIS, pf->state);
-	clear_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
 
@@ -1567,6 +1568,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf
 	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
+		mutex_lock(&vf->cfg_lock);
+
 		vf->driver_caps = 0;
 		ice_vc_set_default_allowlist(vf);
 
@@ -1581,6 +1584,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
 		ice_vf_post_vsi_rebuild(vf);
+
+		mutex_unlock(&vf->cfg_lock);
 	}
 
 	ice_flush(hw);
@@ -1627,6 +1632,8 @@ bool ice_reset_vf(struct ice_vf *vf, boo
 	u32 reg;
 	int i;
 
+	lockdep_assert_held(&vf->cfg_lock);
+
 	dev = ice_pf_to_dev(pf);
 
 	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
@@ -2113,9 +2120,12 @@ void ice_process_vflr_event(struct ice_p
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
 
@@ -2192,7 +2202,9 @@ ice_vf_lan_overflow_event(struct ice_pf
 	if (!vf)
 		return;
 
+	mutex_lock(&vf->cfg_lock);
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
@@ -4429,10 +4441,6 @@ void ice_vc_process_vf_msg(struct ice_pf
 	struct device *dev;
 	int err = 0;
 
-	/* if de-init is underway, don't process messages from VF */
-	if (test_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state))
-		return;
-
 	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id)) {
 		err = -EINVAL;


