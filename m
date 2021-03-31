Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69C534BEF0
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhC1Umj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:42:39 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37150 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhC1UmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:42:22 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEn-0001xI-Cx; Sun, 28 Mar 2021 22:42:21 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEm-003GfT-IU; Sun, 28 Mar 2021 22:42:20 +0200
Date:   Sun, 28 Mar 2021 22:42:20 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 07/13] futex: Handle early deadlock return correctly
Message-ID: <YGDqLAxAfaH+BDVy@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EtkxaMZEvWVK6J+R"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EtkxaMZEvWVK6J+R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Thomas Gleixner <tglx@linutronix.de>

commit 1a1fb985f2e2b85ec0d3dc2e519ee48389ec2434 upstream.

commit 56222b212e8e ("futex: Drop hb->lock before enqueueing on the
rtmutex") changed the locking rules in the futex code so that the hash
bucket lock is not longer held while the waiter is enqueued into the
rtmutex wait list. This made the lock and the unlock path symmetric, but
unfortunately the possible early exit from __rt_mutex_proxy_start() due to
a detected deadlock was not updated accordingly. That allows a concurrent
unlocker to observe inconsitent state which triggers the warning in the
unlock path.

futex_lock_pi()                         futex_unlock_pi()
  lock(hb->lock)
  queue(hb_waiter)				lock(hb->lock)
  lock(rtmutex->wait_lock)
  unlock(hb->lock)
                                        // acquired hb->lock
                                        hb_waiter =3D futex_top_waiter()
                                        lock(rtmutex->wait_lock)
  __rt_mutex_proxy_start()
     ---> fail
          remove(rtmutex_waiter);
     ---> returns -EDEADLOCK
  unlock(rtmutex->wait_lock)
                                        // acquired wait_lock
                                        wake_futex_pi()
                                        rt_mutex_next_owner()
					  --> returns NULL
                                          --> WARN

  lock(hb->lock)
  unqueue(hb_waiter)

The problem is caused by the remove(rtmutex_waiter) in the failure case of
__rt_mutex_proxy_start() as this lets the unlocker observe a waiter in the
hash bucket but no waiter on the rtmutex, i.e. inconsistent state.

The original commit handles this correctly for the other early return cases
(timeout, signal) by delaying the removal of the rtmutex waiter until the
returning task reacquired the hash bucket lock.

Treat the failure case of __rt_mutex_proxy_start() in the same way and let
the existing cleanup code handle the eventual handover of the rtmutex
gracefully. The regular rt_mutex_proxy_start() gains the rtmutex waiter
removal for the failure case, so that the other callsites are still
operating correctly.

Add proper comments to the code so all these details are fully documented.

Thanks to Peter for helping with the analysis and writing the really
valuable code comments.

Fixes: 56222b212e8e ("futex: Drop hb->lock before enqueueing on the rtmutex=
")
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Stefan Liebler <stli@linux.ibm.com>
Cc: Sebastian Sewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1901292311410.1950@nanos.te=
c.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c           | 28 ++++++++++++++++++----------
 kernel/locking/rtmutex.c | 37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bd896f883ffd..60be2d3cfdd7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2958,35 +2958,39 @@ static int futex_lock_pi(u32 __user *uaddr, unsigne=
d int flags,
 	 * and BUG when futex_unlock_pi() interleaves with this.
 	 *
 	 * Therefore acquire wait_lock while holding hb->lock, but drop the
-	 * latter before calling rt_mutex_start_proxy_lock(). This still fully
-	 * serializes against futex_unlock_pi() as that does the exact same
-	 * lock handoff sequence.
+	 * latter before calling __rt_mutex_start_proxy_lock(). This
+	 * interleaves with futex_unlock_pi() -- which does a similar lock
+	 * handoff -- such that the latter can observe the futex_q::pi_state
+	 * before __rt_mutex_start_proxy_lock() is done.
 	 */
 	raw_spin_lock_irq(&q.pi_state->pi_mutex.wait_lock);
 	spin_unlock(q.lock_ptr);
+	/*
+	 * __rt_mutex_start_proxy_lock() unconditionally enqueues the @rt_waiter
+	 * such that futex_unlock_pi() is guaranteed to observe the waiter when
+	 * it sees the futex_q::pi_state.
+	 */
 	ret =3D __rt_mutex_start_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter, cu=
rrent);
 	raw_spin_unlock_irq(&q.pi_state->pi_mutex.wait_lock);
=20
 	if (ret) {
 		if (ret =3D=3D 1)
 			ret =3D 0;
-
-		spin_lock(q.lock_ptr);
-		goto no_block;
+		goto cleanup;
 	}
=20
-
 	if (unlikely(to))
 		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
=20
 	ret =3D rt_mutex_wait_proxy_lock(&q.pi_state->pi_mutex, to, &rt_waiter);
=20
+cleanup:
 	spin_lock(q.lock_ptr);
 	/*
-	 * If we failed to acquire the lock (signal/timeout), we must
+	 * If we failed to acquire the lock (deadlock/signal/timeout), we must
 	 * first acquire the hb->lock before removing the lock from the
-	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex
-	 * wait lists consistent.
+	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex wait
+	 * lists consistent.
 	 *
 	 * In particular; it is important that futex_unlock_pi() can not
 	 * observe this inconsistency.
@@ -3093,6 +3097,10 @@ static int futex_unlock_pi(u32 __user *uaddr, unsign=
ed int flags)
 		 * there is no point where we hold neither; and therefore
 		 * wake_futex_pi() must observe a state consistent with what we
 		 * observed.
+		 *
+		 * In particular; this forces __rt_mutex_start_proxy() to
+		 * complete such that we're guaranteed to observe the
+		 * rt_waiter. Also see the WARN in wake_futex_pi().
 		 */
 		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index eb933efdd224..1589e131ee4b 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1695,12 +1695,33 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock)
 	rt_mutex_set_owner(lock, NULL);
 }
=20
+/**
+ * __rt_mutex_start_proxy_lock() - Start lock acquisition for another task
+ * @lock:		the rt_mutex to take
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @task:		the task to prepare
+ *
+ * Starts the rt_mutex acquire; it enqueues the @waiter and does deadlock
+ * detection. It does not wait, see rt_mutex_wait_proxy_lock() for that.
+ *
+ * NOTE: does _NOT_ remove the @waiter on failure; must either call
+ * rt_mutex_wait_proxy_lock() or rt_mutex_cleanup_proxy_lock() after this.
+ *
+ * Returns:
+ *  0 - task blocked on lock
+ *  1 - acquired the lock for task, caller should wake it up
+ * <0 - error
+ *
+ * Special API call for PI-futex support.
+ */
 int __rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
 			      struct task_struct *task)
 {
 	int ret;
=20
+	lockdep_assert_held(&lock->wait_lock);
+
 	if (try_to_take_rt_mutex(lock, task, NULL))
 		return 1;
=20
@@ -1718,9 +1739,6 @@ int __rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		ret =3D 0;
 	}
=20
-	if (unlikely(ret))
-		remove_waiter(lock, waiter);
-
 	debug_rt_mutex_print_deadlock(waiter);
=20
 	return ret;
@@ -1732,12 +1750,18 @@ int __rt_mutex_start_proxy_lock(struct rt_mutex *lo=
ck,
  * @waiter:		the pre-initialized rt_mutex_waiter
  * @task:		the task to prepare
  *
+ * Starts the rt_mutex acquire; it enqueues the @waiter and does deadlock
+ * detection. It does not wait, see rt_mutex_wait_proxy_lock() for that.
+ *
+ * NOTE: unlike __rt_mutex_start_proxy_lock this _DOES_ remove the @waiter
+ * on failure.
+ *
  * Returns:
  *  0 - task blocked on lock
  *  1 - acquired the lock for task, caller should wake it up
  * <0 - error
  *
- * Special API call for FUTEX_REQUEUE_PI support.
+ * Special API call for PI-futex support.
  */
 int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
@@ -1747,6 +1771,8 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
=20
 	raw_spin_lock_irq(&lock->wait_lock);
 	ret =3D __rt_mutex_start_proxy_lock(lock, waiter, task);
+	if (unlikely(ret))
+		remove_waiter(lock, waiter);
 	raw_spin_unlock_irq(&lock->wait_lock);
=20
 	return ret;
@@ -1814,7 +1840,8 @@ int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
  * @lock:		the rt_mutex we were woken on
  * @waiter:		the pre-initialized rt_mutex_waiter
  *
- * Attempt to clean up after a failed rt_mutex_wait_proxy_lock().
+ * Attempt to clean up after a failed __rt_mutex_start_proxy_lock() or
+ * rt_mutex_wait_proxy_lock().
  *
  * Unless we acquired the lock; we're still enqueued on the wait-list and =
can
  * in fact still be granted ownership until we're removed. Therefore we can


--EtkxaMZEvWVK6J+R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6iwACgkQ57/I7JWG
EQnYKQ//brXW9zdKKcXZ8Nv1PbwdVLH7SRjJ9NQ5SxaVV/Fqpcuk4EF4P3AFKZS0
aX2/6EM3/QfVkavwRcVCSLqH6rgFQj6QW2TmHs3LnW/g5dwuA/Qntct9wIkc2141
o9mHf8qIFMH/2H8Oiykx0HTS4pAgSYGC6O8Kqt7iBACIpWFCWHRpojZSB8Kih1pD
AQOfjLeJNr+JW8IMVK9nQ/blIelIr8cir4F+oiLJawbCaMH3k2AW2OxUt1EU1K97
Orw1Vtd6X+GYGKGcxWg9p46GwsOR2YKj+43u3BKcsmEN6NyD4Q0whBkrQnKUP0VL
YKDweFTqkPpogjaUoFsgRPiY8JhDk6jdjxTQ9A8uEG3pYnBLvcUsg7IATsZenOiV
+czKKK6JGAQ05dduE7eoPHt9R8CBrMmwUROUL1er784FwK5XNVuEIhZiTrO6KG+5
sNRv06/ueMt5gdDe7AxeqWErvdbWgU8KxKXgobKK5TdRLtO4NZRS6Cu7aHaSRnao
CuV++oOI8nFuDm7921wyacYSCx4N+t7zU5aRzAp2+QI9G/mfe07t9FHRsLB/L+Dr
GxdVpnpvzGDjv4hYZQ/NCA1VqyJ7dH/7YEOjuipf7byNA037QNghvOTfnvjfOp8b
xSX30pbMMOqiFMBoOIojWZY6r8mKLnr0C2sgZ5ZxykXePFm6TLA=
=F9BR
-----END PGP SIGNATURE-----

--EtkxaMZEvWVK6J+R--
