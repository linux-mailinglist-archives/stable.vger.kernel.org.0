Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F523F6649
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbhHXRWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240253AbhHXRUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 797F761AFA;
        Tue, 24 Aug 2021 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824598;
        bh=dnNRjND0G3c79vzdwhji2NfxrtaspUgiFhDLTXxjlAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTED8w6q3ebRB+N7/j6JGItKBo9GN4SW+53vrBbOOPhHDSYr1AMZ89SGgrqYPbfMq
         9TILlhPg8fTgXnNvjus89oX32xor7GizfDA7V/LAB3ZzYOR07hjRWSdlJSF58SPFW5
         62RNblUEoNAkA+DtzGlt77GQrcWMUpUfomj7S+pJAOzZ0OfcOKKuOnUFlxJbZCFFbM
         kjPAPVu20c94LeWVztrHSb/trMD6Ts2dhHgXU8ZO9GIQmOsqIAdgTL6LIHzlh7heKU
         WgB7vdKvD1/Ayl6tVEul1mAKxFkYYYuQNClekRf35Hbq3MkEonuNj1NevsfBGCyjiL
         Vv/9VB+yO+lhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 27/84] x86/msi: Force affinity setup before startup
Date:   Tue, 24 Aug 2021 13:01:53 -0400
Message-Id: <20210824170250.710392-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 arch/x86/kernel/apic/msi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index fb26c956c442..ca17a3848834 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -89,11 +89,13 @@ msi_set_affinity(struct irq_data *irqd, const struct cpumask *mask, bool force)
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
@@ -181,7 +183,8 @@ static struct irq_chip pci_msi_controller = {
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.irq_set_affinity	= msi_set_affinity,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
@@ -282,7 +285,8 @@ static struct irq_chip pci_msi_ir_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct msi_domain_info pci_msi_ir_domain_info = {
@@ -325,7 +329,8 @@ static struct irq_chip dmar_msi_controller = {
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static irq_hw_number_t dmar_msi_get_hwirq(struct msi_domain_info *info,
@@ -423,7 +428,7 @@ static struct irq_chip hpet_msi_controller __ro_after_init = {
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg = irq_msi_compose_msg,
 	.irq_write_msi_msg = hpet_msi_write_msg,
-	.flags = IRQCHIP_SKIP_SET_WAKE,
+	.flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static irq_hw_number_t hpet_msi_get_hwirq(struct msi_domain_info *info,
-- 
2.30.2

