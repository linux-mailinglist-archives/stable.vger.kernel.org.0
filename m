Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A24134BEF5
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC1UnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:43:12 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37172 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhC1Umr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:42:47 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFC-0001y7-1Y; Sun, 28 Mar 2021 22:42:46 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFA-003Ghb-3n; Sun, 28 Mar 2021 22:42:44 +0200
Date:   Sun, 28 Mar 2021 22:42:44 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 09/13] locking/futex: Allow low-level atomic operations to
 return -EAGAIN
Message-ID: <YGDqRGR3K1fUDkoR@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IjmgYXj7njm/zTHw"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IjmgYXj7njm/zTHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Will Deacon <will.deacon@arm.com>

commit 6b4f4bc9cb22875f97023984a625386f0c7cc1c0 upstream.

Some futex() operations, including FUTEX_WAKE_OP, require the kernel to
perform an atomic read-modify-write of the futex word via the userspace
mapping. These operations are implemented by each architecture in
arch_futex_atomic_op_inuser() and futex_atomic_cmpxchg_inatomic(), which
are called in atomic context with the relevant hash bucket locks held.

Although these routines may return -EFAULT in response to a page fault
generated when accessing userspace, they are expected to succeed (i.e.
return 0) in all other cases. This poses a problem for architectures
that do not provide bounded forward progress guarantees or fairness of
contended atomic operations and can lead to starvation in some cases.

In these problematic scenarios, we must return back to the core futex
code so that we can drop the hash bucket locks and reschedule if
necessary, much like we do in the case of a page fault.

Allow architectures to return -EAGAIN from their implementations of
arch_futex_atomic_op_inuser() and futex_atomic_cmpxchg_inatomic(), which
will cause the core futex code to reschedule if necessary and return
back to the architecture code later on.

Cc: <stable@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 185 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 115 insertions(+), 70 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5677fbb97aea..c3c7f5494bfd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1407,13 +1407,15 @@ static int lookup_pi_state(u32 __user *uaddr, u32 u=
val,
=20
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
 {
+	int err;
 	u32 uninitialized_var(curval);
=20
 	if (unlikely(should_fail_futex(true)))
 		return -EFAULT;
=20
-	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
-		return -EFAULT;
+	err =3D cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
+	if (unlikely(err))
+		return err;
=20
 	/* If user space value changed, let the caller retry */
 	return curval !=3D uval ? -EAGAIN : 0;
@@ -1606,10 +1608,8 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval=
, struct futex_pi_state *pi_
 	if (unlikely(should_fail_futex(true)))
 		ret =3D -EFAULT;
=20
-	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)) {
-		ret =3D -EFAULT;
-
-	} else if (curval !=3D uval) {
+	ret =3D cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
+	if (!ret && (curval !=3D uval)) {
 		/*
 		 * If a unconditional UNLOCK_PI operation (user space did not
 		 * try the TID->0 transition) raced with a waiter setting the
@@ -1795,32 +1795,32 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flag=
s, u32 __user *uaddr2,
 	double_lock_hb(hb1, hb2);
 	op_ret =3D futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
-
 		double_unlock_hb(hb1, hb2);
=20
-#ifndef CONFIG_MMU
-		/*
-		 * we don't get EFAULT from MMU faults if we don't have an MMU,
-		 * but we might get them from range checking
-		 */
-		ret =3D op_ret;
-		goto out_put_keys;
-#endif
-
-		if (unlikely(op_ret !=3D -EFAULT)) {
+		if (!IS_ENABLED(CONFIG_MMU) ||
+		    unlikely(op_ret !=3D -EFAULT && op_ret !=3D -EAGAIN)) {
+			/*
+			 * we don't get EFAULT from MMU faults if we don't have
+			 * an MMU, but we might get them from range checking
+			 */
 			ret =3D op_ret;
 			goto out_put_keys;
 		}
=20
-		ret =3D fault_in_user_writeable(uaddr2);
-		if (ret)
-			goto out_put_keys;
+		if (op_ret =3D=3D -EFAULT) {
+			ret =3D fault_in_user_writeable(uaddr2);
+			if (ret)
+				goto out_put_keys;
+		}
=20
-		if (!(flags & FLAGS_SHARED))
+		if (!(flags & FLAGS_SHARED)) {
+			cond_resched();
 			goto retry_private;
+		}
=20
 		put_futex_key(&key2);
 		put_futex_key(&key1);
+		cond_resched();
 		goto retry;
 	}
=20
@@ -2516,14 +2516,17 @@ static int __fixup_pi_state_owner(u32 __user *uaddr=
, struct futex_q *q,
 	if (!pi_state->owner)
 		newtid |=3D FUTEX_OWNER_DIED;
=20
-	if (get_futex_value_locked(&uval, uaddr))
-		goto handle_fault;
+	err =3D get_futex_value_locked(&uval, uaddr);
+	if (err)
+		goto handle_err;
=20
 	for (;;) {
 		newval =3D (uval & FUTEX_OWNER_DIED) | newtid;
=20
-		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
-			goto handle_fault;
+		err =3D cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
+		if (err)
+			goto handle_err;
+
 		if (curval =3D=3D uval)
 			break;
 		uval =3D curval;
@@ -2538,23 +2541,36 @@ static int __fixup_pi_state_owner(u32 __user *uaddr=
, struct futex_q *q,
 	return argowner =3D=3D current;
=20
 	/*
-	 * To handle the page fault we need to drop the locks here. That gives
-	 * the other task (either the highest priority waiter itself or the
-	 * task which stole the rtmutex) the chance to try the fixup of the
-	 * pi_state. So once we are back from handling the fault we need to
-	 * check the pi_state after reacquiring the locks and before trying to
-	 * do another fixup. When the fixup has been done already we simply
-	 * return.
+	 * In order to reschedule or handle a page fault, we need to drop the
+	 * locks here. In the case of a fault, this gives the other task
+	 * (either the highest priority waiter itself or the task which stole
+	 * the rtmutex) the chance to try the fixup of the pi_state. So once we
+	 * are back from handling the fault we need to check the pi_state after
+	 * reacquiring the locks and before trying to do another fixup. When
+	 * the fixup has been done already we simply return.
 	 *
 	 * Note: we hold both hb->lock and pi_mutex->wait_lock. We can safely
 	 * drop hb->lock since the caller owns the hb -> futex_q relation.
 	 * Dropping the pi_mutex->wait_lock requires the state revalidate.
 	 */
-handle_fault:
+handle_err:
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	spin_unlock(q->lock_ptr);
=20
-	err =3D fault_in_user_writeable(uaddr);
+	switch (err) {
+	case -EFAULT:
+		err =3D fault_in_user_writeable(uaddr);
+		break;
+
+	case -EAGAIN:
+		cond_resched();
+		err =3D 0;
+		break;
+
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
=20
 	spin_lock(q->lock_ptr);
 	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
@@ -3128,10 +3144,8 @@ static int futex_unlock_pi(u32 __user *uaddr, unsign=
ed int flags)
 		 * A unconditional UNLOCK_PI op raced against a waiter
 		 * setting the FUTEX_WAITERS bit. Try again.
 		 */
-		if (ret =3D=3D -EAGAIN) {
-			put_futex_key(&key);
-			goto retry;
-		}
+		if (ret =3D=3D -EAGAIN)
+			goto pi_retry;
 		/*
 		 * wake_futex_pi has detected invalid state. Tell user
 		 * space.
@@ -3146,9 +3160,19 @@ static int futex_unlock_pi(u32 __user *uaddr, unsign=
ed int flags)
 	 * preserve the WAITERS bit not the OWNER_DIED one. We are the
 	 * owner.
 	 */
-	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0)) {
+	if ((ret =3D cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))) {
 		spin_unlock(&hb->lock);
-		goto pi_faulted;
+		switch (ret) {
+		case -EFAULT:
+			goto pi_faulted;
+
+		case -EAGAIN:
+			goto pi_retry;
+
+		default:
+			WARN_ON_ONCE(1);
+			goto out_putkey;
+		}
 	}
=20
 	/*
@@ -3162,6 +3186,11 @@ static int futex_unlock_pi(u32 __user *uaddr, unsign=
ed int flags)
 	put_futex_key(&key);
 	return ret;
=20
+pi_retry:
+	put_futex_key(&key);
+	cond_resched();
+	goto retry;
+
 pi_faulted:
 	put_futex_key(&key);
=20
@@ -3504,6 +3533,7 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,=
 int pi)
 {
 	u32 uval, uninitialized_var(nval), mval;
+	int err;
=20
 	/* Futex address must be 32bit aligned */
 	if ((((unsigned long)uaddr) % sizeof(*uaddr)) !=3D 0)
@@ -3513,42 +3543,57 @@ static int handle_futex_death(u32 __user *uaddr, st=
ruct task_struct *curr, int p
 	if (get_user(uval, uaddr))
 		return -1;
=20
-	if ((uval & FUTEX_TID_MASK) =3D=3D task_pid_vnr(curr)) {
-		/*
-		 * Ok, this dying thread is truly holding a futex
-		 * of interest. Set the OWNER_DIED bit atomically
-		 * via cmpxchg, and if the value had FUTEX_WAITERS
-		 * set, wake up a waiter (if any). (We have to do a
-		 * futex_wake() even if OWNER_DIED is already set -
-		 * to handle the rare but possible case of recursive
-		 * thread-death.) The rest of the cleanup is done in
-		 * userspace.
-		 */
-		mval =3D (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		/*
-		 * We are not holding a lock here, but we want to have
-		 * the pagefault_disable/enable() protection because
-		 * we want to handle the fault gracefully. If the
-		 * access fails we try to fault in the futex with R/W
-		 * verification via get_user_pages. get_user() above
-		 * does not guarantee R/W access. If that fails we
-		 * give up and leave the futex locked.
-		 */
-		if (cmpxchg_futex_value_locked(&nval, uaddr, uval, mval)) {
+	if ((uval & FUTEX_TID_MASK) !=3D task_pid_vnr(curr))
+		return 0;
+
+	/*
+	 * Ok, this dying thread is truly holding a futex
+	 * of interest. Set the OWNER_DIED bit atomically
+	 * via cmpxchg, and if the value had FUTEX_WAITERS
+	 * set, wake up a waiter (if any). (We have to do a
+	 * futex_wake() even if OWNER_DIED is already set -
+	 * to handle the rare but possible case of recursive
+	 * thread-death.) The rest of the cleanup is done in
+	 * userspace.
+	 */
+	mval =3D (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
+
+	/*
+	 * We are not holding a lock here, but we want to have
+	 * the pagefault_disable/enable() protection because
+	 * we want to handle the fault gracefully. If the
+	 * access fails we try to fault in the futex with R/W
+	 * verification via get_user_pages. get_user() above
+	 * does not guarantee R/W access. If that fails we
+	 * give up and leave the futex locked.
+	 */
+	if ((err =3D cmpxchg_futex_value_locked(&nval, uaddr, uval, mval))) {
+		switch (err) {
+		case -EFAULT:
 			if (fault_in_user_writeable(uaddr))
 				return -1;
 			goto retry;
-		}
-		if (nval !=3D uval)
+
+		case -EAGAIN:
+			cond_resched();
 			goto retry;
=20
-		/*
-		 * Wake robust non-PI futexes here. The wakeup of
-		 * PI futexes happens in exit_pi_state():
-		 */
-		if (!pi && (uval & FUTEX_WAITERS))
-			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+		default:
+			WARN_ON_ONCE(1);
+			return err;
+		}
 	}
+
+	if (nval !=3D uval)
+		goto retry;
+
+	/*
+	 * Wake robust non-PI futexes here. The wakeup of
+	 * PI futexes happens in exit_pi_state():
+	 */
+	if (!pi && (uval & FUTEX_WAITERS))
+		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+
 	return 0;
 }
=20


--IjmgYXj7njm/zTHw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6kMACgkQ57/I7JWG
EQmWzA//RXNv/kGiELgeYUkKKRS3uGKxqNahbar99W1huVN0Z/+4OTfmwvzfZkWM
kKIXQT1TnlPsSrOFGzRL/O0iF2kA6G/zg2FH04Ag/khAFExfxmfqq0/v0V94vcpG
wspmY8k/KAfzz0WpzcIb7JmZFN5UHIzpLJi1+z1CMXSLoY31HRU/wHTj9Vx93G0N
syzSq0Xch0WgMe9nklIyy0LyBUyGjF8KwYahJX8s8BU7hooJqzuZ35fJrvD0C5Im
5YcAVanV7bg7kebR7Zadkt4Skw72Ebo7FHdGLVntR/TRJhjdeBBkxsVM0dSL0KIS
oSW/wpNpnCePqTMF6w4I/vN1PWHFP4DKBO6ycvAYwQvi+9whVa7UvFtqdC88Vcpd
WgUm4u0T2f69vNshIaufuTs094RGfMG4ISevqIVV2q5OqFydaOG5eKc+iOHmsgjV
D5VBpqrbThFEiZn3NdDJlqp0fZ5DKocwfGH/cmVgow4GPoHoK5Q/DibcaDrA1dzI
yc6BXqDDhHesoWtnlCFifDxSvqfIcmo3/zSxklTEvy+I0YTQ97Ar1SGrUseN/gO6
8uVg1kzxng88Mx6iXdwpKO5aMIolQ6is0xMQiYL5xn4w7kuCPMPhDltJetTWhI/b
ij1woANnfOf2f8xPnJ/nSFN2uRPCQbQeanTOM4/Tp7n6WV+RE/s=
=qgNL
-----END PGP SIGNATURE-----

--IjmgYXj7njm/zTHw--
