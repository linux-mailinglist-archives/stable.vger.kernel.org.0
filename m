Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF533ED4C9
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhHPNFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236843AbhHPNFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD0363299;
        Mon, 16 Aug 2021 13:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119083;
        bh=vLrWyTijUo8AlG6GAbEj/ams+44/0e2i7MmYFuuTmn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDc+8iwPWFHH1zpETBfyzdhqpcW4xI7na2+ZSZMXKaNKJXlRa2gYXAf5BKTn+EDQK
         NpGCKWyqNjcGC7rPJT6iN11U6jgFpUfS3a9DwJdyCDXmNs2Eam4MlRl6o1V0mgKnlU
         6gAxtEV1bg46QlH4SPHhlnR/p4DVv24Vt0Vq8PhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 44/62] x86/msi: Force affinity setup before startup
Date:   Mon, 16 Aug 2021 15:02:16 +0200
Message-Id: <20210816125429.712397581@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ff363f480e5997051dd1de949121ffda3b753741 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/msi.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -86,11 +86,13 @@ msi_set_affinity(struct irq_data *irqd,
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
@@ -178,7 +180,8 @@ static struct irq_chip pci_msi_controlle
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.irq_set_affinity	= msi_set_affinity,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
@@ -279,7 +282,8 @@ static struct irq_chip pci_msi_ir_contro
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct msi_domain_info pci_msi_ir_domain_info = {
@@ -322,7 +326,8 @@ static struct irq_chip dmar_msi_controll
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static irq_hw_number_t dmar_msi_get_hwirq(struct msi_domain_info *info,
@@ -420,7 +425,7 @@ static struct irq_chip hpet_msi_controll
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg = irq_msi_compose_msg,
 	.irq_write_msi_msg = hpet_msi_write_msg,
-	.flags = IRQCHIP_SKIP_SET_WAKE,
+	.flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static irq_hw_number_t hpet_msi_get_hwirq(struct msi_domain_info *info,


