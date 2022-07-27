Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35227582DF3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiG0REy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241549AbiG0RE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBB15A140;
        Wed, 27 Jul 2022 09:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 023B3B821AC;
        Wed, 27 Jul 2022 16:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E086C433C1;
        Wed, 27 Jul 2022 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939945;
        bh=e20EUWmZgSZbpAgmRG7IFoz3qsJJw30BAVwpb8YR1jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Onm12+Ntc2zTUETcmCzs0dCqxmY7QzK/v6vNA2iugZdFl3bAeKnFFtqjRoEQ8fuCU
         lqPFJUr/rqX3lmmk+312U3KkBKb57hWjx3a8P2H4fVAUvQxfnraP2SCizq0hoZbyNY
         Wp4sdMlw/JNASuzo08C0EOIMXB3YJF05wOognOpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/201] Revert "e1000e: Fix possible HW unit hang after an s0ix exit"
Date:   Wed, 27 Jul 2022 18:09:16 +0200
Message-Id: <20220727161029.051627351@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index 0fba6ccecf12..407bbb4cc236 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6996,21 +6996,8 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
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
@@ -7032,8 +7019,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7044,17 +7029,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
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



