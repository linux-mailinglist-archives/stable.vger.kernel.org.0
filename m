Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BDE33B9B1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhCOOGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhCOOBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A9F664F19;
        Mon, 15 Mar 2021 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816894;
        bh=mmwPyKd19YyjF2Z+poeYYjjPt8mbBaEk8c4U3p7b/x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C23T4etkzn1T0Dr197tVHexhhq4QpukdkuX/GojeuVVNLrvzxW1qqXLkI8j1cwK/w
         fZJyChHGDiat25/buVCkE9lO2od6z+CyrwxMlrFp4sLJQNg4FZ9FeNnhvUHTnCJj12
         infg4RDzKSoYVzb3o24kDcPrD32JezQY6i6vlevo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: [PATCH 5.11 187/306] xen/events: dont unmask an event channel when an eoi is pending
Date:   Mon, 15 Mar 2021 14:54:10 +0100
Message-Id: <20210315135513.934132389@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Juergen Gross <jgross@suse.com>

commit 25da4618af240fbec6112401498301a6f2bc9702 upstream.

An event channel should be kept masked when an eoi is pending for it.
When being migrated to another cpu it might be unmasked, though.

In order to avoid this keep three different flags for each event channel
to be able to distinguish "normal" masking/unmasking from eoi related
masking/unmasking and temporary masking. The event channel should only
be able to generate an interrupt if all flags are cleared.

Cc: stable@vger.kernel.org
Fixes: 54c9de89895e ("xen/events: add a new "late EOI" evtchn framework")
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Tested-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Link: https://lore.kernel.org/r/20210306161833.4552-3-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[boris -- corrected Fixed tag format]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/events/events_2l.c       |    7 --
 drivers/xen/events/events_base.c     |  101 +++++++++++++++++++++++++++--------
 drivers/xen/events/events_fifo.c     |    7 --
 drivers/xen/events/events_internal.h |    6 --
 4 files changed, 80 insertions(+), 41 deletions(-)

--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -77,12 +77,6 @@ static bool evtchn_2l_is_pending(evtchn_
 	return sync_test_bit(port, BM(&s->evtchn_pending[0]));
 }
 
-static bool evtchn_2l_test_and_set_mask(evtchn_port_t port)
-{
-	struct shared_info *s = HYPERVISOR_shared_info;
-	return sync_test_and_set_bit(port, BM(&s->evtchn_mask[0]));
-}
-
 static void evtchn_2l_mask(evtchn_port_t port)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
@@ -376,7 +370,6 @@ static const struct evtchn_ops evtchn_op
 	.clear_pending     = evtchn_2l_clear_pending,
 	.set_pending       = evtchn_2l_set_pending,
 	.is_pending        = evtchn_2l_is_pending,
-	.test_and_set_mask = evtchn_2l_test_and_set_mask,
 	.mask              = evtchn_2l_mask,
 	.unmask            = evtchn_2l_unmask,
 	.handle_events     = evtchn_2l_handle_events,
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -97,13 +97,18 @@ struct irq_info {
 	short refcnt;
 	u8 spurious_cnt;
 	u8 is_accounted;
-	enum xen_irq_type type; /* type */
+	short type;		/* type: IRQT_* */
+	u8 mask_reason;		/* Why is event channel masked */
+#define EVT_MASK_REASON_EXPLICIT	0x01
+#define EVT_MASK_REASON_TEMPORARY	0x02
+#define EVT_MASK_REASON_EOI_PENDING	0x04
 	unsigned irq;
 	evtchn_port_t evtchn;   /* event channel */
 	unsigned short cpu;     /* cpu bound */
 	unsigned short eoi_cpu; /* EOI must happen on this cpu-1 */
 	unsigned int irq_epoch; /* If eoi_cpu valid: irq_epoch of event */
 	u64 eoi_time;           /* Time in jiffies when to EOI. */
+	spinlock_t lock;
 
 	union {
 		unsigned short virq;
@@ -152,6 +157,7 @@ static DEFINE_RWLOCK(evtchn_rwlock);
  *   evtchn_rwlock
  *     IRQ-desc lock
  *       percpu eoi_list_lock
+ *         irq_info->lock
  */
 
 static LIST_HEAD(xen_irq_list_head);
@@ -302,6 +308,8 @@ static int xen_irq_info_common_setup(str
 	info->irq = irq;
 	info->evtchn = evtchn;
 	info->cpu = cpu;
+	info->mask_reason = EVT_MASK_REASON_EXPLICIT;
+	spin_lock_init(&info->lock);
 
 	ret = set_evtchn_to_irq(evtchn, irq);
 	if (ret < 0)
@@ -450,6 +458,34 @@ unsigned int cpu_from_evtchn(evtchn_port
 	return ret;
 }
 
+static void do_mask(struct irq_info *info, u8 reason)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock, flags);
+
+	if (!info->mask_reason)
+		mask_evtchn(info->evtchn);
+
+	info->mask_reason |= reason;
+
+	spin_unlock_irqrestore(&info->lock, flags);
+}
+
+static void do_unmask(struct irq_info *info, u8 reason)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock, flags);
+
+	info->mask_reason &= ~reason;
+
+	if (!info->mask_reason)
+		unmask_evtchn(info->evtchn);
+
+	spin_unlock_irqrestore(&info->lock, flags);
+}
+
 #ifdef CONFIG_X86
 static bool pirq_check_eoi_map(unsigned irq)
 {
@@ -586,7 +622,7 @@ static void xen_irq_lateeoi_locked(struc
 	}
 
 	info->eoi_time = 0;
-	unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
 static void xen_irq_lateeoi_worker(struct work_struct *work)
@@ -831,7 +867,8 @@ static unsigned int __startup_pirq(unsig
 		goto err;
 
 out:
-	unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_EXPLICIT);
+
 	eoi_pirq(irq_get_irq_data(irq));
 
 	return 0;
@@ -858,7 +895,7 @@ static void shutdown_pirq(struct irq_dat
 	if (!VALID_EVTCHN(evtchn))
 		return;
 
-	mask_evtchn(evtchn);
+	do_mask(info, EVT_MASK_REASON_EXPLICIT);
 	xen_evtchn_close(evtchn);
 	xen_irq_info_cleanup(info);
 }
@@ -1691,10 +1728,10 @@ void rebind_evtchn_irq(evtchn_port_t evt
 }
 
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-static int xen_rebind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int tcpu)
+static int xen_rebind_evtchn_to_cpu(struct irq_info *info, unsigned int tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
-	int masked;
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1710,7 +1747,7 @@ static int xen_rebind_evtchn_to_cpu(evtc
 	 * Mask the event while changing the VCPU binding to prevent
 	 * it being delivered on an unexpected VCPU.
 	 */
-	masked = test_and_set_mask(evtchn);
+	do_mask(info, EVT_MASK_REASON_TEMPORARY);
 
 	/*
 	 * If this fails, it usually just indicates that we're dealing with a
@@ -1720,8 +1757,7 @@ static int xen_rebind_evtchn_to_cpu(evtc
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu, false);
 
-	if (!masked)
-		unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 
 	return 0;
 }
@@ -1760,7 +1796,7 @@ static int set_affinity_irq(struct irq_d
 	unsigned int tcpu = select_target_cpu(dest);
 	int ret;
 
-	ret = xen_rebind_evtchn_to_cpu(evtchn_from_irq(data->irq), tcpu);
+	ret = xen_rebind_evtchn_to_cpu(info_for_irq(data->irq), tcpu);
 	if (!ret)
 		irq_data_update_effective_affinity(data, cpumask_of(tcpu));
 
@@ -1769,18 +1805,20 @@ static int set_affinity_irq(struct irq_d
 
 static void enable_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (VALID_EVTCHN(evtchn))
-		unmask_evtchn(evtchn);
+		do_unmask(info, EVT_MASK_REASON_EXPLICIT);
 }
 
 static void disable_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (VALID_EVTCHN(evtchn))
-		mask_evtchn(evtchn);
+		do_mask(info, EVT_MASK_REASON_EXPLICIT);
 }
 
 static void ack_dynirq(struct irq_data *data)
@@ -1799,18 +1837,39 @@ static void mask_ack_dynirq(struct irq_d
 	ack_dynirq(data);
 }
 
+static void lateeoi_ack_dynirq(struct irq_data *data)
+{
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
+
+	if (VALID_EVTCHN(evtchn)) {
+		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
+		clear_evtchn(evtchn);
+	}
+}
+
+static void lateeoi_mask_ack_dynirq(struct irq_data *data)
+{
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
+
+	if (VALID_EVTCHN(evtchn)) {
+		do_mask(info, EVT_MASK_REASON_EXPLICIT);
+		clear_evtchn(evtchn);
+	}
+}
+
 static int retrigger_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
-	int masked;
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (!VALID_EVTCHN(evtchn))
 		return 0;
 
-	masked = test_and_set_mask(evtchn);
+	do_mask(info, EVT_MASK_REASON_TEMPORARY);
 	set_evtchn(evtchn);
-	if (!masked)
-		unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 
 	return 1;
 }
@@ -2024,8 +2083,8 @@ static struct irq_chip xen_lateeoi_chip
 	.irq_mask		= disable_dynirq,
 	.irq_unmask		= enable_dynirq,
 
-	.irq_ack		= mask_ack_dynirq,
-	.irq_mask_ack		= mask_ack_dynirq,
+	.irq_ack		= lateeoi_ack_dynirq,
+	.irq_mask_ack		= lateeoi_mask_ack_dynirq,
 
 	.irq_set_affinity	= set_affinity_irq,
 	.irq_retrigger		= retrigger_dynirq,
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -209,12 +209,6 @@ static bool evtchn_fifo_is_pending(evtch
 	return sync_test_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
 }
 
-static bool evtchn_fifo_test_and_set_mask(evtchn_port_t port)
-{
-	event_word_t *word = event_word_from_port(port);
-	return sync_test_and_set_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
-}
-
 static void evtchn_fifo_mask(evtchn_port_t port)
 {
 	event_word_t *word = event_word_from_port(port);
@@ -423,7 +417,6 @@ static const struct evtchn_ops evtchn_op
 	.clear_pending     = evtchn_fifo_clear_pending,
 	.set_pending       = evtchn_fifo_set_pending,
 	.is_pending        = evtchn_fifo_is_pending,
-	.test_and_set_mask = evtchn_fifo_test_and_set_mask,
 	.mask              = evtchn_fifo_mask,
 	.unmask            = evtchn_fifo_unmask,
 	.handle_events     = evtchn_fifo_handle_events,
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -21,7 +21,6 @@ struct evtchn_ops {
 	void (*clear_pending)(evtchn_port_t port);
 	void (*set_pending)(evtchn_port_t port);
 	bool (*is_pending)(evtchn_port_t port);
-	bool (*test_and_set_mask)(evtchn_port_t port);
 	void (*mask)(evtchn_port_t port);
 	void (*unmask)(evtchn_port_t port);
 
@@ -84,11 +83,6 @@ static inline bool test_evtchn(evtchn_po
 	return evtchn_ops->is_pending(port);
 }
 
-static inline bool test_and_set_mask(evtchn_port_t port)
-{
-	return evtchn_ops->test_and_set_mask(port);
-}
-
 static inline void mask_evtchn(evtchn_port_t port)
 {
 	return evtchn_ops->mask(port);


