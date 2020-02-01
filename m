Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FA314F743
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 09:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgBAIgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 03:36:49 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56915 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgBAIgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 03:36:49 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ixoGf-0003ZI-HR; Sat, 01 Feb 2020 09:36:41 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 179FF1C1C17;
        Sat,  1 Feb 2020 09:36:41 +0100 (CET)
Date:   Sat, 01 Feb 2020 08:36:40 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic/msi: Plug non-maskable MSI affinity race
Cc:     Evan Green <evgreen@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87imkr4s7n.fsf@nanos.tec.linutronix.de>
References: <87imkr4s7n.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <158054620083.396.4841774652897871837.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     6f1a4891a5928a5969c87fa5a584844c983ec823
Gitweb:        https://git.kernel.org/tip/6f1a4891a5928a5969c87fa5a584844c983ec823
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 31 Jan 2020 15:26:52 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 01 Feb 2020 09:31:47 +01:00

x86/apic/msi: Plug non-maskable MSI affinity race

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

Reported-by: Evan Green <evgreen@chromium.org>
Debugged-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Evan Green <evgreen@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87imkr4s7n.fsf@nanos.tec.linutronix.de
---
 arch/x86/include/asm/apic.h |   8 ++-
 arch/x86/kernel/apic/msi.c  | 128 ++++++++++++++++++++++++++++++++++-
 include/linux/irq.h         |  18 +++++-
 include/linux/irqdomain.h   |   7 ++-
 kernel/irq/debugfs.c        |   1 +-
 kernel/irq/msi.c            |   5 +-
 6 files changed, 163 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index be0b9cf..19e94af 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -454,6 +454,14 @@ static inline void ack_APIC_irq(void)
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
index 7f75334..159bd0c 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -23,10 +23,8 @@
 
 static struct irq_domain *msi_default_domain;
 
-static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
-
 	msg->address_hi = MSI_ADDR_BASE_HI;
 
 	if (x2apic_enabled())
@@ -47,6 +45,127 @@ static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
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
@@ -58,6 +177,7 @@ static struct irq_chip pci_msi_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
+	.irq_set_affinity	= msi_set_affinity,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -146,6 +266,8 @@ void __init arch_init_msi_domain(struct irq_domain *parent)
 	}
 	if (!msi_default_domain)
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
+	else
+		msi_default_domain->flags |= IRQ_DOMAIN_MSI_NOMASK_QUIRK;
 }
 
 #ifdef CONFIG_IRQ_REMAP
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7853eb9..3ed5a05 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -209,6 +209,8 @@ struct irq_data {
  * IRQD_SINGLE_TARGET		- IRQ allows only a single affinity target
  * IRQD_DEFAULT_TRIGGER_SET	- Expected trigger already been set
  * IRQD_CAN_RESERVE		- Can use reservation mode
+ * IRQD_MSI_NOMASK_QUIRK	- Non-maskable MSI quirk for affinity change
+ *				  required
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -231,6 +233,7 @@ enum {
 	IRQD_SINGLE_TARGET		= (1 << 24),
 	IRQD_DEFAULT_TRIGGER_SET	= (1 << 25),
 	IRQD_CAN_RESERVE		= (1 << 26),
+	IRQD_MSI_NOMASK_QUIRK		= (1 << 27),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -390,6 +393,21 @@ static inline bool irqd_can_reserve(struct irq_data *d)
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
index 3c340db..4da8df5 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -207,6 +207,13 @@ enum {
 	IRQ_DOMAIN_FLAG_MSI_REMAP	= (1 << 5),
 
 	/*
+	 * Quirk to handle MSI implementations which do not provide
+	 * masking. Currently known to affect x86, but partially
+	 * handled in core code.
+	 */
+	IRQ_DOMAIN_MSI_NOMASK_QUIRK	= (1 << 6),
+
+	/*
 	 * Flags starting from IRQ_DOMAIN_FLAG_NONCORE are reserved
 	 * for implementation specific purposes and ignored by the
 	 * core code.
diff --git a/kernel/irq/debugfs.c b/kernel/irq/debugfs.c
index c1eccd4..a949bd3 100644
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -114,6 +114,7 @@ static const struct irq_bit_descr irqdata_states[] = {
 	BIT_MASK_DESCR(IRQD_AFFINITY_MANAGED),
 	BIT_MASK_DESCR(IRQD_MANAGED_SHUTDOWN),
 	BIT_MASK_DESCR(IRQD_CAN_RESERVE),
+	BIT_MASK_DESCR(IRQD_MSI_NOMASK_QUIRK),
 
 	BIT_MASK_DESCR(IRQD_FORWARDED_TO_VCPU),
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index ad26fbc..eb95f61 100644
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
