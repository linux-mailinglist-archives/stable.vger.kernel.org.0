Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C64E583029
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbiG0ReK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbiG0Rde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FC38244D;
        Wed, 27 Jul 2022 09:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E993B61684;
        Wed, 27 Jul 2022 16:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3156C433B5;
        Wed, 27 Jul 2022 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940510;
        bh=HExVcHZTruUUfXUkliReJ0ROIBKXM0SO1OOV/4zgfhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dau8xouMusYxpIPi18cvf+npgLLFIZHtQWyNLDJQqF9WepZT8Ozg7SIjLNpZSDl02
         Co9YZ9dU+HvjJO5DO8sOh8OggFdEPAfS0X7FcJCui/mn/8Jc2lDkgDRjjB/PtCMDQV
         Q5QiiNNcL2uPXmE8wKEjZaWdxynbB4cKm5Ifqmkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 031/158] Revert "e1000e: Fix possible HW unit hang after an s0ix exit"
Date:   Wed, 27 Jul 2022 18:11:35 +0200
Message-Id: <20220727161022.727044176@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 6cfa45361d3eac31ba67d7d0bbef547151450106 ]

This reverts commit 1866aa0d0d6492bc2f8d22d0df49abaccf50cddd.

Commit 1866aa0d0d64 ("e1000e: Fix possible HW unit hang after an s0ix
exit") was a workaround for CSME problem to handle messages comes via H2ME
mailbox. This problem has been fixed by patch "e1000e: Enable the GPT
clock before sending message to the CSME".

Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/hw.h      |  1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 ----
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c  | 26 ---------------------
 4 files changed, 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 13382df2f2ef..bcf680e83811 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -630,7 +630,6 @@ struct e1000_phy_info {
 	bool disable_polarity_correction;
 	bool is_mdix;
 	bool polarity_correction;
-	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index e6c8e6d5234f..9466f65a6da7 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2050,10 +2050,6 @@ static s32 e1000_check_reset_block_ich8lan(struct e1000_hw *hw)
 	bool blocked = false;
 	int i = 0;
 
-	/* Check the PHY (LCD) reset flag */
-	if (hw->phy.reset_disable)
-		return true;
-
 	while ((blocked = !(er32(FWSM) & E1000_ICH_FWSM_RSPCIPHY)) &&
 	       (i++ < 30))
 		usleep_range(10000, 11000);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 638a3ddd7ada..2504b11c3169 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -271,7 +271,6 @@
 #define I217_CGFREG_ENABLE_MTA_RESET	0x0002
 #define I217_MEMPWR			PHY_REG(772, 26)
 #define I217_MEMPWR_DISABLE_SMB_RELEASE	0x0010
-#define I217_MEMPWR_MOEM		0x1000
 
 /* Receive Address Initial CRC Calculation */
 #define E1000_PCH_RAICC(_n)	(0x05F50 + ((_n) * 4))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index c64102b29862..f1729940e46c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6991,21 +6991,8 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
-	    hw->mac.type >= e1000_pch_adp) {
-		/* Mask OEM Bits / Gig Disable / Restart AN (772_26[12] = 1) */
-		e1e_rphy(hw, I217_MEMPWR, &phy_data);
-		phy_data |= I217_MEMPWR_MOEM;
-		e1e_wphy(hw, I217_MEMPWR, phy_data);
-
-		/* Disable LCD reset */
-		hw->phy.reset_disable = true;
-	}
-
 	e1000e_flush_lpic(pdev);
 
 	e1000e_pm_freeze(dev);
@@ -7027,8 +7014,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7039,17 +7024,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
-	    hw->mac.type >= e1000_pch_adp) {
-		/* Unmask OEM Bits / Gig Disable / Restart AN 772_26[12] = 0 */
-		e1e_rphy(hw, I217_MEMPWR, &phy_data);
-		phy_data &= ~I217_MEMPWR_MOEM;
-		e1e_wphy(hw, I217_MEMPWR, phy_data);
-
-		/* Enable LCD reset */
-		hw->phy.reset_disable = false;
-	}
-
 	return e1000e_pm_thaw(dev);
 }
 
-- 
2.35.1



