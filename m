Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2892A4827
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgKCOac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:30:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:38890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729726AbgKCO3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:29:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604413753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qk882jnlZj5/NCUogdfBkHOBP87mZQ89Df4JgmJ2x1s=;
        b=fxyUSYazCMHc2m6cGwH0+wdsOhBKZmfvcqsMl9BORLP/kdcFTdFVS8Mz4IwiJELmZnIj9f
        7NnSZLYe/zYJT9Unxnt1A2PP8zSATAi04jcD3Klo+wVweyKLIyZnwsn410VwR3N8cjQruR
        1D6048AKRvF3MO8tFhiQ51y6Ru2jBek=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7095B2A9
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:29:12 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 12/14] xen/events: use a common cpu hotplug hook for event channels
Date:   Tue,  3 Nov 2020 15:29:09 +0100
Message-Id: <20201103142911.21980-13-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103142911.21980-1-jgross@suse.com>
References: <20201103142911.21980-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Today only fifo event channels have a cpu hotplug callback. In order
to prepare for more percpu (de)init work move that callback into
events_base.c and add percpu_init() and percpu_deinit() hooks to
struct evtchn_ops.

This is part of XSA-332.

This is upstream commit 7beb290caa2adb0a399e735a1e175db9aae0523a

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>xen/events: use a common cpu hotplug hook for event
 channels

Today only fifo event channels have a cpu hotplug callback. In order
to prepare for more percpu (de)init work move that callback into
events_base.c and add percpu_init() and percpu_deinit() hooks to
struct evtchn_ops.

This is part of XSA-332.

This is upstream commit 7beb290caa2adb0a399e735a1e175db9aae0523a

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/events/events_base.c     | 25 +++++++++++++++++
 drivers/xen/events/events_fifo.c     | 40 +++++++++++++---------------
 drivers/xen/events/events_internal.h |  3 +++
 3 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 0c0114800f6c..bbeb1d3aecfd 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -33,6 +33,7 @@
 #include <linux/irqnr.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/cpuhotplug.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -1833,6 +1834,26 @@ void xen_callback_vector(void) {}
 static bool fifo_events = true;
 module_param(fifo_events, bool, 0);
 
+static int xen_evtchn_cpu_prepare(unsigned int cpu)
+{
+	int ret = 0;
+
+	if (evtchn_ops->percpu_init)
+		ret = evtchn_ops->percpu_init(cpu);
+
+	return ret;
+}
+
+static int xen_evtchn_cpu_dead(unsigned int cpu)
+{
+	int ret = 0;
+
+	if (evtchn_ops->percpu_deinit)
+		ret = evtchn_ops->percpu_deinit(cpu);
+
+	return ret;
+}
+
 void __init xen_init_IRQ(void)
 {
 	int ret = -EINVAL;
@@ -1843,6 +1864,10 @@ void __init xen_init_IRQ(void)
 	if (ret < 0)
 		xen_evtchn_2l_init();
 
+	cpuhp_setup_state_nocalls(CPUHP_XEN_EVTCHN_PREPARE,
+				  "xen/evtchn:prepare",
+				  xen_evtchn_cpu_prepare, xen_evtchn_cpu_dead);
+
 	evtchn_to_irq = kcalloc(EVTCHN_ROW(xen_evtchn_max_channels()),
 				sizeof(*evtchn_to_irq), GFP_KERNEL);
 	BUG_ON(!evtchn_to_irq);
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 3071256a9413..59e6002c9699 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -385,21 +385,6 @@ static void evtchn_fifo_resume(void)
 	event_array_pages = 0;
 }
 
-static const struct evtchn_ops evtchn_ops_fifo = {
-	.max_channels      = evtchn_fifo_max_channels,
-	.nr_channels       = evtchn_fifo_nr_channels,
-	.setup             = evtchn_fifo_setup,
-	.bind_to_cpu       = evtchn_fifo_bind_to_cpu,
-	.clear_pending     = evtchn_fifo_clear_pending,
-	.set_pending       = evtchn_fifo_set_pending,
-	.is_pending        = evtchn_fifo_is_pending,
-	.test_and_set_mask = evtchn_fifo_test_and_set_mask,
-	.mask              = evtchn_fifo_mask,
-	.unmask            = evtchn_fifo_unmask,
-	.handle_events     = evtchn_fifo_handle_events,
-	.resume            = evtchn_fifo_resume,
-};
-
 static int evtchn_fifo_alloc_control_block(unsigned cpu)
 {
 	void *control_block = NULL;
@@ -422,19 +407,36 @@ static int evtchn_fifo_alloc_control_block(unsigned cpu)
 	return ret;
 }
 
-static int xen_evtchn_cpu_prepare(unsigned int cpu)
+static int evtchn_fifo_percpu_init(unsigned int cpu)
 {
 	if (!per_cpu(cpu_control_block, cpu))
 		return evtchn_fifo_alloc_control_block(cpu);
 	return 0;
 }
 
-static int xen_evtchn_cpu_dead(unsigned int cpu)
+static int evtchn_fifo_percpu_deinit(unsigned int cpu)
 {
 	__evtchn_fifo_handle_events(cpu, true);
 	return 0;
 }
 
+static const struct evtchn_ops evtchn_ops_fifo = {
+	.max_channels      = evtchn_fifo_max_channels,
+	.nr_channels       = evtchn_fifo_nr_channels,
+	.setup             = evtchn_fifo_setup,
+	.bind_to_cpu       = evtchn_fifo_bind_to_cpu,
+	.clear_pending     = evtchn_fifo_clear_pending,
+	.set_pending       = evtchn_fifo_set_pending,
+	.is_pending        = evtchn_fifo_is_pending,
+	.test_and_set_mask = evtchn_fifo_test_and_set_mask,
+	.mask              = evtchn_fifo_mask,
+	.unmask            = evtchn_fifo_unmask,
+	.handle_events     = evtchn_fifo_handle_events,
+	.resume            = evtchn_fifo_resume,
+	.percpu_init       = evtchn_fifo_percpu_init,
+	.percpu_deinit     = evtchn_fifo_percpu_deinit,
+};
+
 int __init xen_evtchn_fifo_init(void)
 {
 	int cpu = smp_processor_id();
@@ -448,9 +450,5 @@ int __init xen_evtchn_fifo_init(void)
 
 	evtchn_ops = &evtchn_ops_fifo;
 
-	cpuhp_setup_state_nocalls(CPUHP_XEN_EVTCHN_PREPARE,
-				  "xen/evtchn:prepare",
-				  xen_evtchn_cpu_prepare, xen_evtchn_cpu_dead);
-
 	return ret;
 }
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 50c2050a1e32..980a56d51e4c 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -71,6 +71,9 @@ struct evtchn_ops {
 
 	void (*handle_events)(unsigned cpu);
 	void (*resume)(void);
+
+	int (*percpu_init)(unsigned int cpu);
+	int (*percpu_deinit)(unsigned int cpu);
 };
 
 extern const struct evtchn_ops *evtchn_ops;
-- 
2.26.2

