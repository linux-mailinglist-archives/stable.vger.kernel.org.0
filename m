Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1C06C7B4
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389427AbfGRDDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389412AbfGRDDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:40 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7AEA2053B;
        Thu, 18 Jul 2019 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419019;
        bh=Qh0YRFtQcJQ3oyBkgK7BsdNywupxtSKO5Szl4RbhAaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O88b+WTgu2gdHvI+rglmTNdoihUAJ0PEs2wANNfK7rZWKgHCaXCiX617yLzE3P4KQ
         LyY7wMgwc+bJ11nSPnY1LeE4KISbxzg0wsYY9mwgm9wTz4BoEUaez2BJVyItXqEx+P
         gfixKLITw9Pb4Eqp6ww/OI2JWNvr+FfCoZ1/cT7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.2 11/21] x86/irq: Handle spurious interrupt after shutdown gracefully
Date:   Thu, 18 Jul 2019 12:01:29 +0900
Message-Id: <20190718030032.865813866@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit b7107a67f0d125459fe41f86e8079afd1a5e0b15 upstream.

Since the rework of the vector management, warnings about spurious
interrupts have been reported. Robert provided some more information and
did an initial analysis. The following situation leads to these warnings:

   CPU 0                  CPU 1               IO_APIC

                                              interrupt is raised
                                              sent to CPU1
			  Unable to handle
			  immediately
			  (interrupts off,
			   deep idle delay)
   mask()
   ...
   free()
     shutdown()
     synchronize_irq()
     clear_vector()
                          do_IRQ()
                            -> vector is clear

Before the rework the vector entries of legacy interrupts were statically
assigned and occupied precious vector space while most of them were
unused. Due to that the above situation was handled silently because the
vector was handled and the core handler of the assigned interrupt
descriptor noticed that it is shut down and returned.

While this has been usually observed with legacy interrupts, this situation
is not limited to them. Any other interrupt source, e.g. MSI, can cause the
same issue.

After adding proper synchronization for level triggered interrupts, this
can only happen for edge triggered interrupts where the IO-APIC obviously
cannot provide information about interrupts in flight.

While the spurious warning is actually harmless in this case it worries
users and driver developers.

Handle it gracefully by marking the vector entry as VECTOR_SHUTDOWN instead
of VECTOR_UNUSED when the vector is freed up.

If that above late handling happens the spurious detector will not complain
and switch the entry to VECTOR_UNUSED. Any subsequent spurious interrupt on
that line will trigger the spurious warning as before.

Fixes: 464d12309e1b ("x86/vector: Switch IOAPIC to global reservation mode")
Reported-by: Robert Hodaszi <Robert.Hodaszi@digi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>-
Tested-by: Robert Hodaszi <Robert.Hodaszi@digi.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/20190628111440.459647741@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/hw_irq.h |    3 ++-
 arch/x86/kernel/apic/vector.c |    4 ++--
 arch/x86/kernel/irq.c         |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -151,7 +151,8 @@ extern char irq_entries_start[];
 #endif
 
 #define VECTOR_UNUSED		NULL
-#define VECTOR_RETRIGGERED	((void *)~0UL)
+#define VECTOR_SHUTDOWN		((void *)~0UL)
+#define VECTOR_RETRIGGERED	((void *)~1UL)
 
 typedef struct irq_desc* vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -340,7 +340,7 @@ static void clear_irq_vector(struct irq_
 	trace_vector_clear(irqd->irq, vector, apicd->cpu, apicd->prev_vector,
 			   apicd->prev_cpu);
 
-	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_UNUSED;
+	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
 	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
 	apicd->vector = 0;
 
@@ -349,7 +349,7 @@ static void clear_irq_vector(struct irq_
 	if (!vector)
 		return;
 
-	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_UNUSED;
+	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
 	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
 	apicd->prev_vector = 0;
 	apicd->move_in_progress = 0;
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -247,7 +247,7 @@ __visible unsigned int __irq_entry do_IR
 	if (!handle_irq(desc, regs)) {
 		ack_APIC_irq();
 
-		if (desc != VECTOR_RETRIGGERED) {
+		if (desc != VECTOR_RETRIGGERED && desc != VECTOR_SHUTDOWN) {
 			pr_emerg_ratelimited("%s: %d.%d No irq handler for vector\n",
 					     __func__, smp_processor_id(),
 					     vector);


