Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74012C9B57
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388942AbgLAJHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388965AbgLAJHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 067CA221FF;
        Tue,  1 Dec 2020 09:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813594;
        bh=4UuE8C3MWj3DtoDzjkLJZ96OOux9UMAtFbC0wm5RqZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QATTxVsiiODFE/QuzA8ABxOx8l6n55fJnuc9ExQkZ/8w5ymQTCZqeQp1H2NdvkWDp
         boDipTqYja4CrZTG+uRjrk5dJydgJjPDEH2P6H28hEddsOR8W+x/vpxbduNPB5mbal
         ZAVKdnV+Pq7wF+ShsaQazIdZDpK2ibCHQsTRzmec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Brett Creeley <brett.creeley@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/98] i40e: Fix removing driver while bare-metal VFs pass traffic
Date:   Tue,  1 Dec 2020 09:53:39 +0100
Message-Id: <20201201084658.122302837@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 2980cbd4dce7b1e9bf57df3ced43a7b184986f50 ]

Prevent VFs from resetting when PF driver is being unloaded:
- introduce new pf state: __I40E_VF_RESETS_DISABLED;
- check if pf state has __I40E_VF_RESETS_DISABLED state set,
  if so, disable any further VFLR event notifications;
- when i40e_remove (rmmod i40e) is called, disable any resets on
  the VFs;

Previously if there were bare-metal VFs passing traffic and PF
driver was removed, there was a possibility of VFs triggering a Tx
timeout right before iavf_remove. This was causing iavf_close to
not be called because there is a check in the beginning of  iavf_remove
that bails out early if adapter->state < IAVF_DOWN_PENDING. This
makes it so some resources do not get cleaned up.

Fixes: 6a9ddb36eeb8 ("i40e: disable IOV before freeing resources")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20201120180640.3654474-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 22 +++++++++++-----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 26 +++++++++++--------
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 401304d4d5536..cfe99bae8e362 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -150,6 +150,7 @@ enum i40e_state_t {
 	__I40E_CLIENT_RESET,
 	__I40E_VIRTCHNL_OP_PENDING,
 	__I40E_RECOVERY_MODE,
+	__I40E_VF_RESETS_DISABLED,	/* disable resets during i40e_remove */
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_STATE_SIZE__,
 };
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b3c3911adfc2e..2b4327416457d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3988,8 +3988,16 @@ static irqreturn_t i40e_intr(int irq, void *data)
 	}
 
 	if (icr0 & I40E_PFINT_ICR0_VFLR_MASK) {
-		ena_mask &= ~I40E_PFINT_ICR0_ENA_VFLR_MASK;
-		set_bit(__I40E_VFLR_EVENT_PENDING, pf->state);
+		/* disable any further VFLR event notifications */
+		if (test_bit(__I40E_VF_RESETS_DISABLED, pf->state)) {
+			u32 reg = rd32(hw, I40E_PFINT_ICR0_ENA);
+
+			reg &= ~I40E_PFINT_ICR0_VFLR_MASK;
+			wr32(hw, I40E_PFINT_ICR0_ENA, reg);
+		} else {
+			ena_mask &= ~I40E_PFINT_ICR0_ENA_VFLR_MASK;
+			set_bit(__I40E_VFLR_EVENT_PENDING, pf->state);
+		}
 	}
 
 	if (icr0 & I40E_PFINT_ICR0_GRST_MASK) {
@@ -15345,6 +15353,11 @@ static void i40e_remove(struct pci_dev *pdev)
 	while (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
 		usleep_range(1000, 2000);
 
+	if (pf->flags & I40E_FLAG_SRIOV_ENABLED) {
+		set_bit(__I40E_VF_RESETS_DISABLED, pf->state);
+		i40e_free_vfs(pf);
+		pf->flags &= ~I40E_FLAG_SRIOV_ENABLED;
+	}
 	/* no more scheduling of any task */
 	set_bit(__I40E_SUSPENDED, pf->state);
 	set_bit(__I40E_DOWN, pf->state);
@@ -15371,11 +15384,6 @@ static void i40e_remove(struct pci_dev *pdev)
 	 */
 	i40e_notify_client_of_netdev_close(pf->vsi[pf->lan_vsi], false);
 
-	if (pf->flags & I40E_FLAG_SRIOV_ENABLED) {
-		i40e_free_vfs(pf);
-		pf->flags &= ~I40E_FLAG_SRIOV_ENABLED;
-	}
-
 	i40e_fdir_teardown(pf);
 
 	/* If there is a switch structure or any orphans, remove them.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 38042d610f82c..09ff3f335ffa6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1335,7 +1335,8 @@ static void i40e_cleanup_reset_vf(struct i40e_vf *vf)
  * @vf: pointer to the VF structure
  * @flr: VFLR was issued or not
  *
- * Returns true if the VF is reset, false otherwise.
+ * Returns true if the VF is in reset, resets successfully, or resets
+ * are disabled and false otherwise.
  **/
 bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 {
@@ -1345,11 +1346,14 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	u32 reg;
 	int i;
 
+	if (test_bit(__I40E_VF_RESETS_DISABLED, pf->state))
+		return true;
+
 	/* If the VFs have been disabled, this means something else is
 	 * resetting the VF, so we shouldn't continue.
 	 */
 	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state))
-		return false;
+		return true;
 
 	i40e_trigger_vf_reset(vf, flr);
 
@@ -1513,6 +1517,15 @@ void i40e_free_vfs(struct i40e_pf *pf)
 
 	i40e_notify_client_of_vf_enable(pf, 0);
 
+	/* Disable IOV before freeing resources. This lets any VF drivers
+	 * running in the host get themselves cleaned up before we yank
+	 * the carpet out from underneath their feet.
+	 */
+	if (!pci_vfs_assigned(pf->pdev))
+		pci_disable_sriov(pf->pdev);
+	else
+		dev_warn(&pf->pdev->dev, "VFs are assigned - not disabling SR-IOV\n");
+
 	/* Amortize wait time by stopping all VFs at the same time */
 	for (i = 0; i < pf->num_alloc_vfs; i++) {
 		if (test_bit(I40E_VF_STATE_INIT, &pf->vf[i].vf_states))
@@ -1528,15 +1541,6 @@ void i40e_free_vfs(struct i40e_pf *pf)
 		i40e_vsi_wait_queues_disabled(pf->vsi[pf->vf[i].lan_vsi_idx]);
 	}
 
-	/* Disable IOV before freeing resources. This lets any VF drivers
-	 * running in the host get themselves cleaned up before we yank
-	 * the carpet out from underneath their feet.
-	 */
-	if (!pci_vfs_assigned(pf->pdev))
-		pci_disable_sriov(pf->pdev);
-	else
-		dev_warn(&pf->pdev->dev, "VFs are assigned - not disabling SR-IOV\n");
-
 	/* free up VF resources */
 	tmp = pf->num_alloc_vfs;
 	pf->num_alloc_vfs = 0;
-- 
2.27.0



