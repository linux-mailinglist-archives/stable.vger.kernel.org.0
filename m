Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F503137E4E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgAKKI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbgAKKI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:08:27 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 468E82064C;
        Sat, 11 Jan 2020 10:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737306;
        bh=3P/hjoYRsu8bPZf0I3NrWjo6PZBfPtY27pUf3fjXgP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVIwoGZqguR+NWybtFrXEkBlZw1XjuaAQ138yAhx9tsVnHl7zkTj70UXJ6XQEldl3
         LAay01WVJLTu/lE7TPqDTZYIr54vITdx8z1TDuw2hV1jdseHYwcB9E49MRFQijqRJP
         dGX8rlIn3Dun6mjAZ1WuFYMp3nwaz6kzeMHvB23o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/62] locking/spinlock/debug: Fix various data races
Date:   Sat, 11 Jan 2020 10:49:45 +0100
Message-Id: <20200111094838.877719097@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



