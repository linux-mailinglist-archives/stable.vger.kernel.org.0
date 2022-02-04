Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E24A9550
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241180AbiBDIkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:40:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiBDIkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:40:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F6336102C
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E10C004E1;
        Fri,  4 Feb 2022 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643964022;
        bh=Dv2xzAzJ+t+SiCejh1561F+fYN+PQRILa04NSwumdvs=;
        h=Subject:To:Cc:From:Date:From;
        b=jtd+afaK4E6OhNKKF2acbUTynJx1IpFBZRGs4866LfNqhCXJcxcthYvKCo/xMNg/s
         kXhtdrzBKjypQDvB/fQPjfV5gzsnhrHKltZBppOv8Ca7uCiItMd51UQIIa/BQ15BLR
         DwAmBps7OCa/DJN6ATkBjVNmchkyAg+Tvx/ZFrcw=
Subject: FAILED: patch "[PATCH] i40e: Fix reset path while removing the driver" failed to apply to 4.19-stable tree
To:     karen.sornek@intel.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com, slawomirx.laba@intel.com,
        sylwesterx.dziedziuch@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:40:11 +0100
Message-ID: <1643964011196116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6533e558c6505e94c3e0ed4281ed5e31ec985f4d Mon Sep 17 00:00:00 2001
From: Karen Sornek <karen.sornek@intel.com>
Date: Wed, 12 Jan 2022 10:19:47 +0100
Subject: [PATCH] i40e: Fix reset path while removing the driver

Fix the crash in kernel while dereferencing the NULL pointer,
when the driver is unloaded and simultaneously the VSI rings
are being stopped.

The hardware requires 50msec in order to finish RX queues
disable. For this purpose the driver spins in mdelay function
for the operation to be completed.

For example changing number of queues which requires reset would
fail in the following call stack:

1) i40e_prep_for_reset
2) i40e_pf_quiesce_all_vsi
3) i40e_quiesce_vsi
4) i40e_vsi_close
5) i40e_down
6) i40e_vsi_stop_rings
7) i40e_vsi_control_rx -> disable requires the delay of 50msecs
8) continue back in i40e_down function where
   i40e_clean_tx_ring(vsi->tx_rings[i]) is going to crash

When the driver was spinning vsi_release called
i40e_vsi_free_arrays where the vsi->tx_rings resources
were freed and the pointer was set to NULL.

Fixes: 5b6d4a7f20b0 ("i40e: Fix crash during removing i40e driver")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 2e02cc68cd3f..80c5cecaf2b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -144,6 +144,7 @@ enum i40e_state_t {
 	__I40E_VIRTCHNL_OP_PENDING,
 	__I40E_RECOVERY_MODE,
 	__I40E_VF_RESETS_DISABLED,	/* disable resets during i40e_remove */
+	__I40E_IN_REMOVE,
 	__I40E_VFS_RELEASING,
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_STATE_SIZE__,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5cb4dc69fe87..0c4b7dfb3b35 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10863,6 +10863,9 @@ static void i40e_reset_and_rebuild(struct i40e_pf *pf, bool reinit,
 				   bool lock_acquired)
 {
 	int ret;
+
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return;
 	/* Now we wait for GRST to settle out.
 	 * We don't have to delete the VEBs or VSIs from the hw switch
 	 * because the reset will make them disappear.
@@ -12222,6 +12225,8 @@ int i40e_reconfig_rss_queues(struct i40e_pf *pf, int queue_count)
 
 		vsi->req_queue_pairs = queue_count;
 		i40e_prep_for_reset(pf);
+		if (test_bit(__I40E_IN_REMOVE, pf->state))
+			return pf->alloc_rss_size;
 
 		pf->alloc_rss_size = new_rss_size;
 
@@ -13048,6 +13053,10 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	if (need_reset)
 		i40e_prep_for_reset(pf);
 
+	/* VSI shall be deleted in a moment, just return EINVAL */
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return -EINVAL;
+
 	old_prog = xchg(&vsi->xdp_prog, prog);
 
 	if (need_reset) {
@@ -15938,8 +15947,13 @@ static void i40e_remove(struct pci_dev *pdev)
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), 0);
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), 0);
 
-	while (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
+	/* Grab __I40E_RESET_RECOVERY_PENDING and set __I40E_IN_REMOVE
+	 * flags, once they are set, i40e_rebuild should not be called as
+	 * i40e_prep_for_reset always returns early.
+	 */
+	while (test_and_set_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
 		usleep_range(1000, 2000);
+	set_bit(__I40E_IN_REMOVE, pf->state);
 
 	if (pf->flags & I40E_FLAG_SRIOV_ENABLED) {
 		set_bit(__I40E_VF_RESETS_DISABLED, pf->state);
@@ -16138,6 +16152,9 @@ static void i40e_pci_error_reset_done(struct pci_dev *pdev)
 {
 	struct i40e_pf *pf = pci_get_drvdata(pdev);
 
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return;
+
 	i40e_reset_and_rebuild(pf, false, false);
 }
 

