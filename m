Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83ED323939
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 10:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhBXJLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 04:11:24 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58571 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234481AbhBXJJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 04:09:22 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UPRTyN0_1614157715;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UPRTyN0_1614157715)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Feb 2021 17:08:36 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Artie Ding <artie.ding@linux.alibaba.com>
Cc:     alikernel-developer@linux.alibaba.com,
        Jiang Liu <gerry@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Evan Green <evgreen@chromium.org>, stable@vger.kernel.org,
        Zelin Deng <zelin.deng@linux.alibaba.com>
Subject: [PATCH CK 4.19 1/1] x86/apic/msi: Plug non-maskable MSI affinity race
Date:   Wed, 24 Feb 2021 17:08:24 +0800
Message-Id: <20210224090824.39024-2-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 2.30.0.81.g72c4083ddf
In-Reply-To: <20210224090824.39024-1-zelin.deng@linux.alibaba.com>
References: <20210224090824.39024-1-zelin.deng@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

task #32972991

commit 6f1a4891a5928a5969c87fa5a584844c983ec823 upstream

Evan tracked down a subtle race between the update of the MSI message and
the device raising an interrupt internally on PCI devices which do not
support MSI masking. The update of the MSI message is non-atomic and
consists of either 2 or 3 sequential 32bit wide writes to the PCI config
space.

   - Write address low 32bits
   - Write address high 32bits (If supported by device)
   - Write data

When an interrupt is migrated then both address and data might change, so
the kernel attempts to mask the MSI interrupt first. But for MSI masking is
optional, so there exist devices which do not provide it. That means that
if the device raises an interrupt internally between the writes then a MSI
message is sent built from half updated state.

On x86 this can lead to spurious interrupts on the wrong interrupt
vector when the affinity setting changes both address and data. As a
consequence the device interrupt can be lost causing the device to
become stuck or malfunctioning.

Evan tried to handle that by disabling MSI accross an MSI message
update. That's not feasible because disabling MSI has issues on its own:

 If MSI is disabled the PCI device is routing an interrupt to the legacy
 INTx mechanism. The INTx delivery can be disabled, but the disablement is
 not working on all devices.

 Some devices lose interrupts when both MSI and INTx delivery are disabled.

Another way to solve this would be to enforce the allocation of the same
vector on all CPUs in the system for this kind of screwed devices. That
could be done, but it would bring back the vector space exhaustion problems
which got solved a few years ago.

Fortunately the high address (if supported by the device) is only relevant
when X2APIC is enabled which implies interrupt remapping. In the interrupt
remapping case the affinity setting is happening at the interrupt remapping
unit and the PCI MSI message is programmed only once when the PCI device is
initialized.

That makes it possible to solve it with a two step update:

  1) Target the MSI msg to the new vector on the current target CPU

  2) Target the MSI msg to the new vector on the new target CPU

In both cases writing the MSI message is only changing a single 32bit word
which prevents the issue of inconsistency.

After writing the final destination it is necessary to check whether the
device issued an interrupt while the intermediate state #1 (new vector,
current CPU) was in effect.

This is possible because the affinity change is always happening on the
current target CPU. The code runs with interrupts disabled, so the
interrupt can be detected by checking the IRR of the local APIC. If the
vector is pending in the IRR then the interrupt is retriggered on the new
target CPU by sending an IPI for the associated vector on the target CPU.

This can cause spurious interrupts on both the local and the new target
CPU.

 1) If the new vector is not in use on the local CPU and the device
    affected by the affinity change raised an interrupt during the
    transitional state (step #1 above) then interrupt entry code will
    ignore that spurious interrupt. The vector is marked so that the
    'No irq handler for vector' warning is supressed once.

 2) If the new vector is in use already on the local CPU then the IRR check
    might see an pending interrupt from the device which is using this
    vector. The IPI to the new target CPU will then invoke the handler of
    the device, which got the affinity change, even if that device did not
    issue an interrupt

 3) If the new vector is in use already on the local CPU and the device
    affected by the affinity change raised an interrupt during the
    transitional state (step #1 above) then the handler of the device which
    uses that vector on the local CPU will be invoked.

expose issues in device driver interrupt handlers which are not prepared to
handle a spurious interrupt correctly. This not a regression, it's just
exposing something which was already broken as spurious interrupts can
happen for a lot of reasons and all driver handlers need to be able to deal
with them.

Conflicts:
	arch/x86/kernel/apic/msi.c
	include/linux/irq.h

Reported-by: Evan Green <evgreen@chromium.org>
Debugged-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Evan Green <evgreen@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87imkr4s7n.fsf@nanos.tec.linutronix.de
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
---
 arch/x86/include/asm/apic.h |   8 +++
 arch/x86/kernel/apic/msi.c  | 128 +++++++++++++++++++++++++++++++++++-
 include/linux/irq.h         |  15 +++++
 include/linux/irqdomain.h   |   7 ++
 kernel/irq/debugfs.c        |   1 +
 kernel/irq/msi.c            |   5 +-
 6 files changed, 160 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 050368db9d35..3c1e51ead072 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -448,6 +448,14 @@ static inline void ack_APIC_irq(void)
 	apic_eoi();
 }
 
+
+static inline bool lapic_vector_set_in_irr(unsigned int vector)
+{
+	u32 irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+
+	return !!(irr & (1U << (vector % 32)));
+}
+
 static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 37465ab9d030..a81e8e2ede3d 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -30,10 +30,8 @@ static struct irq_domain *platform_msi_default_domain;
 static struct msi_domain_info platform_msi_domain_info;
 #endif
 
-static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-
 	msg->address_hi = MSI_ADDR_BASE_HI;
 
 	if (x2apic_enabled())
@@ -54,6 +52,127 @@ static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 		MSI_DATA_VECTOR(cfg->vector);
 }
 
+static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	__irq_msi_compose_msg(irqd_cfg(data), msg);
+}
+
+static void irq_msi_update_msg(struct irq_data *irqd, struct irq_cfg *cfg)
+{
+	struct msi_msg msg[2] = { [1] = { }, };
+
+	__irq_msi_compose_msg(cfg, msg);
+	irq_data_get_irq_chip(irqd)->irq_write_msi_msg(irqd, msg);
+}
+
+static int
+msi_set_affinity(struct irq_data *irqd, const struct cpumask *mask, bool force)
+{
+	struct irq_cfg old_cfg, *cfg = irqd_cfg(irqd);
+	struct irq_data *parent = irqd->parent_data;
+	unsigned int cpu;
+	int ret;
+
+	/* Save the current configuration */
+	cpu = cpumask_first(irq_data_get_effective_affinity_mask(irqd));
+	old_cfg = *cfg;
+
+	/* Allocate a new target vector */
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
+		return ret;
+
+	/*
+	 * For non-maskable and non-remapped MSI interrupts the migration
+	 * to a different destination CPU and a different vector has to be
+	 * done careful to handle the possible stray interrupt which can be
+	 * caused by the non-atomic update of the address/data pair.
+	 *
+	 * Direct update is possible when:
+	 * - The MSI is maskable (remapped MSI does not use this code path)).
+	 *   The quirk bit is not set in this case.
+	 * - The new vector is the same as the old vector
+	 * - The old vector is MANAGED_IRQ_SHUTDOWN_VECTOR (interrupt starts up)
+	 * - The new destination CPU is the same as the old destination CPU
+	 */
+	if (!irqd_msi_nomask_quirk(irqd) ||
+	    cfg->vector == old_cfg.vector ||
+	    old_cfg.vector == MANAGED_IRQ_SHUTDOWN_VECTOR ||
+	    cfg->dest_apicid == old_cfg.dest_apicid) {
+		irq_msi_update_msg(irqd, cfg);
+		return ret;
+	}
+
+	/*
+	 * Paranoia: Validate that the interrupt target is the local
+	 * CPU.
+	 */
+	if (WARN_ON_ONCE(cpu != smp_processor_id())) {
+		irq_msi_update_msg(irqd, cfg);
+		return ret;
+	}
+
+	/*
+	 * Redirect the interrupt to the new vector on the current CPU
+	 * first. This might cause a spurious interrupt on this vector if
+	 * the device raises an interrupt right between this update and the
+	 * update to the final destination CPU.
+	 *
+	 * If the vector is in use then the installed device handler will
+	 * denote it as spurious which is no harm as this is a rare event
+	 * and interrupt handlers have to cope with spurious interrupts
+	 * anyway. If the vector is unused, then it is marked so it won't
+	 * trigger the 'No irq handler for vector' warning in do_IRQ().
+	 *
+	 * This requires to hold vector lock to prevent concurrent updates to
+	 * the affected vector.
+	 */
+	lock_vector_lock();
+
+	/*
+	 * Mark the new target vector on the local CPU if it is currently
+	 * unused. Reuse the VECTOR_RETRIGGERED state which is also used in
+	 * the CPU hotplug path for a similar purpose. This cannot be
+	 * undone here as the current CPU has interrupts disabled and
+	 * cannot handle the interrupt before the whole set_affinity()
+	 * section is done. In the CPU unplug case, the current CPU is
+	 * about to vanish and will not handle any interrupts anymore. The
+	 * vector is cleaned up when the CPU comes online again.
+	 */
+	if (IS_ERR_OR_NULL(this_cpu_read(vector_irq[cfg->vector])))
+		this_cpu_write(vector_irq[cfg->vector], VECTOR_RETRIGGERED);
+
+	/* Redirect it to the new vector on the local CPU temporarily */
+	old_cfg.vector = cfg->vector;
+	irq_msi_update_msg(irqd, &old_cfg);
+
+	/* Now transition it to the target CPU */
+	irq_msi_update_msg(irqd, cfg);
+
+	/*
+	 * All interrupts after this point are now targeted at the new
+	 * vector/CPU.
+	 *
+	 * Drop vector lock before testing whether the temporary assignment
+	 * to the local CPU was hit by an interrupt raised in the device,
+	 * because the retrigger function acquires vector lock again.
+	 */
+	unlock_vector_lock();
+
+	/*
+	 * Check whether the transition raced with a device interrupt and
+	 * is pending in the local APICs IRR. It is safe to do this outside
+	 * of vector lock as the irq_desc::lock of this interrupt is still
+	 * held and interrupts are disabled: The check is not accessing the
+	 * underlying vector store. It's just checking the local APIC's
+	 * IRR.
+	 */
+	if (lapic_vector_set_in_irr(cfg->vector))
+		irq_data_get_irq_chip(irqd)->irq_retrigger(irqd);
+
+	return ret;
+}
+
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -65,6 +184,7 @@ static struct irq_chip pci_msi_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
+	.irq_set_affinity	= msi_set_affinity,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -153,6 +273,8 @@ void __init arch_init_msi_domain(struct irq_domain *parent)
 	}
 	if (!msi_default_domain)
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
+	else
+		msi_default_domain->flags |= IRQ_DOMAIN_MSI_NOMASK_QUIRK;
 #ifdef CONFIG_X86_PLATFORM_MSI
 	fn = irq_domain_alloc_named_fwnode("PLATFORM-MSI");
 	if (fn) {
diff --git a/include/linux/irq.h b/include/linux/irq.h
index ea06077e066d..f7c1177f1840 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -405,6 +405,21 @@ static inline bool irqd_can_reserve(struct irq_data *d)
 	return __irqd_to_state(d) & IRQD_CAN_RESERVE;
 }
 
+static inline void irqd_set_msi_nomask_quirk(struct irq_data *d)
+{
+	__irqd_to_state(d) |= IRQD_MSI_NOMASK_QUIRK;
+}
+
+static inline void irqd_clr_msi_nomask_quirk(struct irq_data *d)
+{
+	__irqd_to_state(d) &= ~IRQD_MSI_NOMASK_QUIRK;
+}
+
+static inline bool irqd_msi_nomask_quirk(struct irq_data *d)
+{
+	return __irqd_to_state(d) & IRQD_MSI_NOMASK_QUIRK;
+}
+
 #undef __irqd_to_state
 
 static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index dccfa65aee96..8301f1df0682 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -202,6 +202,13 @@ enum {
 	/* Irq domain implements MSI remapping */
 	IRQ_DOMAIN_FLAG_MSI_REMAP	= (1 << 5),
 
+	/*
+	 * Quirk to handle MSI implementations which do not provide
+	 * masking. Currently known to affect x86, but partially
+	 * handled in core code.
+	 */
+	IRQ_DOMAIN_MSI_NOMASK_QUIRK	= (1 << 6),
+
 	/*
 	 * Flags starting from IRQ_DOMAIN_FLAG_NONCORE are reserved
 	 * for implementation specific purposes and ignored by the
diff --git a/kernel/irq/debugfs.c b/kernel/irq/debugfs.c
index 7c426da3a37e..ccfe1fd1721b 100644
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -114,6 +114,7 @@ static const struct irq_bit_descr irqdata_states[] = {
 	BIT_MASK_DESCR(IRQD_AFFINITY_MANAGED),
 	BIT_MASK_DESCR(IRQD_MANAGED_SHUTDOWN),
 	BIT_MASK_DESCR(IRQD_CAN_RESERVE),
+	BIT_MASK_DESCR(IRQD_MSI_NOMASK_QUIRK),
 
 	BIT_MASK_DESCR(IRQD_FORWARDED_TO_VCPU),
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 4ca2fd46645d..dc1186ce3ecd 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -453,8 +453,11 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			continue;
 
 		irq_data = irq_domain_get_irq_data(domain, desc->irq);
-		if (!can_reserve)
+		if (!can_reserve) {
 			irqd_clr_can_reserve(irq_data);
+			if (domain->flags & IRQ_DOMAIN_MSI_NOMASK_QUIRK)
+				irqd_set_msi_nomask_quirk(irq_data);
+		}
 		ret = irq_domain_activate_irq(irq_data, can_reserve);
 		if (ret)
 			goto cleanup;
-- 
2.30.0.81.g72c4083ddf

