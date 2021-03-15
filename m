Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E077F33B9DA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhCOOGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhCOOBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 053EE64E89;
        Mon, 15 Mar 2021 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816840;
        bh=HxQmE0RP0LzC8UMxFs5pgAUqlRaAFNSF8+QAirZSGeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rVM9leCwbZdtNlChMTwNe+OBXWWWMTLTbNiPNRnyyyEO0XS+s8aLhULhBqVdIPEm
         8Pd923PijMDh/wtS9alVOJEOceP9ckZNHIHCN80NVE6C0o+XaoqY4iruRyNQexkPdM
         8DElCtdyhk5Pm1ecapNw3ITUY7RQAcnhK9X1z56c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 95/95] xen/events: avoid handling the same event on two cpus at the same time
Date:   Mon, 15 Mar 2021 14:58:05 +0100
Message-Id: <20210315135743.403598567@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Juergen Gross <jgross@suse.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c     |   25 +++++++++++++++++--------
 drivers/xen/events/events_internal.h |    1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -693,6 +693,12 @@ static void xen_evtchn_close(unsigned in
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
@@ -723,13 +729,13 @@ static void eoi_pirq(struct irq_data *da
 	    likely(!irqd_irq_disabled(data))) {
 		do_mask(info, EVT_MASK_REASON_TEMPORARY);
 
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 
 		irq_move_masked_irq(data);
 
 		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 	} else
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 
 	if (pirq_needs_eoi(data->irq)) {
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
@@ -1565,6 +1571,8 @@ void handle_irq_for_port(evtchn_port_t p
 	}
 
 	info = info_for_irq(irq);
+	if (xchg_acquire(&info->is_active, 1))
+		return;
 
 	if (ctrl->defer_eoi) {
 		info->eoi_cpu = smp_processor_id();
@@ -1752,13 +1760,13 @@ static void ack_dynirq(struct irq_data *
 	    likely(!irqd_irq_disabled(data))) {
 		do_mask(info, EVT_MASK_REASON_TEMPORARY);
 
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 
 		irq_move_masked_irq(data);
 
 		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 	} else
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
 
 static void mask_ack_dynirq(struct irq_data *data)
@@ -1774,7 +1782,7 @@ static void lateeoi_ack_dynirq(struct ir
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1785,7 +1793,7 @@ static void lateeoi_mask_ack_dynirq(stru
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1894,10 +1902,11 @@ static void restore_cpu_ipis(unsigned in
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq)
 {
-	int evtchn = evtchn_from_irq(irq);
+	struct irq_info *info = info_for_irq(irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (VALID_EVTCHN(evtchn))
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
 EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -40,6 +40,7 @@ struct irq_info {
 #define EVT_MASK_REASON_EXPLICIT	0x01
 #define EVT_MASK_REASON_TEMPORARY	0x02
 #define EVT_MASK_REASON_EOI_PENDING	0x04
+	u8 is_active;		/* Is event just being handled? */
 	unsigned irq;
 	unsigned int evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */


