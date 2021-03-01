Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964BF3290AD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242807AbhCAUMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242559AbhCAUCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1209465395;
        Mon,  1 Mar 2021 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621469;
        bh=pl2Q7hvzPUKUqWDnY4IvMXgXiT4MrI8eYry386xtx6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfCTuDWOUA75MxBb3mPmxAg8nmqMO6o1mOCz/txkHKsybbGEBE+5pmZWKXnwllW5o
         idVDceJn/B+JebwzZRVxP11onlayBCxjIVfszMoFrbKzLbMiHoUE68tpcNkHhMaQf/
         O3BmSCMbVVCSyCmabY3KH+rVhrhRyZJgRZdU2j+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 526/775] i40e: Fix addition of RX filters after enabling FW LLDP agent
Date:   Mon,  1 Mar 2021 17:11:34 +0100
Message-Id: <20210301161227.505993829@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 28b1208e7a7fa3ddc9345b022bb93e53d9dcc28a ]

Fix addition of VLAN filter for PF after enabling FW LLDP agent.
Changing LLDP Agent causes FW to re-initialize per NVM settings.
Remove default PF filter and move "Enable/Disable" to currently used
reset flag.
Without this patch PF would try to add MAC VLAN filter with default
switch filter present. This causes AQ error and sets promiscuous mode
on.

Fixes: c65e78f87f81 ("i40e: Further implementation of LLDP")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 16 +++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  9 ++++-----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 26ba1f3eb2d85..9e81f85ee2d8d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4878,7 +4878,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 	enum i40e_admin_queue_err adq_err;
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
-	bool is_reset_needed;
+	u32 reset_needed = 0;
 	i40e_status status;
 	u32 i, j;
 
@@ -4923,9 +4923,11 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 flags_complete:
 	changed_flags = orig_flags ^ new_flags;
 
-	is_reset_needed = !!(changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
-		I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED |
-		I40E_FLAG_DISABLE_FW_LLDP));
+	if (changed_flags & I40E_FLAG_DISABLE_FW_LLDP)
+		reset_needed = I40E_PF_RESET_AND_REBUILD_FLAG;
+	if (changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
+	    I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED))
+		reset_needed = BIT(__I40E_PF_RESET_REQUESTED);
 
 	/* Before we finalize any flag changes, we need to perform some
 	 * checks to ensure that the changes are supported and safe.
@@ -5057,7 +5059,7 @@ flags_complete:
 				case I40E_AQ_RC_EEXIST:
 					dev_warn(&pf->pdev->dev,
 						 "FW LLDP agent is already running\n");
-					is_reset_needed = false;
+					reset_needed = 0;
 					break;
 				case I40E_AQ_RC_EPERM:
 					dev_warn(&pf->pdev->dev,
@@ -5086,8 +5088,8 @@ flags_complete:
 	/* Issue reset to cause things to take effect, as additional bits
 	 * are added we will need to create a mask of bits requiring reset
 	 */
-	if (is_reset_needed)
-		i40e_do_reset(pf, BIT(__I40E_PF_RESET_REQUESTED), true);
+	if (reset_needed)
+		i40e_do_reset(pf, reset_needed, true);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index bcfa6dcac29f7..b268adb3e1d44 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8537,11 +8537,6 @@ void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired)
 		dev_dbg(&pf->pdev->dev, "PFR requested\n");
 		i40e_handle_reset_warning(pf, lock_acquired);
 
-		dev_info(&pf->pdev->dev,
-			 pf->flags & I40E_FLAG_DISABLE_FW_LLDP ?
-			 "FW LLDP is disabled\n" :
-			 "FW LLDP is enabled\n");
-
 	} else if (reset_flags & I40E_PF_RESET_AND_REBUILD_FLAG) {
 		/* Request a PF Reset
 		 *
@@ -8549,6 +8544,10 @@ void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired)
 		 */
 		i40e_prep_for_reset(pf, lock_acquired);
 		i40e_reset_and_rebuild(pf, true, lock_acquired);
+		dev_info(&pf->pdev->dev,
+			 pf->flags & I40E_FLAG_DISABLE_FW_LLDP ?
+			 "FW LLDP is disabled\n" :
+			 "FW LLDP is enabled\n");
 
 	} else if (reset_flags & BIT_ULL(__I40E_REINIT_REQUESTED)) {
 		int v;
-- 
2.27.0



