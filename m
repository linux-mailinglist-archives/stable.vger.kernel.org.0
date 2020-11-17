Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292E22B6134
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgKQNQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbgKQNQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:16:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13D17241A6;
        Tue, 17 Nov 2020 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618995;
        bh=iRDqQx8VUT1gst0pKo4miMmmJpIqB/ftKk5+Q5bPtFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VO7xABViE2O8bQiWNzKfjhC1Ijhp7eu6fBgbYBBgF3BrjgivHsdQCHD2iAZAZpHIW
         PHexomUWaD5gVLXicElwYwHKo6oHxV0x5e4K+xqbFnwF4HbvJI7Ts+JM69k3C5HBVg
         PLfy+jLcxxrwFZaIvKITMSDA2+ckTj9gekS3vePc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 4.14 79/85] xen/events: use a common cpu hotplug hook for event channels
Date:   Tue, 17 Nov 2020 14:05:48 +0100
Message-Id: <20201117122114.925635735@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 7beb290caa2adb0a399e735a1e175db9aae0523a upstream.

Today only fifo event channels have a cpu hotplug callback. In order
to prepare for more percpu (de)init work move that callback into
events_base.c and add percpu_init() and percpu_deinit() hooks to
struct evtchn_ops.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c     |   25 +++++++++++++++++++++
 drivers/xen/events/events_fifo.c     |   40 ++++++++++++++++-------------------
 drivers/xen/events/events_internal.h |    3 ++
 3 files changed, 47 insertions(+), 21 deletions(-)

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
@@ -422,19 +407,36 @@ static int evtchn_fifo_alloc_control_blo
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


