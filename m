Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3765533AE1D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCOI6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:58:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:50830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhCOI6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 04:58:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615798715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=KrRfubFwWGw/QWbsbIi263e1KmIy79SMqSE2h983Cn8=;
        b=LeeXM/T5NJUlc0nQGzo/FqrD9NUFOU0x8m61yYyFO39psKXphJvav3hpKPt9p7ppc1UbbW
        8eGpK199CrMTec9bOapmZ96cFQthc4wgVxuXZ/Dpzp5E44coKquVwfS9j8grTTsMudndBU
        eaFSt8i1aYxpBv91HHYa04mU7BtOG90=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 76FBEACA8
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 08:58:35 +0000 (UTC)
To:     stable@vger.kernel.org
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Subject: Backported patches for stable 4.14 - 5.4
Message-ID: <48fe237e-0865-53e4-23f6-a3ac0610f190@suse.com>
Date:   Mon, 15 Mar 2021 09:58:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OnBlNQWl0qVFuQt7MNCB13XobMXT11PDH"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OnBlNQWl0qVFuQt7MNCB13XobMXT11PDH
Content-Type: multipart/mixed; boundary="sGEBiUohl2TNNKDexGE5PpbweRE0ESH98";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: stable@vger.kernel.org
Message-ID: <48fe237e-0865-53e4-23f6-a3ac0610f190@suse.com>
Subject: Backported patches for stable 4.14 - 5.4

--sGEBiUohl2TNNKDexGE5PpbweRE0ESH98
Content-Type: multipart/mixed;
 boundary="------------C5D13A992723037123FE1459"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------C5D13A992723037123FE1459
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

I've attached backports of 3 patches for 4.14 - 5.4.

Juergen

--------------C5D13A992723037123FE1459
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-xen-events-reset-affinity-of-2-level-event-when-tear.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-xen-events-reset-affinity-of-2-level-event-when-tear.pa";
 filename*1="tch"

=46rom d0c22122b31152f4df472952a976f8e502de4275 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Mon, 15 Mar 2021 09:22:37 +0100
Subject: [PATCH 1/3] xen/events: reset affinity of 2-level event when tea=
ring
 it down

commit 9e77d96b8e2724ed00380189f7b0ded61113b39f upstream.

When creating a new event channel with 2-level events the affinity
needs to be reset initially in order to avoid using an old affinity
from earlier usage of the event channel port. So when tearing an event
channel down reset all affinity bits.

The same applies to the affinity when onlining a vcpu: all old
affinity settings for this vcpu must be reset. As percpu events get
initialized before the percpu event channel hook is called,
resetting of the affinities happens after offlining a vcpu (this is
working, as initial percpu memory is zeroed out).

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Link: https://lore.kernel.org/r/20210306161833.4552-2-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/events/events_2l.c       | 15 +++++++++++++++
 drivers/xen/events/events_base.c     |  1 +
 drivers/xen/events/events_internal.h |  8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2=
l.c
index f026624898e7..cf3f579c1c3d 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -47,6 +47,11 @@ static unsigned evtchn_2l_max_channels(void)
 	return EVTCHN_2L_NR_CHANNELS;
 }
=20
+static void evtchn_2l_remove(evtchn_port_t evtchn, unsigned int cpu)
+{
+	clear_bit(evtchn, BM(per_cpu(cpu_evtchn_mask, cpu)));
+}
+
 static void evtchn_2l_bind_to_cpu(struct irq_info *info, unsigned cpu)
 {
 	clear_bit(info->evtchn, BM(per_cpu(cpu_evtchn_mask, info->cpu)));
@@ -354,9 +359,18 @@ static void evtchn_2l_resume(void)
 				EVTCHN_2L_NR_CHANNELS/BITS_PER_EVTCHN_WORD);
 }
=20
+static int evtchn_2l_percpu_deinit(unsigned int cpu)
+{
+	memset(per_cpu(cpu_evtchn_mask, cpu), 0, sizeof(xen_ulong_t) *
+			EVTCHN_2L_NR_CHANNELS/BITS_PER_EVTCHN_WORD);
+
+	return 0;
+}
+
 static const struct evtchn_ops evtchn_ops_2l =3D {
 	.max_channels      =3D evtchn_2l_max_channels,
 	.nr_channels       =3D evtchn_2l_max_channels,
+	.remove            =3D evtchn_2l_remove,
 	.bind_to_cpu       =3D evtchn_2l_bind_to_cpu,
 	.clear_pending     =3D evtchn_2l_clear_pending,
 	.set_pending       =3D evtchn_2l_set_pending,
@@ -366,6 +380,7 @@ static const struct evtchn_ops evtchn_ops_2l =3D {
 	.unmask            =3D evtchn_2l_unmask,
 	.handle_events     =3D evtchn_2l_handle_events,
 	.resume	           =3D evtchn_2l_resume,
+	.percpu_deinit     =3D evtchn_2l_percpu_deinit,
 };
=20
 void __init xen_evtchn_2l_init(void)
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events=
_base.c
index 7b94a6c31664..2e4c4ab38095 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -286,6 +286,7 @@ static int xen_irq_info_pirq_setup(unsigned irq,
 static void xen_irq_info_cleanup(struct irq_info *info)
 {
 	set_evtchn_to_irq(info->evtchn, -1);
+	xen_evtchn_port_remove(info->evtchn, info->cpu);
 	info->evtchn =3D 0;
 }
=20
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/ev=
ents_internal.h
index a35c8c7ac606..6ccebc498679 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -65,6 +65,7 @@ struct evtchn_ops {
 	unsigned (*nr_channels)(void);
=20
 	int (*setup)(struct irq_info *info);
+	void (*remove)(evtchn_port_t port, unsigned int cpu);
 	void (*bind_to_cpu)(struct irq_info *info, unsigned cpu);
=20
 	void (*clear_pending)(unsigned port);
@@ -107,6 +108,13 @@ static inline int xen_evtchn_port_setup(struct irq_i=
nfo *info)
 	return 0;
 }
=20
+static inline void xen_evtchn_port_remove(evtchn_port_t evtchn,
+					  unsigned int cpu)
+{
+	if (evtchn_ops->remove)
+		evtchn_ops->remove(evtchn, cpu);
+}
+
 static inline void xen_evtchn_port_bind_to_cpu(struct irq_info *info,
 					       unsigned cpu)
 {
--=20
2.26.2


--------------C5D13A992723037123FE1459
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-xen-events-don-t-unmask-an-event-channel-when-an-eoi.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0002-xen-events-don-t-unmask-an-event-channel-when-an-eoi.pa";
 filename*1="tch"

=46rom e32cce4a462215791cb1049a8d965353adb2b88c Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Mon, 15 Mar 2021 09:22:37 +0100
Subject: [PATCH 2/3] xen/events: don't unmask an event channel when an eo=
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
 drivers/xen/events/events_base.c     | 110 ++++++++++++++++++++-------
 drivers/xen/events/events_fifo.c     |   7 --
 drivers/xen/events/events_internal.h |  13 ++--
 4 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2=
l.c
index cf3f579c1c3d..77cc80bcb479 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -76,12 +76,6 @@ static bool evtchn_2l_is_pending(unsigned port)
 	return sync_test_bit(port, BM(&s->evtchn_pending[0]));
 }
=20
-static bool evtchn_2l_test_and_set_mask(unsigned port)
-{
-	struct shared_info *s =3D HYPERVISOR_shared_info;
-	return sync_test_and_set_bit(port, BM(&s->evtchn_mask[0]));
-}
-
 static void evtchn_2l_mask(unsigned port)
 {
 	struct shared_info *s =3D HYPERVISOR_shared_info;
@@ -375,7 +369,6 @@ static const struct evtchn_ops evtchn_ops_2l =3D {
 	.clear_pending     =3D evtchn_2l_clear_pending,
 	.set_pending       =3D evtchn_2l_set_pending,
 	.is_pending        =3D evtchn_2l_is_pending,
-	.test_and_set_mask =3D evtchn_2l_test_and_set_mask,
 	.mask              =3D evtchn_2l_mask,
 	.unmask            =3D evtchn_2l_unmask,
 	.handle_events     =3D evtchn_2l_handle_events,
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events=
_base.c
index 2e4c4ab38095..9025a06b5aa9 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -99,6 +99,7 @@ static DEFINE_RWLOCK(evtchn_rwlock);
  *   evtchn_rwlock
  *     IRQ-desc lock
  *       percpu eoi_list_lock
+ *         irq_info->lock
  */
=20
 static LIST_HEAD(xen_irq_list_head);
@@ -220,6 +221,8 @@ static int xen_irq_info_common_setup(struct irq_info =
*info,
 	info->irq =3D irq;
 	info->evtchn =3D evtchn;
 	info->cpu =3D cpu;
+	info->mask_reason =3D EVT_MASK_REASON_EXPLICIT;
+	spin_lock_init(&info->lock);
=20
 	ret =3D set_evtchn_to_irq(evtchn, irq);
 	if (ret < 0)
@@ -367,6 +370,34 @@ unsigned int cpu_from_evtchn(unsigned int evtchn)
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
@@ -494,7 +525,7 @@ static void xen_irq_lateeoi_locked(struct irq_info *i=
nfo, bool spurious)
 	}
=20
 	info->eoi_time =3D 0;
-	unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
=20
 static void xen_irq_lateeoi_worker(struct work_struct *work)
@@ -681,7 +712,8 @@ static void pirq_query_unmask(int irq)
=20
 static void eoi_pirq(struct irq_data *data)
 {
-	int evtchn =3D evtchn_from_irq(data->irq);
+	struct irq_info *info =3D info_for_irq(data->irq);
+	int evtchn =3D info ? info->evtchn : 0;
 	struct physdev_eoi eoi =3D { .irq =3D pirq_from_irq(data->irq) };
 	int rc =3D 0;
=20
@@ -690,14 +722,13 @@ static void eoi_pirq(struct irq_data *data)
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
@@ -750,7 +781,8 @@ static unsigned int __startup_pirq(unsigned int irq)
 		goto err;
=20
 out:
-	unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_EXPLICIT);
+
 	eoi_pirq(irq_get_irq_data(irq));
=20
 	return 0;
@@ -777,7 +809,7 @@ static void shutdown_pirq(struct irq_data *data)
 	if (!VALID_EVTCHN(evtchn))
 		return;
=20
-	mask_evtchn(evtchn);
+	do_mask(info, EVT_MASK_REASON_EXPLICIT);
 	xen_evtchn_close(evtchn);
 	xen_irq_info_cleanup(info);
 }
@@ -1636,10 +1668,10 @@ void rebind_evtchn_irq(int evtchn, int irq)
 }
=20
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-static int xen_rebind_evtchn_to_cpu(int evtchn, unsigned int tcpu)
+static int xen_rebind_evtchn_to_cpu(struct irq_info *info, unsigned int =
tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
-	int masked;
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1655,7 +1687,7 @@ static int xen_rebind_evtchn_to_cpu(int evtchn, uns=
igned int tcpu)
 	 * Mask the event while changing the VCPU binding to prevent
 	 * it being delivered on an unexpected VCPU.
 	 */
-	masked =3D test_and_set_mask(evtchn);
+	do_mask(info, EVT_MASK_REASON_TEMPORARY);
=20
 	/*
 	 * If this fails, it usually just indicates that we're dealing with a
@@ -1665,8 +1697,7 @@ static int xen_rebind_evtchn_to_cpu(int evtchn, uns=
igned int tcpu)
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >=3D 0)=

 		bind_evtchn_to_cpu(evtchn, tcpu);
=20
-	if (!masked)
-		unmask_evtchn(evtchn);
+	do_unmask(info, EVT_MASK_REASON_TEMPORARY);
=20
 	return 0;
 }
@@ -1675,7 +1706,7 @@ static int set_affinity_irq(struct irq_data *data, =
const struct cpumask *dest,
 			    bool force)
 {
 	unsigned tcpu =3D cpumask_first_and(dest, cpu_online_mask);
-	int ret =3D xen_rebind_evtchn_to_cpu(evtchn_from_irq(data->irq), tcpu);=

+	int ret =3D xen_rebind_evtchn_to_cpu(info_for_irq(data->irq), tcpu);
=20
 	if (!ret)
 		irq_data_update_effective_affinity(data, cpumask_of(tcpu));
@@ -1694,37 +1725,39 @@ EXPORT_SYMBOL_GPL(xen_set_affinity_evtchn);
=20
 static void enable_dynirq(struct irq_data *data)
 {
-	int evtchn =3D evtchn_from_irq(data->irq);
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
-	int evtchn =3D evtchn_from_irq(data->irq);
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
-	int evtchn =3D evtchn_from_irq(data->irq);
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
@@ -1735,18 +1768,39 @@ static void mask_ack_dynirq(struct irq_data *data=
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
-	unsigned int evtchn =3D evtchn_from_irq(data->irq);
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
@@ -1952,8 +2006,8 @@ static struct irq_chip xen_lateeoi_chip __read_most=
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
index 33462521bfd0..360a7f8cdf75 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -209,12 +209,6 @@ static bool evtchn_fifo_is_pending(unsigned port)
 	return sync_test_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
 }
=20
-static bool evtchn_fifo_test_and_set_mask(unsigned port)
-{
-	event_word_t *word =3D event_word_from_port(port);
-	return sync_test_and_set_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
-}
-
 static void evtchn_fifo_mask(unsigned port)
 {
 	event_word_t *word =3D event_word_from_port(port);
@@ -420,7 +414,6 @@ static const struct evtchn_ops evtchn_ops_fifo =3D {
 	.clear_pending     =3D evtchn_fifo_clear_pending,
 	.set_pending       =3D evtchn_fifo_set_pending,
 	.is_pending        =3D evtchn_fifo_is_pending,
-	.test_and_set_mask =3D evtchn_fifo_test_and_set_mask,
 	.mask              =3D evtchn_fifo_mask,
 	.unmask            =3D evtchn_fifo_unmask,
 	.handle_events     =3D evtchn_fifo_handle_events,
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/ev=
ents_internal.h
index 6ccebc498679..dd3748e85344 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -33,13 +33,18 @@ struct irq_info {
 	struct list_head eoi_list;
 	short refcnt;
 	short spurious_cnt;
-	enum xen_irq_type type;	/* type */
+	short type;		/* type */
+	u8 mask_reason;		/* Why is event channel masked */
+#define EVT_MASK_REASON_EXPLICIT	0x01
+#define EVT_MASK_REASON_TEMPORARY	0x02
+#define EVT_MASK_REASON_EOI_PENDING	0x04
 	unsigned irq;
 	unsigned int evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
 	unsigned short eoi_cpu;	/* EOI must happen on this cpu */
 	unsigned int irq_epoch;	/* If eoi_cpu valid: irq_epoch of event */
 	u64 eoi_time;		/* Time in jiffies when to EOI. */
+	spinlock_t lock;
=20
 	union {
 		unsigned short virq;
@@ -71,7 +76,6 @@ struct evtchn_ops {
 	void (*clear_pending)(unsigned port);
 	void (*set_pending)(unsigned port);
 	bool (*is_pending)(unsigned port);
-	bool (*test_and_set_mask)(unsigned port);
 	void (*mask)(unsigned port);
 	void (*unmask)(unsigned port);
=20
@@ -136,11 +140,6 @@ static inline bool test_evtchn(unsigned port)
 	return evtchn_ops->is_pending(port);
 }
=20
-static inline bool test_and_set_mask(unsigned port)
-{
-	return evtchn_ops->test_and_set_mask(port);
-}
-
 static inline void mask_evtchn(unsigned port)
 {
 	return evtchn_ops->mask(port);
--=20
2.26.2


--------------C5D13A992723037123FE1459
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-xen-events-avoid-handling-the-same-event-on-two-cpus.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0003-xen-events-avoid-handling-the-same-event-on-two-cpus.pa";
 filename*1="tch"

=46rom 4343938a8e33c2813d10e7f1b14e8dc65257dd77 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Mon, 15 Mar 2021 09:22:38 +0100
Subject: [PATCH 3/3] xen/events: avoid handling the same event on two cpu=
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
 drivers/xen/events/events_base.c     | 25 +++++++++++++++++--------
 drivers/xen/events/events_internal.h |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events=
_base.c
index 9025a06b5aa9..e492f5fe5be6 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -694,6 +694,12 @@ static void xen_evtchn_close(unsigned int port)
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
@@ -724,13 +730,13 @@ static void eoi_pirq(struct irq_data *data)
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
@@ -1566,6 +1572,8 @@ void handle_irq_for_port(evtchn_port_t port, struct=
 evtchn_loop_ctrl *ctrl)
 	}
=20
 	info =3D info_for_irq(irq);
+	if (xchg_acquire(&info->is_active, 1))
+		return;
=20
 	if (ctrl->defer_eoi) {
 		info->eoi_cpu =3D smp_processor_id();
@@ -1753,13 +1761,13 @@ static void ack_dynirq(struct irq_data *data)
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
@@ -1775,7 +1783,7 @@ static void lateeoi_ack_dynirq(struct irq_data *dat=
a)
=20
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
=20
@@ -1786,7 +1794,7 @@ static void lateeoi_mask_ack_dynirq(struct irq_data=
 *data)
=20
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
=20
@@ -1895,10 +1903,11 @@ static void restore_cpu_ipis(unsigned int cpu)
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq)
 {
-	int evtchn =3D evtchn_from_irq(irq);
+	struct irq_info *info =3D info_for_irq(irq);
+	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
=20
 	if (VALID_EVTCHN(evtchn))
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
 EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/ev=
ents_internal.h
index dd3748e85344..d3a89b4646b8 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -38,6 +38,7 @@ struct irq_info {
 #define EVT_MASK_REASON_EXPLICIT	0x01
 #define EVT_MASK_REASON_TEMPORARY	0x02
 #define EVT_MASK_REASON_EOI_PENDING	0x04
+	u8 is_active;		/* Is event just being handled? */
 	unsigned irq;
 	unsigned int evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
--=20
2.26.2


--------------C5D13A992723037123FE1459
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

--------------C5D13A992723037123FE1459--

--sGEBiUohl2TNNKDexGE5PpbweRE0ESH98--

--OnBlNQWl0qVFuQt7MNCB13XobMXT11PDH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBPIboFAwAAAAAACgkQsN6d1ii/Ey+V
igf+M8ijH6eKmd7Sk/bEWokO2JyGdpzSm+sew3+Q507keu8RathgKUtDIbqOJrOhl2HxdR2cOjnP
LZO7hST2OAaGssINahuaE8QjVYWVaoslZM36jbnXNq49xpBwlpBP/sNMGeyNfKZVMz7kzvvWbnBh
EnIzu5ggZD3VolR0f/sCBtd0HV/qQBZGGNSUDBhWj4X1ULt9a4qi9O2yNB9C8//1YCFHP/H6cPeI
iyPn/+dQaUX/d4fcDQdeGGhCiRvKOKjGEOSYfm8iR5P0HSnDzzxqyREtIsNA293qOrgPbSYAWxLu
WqHBXlKpdmcAdYl2Sfs0r81xS39HPgdRJaHUPZnMaA==
=e75I
-----END PGP SIGNATURE-----

--OnBlNQWl0qVFuQt7MNCB13XobMXT11PDH--
