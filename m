Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB98C1482AB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404094AbgAXL3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404113AbgAXL3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:52 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 096D820704;
        Fri, 24 Jan 2020 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865391;
        bh=DfmKTsA14Lz/UZZvlOnpT5dIOIhTL3C6AddBbWu8GnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5AYV8i8a34JE2HsaJfxzJIKouzbvGERQpxdBhlCi+N7kG1T7pF9lC/yaFXmWTrpd
         JxnuDOC4jcdBD2N5m7e2HqiMq2SFZ+BzS5BneAYz82Mc+a7pRyGDtZRuxgyINE4EjV
         mo38yqiUw6k93g7dSzP3j2ybvW4fBWtUGxP2SXZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lili Deng <v-lide@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 533/639] irqdomain: Add the missing assignment of domain->fwnode for named fwnode
Date:   Fri, 24 Jan 2020 10:31:43 +0100
Message-Id: <20200124093155.736363173@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 711419e504ebd68c8f03656616829c8ad7829389 ]

Recently device pass-through stops working for Linux VM running on Hyper-V.

git-bisect shows the regression is caused by the recent commit
467a3bb97432 ("PCI: hv: Allocate a named fwnode ..."), but the root cause
is that the commit d59f6617eef0 forgets to set the domain->fwnode for
IRQCHIP_FWNODE_NAMED*, and as a result:

1. The domain->fwnode remains to be NULL.

2. irq_find_matching_fwspec() returns NULL since "h->fwnode == fwnode" is
false, and pci_set_bus_msi_domain() sets the Hyper-V PCI root bus's
msi_domain to NULL.

3. When the device is added onto the root bus, the device's dev->msi_domain
is set to NULL in pci_set_msi_domain().

4. When a device driver tries to enable MSI-X, pci_msi_setup_msi_irqs()
calls arch_setup_msi_irqs(), which uses the native MSI chip (i.e.
arch/x86/kernel/apic/msi.c: pci_msi_controller) to set up the irqs, but
actually pci_msi_setup_msi_irqs() is supposed to call
msi_domain_alloc_irqs() with the hbus->irq_domain, which is created in
hv_pcie_init_irq_domain() and is associated with the Hyper-V chip
hv_msi_irq_chip. Consequently, the irq line is not properly set up, and
the device driver can not receive any interrupt.

Fixes: d59f6617eef0 ("genirq: Allow fwnode to carry name information only")
Fixes: 467a3bb97432 ("PCI: hv: Allocate a named fwnode instead of an address-based one")
Reported-by: Lili Deng <v-lide@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/PU1P153MB01694D9AF625AC335C600C5FBFBE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0b90be3607249..6e8520a81dd86 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -148,6 +148,7 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, int size,
 		switch (fwid->type) {
 		case IRQCHIP_FWNODE_NAMED:
 		case IRQCHIP_FWNODE_NAMED_ID:
+			domain->fwnode = fwnode;
 			domain->name = kstrdup(fwid->name, GFP_KERNEL);
 			if (!domain->name) {
 				kfree(domain);
-- 
2.20.1



