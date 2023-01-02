Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5236965B097
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjABL01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjABLZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:25:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFB16586
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A76BAB80D1B
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD24C433EF;
        Mon,  2 Jan 2023 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658672;
        bh=Cw70npNCrYgOUOKEX+03N24pA9AGSIUhXwgU3cP1C4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tk22deDrsZBuUJMCG/o2hJgJiXgcAahw3WOV1QKHfe7vgPwOzaYk9CFWxcjYuZdOb
         DBC1qO348tiNhOHien3O5S0Y2mfs5C1NRm3ppPfMKmUhs30tm3y9KOAOKFdcwZguAx
         kht38oyvBHUolj/LMm8PBTSpdxer1JeHP2zjQd5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andre Przywara <andre.przywara@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/71] phy: sun4i-usb: Introduce port2 SIDDQ quirk
Date:   Mon,  2 Jan 2023 12:21:51 +0100
Message-Id: <20230102110552.550178684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit b45c6d80325bec2b78c716629a518b6442d8bdc6 ]

At least the Allwinner H616 SoC requires a weird quirk to make most
USB PHYs work: Only port2 works out of the box, but all other ports
need some help from this port2 to work correctly: The CLK_BUS_PHY2 and
RST_USB_PHY2 clock and reset need to be enabled, and the SIDDQ bit in
the PMU PHY control register needs to be cleared. For this register to
be accessible, CLK_BUS_ECHI2 needs to be ungated. Don't ask ....

Instead of disguising this as some generic feature, treat it more like
a quirk (what it really is):
If the quirk bit is set, and we initialise a PHY other than PHY2, ungate
this one special clock, and clear the SIDDQ bit. We also pick the clock
and reset from PHY2 and enable them as well.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20221031111358.3387297-4-andre.przywara@arm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/allwinner/phy-sun4i-usb.c | 59 +++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
index 3a3831f6059a..e39f5ad62cc1 100644
--- a/drivers/phy/allwinner/phy-sun4i-usb.c
+++ b/drivers/phy/allwinner/phy-sun4i-usb.c
@@ -120,6 +120,7 @@ struct sun4i_usb_phy_cfg {
 	u8 phyctl_offset;
 	bool dedicated_clocks;
 	bool phy0_dual_route;
+	bool needs_phy2_siddq;
 	int missing_phys;
 };
 
@@ -289,6 +290,50 @@ static int sun4i_usb_phy_init(struct phy *_phy)
 		return ret;
 	}
 
+	/* Some PHYs on some SoCs need the help of PHY2 to work. */
+	if (data->cfg->needs_phy2_siddq && phy->index != 2) {
+		struct sun4i_usb_phy *phy2 = &data->phys[2];
+
+		ret = clk_prepare_enable(phy2->clk);
+		if (ret) {
+			reset_control_assert(phy->reset);
+			clk_disable_unprepare(phy->clk2);
+			clk_disable_unprepare(phy->clk);
+			return ret;
+		}
+
+		ret = reset_control_deassert(phy2->reset);
+		if (ret) {
+			clk_disable_unprepare(phy2->clk);
+			reset_control_assert(phy->reset);
+			clk_disable_unprepare(phy->clk2);
+			clk_disable_unprepare(phy->clk);
+			return ret;
+		}
+
+		/*
+		 * This extra clock is just needed to access the
+		 * REG_HCI_PHY_CTL PMU register for PHY2.
+		 */
+		ret = clk_prepare_enable(phy2->clk2);
+		if (ret) {
+			reset_control_assert(phy2->reset);
+			clk_disable_unprepare(phy2->clk);
+			reset_control_assert(phy->reset);
+			clk_disable_unprepare(phy->clk2);
+			clk_disable_unprepare(phy->clk);
+			return ret;
+		}
+
+		if (phy2->pmu && data->cfg->hci_phy_ctl_clear) {
+			val = readl(phy2->pmu + REG_HCI_PHY_CTL);
+			val &= ~data->cfg->hci_phy_ctl_clear;
+			writel(val, phy2->pmu + REG_HCI_PHY_CTL);
+		}
+
+		clk_disable_unprepare(phy->clk2);
+	}
+
 	if (phy->pmu && data->cfg->hci_phy_ctl_clear) {
 		val = readl(phy->pmu + REG_HCI_PHY_CTL);
 		val &= ~data->cfg->hci_phy_ctl_clear;
@@ -354,6 +399,13 @@ static int sun4i_usb_phy_exit(struct phy *_phy)
 		data->phy0_init = false;
 	}
 
+	if (data->cfg->needs_phy2_siddq && phy->index != 2) {
+		struct sun4i_usb_phy *phy2 = &data->phys[2];
+
+		clk_disable_unprepare(phy2->clk);
+		reset_control_assert(phy2->reset);
+	}
+
 	sun4i_usb_phy_passby(phy, 0);
 	reset_control_assert(phy->reset);
 	clk_disable_unprepare(phy->clk2);
@@ -785,6 +837,13 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 				dev_err(dev, "failed to get clock %s\n", name);
 				return PTR_ERR(phy->clk2);
 			}
+		} else {
+			snprintf(name, sizeof(name), "pmu%d_clk", i);
+			phy->clk2 = devm_clk_get_optional(dev, name);
+			if (IS_ERR(phy->clk2)) {
+				dev_err(dev, "failed to get clock %s\n", name);
+				return PTR_ERR(phy->clk2);
+			}
 		}
 
 		snprintf(name, sizeof(name), "usb%d_reset", i);
-- 
2.35.1



