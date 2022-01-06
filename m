Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8104863C1
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 12:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbiAFLdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 06:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238526AbiAFLdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 06:33:11 -0500
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Jan 2022 03:33:11 PST
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 307D4C061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 03:33:11 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 4884E92009E; Thu,  6 Jan 2022 12:24:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 44B9092009B;
        Thu,  6 Jan 2022 11:24:16 +0000 (GMT)
Date:   Thu, 6 Jan 2022 11:24:16 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nikolai Zhubr <zhubr.2@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
cc:     Arnd Bergmann <arnd@kernel.org>,
        Michal Necasek <mnecasek@yahoo.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3 3/4] x86/PCI: Fix ALi M1487 (IBC) PIRQ router link value
 interpretation
In-Reply-To: <alpine.DEB.2.21.2201021821480.56863@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2201022131050.56863@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2201021821480.56863@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix an issue with commit 1ce849c75534 ("x86/PCI: Add support for the ALi 
M1487 (IBC) PIRQ router") and correct ALi M1487 (IBC) PIRQ router link 
value (`pirq' cookie) interpretation according to findings in the BIOS.

Credit to Nikolai Zhubr for the detective work as to the bit layout.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: Nikolai Zhubr <zhubr.2@gmail.com>
Fixes: 1ce849c75534 ("x86/PCI: Add support for the ALi M1487 (IBC) PIRQ router")
Cc: stable@vger.kernel.org # v5.15+
---
New change in v3.
---
 arch/x86/pci/irq.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

linux-x86-pirq-router-finali-link.diff
Index: linux-macro/arch/x86/pci/irq.c
===================================================================
--- linux-macro.orig/arch/x86/pci/irq.c
+++ linux-macro/arch/x86/pci/irq.c
@@ -325,6 +325,15 @@ static void write_pc_conf_nybble(u8 base
 	pc_conf_set(reg, x);
 }
 
+/*
+ * FinALi pirq rules are as follows:
+ *
+ * - bit 0 selects between INTx Routing Table Mapping Registers,
+ *
+ * - bit 3 selects the nibble within the INTx Routing Table Mapping Register,
+ *
+ * - bits 7:4 map to bits 3:0 of the PCI INTx Sensitivity Register.
+ */
 static int pirq_finali_get(struct pci_dev *router, struct pci_dev *dev,
 			   int pirq)
 {
@@ -332,11 +341,13 @@ static int pirq_finali_get(struct pci_de
 		0, 9, 3, 10, 4, 5, 7, 6, 0, 11, 0, 12, 0, 14, 0, 15
 	};
 	unsigned long flags;
+	u8 index;
 	u8 x;
 
+	index = (pirq & 1) << 1 | (pirq & 8) >> 3;
 	raw_spin_lock_irqsave(&pc_conf_lock, flags);
 	pc_conf_set(PC_CONF_FINALI_LOCK, PC_CONF_FINALI_LOCK_KEY);
-	x = irqmap[read_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, pirq - 1)];
+	x = irqmap[read_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, index)];
 	pc_conf_set(PC_CONF_FINALI_LOCK, 0);
 	raw_spin_unlock_irqrestore(&pc_conf_lock, flags);
 	return x;
@@ -350,13 +361,15 @@ static int pirq_finali_set(struct pci_de
 	};
 	u8 val = irqmap[irq];
 	unsigned long flags;
+	u8 index;
 
 	if (!val)
 		return 0;
 
+	index = (pirq & 1) << 1 | (pirq & 8) >> 3;
 	raw_spin_lock_irqsave(&pc_conf_lock, flags);
 	pc_conf_set(PC_CONF_FINALI_LOCK, PC_CONF_FINALI_LOCK_KEY);
-	write_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, pirq - 1, val);
+	write_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, index, val);
 	pc_conf_set(PC_CONF_FINALI_LOCK, 0);
 	raw_spin_unlock_irqrestore(&pc_conf_lock, flags);
 	return 1;
@@ -365,7 +378,7 @@ static int pirq_finali_set(struct pci_de
 static int pirq_finali_lvl(struct pci_dev *router, struct pci_dev *dev,
 			   int pirq, int irq)
 {
-	u8 mask = ~(1u << (pirq - 1));
+	u8 mask = ~((pirq & 0xf0u) >> 4);
 	unsigned long flags;
 	u8 trig;
 
