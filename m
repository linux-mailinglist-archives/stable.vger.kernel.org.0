Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8994328867
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbhCARjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:39:23 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32830 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbhCARcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:32:11 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOB-0002a7-RB; Mon, 01 Mar 2021 18:31:23 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOA-004iVk-V4; Mon, 01 Mar 2021 18:31:22 +0100
Date:   Mon, 1 Mar 2021 18:31:22 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 2/7] futex: Cleanup refcounting
Message-ID: <YD0k6ppZS2lYYEqg@decadent.org.uk>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="htQQ9p95jnpF77Vh"
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--htQQ9p95jnpF77Vh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit bf92cf3a5100f5a0d5f9834787b130159397cb22 upstream.

Add a put_pit_state() as counterpart for get_pi_state() so the refcounting
becomes consistent.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.801778516@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 1cb5064548d6..bf410a4fab71 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -827,7 +827,7 @@ static int refill_pi_state_cache(void)
 	return 0;
 }
=20
-static struct futex_pi_state * alloc_pi_state(void)
+static struct futex_pi_state *alloc_pi_state(void)
 {
 	struct futex_pi_state *pi_state =3D current->pi_state_cache;
=20
@@ -860,6 +860,11 @@ static void pi_state_update_owner(struct futex_pi_stat=
e *pi_state,
 	}
 }
=20
+static void get_pi_state(struct futex_pi_state *pi_state)
+{
+	WARN_ON_ONCE(!atomic_inc_not_zero(&pi_state->refcount));
+}
+
 /*
  * Drops a reference to the pi_state object and frees or caches it
  * when the last reference is gone.
@@ -901,7 +906,7 @@ static void put_pi_state(struct futex_pi_state *pi_stat=
e)
  * Look up the task based on what TID userspace gave us.
  * We dont trust it.
  */
-static struct task_struct * futex_find_get_task(pid_t pid)
+static struct task_struct *futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
=20
@@ -1149,7 +1154,7 @@ static int attach_to_pi_state(u32 __user *uaddr, u32 =
uval,
 		goto out_einval;
=20
 out_attach:
-	atomic_inc(&pi_state->refcount);
+	get_pi_state(pi_state);
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	*ps =3D pi_state;
 	return 0;
@@ -2210,7 +2215,7 @@ static int futex_requeue(u32 __user *uaddr1, unsigned=
 int flags,
 			 * refcount on the pi_state and store the pointer in
 			 * the futex_q object of the waiter.
 			 */
-			atomic_inc(&pi_state->refcount);
+			get_pi_state(pi_state);
 			this->pi_state =3D pi_state;
 			ret =3D rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,


--htQQ9p95jnpF77Vh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JOoACgkQ57/I7JWG
EQmbvhAAhqh1OCHFB8oeyHVD3J84lub6QAXgSHt2igkne5ljto6xkOfqJCyRd1WS
ucUEdc1DTNQxiyGFxTF18ItCIFu1uXXvmAeBzk6B/PI/f0r0ZrGaASU2czSO8iLP
hrzvPJc9dH5GH31pl0tjTo6mNtzBCliTbtgdliziKJZJaKPia1zYvEX5YiZD0rVH
leVKkbr/S5xdw2fNRmbJZLtGF1TgP18v6ENHvYZwfm8RUsIfZ39JxVQN0T3c4mml
3kccEqM1DJWhPrUFd++jA7QZCnjRGCxws221S7F5NFgb4YEHDlamXWRL5qgohnOR
pZVaV8wJcmmOhCvTUxmB0XmVOujMmdHblWTGbqab/I54N1oP74KCW2VTmj6grLRg
a73EKUukiX0zUyt9ex4++Q8fwYxm3la6/pSt7Ov9Z+1AqihrYF95irSxhn0+tNIp
+8szxa3hdkrDm4TIbOC4Oy+azy+eAZkFAVX5n8uS/Jeu0+UlF+KO6dZFAHVDWitU
S4OlNEzCm5jjcXYD6ZYAlN+n3KXwnDxPsNADjA+tY3L/4n93pOxeKN5TGUvsKuhr
IBY/Foh3iBAlXdm3s3lMegT2qZiaLLAOj3ZEitlarcZfBUsDBtKBu9yCidbIWzqp
clzbG5MCWaIDelNvhUifBsmN5dMExdE1YLfVhgmFl26kyBdIicU=
=/aht
-----END PGP SIGNATURE-----

--htQQ9p95jnpF77Vh--
