Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB13431D87
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfFAN3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbfFAN0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C09B7273B2;
        Sat,  1 Jun 2019 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395612;
        bh=jh4k3ff9Qzzy6TgrwDRGZoaobI4tCQlVDN3izfiOQP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajfrn+q0U2NzLeMdvsTK+8DXY5+2NFnlFQ5vhtCVh1l269HgTJ/lk0O7JVovrmbwK
         VVRmFYR+yPPb3yQWpACPyTZOJLtGg6X9vx2r+QKV+a6obRVwdDCyqVWNBttV6th6qW
         fKH6q4dmkgHp8OK5wB6OiALIXlkRqULUoP++Dkfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wang6495@umn.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 29/56] x86/PCI: Fix PCI IRQ routing table memory leak
Date:   Sat,  1 Jun 2019 09:25:33 -0400
Message-Id: <20190601132600.27427-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

[ Upstream commit ea094d53580f40c2124cef3d072b73b2425e7bfd ]

In pcibios_irq_init(), the PCI IRQ routing table 'pirq_table' is first
found through pirq_find_routing_table().  If the table is not found and
CONFIG_PCI_BIOS is defined, the table is then allocated in
pcibios_get_irq_routing_table() using kmalloc().  Later, if the I/O APIC is
used, this table is actually not used.  In that case, the allocated table
is not freed, which is a memory leak.

Free the allocated table if it is not used.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
[bhelgaas: added Ingo's reviewed-by, since the only change since v1 was to
use the irq_routing_table local variable name he suggested]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/irq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 9bd1154847457..5f0e596b0519b 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1117,6 +1117,8 @@ static struct dmi_system_id __initdata pciirq_dmi_table[] = {
 
 void __init pcibios_irq_init(void)
 {
+	struct irq_routing_table *rtable = NULL;
+
 	DBG(KERN_DEBUG "PCI: IRQ init\n");
 
 	if (raw_pci_ops == NULL)
@@ -1127,8 +1129,10 @@ void __init pcibios_irq_init(void)
 	pirq_table = pirq_find_routing_table();
 
 #ifdef CONFIG_PCI_BIOS
-	if (!pirq_table && (pci_probe & PCI_BIOS_IRQ_SCAN))
+	if (!pirq_table && (pci_probe & PCI_BIOS_IRQ_SCAN)) {
 		pirq_table = pcibios_get_irq_routing_table();
+		rtable = pirq_table;
+	}
 #endif
 	if (pirq_table) {
 		pirq_peer_trick();
@@ -1143,8 +1147,10 @@ void __init pcibios_irq_init(void)
 		 * If we're using the I/O APIC, avoid using the PCI IRQ
 		 * routing table
 		 */
-		if (io_apic_assign_pci_irqs)
+		if (io_apic_assign_pci_irqs) {
+			kfree(rtable);
 			pirq_table = NULL;
+		}
 	}
 
 	x86_init.pci.fixup_irqs();
-- 
2.20.1

