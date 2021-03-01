Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC712328875
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbhCARkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:40:13 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32836 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238077AbhCARcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:32:22 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOJ-0002aD-Js; Mon, 01 Mar 2021 18:31:31 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOI-004iWV-PP; Mon, 01 Mar 2021 18:31:30 +0100
Date:   Mon, 1 Mar 2021 18:31:30 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 3/7] futex: Pull rt_mutex_futex_unlock() out from under
 hb->lock
Message-ID: <YD0k8hpgdxeBVa2M@decadent.org.uk>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LB1rnQa1J0v9SHur"
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LB1rnQa1J0v9SHur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 16ffa12d742534d4ff73e8b3a4e81c1de39196f0 upstream.

There's a number of 'interesting' problems, all caused by holding
hb->lock while doing the rt_mutex_unlock() equivalient.

Notably:

 - a PI inversion on hb->lock; and,

 - a SCHED_DEADLINE crash because of pointer instability.

The previous changes:

 - changed the locking rules to cover {uval,pi_state} with wait_lock.

 - allow to do rt_mutex_futex_unlock() without dropping wait_lock; which in
   turn allows to rely on wait_lock atomicity completely.

 - simplified the waiter conundrum.

It's now sufficient to hold rtmutex::wait_lock and a reference on the
pi_state to protect the state consistency, so hb->lock can be dropped
before calling rt_mutex_futex_unlock().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.900002056@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 111 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 68 insertions(+), 43 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bf410a4fab71..c8ec4e7f3609 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -966,10 +966,12 @@ static void exit_pi_state_list(struct task_struct *cu=
rr)
 		pi_state->owner =3D NULL;
 		raw_spin_unlock_irq(&curr->pi_lock);
=20
-		rt_mutex_futex_unlock(&pi_state->pi_mutex);
-
+		get_pi_state(pi_state);
 		spin_unlock(&hb->lock);
=20
+		rt_mutex_futex_unlock(&pi_state->pi_mutex);
+		put_pi_state(pi_state);
+
 		raw_spin_lock_irq(&curr->pi_lock);
 	}
 	raw_spin_unlock_irq(&curr->pi_lock);
@@ -1083,6 +1085,11 @@ static int attach_to_pi_state(u32 __user *uaddr, u32=
 uval,
 	 * has dropped the hb->lock in between queue_me() and unqueue_me_pi(),
 	 * which in turn means that futex_lock_pi() still has a reference on
 	 * our pi_state.
+	 *
+	 * The waiter holding a reference on @pi_state also protects against
+	 * the unlocked put_pi_state() in futex_unlock_pi(), futex_lock_pi()
+	 * and futex_wait_requeue_pi() as it cannot go to 0 and consequently
+	 * free pi_state before we can take a reference ourselves.
 	 */
 	WARN_ON(!atomic_read(&pi_state->refcount));
=20
@@ -1537,48 +1544,40 @@ static void mark_wake_futex(struct wake_q_head *wak=
e_q, struct futex_q *q)
 	q->lock_ptr =3D NULL;
 }
=20
-static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *top_=
waiter,
-			 struct futex_hash_bucket *hb)
+/*
+ * Caller must hold a reference on @pi_state.
+ */
+static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_stat=
e *pi_state)
 {
-	struct task_struct *new_owner;
-	struct futex_pi_state *pi_state =3D top_waiter->pi_state;
 	u32 uninitialized_var(curval), newval;
+	struct task_struct *new_owner;
+	bool deboost =3D false;
 	WAKE_Q(wake_q);
-	bool deboost;
 	int ret =3D 0;
=20
-	if (!pi_state)
-		return -EINVAL;
-
-	/*
-	 * If current does not own the pi_state then the futex is
-	 * inconsistent and user space fiddled with the futex value.
-	 */
-	if (pi_state->owner !=3D current)
-		return -EINVAL;
-
 	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner =3D rt_mutex_next_owner(&pi_state->pi_mutex);
-
-	/*
-	 * When we interleave with futex_lock_pi() where it does
-	 * rt_mutex_timed_futex_lock(), we might observe @top_waiter futex_q wait=
er,
-	 * but the rt_mutex's wait_list can be empty (either still, or again,
-	 * depending on which side we land).
-	 *
-	 * When this happens, give up our locks and try again, giving the
-	 * futex_lock_pi() instance time to complete, either by waiting on the
-	 * rtmutex or removing itself from the futex queue.
-	 */
 	if (!new_owner) {
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
-		return -EAGAIN;
+		/*
+		 * Since we held neither hb->lock nor wait_lock when coming
+		 * into this function, we could have raced with futex_lock_pi()
+		 * such that we might observe @this futex_q waiter, but the
+		 * rt_mutex's wait_list can be empty (either still, or again,
+		 * depending on which side we land).
+		 *
+		 * When this happens, give up our locks and try again, giving
+		 * the futex_lock_pi() instance time to complete, either by
+		 * waiting on the rtmutex or removing itself from the futex
+		 * queue.
+		 */
+		ret =3D -EAGAIN;
+		goto out_unlock;
 	}
=20
 	/*
-	 * We pass it to the next owner. The WAITERS bit is always
-	 * kept enabled while there is PI state around. We cleanup the
-	 * owner died bit, because we are the owner.
+	 * We pass it to the next owner. The WAITERS bit is always kept
+	 * enabled while there is PI state around. We cleanup the owner
+	 * died bit, because we are the owner.
 	 */
 	newval =3D FUTEX_WAITERS | task_pid_vnr(new_owner);
=20
@@ -1611,15 +1610,15 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uva=
l, struct futex_q *top_waiter
 		deboost =3D __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
 	}
=20
+out_unlock:
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
-	spin_unlock(&hb->lock);
=20
 	if (deboost) {
 		wake_up_q(&wake_q);
 		rt_mutex_adjust_prio(current);
 	}
=20
-	return 0;
+	return ret;
 }
=20
 /*
@@ -2493,7 +2492,7 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, =
struct futex_q *q,
 	if (get_futex_value_locked(&uval, uaddr))
 		goto handle_fault;
=20
-	while (1) {
+	for (;;) {
 		newval =3D (uval & FUTEX_OWNER_DIED) | newtid;
=20
 		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
@@ -3006,10 +3005,36 @@ static int futex_unlock_pi(u32 __user *uaddr, unsig=
ned int flags)
 	 */
 	top_waiter =3D futex_top_waiter(hb, &key);
 	if (top_waiter) {
-		ret =3D wake_futex_pi(uaddr, uval, top_waiter, hb);
+		struct futex_pi_state *pi_state =3D top_waiter->pi_state;
+
+		ret =3D -EINVAL;
+		if (!pi_state)
+			goto out_unlock;
+
 		/*
-		 * In case of success wake_futex_pi dropped the hash
-		 * bucket lock.
+		 * If current does not own the pi_state then the futex is
+		 * inconsistent and user space fiddled with the futex value.
+		 */
+		if (pi_state->owner !=3D current)
+			goto out_unlock;
+
+		/*
+		 * Grab a reference on the pi_state and drop hb->lock.
+		 *
+		 * The reference ensures pi_state lives, dropping the hb->lock
+		 * is tricky.. wake_futex_pi() will take rt_mutex::wait_lock to
+		 * close the races against futex_lock_pi(), but in case of
+		 * _any_ fail we'll abort and retry the whole deal.
+		 */
+		get_pi_state(pi_state);
+		spin_unlock(&hb->lock);
+
+		ret =3D wake_futex_pi(uaddr, uval, pi_state);
+
+		put_pi_state(pi_state);
+
+		/*
+		 * Success, we're done! No tricky corner cases.
 		 */
 		if (!ret)
 			goto out_putkey;
@@ -3024,7 +3049,6 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigne=
d int flags)
 		 * setting the FUTEX_WAITERS bit. Try again.
 		 */
 		if (ret =3D=3D -EAGAIN) {
-			spin_unlock(&hb->lock);
 			put_futex_key(&key);
 			goto retry;
 		}
@@ -3032,7 +3056,7 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigne=
d int flags)
 		 * wake_futex_pi has detected invalid state. Tell user
 		 * space.
 		 */
-		goto out_unlock;
+		goto out_putkey;
 	}
=20
 	/*
@@ -3042,8 +3066,10 @@ static int futex_unlock_pi(u32 __user *uaddr, unsign=
ed int flags)
 	 * preserve the WAITERS bit not the OWNER_DIED one. We are the
 	 * owner.
 	 */
-	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))
+	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0)) {
+		spin_unlock(&hb->lock);
 		goto pi_faulted;
+	}
=20
 	/*
 	 * If uval has changed, let user space handle it.
@@ -3057,7 +3083,6 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigne=
d int flags)
 	return ret;
=20
 pi_faulted:
-	spin_unlock(&hb->lock);
 	put_futex_key(&key);
=20
 	ret =3D fault_in_user_writeable(uaddr);


--LB1rnQa1J0v9SHur
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JPIACgkQ57/I7JWG
EQkbRA/+PwJEEtt9NK8tBP43cqEHXdV07Y+KxEioMneQmxiNLROEEFGJeTVBor0s
yyrqBOpKBrATaMXY8bDqPoRTR3mgNHlmr0FwrAyhBtCUwa4m4s19OXjH4eyOEY2B
9meC8J7fa/Nf4XXvvZOwEuSfG08kbioZ0/imLWIs1EeOi9417c6WeUwP8hQ2MlrI
c9EmXMp2nyLMZRbMd49bzxq6KkltymPFw7s6NexqayL5aD+ubJJj6fQ4nCVTy0ME
h9LPq4L7BsfgPlKyINZ2oQgx94MEcOtELGe5rCGipDhBYJJlar0Q3UiTVlHYYb5I
6eZLnxA443e1Ccx6bVBpewBeoqnr2gj60WKG+87VhVYvk8BV+UHDLQjLK+3CUXF3
Q1svZNEm54pjRialqpDvlcDPujeb5603IACfvcWe2s/Cjpv5yN1n9piV0oPj1M7l
5a2bZz/sc1H5+BYGP3hxkfTFl0Gd8/2O4ya8jj7X/eL8f30XQC6Il0ZJMFzQrYav
ZoEfF5Pp7RAWEIIaZwA9I6CWNnj0Vrzxf8zKIQAgBvAJaYQn9n/iwEinUncl7/ko
uvXmbfjmsUYhp8V/ZBSgusVC4//6ZX/lXxrEWDpfTw1By9ZpB7YgN5ZBDFCRQiUf
2kA0MPzwq/zrc+IEXf70Rwb3cp2pQZyr1SVyP8ygLi0gnrETBKY=
=l6SM
-----END PGP SIGNATURE-----

--LB1rnQa1J0v9SHur--
