Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7332855E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbhCAQxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhCAQqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:46:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E40764FA1;
        Mon,  1 Mar 2021 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616321;
        bh=Kaiaq37bxYU3CE8A/02j6FI2Xjs9Nt0iMdwy6IywPzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMCq3EKatE6K7yvbPq7IMDxZmTh0RzW5nwtPXEuAGwC9ZN9EmWvBgosiFFFGcgNbg
         84tqOnIGaMommmgBGhd7xqLKLzED4flIFhYA4foCg7RtvzC1Zqv7bzBU+tcxKjubgT
         dzxKqwtioZgAIPP5/ToMQpncHJRvq3b7TgTZ+eVQ=
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
Subject: [PATCH 4.14 111/176] i40e: Fix overwriting flow control settings during driver loading
Date:   Mon,  1 Mar 2021 17:13:04 +0100
Message-Id: <20210301161026.496379737@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index f4475cbf8ce86..3f43e4f0d3b17 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7185,7 +7185,6 @@ static int i40e_reset(struct i40e_pf *pf)
 static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
 	struct i40e_hw *hw = &pf->hw;
-	u8 set_fc_aq_fail = 0;
 	i40e_status ret;
 	u32 val;
 	int v;
@@ -7263,13 +7262,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
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
@@ -11286,7 +11278,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int err;
 	u32 val;
 	u32 i;
-	u8 set_fc_aq_fail;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -11555,24 +11546,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_vsis;
 	}
 
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



