Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B1C798E8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfG2TdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbfG2TdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:33:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5314A21655;
        Mon, 29 Jul 2019 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428793;
        bh=eO0h03KlQJOXUAo5ZXToyNf4OaRQbcRRIWCrBWlHd+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xN76abjBHNFxeLNmG5gdH7wPLpV00gnTiZ+bZocS4bAGbddgJYxQhIatQmMpavpxu
         NeAdgDq4cmPDFZhpYwDPPYnglri4KIFpXakMZI6rxgkw4/J+3wkMPHOo3iRTT1ACFX
         WlLE31yrDJuTEl/AyOsp+RU7/krPqt0lkXU87Xms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 149/293] xen/events: fix binding user event channels to cpus
Date:   Mon, 29 Jul 2019 21:20:40 +0200
Message-Id: <20190729190835.986303022@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit bce5963bcb4f9934faa52be323994511d59fd13c upstream.

When binding an interdomain event channel to a vcpu via
IOCTL_EVTCHN_BIND_INTERDOMAIN not only the event channel needs to be
bound, but the affinity of the associated IRQi must be changed, too.
Otherwise the IRQ and the event channel won't be moved to another vcpu
in case the original vcpu they were bound to is going offline.

Cc: <stable@vger.kernel.org> # 4.13
Fixes: c48f64ab472389df ("xen-evtchn: Bind dyn evtchn:qemu-dm interrupt to next online VCPU")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_base.c |   12 ++++++++++--
 drivers/xen/evtchn.c             |    2 +-
 include/xen/events.h             |    3 ++-
 3 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1293,7 +1293,7 @@ void rebind_evtchn_irq(int evtchn, int i
 }
 
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-int xen_rebind_evtchn_to_cpu(int evtchn, unsigned tcpu)
+static int xen_rebind_evtchn_to_cpu(int evtchn, unsigned int tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
 	int masked;
@@ -1327,7 +1327,6 @@ int xen_rebind_evtchn_to_cpu(int evtchn,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xen_rebind_evtchn_to_cpu);
 
 static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
 			    bool force)
@@ -1341,6 +1340,15 @@ static int set_affinity_irq(struct irq_d
 	return ret;
 }
 
+/* To be called with desc->lock held. */
+int xen_set_affinity_evtchn(struct irq_desc *desc, unsigned int tcpu)
+{
+	struct irq_data *d = irq_desc_get_irq_data(desc);
+
+	return set_affinity_irq(d, cpumask_of(tcpu), false);
+}
+EXPORT_SYMBOL_GPL(xen_set_affinity_evtchn);
+
 static void enable_dynirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -447,7 +447,7 @@ static void evtchn_bind_interdom_next_vc
 	this_cpu_write(bind_last_selected_cpu, selected_cpu);
 
 	/* unmask expects irqs to be disabled */
-	xen_rebind_evtchn_to_cpu(evtchn, selected_cpu);
+	xen_set_affinity_evtchn(desc, selected_cpu);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -3,6 +3,7 @@
 #define _XEN_EVENTS_H
 
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #ifdef CONFIG_PCI_MSI
 #include <linux/msi.h>
 #endif
@@ -59,7 +60,7 @@ void evtchn_put(unsigned int evtchn);
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
 void rebind_evtchn_irq(int evtchn, int irq);
-int xen_rebind_evtchn_to_cpu(int evtchn, unsigned tcpu);
+int xen_set_affinity_evtchn(struct irq_desc *desc, unsigned int tcpu);
 
 static inline void notify_remote_via_evtchn(int port)
 {


