Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F33DD7C5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhHBNsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:10 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13271 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GdfM854Mpz81tS;
        Mon,  2 Aug 2021 21:42:28 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:17 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:17 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.4 10/11] futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()
Date:   Mon, 2 Aug 2021 21:46:23 +0800
Message-ID: <20210802134624.1934-11-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210802134624.1934-1-thunder.leizhen@huawei.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 04dc1b2fff4e96cb4142227fbdc63c8871ad4ed9 ]

Markus reported that the glibc/nptl/tst-robustpi8 test was failing after
commit:

  cfafcd117da0 ("futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()")

The following trace shows the problem:

 ld-linux-x86-64-2161  [019] ....   410.760971: SyS_futex: 00007ffbeb76b028: 80000875  op=FUTEX_LOCK_PI
 ld-linux-x86-64-2161  [019] ...1   410.760972: lock_pi_update_atomic: 00007ffbeb76b028: curval=80000875 uval=80000875 newval=80000875 ret=0
 ld-linux-x86-64-2165  [011] ....   410.760978: SyS_futex: 00007ffbeb76b028: 80000875  op=FUTEX_UNLOCK_PI
 ld-linux-x86-64-2165  [011] d..1   410.760979: do_futex: 00007ffbeb76b028: curval=80000875 uval=80000875 newval=80000871 ret=0
 ld-linux-x86-64-2165  [011] ....   410.760980: SyS_futex: 00007ffbeb76b028: 80000871 ret=0000
 ld-linux-x86-64-2161  [019] ....   410.760980: SyS_futex: 00007ffbeb76b028: 80000871 ret=ETIMEDOUT

Task 2165 does an UNLOCK_PI, assigning the lock to the waiter task 2161
which then returns with -ETIMEDOUT. That wrecks the lock state, because now
the owner isn't aware it acquired the lock and removes the pending robust
list entry.

If 2161 is killed, the robust list will not clear out this futex and the
subsequent acquire on this futex will then (correctly) result in -ESRCH
which is unexpected by glibc, triggers an internal assertion and dies.

Task 2161			Task 2165

rt_mutex_wait_proxy_lock()
   timeout();
   /* T2161 is still queued in  the waiter list */
   return -ETIMEDOUT;

				futex_unlock_pi()
				spin_lock(hb->lock);
				rtmutex_unlock()
				  remove_rtmutex_waiter(T2161);
				   mark_lock_available();
				/* Make the next waiter owner of the user space side */
				futex_uval = 2161;
				spin_unlock(hb->lock);
spin_lock(hb->lock);
rt_mutex_cleanup_proxy_lock()
  if (rtmutex_owner() !== current)
     ...
     return FAIL;
....
return -ETIMEOUT;

This means that rt_mutex_cleanup_proxy_lock() needs to call
try_to_take_rt_mutex() so it can take over the rtmutex correctly which was
assigned by the waker. If the rtmutex is owned by some other task then this
call is harmless and just confirmes that the waiter is not able to acquire
it.

While there, fix what looks like a merge error which resulted in
rt_mutex_cleanup_proxy_lock() having two calls to
fixup_rt_mutex_waiters() and rt_mutex_wait_proxy_lock() not having any.
Both should have one, since both potentially touch the waiter list.

Fixes: 38d589f2fd08 ("futex,rt_mutex: Restructure rt_mutex_finish_proxy_lock()")
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Bug-Spotted-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Link: http://lkml.kernel.org/r/20170519154850.mlomgdsd26drq5j6@hirez.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/locking/rtmutex.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 18154e10d63a23b..532986d82179b69 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1764,12 +1764,14 @@ int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 	int ret;
 
 	raw_spin_lock_irq(&lock->wait_lock);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-
 	/* sleep on the mutex */
+	set_current_state(TASK_INTERRUPTIBLE);
 	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
-
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
@@ -1800,16 +1802,26 @@ bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
 	bool cleanup = false;
 
 	raw_spin_lock_irq(&lock->wait_lock);
+	/*
+	 * Do an unconditional try-lock, this deals with the lock stealing
+	 * state where __rt_mutex_futex_unlock() -> mark_wakeup_next_waiter()
+	 * sets a NULL owner.
+	 *
+	 * We're not interested in the return value, because the subsequent
+	 * test on rt_mutex_owner() will infer that. If the trylock succeeded,
+	 * we will own the lock and it will have removed the waiter. If we
+	 * failed the trylock, we're still not owner and we need to remove
+	 * ourselves.
+	 */
+	try_to_take_rt_mutex(lock, current, waiter);
 	/*
 	 * Unless we're the owner; we're still enqueued on the wait_list.
 	 * So check if we became owner, if not, take us off the wait_list.
 	 */
 	if (rt_mutex_owner(lock) != current) {
 		remove_waiter(lock, waiter);
-		fixup_rt_mutex_waiters(lock);
 		cleanup = true;
 	}
-
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
-- 
2.26.0.106.g9fadedd

