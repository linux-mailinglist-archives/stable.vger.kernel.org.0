Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72F02267E4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbgGTQPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388017AbgGTQPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19762064B;
        Mon, 20 Jul 2020 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261730;
        bh=BpLFu4Eqk/AIie6pT8aHXRs/3RYFgUwOBfz2ue2Eb6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6wv9cxxYVTfJQ70qFodFXLc6A6FC04Jcjr8Hp9ZnhvdaG4OehJycpiBHez9yfGvT
         JjfxWUMeNU61P4ieG15PPVJQ2Rg2qv0llpI554KTfqt0mibRLl+PMBhtFbjY1Hvnr1
         zivEPQR+enslTnVCHWB+qZbjGTVTg3nzToZGRyBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ali Saidi <alisaidi@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.7 222/244] genirq/affinity: Handle affinity setting on inactive interrupts correctly
Date:   Mon, 20 Jul 2020 17:38:13 +0200
Message-Id: <20200720152836.410748052@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit baedb87d1b53532f81b4bd0387f83b05d4f7eb9a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/vector.c |   22 +++++-----------------
 kernel/irq/manage.c           |   37 +++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -446,12 +446,10 @@ static int x86_vector_activate(struct ir
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
@@ -775,20 +773,10 @@ void lapic_offline(void)
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
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -195,9 +195,9 @@ void irq_set_thread_affinity(struct irq_
 			set_bit(IRQTF_AFFINITY, &action->thread_flags);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 static void irq_validate_effective_affinity(struct irq_data *data)
 {
-#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 	const struct cpumask *m = irq_data_get_effective_affinity_mask(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 
@@ -205,9 +205,19 @@ static void irq_validate_effective_affin
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
@@ -304,6 +314,26 @@ static int irq_try_set_affinity(struct i
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
@@ -314,6 +344,9 @@ int irq_set_affinity_locked(struct irq_d
 	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
+	if (irq_set_affinity_deactivated(data, mask, force))
+		return 0;
+
 	if (irq_can_move_pcntxt(data) && !irqd_is_setaffinity_pending(data)) {
 		ret = irq_try_set_affinity(data, mask, force);
 	} else {


