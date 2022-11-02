Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC566615A20
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKBDZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiKBDZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:25:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FD325C5E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E8B4B82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F15C433D6;
        Wed,  2 Nov 2022 03:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359510;
        bh=/NSA0+ElVRr4yWAt93A2POlZJ1KvBFpT9ll2JXoW5Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2gtQ05BVTXkydUadH7Rn/mPJHUP0S4+vDT0XwlbrPYjflExwAQ5aNXztn0kKoQAG/
         64/ErOb5npagJJuzwKJQ7dQuloD+7sd4ug5BmOTOG+yR9dZYNx8INcLHnj/Syv5Jvp
         Um0XQBHxlrfySqOpcyl/Yw9/I5XgIeNYqz0CquJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/64] i40e: Fix VF hang when reset is triggered on another VF
Date:   Wed,  2 Nov 2022 03:34:18 +0100
Message-Id: <20221102022053.500691255@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 52424f974bc53c26ba3f00300a00e9de9afcd972 ]

When a reset was triggered on one VF with i40e_reset_vf
global PF state __I40E_VF_DISABLE was set on a PF until
the reset finished. If immediately after triggering reset
on one VF there is a request to reset on another
it will cause a hang on VF side because VF will be notified
of incoming reset but the reset will never happen because
of this global state, we will get such error message:

[  +4.890195] iavf 0000:86:02.1: Never saw reset

and VF will hang waiting for the reset to be triggered.

Fix this by introducing new VF state I40E_VF_STATE_RESETTING
that will be set on a VF if it is currently resetting instead of
the global __I40E_VF_DISABLE PF state.

Fixes: 3ba9bcb4b68f ("i40e: add locking around VF reset")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20221024100526.1874914-2-jacob.e.keller@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 43 ++++++++++++++-----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  1 +
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 16f5baafbbd5..fb060e3253d9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1352,10 +1352,12 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	if (test_bit(__I40E_VF_RESETS_DISABLED, pf->state))
 		return true;
 
-	/* If the VFs have been disabled, this means something else is
-	 * resetting the VF, so we shouldn't continue.
-	 */
-	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state))
+	/* Bail out if VFs are disabled. */
+	if (test_bit(__I40E_VF_DISABLE, pf->state))
+		return true;
+
+	/* If VF is being reset already we don't need to continue. */
+	if (test_and_set_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
 		return true;
 
 	i40e_trigger_vf_reset(vf, flr);
@@ -1392,7 +1394,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
-	clear_bit(__I40E_VF_DISABLE, pf->state);
+	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
 }
@@ -1425,8 +1427,12 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		return false;
 
 	/* Begin reset on all VFs at once */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
-		i40e_trigger_vf_reset(&pf->vf[v], flr);
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		vf = &pf->vf[v];
+		/* If VF is being reset no need to trigger reset again */
+		if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			i40e_trigger_vf_reset(&pf->vf[v], flr);
+	}
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
@@ -1442,9 +1448,11 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		 */
 		while (v < pf->num_alloc_vfs) {
 			vf = &pf->vf[v];
-			reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
-			if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
-				break;
+			if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states)) {
+				reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
+				if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
+					break;
+			}
 
 			/* If the current VF has finished resetting, move on
 			 * to the next VF in sequence.
@@ -1472,6 +1480,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		if (pf->vf[v].lan_vsi_idx == 0)
 			continue;
 
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_vsi_stop_rings_no_wait(pf->vsi[pf->vf[v].lan_vsi_idx]);
 	}
 
@@ -1483,6 +1495,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		if (pf->vf[v].lan_vsi_idx == 0)
 			continue;
 
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_vsi_wait_queues_disabled(pf->vsi[pf->vf[v].lan_vsi_idx]);
 	}
 
@@ -1492,8 +1508,13 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	mdelay(50);
 
 	/* Finish the reset on each VF */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_cleanup_reset_vf(&pf->vf[v]);
+	}
 
 	i40e_flush(hw);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 7df3e5833c5d..23182731a73d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -41,6 +41,7 @@ enum i40e_vf_states {
 	I40E_VF_STATE_MC_PROMISC,
 	I40E_VF_STATE_UC_PROMISC,
 	I40E_VF_STATE_PRE_ENABLE,
+	I40E_VF_STATE_RESETTING
 };
 
 /* VF capabilities */
-- 
2.35.1



