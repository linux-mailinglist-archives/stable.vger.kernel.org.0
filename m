Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4472F1626
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387778AbhAKNtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbhAKNKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F033921973;
        Mon, 11 Jan 2021 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370586;
        bh=aVJ8CgOh1pd9gLSjSzrywYM/A/tG0BuZmeOQO3xJTso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKHmbzgc3Sm8jwMSR4R3qdB+0Bc04hgaTYv9bdpRxmEHFwFfy3lZQWux6QWxuXMI/
         Uws/0sPeV9RhOeqX1zrj2XrY91slDWob8D4v9MeD8xOJeOuQhwXKttC0lqWv4l2wPL
         /b87Hg37ZBV0lGMdxsIdCq0A02YJ9ZWwVPiUzK3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 10/92] i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs
Date:   Mon, 11 Jan 2021 14:01:14 +0100
Message-Id: <20210111130039.653194817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 3ac874fa84d1baaf0c0175f2a1499f5d88d528b2 ]

When removing VFs for PF added to bridge there was
an error I40E_AQ_RC_EINVAL. It was caused by not properly
resetting and reinitializing PF when adding/removing VFs.
Changed how reset is performed when adding/removing VFs
to properly reinitialize PFs VSI.

Fixes: fc60861e9b00 ("i40e: start up in VEPA mode by default")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h             |    3 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   10 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    4 ++--
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -129,6 +129,7 @@ enum i40e_state_t {
 	__I40E_RESET_INTR_RECEIVED,
 	__I40E_REINIT_REQUESTED,
 	__I40E_PF_RESET_REQUESTED,
+	__I40E_PF_RESET_AND_REBUILD_REQUESTED,
 	__I40E_CORE_RESET_REQUESTED,
 	__I40E_GLOBAL_RESET_REQUESTED,
 	__I40E_EMP_RESET_INTR_RECEIVED,
@@ -156,6 +157,8 @@ enum i40e_state_t {
 };
 
 #define I40E_PF_RESET_FLAG	BIT_ULL(__I40E_PF_RESET_REQUESTED)
+#define I40E_PF_RESET_AND_REBUILD_FLAG	\
+	BIT_ULL(__I40E_PF_RESET_AND_REBUILD_REQUESTED)
 
 /* VSI state flags */
 enum i40e_vsi_state_t {
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -44,6 +44,8 @@ static int i40e_setup_misc_vector(struct
 static void i40e_determine_queue_usage(struct i40e_pf *pf);
 static int i40e_setup_pf_filter_control(struct i40e_pf *pf);
 static void i40e_prep_for_reset(struct i40e_pf *pf, bool lock_acquired);
+static void i40e_reset_and_rebuild(struct i40e_pf *pf, bool reinit,
+				   bool lock_acquired);
 static int i40e_reset(struct i40e_pf *pf);
 static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired);
 static int i40e_setup_misc_vector_for_recovery_mode(struct i40e_pf *pf);
@@ -8484,6 +8486,14 @@ void i40e_do_reset(struct i40e_pf *pf, u
 			 "FW LLDP is disabled\n" :
 			 "FW LLDP is enabled\n");
 
+	} else if (reset_flags & I40E_PF_RESET_AND_REBUILD_FLAG) {
+		/* Request a PF Reset
+		 *
+		 * Resets PF and reinitializes PFs VSI.
+		 */
+		i40e_prep_for_reset(pf, lock_acquired);
+		i40e_reset_and_rebuild(pf, true, lock_acquired);
+
 	} else if (reset_flags & BIT_ULL(__I40E_REINIT_REQUESTED)) {
 		int v;
 
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1704,7 +1704,7 @@ int i40e_pci_sriov_configure(struct pci_
 	if (num_vfs) {
 		if (!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) {
 			pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
-			i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
+			i40e_do_reset_safe(pf, I40E_PF_RESET_AND_REBUILD_FLAG);
 		}
 		ret = i40e_pci_sriov_enable(pdev, num_vfs);
 		goto sriov_configure_out;
@@ -1713,7 +1713,7 @@ int i40e_pci_sriov_configure(struct pci_
 	if (!pci_vfs_assigned(pf->pdev)) {
 		i40e_free_vfs(pf);
 		pf->flags &= ~I40E_FLAG_VEB_MODE_ENABLED;
-		i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
+		i40e_do_reset_safe(pf, I40E_PF_RESET_AND_REBUILD_FLAG);
 	} else {
 		dev_warn(&pdev->dev, "Unable to free VFs because some are assigned to VMs.\n");
 		ret = -EINVAL;


