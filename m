Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA414D92B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFTR6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfFTR6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:58:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9AF208CA;
        Thu, 20 Jun 2019 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053528;
        bh=fN+mNrmLgtHQROZH8aqQZFI7JhULnm8CryM/SGFakXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qatGdQmr+NQO8dcddAepiTJrgawstCV63feIsTAL68XXL6fVVq1x3pPu0m30MasHc
         B/U5EFrkT6mxSjhWuHtB7m7KMhkohDArm96tG4A/1noonybTPn3S1l7ksNswS2Ty9j
         bB285bIw/7J9cajHOc7AetanYhjUJ87foRvz4HM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/84] x86/PCI: Fix PCI IRQ routing table memory leak
Date:   Thu, 20 Jun 2019 19:56:17 +0200
Message-Id: <20190620174340.620380342@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
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
index 9bd115484745..5f0e596b0519 100644
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



