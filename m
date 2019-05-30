Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2752F5FE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfE3Evv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfE3DKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82F3E244A0;
        Thu, 30 May 2019 03:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185851;
        bh=lZqlFI5rRdNdBUUDFTiQ61znwPK0+JBPzKezX7TVJFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/2WqKnSGG296HFRptOTNu0bKo8GsZ9umt9fJfSmJYz9cWoGPLFLEKuVmU9/lCA7R
         yii0rTFZjYC2tEJOx4xL6rb8NpDDPkyUPgAedMtCcz01WR4pbejulhFb37fc6Bl/1E
         VIXoynDJ3GvPZo6t3UJue9s8Aw8ncgmvJzG6SdmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 176/405] irq_work: Do not raise an IPI when queueing work on the local CPU
Date:   Wed, 29 May 2019 20:02:54 -0700
Message-Id: <20190530030550.017947240@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 471ba0e686cb13752bc1ff3216c54b69a2d250ea ]

The QEMU PowerPC/PSeries machine model was not expecting a self-IPI,
and it may be a bit surprising thing to do, so have irq_work_queue_on
do local queueing when target is the current CPU.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190409093403.20994-1-npiggin@gmail.com
[ Simplified the preprocessor comments.
  Fixed unbalanced curly brackets pointed out by Thomas. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq_work.c | 75 ++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 6b7cdf17ccf89..73288914ed5e7 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -56,61 +56,70 @@ void __weak arch_irq_work_raise(void)
 	 */
 }
 
-/*
- * Enqueue the irq_work @work on @cpu unless it's already pending
- * somewhere.
- *
- * Can be re-enqueued while the callback is still in progress.
- */
-bool irq_work_queue_on(struct irq_work *work, int cpu)
+/* Enqueue on current CPU, work must already be claimed and preempt disabled */
+static void __irq_work_queue_local(struct irq_work *work)
 {
-	/* All work should have been flushed before going offline */
-	WARN_ON_ONCE(cpu_is_offline(cpu));
-
-#ifdef CONFIG_SMP
-
-	/* Arch remote IPI send/receive backend aren't NMI safe */
-	WARN_ON_ONCE(in_nmi());
+	/* If the work is "lazy", handle it from next tick if any */
+	if (work->flags & IRQ_WORK_LAZY) {
+		if (llist_add(&work->llnode, this_cpu_ptr(&lazy_list)) &&
+		    tick_nohz_tick_stopped())
+			arch_irq_work_raise();
+	} else {
+		if (llist_add(&work->llnode, this_cpu_ptr(&raised_list)))
+			arch_irq_work_raise();
+	}
+}
 
+/* Enqueue the irq work @work on the current CPU */
+bool irq_work_queue(struct irq_work *work)
+{
 	/* Only queue if not already pending */
 	if (!irq_work_claim(work))
 		return false;
 
-	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
-		arch_send_call_function_single_ipi(cpu);
-
-#else /* #ifdef CONFIG_SMP */
-	irq_work_queue(work);
-#endif /* #else #ifdef CONFIG_SMP */
+	/* Queue the entry and raise the IPI if needed. */
+	preempt_disable();
+	__irq_work_queue_local(work);
+	preempt_enable();
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(irq_work_queue);
 
-/* Enqueue the irq work @work on the current CPU */
-bool irq_work_queue(struct irq_work *work)
+/*
+ * Enqueue the irq_work @work on @cpu unless it's already pending
+ * somewhere.
+ *
+ * Can be re-enqueued while the callback is still in progress.
+ */
+bool irq_work_queue_on(struct irq_work *work, int cpu)
 {
+#ifndef CONFIG_SMP
+	return irq_work_queue(work);
+
+#else /* CONFIG_SMP: */
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(cpu));
+
 	/* Only queue if not already pending */
 	if (!irq_work_claim(work))
 		return false;
 
-	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
-
-	/* If the work is "lazy", handle it from next tick if any */
-	if (work->flags & IRQ_WORK_LAZY) {
-		if (llist_add(&work->llnode, this_cpu_ptr(&lazy_list)) &&
-		    tick_nohz_tick_stopped())
-			arch_irq_work_raise();
+	if (cpu != smp_processor_id()) {
+		/* Arch remote IPI send/receive backend aren't NMI safe */
+		WARN_ON_ONCE(in_nmi());
+		if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
+			arch_send_call_function_single_ipi(cpu);
 	} else {
-		if (llist_add(&work->llnode, this_cpu_ptr(&raised_list)))
-			arch_irq_work_raise();
+		__irq_work_queue_local(work);
 	}
-
 	preempt_enable();
 
 	return true;
+#endif /* CONFIG_SMP */
 }
-EXPORT_SYMBOL_GPL(irq_work_queue);
+
 
 bool irq_work_needs_cpu(void)
 {
-- 
2.20.1



