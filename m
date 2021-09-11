Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908940773D
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbhIKNPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236550AbhIKNON (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B43A61245;
        Sat, 11 Sep 2021 13:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365969;
        bh=2++X2B/yiaUbM2dzTHy03CmMwNl4sfW4HXCcQwfTfNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH5SlNWD0+OpDU+aPhDQ/BzG1BFH/QMvQy1o8EqyP6K/qhsmEhti2QBm8DXZpvUxr
         ur5CotOdF6VYNWHE2hXYbzvknQ62mW2Gvel8PFyZaOECINyq2WA4TlSHUaiRxLocph
         Wg50NXrhfTJs28UsGqa4WShut7LNh2VLbkWvueSPu7QvkJdNXrxLCv9ZSTdwuH+w2d
         CzWUfyyzsPS7HOYYgSXbNNFP+rnOTiwPeJLQzd5HhtXkPFnr1mL+qUb4G6qhpwUaRT
         asvSd7S1y2gppM8H4GgCqguRTX0ZJnY2lCiaOp46wx1lKO+lrrvnHt/ohgd36+zwGf
         llK6mm88KEpJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa@the-dreams.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-renesas-soc@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 11/29] PCI: rcar: Add L1 link state fix into data abort hook
Date:   Sat, 11 Sep 2021 09:12:15 -0400
Message-Id: <20210911131233.284800-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marek.vasut+renesas@gmail.com>

[ Upstream commit a115b1bd3af0c2963e72f6e47143724c59251be6 ]

When the link is in L1, hardware should return it to L0
automatically whenever a transaction targets a component on the
other end of the link (PCIe r5.0, sec 5.2).

The R-Car PCIe controller doesn't handle this transition correctly.
If the link is not in L0, an MMIO transaction targeting a downstream
device fails, and the controller reports an ARM imprecise external
abort.

Work around this by hooking the abort handler so the driver can
detect this situation and help the hardware complete the link state
transition.

When the R-Car controller receives a PM_ENTER_L1 DLLP from the
downstream component, it sets PMEL1RX bit in PMSR register, but then
the controller enters some sort of in-between state.  A subsequent
MMIO transaction will fail, resulting in the external abort.  The
abort handler detects this condition and completes the link state
transition by setting the L1IATN bit in PMCTLR and waiting for the
link state transition to complete.

Link: https://lore.kernel.org/r/20210815181650.132579-1-marek.vasut@gmail.com
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 86 +++++++++++++++++++++++++
 drivers/pci/controller/pcie-rcar.h      |  7 ++
 2 files changed, 93 insertions(+)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index 765cf2b45e24..11fcaa54c169 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -13,12 +13,14 @@
 
 #include <linux/bitops.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/iopoll.h>
 #include <linux/msi.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -41,6 +43,21 @@ struct rcar_msi {
 	int irq2;
 };
 
+#ifdef CONFIG_ARM
+/*
+ * Here we keep a static copy of the remapped PCIe controller address.
+ * This is only used on aarch32 systems, all of which have one single
+ * PCIe controller, to provide quick access to the PCIe controller in
+ * the L1 link state fixup function, called from the ARM fault handler.
+ */
+static void __iomem *pcie_base;
+/*
+ * Static copy of bus clock pointer, so we can check whether the clock
+ * is enabled or not.
+ */
+static struct clk *pcie_bus_clk;
+#endif
+
 /* Structure representing the PCIe interface */
 struct rcar_pcie_host {
 	struct rcar_pcie	pcie;
@@ -776,6 +793,12 @@ static int rcar_pcie_get_resources(struct rcar_pcie_host *host)
 	}
 	host->msi.irq2 = i;
 
+#ifdef CONFIG_ARM
+	/* Cache static copy for L1 link state fixup hook on aarch32 */
+	pcie_base = pcie->base;
+	pcie_bus_clk = host->bus_clk;
+#endif
+
 	return 0;
 
 err_irq2:
@@ -1031,4 +1054,67 @@ static struct platform_driver rcar_pcie_driver = {
 	},
 	.probe = rcar_pcie_probe,
 };
+
+#ifdef CONFIG_ARM
+static DEFINE_SPINLOCK(pmsr_lock);
+static int rcar_pcie_aarch32_abort_handler(unsigned long addr,
+		unsigned int fsr, struct pt_regs *regs)
+{
+	unsigned long flags;
+	u32 pmsr, val;
+	int ret = 0;
+
+	spin_lock_irqsave(&pmsr_lock, flags);
+
+	if (!pcie_base || !__clk_is_enabled(pcie_bus_clk)) {
+		ret = 1;
+		goto unlock_exit;
+	}
+
+	pmsr = readl(pcie_base + PMSR);
+
+	/*
+	 * Test if the PCIe controller received PM_ENTER_L1 DLLP and
+	 * the PCIe controller is not in L1 link state. If true, apply
+	 * fix, which will put the controller into L1 link state, from
+	 * which it can return to L0s/L0 on its own.
+	 */
+	if ((pmsr & PMEL1RX) && ((pmsr & PMSTATE) != PMSTATE_L1)) {
+		writel(L1IATN, pcie_base + PMCTLR);
+		ret = readl_poll_timeout_atomic(pcie_base + PMSR, val,
+						val & L1FAEG, 10, 1000);
+		WARN(ret, "Timeout waiting for L1 link state, ret=%d\n", ret);
+		writel(L1FAEG | PMEL1RX, pcie_base + PMSR);
+	}
+
+unlock_exit:
+	spin_unlock_irqrestore(&pmsr_lock, flags);
+	return ret;
+}
+
+static const struct of_device_id rcar_pcie_abort_handler_of_match[] __initconst = {
+	{ .compatible = "renesas,pcie-r8a7779" },
+	{ .compatible = "renesas,pcie-r8a7790" },
+	{ .compatible = "renesas,pcie-r8a7791" },
+	{ .compatible = "renesas,pcie-rcar-gen2" },
+	{},
+};
+
+static int __init rcar_pcie_init(void)
+{
+	if (of_find_matching_node(NULL, rcar_pcie_abort_handler_of_match)) {
+#ifdef CONFIG_ARM_LPAE
+		hook_fault_code(17, rcar_pcie_aarch32_abort_handler, SIGBUS, 0,
+				"asynchronous external abort");
+#else
+		hook_fault_code(22, rcar_pcie_aarch32_abort_handler, SIGBUS, 0,
+				"imprecise external abort");
+#endif
+	}
+
+	return platform_driver_register(&rcar_pcie_driver);
+}
+device_initcall(rcar_pcie_init);
+#else
 builtin_platform_driver(rcar_pcie_driver);
+#endif
diff --git a/drivers/pci/controller/pcie-rcar.h b/drivers/pci/controller/pcie-rcar.h
index d4c698b5f821..9bb125db85c6 100644
--- a/drivers/pci/controller/pcie-rcar.h
+++ b/drivers/pci/controller/pcie-rcar.h
@@ -85,6 +85,13 @@
 #define  LTSMDIS		BIT(31)
 #define  MACCTLR_INIT_VAL	(LTSMDIS | MACCTLR_NFTS_MASK)
 #define PMSR			0x01105c
+#define  L1FAEG			BIT(31)
+#define  PMEL1RX		BIT(23)
+#define  PMSTATE		GENMASK(18, 16)
+#define  PMSTATE_L1		(3 << 16)
+#define PMCTLR			0x011060
+#define  L1IATN			BIT(31)
+
 #define MACS2R			0x011078
 #define MACCGSPSETR		0x011084
 #define  SPCNGRSN		BIT(31)
-- 
2.30.2

