Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6A3D6999
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 20:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbfJNSi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 14:38:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40320 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731291AbfJNSi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 14:38:58 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iK5F7-0005bI-2o; Mon, 14 Oct 2019 20:38:53 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A6EAA1C010B;
        Mon, 14 Oct 2019 20:38:47 +0200 (CEST)
Date:   Mon, 14 Oct 2019 18:38:47 -0000
From:   "tip-bot2 for Marc Zyngier" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] irqchip/sifive-plic: Switch to fasteoi flow
Cc:     Marc Zyngier <maz@kernel.org>, Palmer Dabbelt <palmer@sifive.com>,
        Darius Rad <darius@bluespec.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <8636gxskmj.wl-maz@kernel.org>
References: <8636gxskmj.wl-maz@kernel.org>
MIME-Version: 1.0
Message-ID: <157107832749.12254.5664038799279181370.tip-bot2@tip-bot2>
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

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     bb0fed1c60cccbe4063b455a7228818395dac86e
Gitweb:        https://git.kernel.org/tip/bb0fed1c60cccbe4063b455a7228818395dac86e
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Sun, 15 Sep 2019 15:17:45 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Wed, 18 Sep 2019 12:29:52 +01:00

irqchip/sifive-plic: Switch to fasteoi flow

The SiFive PLIC interrupt controller seems to have all the HW
features to support the fasteoi flow, but the driver seems to be
stuck in a distant past. Bring it into the 21st century.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Palmer Dabbelt <palmer@sifive.com> (QEMU Boot)
Tested-by: Darius Rad <darius@bluespec.com> (on 2 HW PLIC implementations)
Tested-by: Paul Walmsley <paul.walmsley@sifive.com> (HiFive Unleashed)
Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/8636gxskmj.wl-maz@kernel.org
---
 drivers/irqchip/irq-sifive-plic.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index cf75596..3e51dee 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -97,7 +97,7 @@ static inline void plic_irq_toggle(const struct cpumask *mask,
 	}
 }
 
-static void plic_irq_enable(struct irq_data *d)
+static void plic_irq_unmask(struct irq_data *d)
 {
 	unsigned int cpu = cpumask_any_and(irq_data_get_affinity_mask(d),
 					   cpu_online_mask);
@@ -106,7 +106,7 @@ static void plic_irq_enable(struct irq_data *d)
 	plic_irq_toggle(cpumask_of(cpu), d->hwirq, 1);
 }
 
-static void plic_irq_disable(struct irq_data *d)
+static void plic_irq_mask(struct irq_data *d)
 {
 	plic_irq_toggle(cpu_possible_mask, d->hwirq, 0);
 }
@@ -125,10 +125,8 @@ static int plic_set_affinity(struct irq_data *d,
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	if (!irqd_irq_disabled(d)) {
-		plic_irq_toggle(cpu_possible_mask, d->hwirq, 0);
-		plic_irq_toggle(cpumask_of(cpu), d->hwirq, 1);
-	}
+	plic_irq_toggle(cpu_possible_mask, d->hwirq, 0);
+	plic_irq_toggle(cpumask_of(cpu), d->hwirq, 1);
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
@@ -136,14 +134,18 @@ static int plic_set_affinity(struct irq_data *d,
 }
 #endif
 
+static void plic_irq_eoi(struct irq_data *d)
+{
+	struct plic_handler *handler = this_cpu_ptr(&plic_handlers);
+
+	writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+}
+
 static struct irq_chip plic_chip = {
 	.name		= "SiFive PLIC",
-	/*
-	 * There is no need to mask/unmask PLIC interrupts.  They are "masked"
-	 * by reading claim and "unmasked" when writing it back.
-	 */
-	.irq_enable	= plic_irq_enable,
-	.irq_disable	= plic_irq_disable,
+	.irq_mask	= plic_irq_mask,
+	.irq_unmask	= plic_irq_unmask,
+	.irq_eoi	= plic_irq_eoi,
 #ifdef CONFIG_SMP
 	.irq_set_affinity = plic_set_affinity,
 #endif
@@ -152,7 +154,7 @@ static struct irq_chip plic_chip = {
 static int plic_irqdomain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hwirq)
 {
-	irq_set_chip_and_handler(irq, &plic_chip, handle_simple_irq);
+	irq_set_chip_and_handler(irq, &plic_chip, handle_fasteoi_irq);
 	irq_set_chip_data(irq, NULL);
 	irq_set_noprobe(irq);
 	return 0;
@@ -188,7 +190,6 @@ static void plic_handle_irq(struct pt_regs *regs)
 					hwirq);
 		else
 			generic_handle_irq(irq);
-		writel(hwirq, claim);
 	}
 	csr_set(sie, SIE_SEIE);
 }
