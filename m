Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150B3540BE1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiFGScP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351351AbiFGS3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E1717A8AC;
        Tue,  7 Jun 2022 10:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF38B80B66;
        Tue,  7 Jun 2022 17:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8454C3411F;
        Tue,  7 Jun 2022 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624528;
        bh=NdoOI/mdof+A4Uy4fR9Q85uef2kWgrggo63N4r2XOrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r39StodENTXD35iy2E6BGty78H2Rhud9HR2nG9vm5aaBvf1+unVowt4OIFgEpB/1c
         mvsd11uLKh0ZmpxuwuAs0HwqOicsnnutN2CfsNj9aGrXVcpt4AMmBQpDdDSl9KZq2h
         no8gwujAhiuaLFN6uF16NkdI8fhNXhwqy/u2jQpW4lTp6tmV7ugD07/a20DFGI5XjE
         PklRz51K0XzVT3mwM2OLR2Nzu7i/yhSLQE8lgsOdAIzOpEpaKY6BEsOJZwb52rJZg7
         5qSsUZozpqc1dMW2MNie1Q27Sz1xcMWDXbWe3XWaKHZwsJhv5EvS8pt+c+lH3/xHWW
         xov8ERjYIU8dA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Cyril Brulebois <kibi@debian.org>,
        Sasha Levin <sashal@kernel.org>, nsaenz@kernel.org,
        jim2101024@gmail.com, f.fainelli@gmail.com, lpieralisi@kernel.org,
        p.zabel@pengutronix.de, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 53/60] Revert "PCI: brcmstb: Do not turn off WOL regulators on suspend"
Date:   Tue,  7 Jun 2022 13:52:50 -0400
Message-Id: <20220607175259.478835-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 7894025c783ca36394d3afe49c8cfb4c830b82fe ]

This reverts commit 11ed8b8624b8085f706864b4addcd304b1e4fc38.

This is part of a revert of the following commits:

  11ed8b8624b8 ("PCI: brcmstb: Do not turn off WOL regulators on suspend")
  93e41f3fca3d ("PCI: brcmstb: Add control of subdevice voltage regulators")
  67211aadcb4b ("PCI: brcmstb: Add mechanism to turn on subdev regulators")
  830aa6f29f07 ("PCI: brcmstb: Split brcm_pcie_setup() into two funcs")

Cyril reported that 830aa6f29f07 ("PCI: brcmstb: Split brcm_pcie_setup()
into two funcs"), which appeared in v5.17-rc1, broke booting on the
Raspberry Pi Compute Module 4.  Apparently 830aa6f29f07 panics with an
Asynchronous SError Interrupt, and after further commits here is a black
screen on HDMI and no output on the serial console.

This does not seem to affect the Raspberry Pi 4 B.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215925
Link: https://lore.kernel.org/r/20220511201856.808690-2-helgaas@kernel.org
Reported-by: Cyril Brulebois <kibi@debian.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 53 +++++----------------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 375c0c40bbf8..3edd63735948 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -333,7 +333,6 @@ struct brcm_pcie {
 	void			(*bridge_sw_init_set)(struct brcm_pcie *pcie, u32 val);
 	bool			refusal_mode;
 	struct subdev_regulators *sr;
-	bool			ep_wakeup_capable;
 };
 
 static inline bool is_bmips(const struct brcm_pcie *pcie)
@@ -1351,21 +1350,9 @@ static void brcm_pcie_turn_off(struct brcm_pcie *pcie)
 	pcie->bridge_sw_init_set(pcie, 1);
 }
 
-static int pci_dev_may_wakeup(struct pci_dev *dev, void *data)
-{
-	bool *ret = data;
-
-	if (device_may_wakeup(&dev->dev)) {
-		*ret = true;
-		dev_info(&dev->dev, "disable cancelled for wake-up device\n");
-	}
-	return (int) *ret;
-}
-
 static int brcm_pcie_suspend(struct device *dev)
 {
 	struct brcm_pcie *pcie = dev_get_drvdata(dev);
-	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	int ret;
 
 	brcm_pcie_turn_off(pcie);
@@ -1384,22 +1371,11 @@ static int brcm_pcie_suspend(struct device *dev)
 	}
 
 	if (pcie->sr) {
-		/*
-		 * Now turn off the regulators, but if at least one
-		 * downstream device is enabled as a wake-up source, do not
-		 * turn off regulators.
-		 */
-		pcie->ep_wakeup_capable = false;
-		pci_walk_bus(bridge->bus, pci_dev_may_wakeup,
-			     &pcie->ep_wakeup_capable);
-		if (!pcie->ep_wakeup_capable) {
-			ret = regulator_bulk_disable(pcie->sr->num_supplies,
-						     pcie->sr->supplies);
-			if (ret) {
-				dev_err(dev, "Could not turn off regulators\n");
-				reset_control_reset(pcie->rescal);
-				return ret;
-			}
+		ret = regulator_bulk_disable(pcie->sr->num_supplies, pcie->sr->supplies);
+		if (ret) {
+			dev_err(dev, "Could not turn off regulators\n");
+			reset_control_reset(pcie->rescal);
+			return ret;
 		}
 	}
 	clk_disable_unprepare(pcie->clk);
@@ -1420,21 +1396,10 @@ static int brcm_pcie_resume(struct device *dev)
 		return ret;
 
 	if (pcie->sr) {
-		if (pcie->ep_wakeup_capable) {
-			/*
-			 * We are resuming from a suspend.  In the suspend we
-			 * did not disable the power supplies, so there is
-			 * no need to enable them (and falsely increase their
-			 * usage count).
-			 */
-			pcie->ep_wakeup_capable = false;
-		} else {
-			ret = regulator_bulk_enable(pcie->sr->num_supplies,
-						    pcie->sr->supplies);
-			if (ret) {
-				dev_err(dev, "Could not turn on regulators\n");
-				goto err_disable_clk;
-			}
+		ret = regulator_bulk_enable(pcie->sr->num_supplies, pcie->sr->supplies);
+		if (ret) {
+			dev_err(dev, "Could not turn on regulators\n");
+			goto err_disable_clk;
 		}
 	}
 
-- 
2.35.1

