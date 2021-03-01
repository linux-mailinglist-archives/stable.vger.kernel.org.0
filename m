Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D564332887C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhCARkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:40:49 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32848 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhCARcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:32:39 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOb-0002aR-LY; Mon, 01 Mar 2021 18:31:49 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOa-004iXh-Qp; Mon, 01 Mar 2021 18:31:48 +0100
Date:   Mon, 1 Mar 2021 18:31:48 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 5/7] futex: Fix pi_state->owner serialization
Message-ID: <YD0lBD9t3Od0dgXp@decadent.org.uk>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h2jujmnZLCV9WKyD"
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h2jujmnZLCV9WKyD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit c74aef2d06a9f59cece89093eecc552933cba72a upstream.

There was a reported suspicion about a race between exit_pi_state_list()
and put_pi_state(). The same report mentioned the comment with
put_pi_state() said it should be called with hb->lock held, and it no
longer is in all places.

As it turns out, the pi_state->owner serialization is indeed broken. As per
the new rules:

  734009e96d19 ("futex: Change locking rules")

pi_state->owner should be serialized by pi_state->pi_mutex.wait_lock.
For the sites setting pi_state->owner we already hold wait_lock (where
required) but exit_pi_state_list() and put_pi_state() were not and
raced on clearing it.

Fixes: 734009e96d19 ("futex: Change locking rules")
Reported-by: Gratian Crisan <gratian.crisan@ni.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: dvhart@infradead.org
Cc: stable@vger.kernel.org
Link:
https://lkml.kernel.org/r/20170922154806.jd3ffltfk24m4o4y@hirez.programming=
=2Ekicks-ass.net
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 77cec33ea112..a07f6080c8b0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -868,8 +868,6 @@ static void get_pi_state(struct futex_pi_state *pi_stat=
e)
 /*
  * Drops a reference to the pi_state object and frees or caches it
  * when the last reference is gone.
- *
- * Must be called with the hb lock held.
  */
 static void put_pi_state(struct futex_pi_state *pi_state)
 {
@@ -884,13 +882,15 @@ static void put_pi_state(struct futex_pi_state *pi_st=
ate)
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	}
=20
-	if (current->pi_state_cache)
+	if (current->pi_state_cache) {
 		kfree(pi_state);
-	else {
+	} else {
 		/*
 		 * pi_state->list is already empty.
 		 * clear pi_state->owner.
@@ -949,13 +949,14 @@ static void exit_pi_state_list(struct task_struct *cu=
rr)
 		raw_spin_unlock_irq(&curr->pi_lock);
=20
 		spin_lock(&hb->lock);
-
-		raw_spin_lock_irq(&curr->pi_lock);
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_lock(&curr->pi_lock);
 		/*
 		 * We dropped the pi-lock, so re-check whether this
 		 * task still owns the PI-state:
 		 */
 		if (head->next !=3D next) {
+			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 			spin_unlock(&hb->lock);
 			continue;
 		}
@@ -964,9 +965,10 @@ static void exit_pi_state_list(struct task_struct *cur=
r)
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
 		pi_state->owner =3D NULL;
-		raw_spin_unlock_irq(&curr->pi_lock);
+		raw_spin_unlock(&curr->pi_lock);
=20
 		get_pi_state(pi_state);
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
=20
 		rt_mutex_futex_unlock(&pi_state->pi_mutex);
@@ -1349,6 +1351,10 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32=
 uval, union futex_key *key,
=20
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &p->pi_state_list);
+	/*
+	 * Assignment without holding pi_state->pi_mutex.wait_lock is safe
+	 * because there is no concurrency as the object is not published yet.
+	 */
 	pi_state->owner =3D p;
 	raw_spin_unlock_irq(&p->pi_lock);
=20
@@ -3027,6 +3033,7 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigne=
d int flags)
 		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
=20
+		/* drops pi_state->pi_mutex.wait_lock */
 		ret =3D wake_futex_pi(uaddr, uval, pi_state);
=20
 		put_pi_state(pi_state);


--h2jujmnZLCV9WKyD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JQQACgkQ57/I7JWG
EQlUsw/+N6H/AkSR8xESk5BwSmg9maFz7ccL5l9ltqnCYZ2Lm0wY86aPTYaLA4Bu
NeoKJHmMLxkpKtsrljvtQVNsNxbNMaAO8jKOoRN+e2xoj/1oAplYX6WgEoeXc4o4
7eeINgBMaKFjpIz7HKhbYS9QkjS2V/8j/bytwydnPcbkTzMh7/Rbdzz4T+/xxkaf
CVPXDSKmXPPwZH2uoEer98GFihENendbHNrgrR6VqxP9QZLHyCJuccezmUBMMEhB
7fr1UUEDMBqpvIUovbwrJrhCEcyczrPb2Tt1HiUQNg0zeLypb69iOA3CICxU6O38
TBKSGlTGLigdNBP83XQJc9D4bsHBUBOhrFGp71rsEmrbYoiqJwhKUR55EZpD6PzX
+aiVWzDi9anaLp+5BnoFwwWqL9sSjth3LMtZqgfKZPxJfG2nDRQEfbiPehf8NNMW
+HW5tdwwZd8yZFHSEuSs/d81M6voJuNpAO2MqcOKBiNCiXKbG650aeYjm1qG2qGZ
i0UTEr42J1v4THjYhoc0mn2oqxDX6k6/3VS6PmUE8M74PnQu2dY338CbBXO8ZB7v
AcAgVmRCmJMyDZaoQ8aujFM2PGRJEbKYCqriGT5AvhCohEzxQpVpVzmJA5FST4BL
85wRxn1/9LFnojTrVgBX9bLW/1TXz0A0u1AckE6iCmdSOW+ARlI=
=HoSk
-----END PGP SIGNATURE-----

--h2jujmnZLCV9WKyD--
