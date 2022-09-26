Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6DE5EA533
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbiIZL7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbiIZL5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:57:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E49179EF7;
        Mon, 26 Sep 2022 03:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F085B8094E;
        Mon, 26 Sep 2022 10:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65411C433D6;
        Mon, 26 Sep 2022 10:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189488;
        bh=rPOYb/usdg3kKuCluI9ZiRDJ+/5EpnjMM/bZ0kffn6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+hejAsZDwj0SNvEyPqdgMedsoYl5cLUhnkkGgoDJzgc+OTEYvlhAFrvNWB/lOh6I
         fHi3xE966VV0RcfsLWgyYafZYlMUaV6/V1Za/fdMkNAh02tlDUV2sDweUUw2Tmwekc
         crLEYIODZQ9+3HH+Z2qg59umw8E5Ksjb0hJVtYqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.19 165/207] phy: marvell: phy-mvebu-a3700-comphy: Remove broken reset support
Date:   Mon, 26 Sep 2022 12:12:34 +0200
Message-Id: <20220926100814.051873209@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 0a6fc70d76bddf98278af2ac000379c82aec8f11 upstream.

Reset support for SATA PHY is somehow broken and after calling it, kernel
is not able to detect and initialize SATA disk Samsung SSD 850 EMT0 [1].

Reset support was introduced in commit 934337080c6c ("phy: marvell:
phy-mvebu-a3700-comphy: Add native kernel implementation") as part of
complete rewrite of this driver. v1 patch series of that commit [2] did
not contain reset support and was tested that is working fine with
Ethernet, SATA and USB PHYs without issues too.

So for now remove broken reset support and change implementation of
power_off callback to power off all functions on specified lane (and not
only selected function) because during startup kernel does not know which
function was selected and configured by bootloader. Same logic was used
also in v1 patch series of that commit.

This change fixes issues with initialization of SATA disk Samsung SSD 850
and disk is working again, like before mentioned commit.

Once problem with PHY reset callback is solved its functionality could be
re-introduced. But for now it is unknown why it does not work.

[1] - https://lore.kernel.org/r/20220531124159.3e4lgn2v462irbtz@shindev/
[2] - https://lore.kernel.org/r/20211028184242.22105-1-kabel@kernel.org/

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 934337080c6c ("phy: marvell: phy-mvebu-a3700-comphy: Add native kernel implementation")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Pali Rohár <pali@kernel.org>
Tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20220829083046.15082-1-pali@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 87 ++++----------------
 1 file changed, 17 insertions(+), 70 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index a4d7d9bd100d..67712c77d806 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -274,7 +274,6 @@ struct mvebu_a3700_comphy_lane {
 	int submode;
 	bool invert_tx;
 	bool invert_rx;
-	bool needs_reset;
 };
 
 struct gbe_phy_init_data_fix {
@@ -1097,40 +1096,12 @@ mvebu_a3700_comphy_pcie_power_off(struct mvebu_a3700_comphy_lane *lane)
 			    0x0, PU_PLL_BIT | PU_RX_BIT | PU_TX_BIT);
 }
 
-static int mvebu_a3700_comphy_reset(struct phy *phy)
+static void mvebu_a3700_comphy_usb3_power_off(struct mvebu_a3700_comphy_lane *lane)
 {
-	struct mvebu_a3700_comphy_lane *lane = phy_get_drvdata(phy);
-	u16 mask, data;
-
-	dev_dbg(lane->dev, "resetting lane %d\n", lane->id);
-
-	/* COMPHY reset for internal logic */
-	comphy_lane_reg_set(lane, COMPHY_SFT_RESET,
-			    SFT_RST_NO_REG, SFT_RST_NO_REG);
-
-	/* COMPHY register reset (cleared automatically) */
-	comphy_lane_reg_set(lane, COMPHY_SFT_RESET, SFT_RST, SFT_RST);
-
-	/* PIPE soft and register reset */
-	data = PIPE_SOFT_RESET | PIPE_REG_RESET;
-	mask = data;
-	comphy_lane_reg_set(lane, COMPHY_PIPE_RST_CLK_CTRL, data, mask);
-
-	/* Release PIPE register reset */
-	comphy_lane_reg_set(lane, COMPHY_PIPE_RST_CLK_CTRL,
-			    0x0, PIPE_REG_RESET);
-
-	/* Reset SB configuration register (only for lanes 0 and 1) */
-	if (lane->id == 0 || lane->id == 1) {
-		u32 mask, data;
-
-		data = PIN_RESET_CORE_BIT | PIN_RESET_COMPHY_BIT |
-		       PIN_PU_PLL_BIT | PIN_PU_RX_BIT | PIN_PU_TX_BIT;
-		mask = data | PIN_PU_IVREF_BIT | PIN_TX_IDLE_BIT;
-		comphy_periph_reg_set(lane, COMPHY_PHY_CFG1, data, mask);
-	}
-
-	return 0;
+	/*
+	 * The USB3 MAC sets the USB3 PHY to low state, so we do not
+	 * need to power off USB3 PHY again.
+	 */
 }
 
 static bool mvebu_a3700_comphy_check_mode(int lane,
@@ -1171,10 +1142,6 @@ static int mvebu_a3700_comphy_set_mode(struct phy *phy, enum phy_mode mode,
 	    (lane->mode != mode || lane->submode != submode))
 		return -EBUSY;
 
-	/* If changing mode, ensure reset is called */
-	if (lane->mode != PHY_MODE_INVALID && lane->mode != mode)
-		lane->needs_reset = true;
-
 	/* Just remember the mode, ->power_on() will do the real setup */
 	lane->mode = mode;
 	lane->submode = submode;
@@ -1185,7 +1152,6 @@ static int mvebu_a3700_comphy_set_mode(struct phy *phy, enum phy_mode mode,
 static int mvebu_a3700_comphy_power_on(struct phy *phy)
 {
 	struct mvebu_a3700_comphy_lane *lane = phy_get_drvdata(phy);
-	int ret;
 
 	if (!mvebu_a3700_comphy_check_mode(lane->id, lane->mode,
 					   lane->submode)) {
@@ -1193,14 +1159,6 @@ static int mvebu_a3700_comphy_power_on(struct phy *phy)
 		return -EINVAL;
 	}
 
-	if (lane->needs_reset) {
-		ret = mvebu_a3700_comphy_reset(phy);
-		if (ret)
-			return ret;
-
-		lane->needs_reset = false;
-	}
-
 	switch (lane->mode) {
 	case PHY_MODE_USB_HOST_SS:
 		dev_dbg(lane->dev, "set lane %d to USB3 host mode\n", lane->id);
@@ -1224,38 +1182,28 @@ static int mvebu_a3700_comphy_power_off(struct phy *phy)
 {
 	struct mvebu_a3700_comphy_lane *lane = phy_get_drvdata(phy);
 
-	switch (lane->mode) {
-	case PHY_MODE_USB_HOST_SS:
-		/*
-		 * The USB3 MAC sets the USB3 PHY to low state, so we do not
-		 * need to power off USB3 PHY again.
-		 */
-		break;
-
-	case PHY_MODE_SATA:
-		mvebu_a3700_comphy_sata_power_off(lane);
-		break;
-
-	case PHY_MODE_ETHERNET:
+	switch (lane->id) {
+	case 0:
+		mvebu_a3700_comphy_usb3_power_off(lane);
 		mvebu_a3700_comphy_ethernet_power_off(lane);
-		break;
-
-	case PHY_MODE_PCIE:
+		return 0;
+	case 1:
 		mvebu_a3700_comphy_pcie_power_off(lane);
-		break;
-
+		mvebu_a3700_comphy_ethernet_power_off(lane);
+		return 0;
+	case 2:
+		mvebu_a3700_comphy_usb3_power_off(lane);
+		mvebu_a3700_comphy_sata_power_off(lane);
+		return 0;
 	default:
 		dev_err(lane->dev, "invalid COMPHY mode\n");
 		return -EINVAL;
 	}
-
-	return 0;
 }
 
 static const struct phy_ops mvebu_a3700_comphy_ops = {
 	.power_on	= mvebu_a3700_comphy_power_on,
 	.power_off	= mvebu_a3700_comphy_power_off,
-	.reset		= mvebu_a3700_comphy_reset,
 	.set_mode	= mvebu_a3700_comphy_set_mode,
 	.owner		= THIS_MODULE,
 };
@@ -1393,8 +1341,7 @@ static int mvebu_a3700_comphy_probe(struct platform_device *pdev)
 		 * To avoid relying on the bootloader/firmware configuration,
 		 * power off all comphys.
 		 */
-		mvebu_a3700_comphy_reset(phy);
-		lane->needs_reset = false;
+		mvebu_a3700_comphy_power_off(phy);
 	}
 
 	provider = devm_of_phy_provider_register(&pdev->dev,
-- 
2.37.3



