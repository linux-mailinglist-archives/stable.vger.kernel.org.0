Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08B733BC4F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhCOOYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238450AbhCOOXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2063864F3D;
        Mon, 15 Mar 2021 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818194;
        bh=pL8oEeOkVhCTQuvZfaQ9UdTHZ6z+z8pKjV23RvvcqTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOcTpps1wTOuzXtNxPbF3VyYgKm+8BQdTxLqLgfDYk2cMvdIB/JfEoMWinjIKBwLQ
         a3u87hGtOyt7ihvp1dyYNflq8DROx8EA20yoF9EO1fFrNXUBoRPcqeF/KCfhmTiU88
         xFQgaTl4vbKJwDWP6tgjGA7Jiww3U/cr15/ydE8w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.10 288/290] xen/events: avoid handling the same event on two cpus at the same time
Date:   Mon, 15 Mar 2021 15:22:38 +0100
Message-Id: <20210315135551.780250805@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135551.391322899@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.391322899@linuxfoundation.org>
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
 drivers/xen/events/events_base.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

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
@@ -751,6 +752,12 @@ static void xen_evtchn_close(evtchn_port
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
@@ -781,13 +788,13 @@ static void eoi_pirq(struct irq_data *da
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
@@ -1603,6 +1610,8 @@ void handle_irq_for_port(evtchn_port_t p
 	}
 
 	info = info_for_irq(irq);
+	if (xchg_acquire(&info->is_active, 1))
+		return;
 
 	if (ctrl->defer_eoi) {
 		info->eoi_cpu = smp_processor_id();
@@ -1778,13 +1787,13 @@ static void ack_dynirq(struct irq_data *
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
@@ -1800,7 +1809,7 @@ static void lateeoi_ack_dynirq(struct ir
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1811,7 +1820,7 @@ static void lateeoi_mask_ack_dynirq(stru
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1922,10 +1931,11 @@ static void restore_cpu_ipis(unsigned in
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


