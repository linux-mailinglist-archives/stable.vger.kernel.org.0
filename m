Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF834BEEB
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhC1UlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:41:02 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37098 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC1Uk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:40:56 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcDP-0001w4-MR; Sun, 28 Mar 2021 22:40:55 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcDO-003GZt-Ue; Sun, 28 Mar 2021 22:40:54 +0200
Date:   Sun, 28 Mar 2021 22:40:54 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 01/13] futex: Use smp_store_release() in mark_wake_futex()
Message-ID: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Q5NbVCB82Ekm7uuL"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q5NbVCB82Ekm7uuL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

commit 1b367ece0d7e696cab1c8501bab282cc6a538b3f upstream.

Since the futex_q can dissapear the instruction after assigning NULL,
this really should be a RELEASE barrier. That stops loads from hitting
dead memory too.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.604296452@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 796b1c860839..e112a9d4c84f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1565,8 +1565,7 @@ static void mark_wake_futex(struct wake_q_head *wake_=
q, struct futex_q *q)
 	 * memory barrier is required here to prevent the following
 	 * store to lock_ptr from getting ahead of the plist_del.
 	 */
-	smp_wmb();
-	q->lock_ptr =3D NULL;
+	smp_store_release(&q->lock_ptr, NULL);
 }
=20
 /*


--Q5NbVCB82Ekm7uuL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6dYACgkQ57/I7JWG
EQmcAxAAhvYXwZMjH93SO06Z7nyRUfu72eES3OQvO0d/81zKFpYoCLeVir+h68k5
8PgssV6xhRLVNNmLK6AVHLs0YTMyXJ8Dhz6/6XGdwUAdqwK+ycDEJe8mkLp+gAIz
hUoOoDexn5S1/peLgEJQxd02UtG6ABxuZMREJwrlzms2RAZOSawh/fuKN9ujIyYE
lwIVSStObnjJK5woeWb/r8NaPGu7AOV2RR3TdQGOZubkKi5sNqs21zw9ARbocKcY
COLlAu7APn0ENH6mNPIoYM+MmTLMngQrQrYnogY0yJLXKXiM9BNtILvaVsLnbSVy
NtTnBFgMxVgnd72CjQq0dEBepYncgyxeE8/fscJCK0xaUHOaUY49QlnYWv5RcJjA
N0ZY4cvd3HvQq3AE/2Y/5z26GfJPJCswM0o/Lhm4MacqNcR8h5lBurMfrtt/V2DG
xdkengc0JwmneDDS9npCSTxFaOENcKHTSzxbmLFpRBZegVJJwqIbSdS1Oo7FqBfA
xTLaXdLKXclw+7kK5E1IqPHfBKKTSpAbn8pcSHivxLIYWvj5JGSz2ZEU1w3z/IKC
Y1HiuPKnKAiqDOtthavfxOMy/NBRK8JYHulN+ARgk8pyhQqNeh9nvI+l6Qv8RpNj
st19Gh8uzPytT6JSGZZKynUsw8MB5yEIIum/eHiHiHlkZS+Fn3Y=
=YzZ2
-----END PGP SIGNATURE-----

--Q5NbVCB82Ekm7uuL--
