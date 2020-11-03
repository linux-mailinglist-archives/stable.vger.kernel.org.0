Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB672A4B2B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgKCQWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:58866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbgKCQWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAen7a3G5/xg2PjRgHVvppD1PkYoMzbrSNL9oQPnI8s=;
        b=eaXcDT3g+RiOI8veBP3YhdTFeCZHE/yErmb9I3edaXCmtaCOCcRz7PaTZlglfLdp8XRoww
        4tcQTulWQAoeTo1T7q5M1Zh2P+9dPhwf4hHzRDhGH8kWiQEPFMsUeGgcoPPRE8sIurI+b5
        0QUdbvPJuEbhCcy1MnefYOQTzBaKzaE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 70398ADDB
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:40 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 12/13] xen/events: defer eoi in case of excessive number of events
Date:   Tue,  3 Nov 2020 17:22:37 +0100
Message-Id: <20201103162238.30264-13-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
References: <20201103162238.30264-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

This is upstream commit e99502f76271d6bc4e374fe368c50c67a1fd3070

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
---
 Documentation/kernel-parameters.txt  |   8 ++
 drivers/xen/events/events_2l.c       |   7 +-
 drivers/xen/events/events_base.c     | 189 ++++++++++++++++++++++++++-
 drivers/xen/events/events_fifo.c     |  30 ++---
 drivers/xen/events/events_internal.h |  14 +-
 5 files changed, 216 insertions(+), 32 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b19d872feb56..17747dcd0e77 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -4488,6 +4488,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Disables the PV optimizations forcing the HVM guest to
 			run as generic HVM guest with no PV drivers.
 
+	xen.event_eoi_delay=	[XEN]
+			How long to delay EOI handling in case of event
+			storms (jiffies). Default is 10.
+
+	xen.event_loop_timeout=	[XEN]
+			After which time (jiffies) the event handling loop
+			should start to delay EOI handling. Default is 2.
+
 	xirc2ps_cs=	[NET,PCMCIA]
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index 04d1b025b29d..e902512fcfb5 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -160,7 +160,7 @@ static inline xen_ulong_t active_evtchns(unsigned int cpu,
  * a bitset of words which contain pending event bits.  The second
  * level is a bitset of pending events themselves.
  */
-static void evtchn_2l_handle_events(unsigned cpu)
+static void evtchn_2l_handle_events(unsigned cpu, struct evtchn_loop_ctrl *ctrl)
 {
 	int irq;
 	xen_ulong_t pending_words;
@@ -241,10 +241,7 @@ static void evtchn_2l_handle_events(unsigned cpu)
 
 			/* Process port. */
 			port = (word_idx * BITS_PER_EVTCHN_WORD) + bit_idx;
-			irq = get_evtchn_to_irq(port);
-
-			if (irq != -1)
-				generic_handle_irq(irq);
+			handle_irq_for_port(port, ctrl);
 
 			bit_idx = (bit_idx + 1) % BITS_PER_EVTCHN_WORD;
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 9e7cbc3369f7..07cef5fb4515 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -34,6 +34,8 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
+#include <linux/atomic.h>
+#include <linux/ktime.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -64,6 +66,15 @@
 
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
@@ -87,6 +98,7 @@ static DEFINE_RWLOCK(evtchn_rwlock);
  * irq_mapping_update_lock
  *   evtchn_rwlock
  *     IRQ-desc lock
+ *       percpu eoi_list_lock
  */
 
 static LIST_HEAD(xen_irq_list_head);
@@ -119,6 +131,8 @@ static struct irq_chip xen_pirq_chip;
 static void enable_dynirq(struct irq_data *data);
 static void disable_dynirq(struct irq_data *data);
 
+static DEFINE_PER_CPU(unsigned int, irq_epoch);
+
 static void clear_evtchn_to_irq_row(unsigned row)
 {
 	unsigned col;
@@ -406,17 +420,120 @@ void notify_remote_via_irq(int irq)
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
@@ -436,6 +553,7 @@ EXPORT_SYMBOL_GPL(xen_irq_lateeoi);
 static void xen_irq_init(unsigned irq)
 {
 	struct irq_info *info;
+
 #ifdef CONFIG_SMP
 	/* By default all event channels notify CPU#0. */
 	cpumask_copy(irq_get_affinity_mask(irq), cpumask_of(0));
@@ -450,6 +568,7 @@ static void xen_irq_init(unsigned irq)
 
 	set_info_for_irq(irq, info);
 
+	INIT_LIST_HEAD(&info->eoi_list);
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
 
@@ -505,6 +624,9 @@ static void xen_free_irq(unsigned irq)
 
 	write_lock_irqsave(&evtchn_rwlock, flags);
 
+	if (!list_empty(&info->eoi_list))
+		lateeoi_list_del(info);
+
 	list_del(&info->list);
 
 	set_info_for_irq(irq, NULL);
@@ -1363,6 +1485,54 @@ void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
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
+		if (!ctrl->timeout.tv64) {
+			kt = ktime_add_ms(kt,
+					  jiffies_to_msecs(event_loop_timeout));
+			ctrl->timeout = kt;
+		} else if (kt.tv64 > ctrl->timeout.tv64) {
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
 static DEFINE_PER_CPU(unsigned, xed_nesting_count);
 
 static void __xen_evtchn_do_upcall(void)
@@ -1370,6 +1540,7 @@ static void __xen_evtchn_do_upcall(void)
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 	int cpu = get_cpu();
 	unsigned count;
+	struct evtchn_loop_ctrl ctrl = { 0 };
 
 	read_lock(&evtchn_rwlock);
 
@@ -1379,7 +1550,7 @@ static void __xen_evtchn_do_upcall(void)
 		if (__this_cpu_inc_return(xed_nesting_count) - 1)
 			goto out;
 
-		xen_evtchn_handle_events(cpu);
+		xen_evtchn_handle_events(cpu, &ctrl);
 
 		BUG_ON(!irqs_disabled());
 
@@ -1390,6 +1561,13 @@ static void __xen_evtchn_do_upcall(void)
 out:
 	read_unlock(&evtchn_rwlock);
 
+	/*
+	 * Increment irq_epoch only now to defer EOIs only for
+	 * xen_irq_lateeoi() invocations occurring from inside the loop
+	 * above.
+	 */
+	__this_cpu_inc(irq_epoch);
+
 	put_cpu();
 }
 
@@ -1827,9 +2005,6 @@ void xen_callback_vector(void)
 void xen_callback_vector(void) {}
 #endif
 
-#undef MODULE_PARAM_PREFIX
-#define MODULE_PARAM_PREFIX "xen."
-
 static bool fifo_events = true;
 module_param(fifo_events, bool, 0);
 
@@ -1837,6 +2012,8 @@ static int xen_evtchn_cpu_prepare(unsigned int cpu)
 {
 	int ret = 0;
 
+	xen_cpu_init_eoi(cpu);
+
 	if (evtchn_ops->percpu_init)
 		ret = evtchn_ops->percpu_init(cpu);
 
@@ -1886,6 +2063,8 @@ void __init xen_init_IRQ(void)
 	if (ret < 0)
 		xen_evtchn_2l_init();
 
+	xen_cpu_init_eoi(smp_processor_id());
+
 	register_cpu_notifier(&evtchn_cpu_notifier);
 
 	evtchn_to_irq = kcalloc(EVTCHN_ROW(xen_evtchn_max_channels()),
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index db809ee3197b..7addca0d8d26 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -275,19 +275,9 @@ static uint32_t clear_linked(volatile event_word_t *word)
 	return w & EVTCHN_FIFO_LINK_MASK;
 }
 
-static void handle_irq_for_port(unsigned port)
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
@@ -320,16 +310,17 @@ static void consume_one_event(unsigned cpu,
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
@@ -341,14 +332,15 @@ static void __evtchn_fifo_handle_events(unsigned cpu, bool drop)
 
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
@@ -417,7 +409,7 @@ static int evtchn_fifo_percpu_init(unsigned int cpu)
 
 static int evtchn_fifo_percpu_deinit(unsigned int cpu)
 {
-	__evtchn_fifo_handle_events(cpu, true);
+	__evtchn_fifo_handle_events(cpu, NULL);
 	return 0;
 }
 
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 980a56d51e4c..2cb9c2d2c5c0 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -32,11 +32,15 @@ enum xen_irq_type {
  */
 struct irq_info {
 	struct list_head list;
+	struct list_head eoi_list;
 	int refcnt;
 	enum xen_irq_type type;	/* type */
 	unsigned irq;
 	unsigned int evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
+	unsigned short eoi_cpu;	/* EOI must happen on this cpu */
+	unsigned int irq_epoch;	/* If eoi_cpu valid: irq_epoch of event */
+	u64 eoi_time;		/* Time in jiffies when to EOI. */
 
 	union {
 		unsigned short virq;
@@ -55,6 +59,8 @@ struct irq_info {
 #define PIRQ_SHAREABLE	(1 << 1)
 #define PIRQ_MSI_GROUP	(1 << 2)
 
+struct evtchn_loop_ctrl;
+
 struct evtchn_ops {
 	unsigned (*max_channels)(void);
 	unsigned (*nr_channels)(void);
@@ -69,7 +75,7 @@ struct evtchn_ops {
 	void (*mask)(unsigned port);
 	void (*unmask)(unsigned port);
 
-	void (*handle_events)(unsigned cpu);
+	void (*handle_events)(unsigned cpu, struct evtchn_loop_ctrl *ctrl);
 	void (*resume)(void);
 
 	int (*percpu_init)(unsigned int cpu);
@@ -80,6 +86,7 @@ extern const struct evtchn_ops *evtchn_ops;
 
 extern int **evtchn_to_irq;
 int get_evtchn_to_irq(unsigned int evtchn);
+void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl);
 
 struct irq_info *info_for_irq(unsigned irq);
 unsigned cpu_from_irq(unsigned irq);
@@ -137,9 +144,10 @@ static inline void unmask_evtchn(unsigned port)
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
-- 
2.26.2

