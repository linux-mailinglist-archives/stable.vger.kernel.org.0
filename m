Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF80461E0B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378630AbhK2Sb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48724 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378328AbhK2S3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38D90CE140D;
        Mon, 29 Nov 2021 18:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC9FC53FC7;
        Mon, 29 Nov 2021 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210380;
        bh=VasDqQH5SMU3/Sty/HHktn+lfZMz38cNQNP1ZjYlyq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abIrgRiIGlmMYmwxHCHQzKQi6IHBQrICNOQA6vGP0jxZjAcydvJrBifjT9KL6QgN2
         sS5hdU4m/Kf+UeGVOtPYLsuISmGzQIFKD8x+9rr1lfQgDsnZJgjgUsKevFjxOrtETG
         x6Gt/IwiVP+h7OKHro8IGyt2DydxJC8dXSekKtN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 40/92] PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge
Date:   Mon, 29 Nov 2021 19:18:09 +0100
Message-Id: <20211129181708.763171938@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 771153fc884f566a89af2d30033b7f3bc6e24e84 upstream.

>From very vague, ambiguous and incomplete information from Marvell we
deduced that the 32-bit Aardvark register at address 0x4
(PCIE_CORE_CMD_STATUS_REG), which is not documented for Root Complex mode
in the Functional Specification (only for Endpoint mode), controls two
16-bit PCIe registers: Command Register and Status Registers of PCIe Root
Port.

This means that bit 2 controls bus mastering and forwarding of memory and
I/O requests in the upstream direction. According to PCI specifications
bits [0:2] of Command Register, this should be by default disabled on
reset. So explicitly disable these bits at early setup of the Aardvark
driver.

Remove code which unconditionally enables all 3 bits and let kernel code
(via pci_set_master() function) to handle bus mastering of Root PCIe
Bridge via emulated PCI_COMMAND on emulated bridge.

Link: https://lore.kernel.org/r/20211028185659.20329-5-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # b2a56469d550 ("PCI: aardvark: Add FIXME comment for PCIE_CORE_CMD_STATUS_REG access")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   47 +++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 9 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -27,9 +27,6 @@
 /* PCIe core registers */
 #define PCIE_CORE_DEV_ID_REG					0x0
 #define PCIE_CORE_CMD_STATUS_REG				0x4
-#define     PCIE_CORE_CMD_IO_ACCESS_EN				BIT(0)
-#define     PCIE_CORE_CMD_MEM_ACCESS_EN				BIT(1)
-#define     PCIE_CORE_CMD_MEM_IO_REQ_EN				BIT(2)
 #define PCIE_CORE_DEV_REV_REG					0x8
 #define PCIE_CORE_PCIEXP_CAP					0xc0
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
@@ -505,6 +502,11 @@ static void advk_pcie_setup_hw(struct ad
 	reg = (PCI_VENDOR_ID_MARVELL << 16) | PCI_VENDOR_ID_MARVELL;
 	advk_writel(pcie, reg, VENDOR_ID_REG);
 
+	/* Disable Root Bridge I/O space, memory space and bus mastering */
+	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
+	reg &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
+	advk_writel(pcie, reg, PCIE_CORE_CMD_STATUS_REG);
+
 	/* Set Advanced Error Capabilities and Control PF0 register */
 	reg = PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX |
 		PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX_EN |
@@ -603,12 +605,6 @@ static void advk_pcie_setup_hw(struct ad
 		advk_pcie_disable_ob_win(pcie, i);
 
 	advk_pcie_train_link(pcie);
-
-	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
-	reg |= PCIE_CORE_CMD_MEM_ACCESS_EN |
-		PCIE_CORE_CMD_IO_ACCESS_EN |
-		PCIE_CORE_CMD_MEM_IO_REQ_EN;
-	advk_writel(pcie, reg, PCIE_CORE_CMD_STATUS_REG);
 }
 
 static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u32 *val)
@@ -737,6 +733,37 @@ static int advk_pcie_wait_pio(struct adv
 	return -ETIMEDOUT;
 }
 
+static pci_bridge_emul_read_status_t
+advk_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
+				    int reg, u32 *value)
+{
+	struct advk_pcie *pcie = bridge->data;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		*value = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
+		return PCI_BRIDGE_EMUL_HANDLED;
+
+	default:
+		return PCI_BRIDGE_EMUL_NOT_HANDLED;
+	}
+}
+
+static void
+advk_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
+				     int reg, u32 old, u32 new, u32 mask)
+{
+	struct advk_pcie *pcie = bridge->data;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		advk_writel(pcie, new, PCIE_CORE_CMD_STATUS_REG);
+		break;
+
+	default:
+		break;
+	}
+}
 
 static pci_bridge_emul_read_status_t
 advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
@@ -838,6 +865,8 @@ advk_pci_bridge_emul_pcie_conf_write(str
 }
 
 static struct pci_bridge_emul_ops advk_pci_bridge_emul_ops = {
+	.read_base = advk_pci_bridge_emul_base_conf_read,
+	.write_base = advk_pci_bridge_emul_base_conf_write,
 	.read_pcie = advk_pci_bridge_emul_pcie_conf_read,
 	.write_pcie = advk_pci_bridge_emul_pcie_conf_write,
 };


