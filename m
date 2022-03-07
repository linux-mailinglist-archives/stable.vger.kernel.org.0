Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A874CF8F6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbiCGKDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbiCGKAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377037DE13;
        Mon,  7 Mar 2022 01:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B79E61220;
        Mon,  7 Mar 2022 09:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1CDC340E9;
        Mon,  7 Mar 2022 09:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646419;
        bh=pNDp5nWRSBhinNFZm8hy3QHMNRTvUd6XoKNcO8RCUuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUj/TEHZnqEl1vkn4N+inceSjK6b7KZLlUx/FwIC5Ucpv6FRtB6jqZJ9/s7XKkVbQ
         VMJb2LpDre0zNBSvMoYpo+La6ebWa209X0DOeJQ5HZifp45B5coyKgYc2YzROcdlHl
         wlMq4FnI+LaPIAa0w+xQwBdxEhKqBAiNCiMdKisM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Nir Efrati <nir.efrati@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/262] e1000e: Fix possible HW unit hang after an s0ix exit
Date:   Mon,  7 Mar 2022 10:19:41 +0100
Message-Id: <20220307091710.039447036@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 1866aa0d0d6492bc2f8d22d0df49abaccf50cddd ]

Disable the OEM bit/Gig Disable/restart AN impact and disable the PHY
LAN connected device (LCD) reset during power management flows. This
fixes possible HW unit hangs on the s0ix exit on some corporate ADL
platforms.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Suggested-by: Nir Efrati <nir.efrati@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/hw.h      |  1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 ++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 +
 drivers/net/ethernet/intel/e1000e/netdev.c  | 26 +++++++++++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index bcf680e83811..13382df2f2ef 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -630,6 +630,7 @@ struct e1000_phy_info {
 	bool disable_polarity_correction;
 	bool is_mdix;
 	bool polarity_correction;
+	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index a3e42d06c63e..d60e2016d03c 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2050,6 +2050,10 @@ static s32 e1000_check_reset_block_ich8lan(struct e1000_hw *hw)
 	bool blocked = false;
 	int i = 0;
 
+	/* Check the PHY (LCD) reset flag */
+	if (hw->phy.reset_disable)
+		return true;
+
 	while ((blocked = !(er32(FWSM) & E1000_ICH_FWSM_RSPCIPHY)) &&
 	       (i++ < 30))
 		usleep_range(10000, 11000);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 2504b11c3169..638a3ddd7ada 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -271,6 +271,7 @@
 #define I217_CGFREG_ENABLE_MTA_RESET	0x0002
 #define I217_MEMPWR			PHY_REG(772, 26)
 #define I217_MEMPWR_DISABLE_SMB_RELEASE	0x0010
+#define I217_MEMPWR_MOEM		0x1000
 
 /* Receive Address Initial CRC Calculation */
 #define E1000_PCH_RAICC(_n)	(0x05F50 + ((_n) * 4))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index af2029bb43e3..ce48e630fe55 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6992,8 +6992,21 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
+		/* Mask OEM Bits / Gig Disable / Restart AN (772_26[12] = 1) */
+		e1e_rphy(hw, I217_MEMPWR, &phy_data);
+		phy_data |= I217_MEMPWR_MOEM;
+		e1e_wphy(hw, I217_MEMPWR, phy_data);
+
+		/* Disable LCD reset */
+		hw->phy.reset_disable = true;
+	}
+
 	e1000e_flush_lpic(pdev);
 
 	e1000e_pm_freeze(dev);
@@ -7015,6 +7028,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7025,6 +7040,17 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	if (rc)
 		return rc;
 
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
+		/* Unmask OEM Bits / Gig Disable / Restart AN 772_26[12] = 0 */
+		e1e_rphy(hw, I217_MEMPWR, &phy_data);
+		phy_data &= ~I217_MEMPWR_MOEM;
+		e1e_wphy(hw, I217_MEMPWR, phy_data);
+
+		/* Enable LCD reset */
+		hw->phy.reset_disable = false;
+	}
+
 	return e1000e_pm_thaw(dev);
 }
 
-- 
2.34.1



