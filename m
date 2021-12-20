Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB0647AE9A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhLTPBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37744 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbhLTO7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0550B80EE9;
        Mon, 20 Dec 2021 14:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16823C36AE8;
        Mon, 20 Dec 2021 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012384;
        bh=xiHQwyM5v4QeT+CyXxfNPYIbPPQruwEwIJ1MasedF4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di6hW1gaGHg51+Gki4js9GHdgBeeAUC1BDP48gf/3q3xctPfiQOI6kc63wgSImdN/
         gfoGhlRWPA41Uj+GFg8lDqLYry06CE92cxSHcXTxdOVkW/RZBWXgfy3SrlYkjlgdI4
         Cu5JMGRuqUBPqnREM88vd4K9cS5dK+7HbcOiJoxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.15 175/177] xen/console: harden hvc_xen against event channel storms
Date:   Mon, 20 Dec 2021 15:35:25 +0100
Message-Id: <20211220143045.957409400@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit fe415186b43df0db1f17fa3a46275fd92107fe71 upstream.

The Xen console driver is still vulnerable for an attack via excessive
number of events sent by the backend. Fix that by using a lateeoi event
channel.

For the normal domU initial console this requires the introduction of
bind_evtchn_to_irq_lateeoi() as there is no xenbus device available
at the time the event channel is bound to the irq.

As the decision whether an interrupt was spurious or not requires to
test for bytes having been read from the backend, move sending the
event into the if statement, as sending an event without having found
any bytes to be read is making no sense at all.

This is part of XSA-391

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c        |   30 +++++++++++++++++++++++++++---
 drivers/xen/events/events_base.c |    6 ++++++
 include/xen/events.h             |    1 +
 3 files changed, 34 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -37,6 +37,8 @@ struct xencons_info {
 	struct xenbus_device *xbdev;
 	struct xencons_interface *intf;
 	unsigned int evtchn;
+	XENCONS_RING_IDX out_cons;
+	unsigned int out_cons_same;
 	struct hvc_struct *hvc;
 	int irq;
 	int vtermno;
@@ -138,6 +140,8 @@ static int domU_read_console(uint32_t vt
 	XENCONS_RING_IDX cons, prod;
 	int recv = 0;
 	struct xencons_info *xencons = vtermno_to_xencons(vtermno);
+	unsigned int eoiflag = 0;
+
 	if (xencons == NULL)
 		return -EINVAL;
 	intf = xencons->intf;
@@ -157,7 +161,27 @@ static int domU_read_console(uint32_t vt
 	mb();			/* read ring before consuming */
 	intf->in_cons = cons;
 
-	notify_daemon(xencons);
+	/*
+	 * When to mark interrupt having been spurious:
+	 * - there was no new data to be read, and
+	 * - the backend did not consume some output bytes, and
+	 * - the previous round with no read data didn't see consumed bytes
+	 *   (we might have a race with an interrupt being in flight while
+	 *   updating xencons->out_cons, so account for that by allowing one
+	 *   round without any visible reason)
+	 */
+	if (intf->out_cons != xencons->out_cons) {
+		xencons->out_cons = intf->out_cons;
+		xencons->out_cons_same = 0;
+	}
+	if (recv) {
+		notify_daemon(xencons);
+	} else if (xencons->out_cons_same++ > 1) {
+		eoiflag = XEN_EOI_FLAG_SPURIOUS;
+	}
+
+	xen_irq_lateeoi(xencons->irq, eoiflag);
+
 	return recv;
 }
 
@@ -386,7 +410,7 @@ static int xencons_connect_backend(struc
 	if (ret)
 		return ret;
 	info->evtchn = evtchn;
-	irq = bind_evtchn_to_irq(evtchn);
+	irq = bind_interdomain_evtchn_to_irq_lateeoi(dev, evtchn);
 	if (irq < 0)
 		return irq;
 	info->irq = irq;
@@ -550,7 +574,7 @@ static int __init xen_hvc_init(void)
 			return r;
 
 		info = vtermno_to_xencons(HVC_COOKIE);
-		info->irq = bind_evtchn_to_irq(info->evtchn);
+		info->irq = bind_evtchn_to_irq_lateeoi(info->evtchn);
 	}
 	if (info->irq < 0)
 		info->irq = 0; /* NO_IRQ */
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1251,6 +1251,12 @@ int bind_evtchn_to_irq(evtchn_port_t evt
 }
 EXPORT_SYMBOL_GPL(bind_evtchn_to_irq);
 
+int bind_evtchn_to_irq_lateeoi(evtchn_port_t evtchn)
+{
+	return bind_evtchn_to_irq_chip(evtchn, &xen_lateeoi_chip, NULL);
+}
+EXPORT_SYMBOL_GPL(bind_evtchn_to_irq_lateeoi);
+
 static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 {
 	struct evtchn_bind_ipi bind_ipi;
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -17,6 +17,7 @@ struct xenbus_device;
 unsigned xen_evtchn_nr_channels(void);
 
 int bind_evtchn_to_irq(evtchn_port_t evtchn);
+int bind_evtchn_to_irq_lateeoi(evtchn_port_t evtchn);
 int bind_evtchn_to_irqhandler(evtchn_port_t evtchn,
 			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,


