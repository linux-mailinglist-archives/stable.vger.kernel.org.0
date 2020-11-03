Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2A2A5111
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgKCUhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbgKCUhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:37:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C48C2224E;
        Tue,  3 Nov 2020 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435855;
        bh=PQLLeU0ovkCY9TWt3RzpFNSBqdoFeNweHJIjL7NR+lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQKPP1upJ31OVwE+gCJEWlijq6lIKwq1+5Gg0Gh34arUtDRfaR4++QgpA0/b0yxb7
         NMVkfrmXjIq0GR8TAqttcwsyQfuWoLN7PR35i5BYjO3sRRBKDXPKz6EDVxiNvAulvh
         NQLjZ3bqIL0vCi976SnUDRDx05TL9SiJFJwSRbu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: [PATCH 5.9 012/391] xen/events: defer eoi in case of excessive number of events
Date:   Tue,  3 Nov 2020 21:31:03 +0100
Message-Id: <20201103203348.845899125@linuxfoundation.org>
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

commit e99502f76271d6bc4e374fe368c50c67a1fd3070 upstream.

In case rogue guests are sending events at high frequency it might
happen that xen_evtchn_do_upcall() won't stop processing events in
dom0. As this is done in irq handling a crash might be the result.

In order to avoid that, delay further inter-domain events after some
time in xen_evtchn_do_upcall() by forcing eoi processing into a
worker on the same cpu, thus inhibiting new events coming in.

The time after which eoi processing is to be delayed is configurable
via a new module parameter "event_loop_timeout" which specifies the
maximum event loop time in jiffies (default: 2, the value was chosen
after some tests showing that a value of 2 was the lowest with an
only slight drop of dom0 network throughput while multiple guests
performed an event storm).

How long eoi processing will be delayed can be specified via another
parameter "event_eoi_delay" (again in jiffies, default 10, again the
value was chosen after testing with different delay values).

This is part of XSA-332.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    8 +
 drivers/xen/events/events_2l.c                  |    7 
 drivers/xen/events/events_base.c                |  189 +++++++++++++++++++++++-
 drivers/xen/events/events_fifo.c                |   30 +--
 drivers/xen/events/events_internal.h            |   14 +
 5 files changed, 216 insertions(+), 32 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5828,6 +5828,14 @@
 			improve timer resolution at the expense of processing
 			more timer interrupts.
 
+	xen.event_eoi_delay=	[XEN]
+			How long to delay EOI handling in case of event
+			storms (jiffies). Default is 10.
+
+	xen.event_loop_timeout=	[XEN]
+			After which time (jiffies) the event handling loop
+			should start to delay EOI handling. Default is 2.
+
 	nopv=		[X86,XEN,KVM,HYPER_V,VMWARE]
 			Disables the PV optimizations forcing the guest to run
 			as generic guest with no PV drivers. Currently support
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -161,7 +161,7 @@ static inline xen_ulong_t active_evtchns
  * a bitset of words which contain pending event bits.  The second
  * level is a bitset of pending events themselves.
  */
-static void evtchn_2l_handle_events(unsigned cpu)
+static void evtchn_2l_handle_events(unsigned cpu, struct evtchn_loop_ctrl *ctrl)
 {
 	int irq;
 	xen_ulong_t pending_words;
@@ -242,10 +242,7 @@ static void evtchn_2l_handle_events(unsi
 
 			/* Process port. */
 			port = (word_idx * BITS_PER_EVTCHN_WORD) + bit_idx;
-			irq = get_evtchn_to_irq(port);
-
-			if (irq != -1)
-				generic_handle_irq(irq);
+			handle_irq_for_port(port, ctrl);
 
 			bit_idx = (bit_idx + 1) % BITS_PER_EVTCHN_WORD;
 
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -35,6 +35,8 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/cpuhotplug.h>
+#include <linux/atomic.h>
+#include <linux/ktime.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -65,6 +67,15 @@
 
 #include "events_internal.h"
 
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "xen."
+
+static uint __read_mostly event_loop_timeout = 2;
+module_param(event_loop_timeout, uint, 0644);
+
+static uint __read_mostly event_eoi_delay = 10;
+module_param(event_eoi_delay, uint, 0644);
+
 const struct evtchn_ops *evtchn_ops;
 
 /*
@@ -88,6 +99,7 @@ static DEFINE_RWLOCK(evtchn_rwlock);
  * irq_mapping_update_lock
  *   evtchn_rwlock
  *     IRQ-desc lock
+ *       percpu eoi_list_lock
  */
 
 static LIST_HEAD(xen_irq_list_head);
@@ -120,6 +132,8 @@ static struct irq_chip xen_pirq_chip;
 static void enable_dynirq(struct irq_data *data);
 static void disable_dynirq(struct irq_data *data);
 
+static DEFINE_PER_CPU(unsigned int, irq_epoch);
+
 static void clear_evtchn_to_irq_row(unsigned row)
 {
 	unsigned col;
@@ -399,17 +413,120 @@ void notify_remote_via_irq(int irq)
 }
 EXPORT_SYMBOL_GPL(notify_remote_via_irq);
 
+struct lateeoi_work {
+	struct delayed_work delayed;
+	spinlock_t eoi_list_lock;
+	struct list_head eoi_list;
+};
+
+static DEFINE_PER_CPU(struct lateeoi_work, lateeoi);
+
+static void lateeoi_list_del(struct irq_info *info)
+{
+	struct lateeoi_work *eoi = &per_cpu(lateeoi, info->eoi_cpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&eoi->eoi_list_lock, flags);
+	list_del_init(&info->eoi_list);
+	spin_unlock_irqrestore(&eoi->eoi_list_lock, flags);
+}
+
+static void lateeoi_list_add(struct irq_info *info)
+{
+	struct lateeoi_work *eoi = &per_cpu(lateeoi, info->eoi_cpu);
+	struct irq_info *elem;
+	u64 now = get_jiffies_64();
+	unsigned long delay;
+	unsigned long flags;
+
+	if (now < info->eoi_time)
+		delay = info->eoi_time - now;
+	else
+		delay = 1;
+
+	spin_lock_irqsave(&eoi->eoi_list_lock, flags);
+
+	if (list_empty(&eoi->eoi_list)) {
+		list_add(&info->eoi_list, &eoi->eoi_list);
+		mod_delayed_work_on(info->eoi_cpu, system_wq,
+				    &eoi->delayed, delay);
+	} else {
+		list_for_each_entry_reverse(elem, &eoi->eoi_list, eoi_list) {
+			if (elem->eoi_time <= info->eoi_time)
+				break;
+		}
+		list_add(&info->eoi_list, &elem->eoi_list);
+	}
+
+	spin_unlock_irqrestore(&eoi->eoi_list_lock, flags);
+}
+
 static void xen_irq_lateeoi_locked(struct irq_info *info)
 {
 	evtchn_port_t evtchn;
+	unsigned int cpu;
 
 	evtchn = info->evtchn;
-	if (!VALID_EVTCHN(evtchn))
+	if (!VALID_EVTCHN(evtchn) || !list_empty(&info->eoi_list))
 		return;
 
+	cpu = info->eoi_cpu;
+	if (info->eoi_time && info->irq_epoch == per_cpu(irq_epoch, cpu)) {
+		lateeoi_list_add(info);
+		return;
+	}
+
+	info->eoi_time = 0;
 	unmask_evtchn(evtchn);
 }
 
+static void xen_irq_lateeoi_worker(struct work_struct *work)
+{
+	struct lateeoi_work *eoi;
+	struct irq_info *info;
+	u64 now = get_jiffies_64();
+	unsigned long flags;
+
+	eoi = container_of(to_delayed_work(work), struct lateeoi_work, delayed);
+
+	read_lock_irqsave(&evtchn_rwlock, flags);
+
+	while (true) {
+		spin_lock(&eoi->eoi_list_lock);
+
+		info = list_first_entry_or_null(&eoi->eoi_list, struct irq_info,
+						eoi_list);
+
+		if (info == NULL || now < info->eoi_time) {
+			spin_unlock(&eoi->eoi_list_lock);
+			break;
+		}
+
+		list_del_init(&info->eoi_list);
+
+		spin_unlock(&eoi->eoi_list_lock);
+
+		info->eoi_time = 0;
+
+		xen_irq_lateeoi_locked(info);
+	}
+
+	if (info)
+		mod_delayed_work_on(info->eoi_cpu, system_wq,
+				    &eoi->delayed, info->eoi_time - now);
+
+	read_unlock_irqrestore(&evtchn_rwlock, flags);
+}
+
+static void xen_cpu_init_eoi(unsigned int cpu)
+{
+	struct lateeoi_work *eoi = &per_cpu(lateeoi, cpu);
+
+	INIT_DELAYED_WORK(&eoi->delayed, xen_irq_lateeoi_worker);
+	spin_lock_init(&eoi->eoi_list_lock);
+	INIT_LIST_HEAD(&eoi->eoi_list);
+}
+
 void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags)
 {
 	struct irq_info *info;
@@ -429,6 +546,7 @@ EXPORT_SYMBOL_GPL(xen_irq_lateeoi);
 static void xen_irq_init(unsigned irq)
 {
 	struct irq_info *info;
+
 #ifdef CONFIG_SMP
 	/* By default all event channels notify CPU#0. */
 	cpumask_copy(irq_get_affinity_mask(irq), cpumask_of(0));
@@ -443,6 +561,7 @@ static void xen_irq_init(unsigned irq)
 
 	set_info_for_irq(irq, info);
 
+	INIT_LIST_HEAD(&info->eoi_list);
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
 
@@ -498,6 +617,9 @@ static void xen_free_irq(unsigned irq)
 
 	write_lock_irqsave(&evtchn_rwlock, flags);
 
+	if (!list_empty(&info->eoi_list))
+		lateeoi_list_del(info);
+
 	list_del(&info->list);
 
 	set_info_for_irq(irq, NULL);
@@ -1358,17 +1480,66 @@ void xen_send_IPI_one(unsigned int cpu,
 	notify_remote_via_irq(irq);
 }
 
+struct evtchn_loop_ctrl {
+	ktime_t timeout;
+	unsigned count;
+	bool defer_eoi;
+};
+
+void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
+{
+	int irq;
+	struct irq_info *info;
+
+	irq = get_evtchn_to_irq(port);
+	if (irq == -1)
+		return;
+
+	/*
+	 * Check for timeout every 256 events.
+	 * We are setting the timeout value only after the first 256
+	 * events in order to not hurt the common case of few loop
+	 * iterations. The 256 is basically an arbitrary value.
+	 *
+	 * In case we are hitting the timeout we need to defer all further
+	 * EOIs in order to ensure to leave the event handling loop rather
+	 * sooner than later.
+	 */
+	if (!ctrl->defer_eoi && !(++ctrl->count & 0xff)) {
+		ktime_t kt = ktime_get();
+
+		if (!ctrl->timeout) {
+			kt = ktime_add_ms(kt,
+					  jiffies_to_msecs(event_loop_timeout));
+			ctrl->timeout = kt;
+		} else if (kt > ctrl->timeout) {
+			ctrl->defer_eoi = true;
+		}
+	}
+
+	info = info_for_irq(irq);
+
+	if (ctrl->defer_eoi) {
+		info->eoi_cpu = smp_processor_id();
+		info->irq_epoch = __this_cpu_read(irq_epoch);
+		info->eoi_time = get_jiffies_64() + event_eoi_delay;
+	}
+
+	generic_handle_irq(irq);
+}
+
 static void __xen_evtchn_do_upcall(void)
 {
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 	int cpu = smp_processor_id();
+	struct evtchn_loop_ctrl ctrl = { 0 };
 
 	read_lock(&evtchn_rwlock);
 
 	do {
 		vcpu_info->evtchn_upcall_pending = 0;
 
-		xen_evtchn_handle_events(cpu);
+		xen_evtchn_handle_events(cpu, &ctrl);
 
 		BUG_ON(!irqs_disabled());
 
@@ -1377,6 +1548,13 @@ static void __xen_evtchn_do_upcall(void)
 	} while (vcpu_info->evtchn_upcall_pending);
 
 	read_unlock(&evtchn_rwlock);
+
+	/*
+	 * Increment irq_epoch only now to defer EOIs only for
+	 * xen_irq_lateeoi() invocations occurring from inside the loop
+	 * above.
+	 */
+	__this_cpu_inc(irq_epoch);
 }
 
 void xen_evtchn_do_upcall(struct pt_regs *regs)
@@ -1825,9 +2003,6 @@ void xen_setup_callback_vector(void) {}
 static inline void xen_alloc_callback_vector(void) {}
 #endif
 
-#undef MODULE_PARAM_PREFIX
-#define MODULE_PARAM_PREFIX "xen."
-
 static bool fifo_events = true;
 module_param(fifo_events, bool, 0);
 
@@ -1835,6 +2010,8 @@ static int xen_evtchn_cpu_prepare(unsign
 {
 	int ret = 0;
 
+	xen_cpu_init_eoi(cpu);
+
 	if (evtchn_ops->percpu_init)
 		ret = evtchn_ops->percpu_init(cpu);
 
@@ -1861,6 +2038,8 @@ void __init xen_init_IRQ(void)
 	if (ret < 0)
 		xen_evtchn_2l_init();
 
+	xen_cpu_init_eoi(smp_processor_id());
+
 	cpuhp_setup_state_nocalls(CPUHP_XEN_EVTCHN_PREPARE,
 				  "xen/evtchn:prepare",
 				  xen_evtchn_cpu_prepare, xen_evtchn_cpu_dead);
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -275,19 +275,9 @@ static uint32_t clear_linked(volatile ev
 	return w & EVTCHN_FIFO_LINK_MASK;
 }
 
-static void handle_irq_for_port(evtchn_port_t port)
-{
-	int irq;
-
-	irq = get_evtchn_to_irq(port);
-	if (irq != -1)
-		generic_handle_irq(irq);
-}
-
-static void consume_one_event(unsigned cpu,
+static void consume_one_event(unsigned cpu, struct evtchn_loop_ctrl *ctrl,
 			      struct evtchn_fifo_control_block *control_block,
-			      unsigned priority, unsigned long *ready,
-			      bool drop)
+			      unsigned priority, unsigned long *ready)
 {
 	struct evtchn_fifo_queue *q = &per_cpu(cpu_queue, cpu);
 	uint32_t head;
@@ -320,16 +310,17 @@ static void consume_one_event(unsigned c
 		clear_bit(priority, ready);
 
 	if (evtchn_fifo_is_pending(port) && !evtchn_fifo_is_masked(port)) {
-		if (unlikely(drop))
+		if (unlikely(!ctrl))
 			pr_warn("Dropping pending event for port %u\n", port);
 		else
-			handle_irq_for_port(port);
+			handle_irq_for_port(port, ctrl);
 	}
 
 	q->head[priority] = head;
 }
 
-static void __evtchn_fifo_handle_events(unsigned cpu, bool drop)
+static void __evtchn_fifo_handle_events(unsigned cpu,
+					struct evtchn_loop_ctrl *ctrl)
 {
 	struct evtchn_fifo_control_block *control_block;
 	unsigned long ready;
@@ -341,14 +332,15 @@ static void __evtchn_fifo_handle_events(
 
 	while (ready) {
 		q = find_first_bit(&ready, EVTCHN_FIFO_MAX_QUEUES);
-		consume_one_event(cpu, control_block, q, &ready, drop);
+		consume_one_event(cpu, ctrl, control_block, q, &ready);
 		ready |= xchg(&control_block->ready, 0);
 	}
 }
 
-static void evtchn_fifo_handle_events(unsigned cpu)
+static void evtchn_fifo_handle_events(unsigned cpu,
+				      struct evtchn_loop_ctrl *ctrl)
 {
-	__evtchn_fifo_handle_events(cpu, false);
+	__evtchn_fifo_handle_events(cpu, ctrl);
 }
 
 static void evtchn_fifo_resume(void)
@@ -416,7 +408,7 @@ static int evtchn_fifo_percpu_init(unsig
 
 static int evtchn_fifo_percpu_deinit(unsigned int cpu)
 {
-	__evtchn_fifo_handle_events(cpu, true);
+	__evtchn_fifo_handle_events(cpu, NULL);
 	return 0;
 }
 
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -30,11 +30,15 @@ enum xen_irq_type {
  */
 struct irq_info {
 	struct list_head list;
+	struct list_head eoi_list;
 	int refcnt;
 	enum xen_irq_type type;	/* type */
 	unsigned irq;
 	evtchn_port_t evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
+	unsigned short eoi_cpu;	/* EOI must happen on this cpu */
+	unsigned int irq_epoch;	/* If eoi_cpu valid: irq_epoch of event */
+	u64 eoi_time;		/* Time in jiffies when to EOI. */
 
 	union {
 		unsigned short virq;
@@ -53,6 +57,8 @@ struct irq_info {
 #define PIRQ_SHAREABLE	(1 << 1)
 #define PIRQ_MSI_GROUP	(1 << 2)
 
+struct evtchn_loop_ctrl;
+
 struct evtchn_ops {
 	unsigned (*max_channels)(void);
 	unsigned (*nr_channels)(void);
@@ -67,7 +73,7 @@ struct evtchn_ops {
 	void (*mask)(evtchn_port_t port);
 	void (*unmask)(evtchn_port_t port);
 
-	void (*handle_events)(unsigned cpu);
+	void (*handle_events)(unsigned cpu, struct evtchn_loop_ctrl *ctrl);
 	void (*resume)(void);
 
 	int (*percpu_init)(unsigned int cpu);
@@ -78,6 +84,7 @@ extern const struct evtchn_ops *evtchn_o
 
 extern int **evtchn_to_irq;
 int get_evtchn_to_irq(evtchn_port_t evtchn);
+void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl);
 
 struct irq_info *info_for_irq(unsigned irq);
 unsigned cpu_from_irq(unsigned irq);
@@ -135,9 +142,10 @@ static inline void unmask_evtchn(evtchn_
 	return evtchn_ops->unmask(port);
 }
 
-static inline void xen_evtchn_handle_events(unsigned cpu)
+static inline void xen_evtchn_handle_events(unsigned cpu,
+					    struct evtchn_loop_ctrl *ctrl)
 {
-	return evtchn_ops->handle_events(cpu);
+	return evtchn_ops->handle_events(cpu, ctrl);
 }
 
 static inline void xen_evtchn_resume(void)


