Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48106C567
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390084AbfGRDFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389524AbfGRDFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:53 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20B82173B;
        Thu, 18 Jul 2019 03:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419153;
        bh=o2Kr2eyw/O6JKnMps8ZPt7nNdeWLgNXBUuzb704FtCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4DSUbqEI/VeyNYfZwZ3zexdSbmuKQFFEfcqOO1O0K1ZncY0Ryex+4vCvs6NkwgIh
         YRtfFcOobZ/DKqGNw20YwLs9OUbGWUCRk8OVzEGxDrBv387D1IYGGfAwhU71z9TuQI
         +PFTproTDz9CHUz3ZgEJuVHRGRMa7Nz3oKJfdRgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5.1 41/54] genirq: Delay deactivation in free_irq()
Date:   Thu, 18 Jul 2019 12:01:36 +0900
Message-Id: <20190718030056.347427870@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4001d8e8762f57d418b66e4e668601791900a1dd upstream.

When interrupts are shutdown, they are immediately deactivated in the
irqdomain hierarchy. While this looks obviously correct there is a subtle
issue:

There might be an interrupt in flight when free_irq() is invoking the
shutdown. This is properly handled at the irq descriptor / primary handler
level, but the deactivation might completely disable resources which are
required to acknowledge the interrupt.

Split the shutdown code and deactivate the interrupt after synchronization
in free_irq(). Fixup all other usage sites where this is not an issue to
invoke the combined shutdown_and_deactivate() function instead.

This still might be an issue if the interrupt in flight servicing is
delayed on a remote CPU beyond the invocation of synchronize_irq(), but
that cannot be handled at that level and needs to be handled in the
synchronize_irq() context.

Fixes: f8264e34965a ("irqdomain: Introduce new interfaces to support hierarchy irqdomains")
Reported-by: Robert Hodaszi <Robert.Hodaszi@digi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/20190628111440.098196390@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/autoprobe.c  |    6 +++---
 kernel/irq/chip.c       |    6 ++++++
 kernel/irq/cpuhotplug.c |    2 +-
 kernel/irq/internals.h  |    1 +
 kernel/irq/manage.c     |   12 +++++++++++-
 5 files changed, 22 insertions(+), 5 deletions(-)

--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -90,7 +90,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(desc->istate & IRQS_WAITING)) {
 				desc->istate &= ~IRQS_AUTODETECT;
-				irq_shutdown(desc);
+				irq_shutdown_and_deactivate(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -127,7 +127,7 @@ unsigned int probe_irq_mask(unsigned lon
 				mask |= 1 << i;
 
 			desc->istate &= ~IRQS_AUTODETECT;
-			irq_shutdown(desc);
+			irq_shutdown_and_deactivate(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -169,7 +169,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->istate &= ~IRQS_AUTODETECT;
-			irq_shutdown(desc);
+			irq_shutdown_and_deactivate(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -314,6 +314,12 @@ void irq_shutdown(struct irq_desc *desc)
 		}
 		irq_state_clr_started(desc);
 	}
+}
+
+
+void irq_shutdown_and_deactivate(struct irq_desc *desc)
+{
+	irq_shutdown(desc);
 	/*
 	 * This must be called even if the interrupt was never started up,
 	 * because the activation can happen before the interrupt is
--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -116,7 +116,7 @@ static bool migrate_one_irq(struct irq_d
 		 */
 		if (irqd_affinity_is_managed(d)) {
 			irqd_set_managed_shutdown(d);
-			irq_shutdown(desc);
+			irq_shutdown_and_deactivate(desc);
 			return false;
 		}
 		affinity = cpu_online_mask;
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -82,6 +82,7 @@ extern int irq_activate_and_startup(stru
 extern int irq_startup(struct irq_desc *desc, bool resend, bool force);
 
 extern void irq_shutdown(struct irq_desc *desc);
+extern void irq_shutdown_and_deactivate(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
 extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
@@ -1699,6 +1700,7 @@ static struct irqaction *__free_irq(stru
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		irq_settings_clr_disable_unlazy(desc);
+		/* Only shutdown. Deactivate after synchronize_hardirq() */
 		irq_shutdown(desc);
 	}
 
@@ -1768,6 +1770,14 @@ static struct irqaction *__free_irq(stru
 		 * require it to deallocate resources over the slow bus.
 		 */
 		chip_bus_lock(desc);
+		/*
+		 * There is no interrupt on the fly anymore. Deactivate it
+		 * completely.
+		 */
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		irq_domain_deactivate_irq(&desc->irq_data);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+
 		irq_release_resources(desc);
 		chip_bus_sync_unlock(desc);
 		irq_remove_timings(desc);
@@ -1855,7 +1865,7 @@ static const void *__cleanup_nmi(unsigne
 	}
 
 	irq_settings_clr_disable_unlazy(desc);
-	irq_shutdown(desc);
+	irq_shutdown_and_deactivate(desc);
 
 	irq_release_resources(desc);
 


