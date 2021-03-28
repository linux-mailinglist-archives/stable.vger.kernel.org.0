Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C31134BEF3
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhC1UnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:43:11 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37158 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbhC1Umj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:42:39 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcF4-0001xZ-0P; Sun, 28 Mar 2021 22:42:38 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcF3-003GgV-5p; Sun, 28 Mar 2021 22:42:37 +0200
Date:   Sun, 28 Mar 2021 22:42:32 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 08/13] futex: Fix (possible) missed wakeup
Message-ID: <YGDqOPquwh/m9sL9@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7IT3T4tENIWZaas+"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7IT3T4tENIWZaas+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit b061c38bef43406df8e73c5be06cbfacad5ee6ad upstream.

We must not rely on wake_q_add() to delay the wakeup; in particular
commit:

  1d0dcb3ad9d3 ("futex: Implement lockless wakeups")

moved wake_q_add() before smp_store_release(&q->lock_ptr, NULL), which
could result in futex_wait() waking before observing ->lock_ptr =3D=3D
NULL and going back to sleep again.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 1d0dcb3ad9d3 ("futex: Implement lockless wakeups")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 60be2d3cfdd7..5677fbb97aea 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1553,11 +1553,7 @@ static void mark_wake_futex(struct wake_q_head *wake=
_q, struct futex_q *q)
 	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
 		return;
=20
-	/*
-	 * Queue the task for later wakeup for after we've released
-	 * the hb->lock. wake_q_add() grabs reference to p.
-	 */
-	wake_q_add(wake_q, p);
+	get_task_struct(p);
 	__unqueue_futex(q);
 	/*
 	 * The waiting task can free the futex_q as soon as
@@ -1566,6 +1562,13 @@ static void mark_wake_futex(struct wake_q_head *wake=
_q, struct futex_q *q)
 	 * store to lock_ptr from getting ahead of the plist_del.
 	 */
 	smp_store_release(&q->lock_ptr, NULL);
+
+	/*
+	 * Queue the task for later wakeup for after we've released
+	 * the hb->lock. wake_q_add() grabs reference to p.
+	 */
+	wake_q_add(wake_q, p);
+	put_task_struct(p);
 }
=20
 /*


--7IT3T4tENIWZaas+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6jgACgkQ57/I7JWG
EQlfNxAAj9KAVU5JWncteO3PmHcL3KhMTk6iHhT7A7m3Yt9ErlmnwyzY4I1vQbk0
Kp301cBf+nqP3m8Qz99ODN8/ewpMJYJzysRCSnU243ebNUiClBZ0t/KL0/n/Lycl
Pje09l1lpRF+70hBYVM4/TC+YluqQjnYD9Z0KUztEqXZQ0OnUbfhIAC0jhQQUCtb
VWik4kdUDOHuKEdIzQFmbiUuG6+wDajLId03N6xJbgo5JB0JNDhyWZtp+Jnwt9KQ
gc44s+DMgbWVM/gvsPlugl2b4DmtDnzOjmCQV/+1EW7Dh59WDQeWtSzWuRoYiZ0V
QZn8sHcu+W6HLPb2MRyV2nSJjqMbZDHY0+I659wN4GWEXRwXsLFiM0CAXkp9ejJQ
KjnDZ3/7YmTfRabuqwI8DB69JAq/NcFTfQaduMa5Jjirhq7J+KRB86uJNLV3RPG/
6qj2MLpxlA2J7JJ9HGa9lNqZ4MYlnwy3MP/XKbRc6yUNk22x2VHITFeGqBpBpFMu
L751uCVXKuUlJ829FcyShlZzZy/HYKZf4TC9NItRPZXhnc5Y+5iJUxoq0GZM+a0D
r2sM+e2x70ZXAcbfUCf9OG/vsJYlf47JWWqTw+epjgC8Be3dLJufJ8adKv6jOIIW
WSAFxdPXQKW3dsVTjDuaCEaCNK0fAAsKl2oMjJPClEX2R0BL9z8=
=/GNl
-----END PGP SIGNATURE-----

--7IT3T4tENIWZaas+--
