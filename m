Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61412A4B2A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgKCQWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:58864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgKCQWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSBZ8wroRY0dfVbH8H/mKeY2mdQkqyDJ1g4cDD1BSd0=;
        b=dehOYEAiS/lm68+Z6FgpCpVUptRdGiDJ1byHm0fF6mBykh6bZ+86lQV2Bc7ykEgT9x+0Zz
        1tjcnT54linG0eMO0pGBeS6V9aku43iT1Ga7Kg9q1NdoQzCHdWFYMQdRXfJKwdYZfU1Vlc
        q/g1K3xhC/YehcedPDWJpd+rat9zx9w=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 56DE9ADB5
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:40 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 11/13] xen/events: use a common cpu hotplug hook for event channels
Date:   Tue,  3 Nov 2020 17:22:36 +0100
Message-Id: <20201103162238.30264-12-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
References: <20201103162238.30264-1-jgross@suse.com>
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
 drivers/xen/events/events_base.c     | 47 +++++++++++++++++++++
 drivers/xen/events/events_fifo.c     | 61 ++++++++++++----------------
 drivers/xen/events/events_internal.h |  3 ++
 3 files changed, 75 insertions(+), 36 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index fe01950ef78c..9e7cbc3369f7 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -33,6 +33,7 @@
 #include <linux/irqnr.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/cpu.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -1832,6 +1833,50 @@ void xen_callback_vector(void) {}
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
+static int evtchn_cpu_notification(struct notifier_block *self,
+				   unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+	int ret = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		ret = xen_evtchn_cpu_prepare(cpu);
+		break;
+	case CPU_DEAD:
+		ret = xen_evtchn_cpu_dead(cpu);
+		break;
+	default:
+		break;
+	}
+
+	return ret < 0 ? NOTIFY_BAD : NOTIFY_OK;
+}
+
+static struct notifier_block evtchn_cpu_notifier = {
+	.notifier_call  = evtchn_cpu_notification,
+};
+
 void __init xen_init_IRQ(void)
 {
 	int ret = -EINVAL;
@@ -1841,6 +1886,8 @@ void __init xen_init_IRQ(void)
 	if (ret < 0)
 		xen_evtchn_2l_init();
 
+	register_cpu_notifier(&evtchn_cpu_notifier);
+
 	evtchn_to_irq = kcalloc(EVTCHN_ROW(xen_evtchn_max_channels()),
 				sizeof(*evtchn_to_irq), GFP_KERNEL);
 	BUG_ON(!evtchn_to_irq);
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index ce909d830973..db809ee3197b 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -386,21 +386,6 @@ static void evtchn_fifo_resume(void)
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
@@ -423,29 +408,34 @@ static int evtchn_fifo_alloc_control_block(unsigned cpu)
 	return ret;
 }
 
-static int evtchn_fifo_cpu_notification(struct notifier_block *self,
-						  unsigned long action,
-						  void *hcpu)
+static int evtchn_fifo_percpu_init(unsigned int cpu)
 {
-	int cpu = (long)hcpu;
-	int ret = 0;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-		if (!per_cpu(cpu_control_block, cpu))
-			ret = evtchn_fifo_alloc_control_block(cpu);
-		break;
-	case CPU_DEAD:
-		__evtchn_fifo_handle_events(cpu, true);
-		break;
-	default:
-		break;
-	}
-	return ret < 0 ? NOTIFY_BAD : NOTIFY_OK;
+	if (!per_cpu(cpu_control_block, cpu))
+		return evtchn_fifo_alloc_control_block(cpu);
+	return 0;
 }
 
-static struct notifier_block evtchn_fifo_cpu_notifier = {
-	.notifier_call	= evtchn_fifo_cpu_notification,
+static int evtchn_fifo_percpu_deinit(unsigned int cpu)
+{
+	__evtchn_fifo_handle_events(cpu, true);
+	return 0;
+}
+
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
 };
 
 int __init xen_evtchn_fifo_init(void)
@@ -461,7 +451,6 @@ int __init xen_evtchn_fifo_init(void)
 
 	evtchn_ops = &evtchn_ops_fifo;
 
-	register_cpu_notifier(&evtchn_fifo_cpu_notifier);
 out:
 	put_cpu();
 	return ret;
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

