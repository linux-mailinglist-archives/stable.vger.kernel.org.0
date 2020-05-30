Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD21E8F1D
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 09:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgE3Hqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 03:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgE3Hqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 03:46:37 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4CCC08C5C9;
        Sat, 30 May 2020 00:46:37 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jewCQ-0001qm-EU; Sat, 30 May 2020 09:46:34 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 1B66E1C032F;
        Sat, 30 May 2020 09:46:34 +0200 (CEST)
Date:   Sat, 30 May 2020 07:46:33 -0000
From:   "tip-bot2 for Anup Patel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] irqchip/sifive-plic: Setup cpuhp once after boot CPU
 handler is present
Cc:     Anup Patel <anup.patel@wdc.com>, Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200518091441.94843-3-anup.patel@wdc.com>
References: <20200518091441.94843-3-anup.patel@wdc.com>
MIME-Version: 1.0
Message-ID: <159082479399.17951.16312468459384777316.tip-bot2@tip-bot2>
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

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     2234ae846ccb9ebdf4c391824cb79e73674dceda
Gitweb:        https://git.kernel.org/tip/2234ae846ccb9ebdf4c391824cb79e73674dceda
Author:        Anup Patel <anup.patel@wdc.com>
AuthorDate:    Mon, 18 May 2020 14:44:40 +05:30
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 25 May 2020 10:36:53 +01:00

irqchip/sifive-plic: Setup cpuhp once after boot CPU handler is present

For multiple PLIC instances, the plic_init() is called once for each
PLIC instance. Due to this we have two issues:
1. cpuhp_setup_state() is called multiple times
2. plic_starting_cpu() can crash for boot CPU if cpuhp_setup_state()
   is called before boot CPU PLIC handler is available.

Address both issues by only initializing the HP notifiers when
the boot CPU setup is complete.

Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200518091441.94843-3-anup.patel@wdc.com
---
 drivers/irqchip/irq-sifive-plic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 9f7f8ce..6c54abf 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -76,6 +76,7 @@ struct plic_handler {
 	void __iomem		*enable_base;
 	struct plic_priv	*priv;
 };
+static bool plic_cpuhp_setup_done;
 static DEFINE_PER_CPU(struct plic_handler, plic_handlers);
 
 static inline void plic_toggle(struct plic_handler *handler,
@@ -285,6 +286,7 @@ static int __init plic_init(struct device_node *node,
 	int error = 0, nr_contexts, nr_handlers = 0, i;
 	u32 nr_irqs;
 	struct plic_priv *priv;
+	struct plic_handler *handler;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -313,7 +315,6 @@ static int __init plic_init(struct device_node *node,
 
 	for (i = 0; i < nr_contexts; i++) {
 		struct of_phandle_args parent;
-		struct plic_handler *handler;
 		irq_hw_number_t hwirq;
 		int cpu, hartid;
 
@@ -367,9 +368,18 @@ done:
 		nr_handlers++;
 	}
 
-	cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
+	/*
+	 * We can have multiple PLIC instances so setup cpuhp state only
+	 * when context handler for current/boot CPU is present.
+	 */
+	handler = this_cpu_ptr(&plic_handlers);
+	if (handler->present && !plic_cpuhp_setup_done) {
+		cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
 				  "irqchip/sifive/plic:starting",
 				  plic_starting_cpu, plic_dying_cpu);
+		plic_cpuhp_setup_done = true;
+	}
+
 	pr_info("mapped %d interrupts with %d handlers for %d contexts.\n",
 		nr_irqs, nr_handlers, nr_contexts);
 	set_handle_irq(plic_handle_irq);
