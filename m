Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC632872D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbhCARVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237857AbhCARNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7199964F49;
        Mon,  1 Mar 2021 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617075;
        bh=i06Ue1D+x+J5O1aZ0G+2K1e34YMbhk1OMb9LwjGHnAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RX+aR3VkpyUtRDcE6R6Ec1sCV7UWFNn7ImbcLMTLShtqcwkfv1aaA8Bcz7EMqSzMa
         jp5hnVkE+rZMsSO+1j+KXokI5A6O7h1ApZ0XTzTMCtOB/5czsdx8ZXWgYQZu4ms0EW
         vvlw1SpGNjMBUtrDum6d2fxTl4tUdL0p+O62YFEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/247] i40e: Fix overwriting flow control settings during driver loading
Date:   Mon,  1 Mar 2021 17:13:04 +0100
Message-Id: <20210301161039.696960092@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 4cdb9f80dcd46aab3c0020b4a6920c22735c5d6e ]

During driver loading flow control settings were written to FW
using a variable which was always zero, since it was being set
only by ethtool. This behavior has been corrected and driver
no longer overwrites the default FW/NVM settings.

Fixes: 373149fc99a0 ("i40e: Decrease the scope of rtnl lock")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 27 ---------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2518e2d6484c0..7a9d8bf2e1d5f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9403,7 +9403,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	struct i40e_hw *hw = &pf->hw;
-	u8 set_fc_aq_fail = 0;
 	i40e_status ret;
 	u32 val;
 	int v;
@@ -9484,13 +9483,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 			 i40e_stat_str(&pf->hw, ret),
 			 i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
 
-	/* make sure our flow control settings are restored */
-	ret = i40e_set_fc(&pf->hw, &set_fc_aq_fail, true);
-	if (ret)
-		dev_dbg(&pf->pdev->dev, "setting flow control: ret = %s last_status = %s\n",
-			i40e_stat_str(&pf->hw, ret),
-			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
-
 	/* Rebuild the VSIs and VEBs that existed before reset.
 	 * They are still in our local switch element arrays, so only
 	 * need to rebuild the switch model in the HW.
@@ -13629,7 +13621,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int err;
 	u32 val;
 	u32 i;
-	u8 set_fc_aq_fail;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -13909,24 +13900,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	INIT_LIST_HEAD(&pf->vsi[pf->lan_vsi]->ch_list);
 
-	/* Make sure flow control is set according to current settings */
-	err = i40e_set_fc(hw, &set_fc_aq_fail, true);
-	if (set_fc_aq_fail & I40E_SET_FC_AQ_FAIL_GET)
-		dev_dbg(&pf->pdev->dev,
-			"Set fc with err %s aq_err %s on get_phy_cap\n",
-			i40e_stat_str(hw, err),
-			i40e_aq_str(hw, hw->aq.asq_last_status));
-	if (set_fc_aq_fail & I40E_SET_FC_AQ_FAIL_SET)
-		dev_dbg(&pf->pdev->dev,
-			"Set fc with err %s aq_err %s on set_phy_config\n",
-			i40e_stat_str(hw, err),
-			i40e_aq_str(hw, hw->aq.asq_last_status));
-	if (set_fc_aq_fail & I40E_SET_FC_AQ_FAIL_UPDATE)
-		dev_dbg(&pf->pdev->dev,
-			"Set fc with err %s aq_err %s on get_link_info\n",
-			i40e_stat_str(hw, err),
-			i40e_aq_str(hw, hw->aq.asq_last_status));
-
 	/* if FDIR VSI was set up, start it now */
 	for (i = 0; i < pf->num_alloc_vsi; i++) {
 		if (pf->vsi[i] && pf->vsi[i]->type == I40E_VSI_FDIR) {
-- 
2.27.0



