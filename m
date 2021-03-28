Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8B34BEF7
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhC1Uno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:43:44 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37212 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhC1UnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:43:18 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFg-0001yt-L7; Sun, 28 Mar 2021 22:43:16 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFf-003Gk0-R2; Sun, 28 Mar 2021 22:43:15 +0200
Date:   Sun, 28 Mar 2021 22:43:15 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 13/13] futex: Handle transient "ownerless" rtmutex state
 correctly
Message-ID: <YGDqY9a/qbJKK5eC@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SP6X5spy/ddWUENP"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SP6X5spy/ddWUENP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Mike Galbraith <efault@gmx.de>

commit 9f5d1c336a10c0d24e83e40b4c1b9539f7dba627 upstream.

Gratian managed to trigger the BUG_ON(!newowner) in fixup_pi_state_owner().
This is one possible chain of events leading to this:

Task Prio       Operation
T1   120	lock(F)
T2   120	lock(F)   -> blocks (top waiter)
T3   50 (RT)	lock(F)   -> boosts T1 and blocks (new top waiter)
XX   		timeout/  -> wakes T2
		signal
T1   50		unlock(F) -> wakes T3 (rtmutex->owner =3D=3D NULL, waiter bit is s=
et)
T2   120	cleanup   -> try_to_take_mutex() fails because T3 is the top waiter
     			     and the lower priority T2 cannot steal the lock.
     			  -> fixup_pi_state_owner() sees newowner =3D=3D NULL -> BUG_ON()

The comment states that this is invalid and rt_mutex_real_owner() must
return a non NULL owner when the trylock failed, but in case of a queued
and woken up waiter rt_mutex_real_owner() =3D=3D NULL is a valid transient
state. The higher priority waiter has simply not yet managed to take over
the rtmutex.

The BUG_ON() is therefore wrong and this is just another retry condition in
fixup_pi_state_owner().

Drop the locks, so that T3 can make progress, and then try the fixup again.

Gratian provided a great analysis, traces and a reproducer. The analysis is
to the point, but it confused the hell out of that tglx dude who had to
page in all the futex horrors again. Condensed version is above.

[ tglx: Wrote comment and changelog ]

Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Reported-by: Gratian Crisan <gratian.crisan@ni.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87a6w6x7bb.fsf@ni.com
Link: https://lore.kernel.org/r/87sg9pkvf7.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a03952ffc3cb..468f39476476 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2497,10 +2497,22 @@ static int __fixup_pi_state_owner(u32 __user *uaddr=
, struct futex_q *q,
 		}
=20
 		/*
-		 * Since we just failed the trylock; there must be an owner.
+		 * The trylock just failed, so either there is an owner or
+		 * there is a higher priority waiter than this one.
 		 */
 		newowner =3D rt_mutex_owner(&pi_state->pi_mutex);
-		BUG_ON(!newowner);
+		/*
+		 * If the higher priority waiter has not yet taken over the
+		 * rtmutex then newowner is NULL. We can't return here with
+		 * that state because it's inconsistent vs. the user space
+		 * state. So drop the locks and try again. It's a valid
+		 * situation and not any different from the other retry
+		 * conditions.
+		 */
+		if (unlikely(!newowner)) {
+			err =3D -EAGAIN;
+			goto handle_err;
+		}
 	} else {
 		WARN_ON_ONCE(argowner !=3D current);
 		if (oldowner =3D=3D current) {

--SP6X5spy/ddWUENP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6mMACgkQ57/I7JWG
EQmjug/+PUiuHhoJkWqMRDiuJGG5PyKiOH05fDdl6i+noKzEIucJ8PLxzkAF+oTd
CGSvn7atF5zQC918XRARwFTLYeTlrnTu7vTgaEa+XmbkkGprqCpmntt0rC2ti8Gg
a3fU81AZmgTFFrVF96x9DcCHpGP42y3iaoUFcTcr8PDxpCc6QlTrh55HWfTPpbqA
Qxm939MIRCUMGEVuP3Tf1aPvJ+4HcaYHHOBvbUqOa67jqreOcwy53nzAkYpALMVo
CA3wBDAZ+pdWz12sNJSKk2bANBEA6oJ2I2F3nNKiJFr/WNIAB3XOVcy09Q9kioR/
lTVaemn4VGdHXLLHcXeUXDBTR+6dRt9Kcd9+zHC7ISXKTE8DUiH1zTGfI8ELubKJ
w30lfTaC20Tv5oiYKtsv1qCLmuGltKfblIssV6jgIUvAEp4FwmTwcTTMBNDhVIpS
1H8cHn67QXrJaeXf5l49OWB0Hdfm6NhOcJYjK/KaBJXp4yO+gcveJ2dI0g5JUwT6
jgoSRRoestLGptKFCS52vORxB63GLFYG3dg89+2q3ubFbf8eJFspPBcP07G3IB94
2+XxOnsB34saf2H3Q/FSpx90TzNrnG1LpPAJJf1D4YmkH9vcXgVC/CPltFFfMy0D
zrQG0QB6as7jx193RWZdypPSzRrc8LQZiR2YuhyKakF6MWboX18=
=86Ip
-----END PGP SIGNATURE-----

--SP6X5spy/ddWUENP--
