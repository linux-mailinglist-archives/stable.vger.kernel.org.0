Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C5533AD2F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhCOISp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:18:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:48708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhCOISa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 04:18:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615796309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=mzy8MeidSzFmSTcOyvZGB7fFCnvQkhBfAH4l3jUwyfE=;
        b=CIfn3+TOkVOsAevH/gRfLC1RdLHytPPspdhe1/XqiQnn4nQ26BFdyJPtgKhhP/N5+GLTTP
        UNTAUjAJrEBGwjGzmNSctaZ73rQr3LwKrrxwNos2xyVF/aUAzj+7efcyHx4cMnXhhgjDcY
        43T6PD2IElZ3LuHQW51L71agkzaDYmY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18E87AE56
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 08:18:29 +0000 (UTC)
To:     stable@vger.kernel.org
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Subject: Backported patches for stable 5.10
Message-ID: <aed51a72-7dbd-7d0c-df2c-4b226f63e44a@suse.com>
Date:   Mon, 15 Mar 2021 09:18:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K8q1PWfEbSJc2OQeFiFjn9GrdycZrj6Fc"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K8q1PWfEbSJc2OQeFiFjn9GrdycZrj6Fc
Content-Type: multipart/mixed; boundary="WQnvFQRwTbEAN630bryhAdg5LGfS78EZ9";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: stable@vger.kernel.org
Message-ID: <aed51a72-7dbd-7d0c-df2c-4b226f63e44a@suse.com>
Subject: Backported patches for stable 5.10

--WQnvFQRwTbEAN630bryhAdg5LGfS78EZ9
Content-Type: multipart/mixed;
 boundary="------------4C3CBD016D3D96687B8A8B7E"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------4C3CBD016D3D96687B8A8B7E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

I've attached backports of 2 patches for 5.10.

Juergen

--------------4C3CBD016D3D96687B8A8B7E
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-xen-events-don-t-unmask-an-event-channel-when-an-eoi.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-xen-events-don-t-unmask-an-event-channel-when-an-eoi.pa";
 filename*1="tch"

=46rom eeb0c941de41ab74ef8163ffc3e32733ff7c4357 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Mon, 15 Mar 2021 08:11:29 +0100
Subject: [PATCH 1/2] xen/events: don't unmask an event channel when an eo=
i is
 pending

commit 25da4618af240fbec6112401498301a6f2bc9702 upstream.

An event channel should be kept masked when an eoi is pending for it.
When being migrated to another cpu it might be unmasked, though.

In order to avoid this keep three different flags for each event channel
to be able to distinguish "normal" masking/unmasking from eoi related
masking/unmasking and temporary masking. The event channel should only
be able to generate an interrupt if all flags are cleared.

Cc: stable@vger.kernel.org
Fixes: 54c9de89895e ("xen/events: add a new "late EOI" evtchn framework")=

Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Tested-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Link: https://lore.kernel.org/r/20210306161833.4552-3-jgross@suse.com

[boris -- corrected Fixed tag format]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/events/events_2l.c       |   7 --
 drivers/xen/events/events_base.c     | 117 ++++++++++++++++++++-------
 drivers/xen/events/events_fifo.c     |   7 --
 drivers/xen/events/events_internal.h |   6 --
 4 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2=
l.c
index a7f413c5c190..b8f2f971c2f0 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -77,12 +77,6 @@ static bool evtchn_2l_is_pending(evtchn_port_t port)
 	return sync_test_bit(port, BM(&s->evtchn_pending[0]));
 }
=20
-static bool evtchn_2l_test_and_set_mask(evtchn_port_t port)
-{
-	struct shared_info *s =3D HYPERVISOR_shared_info;
-	return sync_test_and_set_bit(port, BM(&s->evtchn_mask[0]));
-}
-
 static void evtchn_2l_mask(evtchn_port_t port)
 {
 	struct shared_info *s =3D HYPERVISOR_shared_info;
@@ -376,7 +370,6 @@ static const struct evtchn_ops evtchn_ops_2l =3D {
 	.clear_pending     =3D evtchn_2l_clear_pending,
 	.set_pending       =3D evtchn_2l_set_pending,
 	.is_pending        =3D evtchn_2l_is_pending,
-	.test_and_set_mask =3D evtchn_2l_test_and_set_mask,
 	.mask              =3D evtchn_2l_mask,
 	.unmask            =3D evtchn_2l_unmask,
 	.handle_events     =3D evtchn_2l_handle_events,
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events=
_base.c
index ae9215186093..101b99576799 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -96,13 +96,18 @@ struct irq_info {
 	struct list_head eoi_list;
 	short refcnt;
 	short spurious_cnt;
-	enum xen_irq_type type; /* type */
+	short type;             /* type */
+	u8 mask_reason;         /* Why is event channel masked */
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
=20
 	union {
 		unsigned short virq;
@@ -151,6 +156,7 @@ static DEFINE_RWLOCK(evtchn_rwlock);
  *   evtchn_rwlock
  *     IRQ-desc lock
  *       percpu eoi_list_lock
+ *         irq_info->lock
  */
=20
 static LIST_HEAD(xen_irq_list_head);
@@ -272,6 +278,8 @@ static int xen_irq_info_common_setup(struct irq_info =
*info,
 	info->irq =3D irq;
 	info->evtchn =3D evtchn;
 	info->cpu =3D cpu;
+	info->mask_reason =3D EVT_MASK_REASON_EXPLICIT;
+	spin_lock_init(&info->lock);
=20
 	ret =3D set_evtchn_to_irq(evtchn, irq);
 	if (ret < 0)
@@ -419,6 +427,34 @@ unsigned int cpu_from_evtchn(evtchn_port_t evtchn)
 	return ret;
 }
=20
+static void do_mask(struct irq_info *info, u8 reason)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock, flags);
+
+	if (!info->mask_reason)
+		mask_evtchn(info->evtchn);
+
+	info->mask_reason |=3D reason;
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
+	info->mask_reason &=3D ~reason;
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
@@ -546,7 +582,7 @@ static void xen_irq_lateeoi_locked(struct irq_info *i=
nfo, bool spurious)
 	}
=20
 	info->eoi_time =3D 0;
-	unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
=20
 static void xen_irq_lateeoi_worker(struct work_struct *work)
@@ -733,7 +769,8 @@ static void pirq_query_unmask(int irq)
=20
 static void eoi_pirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn =3D evtchn_from_irq(data->irq);
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
 	struct physdev_eoi eoi =3D { .irq =3D pirq_from_irq(data->irq) };
 	int rc =3D 0;
=20
@@ -742,14 +779,13 @@ static void eoi_pirq(struct irq_data *data)
=20
 	if (unlikely(irqd_is_setaffinity_pending(data)) &&
 	    likely(!irqd_irq_disabled(data))) {
-		int masked =3D test_and_set_mask(evtchn);
+		do_mask(info, EVT_MASK_REASON_TEMPORARY);
=20
 		clear_evtchn(evtchn);
=20
 		irq_move_masked_irq(data);
=20
-		if (!masked)
-			unmask_evtchn(evtchn);
+		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 	} else
 		clear_evtchn(evtchn);
=20
@@ -802,7 +838,8 @@ static unsigned int __startup_pirq(unsigned int irq)
 		goto err;
=20
 out:
-	unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_EXPLICIT);
+
 	eoi_pirq(irq_get_irq_data(irq));
=20
 	return 0;
@@ -829,7 +866,7 @@ static void shutdown_pirq(struct irq_data *data)
 	if (!VALID_EVTCHN(evtchn))
 		return;
=20
-	mask_evtchn(evtchn);
+	do_mask(info, EVT_MASK_REASON_EXPLICIT);
 	xen_evtchn_close(evtchn);
 	xen_irq_info_cleanup(info);
 }
@@ -1656,10 +1693,10 @@ void rebind_evtchn_irq(evtchn_port_t evtchn, int =
irq)
 }
=20
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-static int xen_rebind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int t=
cpu)
+static int xen_rebind_evtchn_to_cpu(struct irq_info *info, unsigned int =
tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
-	int masked;
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1675,7 +1712,7 @@ static int xen_rebind_evtchn_to_cpu(evtchn_port_t e=
vtchn, unsigned int tcpu)
 	 * Mask the event while changing the VCPU binding to prevent
 	 * it being delivered on an unexpected VCPU.
 	 */
-	masked =3D test_and_set_mask(evtchn);
+	do_mask(info, EVT_MASK_REASON_TEMPORARY);
=20
 	/*
 	 * If this fails, it usually just indicates that we're dealing with a
@@ -1685,8 +1722,7 @@ static int xen_rebind_evtchn_to_cpu(evtchn_port_t e=
vtchn, unsigned int tcpu)
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >=3D 0)=

 		bind_evtchn_to_cpu(evtchn, tcpu);
=20
-	if (!masked)
-		unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_TEMPORARY);
=20
 	return 0;
 }
@@ -1695,7 +1731,7 @@ static int set_affinity_irq(struct irq_data *data, =
const struct cpumask *dest,
 			    bool force)
 {
 	unsigned tcpu =3D cpumask_first_and(dest, cpu_online_mask);
-	int ret =3D xen_rebind_evtchn_to_cpu(evtchn_from_irq(data->irq), tcpu);=

+	int ret =3D xen_rebind_evtchn_to_cpu(info_for_irq(data->irq), tcpu);
=20
 	if (!ret)
 		irq_data_update_effective_affinity(data, cpumask_of(tcpu));
@@ -1714,37 +1750,39 @@ EXPORT_SYMBOL_GPL(xen_set_affinity_evtchn);
=20
 static void enable_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn =3D evtchn_from_irq(data->irq);
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (VALID_EVTCHN(evtchn))
-		unmask_evtchn(evtchn);
+		do_unmask(info, EVT_MASK_REASON_EXPLICIT);
 }
=20
 static void disable_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn =3D evtchn_from_irq(data->irq);
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (VALID_EVTCHN(evtchn))
-		mask_evtchn(evtchn);
+		do_mask(info, EVT_MASK_REASON_EXPLICIT);
 }
=20
 static void ack_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn =3D evtchn_from_irq(data->irq);
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (!VALID_EVTCHN(evtchn))
 		return;
=20
 	if (unlikely(irqd_is_setaffinity_pending(data)) &&
 	    likely(!irqd_irq_disabled(data))) {
-		int masked =3D test_and_set_mask(evtchn);
+		do_mask(info, EVT_MASK_REASON_TEMPORARY);
=20
 		clear_evtchn(evtchn);
=20
 		irq_move_masked_irq(data);
=20
-		if (!masked)
-			unmask_evtchn(evtchn);
+		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 	} else
 		clear_evtchn(evtchn);
 }
@@ -1755,18 +1793,39 @@ static void mask_ack_dynirq(struct irq_data *data=
)
 	ack_dynirq(data);
 }
=20
+static void lateeoi_ack_dynirq(struct irq_data *data)
+{
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
+
+	if (VALID_EVTCHN(evtchn)) {
+		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
+		clear_evtchn(evtchn);
+	}
+}
+
+static void lateeoi_mask_ack_dynirq(struct irq_data *data)
+{
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
+
+	if (VALID_EVTCHN(evtchn)) {
+		do_mask(info, EVT_MASK_REASON_EXPLICIT);
+		clear_evtchn(evtchn);
+	}
+}
+
 static int retrigger_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn =3D evtchn_from_irq(data->irq);
-	int masked;
+	struct irq_info *info =3D info_for_irq(data->irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (!VALID_EVTCHN(evtchn))
 		return 0;
=20
-	masked =3D test_and_set_mask(evtchn);
+	do_mask(info, EVT_MASK_REASON_TEMPORARY);
 	set_evtchn(evtchn);
-	if (!masked)
-		unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_TEMPORARY);
=20
 	return 1;
 }
@@ -1974,8 +2033,8 @@ static struct irq_chip xen_lateeoi_chip __read_most=
ly =3D {
 	.irq_mask		=3D disable_dynirq,
 	.irq_unmask		=3D enable_dynirq,
=20
-	.irq_ack		=3D mask_ack_dynirq,
-	.irq_mask_ack		=3D mask_ack_dynirq,
+	.irq_ack		=3D lateeoi_ack_dynirq,
+	.irq_mask_ack		=3D lateeoi_mask_ack_dynirq,
=20
 	.irq_set_affinity	=3D set_affinity_irq,
 	.irq_retrigger		=3D retrigger_dynirq,
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events=
_fifo.c
index b234f1766810..ad9fe51d3fb3 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -209,12 +209,6 @@ static bool evtchn_fifo_is_pending(evtchn_port_t por=
t)
 	return sync_test_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
 }
=20
-static bool evtchn_fifo_test_and_set_mask(evtchn_port_t port)
-{
-	event_word_t *word =3D event_word_from_port(port);
-	return sync_test_and_set_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
-}
-
 static void evtchn_fifo_mask(evtchn_port_t port)
 {
 	event_word_t *word =3D event_word_from_port(port);
@@ -423,7 +417,6 @@ static const struct evtchn_ops evtchn_ops_fifo =3D {
 	.clear_pending     =3D evtchn_fifo_clear_pending,
 	.set_pending       =3D evtchn_fifo_set_pending,
 	.is_pending        =3D evtchn_fifo_is_pending,
-	.test_and_set_mask =3D evtchn_fifo_test_and_set_mask,
 	.mask              =3D evtchn_fifo_mask,
 	.unmask            =3D evtchn_fifo_unmask,
 	.handle_events     =3D evtchn_fifo_handle_events,
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/ev=
ents_internal.h
index 18a4090d0709..4d3398eff9cd 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -21,7 +21,6 @@ struct evtchn_ops {
 	void (*clear_pending)(evtchn_port_t port);
 	void (*set_pending)(evtchn_port_t port);
 	bool (*is_pending)(evtchn_port_t port);
-	bool (*test_and_set_mask)(evtchn_port_t port);
 	void (*mask)(evtchn_port_t port);
 	void (*unmask)(evtchn_port_t port);
=20
@@ -84,11 +83,6 @@ static inline bool test_evtchn(evtchn_port_t port)
 	return evtchn_ops->is_pending(port);
 }
=20
-static inline bool test_and_set_mask(evtchn_port_t port)
-{
-	return evtchn_ops->test_and_set_mask(port);
-}
-
 static inline void mask_evtchn(evtchn_port_t port)
 {
 	return evtchn_ops->mask(port);
--=20
2.26.2


--------------4C3CBD016D3D96687B8A8B7E
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-xen-events-avoid-handling-the-same-event-on-two-cpus.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0002-xen-events-avoid-handling-the-same-event-on-two-cpus.pa";
 filename*1="tch"

=46rom 0d7eb384c8de17adbf7deedcd50c50805926b7b4 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Mon, 15 Mar 2021 08:23:51 +0100
Subject: [PATCH 2/2] xen/events: avoid handling the same event on two cpu=
s at
 the same time

commit b6622798bc50b625a1e62f82c7190df40c1f5b21 upstream.

When changing the cpu affinity of an event it can happen today that
(with some unlucky timing) the same event will be handled on the old
and the new cpu at the same time.

Avoid that by adding an "event active" flag to the per-event data and
call the handler only if this flag isn't set.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Link: https://lore.kernel.org/r/20210306161833.4552-4-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/events/events_base.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events=
_base.c
index 101b99576799..7bd03f6e0422 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -101,6 +101,7 @@ struct irq_info {
 #define EVT_MASK_REASON_EXPLICIT	0x01
 #define EVT_MASK_REASON_TEMPORARY	0x02
 #define EVT_MASK_REASON_EOI_PENDING	0x04
+	u8 is_active;		/* Is event just being handled? */
 	unsigned irq;
 	evtchn_port_t evtchn;   /* event channel */
 	unsigned short cpu;     /* cpu bound */
@@ -751,6 +752,12 @@ static void xen_evtchn_close(evtchn_port_t port)
 		BUG();
 }
=20
+static void event_handler_exit(struct irq_info *info)
+{
+	smp_store_release(&info->is_active, 0);
+	clear_evtchn(info->evtchn);
+}
+
 static void pirq_query_unmask(int irq)
 {
 	struct physdev_irq_status_query irq_status;
@@ -781,13 +788,13 @@ static void eoi_pirq(struct irq_data *data)
 	    likely(!irqd_irq_disabled(data))) {
 		do_mask(info, EVT_MASK_REASON_TEMPORARY);
=20
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
=20
 		irq_move_masked_irq(data);
=20
 		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 	} else
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
=20
 	if (pirq_needs_eoi(data->irq)) {
 		rc =3D HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
@@ -1603,6 +1610,8 @@ void handle_irq_for_port(evtchn_port_t port, struct=
 evtchn_loop_ctrl *ctrl)
 	}
=20
 	info =3D info_for_irq(irq);
+	if (xchg_acquire(&info->is_active, 1))
+		return;
=20
 	if (ctrl->defer_eoi) {
 		info->eoi_cpu =3D smp_processor_id();
@@ -1778,13 +1787,13 @@ static void ack_dynirq(struct irq_data *data)
 	    likely(!irqd_irq_disabled(data))) {
 		do_mask(info, EVT_MASK_REASON_TEMPORARY);
=20
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
=20
 		irq_move_masked_irq(data);
=20
 		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 	} else
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
=20
 static void mask_ack_dynirq(struct irq_data *data)
@@ -1800,7 +1809,7 @@ static void lateeoi_ack_dynirq(struct irq_data *dat=
a)
=20
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
=20
@@ -1811,7 +1820,7 @@ static void lateeoi_mask_ack_dynirq(struct irq_data=
 *data)
=20
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
=20
@@ -1922,10 +1931,11 @@ static void restore_cpu_ipis(unsigned int cpu)
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq)
 {
-	evtchn_port_t evtchn =3D evtchn_from_irq(irq);
+	struct irq_info *info =3D info_for_irq(irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (VALID_EVTCHN(evtchn))
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
 EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
--=20
2.26.2


--------------4C3CBD016D3D96687B8A8B7E
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------4C3CBD016D3D96687B8A8B7E--

--WQnvFQRwTbEAN630bryhAdg5LGfS78EZ9--

--K8q1PWfEbSJc2OQeFiFjn9GrdycZrj6Fc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBPGFQFAwAAAAAACgkQsN6d1ii/Ey/D
lQf+Jn+h6+V7onzq1JRvEVKcv5cQARnHsmmCt6QDS3jssnATFXZ+vg+/gfL72oDO/k0zRewMshib
JOGJwt4Q40zns49040QAAClQzp43OJrzQ3ntgHfypZxN3jNBblQa3ztC1cuOqcMl+boKGFL29s9c
t/C+evMAN6SZjSl+seTxxD/jorBSCXdkO+0YyhwWTRFmL7eOn+mp+YHQFrEl1niv790fxBZzJCm0
N3eFhKd4zlV2X+BLPQo/rjkwlJNWB9qkb6WdpVT5eWiR2bKJcfKlQB43azoVmsv9OTvx08hptUTU
mQ3Qup2IRjZ49m6+kNcyG3/Q2DJKlh0cjV+dnOCBQw==
=7DJu
-----END PGP SIGNATURE-----

--K8q1PWfEbSJc2OQeFiFjn9GrdycZrj6Fc--
