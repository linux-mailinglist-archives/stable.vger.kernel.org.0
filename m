Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B312A59C2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgKCUhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729817AbgKCUht (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:37:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017082224E;
        Tue,  3 Nov 2020 20:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435867;
        bh=3b5R3CvkrwmL/K0Sj+vFFFGJcW21TJz+PahkD6ogz54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbISAFv6Gb3WK6H9h/mHQRtwK2TA1TftD0beXryULdi8PuqDcxR6gp1OqJQv0EvaU
         dT0WNFMNi61/cO/HXZEcXV3GB+jQuhY7H2klc9lJ2c1r+sBGeeKaaD/cl7Qujl8FuN
         VRmEG1Bx0cPHPzx66gyoVzFKLaxpJXH0SEWCnM8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: [PATCH 5.9 004/391] xen/events: add a new "late EOI" evtchn framework
Date:   Tue,  3 Nov 2020 21:30:55 +0100
Message-Id: <20201103203348.416984184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 54c9de89895e0a36047fcc4ae754ea5b8655fb9d upstream.

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

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_base.c |  151 ++++++++++++++++++++++++++++++++++-----
 include/xen/events.h             |   21 +++++
 2 files changed, 155 insertions(+), 17 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -113,6 +113,7 @@ static bool (*pirq_needs_eoi)(unsigned i
 static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
 
 static struct irq_chip xen_dynamic_chip;
+static struct irq_chip xen_lateeoi_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
 static void enable_dynirq(struct irq_data *data);
@@ -397,6 +398,33 @@ void notify_remote_via_irq(int irq)
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
@@ -868,7 +896,7 @@ int xen_pirq_from_irq(unsigned irq)
 }
 EXPORT_SYMBOL_GPL(xen_pirq_from_irq);
 
-int bind_evtchn_to_irq(evtchn_port_t evtchn)
+static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip)
 {
 	int irq;
 	int ret;
@@ -885,7 +913,7 @@ int bind_evtchn_to_irq(evtchn_port_t evt
 		if (irq < 0)
 			goto out;
 
-		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
+		irq_set_chip_and_handler_name(irq, chip,
 					      handle_edge_irq, "event");
 
 		ret = xen_irq_info_evtchn_setup(irq, evtchn);
@@ -906,8 +934,19 @@ out:
 
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
@@ -949,8 +988,9 @@ static int bind_ipi_to_irq(unsigned int
 	return irq;
 }
 
-int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
-				   evtchn_port_t remote_port)
+static int bind_interdomain_evtchn_to_irq_chip(unsigned int remote_domain,
+					       evtchn_port_t remote_port,
+					       struct irq_chip *chip)
 {
 	struct evtchn_bind_interdomain bind_interdomain;
 	int err;
@@ -961,10 +1001,26 @@ int bind_interdomain_evtchn_to_irq(unsig
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
 static int find_virq(unsigned int virq, unsigned int cpu, evtchn_port_t *evtchn)
 {
 	struct evtchn_status status;
@@ -1061,14 +1117,15 @@ static void unbind_from_irq(unsigned int
 	mutex_unlock(&irq_mapping_update_lock);
 }
 
-int bind_evtchn_to_irqhandler(evtchn_port_t evtchn,
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
@@ -1079,18 +1136,38 @@ int bind_evtchn_to_irqhandler(evtchn_por
 
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
-					  evtchn_port_t remote_port,
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
 
@@ -1102,8 +1179,33 @@ int bind_interdomain_evtchn_to_irqhandle
 
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
@@ -1634,6 +1736,21 @@ static struct irq_chip xen_dynamic_chip
 	.irq_mask_ack		= mask_ack_dynirq,
 
 	.irq_set_affinity	= set_affinity_irq,
+	.irq_retrigger		= retrigger_dynirq,
+};
+
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
 	.irq_retrigger		= retrigger_dynirq,
 };
 
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -15,10 +15,15 @@
 unsigned xen_evtchn_nr_channels(void);
 
 int bind_evtchn_to_irq(evtchn_port_t evtchn);
+int bind_evtchn_to_irq_lateeoi(evtchn_port_t evtchn);
 int bind_evtchn_to_irqhandler(evtchn_port_t evtchn,
 			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,
 			      void *dev_id);
+int bind_evtchn_to_irqhandler_lateeoi(evtchn_port_t evtchn,
+			      irq_handler_t handler,
+			      unsigned long irqflags, const char *devname,
+			      void *dev_id);
 int bind_virq_to_irq(unsigned int virq, unsigned int cpu, bool percpu);
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
@@ -32,12 +37,20 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 			   void *dev_id);
 int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
 				   evtchn_port_t remote_port);
+int bind_interdomain_evtchn_to_irq_lateeoi(unsigned int remote_domain,
+					   evtchn_port_t remote_port);
 int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
 					  evtchn_port_t remote_port,
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
@@ -46,6 +59,14 @@ int bind_interdomain_evtchn_to_irqhandle
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


