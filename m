Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135CF5219FE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiEJNw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245088AbiEJNrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39812397BC;
        Tue, 10 May 2022 06:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48301618A0;
        Tue, 10 May 2022 13:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB56C385C6;
        Tue, 10 May 2022 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189711;
        bh=5rAlW1wYW5d6FR1f1sFjXnRlxQn9Iy+A/ftvj77vTrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2eEGFFv0uwSNfvA05xG+qQXWYbfL3TrnFjxh3g3mxJwnv+vRIUkppC/c27ivv+ZE
         NGktmsXLZOh3Dtz0zYpuK5+PWl5ZRYBiI9eGxFBpoaofIviOHAQ9xpIrD7mIrzKHXi
         psPFmkpkskLdagrYh+Pysp+uckW5ZB04v1J/8gQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 130/135] PCI: aardvark: Fix support for PME requester on emulated bridge
Date:   Tue, 10 May 2022 15:08:32 +0200
Message-Id: <20220510130744.126945323@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Roh�r <pali@kernel.org>

commit 273ddd86d67694e3639e3bfe337a96d8861798b8 upstream.

Enable aardvark PME interrupt unconditionally by unmasking it and read PME
requester ID to emulated bridge config space immediately after receiving
interrupt.

PME requester ID is stored in the PCIE_MSG_LOG_REG register, which contains
the last inbound message. So when new inbound message is received by HW
(including non-PM), the content in PCIE_MSG_LOG_REG register is replaced by
a new value.

PCIe specification mandates that subsequent PMEs are kept pending until the
PME Status Register bit is cleared by software by writing a 1b.

Support for masking/unmasking PME interrupt on emulated bridge via
PCI_EXP_RTCTL_PMEIE bit is now implemented only in emulated bridge config
space, to ensure that we do not miss any aardvark PME interrupt.

Reading of PCI_EXP_RTCAP and PCI_EXP_RTSTA registers is simplified as final
value is now always stored into emulated bridge config space by the
interrupt handler, so there is no need to implement support for these
registers in read_pcie callback.

Clearing of W1C bit PCI_EXP_RTSTA_PME is now also simplified as it is done
by pci-bridge-emul.c code for emulated bridge config space. So there is no
need to implement support for clearing this bit in write_pcie callback.

Link: https://lore.kernel.org/r/20220110015018.26359-18-kabel@kernel.org
Signed-off-by: Pali Roh�r <pali@kernel.org>
Signed-off-by: Marek Beh�n <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Beh�n <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   91 ++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 41 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -590,6 +590,11 @@ static void advk_pcie_setup_hw(struct ad
 	reg &= ~PCIE_ISR0_MSI_INT_PENDING;
 	advk_writel(pcie, reg, PCIE_ISR0_MASK_REG);
 
+	/* Unmask PME interrupt for processing of PME requester */
+	reg = advk_readl(pcie, PCIE_ISR0_MASK_REG);
+	reg &= ~PCIE_MSG_PM_PME_MASK;
+	advk_writel(pcie, reg, PCIE_ISR0_MASK_REG);
+
 	/* Enable summary interrupt for GIC SPI source */
 	reg = PCIE_IRQ_ALL_MASK & (~PCIE_IRQ_ENABLE_INTS_MASK);
 	advk_writel(pcie, reg, HOST_CTRL_INT_MASK_REG);
@@ -856,22 +861,11 @@ advk_pci_bridge_emul_pcie_conf_read(stru
 		*value = PCI_EXP_SLTSTA_PDS << 16;
 		return PCI_BRIDGE_EMUL_HANDLED;
 
-	case PCI_EXP_RTCTL: {
-		u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
-		*value = (val & PCIE_MSG_PM_PME_MASK) ? 0 : PCI_EXP_RTCTL_PMEIE;
-		*value |= le16_to_cpu(bridge->pcie_conf.rootctl) & PCI_EXP_RTCTL_CRSSVE;
-		*value |= PCI_EXP_RTCAP_CRSVIS << 16;
-		return PCI_BRIDGE_EMUL_HANDLED;
-	}
-
-	case PCI_EXP_RTSTA: {
-		u32 isr0 = advk_readl(pcie, PCIE_ISR0_REG);
-		u32 msglog = advk_readl(pcie, PCIE_MSG_LOG_REG);
-		*value = msglog >> 16;
-		if (isr0 & PCIE_MSG_PM_PME_MASK)
-			*value |= PCI_EXP_RTSTA_PME;
-		return PCI_BRIDGE_EMUL_HANDLED;
-	}
+	/*
+	 * PCI_EXP_RTCTL and PCI_EXP_RTSTA are also supported, but do not need
+	 * to be handled here, because their values are stored in emulated
+	 * config space buffer, and we read them from there when needed.
+	 */
 
 	case PCI_EXP_LNKCAP: {
 		u32 val = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
@@ -925,22 +919,19 @@ advk_pci_bridge_emul_pcie_conf_write(str
 			advk_pcie_wait_for_retrain(pcie);
 		break;
 
-	case PCI_EXP_RTCTL:
-		/* Only mask/unmask PME interrupt */
-		if (mask & PCI_EXP_RTCTL_PMEIE) {
-			u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
-			if (new & PCI_EXP_RTCTL_PMEIE)
-				val &= ~PCIE_MSG_PM_PME_MASK;
-			else
-				val |= PCIE_MSG_PM_PME_MASK;
-			advk_writel(pcie, val, PCIE_ISR0_MASK_REG);
-		}
+	case PCI_EXP_RTCTL: {
+		u16 rootctl = le16_to_cpu(bridge->pcie_conf.rootctl);
+		/* Only emulation of PMEIE and CRSSVE bits is provided */
+		rootctl &= PCI_EXP_RTCTL_PMEIE | PCI_EXP_RTCTL_CRSSVE;
+		bridge->pcie_conf.rootctl = cpu_to_le16(rootctl);
 		break;
+	}
 
-	case PCI_EXP_RTSTA:
-		if (new & PCI_EXP_RTSTA_PME)
-			advk_writel(pcie, PCIE_MSG_PM_PME_MASK, PCIE_ISR0_REG);
-		break;
+	/*
+	 * PCI_EXP_RTSTA is also supported, but does not need to be handled
+	 * here, because its value is stored in emulated config space buffer,
+	 * and we write it there when needed.
+	 */
 
 	case PCI_EXP_DEVCTL:
 	case PCI_EXP_DEVCTL2:
@@ -1445,6 +1436,32 @@ static void advk_pcie_remove_irq_domain(
 	irq_domain_remove(pcie->irq_domain);
 }
 
+static void advk_pcie_handle_pme(struct advk_pcie *pcie)
+{
+	u32 requester = advk_readl(pcie, PCIE_MSG_LOG_REG) >> 16;
+
+	advk_writel(pcie, PCIE_MSG_PM_PME_MASK, PCIE_ISR0_REG);
+
+	/*
+	 * PCIE_MSG_LOG_REG contains the last inbound message, so store
+	 * the requester ID only when PME was not asserted yet.
+	 * Also do not trigger PME interrupt when PME is still asserted.
+	 */
+	if (!(le32_to_cpu(pcie->bridge.pcie_conf.rootsta) & PCI_EXP_RTSTA_PME)) {
+		pcie->bridge.pcie_conf.rootsta = cpu_to_le32(requester | PCI_EXP_RTSTA_PME);
+
+		/*
+		 * Trigger PME interrupt only if PMEIE bit in Root Control is set.
+		 * Aardvark HW returns zero for PCI_EXP_FLAGS_IRQ, so use PCIe interrupt 0.
+		 */
+		if (!(le16_to_cpu(pcie->bridge.pcie_conf.rootctl) & PCI_EXP_RTCTL_PMEIE))
+			return;
+
+		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+			dev_err_ratelimited(&pcie->pdev->dev, "unhandled PME IRQ\n");
+	}
+}
+
 static void advk_pcie_handle_msi(struct advk_pcie *pcie)
 {
 	u32 msi_val, msi_mask, msi_status, msi_idx;
@@ -1480,17 +1497,9 @@ static void advk_pcie_handle_int(struct
 	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
 
-	/* Process PME interrupt */
-	if (isr0_status & PCIE_MSG_PM_PME_MASK) {
-		/*
-		 * Do not clear PME interrupt bit in ISR0, it is cleared by IRQ
-		 * receiver by writing to the PCI_EXP_RTSTA register of emulated
-		 * root bridge. Aardvark HW returns zero for PCI_EXP_FLAGS_IRQ,
-		 * so use PCIe interrupt 0.
-		 */
-		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
-			dev_err_ratelimited(&pcie->pdev->dev, "unhandled PME IRQ\n");
-	}
+	/* Process PME interrupt as the first one to do not miss PME requester id */
+	if (isr0_status & PCIE_MSG_PM_PME_MASK)
+		advk_pcie_handle_pme(pcie);
 
 	/* Process ERR interrupt */
 	if (isr0_status & PCIE_ISR0_ERR_MASK) {


