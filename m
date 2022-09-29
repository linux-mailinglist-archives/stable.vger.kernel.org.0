Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31AD5EFF0E
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiI2VIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiI2VH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:07:58 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FCC1B95C0;
        Thu, 29 Sep 2022 14:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485678; x=1696021678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XhYF8rZOoKFacUMCVB3oEurglWDcnVMOCVxLu6rDayk=;
  b=Wa99g0E8brNVegeiwEngfvQuXivXd6WP2sNbTp7MKDaRNk9pB3oZLQT/
   pDydJI0gq4Fu36+5N3dS7lS+tSLHtgrEx68BzBlmsdekb5ZIDFmgJVyFw
   B2DgIWe+8CHAVzKpQ/R4HQO10wIY5wK1po4sj43fj9oS8BRhKfSV8PU+j
   A=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="264663810"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:07:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id E4AF945E7E;
        Thu, 29 Sep 2022 21:07:56 +0000 (UTC)
Received: from EX19D012UWB002.ant.amazon.com (10.13.138.53) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:07:54 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D012UWB002.ant.amazon.com (10.13.138.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Thu, 29 Sep 2022 21:07:54 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 25801286C; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 3/6] genirq: Delay deactivation in free_irq()
Date:   Thu, 29 Sep 2022 21:06:48 +0000
Message-ID: <20220929210651.12308-4-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-14.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 kernel/irq/autoprobe.c  |  6 +++---
 kernel/irq/chip.c       |  6 ++++++
 kernel/irq/cpuhotplug.c |  2 +-
 kernel/irq/internals.h  |  1 +
 kernel/irq/manage.c     | 10 ++++++++++
 5 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index befa671fba64..39ff9ab34e82 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -92,7 +92,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(desc->istate & IRQS_WAITING)) {
 				desc->istate &= ~IRQS_AUTODETECT;
-				irq_shutdown(desc);
+				irq_shutdown_and_deactivate(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -129,7 +129,7 @@ unsigned int probe_irq_mask(unsigned long val)
 				mask |= 1 << i;
 
 			desc->istate &= ~IRQS_AUTODETECT;
-			irq_shutdown(desc);
+			irq_shutdown_and_deactivate(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -171,7 +171,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->istate &= ~IRQS_AUTODETECT;
-			irq_shutdown(desc);
+			irq_shutdown_and_deactivate(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 317fc759de76..1936d86db883 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -293,6 +293,12 @@ void irq_shutdown(struct irq_desc *desc)
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
diff --git a/kernel/irq/cpuhotplug.c b/kernel/irq/cpuhotplug.c
index 9eb09aef0313..a9f931217a1b 100644
--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -115,7 +115,7 @@ static bool migrate_one_irq(struct irq_desc *desc)
 		 */
 		if (irqd_affinity_is_managed(d)) {
 			irqd_set_managed_shutdown(d);
-			irq_shutdown(desc);
+			irq_shutdown_and_deactivate(desc);
 			return false;
 		}
 		affinity = cpu_online_mask;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 5230c47fc43e..3de3821ab5fe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -78,6 +78,7 @@ extern void __enable_irq(struct irq_desc *desc);
 extern int irq_startup(struct irq_desc *desc, bool resend, bool force);
 
 extern void irq_shutdown(struct irq_desc *desc);
+extern void irq_shutdown_and_deactivate(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
 extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 722aeaae92b1..4e4fc7879307 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
@@ -1604,6 +1605,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		irq_settings_clr_disable_unlazy(desc);
+		/* Only shutdown. Deactivate after synchronize_hardirq() */
 		irq_shutdown(desc);
 	}
 
@@ -1673,6 +1675,14 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
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
-- 
2.37.1

