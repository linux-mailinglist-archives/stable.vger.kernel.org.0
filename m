Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7514534BEF8
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhC1Unn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:43:43 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37200 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhC1UnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:43:12 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFb-0001yY-2M; Sun, 28 Mar 2021 22:43:11 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFa-003Gji-5c; Sun, 28 Mar 2021 22:43:10 +0200
Date:   Sun, 28 Mar 2021 22:43:10 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 12/13] futex: Fix incorrect should_fail_futex() handling
Message-ID: <YGDqXlZ4Vb3r3Q8f@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="S7RbSueySYyv7cOX"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--S7RbSueySYyv7cOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Mateusz Nosek <mateusznosek0@gmail.com>

commit 921c7ebd1337d1a46783d7e15a850e12aed2eaa0 upstream.

If should_futex_fail() returns true in futex_wake_pi(), then the 'ret'
variable is set to -EFAULT and then immediately overwritten. So the failure
injection is non-functional.

Fix it by actually leaving the function and returning -EFAULT.

The Fixes tag is kinda blury because the initial commit which introduced
failure injection was already sloppy, but the below mentioned commit broke
it completely.

[ tglx: Massaged changelog ]

Fixes: 6b4f4bc9cb22 ("locking/futex: Allow low-level atomic operations to r=
eturn -EAGAIN")
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200927000858.24219-1-mateusznosek0@gmail.=
com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c55bf3511203..a03952ffc3cb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1605,8 +1605,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval=
, struct futex_pi_state *pi_
 	 */
 	newval =3D FUTEX_WAITERS | task_pid_vnr(new_owner);
=20
-	if (unlikely(should_fail_futex(true)))
+	if (unlikely(should_fail_futex(true))) {
 		ret =3D -EFAULT;
+		goto out_unlock;
+	}
=20
 	ret =3D cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
 	if (!ret && (curval !=3D uval)) {


--S7RbSueySYyv7cOX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6lkACgkQ57/I7JWG
EQlGpA//VW6JvTpMj6/+xgP5YuYgMXLoIBiKFxSYiEAwGeN+srEVJNTGBE7JGcen
9VlJ84ufdqBmpddu7crAeUu6wEjb7Os9oDvNZanTbFLMSKGyt0j624I1VAqztMsm
rUnpom1yh3+0NT8/DNxs+PPHIHTr7QfgxG+r3K/e7Mgk8eKLWBLV0WZqwX7VgEl6
s+XuU/oBWJ69pCxqzWbSzBKZILpXKKE91Ot/va2eSK8vCPbNrs5Y1HlMDvHmWmsh
JrvhSaQAW9UHTXQcZiXlvh7Y1zivFX2u+CDnoVA1PxJAWNPxeJkhWlpCJiq8zZy5
PIA12fokV4VLCQj0h8+gIrBI/B5UBgiuLTfLJ3ivkrorNz55aaADNuTL5ooRfBxe
4czSDApNliGpaDOL0uFcYg2XcwTpNFiBJ70QpJw5zNvStrE22+haL3ApsCKt+SQT
Lxp7VQsplY4DIGpbB0lzVGS+bEfcm7ZnVamVCrMl9Aw1bmqV9NfN5g/LoUFDKhS3
JYaYk4CLUa6fw/BEJboxY6iHnG3OSy1x71GGurAKZVeF9Lb7Y6FFwEGD7dWwpG6u
28rM/bdw8RVGUP+iwHhfKSmP4uxhBstPjo/8kayBeH8O5AAon51g2JOAw0TClEhj
882wl1DATvMBwCFv6FCtDLrtMFw69N9Si1akBX1umuiQTQodxpg=
=832a
-----END PGP SIGNATURE-----

--S7RbSueySYyv7cOX--
