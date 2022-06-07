Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45890540B15
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351269AbiFGSWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352787AbiFGSRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B6513CA15;
        Tue,  7 Jun 2022 10:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B646CB82377;
        Tue,  7 Jun 2022 17:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07015C36AFF;
        Tue,  7 Jun 2022 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624359;
        bh=VAG+3uL6h5kOCfu6AuzyUB7t+yIhbm19oEA/UYTLcX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbCR1SehUt5fD9gqWxiNNLUc4PMWw2Ev9RA4UNoUTHur4xkfF6SfFqdXYqnPgvthU
         cFTY15RPSus80M4c82oTgYMuHRc9wldPtiKzY5h1mCjwnX3/DSUXLvZX+Qc8fQ6FVG
         cgCpNYCXx8g2JvvgnFg2QeFGLV5hdoljDgpJgMu/g24pyibUlwlvtGIFaQIs4IVjqt
         YTND+lQ7gba4Sxnc5gL4mm1QiMaUc5Rbz7P6S16nVfgexupWICfOyznCSTRy4V5N/c
         E4f1Ejiupg/+MEsUBiPgRF+294ZK0PFAZUD6eI53AMPQkN/PBXQ+gdaeQrrSmzlJzE
         Icl4++TWDlSdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Cyril Brulebois <kibi@debian.org>,
        Sasha Levin <sashal@kernel.org>, nsaenz@kernel.org,
        jim2101024@gmail.com, f.fainelli@gmail.com, lpieralisi@kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 63/68] Revert "PCI: brcmstb: Split brcm_pcie_setup() into two funcs"
Date:   Tue,  7 Jun 2022 13:48:29 -0400
Message-Id: <20220607174846.477972-63-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
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

[ Upstream commit f4fd559de3434c44bed1d2912bd0c75cfa42898b ]

This reverts commit 830aa6f29f07a4e2f1a947dfa72b3ccddb46dd21.

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
Link: https://lore.kernel.org/r/20220511201856.808690-5-helgaas@kernel.org
Reported-by: Cyril Brulebois <kibi@debian.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 65 +++++++++++----------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 0e8346114a8d..e61058e13818 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -926,9 +926,16 @@ static inline int brcm_pcie_get_rc_bar2_size_and_offset(struct brcm_pcie *pcie,
 
 static int brcm_pcie_setup(struct brcm_pcie *pcie)
 {
+	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	u64 rc_bar2_offset, rc_bar2_size;
 	void __iomem *base = pcie->base;
-	int ret, memc;
+	struct device *dev = pcie->dev;
+	struct resource_entry *entry;
+	bool ssc_good = false;
+	struct resource *res;
+	int num_out_wins = 0;
+	u16 nlw, cls, lnksta;
+	int i, ret, memc;
 	u32 tmp, burst, aspm_support;
 
 	/* Reset the bridge */
@@ -1018,40 +1025,6 @@ static int brcm_pcie_setup(struct brcm_pcie *pcie)
 	if (pcie->gen)
 		brcm_pcie_set_gen(pcie, pcie->gen);
 
-	/* Don't advertise L0s capability if 'aspm-no-l0s' */
-	aspm_support = PCIE_LINK_STATE_L1;
-	if (!of_property_read_bool(pcie->np, "aspm-no-l0s"))
-		aspm_support |= PCIE_LINK_STATE_L0S;
-	tmp = readl(base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
-	u32p_replace_bits(&tmp, aspm_support,
-		PCIE_RC_CFG_PRIV1_LINK_CAPABILITY_ASPM_SUPPORT_MASK);
-	writel(tmp, base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
-
-	/*
-	 * For config space accesses on the RC, show the right class for
-	 * a PCIe-PCIe bridge (the default setting is to be EP mode).
-	 */
-	tmp = readl(base + PCIE_RC_CFG_PRIV1_ID_VAL3);
-	u32p_replace_bits(&tmp, 0x060400,
-			  PCIE_RC_CFG_PRIV1_ID_VAL3_CLASS_CODE_MASK);
-	writel(tmp, base + PCIE_RC_CFG_PRIV1_ID_VAL3);
-
-	return 0;
-}
-
-static int brcm_pcie_linkup(struct brcm_pcie *pcie)
-{
-	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
-	struct device *dev = pcie->dev;
-	void __iomem *base = pcie->base;
-	struct resource_entry *entry;
-	struct resource *res;
-	int num_out_wins = 0;
-	u16 nlw, cls, lnksta;
-	bool ssc_good = false;
-	u32 tmp;
-	int ret, i;
-
 	/* Unassert the fundamental reset */
 	pcie->perst_set(pcie, 0);
 
@@ -1102,6 +1075,24 @@ static int brcm_pcie_linkup(struct brcm_pcie *pcie)
 		num_out_wins++;
 	}
 
+	/* Don't advertise L0s capability if 'aspm-no-l0s' */
+	aspm_support = PCIE_LINK_STATE_L1;
+	if (!of_property_read_bool(pcie->np, "aspm-no-l0s"))
+		aspm_support |= PCIE_LINK_STATE_L0S;
+	tmp = readl(base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
+	u32p_replace_bits(&tmp, aspm_support,
+		PCIE_RC_CFG_PRIV1_LINK_CAPABILITY_ASPM_SUPPORT_MASK);
+	writel(tmp, base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
+
+	/*
+	 * For config space accesses on the RC, show the right class for
+	 * a PCIe-PCIe bridge (the default setting is to be EP mode).
+	 */
+	tmp = readl(base + PCIE_RC_CFG_PRIV1_ID_VAL3);
+	u32p_replace_bits(&tmp, 0x060400,
+			  PCIE_RC_CFG_PRIV1_ID_VAL3_CLASS_CODE_MASK);
+	writel(tmp, base + PCIE_RC_CFG_PRIV1_ID_VAL3);
+
 	if (pcie->ssc) {
 		ret = brcm_pcie_set_ssc(pcie);
 		if (ret == 0)
@@ -1290,10 +1281,6 @@ static int brcm_pcie_resume(struct device *dev)
 	if (ret)
 		goto err_reset;
 
-	ret = brcm_pcie_linkup(pcie);
-	if (ret)
-		goto err_reset;
-
 	if (pcie->msi)
 		brcm_msi_set_regs(pcie->msi);
 
-- 
2.35.1

