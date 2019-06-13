Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618F5442D4
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfFMQZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbfFMIg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:36:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A42C20851;
        Thu, 13 Jun 2019 08:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414988;
        bh=xvVqEAfwWGDdhKqM/GDR0cBONz4WcVgKfelHCundFQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Occ+thp4OTBqlzFMjp/VZ36ZTc7EpdTMXzZT0o0OjNR7O/T7az4/gHumjlQkjqmED
         GXla3hgSoN7n16Z2Idr9IY2SjIAyeLf6gItQ0EL51uo6JxMboeOXe9qNVW8sQJuYcR
         +CvZWP2sfkH5dkT4caDxezIM1mLB4H+feO8pX+Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/81] x86/PCI: Fix PCI IRQ routing table memory leak
Date:   Thu, 13 Jun 2019 10:33:29 +0200
Message-Id: <20190613075652.667501039@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
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
index 0452629148be..c77f565a04f2 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1118,6 +1118,8 @@ static const struct dmi_system_id pciirq_dmi_table[] __initconst = {
 
 void __init pcibios_irq_init(void)
 {
+	struct irq_routing_table *rtable = NULL;
+
 	DBG(KERN_DEBUG "PCI: IRQ init\n");
 
 	if (raw_pci_ops == NULL)
@@ -1128,8 +1130,10 @@ void __init pcibios_irq_init(void)
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
@@ -1144,8 +1148,10 @@ void __init pcibios_irq_init(void)
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



