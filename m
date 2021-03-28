Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4534BEEE
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhC1UmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:42:07 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37126 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhC1Ulx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:41:53 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEJ-0001wl-Sb; Sun, 28 Mar 2021 22:41:51 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEJ-003GdV-2D; Sun, 28 Mar 2021 22:41:51 +0200
Date:   Sun, 28 Mar 2021 22:41:51 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 04/13] futex: Drop hb->lock before enqueueing on the rtmutex
Message-ID: <YGDqD/h/x3P8HwyB@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j6agz95TelSDp1k9"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--j6agz95TelSDp1k9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 56222b212e8edb1cf51f5dd73ff645809b082b40 upstream.

When PREEMPT_RT_FULL does the spinlock -> rt_mutex substitution the PI
chain code will (falsely) report a deadlock and BUG.

The problem is that it hold hb->lock (now an rt_mutex) while doing
task_blocks_on_rt_mutex on the futex's pi_state::rtmutex. This, when
interleaved just right with futex_unlock_pi() leads it to believe to see an
AB-BA deadlock.

  Task1 (holds rt_mutex,	Task2 (does FUTEX_LOCK_PI)
         does FUTEX_UNLOCK_PI)

				lock hb->lock
				lock rt_mutex (as per start_proxy)
  lock hb->lock

Which is a trivial AB-BA.

It is not an actual deadlock, because it won't be holding hb->lock by the
time it actually blocks on the rt_mutex, but the chainwalk code doesn't
know that and it would be a nightmare to handle this gracefully.

To avoid this problem, do the same as in futex_unlock_pi() and drop
hb->lock after acquiring wait_lock. This still fully serializes against
futex_unlock_pi(), since adding to the wait_list does the very same lock
dance, and removing it holds both locks.

Aside of solving the RT problem this makes the lock and unlock mechanism
symetric and reduces the hb->lock held time.

Reported-and-tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104152.161341537@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c                  | 30 ++++++++++++++------
 kernel/locking/rtmutex.c        | 49 +++++++++++++++++++--------------
 kernel/locking/rtmutex_common.h |  3 ++
 3 files changed, 52 insertions(+), 30 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0e72e51ac3a8..491888a89144 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2948,20 +2948,33 @@ static int futex_lock_pi(u32 __user *uaddr, unsigne=
d int flags,
 		goto no_block;
 	}
=20
+	rt_mutex_init_waiter(&rt_waiter);
+
 	/*
-	 * We must add ourselves to the rt_mutex waitlist while holding hb->lock
-	 * such that the hb and rt_mutex wait lists match.
+	 * On PREEMPT_RT_FULL, when hb->lock becomes an rt_mutex, we must not
+	 * hold it while doing rt_mutex_start_proxy(), because then it will
+	 * include hb->lock in the blocking chain, even through we'll not in
+	 * fact hold it while blocking. This will lead it to report -EDEADLK
+	 * and BUG when futex_unlock_pi() interleaves with this.
+	 *
+	 * Therefore acquire wait_lock while holding hb->lock, but drop the
+	 * latter before calling rt_mutex_start_proxy_lock(). This still fully
+	 * serializes against futex_unlock_pi() as that does the exact same
+	 * lock handoff sequence.
 	 */
-	rt_mutex_init_waiter(&rt_waiter);
-	ret =3D rt_mutex_start_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter, curr=
ent);
+	raw_spin_lock_irq(&q.pi_state->pi_mutex.wait_lock);
+	spin_unlock(q.lock_ptr);
+	ret =3D __rt_mutex_start_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter, cu=
rrent);
+	raw_spin_unlock_irq(&q.pi_state->pi_mutex.wait_lock);
+
 	if (ret) {
 		if (ret =3D=3D 1)
 			ret =3D 0;
=20
+		spin_lock(q.lock_ptr);
 		goto no_block;
 	}
=20
-	spin_unlock(q.lock_ptr);
=20
 	if (unlikely(to))
 		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
@@ -2974,6 +2987,9 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned =
int flags,
 	 * first acquire the hb->lock before removing the lock from the
 	 * rt_mutex waitqueue, such that we can keep the hb and rt_mutex
 	 * wait lists consistent.
+	 *
+	 * In particular; it is important that futex_unlock_pi() can not
+	 * observe this inconsistency.
 	 */
 	if (ret && !rt_mutex_cleanup_proxy_lock(&q.pi_state->pi_mutex, &rt_waiter=
))
 		ret =3D 0;
@@ -3071,10 +3087,6 @@ static int futex_unlock_pi(u32 __user *uaddr, unsign=
ed int flags)
=20
 		get_pi_state(pi_state);
 		/*
-		 * Since modifying the wait_list is done while holding both
-		 * hb->lock and wait_lock, holding either is sufficient to
-		 * observe it.
-		 *
 		 * By taking wait_lock while still holding hb->lock, we ensure
 		 * there is no point where we hold neither; and therefore
 		 * wake_futex_pi() must observe a state consistent with what we
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index d8585ff1ffab..e4772b0367ff 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1695,31 +1695,14 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock)
 	rt_mutex_set_owner(lock, NULL);
 }
=20
-/**
- * rt_mutex_start_proxy_lock() - Start lock acquisition for another task
- * @lock:		the rt_mutex to take
- * @waiter:		the pre-initialized rt_mutex_waiter
- * @task:		the task to prepare
- *
- * Returns:
- *  0 - task blocked on lock
- *  1 - acquired the lock for task, caller should wake it up
- * <0 - error
- *
- * Special API call for FUTEX_REQUEUE_PI support.
- */
-int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+int __rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
 			      struct task_struct *task)
 {
 	int ret;
=20
-	raw_spin_lock_irq(&lock->wait_lock);
-
-	if (try_to_take_rt_mutex(lock, task, NULL)) {
-		raw_spin_unlock_irq(&lock->wait_lock);
+	if (try_to_take_rt_mutex(lock, task, NULL))
 		return 1;
-	}
=20
 	/* We enforce deadlock detection for futexes */
 	ret =3D task_blocks_on_rt_mutex(lock, waiter, task,
@@ -1738,13 +1721,37 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (unlikely(ret))
 		remove_waiter(lock, waiter);
=20
-	raw_spin_unlock_irq(&lock->wait_lock);
-
 	debug_rt_mutex_print_deadlock(waiter);
=20
 	return ret;
 }
=20
+/**
+ * rt_mutex_start_proxy_lock() - Start lock acquisition for another task
+ * @lock:		the rt_mutex to take
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @task:		the task to prepare
+ *
+ * Returns:
+ *  0 - task blocked on lock
+ *  1 - acquired the lock for task, caller should wake it up
+ * <0 - error
+ *
+ * Special API call for FUTEX_REQUEUE_PI support.
+ */
+int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+			      struct rt_mutex_waiter *waiter,
+			      struct task_struct *task)
+{
+	int ret;
+
+	raw_spin_lock_irq(&lock->wait_lock);
+	ret =3D __rt_mutex_start_proxy_lock(lock, waiter, task);
+	raw_spin_unlock_irq(&lock->wait_lock);
+
+	return ret;
+}
+
 /**
  * rt_mutex_next_owner - return the next owner of the lock
  *
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_commo=
n.h
index 637e6fe51782..c5d3f577b2a7 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -104,6 +104,9 @@ extern void rt_mutex_init_proxy_locked(struct rt_mutex =
*lock,
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
 extern void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
+extern int __rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+				     struct rt_mutex_waiter *waiter,
+				     struct task_struct *task);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
 				     struct task_struct *task);


--j6agz95TelSDp1k9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6g4ACgkQ57/I7JWG
EQkTtw/+OSF927w2xoUVqr0+40TijtHYedjjysEMlysj6Pq+pD/VEtCf3V0E/VGD
lY2gNA/BGQetUyjHMFigRBdW6GHA/+S7AmsU4RMMdcUa0dS/mbgfIVyOPdsFNDSm
2XYMr182nh7Exwf/QfAWuzEKzJfrKaizUflD3or6vemy6JCDDX0dBfA4gLxbl8Zj
/IyHAlBzdBDh41UirBKRDs8izRwTK1CzmrwDMl+mESEKaO++i6o0yF1msV5I99xf
ZJ2IkMYV9ppkMYQ21sX+qO1qIc9zot/2gZNxNLgbc/dPqhTsGaimLf02mk3vFKjG
/5ICG9bCVgOgBgiC3diBLu0bUoHqYIc39eQnfGV6ct9nGuxI1D6p7xPrWkPoSenb
FWIsGxrg519ALZ1x8kFVq6frVWpbiHUEeu/u9Xc2kzvDbSjYCSaxYxEujlBzCkzQ
CKkTNgLYae85Ug3mtwj2VbBzDV9gpHtkDNxkJOSbFC6psTZiXowj+9nO1QlIfhH0
qFHYRFfYCFYGqGVWblTGMXkK+45coXgCmK2j0tNu5HPMdkPhPTWh/vaM63146G3e
KNmvJojbQsTJnPvZQWPc0QFb7FrSYScmrx6KvUThUCC6C99X4taXsWpBN7psNhq2
xiOrwVTSiljLtmbwb5x4b9picUu1u5Htt9CUBAcSSJDqd18/Exo=
=bAQ1
-----END PGP SIGNATURE-----

--j6agz95TelSDp1k9--
