Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5643634BEEC
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhC1UmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:42:06 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37108 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC1Ulf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:41:35 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcE2-0001wK-Ep; Sun, 28 Mar 2021 22:41:34 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcE1-003Gbq-MA; Sun, 28 Mar 2021 22:41:33 +0200
Date:   Sun, 28 Mar 2021 22:41:33 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 02/13] futex,rt_mutex: Introduce rt_mutex_init_waiter()
Message-ID: <YGDp/WL8DllYuErc@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ygxPSHfLjPjYcE3b"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ygxPSHfLjPjYcE3b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 50809358dd7199aa7ce232f6877dd09ec30ef374 upstream.

Since there's already two copies of this code, introduce a helper now
before adding a third one.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.950039479@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c                  |  5 +----
 kernel/locking/rtmutex.c        | 12 +++++++++---
 kernel/locking/rtmutex_common.h |  1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e112a9d4c84f..cd8a9abadd69 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3234,10 +3234,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, =
unsigned int flags,
 	 * The waiter is allocated on our stack, manipulated by the requeue
 	 * code while we sleep on uaddr.
 	 */
-	debug_rt_mutex_init_waiter(&rt_waiter);
-	RB_CLEAR_NODE(&rt_waiter.pi_tree_entry);
-	RB_CLEAR_NODE(&rt_waiter.tree_entry);
-	rt_waiter.task =3D NULL;
+	rt_mutex_init_waiter(&rt_waiter);
=20
 	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret !=3D 0))
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 6ff4156b3929..873c8c800e00 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1176,6 +1176,14 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 				   next_lock, NULL, task);
 }
=20
+void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
+{
+	debug_rt_mutex_init_waiter(waiter);
+	RB_CLEAR_NODE(&waiter->pi_tree_entry);
+	RB_CLEAR_NODE(&waiter->tree_entry);
+	waiter->task =3D NULL;
+}
+
 /**
  * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
  * @lock:		 the rt_mutex to take
@@ -1258,9 +1266,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	unsigned long flags;
 	int ret =3D 0;
=20
-	debug_rt_mutex_init_waiter(&waiter);
-	RB_CLEAR_NODE(&waiter.pi_tree_entry);
-	RB_CLEAR_NODE(&waiter.tree_entry);
+	rt_mutex_init_waiter(&waiter);
=20
 	/*
 	 * Technically we could use raw_spin_[un]lock_irq() here, but this can
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_commo=
n.h
index bea5d677fe34..ba465c0192f3 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -103,6 +103,7 @@ extern struct task_struct *rt_mutex_next_owner(struct r=
t_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
+extern void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
 				     struct task_struct *task);


--ygxPSHfLjPjYcE3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6f0ACgkQ57/I7JWG
EQlItxAAlw+xWph9i5WoQrCE0FBMd+BOLaI1R1Ecl3ctelbv2Dmflmu9HGTFVuAX
u+h+pfn3SqQ7DoZ6oAW8Qy3H2Rd6aF+XCryLzZx/skSGcQl3N5NIHu624VDmOlSN
Mj8wL46F8jHcSa+trnnaEgoLMVY+7evyiwJeOtgaEDMQtBaeyUjtuz3aN5foIvNl
GQ3y3aoYrO3n2I08ADB1nyoTwybs8A0KvebCVdXqE+mxW4uNTq08TOKqNRWYSwqz
ubP/jXUL1+r5eTqS8U9FnGnhxB8f4/4m9LZoeC4P4QsATMrhkMG/mFAoGNajGzCy
wP1bQ03vtc1GrdX6H8Fd6RgwFmbRXS3zDB8OnwnBINBBaHwLDJFjSCEBkqIFCM23
ytNLwpluRsJwHcjs6t3a4WdU7+8mNtjumy7si19BXBAHrHqh0ZanRbcWjCk5Jm+o
zcOcN0gbsziHpDVIgWV4GyScD7UWwz/U4XNg6seonFEuTdm1/LIwE5fLyNNMp3ZE
SNR6edL5cS4EXlUhJNlA7Us1n6thgSiDRf6AJewmWtWO2mv/8tTeuUfrCQ7Nt7Tv
NSckw4WomskpZdHrIO/NTlqdkpF4u+dgqxezLqR++3YTKegv5IpswbEAZ7IV5HP6
lRUooNjXPZNGuu7TVPdJN4ewQ3NoSM4h6Tl8uOvq1MalsWXbHlk=
=cKrh
-----END PGP SIGNATURE-----

--ygxPSHfLjPjYcE3b--
