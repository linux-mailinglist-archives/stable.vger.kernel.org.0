Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69114A42A1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376405AbiAaLMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377683AbiAaLKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0AC06175D;
        Mon, 31 Jan 2022 03:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9433B82A4E;
        Mon, 31 Jan 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35B8C340E8;
        Mon, 31 Jan 2022 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627418;
        bh=Drc0GsiNZrcBcv4xS0NRamkCfkHmCeJH4517ls2OviM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG3PaD8a7jfhh+w5vss2HxysVqaH/qcTpaP6DvATmT7Qas3gHW1yzwOmcIQy1aLtY
         Pb3xn2gStFPCxZ+1mGcCfO8VCOrrpoC9aK/9AM+Ypab4mgnhCvkpgXwmcfYL8vAGr3
         +bxxbnDpFBS3CZBvRADHYCBI09g6ndqlzvbJ4VB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 078/171] i40e: Fix for failed to init adminq while VF reset
Date:   Mon, 31 Jan 2022 11:55:43 +0100
Message-Id: <20220131105232.673014556@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

commit 0f344c8129a5337dae50e31b817dd50a60ff238c upstream.

Fix for failed to init adminq: -53 while VF is resetting via MAC
address changing procedure.
Added sync module to avoid reading deadbeef value in reinit adminq
during software reset.
Without this patch it is possible to trigger VF reset procedure
during reinit adminq. This resulted in an incorrect reading of
value from the AQP registers and generated the -53 error.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_register.h    |    3 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   44 ++++++++++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |    1 
 3 files changed, 46 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -413,6 +413,9 @@
 #define I40E_VFINT_DYN_CTLN(_INTVF) (0x00024800 + ((_INTVF) * 4)) /* _i=0...511 */ /* Reset: VFR */
 #define I40E_VFINT_DYN_CTLN_CLEARPBA_SHIFT 1
 #define I40E_VFINT_DYN_CTLN_CLEARPBA_MASK I40E_MASK(0x1, I40E_VFINT_DYN_CTLN_CLEARPBA_SHIFT)
+#define I40E_VFINT_ICR0_ADMINQ_SHIFT 30
+#define I40E_VFINT_ICR0_ADMINQ_MASK I40E_MASK(0x1, I40E_VFINT_ICR0_ADMINQ_SHIFT)
+#define I40E_VFINT_ICR0_ENA(_VF) (0x0002C000 + ((_VF) * 4)) /* _i=0...127 */ /* Reset: CORER */
 #define I40E_VPINT_AEQCTL(_VF) (0x0002B800 + ((_VF) * 4)) /* _i=0...127 */ /* Reset: CORER */
 #define I40E_VPINT_AEQCTL_MSIX_INDX_SHIFT 0
 #define I40E_VPINT_AEQCTL_ITR_INDX_SHIFT 11
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1377,6 +1377,32 @@ static i40e_status i40e_config_vf_promis
 }
 
 /**
+ * i40e_sync_vfr_reset
+ * @hw: pointer to hw struct
+ * @vf_id: VF identifier
+ *
+ * Before trigger hardware reset, we need to know if no other process has
+ * reserved the hardware for any reset operations. This check is done by
+ * examining the status of the RSTAT1 register used to signal the reset.
+ **/
+static int i40e_sync_vfr_reset(struct i40e_hw *hw, int vf_id)
+{
+	u32 reg;
+	int i;
+
+	for (i = 0; i < I40E_VFR_WAIT_COUNT; i++) {
+		reg = rd32(hw, I40E_VFINT_ICR0_ENA(vf_id)) &
+			   I40E_VFINT_ICR0_ADMINQ_MASK;
+		if (reg)
+			return 0;
+
+		usleep_range(100, 200);
+	}
+
+	return -EAGAIN;
+}
+
+/**
  * i40e_trigger_vf_reset
  * @vf: pointer to the VF structure
  * @flr: VFLR was issued or not
@@ -1390,9 +1416,11 @@ static void i40e_trigger_vf_reset(struct
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
 	u32 reg, reg_idx, bit_idx;
+	bool vf_active;
+	u32 radq;
 
 	/* warn the VF */
-	clear_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states);
+	vf_active = test_and_clear_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states);
 
 	/* Disable VF's configuration API during reset. The flag is re-enabled
 	 * in i40e_alloc_vf_res(), when it's safe again to access VF's VSI.
@@ -1406,7 +1434,19 @@ static void i40e_trigger_vf_reset(struct
 	 * just need to clean up, so don't hit the VFRTRIG register.
 	 */
 	if (!flr) {
-		/* reset VF using VPGEN_VFRTRIG reg */
+		/* Sync VFR reset before trigger next one */
+		radq = rd32(hw, I40E_VFINT_ICR0_ENA(vf->vf_id)) &
+			    I40E_VFINT_ICR0_ADMINQ_MASK;
+		if (vf_active && !radq)
+			/* waiting for finish reset by virtual driver */
+			if (i40e_sync_vfr_reset(hw, vf->vf_id))
+				dev_info(&pf->pdev->dev,
+					 "Reset VF %d never finished\n",
+				vf->vf_id);
+
+		/* Reset VF using VPGEN_VFRTRIG reg. It is also setting
+		 * in progress state in rstat1 register.
+		 */
 		reg = rd32(hw, I40E_VPGEN_VFRTRIG(vf->vf_id));
 		reg |= I40E_VPGEN_VFRTRIG_VFSWR_MASK;
 		wr32(hw, I40E_VPGEN_VFRTRIG(vf->vf_id), reg);
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -19,6 +19,7 @@
 #define I40E_MAX_VF_PROMISC_FLAGS	3
 
 #define I40E_VF_STATE_WAIT_COUNT	20
+#define I40E_VFR_WAIT_COUNT		100
 
 /* Various queue ctrls */
 enum i40e_queue_ctrl {


