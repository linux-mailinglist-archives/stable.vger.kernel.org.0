Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58D931FC34
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 16:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBSPl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 10:41:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:47402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhBSPl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 10:41:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613749238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FO0fz98U2g5weSeglUcsg+1IlA+co2jioZAxAjIzYHw=;
        b=QHsiSyjEB+XxqHutx5nmU495s5WuRT0+qc5uj4y7BVCW2JiShJb0alShJHO9TdfRz2ErIk
        oECbNApBN2vIETzf/74XNNkgdqqKi1NF/cJVQDze0mmLQXz/o0ELCqD4f7DDFbTncYvnLU
        PMx2UHjoxGknPHWP9OyA2OLZyRYUoR0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16522ACBF;
        Fri, 19 Feb 2021 15:40:38 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Julien Grall <jgrall@amazon.com>
Subject: [PATCH v3 1/8] xen/events: reset affinity of 2-level event when tearing it down
Date:   Fri, 19 Feb 2021 16:40:23 +0100
Message-Id: <20210219154030.10892-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219154030.10892-1-jgross@suse.com>
References: <20210219154030.10892-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
V2:
- reset affinity when tearing down the event (Julien Grall)
---
 drivers/xen/events/events_2l.c       | 15 +++++++++++++++
 drivers/xen/events/events_base.c     |  1 +
 drivers/xen/events/events_internal.h |  8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index da87f3a1e351..a7f413c5c190 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -47,6 +47,11 @@ static unsigned evtchn_2l_max_channels(void)
 	return EVTCHN_2L_NR_CHANNELS;
 }
 
+static void evtchn_2l_remove(evtchn_port_t evtchn, unsigned int cpu)
+{
+	clear_bit(evtchn, BM(per_cpu(cpu_evtchn_mask, cpu)));
+}
+
 static void evtchn_2l_bind_to_cpu(evtchn_port_t evtchn, unsigned int cpu,
 				  unsigned int old_cpu)
 {
@@ -355,9 +360,18 @@ static void evtchn_2l_resume(void)
 				EVTCHN_2L_NR_CHANNELS/BITS_PER_EVTCHN_WORD);
 }
 
+static int evtchn_2l_percpu_deinit(unsigned int cpu)
+{
+	memset(per_cpu(cpu_evtchn_mask, cpu), 0, sizeof(xen_ulong_t) *
+			EVTCHN_2L_NR_CHANNELS/BITS_PER_EVTCHN_WORD);
+
+	return 0;
+}
+
 static const struct evtchn_ops evtchn_ops_2l = {
 	.max_channels      = evtchn_2l_max_channels,
 	.nr_channels       = evtchn_2l_max_channels,
+	.remove            = evtchn_2l_remove,
 	.bind_to_cpu       = evtchn_2l_bind_to_cpu,
 	.clear_pending     = evtchn_2l_clear_pending,
 	.set_pending       = evtchn_2l_set_pending,
@@ -367,6 +381,7 @@ static const struct evtchn_ops evtchn_ops_2l = {
 	.unmask            = evtchn_2l_unmask,
 	.handle_events     = evtchn_2l_handle_events,
 	.resume	           = evtchn_2l_resume,
+	.percpu_deinit     = evtchn_2l_percpu_deinit,
 };
 
 void __init xen_evtchn_2l_init(void)
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index e850f79351cb..6c539db81f8f 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -368,6 +368,7 @@ static int xen_irq_info_pirq_setup(unsigned irq,
 static void xen_irq_info_cleanup(struct irq_info *info)
 {
 	set_evtchn_to_irq(info->evtchn, -1);
+	xen_evtchn_port_remove(info->evtchn, info->cpu);
 	info->evtchn = 0;
 	channels_on_cpu_dec(info);
 }
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 0a97c0549db7..18a4090d0709 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -14,6 +14,7 @@ struct evtchn_ops {
 	unsigned (*nr_channels)(void);
 
 	int (*setup)(evtchn_port_t port);
+	void (*remove)(evtchn_port_t port, unsigned int cpu);
 	void (*bind_to_cpu)(evtchn_port_t evtchn, unsigned int cpu,
 			    unsigned int old_cpu);
 
@@ -54,6 +55,13 @@ static inline int xen_evtchn_port_setup(evtchn_port_t evtchn)
 	return 0;
 }
 
+static inline void xen_evtchn_port_remove(evtchn_port_t evtchn,
+					  unsigned int cpu)
+{
+	if (evtchn_ops->remove)
+		evtchn_ops->remove(evtchn, cpu);
+}
+
 static inline void xen_evtchn_port_bind_to_cpu(evtchn_port_t evtchn,
 					       unsigned int cpu,
 					       unsigned int old_cpu)
-- 
2.26.2

