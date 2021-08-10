Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA93E5659
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhHJJIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41916 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238636AbhHJJIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:12 -0400
Date:   Tue, 10 Aug 2021 09:07:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586468;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6vQYKYvz+ivJTKNdHW5y+wHoqPJmrPa/BBtlmsOHYs=;
        b=VlJoZmovKGCnFMcDYWJoAkq9S5SYNhg+b2Sz5J+ysLYgktBTH2ULB4hU3AaGl23s5hSLam
        bfRlTT+jW6Y+8eZkNdXcedt3CyA7dDnvyIurRlM35PWaz/MmW0ItXmZJWbMeNY36MBP4Z0
        hBHsAvZOjDbleNQ4lmofc8vnMEBEAFKrzdcBk8pgoL4IFpy1/7PpP18rZrQGz9xRMfVVCa
        wZWOsfuy/yhOKbD9GPzuQB/7ZaFxQh7M5r1U+6FnY0RAaA4f0hHHL72ALvjekUlukxE6bL
        fMpxWepIMu7Nprt0WNmtY1Y9GP2hft/g3Qt+vdhb/TgLEIskanaNxamluFt17A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586468;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6vQYKYvz+ivJTKNdHW5y+wHoqPJmrPa/BBtlmsOHYs=;
        b=SqZ0AEU7hfRXrzwDGgQv3CZtIU9owB3zMF2fWwyhutZNgfEsXYfrRj+QbggnqsX8Yj1KZl
        ShWJ5gVMqE5q6fAA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] x86/msi: Force affinity setup before startup
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.886722080@linutronix.de>
References: <20210729222542.886722080@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646212.395.10672951353758752263.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     ff363f480e5997051dd1de949121ffda3b753741
Gitweb:        https://git.kernel.org/tip/ff363f480e5997051dd1de949121ffda3b753741
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:50 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:21 +02:00

x86/msi: Force affinity setup before startup

The X86 MSI mechanism cannot handle interrupt affinity changes safely after
startup other than from an interrupt handler, unless interrupt remapping is
enabled. The startup sequence in the generic interrupt code violates that
assumption.

Mark the irq chips with the new IRQCHIP_AFFINITY_PRE_STARTUP flag so that
the default interrupt setting happens before the interrupt is started up
for the first time.

While the interrupt remapping MSI chip does not require this, there is no
point in treating it differently as this might spare an interrupt to a CPU
which is not in the default affinity mask.

For the non-remapping case go to the direct write path when the interrupt
is not yet started similar to the not yet activated case.

Fixes: 18404756765c ("genirq: Expose default irq affinity mask (take 3)")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.886722080@linutronix.de


---
 arch/x86/kernel/apic/msi.c | 11 ++++++++---
 arch/x86/kernel/hpet.c     |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 44ebe25..dbacb9e 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -58,11 +58,13 @@ msi_set_affinity(struct irq_data *irqd, const struct cpumask *mask, bool force)
 	 *   The quirk bit is not set in this case.
 	 * - The new vector is the same as the old vector
 	 * - The old vector is MANAGED_IRQ_SHUTDOWN_VECTOR (interrupt starts up)
+	 * - The interrupt is not yet started up
 	 * - The new destination CPU is the same as the old destination CPU
 	 */
 	if (!irqd_msi_nomask_quirk(irqd) ||
 	    cfg->vector == old_cfg.vector ||
 	    old_cfg.vector == MANAGED_IRQ_SHUTDOWN_VECTOR ||
+	    !irqd_is_started(irqd) ||
 	    cfg->dest_apicid == old_cfg.dest_apicid) {
 		irq_msi_update_msg(irqd, cfg);
 		return ret;
@@ -150,7 +152,8 @@ static struct irq_chip pci_msi_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_affinity	= msi_set_affinity,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
@@ -219,7 +222,8 @@ static struct irq_chip pci_msi_ir_controller = {
 	.irq_mask		= pci_msi_mask_irq,
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct msi_domain_info pci_msi_ir_domain_info = {
@@ -273,7 +277,8 @@ static struct irq_chip dmar_msi_controller = {
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= dmar_msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static int dmar_msi_init(struct irq_domain *domain,
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 08651a4..42fc41d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -508,7 +508,7 @@ static struct irq_chip hpet_msi_controller __ro_after_init = {
 	.irq_set_affinity = msi_domain_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_write_msi_msg = hpet_msi_write_msg,
-	.flags = IRQCHIP_SKIP_SET_WAKE,
+	.flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static int hpet_msi_init(struct irq_domain *domain,
