Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B941E3FAA75
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhH2JbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 05:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234889AbhH2JbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 05:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4710D60E94;
        Sun, 29 Aug 2021 09:30:03 +0000 (UTC)
From:   Huacai Chen <chenhuacai@loongson.cn>
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: [PATCH] irqchip/loongson-pch-msi: Fix hwirq setting problem
Date:   Sun, 29 Aug 2021 17:29:33 +0800
Message-Id: <20210829092933.4061429-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The default msi_domain_ops_init() doesn't set hwirq for irq_data,
which causes the hwirq displayed in /proc/interrupts very strange.
We fix this by providing a custom msi_domain_ops_init().

Before this patch:

root@loongson-pc:~# cat /proc/interrupts
           CPU0       CPU1
 30:          0          0      PCH PIC  47  acpi
 42:      80020          0      LIOINTC  10  ttyS0
 44:          1          0      PCH PIC  49  ohci_hcd:usb3
 45:          0          0      PCH PIC  48  ehci_hcd:usb1
 46:          1          0      PCH PIC  51  ohci_hcd:usb4
 47:          0          0      PCH PIC  50  ehci_hcd:usb2
 54:          0          0      PCH PIC  16  ahci[0000:00:08.0]
 55:       4364          0      PCH PIC  17  ahci[0000:00:08.1]
 56:        103          0      PCH PIC  18  ahci[0000:00:08.2]
 57:          0          0     PCH PCI MSI 1048576  ahci[0000:02:00.0]
 58:          0          0     PCH PCI MSI 524288  xhci_hcd
 59:          0          0     PCH PCI MSI 524289  xhci_hcd
 60:          0          0     PCH PCI MSI 524290  xhci_hcd
 61:          0          0     PCH PCI MSI 524291  xhci_hcd
 62:          1          0     PCH PCI MSI 1572864  enp3s0f0
 63:          6        173     PCH PCI MSI 1572865  enp3s0f0-rx-0
 64:          6        151     PCH PCI MSI 1572866  enp3s0f0-rx-1
 65:          6        151     PCH PCI MSI 1572867  enp3s0f0-rx-2
 66:         20          0     PCH PCI MSI 1572868  enp3s0f0-tx-0
 67:         20          0     PCH PCI MSI 1572869  enp3s0f0-tx-1
 68:        170          0     PCH PCI MSI 1572870  enp3s0f0-tx-2

After this patch:

root@loongson-pc:~# cat /proc/interrupts
           CPU0       CPU1
 30:          0          0      PCH PIC  47  acpi
 42:      83960          0      LIOINTC  10  ttyS0
 44:          1          0      PCH PIC  49  ohci_hcd:usb3
 45:          0          0      PCH PIC  48  ehci_hcd:usb1
 46:          1          0      PCH PIC  51  ohci_hcd:usb4
 47:          0          0      PCH PIC  50  ehci_hcd:usb2
 54:          0          0      PCH PIC  16  ahci[0000:00:08.0]
 55:       6688         13      PCH PIC  17  ahci[0000:00:08.1]
 56:        113          2      PCH PIC  18  ahci[0000:00:08.2]
 57:          0          0     PCH PCI MSI  67  ahci[0000:02:00.0]
 58:          0          0     PCH PCI MSI  68  xhci_hcd
 59:          0          0     PCH PCI MSI  69  xhci_hcd
 60:          0          0     PCH PCI MSI  70  xhci_hcd
 61:          0          0     PCH PCI MSI  71  xhci_hcd
 62:          1          0     PCH PCI MSI  72  enp3s0f0
 63:         12          4     PCH PCI MSI  73  enp3s0f0-rx-0
 64:         12          4     PCH PCI MSI  74  enp3s0f0-rx-1
 65:         12          0     PCH PCI MSI  75  enp3s0f0-rx-2
 66:         16          0     PCH PCI MSI  76  enp3s0f0-tx-0
 67:         22          0     PCH PCI MSI  77  enp3s0f0-tx-1
 68:         12          0     PCH PCI MSI  78  enp3s0f0-tx-2

Fixes: 632dcc2c75ef6de327 ("irqchip: Add Loongson PCH MSI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/irqchip/irq-loongson-pch-msi.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-msi.c b/drivers/irqchip/irq-loongson-pch-msi.c
index 32562b7e681b..c91a731abd99 100644
--- a/drivers/irqchip/irq-loongson-pch-msi.c
+++ b/drivers/irqchip/irq-loongson-pch-msi.c
@@ -81,10 +81,25 @@ static void pch_msi_compose_msi_msg(struct irq_data *data,
 	msg->data = data->hwirq;
 }
 
+static int msi_domain_ops_init(struct irq_domain *domain,
+				struct msi_domain_info *info,
+				unsigned int virq, irq_hw_number_t hwirq,
+				msi_alloc_info_t *arg)
+{
+	irq_domain_set_hwirq_and_chip(domain, virq, arg->hwirq, info->chip,
+					info->chip_data);
+	return 0;
+}
+
+static struct msi_domain_ops pch_msi_domain_ops = {
+	.msi_init	= msi_domain_ops_init,
+};
+
 static struct msi_domain_info pch_msi_domain_info = {
 	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
 		  MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
 	.chip	= &pch_msi_irq_chip,
+	.ops	= &pch_msi_domain_ops,
 };
 
 static struct irq_chip middle_irq_chip = {
@@ -112,8 +127,9 @@ static int pch_msi_middle_domain_alloc(struct irq_domain *domain,
 					   unsigned int virq,
 					   unsigned int nr_irqs, void *args)
 {
-	struct pch_msi_data *priv = domain->host_data;
 	int hwirq, err, i;
+	struct pch_msi_data *priv = domain->host_data;
+	msi_alloc_info_t *info = (msi_alloc_info_t *)args;
 
 	hwirq = pch_msi_allocate_hwirq(priv, nr_irqs);
 	if (hwirq < 0)
@@ -127,6 +143,7 @@ static int pch_msi_middle_domain_alloc(struct irq_domain *domain,
 		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
 					      &middle_irq_chip, priv);
 	}
+	info->hwirq = hwirq;
 
 	return 0;
 
-- 
2.27.0

