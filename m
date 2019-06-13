Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40D943FA0
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfFMP66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731489AbfFMIuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0FAA20851;
        Thu, 13 Jun 2019 08:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415800;
        bh=76D3vaAouJvHGGAHeFdnU7ReK0evbpdCzSUXWh05FYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed9x4pwJzF9lSzdTHbJ3Li2XuCibqMiJna+QyI25fcY7IooGi/3fv+aUx09r+AZOj
         hBmO6DGNu70DWyarUC21v6RGRJiRWatg1VgpVSQd8ittNpSHxXVQvG5Yw04r2bD9c0
         E0rFHVkrK7YjZS/NoGkKvU3I3WoWPPl/iclEYB7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 092/155] x86/PCI: Fix PCI IRQ routing table memory leak
Date:   Thu, 13 Jun 2019 10:33:24 +0200
Message-Id: <20190613075658.239152949@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 52e55108404e..d3a73f9335e1 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1119,6 +1119,8 @@ static const struct dmi_system_id pciirq_dmi_table[] __initconst = {
 
 void __init pcibios_irq_init(void)
 {
+	struct irq_routing_table *rtable = NULL;
+
 	DBG(KERN_DEBUG "PCI: IRQ init\n");
 
 	if (raw_pci_ops == NULL)
@@ -1129,8 +1131,10 @@ void __init pcibios_irq_init(void)
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
@@ -1145,8 +1149,10 @@ void __init pcibios_irq_init(void)
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



