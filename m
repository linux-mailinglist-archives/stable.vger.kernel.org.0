Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8138548BA5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380371AbiFMN6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380925AbiFMNzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:55:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8D182179;
        Mon, 13 Jun 2022 04:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 003BE6130D;
        Mon, 13 Jun 2022 11:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0864CC34114;
        Mon, 13 Jun 2022 11:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120177;
        bh=NdoOI/mdof+A4Uy4fR9Q85uef2kWgrggo63N4r2XOrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1u0EsmT41ZerQqOsgwv6IUIzK9ZcVK/85BufU2jzzaZ+rbPI++lUqfuB4Niwye005
         +nb9SadDMNiYL/jCB5OX8QLnDtMf60DqfYWHhm9x9bup144afkmnpvtKLb7Dak19Gr
         04yHf0RhDNPSlYVJkkHGAIc5u6vtcILwbFph3Cow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyril Brulebois <kibi@debian.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 278/339] Revert "PCI: brcmstb: Do not turn off WOL regulators on suspend"
Date:   Mon, 13 Jun 2022 12:11:43 +0200
Message-Id: <20220613094935.069895635@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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



