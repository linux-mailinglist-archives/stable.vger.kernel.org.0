Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8630C34BEF2
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhC1Umj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:42:39 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37142 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhC1UmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:42:16 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEh-0001x4-2Y; Sun, 28 Mar 2021 22:42:15 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEb-003Gek-17; Sun, 28 Mar 2021 22:42:09 +0200
Date:   Sun, 28 Mar 2021 22:42:08 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 06/13] futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()
Message-ID: <YGDqIHbfbs/FszkQ@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZFSZPNjK40Bq9yqL"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZFSZPNjK40Bq9yqL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 04dc1b2fff4e96cb4142227fbdc63c8871ad4ed9 upstream.

Markus reported that the glibc/nptl/tst-robustpi8 test was failing after
commit:

  cfafcd117da0 ("futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock=
()")

The following trace shows the problem:

 ld-linux-x86-64-2161  [019] ....   410.760971: SyS_futex: 00007ffbeb76b028=
: 80000875  op=3DFUTEX_LOCK_PI
 ld-linux-x86-64-2161  [019] ...1   410.760972: lock_pi_update_atomic: 0000=
7ffbeb76b028: curval=3D80000875 uval=3D80000875 newval=3D80000875 ret=3D0
 ld-linux-x86-64-2165  [011] ....   410.760978: SyS_futex: 00007ffbeb76b028=
: 80000875  op=3DFUTEX_UNLOCK_PI
 ld-linux-x86-64-2165  [011] d..1   410.760979: do_futex: 00007ffbeb76b028:=
 curval=3D80000875 uval=3D80000875 newval=3D80000871 ret=3D0
 ld-linux-x86-64-2165  [011] ....   410.760980: SyS_futex: 00007ffbeb76b028=
: 80000871 ret=3D0000
 ld-linux-x86-64-2161  [019] ....   410.760980: SyS_futex: 00007ffbeb76b028=
: 80000871 ret=3DETIMEDOUT

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
				futex_uval =3D 2161;
				spin_unlock(hb->lock);
spin_lock(hb->lock);
rt_mutex_cleanup_proxy_lock()
  if (rtmutex_owner() !=3D=3D current)
     ...
     return FAIL;
=2E...
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

Fixes: 38d589f2fd08 ("futex,rt_mutex: Restructure rt_mutex_finish_proxy_loc=
k()")
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Bug-Spotted-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Link: http://lkml.kernel.org/r/20170519154850.mlomgdsd26drq5j6@hirez.progra=
mming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/locking/rtmutex.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index e4772b0367ff..eb933efdd224 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1796,12 +1796,14 @@ int rt_mutex_wait_proxy_lock(struct rt_mutex *lock,
 	int ret;
=20
 	raw_spin_lock_irq(&lock->wait_lock);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-
 	/* sleep on the mutex */
+	set_current_state(TASK_INTERRUPTIBLE);
 	ret =3D __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
-
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
 	raw_spin_unlock_irq(&lock->wait_lock);
=20
 	return ret;
@@ -1832,16 +1834,26 @@ bool rt_mutex_cleanup_proxy_lock(struct rt_mutex *l=
ock,
 	bool cleanup =3D false;
=20
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
 	if (rt_mutex_owner(lock) !=3D current) {
 		remove_waiter(lock, waiter);
-		fixup_rt_mutex_waiters(lock);
 		cleanup =3D true;
 	}
-
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.


--ZFSZPNjK40Bq9yqL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6iAACgkQ57/I7JWG
EQnFDBAAx9tfql6Xe8GzZLcQQ+R5ZPkKz9RhjRlRf/IE+nThq0qbDfixMaMErpcl
fo+2q7U7wz+wCx7IlgzWH6rHUBRs9huTQzYZdMpsm59ofs3R5i+gTL3IqiGfNvTB
JsJtnqc+lXJ7idlmRR+U6lwh1/FPsRL77XmuuCf+rXZO8UDNbQDGmlI24uR3M7n/
o7noW9XzMfpgMo0aZ0dRK3B1hQqTbMIH+NruZkI+PrKM/3KQ6kdQ7DNGqisLcgAJ
UdGdcNnx21ddc9QOkGPWLCGUmSi+QoVZcU8a3d5l7TOKCgUNByNBykWDMw6oRrvi
npSL7T1qt0gfqYfBN8h4Lk/01RikhT+hJ1XZ9ShLQQsk+uxaFQFY7iw9wi21S37W
S16pL5UCLmyg7Bd3uu6CaQjZK94lnzWpb+h9bc0Jy4fbw3RZ4tS9z3bnBSkzA4j1
k4Vfplem9BKoOjjfcp6Fzt/skOPRQeOv0Yp3uV67swk31tqTNt2jwY2d53mZ6T1y
uglkakg9Sp4yB606dqbadrF6tjSXuPvwzoOJTL1xCGItVeqJnbYs8pf5eQOXdyvC
EyISfsKqPNbC7HAQaPkfpO8vgKiFZS1qHofFUfiTcz+iyeXt5H9PimMHs1vr6COB
EoZR+Gap5oBjWp39InjPrd5lPlqYKytJaZvTprVlISTE/J+ewAM=
=CLw2
-----END PGP SIGNATURE-----

--ZFSZPNjK40Bq9yqL--
