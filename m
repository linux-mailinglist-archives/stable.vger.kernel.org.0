Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DA2171C65
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387598AbgB0OLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388724AbgB0OLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F7D20578;
        Thu, 27 Feb 2020 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812697;
        bh=S9GqItKIHASXJmYV/DxK6yz7hoIfKT9dETRIIGassKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiuWHocrKdrDrjWAuNPmixoDc3i+QNeOwAQeR2sAsJC08tTntGUercwVZSrw170ca
         dEni+m8yPEqD8VgVSW3KnE4dyh/NeslQ+K/Jde9iQBYM0Brarf/1XZYSCi79iEFkBG
         gUQAMUUXAmtZPhkx7vNNCnnlDruGIjI4eg7aCow0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 118/135] genirq/proc: Reject invalid affinity masks (again)
Date:   Thu, 27 Feb 2020 14:37:38 +0100
Message-Id: <20200227132246.855068158@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit cba6437a1854fde5934098ec3bd0ee83af3129f5 upstream.

Qian Cai reported that the WARN_ON() in the x86/msi affinity setting code,
which catches cases where the affinity setting is not done on the CPU which
is the current target of the interrupt, triggers during CPU hotplug stress
testing.

It turns out that the warning which was added with the commit addressing
the MSI affinity race unearthed yet another long standing bug.

If user space writes a bogus affinity mask, i.e. it contains no online CPUs,
then it calls irq_select_affinity_usr(). This was introduced for ALPHA in

  eee45269b0f5 ("[PATCH] Alpha: convert to generic irq framework (generic part)")

and subsequently made available for all architectures in

  18404756765c ("genirq: Expose default irq affinity mask (take 3)")

which introduced the circumvention of the affinity setting restrictions for
interrupt which cannot be moved in process context.

The whole exercise is bogus in various aspects:

  1) If the interrupt is already started up then there is absolutely
     no point to honour a bogus interrupt affinity setting from user
     space. The interrupt is already assigned to an online CPU and it
     does not make any sense to reassign it to some other randomly
     chosen online CPU.

  2) If the interupt is not yet started up then there is no point
     either. A subsequent startup of the interrupt will invoke
     irq_setup_affinity() anyway which will chose a valid target CPU.

So the only correct solution is to just return -EINVAL in case user space
wrote an affinity mask which does not contain any online CPUs, except for
ALPHA which has it's own magic sauce for this.

Fixes: 18404756765c ("genirq: Expose default irq affinity mask (take 3)")
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Qian Cai <cai@lca.pw>
Link: https://lkml.kernel.org/r/878sl8xdbm.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/internals.h |    2 --
 kernel/irq/manage.c    |   18 ++----------------
 kernel/irq/proc.c      |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 18 deletions(-)

--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -128,8 +128,6 @@ static inline void unregister_handler_pr
 
 extern bool irq_can_set_affinity_usr(unsigned int irq);
 
-extern int irq_select_affinity_usr(unsigned int irq);
-
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 extern int irq_do_set_affinity(struct irq_data *data,
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -442,23 +442,9 @@ int irq_setup_affinity(struct irq_desc *
 {
 	return irq_select_affinity(irq_desc_get_irq(desc));
 }
-#endif
+#endif /* CONFIG_AUTO_IRQ_AFFINITY */
+#endif /* CONFIG_SMP */
 
-/*
- * Called when a bogus affinity is set via /proc/irq
- */
-int irq_select_affinity_usr(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-	int ret;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret = irq_setup_affinity(desc);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return ret;
-}
-#endif
 
 /**
  *	irq_set_vcpu_affinity - Set vcpu affinity for the interrupt
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -111,6 +111,28 @@ static int irq_affinity_list_proc_show(s
 	return show_irq_affinity(AFFINITY_LIST, m);
 }
 
+#ifndef CONFIG_AUTO_IRQ_AFFINITY
+static inline int irq_select_affinity_usr(unsigned int irq)
+{
+	/*
+	 * If the interrupt is started up already then this fails. The
+	 * interrupt is assigned to an online CPU already. There is no
+	 * point to move it around randomly. Tell user space that the
+	 * selected mask is bogus.
+	 *
+	 * If not then any change to the affinity is pointless because the
+	 * startup code invokes irq_setup_affinity() which will select
+	 * a online CPU anyway.
+	 */
+	return -EINVAL;
+}
+#else
+/* ALPHA magic affinity auto selector. Keep it for historical reasons. */
+static inline int irq_select_affinity_usr(unsigned int irq)
+{
+	return irq_select_affinity(irq);
+}
+#endif
 
 static ssize_t write_irq_affinity(int type, struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)


