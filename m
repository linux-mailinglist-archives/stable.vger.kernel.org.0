Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5265432887D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhCARlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:41:00 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32858 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbhCARco (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:32:44 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOi-0002ae-Sy; Mon, 01 Mar 2021 18:31:56 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOh-004iYH-Rj; Mon, 01 Mar 2021 18:31:55 +0100
Date:   Mon, 1 Mar 2021 18:31:55 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 6/7] futex: Fix more put_pi_state() vs.
 exit_pi_state_list() races
Message-ID: <YD0lC+fuTMO3BKSw@decadent.org.uk>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jC4dLnQ1ze8GylN6"
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jC4dLnQ1ze8GylN6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 153fbd1226fb30b8630802aa5047b8af5ef53c9f upstream.

Dmitry (through syzbot) reported being able to trigger the WARN in
get_pi_state() and a use-after-free on:

	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);

Both are due to this race:

  exit_pi_state_list()				put_pi_state()

  lock(&curr->pi_lock)
  while() {
	pi_state =3D list_first_entry(head);
	hb =3D hash_futex(&pi_state->key);
	unlock(&curr->pi_lock);

						dec_and_test(&pi_state->refcount);

	lock(&hb->lock)
	lock(&pi_state->pi_mutex.wait_lock)	// uaf if pi_state free'd
	lock(&curr->pi_lock);

	....

	unlock(&curr->pi_lock);
	get_pi_state();				// WARN; refcount=3D=3D0

The problem is we take the reference count too late, and don't allow it
being 0. Fix it by using inc_not_zero() and simply retrying the loop
when we fail to get a refcount. In that case put_pi_state() should
remove the entry from the list.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Gratian Crisan <gratian.crisan@ni.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: dvhart@infradead.org
Cc: syzbot <bot+2af19c9e1ffe4d4ee1d16c56ae7580feaee75765@syzkaller.appspotm=
ail.com>
Cc: syzkaller-bugs@googlegroups.com
Cc: <stable@vger.kernel.org>
Fixes: c74aef2d06a9 ("futex: Fix pi_state->owner serialization")
Link: http://lkml.kernel.org/r/20171031101853.xpfh72y643kdfhjs@hirez.progra=
mming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a07f6080c8b0..855dae277f83 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -941,11 +941,27 @@ static void exit_pi_state_list(struct task_struct *cu=
rr)
 	 */
 	raw_spin_lock_irq(&curr->pi_lock);
 	while (!list_empty(head)) {
-
 		next =3D head->next;
 		pi_state =3D list_entry(next, struct futex_pi_state, list);
 		key =3D pi_state->key;
 		hb =3D hash_futex(&key);
+
+		/*
+		 * We can race against put_pi_state() removing itself from the
+		 * list (a waiter going away). put_pi_state() will first
+		 * decrement the reference count and then modify the list, so
+		 * its possible to see the list entry but fail this reference
+		 * acquire.
+		 *
+		 * In that case; drop the locks to let put_pi_state() make
+		 * progress and retry the loop.
+		 */
+		if (!atomic_inc_not_zero(&pi_state->refcount)) {
+			raw_spin_unlock_irq(&curr->pi_lock);
+			cpu_relax();
+			raw_spin_lock_irq(&curr->pi_lock);
+			continue;
+		}
 		raw_spin_unlock_irq(&curr->pi_lock);
=20
 		spin_lock(&hb->lock);
@@ -956,8 +972,10 @@ static void exit_pi_state_list(struct task_struct *cur=
r)
 		 * task still owns the PI-state:
 		 */
 		if (head->next !=3D next) {
+			/* retain curr->pi_lock for the loop invariant */
 			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 			spin_unlock(&hb->lock);
+			put_pi_state(pi_state);
 			continue;
 		}
=20
@@ -965,9 +983,8 @@ static void exit_pi_state_list(struct task_struct *curr)
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
 		pi_state->owner =3D NULL;
-		raw_spin_unlock(&curr->pi_lock);
=20
-		get_pi_state(pi_state);
+		raw_spin_unlock(&curr->pi_lock);
 		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
=20


--jC4dLnQ1ze8GylN6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JQsACgkQ57/I7JWG
EQkkxRAAutJTNSJzCXIYfuHo4hGsABgfd/BXyayJGC8ZM/1Q35qQP7485+LcffI1
UC7cnASD6oUcGVKfgg8y4e2jiO312PfaLUXbW+Bh0Tnjuk8r4856eDtUdppTHNac
5iH8iCgom+aCs7F3LwCbC1SNLLG9Si7rCE9hkla8RQs3mnWO+unaCJc7SRVSfdXq
bHAoW7+TLuV3Fpi8FjHVbbXBMP9nh/JNZyXfeEdREpqTpgqhqpOlCZHXycZHaRdh
dcZFeyZp4JF3c181U8Q/dklBQowkOl9/QALJVf6W+Lr08owTRNY67oUK+tZWnPvl
MIWfWdU23vZ3RdG8M3xb1nxDy/A51pSNDrdWknbnOH+uPs7fQZ6gGnSg0UOkEaaY
TNZEyEdGpDz3wYfql7UScKsZ9yI/LKCEoytEz7chtP5nWzvex1hwo82vvJHK59V0
0RsoWK/NV1+SiEw/PTVWDsL9zk6LwJAMPn1gkj39vymUgmhpzRrL1QIVeh0Gs9Ou
mweR0f5D8eLAcWBmOduJHR7wtPhpgFh8yNwTAKt5gd05cATDuio6+QJ+GyfCls5B
II959U/wTngupQNtZnAWc1cXtO0HYNl1oqMqMWmVUiU64uSJvyDmblpGrQCCK35z
gXUqRMpRO4iIQyHo9wcK6L2y05BJ6QKdEXAkDGru70/aidQjIFI=
=Wkzr
-----END PGP SIGNATURE-----

--jC4dLnQ1ze8GylN6--
