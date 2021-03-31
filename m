Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81134C5E9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhC2IDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232005AbhC2IDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55C8F619AF;
        Mon, 29 Mar 2021 08:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004995;
        bh=XgkTabc5zj4w+Fipru7eR1xR3dNMvN5h6RAHuieR1yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ct9WzXMoiYy12n8C7jqaKcaYSBQy6olDKKPCeDZ+P3iXrbHX767yijoT5dM0O6BYN
         +N49YWeqLx7rBtcQG9bqTtHtetaLpMPX1Da4TM/ULsFWil38gBIXFQJ5ut9VvFF4In
         CiuYX36MfA+Q5QYBO8RDN7P1xxT2FB9dZHzsm2PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Florian Weimer <fweimer@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 42/53] futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()
Date:   Mon, 29 Mar 2021 09:58:17 +0200
Message-Id: <20210329075608.896530472@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 04dc1b2fff4e96cb4142227fbdc63c8871ad4ed9 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1796,12 +1796,14 @@ int rt_mutex_wait_proxy_lock(struct rt_m
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
@@ -1833,15 +1835,25 @@ bool rt_mutex_cleanup_proxy_lock(struct
 
 	raw_spin_lock_irq(&lock->wait_lock);
 	/*
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
+	/*
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


