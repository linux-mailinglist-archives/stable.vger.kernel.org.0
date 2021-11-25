Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C649645D21B
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345649AbhKYAfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353037AbhKYAdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:33:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC9B5610CC;
        Thu, 25 Nov 2021 00:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637800011;
        bh=slCUGcqTUtYpaaz2MCpVynwuhiibi71wCibgyzxXNaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJvnCW3Qcdl4Pn7nVnLA0yjXerzydlfPXQG7BQjMXYemxSowToACHkZYGFQ3QT7cP
         omQvd4mX88d+fBMuV9cxXr+B5eicbUf6Li18HeVJBH8bEAe+Dw/zkh6sJ92fWRoxp6
         rMaS549OORHwXVMOea1cChWxBrwh7EQp3VJwPv/DOGftTH3wyk370Jg7bZnt4FCgn+
         kDF9ZlFICdUMb71Znc2mvMoX8LN+Fwn+AeQAl7uVFGx4wBK59dCZOFFsWk5qobF/9h
         x42d4TAiZazswW6Li0ntszT7PqIWDkRdC31IiE53HYM4jzf6GjOedjtlU8W6gjd40y
         zIwGdlLSxzesw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 18/22] PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge
Date:   Thu, 25 Nov 2021 01:26:12 +0100
Message-Id: <20211125002616.31363-19-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 771153fc884f566a89af2d30033b7f3bc6e24e84 upstream.

From very vague, ambiguous and incomplete information from Marvell we
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
---
 drivers/pci/controller/pci-aardvark.c | 47 ++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 5898e55426c4..2fe6b3aa8919 100644
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
@@ -505,6 +502,11 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -603,12 +605,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -737,6 +733,37 @@ static int advk_pcie_wait_pio(struct advk_pcie *pcie)
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
@@ -838,6 +865,8 @@ advk_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 }
 
 static struct pci_bridge_emul_ops advk_pci_bridge_emul_ops = {
+	.read_base = advk_pci_bridge_emul_base_conf_read,
+	.write_base = advk_pci_bridge_emul_base_conf_write,
 	.read_pcie = advk_pci_bridge_emul_pcie_conf_read,
 	.write_pcie = advk_pci_bridge_emul_pcie_conf_write,
 };
-- 
2.32.0

