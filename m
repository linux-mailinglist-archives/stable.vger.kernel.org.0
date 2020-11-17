Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E822B60B4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgKQNL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbgKQNL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD87E24199;
        Tue, 17 Nov 2020 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618717;
        bh=MEiHk3t9Dj3Mu+y5Wt/0luwyFH95ATsHIO9D+NuWnps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVTaFX1ZoLfcehwbwssK3f7F3swohAmtvi5z4sABJ9vfzMerrlnajPCJn+kqObkw8
         BhREuhePESE932aJqD8H2bGUKF7UsiTgRuHkGpqfXBEWxfy3xpE81YEMKyX3ZH/TGW
         9ctxfbWyqEHDUKg677RRF4SVVLJoUtWXhy2m3OEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Jinoh Kang <luke1337@theori.io>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: [PATCH 4.9 62/78] xen/events: avoid removing an event channel while handling it
Date:   Tue, 17 Nov 2020 14:05:28 +0100
Message-Id: <20201117122112.141846946@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 073d0552ead5bfc7a3a9c01de590e924f11b5dd2 upstream.

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

Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reported-by: Jinoh Kang <luke1337@theori.io>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |   40 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/irqnr.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -70,6 +71,23 @@ const struct evtchn_ops *evtchn_ops;
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
@@ -104,7 +122,7 @@ static void clear_evtchn_to_irq_row(unsi
 	unsigned col;
 
 	for (col = 0; col < EVTCHN_PER_ROW; col++)
-		evtchn_to_irq[row][col] = -1;
+		WRITE_ONCE(evtchn_to_irq[row][col], -1);
 }
 
 static void clear_evtchn_to_irq_all(void)
@@ -141,7 +159,7 @@ static int set_evtchn_to_irq(unsigned ev
 		clear_evtchn_to_irq_row(row);
 	}
 
-	evtchn_to_irq[row][col] = irq;
+	WRITE_ONCE(evtchn_to_irq[row][col], irq);
 	return 0;
 }
 
@@ -151,7 +169,7 @@ int get_evtchn_to_irq(unsigned evtchn)
 		return -1;
 	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
 		return -1;
-	return evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)];
+	return READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
 }
 
 /* Get info for IRQ */
@@ -260,10 +278,14 @@ static void xen_irq_info_cleanup(struct
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
@@ -447,16 +469,21 @@ static int __must_check xen_allocate_irq
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
@@ -1242,6 +1269,8 @@ static void __xen_evtchn_do_upcall(void)
 	int cpu = get_cpu();
 	unsigned count;
 
+	read_lock(&evtchn_rwlock);
+
 	do {
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1257,6 +1286,7 @@ static void __xen_evtchn_do_upcall(void)
 	} while (count != 1 || vcpu_info->evtchn_upcall_pending);
 
 out:
+	read_unlock(&evtchn_rwlock);
 
 	put_cpu();
 }


