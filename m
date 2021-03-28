Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5734BEEF
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhC1UmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:42:06 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37118 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhC1Ulp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:41:45 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEC-0001wa-8D; Sun, 28 Mar 2021 22:41:44 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEA-003Gcg-C6; Sun, 28 Mar 2021 22:41:42 +0200
Date:   Sun, 28 Mar 2021 22:41:42 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 03/13] futex: Rework futex_lock_pi() to use
 rt_mutex_*_proxy_lock()
Message-ID: <YGDqBnDrUInZoDsM@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EGOjm+DO/eMbJnde"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EGOjm+DO/eMbJnde
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit cfafcd117da0216520568c195cb2f6cd1980c4bb upstream.

By changing futex_lock_pi() to use rt_mutex_*_proxy_lock() all wait_list
modifications are done under both hb->lock and wait_lock.

This closes the obvious interleave pattern between futex_lock_pi() and
futex_unlock_pi(), but not entirely so. See below:

Before:

futex_lock_pi()			futex_unlock_pi()
  unlock hb->lock

				  lock hb->lock
				  unlock hb->lock

				  lock rt_mutex->wait_lock
				  unlock rt_mutex_wait_lock
				    -EAGAIN

  lock rt_mutex->wait_lock
  list_add
  unlock rt_mutex->wait_lock

  schedule()

  lock rt_mutex->wait_lock
  list_del
  unlock rt_mutex->wait_lock

				  <idem>
				    -EAGAIN

  lock hb->lock

After:

futex_lock_pi()			futex_unlock_pi()

  lock hb->lock
  lock rt_mutex->wait_lock
  list_add
  unlock rt_mutex->wait_lock
  unlock hb->lock

  schedule()
				  lock hb->lock
				  unlock hb->lock
  lock hb->lock
  lock rt_mutex->wait_lock
  list_del
  unlock rt_mutex->wait_lock

				  lock rt_mutex->wait_lock
				  unlock rt_mutex_wait_lock
				    -EAGAIN

  unlock hb->lock

It does however solve the earlier starvation/live-lock scenario which got
introduced with the -EAGAIN since unlike the before scenario; where the
-EAGAIN happens while futex_unlock_pi() doesn't hold any locks; in the
after scenario it happens while futex_unlock_pi() actually holds a lock,
and then it is serialized on that lock.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104152.062785528@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c                  | 77 +++++++++++++++++++++++----------
 kernel/locking/rtmutex.c        | 26 +++--------
 kernel/locking/rtmutex_common.h |  1 -
 3 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index cd8a9abadd69..0e72e51ac3a8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2333,20 +2333,7 @@ queue_unlock(struct futex_hash_bucket *hb)
 	hb_waiters_dec(hb);
 }
=20
-/**
- * queue_me() - Enqueue the futex_q on the futex_hash_bucket
- * @q:	The futex_q to enqueue
- * @hb:	The destination hash bucket
- *
- * The hb->lock must be held by the caller, and is released here. A call to
- * queue_me() is typically paired with exactly one call to unqueue_me().  =
The
- * exceptions involve the PI related operations, which may use unqueue_me_=
pi()
- * or nothing if the unqueue is done as part of the wake process and the u=
nqueue
- * state is implicit in the state of woken task (see futex_wait_requeue_pi=
() for
- * an example).
- */
-static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *h=
b)
-	__releases(&hb->lock)
+static inline void __queue_me(struct futex_q *q, struct futex_hash_bucket =
*hb)
 {
 	int prio;
=20
@@ -2363,6 +2350,24 @@ static inline void queue_me(struct futex_q *q, struc=
t futex_hash_bucket *hb)
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
 	q->task =3D current;
+}
+
+/**
+ * queue_me() - Enqueue the futex_q on the futex_hash_bucket
+ * @q:	The futex_q to enqueue
+ * @hb:	The destination hash bucket
+ *
+ * The hb->lock must be held by the caller, and is released here. A call to
+ * queue_me() is typically paired with exactly one call to unqueue_me().  =
The
+ * exceptions involve the PI related operations, which may use unqueue_me_=
pi()
+ * or nothing if the unqueue is done as part of the wake process and the u=
nqueue
+ * state is implicit in the state of woken task (see futex_wait_requeue_pi=
() for
+ * an example).
+ */
+static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *h=
b)
+	__releases(&hb->lock)
+{
+	__queue_me(q, hb);
 	spin_unlock(&hb->lock);
 }
=20
@@ -2868,6 +2873,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned =
int flags,
 {
 	struct hrtimer_sleeper timeout, *to =3D NULL;
 	struct task_struct *exiting =3D NULL;
+	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
 	struct futex_q q =3D futex_q_init;
 	int res, ret;
@@ -2928,24 +2934,51 @@ static int futex_lock_pi(u32 __user *uaddr, unsigne=
d int flags,
 		}
 	}
=20
+	WARN_ON(!q.pi_state);
+
 	/*
 	 * Only actually queue now that the atomic ops are done:
 	 */
-	queue_me(&q, hb);
+	__queue_me(&q, hb);
=20
-	WARN_ON(!q.pi_state);
-	/*
-	 * Block on the PI mutex:
-	 */
-	if (!trylock) {
-		ret =3D rt_mutex_timed_futex_lock(&q.pi_state->pi_mutex, to);
-	} else {
+	if (trylock) {
 		ret =3D rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret =3D ret ? 0 : -EWOULDBLOCK;
+		goto no_block;
+	}
+
+	/*
+	 * We must add ourselves to the rt_mutex waitlist while holding hb->lock
+	 * such that the hb and rt_mutex wait lists match.
+	 */
+	rt_mutex_init_waiter(&rt_waiter);
+	ret =3D rt_mutex_start_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter, curr=
ent);
+	if (ret) {
+		if (ret =3D=3D 1)
+			ret =3D 0;
+
+		goto no_block;
 	}
=20
+	spin_unlock(q.lock_ptr);
+
+	if (unlikely(to))
+		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
+
+	ret =3D rt_mutex_wait_proxy_lock(&q.pi_state->pi_mutex, to, &rt_waiter);
+
 	spin_lock(q.lock_ptr);
+	/*
+	 * If we failed to acquire the lock (signal/timeout), we must
+	 * first acquire the hb->lock before removing the lock from the
+	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex
+	 * wait lists consistent.
+	 */
+	if (ret && !rt_mutex_cleanup_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter=
))
+		ret =3D 0;
+
+no_block:
 	/*
 	 * Fixup the pi_state owner and possibly acquire the lock if we
 	 * haven't already.
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 873c8c800e00..d8585ff1ffab 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1522,19 +1522,6 @@ int __sched rt_mutex_lock_interruptible(struct rt_mu=
tex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
=20
-/*
- * Futex variant with full deadlock detection.
- * Futex variants must not use the fast-path, see __rt_mutex_futex_unlock(=
).
- */
-int __sched rt_mutex_timed_futex_lock(struct rt_mutex *lock,
-			      struct hrtimer_sleeper *timeout)
-{
-	might_sleep();
-
-	return rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE,
-				 timeout, RT_MUTEX_FULL_CHAINWALK);
-}
-
 /*
  * Futex variant, must not use fastpath.
  */
@@ -1808,12 +1795,6 @@ int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 	/* sleep on the mutex */
 	ret =3D __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
=20
-	/*
-	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
-	 * have to fix that up.
-	 */
-	fixup_rt_mutex_waiters(lock);
-
 	raw_spin_unlock_irq(&lock->wait_lock);
=20
 	return ret;
@@ -1853,6 +1834,13 @@ bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lo=
ck,
 		fixup_rt_mutex_waiters(lock);
 		cleanup =3D true;
 	}
+
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
 	raw_spin_unlock_irq(&lock->wait_lock);
=20
 	return cleanup;
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_commo=
n.h
index ba465c0192f3..637e6fe51782 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -112,7 +112,6 @@ extern int rt_mutex_wait_proxy_lock(struct rt_mutex *lo=
ck,
 			       struct rt_mutex_waiter *waiter);
 extern bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *lock,
 				 struct rt_mutex_waiter *waiter);
-extern int rt_mutex_timed_futex_lock(struct rt_mutex *l, struct hrtimer_sl=
eeper *to);
 extern int rt_mutex_futex_trylock(struct rt_mutex *l);
 extern int __rt_mutex_futex_trylock(struct rt_mutex *l);
=20


--EGOjm+DO/eMbJnde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6gYACgkQ57/I7JWG
EQk4iRAAjIrA8YoExyQgHP3dUPko51dBZs10BlH4Yz5y+nLTjB48Q+VVDBn8kZY8
jviHoS681urCA53Qxh+qx4yOS/Rw5IuVqcn0qn/1cohveDEd03GaCrLF8WUZlvQ9
7P4rkM2YbgSTqoIX5oOh9b5jHews0hXZgVV+3wqIBsJSPiYSjfw2QnedOeq+ciE5
TwCZLzVo8LnZWSi+R3bDscayRLWUhAF9bGv+aEP1fR0aOCuUw1EeOdiftFyc1glF
QTOZ5F9MNEDhfuxIBeXn8dMy+jtyNB1J4Lf8tqzel7brZZmxF6grZKPRVL5XVGSY
c/CdzAnAYS4+om1kWnM8sq6FNc2Mg2HtFaYwICu46axgdvCFRsHSbF7OqQQ5vYyk
qdTs7A0/B1yy+NUbRwi7EMd6kS/GKRd75vuKxsVCj/3msOirGxy2oXiiKiDu78ha
ls6gg+60FNb0K3r/6LRM/wgwsNGwUPGbfsOG+s2DespHDMMVR7eFql1Qf4Ssoe34
yWybMCorbiE/dCCgiqmO26jehcng9b7nNCkF4tmZjtwlZjAFwl7m4lgZBpetMhUS
BA5s3Hngf/RdsRz+JnN9Zn51DnNod3OWRuAq+xOcC+d08ItCFzkHq8NBZtsVlMvD
m+2KJsR6+C+0YKFiKAKAiRmoMR3Gs9wocuzSZeU77Hy8X81kAVM=
=eQdq
-----END PGP SIGNATURE-----

--EGOjm+DO/eMbJnde--
