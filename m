Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041D3328878
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhCARkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:40:25 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32842 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbhCARcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:32:24 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOS-0002aJ-6S; Mon, 01 Mar 2021 18:31:40 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOR-004iX7-BR; Mon, 01 Mar 2021 18:31:39 +0100
Date:   Mon, 1 Mar 2021 18:31:39 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 4/7] futex: Futex_unlock_pi() determinism
Message-ID: <YD0k+9Ukc5MhhU8V@decadent.org.uk>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z0egGUwulAa5aYJ/"
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--z0egGUwulAa5aYJ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit bebe5b514345f09be2c15e414d076b02ecb9cce8 upstream.

The problem with returning -EAGAIN when the waiter state mismatches is that
it becomes very hard to proof a bounded execution time on the
operation. And seeing that this is a RT operation, this is somewhat
important.

While in practise; given the previous patch; it will be very unlikely to
ever really take more than one or two rounds, proving so becomes rather
hard.

However, now that modifying wait_list is done while holding both hb->lock
and wait_lock, the scenario can be avoided entirely by acquiring wait_lock
while still holding hb-lock. Doing a hand-over, without leaving a hole.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104152.112378812@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c8ec4e7f3609..77cec33ea112 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1555,15 +1555,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uva=
l, struct futex_pi_state *pi_
 	WAKE_Q(wake_q);
 	int ret =3D 0;
=20
-	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner =3D rt_mutex_next_owner(&pi_state->pi_mutex);
-	if (!new_owner) {
+	if (WARN_ON_ONCE(!new_owner)) {
 		/*
-		 * Since we held neither hb->lock nor wait_lock when coming
-		 * into this function, we could have raced with futex_lock_pi()
-		 * such that we might observe @this futex_q waiter, but the
-		 * rt_mutex's wait_list can be empty (either still, or again,
-		 * depending on which side we land).
+		 * As per the comment in futex_unlock_pi() this should not happen.
 		 *
 		 * When this happens, give up our locks and try again, giving
 		 * the futex_lock_pi() instance time to complete, either by
@@ -3018,15 +3013,18 @@ static int futex_unlock_pi(u32 __user *uaddr, unsig=
ned int flags)
 		if (pi_state->owner !=3D current)
 			goto out_unlock;
=20
+		get_pi_state(pi_state);
 		/*
-		 * Grab a reference on the pi_state and drop hb->lock.
+		 * Since modifying the wait_list is done while holding both
+		 * hb->lock and wait_lock, holding either is sufficient to
+		 * observe it.
 		 *
-		 * The reference ensures pi_state lives, dropping the hb->lock
-		 * is tricky.. wake_futex_pi() will take rt_mutex::wait_lock to
-		 * close the races against futex_lock_pi(), but in case of
-		 * _any_ fail we'll abort and retry the whole deal.
+		 * By taking wait_lock while still holding hb->lock, we ensure
+		 * there is no point where we hold neither; and therefore
+		 * wake_futex_pi() must observe a state consistent with what we
+		 * observed.
 		 */
-		get_pi_state(pi_state);
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
=20
 		ret =3D wake_futex_pi(uaddr, uval, pi_state);


--z0egGUwulAa5aYJ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JPsACgkQ57/I7JWG
EQnhow//UDpYxrOwXAVEgL72SBsvZRbMUtptiOmf3M7GSp/ln257V3aM6ETsEOwb
e5l6S8uDu+13Wjw51ttI0LNnJuTwXV3cBaoZHFteAT8yJg7udUHtw40iGu8La8k7
3GEGEDiUCgL/rMtu2q2F/mGs87/Hvbovv0e7ygD3h+X0UDVeqa/9yIef40UIa0Kl
eOWj6qem+5Q53ohCWDueJ+Qv2EaIPvYdQF82VCjpd7m4iErGx3tryFmMTDksxVWJ
ZXl/kN3FuOIcPKUwuCVWkX8nxhNMaGtrcufgjirpy8j0dldjt3+neIH54NtJewb2
e6O+8B6ppDK4mgzAAnWi4RpqNTbiEKamZtZxrdaDYWwMKoAgbYN5AR+Oya6rKUUb
9kPzlnKZMtPtPigP9gDVH8usYgnjd25gVdlPbmUbmlZ+14Wb2Kovody1Xnz8cICM
Lg6yNj/Bq+MDTiWsA10obi0TBGa0SHx1DqN7V+A9tv4tbPs7mlY6pn/tha+jLgOm
TjklucOlCQylofsrrvAc481P97dJPsJKZR6wXre7ElbDaJJrsAyDHR8qSC7pFfat
piR1fUNydvRxt9OCUTR5uLYRinWxiELZP1+3FSY3gGMgdH9fC7Fw/xjJ3dc9Ye+6
ykH3TFJ/pcaDWL8vyYbzqhDUkcFQ3oqGxOQrBbTnr6RpDf9jRtQ=
=9BbZ
-----END PGP SIGNATURE-----

--z0egGUwulAa5aYJ/--
