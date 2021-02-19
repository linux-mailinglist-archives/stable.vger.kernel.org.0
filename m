Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2130331FC39
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 16:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBSPld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 10:41:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:47470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhBSPl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 10:41:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613749238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3hsQtjVhbUJuzJrwS+bXrEjvj+YDAiuRUM066+18HU=;
        b=Mc5dLu2iK4ri54BVS8sVlgoCdpzZyxnZb6PrS1izcSrnyoWAfPFIU02dYvCgRltNbGbIHW
        oI3sqwmM0Q2vgPMX7v3/FBtanmeY4inkYGxGOt//Jb19mpHGoSbfO8NU+nPaL4L7JnOwyJ
        lXkAGmpRFn162CNsNJmSx3FibIYwqZw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7C5A8AF23;
        Fri, 19 Feb 2021 15:40:38 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>
Subject: [PATCH v3 3/8] xen/events: avoid handling the same event on two cpus at the same time
Date:   Fri, 19 Feb 2021 16:40:25 +0100
Message-Id: <20210219154030.10892-4-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219154030.10892-1-jgross@suse.com>
References: <20210219154030.10892-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When changing the cpu affinity of an event it can happen today that
(with some unlucky timing) the same event will be handled on the old
and the new cpu at the same time.

Avoid that by adding an "event active" flag to the per-event data and
call the handler only if this flag isn't set.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- new patch
V3:
- use common helper for end of handler action (Julien Grall)
- move setting is_active to 0 for lateeoi (Boris Ostrovsky)
---
 drivers/xen/events/events_base.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index e157e7506830..9d7ba7623510 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -102,6 +102,7 @@ struct irq_info {
 #define EVT_MASK_REASON_EXPLICIT	0x01
 #define EVT_MASK_REASON_TEMPORARY	0x02
 #define EVT_MASK_REASON_EOI_PENDING	0x04
+	u8 is_active;		/* Is event just being handled? */
 	unsigned irq;
 	evtchn_port_t evtchn;   /* event channel */
 	unsigned short cpu;     /* cpu bound */
@@ -791,6 +792,12 @@ static void xen_evtchn_close(evtchn_port_t port)
 		BUG();
 }
 
+static void event_handler_exit(struct irq_info *info)
+{
+	smp_store_release(&info->is_active, 0);
+	clear_evtchn(info->evtchn);
+}
+
 static void pirq_query_unmask(int irq)
 {
 	struct physdev_irq_status_query irq_status;
@@ -809,14 +816,15 @@ static void pirq_query_unmask(int irq)
 
 static void eoi_pirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 	struct physdev_eoi eoi = { .irq = pirq_from_irq(data->irq) };
 	int rc = 0;
 
 	if (!VALID_EVTCHN(evtchn))
 		return;
 
-	clear_evtchn(evtchn);
+	event_handler_exit(info);
 
 	if (pirq_needs_eoi(data->irq)) {
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
@@ -1640,6 +1648,8 @@ void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 	}
 
 	info = info_for_irq(irq);
+	if (xchg_acquire(&info->is_active, 1))
+		return;
 
 	if (ctrl->defer_eoi) {
 		info->eoi_cpu = smp_processor_id();
@@ -1823,12 +1833,11 @@ static void disable_dynirq(struct irq_data *data)
 
 static void ack_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
-
-	if (!VALID_EVTCHN(evtchn))
-		return;
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
-	clear_evtchn(evtchn);
+	if (VALID_EVTCHN(evtchn))
+		event_handler_exit(info);
 }
 
 static void mask_ack_dynirq(struct irq_data *data)
@@ -1844,7 +1853,7 @@ static void lateeoi_ack_dynirq(struct irq_data *data)
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1856,7 +1865,7 @@ static void lateeoi_mask_ack_dynirq(struct irq_data *data)
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT |
 			      EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1969,10 +1978,11 @@ static void restore_cpu_ipis(unsigned int cpu)
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(irq);
+	struct irq_info *info = info_for_irq(irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (VALID_EVTCHN(evtchn))
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
 EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
-- 
2.26.2

