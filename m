Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336C2680C14
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 12:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjA3Lgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 06:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjA3Lge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 06:36:34 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE436E80
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 03:36:30 -0800 (PST)
Date:   Mon, 30 Jan 2023 12:36:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675078588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=mqvJetLMYyl0eXQeTZ5f/g3HMLTYxSlNKdzxWd2xPMQ=;
        b=meJ+svMxNXo8k0g+CQ2wMHWpGh155mVFQklJFz75iC84038Y0xS32FPjm/n89UXW8Epe+P
        9MclqROVncJ4sTSlJmuRfwk/kIjIsQSvtWE4iAp7RjjvdkV4xBWFG55ncKPYEYY9G30Hhe
        IcPRynn6gsywxxaaY3TA/HZeHAn1K/x1ncCePPeYIBWB6UaXgv/sYHED5aP8vTeVZkOqHn
        FCIf5aG7BRbGHb2dry8p5jc82pLMB37hzsh4F8nS7lpE7/KEJ10O99QXyI+aFPg4IHxBpL
        V+hQQ1Gvu87goqG0ZqlK9T/f/+TbBNcaBzmDFBzqhlwbQmXe2P6Jp5DI2qVfdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675078588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=mqvJetLMYyl0eXQeTZ5f/g3HMLTYxSlNKdzxWd2xPMQ=;
        b=pvTM8/rkwTcJYX48k4EzaXQf3aZinsZ3YVHPeZi7K0i4SY3IXNsgrr5mqZ1S3Yw2JZoFxz
        eNbxD8iEM0BjRVCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     stable@vger.kernel.org
Cc:     Mel Gorman <mgorman@techsingularity.net>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] rtmutex: Add acquire semantics for rtmutex lock acquisition
 slow path
Message-ID: <Y9ert97Qzt5Qv+4Z@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 1c0908d8e441631f5b8ba433523cf39339ee2ba0 upstream.

Jan Kara reported the following bug triggering on 6.0.5-rt14 running dbench
on XFS on arm64.

 kernel BUG at fs/inode.c:625!
 Internal error: Oops - BUG: 0 [#1] PREEMPT_RT SMP
 CPU: 11 PID: 6611 Comm: dbench Tainted: G            E   6.0.0-rt14-rt+ #1
 pc : clear_inode+0xa0/0xc0
 lr : clear_inode+0x38/0xc0
 Call trace:
  clear_inode+0xa0/0xc0
  evict+0x160/0x180
  iput+0x154/0x240
  do_unlinkat+0x184/0x300
  __arm64_sys_unlinkat+0x48/0xc0
  el0_svc_common.constprop.4+0xe4/0x2c0
  do_el0_svc+0xac/0x100
  el0_svc+0x78/0x200
  el0t_64_sync_handler+0x9c/0xc0
  el0t_64_sync+0x19c/0x1a0

It also affects 6.1-rc7-rt5 and affects a preempt-rt fork of 5.14 so this
is likely a bug that existed forever and only became visible when ARM
support was added to preempt-rt. The same problem does not occur on x86-64
and he also reported that converting sb->s_inode_wblist_lock to
raw_spinlock_t makes the problem disappear indicating that the RT spinlock
variant is the problem.

Which in turn means that RT mutexes on ARM64 and any other weakly ordered
architecture are affected by this independent of RT.

Will Deacon observed:

  "I'd be more inclined to be suspicious of the slowpath tbh, as we need to
   make sure that we have acquire semantics on all paths where the lock can
   be taken. Looking at the rtmutex code, this really isn't obvious to me
   -- for example, try_to_take_rt_mutex() appears to be able to return via
   the 'takeit' label without acquire semantics and it looks like we might
   be relying on the caller's subsequent _unlock_ of the wait_lock for
   ordering, but that will give us release semantics which aren't correct."

Sebastian Andrzej Siewior prototyped a fix that does work based on that
comment but it was a little bit overkill and added some fences that should
not be necessary.

The lock owner is updated with an IRQ-safe raw spinlock held, but the
spin_unlock does not provide acquire semantics which are needed when
acquiring a mutex.

Adds the necessary acquire semantics for lock owner updates in the slow path
acquisition and the waiter bit logic.

It successfully completed 10 iterations of the dbench workload while the
vanilla kernel fails on the first iteration.

[ bigeasy@linutronix.de: Initial prototype fix ]

Fixes: 700318d1d7b38 ("locking/rtmutex: Use acquire/release semantics")
Fixes: 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221202100223.6mevpbl7i6x5udfd@techsingularity.net
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Could this be please backported to 5.15 and earlier? It is already part
of the 6.X kernels. Either I am not waiting long enough or this has been
skipped because it does not apply cleanly. In case of the latter, here
is a patch that applies against v5.15.

I received reports that this fixes "mysterious" crashes and that is how
I noticed that it is not part of the earlier kernels.

 kernel/locking/rtmutex.c     | 55 ++++++++++++++++++++++++++++++------
 kernel/locking/rtmutex_api.c |  6 ++--
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index ea5a701ab2408..c9b21fd30bed5 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -87,15 +87,31 @@ static inline int __ww_mutex_check_kill(struct rt_mutex *lock,
  * set this bit before looking at the lock.
  */
 
-static __always_inline void
-rt_mutex_set_owner(struct rt_mutex_base *lock, struct task_struct *owner)
+static __always_inline struct task_struct *
+rt_mutex_owner_encode(struct rt_mutex_base *lock, struct task_struct *owner)
 {
 	unsigned long val = (unsigned long)owner;
 
 	if (rt_mutex_has_waiters(lock))
 		val |= RT_MUTEX_HAS_WAITERS;
 
-	WRITE_ONCE(lock->owner, (struct task_struct *)val);
+	return (struct task_struct *)val;
+}
+
+static __always_inline void
+rt_mutex_set_owner(struct rt_mutex_base *lock, struct task_struct *owner)
+{
+	/*
+	 * lock->wait_lock is held but explicit acquire semantics are needed
+	 * for a new lock owner so WRITE_ONCE is insufficient.
+	 */
+	xchg_acquire(&lock->owner, rt_mutex_owner_encode(lock, owner));
+}
+
+static __always_inline void rt_mutex_clear_owner(struct rt_mutex_base *lock)
+{
+	/* lock->wait_lock is held so the unlock provides release semantics. */
+	WRITE_ONCE(lock->owner, rt_mutex_owner_encode(lock, NULL));
 }
 
 static __always_inline void clear_rt_mutex_waiters(struct rt_mutex_base *lock)
@@ -104,7 +120,8 @@ static __always_inline void clear_rt_mutex_waiters(struct rt_mutex_base *lock)
 			((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
 }
 
-static __always_inline void fixup_rt_mutex_waiters(struct rt_mutex_base *lock)
+static __always_inline void
+fixup_rt_mutex_waiters(struct rt_mutex_base *lock, bool acquire_lock)
 {
 	unsigned long owner, *p = (unsigned long *) &lock->owner;
 
@@ -170,8 +187,21 @@ static __always_inline void fixup_rt_mutex_waiters(struct rt_mutex_base *lock)
 	 * still set.
 	 */
 	owner = READ_ONCE(*p);
-	if (owner & RT_MUTEX_HAS_WAITERS)
-		WRITE_ONCE(*p, owner & ~RT_MUTEX_HAS_WAITERS);
+	if (owner & RT_MUTEX_HAS_WAITERS) {
+		/*
+		 * See rt_mutex_set_owner() and rt_mutex_clear_owner() on
+		 * why xchg_acquire() is used for updating owner for
+		 * locking and WRITE_ONCE() for unlocking.
+		 *
+		 * WRITE_ONCE() would work for the acquire case too, but
+		 * in case that the lock acquisition failed it might
+		 * force other lockers into the slow path unnecessarily.
+		 */
+		if (acquire_lock)
+			xchg_acquire(p, owner & ~RT_MUTEX_HAS_WAITERS);
+		else
+			WRITE_ONCE(*p, owner & ~RT_MUTEX_HAS_WAITERS);
+	}
 }
 
 /*
@@ -206,6 +236,13 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
 		owner = *p;
 	} while (cmpxchg_relaxed(p, owner,
 				 owner | RT_MUTEX_HAS_WAITERS) != owner);
+
+	/*
+	 * The cmpxchg loop above is relaxed to avoid back-to-back ACQUIRE
+	 * operations in the event of contention. Ensure the successful
+	 * cmpxchg is visible.
+	 */
+	smp_mb__after_atomic();
 }
 
 /*
@@ -1231,7 +1268,7 @@ static int __sched __rt_mutex_slowtrylock(struct rt_mutex_base *lock)
 	 * try_to_take_rt_mutex() sets the lock waiters bit
 	 * unconditionally. Clean this up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 
 	return ret;
 }
@@ -1591,7 +1628,7 @@ static int __sched __rt_mutex_slowlock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit
 	 * unconditionally. We might have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	return ret;
 }
 
@@ -1701,7 +1738,7 @@ static void __sched rtlock_slowlock_locked(struct rt_mutex_base *lock)
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally.
 	 * We might have to fix that up:
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	debug_rt_mutex_free_waiter(&waiter);
 }
 
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index 5c9299aaabae1..a461be2f873db 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -245,7 +245,7 @@ void __sched rt_mutex_init_proxy_locked(struct rt_mutex_base *lock,
 void __sched rt_mutex_proxy_unlock(struct rt_mutex_base *lock)
 {
 	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL);
+	rt_mutex_clear_owner(lock);
 }
 
 /**
@@ -360,7 +360,7 @@ int __sched rt_mutex_wait_proxy_lock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
@@ -416,7 +416,7 @@ bool __sched rt_mutex_cleanup_proxy_lock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, false);
 
 	raw_spin_unlock_irq(&lock->wait_lock);
 
-- 
2.39.1

