Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A5E2A274E
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 10:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgKBJqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 04:46:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:59312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgKBJql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 04:46:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604310399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNfRf+pn3Xo+MAg3xzLdAS7Ww1Yejt/iuMJUOvUyRWg=;
        b=ZYc4cipiJpDSqdILi1POTE4UgrEA0JZoK+LsGTqi9NBj5VplIT+QPzpA7LQ92uDRGCWhLB
        KHuw1k1QpeLulpXoUXCZmnrv3wk8HMPQ9d4bVNe1LhoO+BeekKfNWZRCkxUQsVOH69UPwz
        TvvQ5yseS5kmtLDD/dvKNanR6pNpf0U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66D6DB1EA
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 09:46:39 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 11/13] xen/events: use a common cpu hotplug hook for event channels
Date:   Mon,  2 Nov 2020 10:46:36 +0100
Message-Id: <20201102094638.3355-12-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102094638.3355-1-jgross@suse.com>
References: <20201102094638.3355-1-jgross@suse.com>
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
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/events/events_base.c     | 25 +++++++++++++++++
 drivers/xen/events/events_fifo.c     | 40 +++++++++++++---------------
 drivers/xen/events/events_internal.h |  3 +++
 3 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 6f3041fce48d..a8f180b2acb6 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -34,6 +34,7 @@
 #include <linux/irqnr.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/cpuhotplug.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -1835,6 +1836,26 @@ void xen_callback_vector(void) {}
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
@@ -1845,6 +1866,10 @@ void __init xen_init_IRQ(void)
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
index 82938cff6c7a..fef1d645261e 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -69,6 +69,9 @@ struct evtchn_ops {
 
 	void (*handle_events)(unsigned cpu);
 	void (*resume)(void);
+
+	int (*percpu_init)(unsigned int cpu);
+	int (*percpu_deinit)(unsigned int cpu);
 };
 
 extern const struct evtchn_ops *evtchn_ops;
-- 
2.26.2

