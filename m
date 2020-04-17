Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495951ADC92
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 13:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgDQLy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 07:54:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:40950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730469AbgDQLy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 07:54:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17549AFDC;
        Fri, 17 Apr 2020 11:54:57 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     security@xen.org
Cc:     Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/9] xen/events: avoid removing an event channel while handling it
Date:   Fri, 17 Apr 2020 13:54:46 +0200
Message-Id: <20200417115454.24931-2-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200417115454.24931-1-jgross@suse.com>
References: <20200417115454.24931-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Today it can happen that an event channel is being removed from the
system while the event handling loop is active. This can lead to a
race resulting in crashes or WARN() splats.

Fix this problem by using a rwlock taken as reader in the event
handling loop and as writer when removing an event channel.

As the observed problem was a NULL dereference in evtchn_from_irq()
make this function more robust against races by testing the irq_info
pointer to be not NULL before dereferencing it.

Cc: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/events/events_base.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 3a791c8485d0..178a471906de 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/irqnr.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -70,6 +71,9 @@ const struct evtchn_ops *evtchn_ops;
  */
 static DEFINE_MUTEX(irq_mapping_update_lock);
 
+/* Lock protecting event handling loop against removing event channels. */
+static DEFINE_RWLOCK(evtchn_rwlock);
+
 static LIST_HEAD(xen_irq_list_head);
 
 /* IRQ <-> VIRQ mapping. */
@@ -247,10 +251,14 @@ static void xen_irq_info_cleanup(struct irq_info *info)
  */
 evtchn_port_t evtchn_from_irq(unsigned irq)
 {
-	if (WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq))
+	struct irq_info *info = NULL;
+
+	if (likely(irq < nr_irqs))
+		info = info_for_irq(irq);
+	if (WARN(!info, "Invalid irq %d!\n", irq))
 		return 0;
 
-	return info_for_irq(irq)->evtchn;
+	return info->evtchn;
 }
 
 unsigned int irq_from_evtchn(evtchn_port_t evtchn)
@@ -603,6 +611,7 @@ static void __unbind_from_irq(unsigned int irq)
 {
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
 	struct irq_info *info = irq_get_handler_data(irq);
+	unsigned long flags;
 
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -610,8 +619,10 @@ static void __unbind_from_irq(unsigned int irq)
 			return;
 	}
 
+	write_lock_irqsave(&evtchn_rwlock, flags);
+
 	if (VALID_EVTCHN(evtchn)) {
-		unsigned int cpu = cpu_from_irq(irq);
+		unsigned int cpu = cpu_from_irq(irq);;
 
 		xen_evtchn_close(evtchn);
 
@@ -629,6 +640,8 @@ static void __unbind_from_irq(unsigned int irq)
 		xen_irq_info_cleanup(info);
 	}
 
+	write_unlock_irqrestore(&evtchn_rwlock, flags);
+
 	xen_free_irq(irq);
 }
 
@@ -1219,6 +1232,8 @@ static void __xen_evtchn_do_upcall(void)
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 	int cpu = smp_processor_id();
 
+	read_lock(&evtchn_rwlock);
+
 	do {
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1229,6 +1244,8 @@ static void __xen_evtchn_do_upcall(void)
 		virt_rmb(); /* Hypervisor can set upcall pending. */
 
 	} while (vcpu_info->evtchn_upcall_pending);
+
+	read_unlock(&evtchn_rwlock);
 }
 
 void xen_evtchn_do_upcall(struct pt_regs *regs)
-- 
2.16.4

