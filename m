Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F23A4EEE2
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 20:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfFUSrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 14:47:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:53452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbfFUSrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 14:47:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03377AEE0;
        Fri, 21 Jun 2019 18:47:06 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] xen/events: fix binding user event channels to cpus
Date:   Fri, 21 Jun 2019 20:47:03 +0200
Message-Id: <20190621184703.17108-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When binding an interdomain event channel to a vcpu via
IOCTL_EVTCHN_BIND_INTERDOMAIN not only the event channel needs to be
bound, but the affinity of the associated IRQi must be changed, too.
Otherwise the IRQ and the event channel won't be moved to another vcpu
in case the original vcpu they were bound to is going offline.

Cc: <stable@vger.kernel.org> # 4.13
Fixes: c48f64ab472389df ("xen-evtchn: Bind dyn evtchn:qemu-dm interrupt to next online VCPU")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/events/events_base.c | 12 ++++++++++--
 drivers/xen/evtchn.c             |  2 +-
 include/xen/events.h             |  3 ++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index ff9b51055b14..e718c8fea18b 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1294,7 +1294,7 @@ void rebind_evtchn_irq(int evtchn, int irq)
 }
 
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-int xen_rebind_evtchn_to_cpu(int evtchn, unsigned tcpu)
+static int xen_rebind_evtchn_to_cpu(int evtchn, unsigned int tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
 	int masked;
@@ -1328,7 +1328,6 @@ int xen_rebind_evtchn_to_cpu(int evtchn, unsigned tcpu)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xen_rebind_evtchn_to_cpu);
 
 static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
 			    bool force)
@@ -1342,6 +1341,15 @@ static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
 	return ret;
 }
 
+/* To be called with desc->lock held. */
+int xen_set_affinity_evtchn(struct irq_desc *desc, unsigned int tcpu)
+{
+	struct irq_data *d = irq_desc_get_irq_data(desc);
+
+	return set_affinity_irq(d, cpumask_of(tcpu), false);
+}
+EXPORT_SYMBOL_GPL(xen_set_affinity_evtchn);
+
 static void enable_dynirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index f341b016672f..052b55a14ebc 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -447,7 +447,7 @@ static void evtchn_bind_interdom_next_vcpu(int evtchn)
 	this_cpu_write(bind_last_selected_cpu, selected_cpu);
 
 	/* unmask expects irqs to be disabled */
-	xen_rebind_evtchn_to_cpu(evtchn, selected_cpu);
+	xen_set_affinity_evtchn(desc, selected_cpu);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
diff --git a/include/xen/events.h b/include/xen/events.h
index a48897199975..c0e6a0598397 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -3,6 +3,7 @@
 #define _XEN_EVENTS_H
 
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #ifdef CONFIG_PCI_MSI
 #include <linux/msi.h>
 #endif
@@ -59,7 +60,7 @@ void evtchn_put(unsigned int evtchn);
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
 void rebind_evtchn_irq(int evtchn, int irq);
-int xen_rebind_evtchn_to_cpu(int evtchn, unsigned tcpu);
+int xen_set_affinity_evtchn(struct irq_desc *desc, unsigned int tcpu);
 
 static inline void notify_remote_via_evtchn(int port)
 {
-- 
2.16.4

