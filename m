Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7785406A7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbiFGRhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347842AbiFGRfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB301109AB;
        Tue,  7 Jun 2022 10:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EAE8614AE;
        Tue,  7 Jun 2022 17:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649B5C385A5;
        Tue,  7 Jun 2022 17:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623116;
        bh=lnVIzLS/8oXyQGTC7yZ6FB72o8AH3PFI3K2kcM4Kszk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn8kahqCLkbPgRmgbmJq8yT4iAznZxksNVfsE135P/ugovFw6F+7iPXs/8SSwokZ2
         yiXzyVyXObNGRwxFt4rM7CNWkK7bKHGouswN01VgLhS/CoQAdYikqPhXyBNr3VsxT2
         diDkeiuvTGF0V5Z80YKndcNu3R6A3GY2h8e6Iz+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <hongxing.zhu@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/452] PCI: imx6: Fix PERST# start-up sequence
Date:   Tue,  7 Jun 2022 19:02:39 +0200
Message-Id: <20220607164917.558475881@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit a6809941c1f17f455db2cf4ca19c6d8c8746ec25 ]

According to the PCIe standard the PERST# signal (reset-gpio in
fsl,imx* compatible dts) should be kept asserted for at least 100 usec
before the PCIe refclock is stable, should be kept asserted for at
least 100 msec after the power rails are stable and the host should wait
at least 100 msec after it is de-asserted before accessing the
configuration space of any attached device.

>From PCIe CEM r2.0, sec 2.6.2

  T-PVPERL: Power stable to PERST# inactive - 100 msec
  T-PERST-CLK: REFCLK stable before PERST# inactive - 100 usec.

>From PCIe r5.0, sec 6.6.1

  With a Downstream Port that does not support Link speeds greater than
  5.0 GT/s, software must wait a minimum of 100 ms before sending a
  Configuration Request to the device immediately below that Port.

Failure to do so could prevent PCIe devices to be working correctly,
and this was experienced with real devices.

Move reset assert to imx6_pcie_assert_core_reset(), this way we ensure
that PERST# is asserted before enabling any clock, move de-assert to the
end of imx6_pcie_deassert_core_reset() after the clock is enabled and
deemed stable and add a new delay of 100 msec just afterward.

Link: https://lore.kernel.org/all/20220211152550.286821-1-francesco.dolcini@toradex.com
Link: https://lore.kernel.org/r/20220404081509.94356-1-francesco.dolcini@toradex.com
Fixes: bb38919ec56e ("PCI: imx6: Add support for i.MX6 PCIe controller")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 5cf1ef12fb9b..ceb4815379cd 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -401,6 +401,11 @@ static void imx6_pcie_assert_core_reset(struct imx6_pcie *imx6_pcie)
 			dev_err(dev, "failed to disable vpcie regulator: %d\n",
 				ret);
 	}
+
+	/* Some boards don't have PCIe reset GPIO. */
+	if (gpio_is_valid(imx6_pcie->reset_gpio))
+		gpio_set_value_cansleep(imx6_pcie->reset_gpio,
+					imx6_pcie->gpio_active_high);
 }
 
 static unsigned int imx6_pcie_grp_offset(const struct imx6_pcie *imx6_pcie)
@@ -523,15 +528,6 @@ static void imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 	/* allow the clocks to stabilize */
 	usleep_range(200, 500);
 
-	/* Some boards don't have PCIe reset GPIO. */
-	if (gpio_is_valid(imx6_pcie->reset_gpio)) {
-		gpio_set_value_cansleep(imx6_pcie->reset_gpio,
-					imx6_pcie->gpio_active_high);
-		msleep(100);
-		gpio_set_value_cansleep(imx6_pcie->reset_gpio,
-					!imx6_pcie->gpio_active_high);
-	}
-
 	switch (imx6_pcie->drvdata->variant) {
 	case IMX8MQ:
 		reset_control_deassert(imx6_pcie->pciephy_reset);
@@ -574,6 +570,15 @@ static void imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 		break;
 	}
 
+	/* Some boards don't have PCIe reset GPIO. */
+	if (gpio_is_valid(imx6_pcie->reset_gpio)) {
+		msleep(100);
+		gpio_set_value_cansleep(imx6_pcie->reset_gpio,
+					!imx6_pcie->gpio_active_high);
+		/* Wait for 100ms after PERST# deassertion (PCIe r5.0, 6.6.1) */
+		msleep(100);
+	}
+
 	return;
 
 err_ref_clk:
-- 
2.35.1



