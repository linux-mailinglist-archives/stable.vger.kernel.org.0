Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDFD2A274B
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 10:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgKBJql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 04:46:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:59248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbgKBJql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 04:46:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604310398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXSDIvgiglFyOtyn6eqOip47nX2DiCg3mqCFE+l1JH4=;
        b=q1ZOs/n/BBzUfi/6esZX0GWO+Lz5yx24RRuUanHA6C/Numvl8vMkQ6BVDoopVHrRF3M7CC
        FOLsOtFppaT9JxZOQeMqiZX/CJJ7UmnO4N7duAsgo7WCZwG/pzCX0P5INnqFiuHigUCTLj
        CEyeocUpNjEljaNgYHJiEPNYoyIkpE4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C8294AE08
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 09:46:38 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 04/13] xen/events: add a new "late EOI" evtchn framework
Date:   Mon,  2 Nov 2020 10:46:29 +0100
Message-Id: <20201102094638.3355-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102094638.3355-1-jgross@suse.com>
References: <20201102094638.3355-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to avoid tight event channel related IRQ loops add a new
framework of "late EOI" handling: the IRQ the event channel is bound
to will be masked until the event has been handled and the related
driver is capable to handle another event. The driver is responsible
for unmasking the event channel via the new function xen_irq_lateeoi().

This is similar to binding an event channel to a threaded IRQ, but
without having to structure the driver accordingly.

In order to support a future special handling in case a rogue guest
is sending lots of unsolicited events, add a flag to xen_irq_lateeoi()
which can be set by the caller to indicate the event was a spurious
one.

This is part of XSA-332.

This is upstream commit 54c9de89895e0a36047fcc4ae754ea5b8655fb9d

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/events/events_base.c | 151 +++++++++++++++++++++++++++----
 include/xen/events.h             |  29 +++++-
 2 files changed, 159 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index eccfe0b0533f..6f3041fce48d 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -112,6 +112,7 @@ static bool (*pirq_needs_eoi)(unsigned irq);
 static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
 
 static struct irq_chip xen_dynamic_chip;
+static struct irq_chip xen_lateeoi_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
 static void enable_dynirq(struct irq_data *data);
@@ -396,6 +397,33 @@ void notify_remote_via_irq(int irq)
 }
 EXPORT_SYMBOL_GPL(notify_remote_via_irq);
 
+static void xen_irq_lateeoi_locked(struct irq_info *info)
+{
+	evtchn_port_t evtchn;
+
+	evtchn = info->evtchn;
+	if (!VALID_EVTCHN(evtchn))
+		return;
+
+	unmask_evtchn(evtchn);
+}
+
+void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags)
+{
+	struct irq_info *info;
+	unsigned long flags;
+
+	read_lock_irqsave(&evtchn_rwlock, flags);
+
+	info = info_for_irq(irq);
+
+	if (info)
+		xen_irq_lateeoi_locked(info);
+
+	read_unlock_irqrestore(&evtchn_rwlock, flags);
+}
+EXPORT_SYMBOL_GPL(xen_irq_lateeoi);
+
 static void xen_irq_init(unsigned irq)
 {
 	struct irq_info *info;
@@ -867,7 +895,7 @@ int xen_pirq_from_irq(unsigned irq)
 }
 EXPORT_SYMBOL_GPL(xen_pirq_from_irq);
 
-int bind_evtchn_to_irq(unsigned int evtchn)
+static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip)
 {
 	int irq;
 	int ret;
@@ -884,7 +912,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		if (irq < 0)
 			goto out;
 
-		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
+		irq_set_chip_and_handler_name(irq, chip,
 					      handle_edge_irq, "event");
 
 		ret = xen_irq_info_evtchn_setup(irq, evtchn);
@@ -905,8 +933,19 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 
 	return irq;
 }
+
+int bind_evtchn_to_irq(evtchn_port_t evtchn)
+{
+	return bind_evtchn_to_irq_chip(evtchn, &xen_dynamic_chip);
+}
 EXPORT_SYMBOL_GPL(bind_evtchn_to_irq);
 
+int bind_evtchn_to_irq_lateeoi(evtchn_port_t evtchn)
+{
+	return bind_evtchn_to_irq_chip(evtchn, &xen_lateeoi_chip);
+}
+EXPORT_SYMBOL_GPL(bind_evtchn_to_irq_lateeoi);
+
 static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 {
 	struct evtchn_bind_ipi bind_ipi;
@@ -948,8 +987,9 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 	return irq;
 }
 
-int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
-				   unsigned int remote_port)
+static int bind_interdomain_evtchn_to_irq_chip(unsigned int remote_domain,
+					       evtchn_port_t remote_port,
+					       struct irq_chip *chip)
 {
 	struct evtchn_bind_interdomain bind_interdomain;
 	int err;
@@ -960,10 +1000,26 @@ int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
 	err = HYPERVISOR_event_channel_op(EVTCHNOP_bind_interdomain,
 					  &bind_interdomain);
 
-	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
+	return err ? : bind_evtchn_to_irq_chip(bind_interdomain.local_port,
+					       chip);
+}
+
+int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
+				   evtchn_port_t remote_port)
+{
+	return bind_interdomain_evtchn_to_irq_chip(remote_domain, remote_port,
+						   &xen_dynamic_chip);
 }
 EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq);
 
+int bind_interdomain_evtchn_to_irq_lateeoi(unsigned int remote_domain,
+					   evtchn_port_t remote_port)
+{
+	return bind_interdomain_evtchn_to_irq_chip(remote_domain, remote_port,
+						   &xen_lateeoi_chip);
+}
+EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq_lateeoi);
+
 static int find_virq(unsigned int virq, unsigned int cpu)
 {
 	struct evtchn_status status;
@@ -1059,14 +1115,15 @@ static void unbind_from_irq(unsigned int irq)
 	mutex_unlock(&irq_mapping_update_lock);
 }
 
-int bind_evtchn_to_irqhandler(unsigned int evtchn,
-			      irq_handler_t handler,
-			      unsigned long irqflags,
-			      const char *devname, void *dev_id)
+static int bind_evtchn_to_irqhandler_chip(evtchn_port_t evtchn,
+					  irq_handler_t handler,
+					  unsigned long irqflags,
+					  const char *devname, void *dev_id,
+					  struct irq_chip *chip)
 {
 	int irq, retval;
 
-	irq = bind_evtchn_to_irq(evtchn);
+	irq = bind_evtchn_to_irq_chip(evtchn, chip);
 	if (irq < 0)
 		return irq;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
@@ -1077,18 +1134,38 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 
 	return irq;
 }
+
+int bind_evtchn_to_irqhandler(evtchn_port_t evtchn,
+			      irq_handler_t handler,
+			      unsigned long irqflags,
+			      const char *devname, void *dev_id)
+{
+	return bind_evtchn_to_irqhandler_chip(evtchn, handler, irqflags,
+					      devname, dev_id,
+					      &xen_dynamic_chip);
+}
 EXPORT_SYMBOL_GPL(bind_evtchn_to_irqhandler);
 
-int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
-					  unsigned int remote_port,
-					  irq_handler_t handler,
-					  unsigned long irqflags,
-					  const char *devname,
-					  void *dev_id)
+int bind_evtchn_to_irqhandler_lateeoi(evtchn_port_t evtchn,
+				      irq_handler_t handler,
+				      unsigned long irqflags,
+				      const char *devname, void *dev_id)
+{
+	return bind_evtchn_to_irqhandler_chip(evtchn, handler, irqflags,
+					      devname, dev_id,
+					      &xen_lateeoi_chip);
+}
+EXPORT_SYMBOL_GPL(bind_evtchn_to_irqhandler_lateeoi);
+
+static int bind_interdomain_evtchn_to_irqhandler_chip(
+		unsigned int remote_domain, evtchn_port_t remote_port,
+		irq_handler_t handler, unsigned long irqflags,
+		const char *devname, void *dev_id, struct irq_chip *chip)
 {
 	int irq, retval;
 
-	irq = bind_interdomain_evtchn_to_irq(remote_domain, remote_port);
+	irq = bind_interdomain_evtchn_to_irq_chip(remote_domain, remote_port,
+						  chip);
 	if (irq < 0)
 		return irq;
 
@@ -1100,8 +1177,33 @@ int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
 
 	return irq;
 }
+
+int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
+					  evtchn_port_t remote_port,
+					  irq_handler_t handler,
+					  unsigned long irqflags,
+					  const char *devname,
+					  void *dev_id)
+{
+	return bind_interdomain_evtchn_to_irqhandler_chip(remote_domain,
+				remote_port, handler, irqflags, devname,
+				dev_id, &xen_dynamic_chip);
+}
 EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irqhandler);
 
+int bind_interdomain_evtchn_to_irqhandler_lateeoi(unsigned int remote_domain,
+						  evtchn_port_t remote_port,
+						  irq_handler_t handler,
+						  unsigned long irqflags,
+						  const char *devname,
+						  void *dev_id)
+{
+	return bind_interdomain_evtchn_to_irqhandler_chip(remote_domain,
+				remote_port, handler, irqflags, devname,
+				dev_id, &xen_lateeoi_chip);
+}
+EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irqhandler_lateeoi);
+
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
 			    unsigned long irqflags, const char *devname, void *dev_id)
@@ -1646,6 +1748,21 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.irq_retrigger		= retrigger_dynirq,
 };
 
+static struct irq_chip xen_lateeoi_chip __read_mostly = {
+	/* The chip name needs to contain "xen-dyn" for irqbalance to work. */
+	.name			= "xen-dyn-lateeoi",
+
+	.irq_disable		= disable_dynirq,
+	.irq_mask		= disable_dynirq,
+	.irq_unmask		= enable_dynirq,
+
+	.irq_ack		= mask_ack_dynirq,
+	.irq_mask_ack		= mask_ack_dynirq,
+
+	.irq_set_affinity	= set_affinity_irq,
+	.irq_retrigger		= retrigger_dynirq,
+};
+
 static struct irq_chip xen_pirq_chip __read_mostly = {
 	.name			= "xen-pirq",
 
diff --git a/include/xen/events.h b/include/xen/events.h
index c0e6a0598397..31952308a6d5 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -14,11 +14,16 @@
 
 unsigned xen_evtchn_nr_channels(void);
 
-int bind_evtchn_to_irq(unsigned int evtchn);
-int bind_evtchn_to_irqhandler(unsigned int evtchn,
+int bind_evtchn_to_irq(evtchn_port_t evtchn);
+int bind_evtchn_to_irq_lateeoi(evtchn_port_t evtchn);
+int bind_evtchn_to_irqhandler(evtchn_port_t evtchn,
 			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,
 			      void *dev_id);
+int bind_evtchn_to_irqhandler_lateeoi(evtchn_port_t evtchn,
+				      irq_handler_t handler,
+				      unsigned long irqflags, const char *devname,
+				      void *dev_id);
 int bind_virq_to_irq(unsigned int virq, unsigned int cpu, bool percpu);
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
@@ -31,13 +36,21 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 			   const char *devname,
 			   void *dev_id);
 int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
-				   unsigned int remote_port);
+				   evtchn_port_t remote_port);
+int bind_interdomain_evtchn_to_irq_lateeoi(unsigned int remote_domain,
+					   evtchn_port_t remote_port);
 int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
-					  unsigned int remote_port,
+					  evtchn_port_t remote_port,
 					  irq_handler_t handler,
 					  unsigned long irqflags,
 					  const char *devname,
 					  void *dev_id);
+int bind_interdomain_evtchn_to_irqhandler_lateeoi(unsigned int remote_domain,
+						  evtchn_port_t remote_port,
+						  irq_handler_t handler,
+						  unsigned long irqflags,
+						  const char *devname,
+						  void *dev_id);
 
 /*
  * Common unbind function for all event sources. Takes IRQ to unbind from.
@@ -46,6 +59,14 @@ int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
  */
 void unbind_from_irqhandler(unsigned int irq, void *dev_id);
 
+/*
+ * Send late EOI for an IRQ bound to an event channel via one of the *_lateeoi
+ * functions above.
+ */
+void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags);
+/* Signal an event was spurious, i.e. there was no action resulting from it. */
+#define XEN_EOI_FLAG_SPURIOUS	0x00000001
+
 #define XEN_IRQ_PRIORITY_MAX     EVTCHN_FIFO_PRIORITY_MAX
 #define XEN_IRQ_PRIORITY_DEFAULT EVTCHN_FIFO_PRIORITY_DEFAULT
 #define XEN_IRQ_PRIORITY_MIN     EVTCHN_FIFO_PRIORITY_MIN
-- 
2.26.2

