Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA73634BEED
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhC1UmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:42:07 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37134 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhC1UmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:42:03 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcEU-0001ww-9R; Sun, 28 Mar 2021 22:42:02 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcES-003GeO-OR; Sun, 28 Mar 2021 22:42:00 +0200
Date:   Sun, 28 Mar 2021 22:42:00 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 05/13] futex: Avoid freeing an active timer
Message-ID: <YGDqGB/tmAa2cjOz@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BRdWqkqTeC5733u2"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BRdWqkqTeC5733u2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Thomas Gleixner <tglx@linutronix.de>

commit 97181f9bd57405b879403763284537e27d46963d upstream.

Alexander reported a hrtimer debug_object splat:

  ODEBUG: free active (active state 0) object type: hrtimer hint: hrtimer_w=
akeup (kernel/time/hrtimer.c:1423)

  debug_object_free (lib/debugobjects.c:603)
  destroy_hrtimer_on_stack (kernel/time/hrtimer.c:427)
  futex_lock_pi (kernel/futex.c:2740)
  do_futex (kernel/futex.c:3399)
  SyS_futex (kernel/futex.c:3447 kernel/futex.c:3415)
  do_syscall_64 (arch/x86/entry/common.c:284)
  entry_SYSCALL64_slow_path (arch/x86/entry/entry_64.S:249)

Which was caused by commit:

  cfafcd117da0 ("futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock=
()")

=2E.. losing the hrtimer_cancel() in the shuffle. Where previously the
hrtimer_cancel() was done by rt_mutex_slowlock() we now need to do it
manually.

Reported-by: Alexander Levin <alexander.levin@verizon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Fixes: cfafcd117da0 ("futex: Rework futex_lock_pi() to use rt_mutex_*_proxy=
_lock()")
Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1704101802370.2906@nanos
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 491888a89144..bd896f883ffd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3018,8 +3018,10 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned=
 int flags,
 out_put_key:
 	put_futex_key(&q.key);
 out:
-	if (to)
+	if (to) {
+		hrtimer_cancel(&to->timer);
 		destroy_hrtimer_on_stack(&to->timer);
+	}
 	return ret !=3D -EINTR ? ret : -ERESTARTNOINTR;
=20
 uaddr_faulted:


--BRdWqkqTeC5733u2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6hgACgkQ57/I7JWG
EQlURRAAnJ5VxrAnRD6vmQM7ltKy97ru5/AfrJKK6d8ltoMBGAHHkiqiYXTcdKdH
XLHfs0UkxZrXudIZWoeCNjO7iSFaISsptjt57lz1t3szWO2YSmuE6s2VKW9aVi0B
sgtODAP686UmKjVk9kGGH2WDp3jT0RayRkT6ygioPJN0nZGOiBIOqI3hzI/ZlukP
SfD4x+m/LaqbtnIVAyPg6+TLSrGENX/JboDnL3bVWt5Y/SRLdgKQB0RCI8zczKIX
D5Lkcee1vAEBv+yx7Cnw7vG8sdb/hrJg+M8dmd6+jZ+B5VaMWWWG6i3M7LAT49Pv
oUuzj9b7+CmP4V5AEAUOtOi8WLhc5OOontShnw2M1ZUeDGRtmQlWxn0QUGz6PhWY
wsPDtbbf2h6yE+Djx6OxSlaXOkeXWpZrMDC7c3gZKDohNJcGvWoHzqOK/ET9yrQa
U2xLVNjVN68hdxsntQD3mbr/9rXgCwSLwifaZBLsTSAGU56IH9PbwFmO0zhsGv7i
+HTjif/OhZvok4MJZn9Ns0QVRduSN2TZ7zvacF78qKoj6GnVNrsqvdvvrDxukE8r
2SpC4FZA0RfHC9SK9SzQnMnfQoWf49IhEh9YZjazt+DRDgSJ3W8CMSMaAnMnh7kD
uSiLOiIKkTESQC/tdXaoKSkHeRcNHecgKm0ZFR22vjF6cAEMiYs=
=NnII
-----END PGP SIGNATURE-----

--BRdWqkqTeC5733u2--
