Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4A6C59E
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390703AbfGRDIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390692AbfGRDIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:18 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 406FB2173E;
        Thu, 18 Jul 2019 03:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419297;
        bh=T9eQoAiIWPYnbZC12RBVVTjmAPmTLoPHD2f9MjtfjP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfOmZWmW42sUPVblrHzBdzIrKwxrNH4XOHD/UuJVqqveganEWBpS/fqtPHwRSkZ3Z
         pyrpdt3NZDXLg546548baf76BAO3Hpdwm+9kIH3Psb6Vpzb6h9ShP0V1YuHf4tUoTG
         Hu2sN9d1+iVT5HymwRZB59lmCwhUzgRchcEroPt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4.19 33/47] x86/ioapic: Implement irq_get_irqchip_state() callback
Date:   Thu, 18 Jul 2019 12:01:47 +0900
Message-Id: <20190718030051.546207484@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner tglx@linutronix.de

commit dfe0cf8b51b07e56ded571e3de0a4a9382517231 upstream

When an interrupt is shut down in free_irq() there might be an inflight
interrupt pending in the IO-APIC remote IRR which is not yet serviced. That
means the interrupt has been sent to the target CPUs local APIC, but the
target CPU is in a state which delays the servicing.

So free_irq() would proceed to free resources and to clear the vector
because synchronize_hardirq() does not see an interrupt handler in
progress.

That can trigger a spurious interrupt warning, which is harmless and just
confuses users, but it also can leave the remote IRR in a stale state
because once the handler is invoked the interrupt resources might be freed
already and therefore acknowledgement is not possible anymore.

Implement the irq_get_irqchip_state() callback for the IO-APIC irq chip. The
callback is invoked from free_irq() via __synchronize_hardirq(). Check the
remote IRR bit of the interrupt and return 'in flight' if it is set and the
interrupt is configured in level mode. For edge mode the remote IRR has no
meaning.

As this is only meaningful for level triggered interrupts this won't cure
the potential spurious interrupt warning for edge triggered interrupts, but
the edge trigger case does not result in stale hardware state. This has to
be addressed at the vector/interrupt entry level seperately.

Fixes: 464d12309e1b ("x86/vector: Switch IOAPIC to global reservation mode")
Reported-by: Robert Hodaszi <Robert.Hodaszi@digi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/20190628111440.370295517@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/kernel/apic/io_apic.c |   46 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1891,6 +1891,50 @@ static int ioapic_set_affinity(struct ir
 	return ret;
 }
 
+/*
+ * Interrupt shutdown masks the ioapic pin, but the interrupt might already
+ * be in flight, but not yet serviced by the target CPU. That means
+ * __synchronize_hardirq() would return and claim that everything is calmed
+ * down. So free_irq() would proceed and deactivate the interrupt and free
+ * resources.
+ *
+ * Once the target CPU comes around to service it it will find a cleared
+ * vector and complain. While the spurious interrupt is harmless, the full
+ * release of resources might prevent the interrupt from being acknowledged
+ * which keeps the hardware in a weird state.
+ *
+ * Verify that the corresponding Remote-IRR bits are clear.
+ */
+static int ioapic_irq_get_chip_state(struct irq_data *irqd,
+				   enum irqchip_irq_state which,
+				   bool *state)
+{
+	struct mp_chip_data *mcd = irqd->chip_data;
+	struct IO_APIC_route_entry rentry;
+	struct irq_pin_list *p;
+
+	if (which != IRQCHIP_STATE_ACTIVE)
+		return -EINVAL;
+
+	*state = false;
+	raw_spin_lock(&ioapic_lock);
+	for_each_irq_pin(p, mcd->irq_2_pin) {
+		rentry = __ioapic_read_entry(p->apic, p->pin);
+		/*
+		 * The remote IRR is only valid in level trigger mode. It's
+		 * meaning is undefined for edge triggered interrupts and
+		 * irrelevant because the IO-APIC treats them as fire and
+		 * forget.
+		 */
+		if (rentry.irr && rentry.trigger) {
+			*state = true;
+			break;
+		}
+	}
+	raw_spin_unlock(&ioapic_lock);
+	return 0;
+}
+
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
 	.irq_startup		= startup_ioapic_irq,
@@ -1900,6 +1944,7 @@ static struct irq_chip ioapic_chip __rea
 	.irq_eoi		= ioapic_ack_level,
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -1912,6 +1957,7 @@ static struct irq_chip ioapic_ir_chip __
 	.irq_eoi		= ioapic_ir_ack_level,
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 


