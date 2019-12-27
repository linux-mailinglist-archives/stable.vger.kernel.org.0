Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC51E12BA94
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfL0SOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbfL0SOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:14:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11AD20CC7;
        Fri, 27 Dec 2019 18:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470479;
        bh=3P/hjoYRsu8bPZf0I3NrWjo6PZBfPtY27pUf3fjXgP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMgjU6tjQ6hH8tbjqlDeHq5gUd1mwgxwHWp3otq+hQVTjBiQ5iTOd9nmS6dzqOUIS
         mO1sUsJhB9U3orSv1TFKYKCvcWVgDWkFcIypq18xOaR9oDRAY23ULaXQqqoSvzMv+l
         TBdG0WShTdnlt6cuwaGVPk1h0ql0R1n6RvVb0rL0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/38] locking/spinlock/debug: Fix various data races
Date:   Fri, 27 Dec 2019 13:13:59 -0500
Message-Id: <20191227181435.7644-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 1a365e822372ba24c9da0822bc583894f6f3d821 ]

This fixes various data races in spinlock_debug. By testing with KCSAN,
it is observable that the console gets spammed with data races reports,
suggesting these are extremely frequent.

Example data race report:

  read to 0xffff8ab24f403c48 of 4 bytes by task 221 on cpu 2:
   debug_spin_lock_before kernel/locking/spinlock_debug.c:85 [inline]
   do_raw_spin_lock+0x9b/0x210 kernel/locking/spinlock_debug.c:112
   __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
   _raw_spin_lock+0x39/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:338 [inline]
   get_partial_node.isra.0.part.0+0x32/0x2f0 mm/slub.c:1873
   get_partial_node mm/slub.c:1870 [inline]
  <snip>

  write to 0xffff8ab24f403c48 of 4 bytes by task 167 on cpu 3:
   debug_spin_unlock kernel/locking/spinlock_debug.c:103 [inline]
   do_raw_spin_unlock+0xc9/0x1a0 kernel/locking/spinlock_debug.c:138
   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:159 [inline]
   _raw_spin_unlock_irqrestore+0x2d/0x50 kernel/locking/spinlock.c:191
   spin_unlock_irqrestore include/linux/spinlock.h:393 [inline]
   free_debug_processing+0x1b3/0x210 mm/slub.c:1214
   __slab_free+0x292/0x400 mm/slub.c:2864
  <snip>

As a side-effect, with KCSAN, this eventually locks up the console, most
likely due to deadlock, e.g. .. -> printk lock -> spinlock_debug ->
KCSAN detects data race -> kcsan_print_report() -> printk lock ->
deadlock.

This fix will 1) avoid the data races, and 2) allow using lock debugging
together with KCSAN.

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Link: https://lkml.kernel.org/r/20191120155715.28089-1-elver@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/spinlock_debug.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 9aa0fccd5d43..03595c29c566 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -51,19 +51,19 @@ EXPORT_SYMBOL(__rwlock_init);
 
 static void spin_dump(raw_spinlock_t *lock, const char *msg)
 {
-	struct task_struct *owner = NULL;
+	struct task_struct *owner = READ_ONCE(lock->owner);
 
-	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
-		owner = lock->owner;
+	if (owner == SPINLOCK_OWNER_INIT)
+		owner = NULL;
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
 	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
-		lock, lock->magic,
+		lock, READ_ONCE(lock->magic),
 		owner ? owner->comm : "<none>",
 		owner ? task_pid_nr(owner) : -1,
-		lock->owner_cpu);
+		READ_ONCE(lock->owner_cpu));
 	dump_stack();
 }
 
@@ -80,16 +80,16 @@ static void spin_bug(raw_spinlock_t *lock, const char *msg)
 static inline void
 debug_spin_lock_before(raw_spinlock_t *lock)
 {
-	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
-	SPIN_BUG_ON(lock->owner == current, lock, "recursion");
-	SPIN_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
+	SPIN_BUG_ON(READ_ONCE(lock->magic) != SPINLOCK_MAGIC, lock, "bad magic");
+	SPIN_BUG_ON(READ_ONCE(lock->owner) == current, lock, "recursion");
+	SPIN_BUG_ON(READ_ONCE(lock->owner_cpu) == raw_smp_processor_id(),
 							lock, "cpu recursion");
 }
 
 static inline void debug_spin_lock_after(raw_spinlock_t *lock)
 {
-	lock->owner_cpu = raw_smp_processor_id();
-	lock->owner = current;
+	WRITE_ONCE(lock->owner_cpu, raw_smp_processor_id());
+	WRITE_ONCE(lock->owner, current);
 }
 
 static inline void debug_spin_unlock(raw_spinlock_t *lock)
@@ -99,8 +99,8 @@ static inline void debug_spin_unlock(raw_spinlock_t *lock)
 	SPIN_BUG_ON(lock->owner != current, lock, "wrong owner");
 	SPIN_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
 							lock, "wrong CPU");
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
+	WRITE_ONCE(lock->owner, SPINLOCK_OWNER_INIT);
+	WRITE_ONCE(lock->owner_cpu, -1);
 }
 
 /*
@@ -183,8 +183,8 @@ static inline void debug_write_lock_before(rwlock_t *lock)
 
 static inline void debug_write_lock_after(rwlock_t *lock)
 {
-	lock->owner_cpu = raw_smp_processor_id();
-	lock->owner = current;
+	WRITE_ONCE(lock->owner_cpu, raw_smp_processor_id());
+	WRITE_ONCE(lock->owner, current);
 }
 
 static inline void debug_write_unlock(rwlock_t *lock)
@@ -193,8 +193,8 @@ static inline void debug_write_unlock(rwlock_t *lock)
 	RWLOCK_BUG_ON(lock->owner != current, lock, "wrong owner");
 	RWLOCK_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
 							lock, "wrong CPU");
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
+	WRITE_ONCE(lock->owner, SPINLOCK_OWNER_INIT);
+	WRITE_ONCE(lock->owner_cpu, -1);
 }
 
 void do_raw_write_lock(rwlock_t *lock)
-- 
2.20.1

