Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA9A593456
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiHOR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 13:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiHOR7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 13:59:10 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BCB29824;
        Mon, 15 Aug 2022 10:58:23 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 2204B447DB;
        Mon, 15 Aug 2022 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660586299; bh=ua/yZD37LRjVhAmoFQjxcYx+kjIfLUaOX5iBGAQfvEw=;
        h=From:To:Cc:Subject:Date;
        b=E20W8zf0oQ7MmRzAkhNOt1OTJq/0vnenLMc88d/4bu4fEXUiCzyoD2EpMvyWfSc0F
         4TlBXP7FetuHCxn+jjvWqLmdIm16rxXPsGBHHwMkX0JaJh4Crh3qjytcgV87CRQ+yX
         ItUh3fLQYngSALUTESzquJiHZsCjAlsHU6l4uFENtjWKjZwf1Hr81HXZpIk/Ao1bT0
         uXPazqNgf1iBk3pVRVU7vpU4srbpZ690pw5TTuusca5sWclyQnV0hEl798ZtdcxulW
         PEgfdsHXPdj8W3ey7b0HWjXoW3a3u7uLB+GGOdPpyBt1qE783TD4RXuceHn8Yy4b+y
         8lVCr50XyE4SA==
From:   Hector Martin <marcan@marcan.st>
To:     Tejun Heo <tj@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, jirislaby@kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Roman Pen <roman.penyaev@profitbricks.com>,
        Asahi Linux <asahi@lists.linux.dev>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        stable@vger.kernel.org
Subject: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Date:   Tue, 16 Aug 2022 02:58:10 +0900
Message-Id: <20220815175810.17780-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The work queueing operation relies on the atomic test-and-set operation
to set the PENDING bit behaving as a full barrier, even if it fails.
Otherwise, the PENDING state may be observed before memory writes
pertaining to the work complete, as they are allowed to be reordered.
That can lead to work being processed before all prior writes are
observable, and no new work being queued to ensure they are observed at
some point.

This has been broken since the dawn of time, and it was incompletely
fixed by 346c09f80459, which added the necessary barriers in the work
execution path but failed to account for the missing barrier in the
test_and_set_bit() failure case. Fix it by switching to
atomic_long_fetch_or(), which does have unconditional barrier semantics
regardless of whether the bit was already set or not (this is actually
just test_and_set_bit() minus the early exit path).

Discovered [1] on Apple M1 platforms, which are ridiculously
out-of-order and managed to trigger this in the TTY core, of all places.
Easily reproducible by running this m1n1 client script on one M1 machine
connected to another one running the m1n1 bootloader in proxy mode:

=============
from m1n1.setup import *

i = 0
while True:
    a = iface.readmem(u.base, 1170)
    print(i)
    i += 1
=============

The script will hang when the TTY layer fails to push a buffer of data
into the ldisc in a timely manner in tty_flip_buffer_push(), which
writes a buffer pointer and then queue_work()s the ldisc push.

(Note: reproducibility depends on .config options)

Additionally, properly document that queue_work() has guarantees even
when work is already queued (it doesn't make any sense for it not to,
the comment in set_work_pool_and_clear_pending() already implies it
does, and the TTY core and probably quite a few other places rely on
this).

[1] https://lore.kernel.org/lkml/6c089268-4f2c-9fdf-7bcb-107b611fbc21@marcan.st/#t

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 346c09f80459 ("workqueue: fix ghost PENDING flag while doing MQ IO")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 include/linux/workqueue.h | 15 ++++++++++-----
 kernel/workqueue.c        | 39 +++++++++++++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a0143dd24430..d9ea73813a3c 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -484,18 +484,23 @@ extern void wq_worker_comm(char *buf, size_t size, struct task_struct *task);
  * We queue the work to the CPU on which it was submitted, but if the CPU dies
  * it can be processed by another CPU.
  *
- * Memory-ordering properties:  If it returns %true, guarantees that all stores
- * preceding the call to queue_work() in the program order will be visible from
- * the CPU which will execute @work by the time such work executes, e.g.,
+ * Memory-ordering properties:  Guarantees that all stores preceding the call to
+ * queue_work() in the program order will be visible from the CPU which will
+ * execute @work by the time such work executes, e.g.,
  *
  * { x is initially 0 }
  *
  *   CPU0				CPU1
  *
  *   WRITE_ONCE(x, 1);			[ @work is being executed ]
- *   r0 = queue_work(wq, work);		  r1 = READ_ONCE(x);
+ *   queue_work(wq, work);		r0 = READ_ONCE(x);
  *
- * Forbids: r0 == true && r1 == 0
+ * Forbids: r0 == 0 for the currently pending execution of @work after
+ * queue_work() completes.
+ *
+ * If @work was already pending (ret == false), that execution is guaranteed
+ * to observe x == 1. If @work was newly queued (ret == true), the newly
+ * queued execution is guaranteed to observe x == 1.
  */
 static inline bool queue_work(struct workqueue_struct *wq,
 			      struct work_struct *work)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index aeea9731ef80..01bc03eed649 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -655,7 +655,7 @@ static void set_work_pool_and_clear_pending(struct work_struct *work,
 {
 	/*
 	 * The following wmb is paired with the implied mb in
-	 * test_and_set_bit(PENDING) and ensures all updates to @work made
+	 * atomic_long_fetch_or(PENDING) and ensures all updates to @work made
 	 * here are visible to and precede any updates by the next PENDING
 	 * owner.
 	 */
@@ -673,7 +673,7 @@ static void set_work_pool_and_clear_pending(struct work_struct *work,
 	 *
 	 * 1  STORE event_indicated
 	 * 2  queue_work_on() {
-	 * 3    test_and_set_bit(PENDING)
+	 * 3    atomic_long_fetch_or(PENDING)
 	 * 4 }                             set_..._and_clear_pending() {
 	 * 5                                 set_work_data() # clear bit
 	 * 6                                 smp_mb()
@@ -688,6 +688,15 @@ static void set_work_pool_and_clear_pending(struct work_struct *work,
 	 * finish the queued @work.  Meanwhile CPU#1 does not see
 	 * event_indicated is set, because speculative LOAD was executed
 	 * before actual STORE.
+	 *
+	 * Line 3 requires barrier semantics, even on failure. If it were
+	 * implemented with test_and_set_bit() (which does not have
+	 * barrier semantics on failure), that would allow the STORE to
+	 * be reordered after it, and it could be observed by CPU#1 after
+	 * it has executed all the way through to line 8 (and cleared the
+	 * PENDING bit in the process). At this point, CPU#0 would not have
+	 * queued new work (having observed PENDING set), and CPU#1 would not
+	 * have observed the event_indicated store in the last work execution.
 	 */
 	smp_mb();
 }
@@ -1276,8 +1285,9 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			return 1;
 	}

-	/* try to claim PENDING the normal way */
-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
+	/* try to claim PENDING the normal way, see queue_work_on() */
+	if (!(atomic_long_fetch_or(WORK_STRUCT_PENDING, &work->data)
+			& WORK_STRUCT_PENDING))
 		return 0;

 	rcu_read_lock();
@@ -1541,7 +1551,14 @@ bool queue_work_on(int cpu, struct workqueue_struct *wq,

 	local_irq_save(flags);

-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+	/*
+	 * We need unconditional barrier semantics, even on failure,
+	 * to avoid racing set_work_pool_and_clear_pending(). Hence,
+	 * this has to be atomic_long_fetch_or(), not test_and_set_bit()
+	 * which elides the barrier on failure.
+	 */
+	if (!(atomic_long_fetch_or(WORK_STRUCT_PENDING, &work->data)
+			& WORK_STRUCT_PENDING)) {
 		__queue_work(cpu, wq, work);
 		ret = true;
 	}
@@ -1623,7 +1640,9 @@ bool queue_work_node(int node, struct workqueue_struct *wq,

 	local_irq_save(flags);

-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+	/* see queue_work_on() */
+	if (!(atomic_long_fetch_or(WORK_STRUCT_PENDING, &work->data)
+			& WORK_STRUCT_PENDING)) {
 		int cpu = workqueue_select_cpu_near(node);

 		__queue_work(cpu, wq, work);
@@ -1697,7 +1716,9 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	/* read the comment in __queue_work() */
 	local_irq_save(flags);

-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+	/* see queue_work_on() */
+	if (!(atomic_long_fetch_or(WORK_STRUCT_PENDING, &work->data)
+			& WORK_STRUCT_PENDING)) {
 		__queue_delayed_work(cpu, wq, dwork, delay);
 		ret = true;
 	}
@@ -1769,7 +1790,9 @@ bool queue_rcu_work(struct workqueue_struct *wq, struct rcu_work *rwork)
 {
 	struct work_struct *work = &rwork->work;

-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+	/* see queue_work_on() */
+	if (!(atomic_long_fetch_or(WORK_STRUCT_PENDING, &work->data)
+			& WORK_STRUCT_PENDING)) {
 		rwork->wq = wq;
 		call_rcu(&rwork->rcu, rcu_work_rcufn);
 		return true;
--
2.35.1

