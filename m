Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469DA32884B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhCARib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:31 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32786 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbhCARbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:31:31 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmNU-0002Zd-RQ; Mon, 01 Mar 2021 18:30:40 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmNT-004iTj-RW; Mon, 01 Mar 2021 18:30:39 +0100
Date:   Mon, 1 Mar 2021 18:30:39 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 1/7] futex: Cleanup variable names for futex_top_waiter()
Message-ID: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KKUuAA9Gm12dJ6Re"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KKUuAA9Gm12dJ6Re
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 499f5aca2cdd5e958b27e2655e7e7f82524f46b1 upstream.

futex_top_waiter() returns the top-waiter on the pi_mutex. Assinging
this to a variable 'match' totally obscures the code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.554710645@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0b49a8e1e1be..1cb5064548d6 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1352,14 +1352,14 @@ static int lookup_pi_state(u32 __user *uaddr, u32 u=
val,
 			   union futex_key *key, struct futex_pi_state **ps,
 			   struct task_struct **exiting)
 {
-	struct futex_q *match =3D futex_top_waiter(hb, key);
+	struct futex_q *top_waiter =3D futex_top_waiter(hb, key);
=20
 	/*
 	 * If there is a waiter on that futex, validate it and
 	 * attach to the pi_state when the validation succeeds.
 	 */
-	if (match)
-		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
+	if (top_waiter)
+		return attach_to_pi_state(uaddr, uval, top_waiter->pi_state, ps);
=20
 	/*
 	 * We are the first waiter - try to look up the owner based on
@@ -1414,7 +1414,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, st=
ruct futex_hash_bucket *hb,
 				int set_waiters)
 {
 	u32 uval, newval, vpid =3D task_pid_vnr(task);
-	struct futex_q *match;
+	struct futex_q *top_waiter;
 	int ret;
=20
 	/*
@@ -1440,9 +1440,9 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, st=
ruct futex_hash_bucket *hb,
 	 * Lookup existing state first. If it exists, try to attach to
 	 * its pi_state.
 	 */
-	match =3D futex_top_waiter(hb, key);
-	if (match)
-		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
+	top_waiter =3D futex_top_waiter(hb, key);
+	if (top_waiter)
+		return attach_to_pi_state(uaddr, uval, top_waiter->pi_state, ps);
=20
 	/*
 	 * No waiter and user TID is 0. We are here because the
@@ -1532,11 +1532,11 @@ static void mark_wake_futex(struct wake_q_head *wak=
e_q, struct futex_q *q)
 	q->lock_ptr =3D NULL;
 }
=20
-static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
+static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *top_=
waiter,
 			 struct futex_hash_bucket *hb)
 {
 	struct task_struct *new_owner;
-	struct futex_pi_state *pi_state =3D this->pi_state;
+	struct futex_pi_state *pi_state =3D top_waiter->pi_state;
 	u32 uninitialized_var(curval), newval;
 	WAKE_Q(wake_q);
 	bool deboost;
@@ -1557,7 +1557,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval,=
 struct futex_q *this,
=20
 	/*
 	 * When we interleave with futex_lock_pi() where it does
-	 * rt_mutex_timed_futex_lock(), we might observe @this futex_q waiter,
+	 * rt_mutex_timed_futex_lock(), we might observe @top_waiter futex_q wait=
er,
 	 * but the rt_mutex's wait_list can be empty (either still, or again,
 	 * depending on which side we land).
 	 *
@@ -2975,7 +2975,7 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigne=
d int flags)
 	u32 uninitialized_var(curval), uval, vpid =3D task_pid_vnr(current);
 	union futex_key key =3D FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb;
-	struct futex_q *match;
+	struct futex_q *top_waiter;
 	int ret;
=20
 retry:
@@ -2999,9 +2999,9 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigne=
d int flags)
 	 * all and we at least want to know if user space fiddled
 	 * with the futex value instead of blindly unlocking.
 	 */
-	match =3D futex_top_waiter(hb, &key);
-	if (match) {
-		ret =3D wake_futex_pi(uaddr, uval, match, hb);
+	top_waiter =3D futex_top_waiter(hb, &key);
+	if (top_waiter) {
+		ret =3D wake_futex_pi(uaddr, uval, top_waiter, hb);
 		/*
 		 * In case of success wake_futex_pi dropped the hash
 		 * bucket lock.


--KKUuAA9Gm12dJ6Re
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JL8ACgkQ57/I7JWG
EQkyOBAAph/pru9juYk1x4jRJe3wYzWakT1GlApShJRUvzIXpbvUm4XllkqGRHwD
cFY0QQeKUmQuYw21qsndSogaBX9F9Gbt9krktyZw4lECVbFi0Ab3poTqIolO6Ztj
rY7zJo7NGWUytIBJv+lWD+K1j59684LPp7PVB1VO+3jyeX+N0MRDMUz/RKj3gLTy
N8jTsQvW6p6slmJxH2V4rUYo0h5xqtQ402exbleuFzi/XLQnIxQwWzI9dF7QhU/L
7keMXFyVMyXfYRWxvIyFwEYzhE1VySO1ieAXXPnDhHMBthZ1mngYtCjfZ6Je7KPu
k+xhsauD5QYRVD+giSQFvW0760QFqcGchGdQiYjQlQLKQ81ZV/msFF7wtSPzx3fE
lbHikchMoXjfZWaRws8TkBbs4Wcb67oRJj6aVvrGyRj3yTWZ6N+4/vfklUtpge94
/pVq+Si+X6SPtM6iNTexrCUvoa9TUbzU1w2DnYjbmEXs/EHTJppPp1wPw1kHFCuG
WgrklYVAJL5C6jI8d1QvUX5zP7OzIv4oKB2nEsF2h3+cOR911bA6HiCo8EJDUguX
Dr1ZEyC8jbcikV+et42LnOj9BIJCUAA1vTt7De3Lq5zcFtITrPgAR69dy2vHuBlR
R3gtLujT6lZ/tt5NCf9+E2Egmnw+eqWu28hQ0819HHwaYBOLDXs=
=3veq
-----END PGP SIGNATURE-----

--KKUuAA9Gm12dJ6Re--
