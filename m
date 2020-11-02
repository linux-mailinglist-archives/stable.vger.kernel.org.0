Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474572A2EBA
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgKBP5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:57:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:39052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgKBP5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 10:57:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604332626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFyLwh4kPOhMumz4Kjuj/7SzN2WgUKA80deEKk/G/X4=;
        b=H0ok6B1lWKWY1i0TQo1YiwJnjHsRA3vonWgZncLj1Cg1PnQHtwvGErKitXMtw2n4Lwe+Gp
        xRfe174slt45VNmr9rXLA8zggGunbyv9daD+R3pt2tHD9uvh5BTmcQKdFU4CaNu2vjNsVg
        rZUJs4juKuTZ5BbFwZlgtlcs+OHAsO8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C0C4AFD8
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 15:57:06 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 02/14] xen/events: avoid removing an event channel while handling it
Date:   Mon,  2 Nov 2020 16:56:53 +0100
Message-Id: <20201102155705.8578-3-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102155705.8578-1-jgross@suse.com>
References: <20201102155705.8578-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Today it can happen that an event channel is being removed from the
system while the event handling loop is active. This can lead to a
race resulting in crashes or WARN() splats when trying to access the
irq_info structure related to the event channel.

Fix this problem by using a rwlock taken as reader in the event
handling loop and as writer when deallocating the irq_info structure.

As the observed problem was a NULL dereference in evtchn_from_irq()
make this function more robust against races by testing the irq_info
pointer to be not NULL before dereferencing it.

And finally make all accesses to evtchn_to_irq[row][col] atomic ones
in order to avoid seeing partial updates of an array element in irq
handling. Note that irq handling can be entered only for event channels
which have been valid before, so any not populated row isn't a problem
in this regard, as rows are only ever added and never removed.

This is XSA-331.

This is upstream commit 073d0552ead5bfc7a3a9c01de590e924f11b5dd2

Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reported-by: Jinoh Kang <luke1337@theori.io>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/events/events_base.c | 41 ++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index fdeeef2b9947..048c05615b77 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/irqnr.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -69,6 +70,23 @@ const struct evtchn_ops *evtchn_ops;
  */
 static DEFINE_MUTEX(irq_mapping_update_lock);
 
+/*
+ * Lock protecting event handling loop against removing event channels.
+ * Adding of event channels is no issue as the associated IRQ becomes active
+ * only after everything is setup (before request_[threaded_]irq() the handler
+ * can't be entered for an event, as the event channel will be unmasked only
+ * then).
+ */
+static DEFINE_RWLOCK(evtchn_rwlock);
+
+/*
+ * Lock hierarchy:
+ *
+ * irq_mapping_update_lock
+ *   evtchn_rwlock
+ *     IRQ-desc lock
+ */
+
 static LIST_HEAD(xen_irq_list_head);
 
 /* IRQ <-> VIRQ mapping. */
@@ -103,7 +121,7 @@ static void clear_evtchn_to_irq_row(unsigned row)
 	unsigned col;
 
 	for (col = 0; col < EVTCHN_PER_ROW; col++)
-		evtchn_to_irq[row][col] = -1;
+		WRITE_ONCE(evtchn_to_irq[row][col], -1);
 }
 
 static void clear_evtchn_to_irq_all(void)
@@ -140,7 +158,7 @@ static int set_evtchn_to_irq(unsigned evtchn, unsigned irq)
 		clear_evtchn_to_irq_row(row);
 	}
 
-	evtchn_to_irq[row][col] = irq;
+	WRITE_ONCE(evtchn_to_irq[row][col], irq);
 	return 0;
 }
 
@@ -150,7 +168,7 @@ int get_evtchn_to_irq(unsigned evtchn)
 		return -1;
 	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
 		return -1;
-	return evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)];
+	return READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
 }
 
 /* Get info for IRQ */
@@ -259,10 +277,14 @@ static void xen_irq_info_cleanup(struct irq_info *info)
  */
 unsigned int evtchn_from_irq(unsigned irq)
 {
-	if (unlikely(WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq)))
+	const struct irq_info *info = NULL;
+
+	if (likely(irq < nr_irqs))
+		info = info_for_irq(irq);
+	if (!info)
 		return 0;
 
-	return info_for_irq(irq)->evtchn;
+	return info->evtchn;
 }
 
 unsigned irq_from_evtchn(unsigned int evtchn)
@@ -438,16 +460,21 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 static void xen_free_irq(unsigned irq)
 {
 	struct irq_info *info = info_for_irq(irq);
+	unsigned long flags;
 
 	if (WARN_ON(!info))
 		return;
 
+	write_lock_irqsave(&evtchn_rwlock, flags);
+
 	list_del(&info->list);
 
 	set_info_for_irq(irq, NULL);
 
 	WARN_ON(info->refcnt > 0);
 
+	write_unlock_irqrestore(&evtchn_rwlock, flags);
+
 	kfree(info);
 
 	/* Legacy IRQ descriptors are managed by the arch. */
@@ -1233,6 +1260,8 @@ static void __xen_evtchn_do_upcall(void)
 	int cpu = get_cpu();
 	unsigned count;
 
+	read_lock(&evtchn_rwlock);
+
 	do {
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1247,6 +1276,8 @@ static void __xen_evtchn_do_upcall(void)
 		__this_cpu_write(xed_nesting_count, 0);
 	} while (count != 1 || vcpu_info->evtchn_upcall_pending);
 
+	read_unlock(&evtchn_rwlock);
+
 out:
 
 	put_cpu();
-- 
2.26.2

