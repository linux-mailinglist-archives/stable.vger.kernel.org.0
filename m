Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D052245DA
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 23:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGQVex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 17:34:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43312 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQVex (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 17:34:53 -0400
Date:   Fri, 17 Jul 2020 21:34:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595021689;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPWBpVP2RhRga83juGM3kt8abhmjMkgko6QmWcngcwY=;
        b=ZliFmb8MyVLLYa2zg+x4ic5Oo4Ctx5EnF9JUmWohJQfMJtEW5uQ4ryAuVlyz7OUSD6H9lp
        XToXcn0vfc25PIxOZf7s4Ap4filgobN7B+UyaEQez/6v+gh8eUJcmTnd/jGk/PB+Nbd2dy
        4nuW3P/d2rjELD1D/PVZvn+CzATXYB/s5u9vn8VzmBRkY09tpNzae8nJNqSKFLlkDb0QU0
        P0xJK4+AUpZysWr+YdSHoaoEVYb8Ndx2rlRmOqz073GGRptnjhFvWKys1LQF+mUEjqdm5Q
        +5+jadVD4FLvggL3mZdTRd3XQAJ2xbHRytTKZf4KMVK8i5uOMZHW9gF4WDjIgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595021689;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPWBpVP2RhRga83juGM3kt8abhmjMkgko6QmWcngcwY=;
        b=ktr3L9kwtY7DWGfl/n4pCh671oMaxZK9/cFguy92C2N7QyIF9wg72ZHwo3yM83O/MaVgEy
        YzUlZhd7YP5g7GAg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/affinity: Handle affinity setting on
 inactive interrupts correctly
Cc:     Ali Saidi <alisaidi@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200529015501.15771-1-alisaidi@amazon.com>
References: <20200529015501.15771-1-alisaidi@amazon.com>
MIME-Version: 1.0
Message-ID: <159502168875.4006.5712868222524660630.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     baedb87d1b53532f81b4bd0387f83b05d4f7eb9a
Gitweb:        https://git.kernel.org/tip/baedb87d1b53532f81b4bd0387f83b05d4f7eb9a
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 17 Jul 2020 18:00:02 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 17 Jul 2020 23:30:43 +02:00

genirq/affinity: Handle affinity setting on inactive interrupts correctly

Setting interrupt affinity on inactive interrupts is inconsistent when
hierarchical irq domains are enabled. The core code should just store the
affinity and not call into the irq chip driver for inactive interrupts
because the chip drivers may not be in a state to handle such requests.

X86 has a hacky workaround for that but all other irq chips have not which
causes problems e.g. on GIC V3 ITS.

Instead of adding more ugly hacks all over the place, solve the problem in
the core code. If the affinity is set on an inactive interrupt then:

    - Store it in the irq descriptors affinity mask
    - Update the effective affinity to reflect that so user space has
      a consistent view
    - Don't call into the irq chip driver

This is the core equivalent of the X86 workaround and works correctly
because the affinity setting is established in the irq chip when the
interrupt is activated later on.

Note, that this is only effective when hierarchical irq domains are enabled
by the architecture. Doing it unconditionally would break legacy irq chip
implementations.

For hierarchial irq domains this works correctly as none of the drivers can
have a dependency on affinity setting in inactive state by design.

Remove the X86 workaround as it is not longer required.

Fixes: 02edee152d6e ("x86/apic/vector: Ignore set_affinity call for inactive interrupts")
Reported-by: Ali Saidi <alisaidi@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Ali Saidi <alisaidi@amazon.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200529015501.15771-1-alisaidi@amazon.com
Link: https://lkml.kernel.org/r/877dv2rv25.fsf@nanos.tec.linutronix.de
---
 arch/x86/kernel/apic/vector.c | 22 ++++----------------
 kernel/irq/manage.c           | 37 ++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index cc8b16f..7649da2 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -446,12 +446,10 @@ static int x86_vector_activate(struct irq_domain *dom, struct irq_data *irqd,
 	trace_vector_activate(irqd->irq, apicd->is_managed,
 			      apicd->can_reserve, reserve);
 
-	/* Nothing to do for fixed assigned vectors */
-	if (!apicd->can_reserve && !apicd->is_managed)
-		return 0;
-
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	if (reserve || irqd_is_managed_and_shutdown(irqd))
+	if (!apicd->can_reserve && !apicd->is_managed)
+		assign_irq_vector_any_locked(irqd);
+	else if (reserve || irqd_is_managed_and_shutdown(irqd))
 		vector_assign_managed_shutdown(irqd);
 	else if (apicd->is_managed)
 		ret = activate_managed(irqd);
@@ -774,20 +772,10 @@ void lapic_offline(void)
 static int apic_set_affinity(struct irq_data *irqd,
 			     const struct cpumask *dest, bool force)
 {
-	struct apic_chip_data *apicd = apic_chip_data(irqd);
 	int err;
 
-	/*
-	 * Core code can call here for inactive interrupts. For inactive
-	 * interrupts which use managed or reservation mode there is no
-	 * point in going through the vector assignment right now as the
-	 * activation will assign a vector which fits the destination
-	 * cpumask. Let the core code store the destination mask and be
-	 * done with it.
-	 */
-	if (!irqd_is_activated(irqd) &&
-	    (apicd->is_managed || apicd->can_reserve))
-		return IRQ_SET_MASK_OK;
+	if (WARN_ON_ONCE(!irqd_is_activated(irqd)))
+		return -EIO;
 
 	raw_spin_lock(&vector_lock);
 	cpumask_and(vector_searchmask, dest, cpu_online_mask);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7619111..2a9fec5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -195,9 +195,9 @@ void irq_set_thread_affinity(struct irq_desc *desc)
 			set_bit(IRQTF_AFFINITY, &action->thread_flags);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 static void irq_validate_effective_affinity(struct irq_data *data)
 {
-#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 	const struct cpumask *m = irq_data_get_effective_affinity_mask(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 
@@ -205,9 +205,19 @@ static void irq_validate_effective_affinity(struct irq_data *data)
 		return;
 	pr_warn_once("irq_chip %s did not update eff. affinity mask of irq %u\n",
 		     chip->name, data->irq);
-#endif
 }
 
+static inline void irq_init_effective_affinity(struct irq_data *data,
+					       const struct cpumask *mask)
+{
+	cpumask_copy(irq_data_get_effective_affinity_mask(data), mask);
+}
+#else
+static inline void irq_validate_effective_affinity(struct irq_data *data) { }
+static inline void irq_init_effective_affinity(struct irq_data *data,
+					       const struct cpumask *mask) { }
+#endif
+
 int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			bool force)
 {
@@ -304,6 +314,26 @@ static int irq_try_set_affinity(struct irq_data *data,
 	return ret;
 }
 
+static bool irq_set_affinity_deactivated(struct irq_data *data,
+					 const struct cpumask *mask, bool force)
+{
+	struct irq_desc *desc = irq_data_to_desc(data);
+
+	/*
+	 * If the interrupt is not yet activated, just store the affinity
+	 * mask and do not call the chip driver at all. On activation the
+	 * driver has to make sure anyway that the interrupt is in a
+	 * useable state so startup works.
+	 */
+	if (!IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) || irqd_is_activated(data))
+		return false;
+
+	cpumask_copy(desc->irq_common_data.affinity, mask);
+	irq_init_effective_affinity(data, mask);
+	irqd_set(data, IRQD_AFFINITY_SET);
+	return true;
+}
+
 int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
@@ -314,6 +344,9 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
+	if (irq_set_affinity_deactivated(data, mask, force))
+		return 0;
+
 	if (irq_can_move_pcntxt(data) && !irqd_is_setaffinity_pending(data)) {
 		ret = irq_try_set_affinity(data, mask, force);
 	} else {
