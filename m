Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A84383040
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbhEQOZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239339AbhEQOXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953D660E0C;
        Mon, 17 May 2021 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260750;
        bh=XnCNmbyJV+3bTY1zE4tAOCWRkCNnGA/vc64oZ3JCjPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TX1UOKkB104elMpSlmU7vzIFCcucCCnRAUlpcXskZ+ozEpQXT+ud9xYYyCJFCnzin
         Ja7IRu8HfYYBNftnD/Qmbf6oLi/7vq8X9kzystFiXVOaolnoKNzJpD7UMXGPcdEIQl
         5dBMR1taTRZVWrMUkg2GscA3yHO3Gx5iAKpkN75k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jann Horn <jannh@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 224/363] kfence: await for allocation using wait_event
Date:   Mon, 17 May 2021 16:01:30 +0200
Message-Id: <20210517140310.166493645@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 407f1d8c1b5f3ec66a6a3eb835d3b81c76440f4e ]

Patch series "kfence: optimize timer scheduling", v2.

We have observed that mostly-idle systems with KFENCE enabled wake up
otherwise idle CPUs, preventing such to enter a lower power state.
Debugging revealed that KFENCE spends too much active time in
toggle_allocation_gate().

While the first version of KFENCE was using all the right bits to be
scheduling optimal, and thus power efficient, by simply using wait_event()
+ wake_up(), that code was unfortunately removed.

As KFENCE was exposed to various different configs and tests, the
scheduling optimal code slowly disappeared.  First because of hung task
warnings, and finally because of deadlocks when an allocation is made by
timer code with debug objects enabled.  Clearly, the "fixes" were not too
friendly for devices that want to be power efficient.

Therefore, let's try a little harder to fix the hung task and deadlock
problems that we have with wait_event() + wake_up(), while remaining as
scheduling friendly and power efficient as possible.

Crucially, we need to defer the wake_up() to an irq_work, avoiding any
potential for deadlock.

The result with this series is that on the devices where we observed a
power regression, power usage returns back to baseline levels.

This patch (of 3):

On mostly-idle systems, we have observed that toggle_allocation_gate() is
a cause of frequent wake-ups, preventing an otherwise idle CPU to go into
a lower power state.

A late change in KFENCE's development, due to a potential deadlock [1],
required changing the scheduling-friendly wait_event_timeout() and
wake_up() to an open-coded wait-loop using schedule_timeout().  [1]
https://lkml.kernel.org/r/000000000000c0645805b7f982e4@google.com

To avoid unnecessary wake-ups, switch to using wait_event_timeout().

Unfortunately, we still cannot use a version with direct wake_up() in
__kfence_alloc() due to the same potential for deadlock as in [1].
Instead, add a level of indirection via an irq_work that is scheduled if
we determine that the kfence_timer requires a wake_up().

Link: https://lkml.kernel.org/r/20210421105132.3965998-1-elver@google.com
Link: https://lkml.kernel.org/r/20210421105132.3965998-2-elver@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.kfence |  1 +
 mm/kfence/core.c   | 45 +++++++++++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/lib/Kconfig.kfence b/lib/Kconfig.kfence
index 78f50ccb3b45..e641add33947 100644
--- a/lib/Kconfig.kfence
+++ b/lib/Kconfig.kfence
@@ -7,6 +7,7 @@ menuconfig KFENCE
 	bool "KFENCE: low-overhead sampling-based memory safety error detector"
 	depends on HAVE_ARCH_KFENCE && (SLAB || SLUB)
 	select STACKTRACE
+	select IRQ_WORK
 	help
 	  KFENCE is a low-overhead sampling-based detector of heap out-of-bounds
 	  access, use-after-free, and invalid-free errors. KFENCE is designed
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index d53c91f881a4..f0be2c5038b5 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
+#include <linux/irq_work.h>
 #include <linux/kcsan-checks.h>
 #include <linux/kfence.h>
 #include <linux/kmemleak.h>
@@ -586,6 +587,17 @@ late_initcall(kfence_debugfs_init);
 
 /* === Allocation Gate Timer ================================================ */
 
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+/* Wait queue to wake up allocation-gate timer task. */
+static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
+
+static void wake_up_kfence_timer(struct irq_work *work)
+{
+	wake_up(&allocation_wait);
+}
+static DEFINE_IRQ_WORK(wake_up_kfence_timer_work, wake_up_kfence_timer);
+#endif
+
 /*
  * Set up delayed work, which will enable and disable the static key. We need to
  * use a work queue (rather than a simple timer), since enabling and disabling a
@@ -603,25 +615,13 @@ static void toggle_allocation_gate(struct work_struct *work)
 	if (!READ_ONCE(kfence_enabled))
 		return;
 
-	/* Enable static key, and await allocation to happen. */
 	atomic_set(&kfence_allocation_gate, 0);
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
-	/*
-	 * Await an allocation. Timeout after 1 second, in case the kernel stops
-	 * doing allocations, to avoid stalling this worker task for too long.
-	 */
-	{
-		unsigned long end_wait = jiffies + HZ;
-
-		do {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (atomic_read(&kfence_allocation_gate) != 0)
-				break;
-			schedule_timeout(1);
-		} while (time_before(jiffies, end_wait));
-		__set_current_state(TASK_RUNNING);
-	}
+
+	wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate), HZ);
+
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
@@ -728,6 +728,19 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	 */
 	if (atomic_read(&kfence_allocation_gate) || atomic_inc_return(&kfence_allocation_gate) > 1)
 		return NULL;
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+	/*
+	 * waitqueue_active() is fully ordered after the update of
+	 * kfence_allocation_gate per atomic_inc_return().
+	 */
+	if (waitqueue_active(&allocation_wait)) {
+		/*
+		 * Calling wake_up() here may deadlock when allocations happen
+		 * from within timer code. Use an irq_work to defer it.
+		 */
+		irq_work_queue(&wake_up_kfence_timer_work);
+	}
+#endif
 
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
-- 
2.30.2



