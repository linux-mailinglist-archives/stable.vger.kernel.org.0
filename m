Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CDAE6821
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbfJ0VZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732668AbfJ0VZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:10 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 478252064A;
        Sun, 27 Oct 2019 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211508;
        bh=LuuwH0M7TTpEcNcdrSsa6DTSBCMS53WFKp+CioUPCnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7U35bJyxwDDRTdf25X95q7r+xhsW4fq5XV/kIHQhvvq8auu4Athbusgp7TTuxZ7l
         cWsAwNgT9rKC39DR7MDqU7xeDx/3WGVLaCXb0/QlEUmCbPjy9Luv5zmatoVrO5qLMF
         aTJ5HO6aOqw1SNgClSa010wK4CL6a0qqKhwAbzaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Darius Rad <darius@bluespec.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH 5.3 174/197] irqchip/sifive-plic: Switch to fasteoi flow
Date:   Sun, 27 Oct 2019 22:01:32 +0100
Message-Id: <20191027203404.473976831@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit bb0fed1c60cccbe4063b455a7228818395dac86e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-sifive-plic.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -97,7 +97,7 @@ static inline void plic_irq_toggle(const
 	}
 }
 
-static void plic_irq_enable(struct irq_data *d)
+static void plic_irq_unmask(struct irq_data *d)
 {
 	unsigned int cpu = cpumask_any_and(irq_data_get_affinity_mask(d),
 					   cpu_online_mask);
@@ -106,7 +106,7 @@ static void plic_irq_enable(struct irq_d
 	plic_irq_toggle(cpumask_of(cpu), d->hwirq, 1);
 }
 
-static void plic_irq_disable(struct irq_data *d)
+static void plic_irq_mask(struct irq_data *d)
 {
 	plic_irq_toggle(cpu_possible_mask, d->hwirq, 0);
 }
@@ -125,10 +125,8 @@ static int plic_set_affinity(struct irq_
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	if (!irqd_irq_disabled(d)) {
-		plic_irq_toggle(cpu_possible_mask, d->hwirq, 0);
-		plic_irq_toggle(cpumask_of(cpu), d->hwirq, 1);
-	}
+	plic_irq_toggle(cpu_possible_mask, d->hwirq, 0);
+	plic_irq_toggle(cpumask_of(cpu), d->hwirq, 1);
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
@@ -136,14 +134,18 @@ static int plic_set_affinity(struct irq_
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
@@ -188,7 +190,6 @@ static void plic_handle_irq(struct pt_re
 					hwirq);
 		else
 			generic_handle_irq(irq);
-		writel(hwirq, claim);
 	}
 	csr_set(sie, SIE_SEIE);
 }


