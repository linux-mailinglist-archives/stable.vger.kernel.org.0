Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4460E1026F2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfKSOhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:37:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46036 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbfKSOhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 09:37:36 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4dK-0004q4-De; Tue, 19 Nov 2019 14:37:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4dK-0001P3-1N; Tue, 19 Nov 2019 14:37:34 +0000
Message-ID: <43b375712cdd400695af9e4e8e4a9381706601fc.camel@decadent.org.uk>
Subject: Re: [PATCH v3.16] alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Petr Vorel <pvorel@suse.cz>, stable@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Tue, 19 Nov 2019 14:37:27 +0000
In-Reply-To: <20191108155411.13306-1-pvorel@suse.cz>
References: <20191108155411.13306-1-pvorel@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Nx1FY5pq+xbmbZrm/SLI"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Nx1FY5pq+xbmbZrm/SLI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-11-08 at 16:54 +0100, Petr Vorel wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>=20
> ENOTSUPP is not supposed to be returned to userspace. This was found on a=
n
> OpenPower machine, where the RTC does not support set_alarm.
>=20
> On that system, a clock_nanosleep(CLOCK_REALTIME_ALARM, ...) results in
> "524 Unknown error 524"
>=20
> Replace it with EOPNOTSUPP which results in the expected "95 Operation no=
t
> supported" error.
>=20
> Fixes: 1c6b39ad3f01 (alarmtimers: Return -ENOTSUPP if no RTC device is pr=
esent)
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [ pvorel: backport for v3.16, changes also in alarm_timer_{del,set}(), wh=
ich
> were removed in f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1 ]
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> Cc: stable@vger.kernel.org # v3.16
> Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Link: https://lkml.kernel.org/r/20190903171802.28314-1-cascardo@canonical=
.com

I've queued this up, thanks.  In future please remember to include the
upstream commit hash.

Ben.

> ---
>  kernel/time/alarmtimer.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index 8c65c236f26a..c3fc69986850 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -533,7 +533,7 @@ static int alarm_timer_create(struct k_itimer *new_ti=
mer)
>  	struct alarm_base *base;
> =20
>  	if (!alarmtimer_get_rtcdev())
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
> =20
>  	if (!capable(CAP_WAKE_ALARM))
>  		return -EPERM;
> @@ -576,7 +576,7 @@ static void alarm_timer_get(struct k_itimer *timr,
>  static int alarm_timer_del(struct k_itimer *timr)
>  {
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
> =20
>  	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
>  		return TIMER_RETRY;
> @@ -600,7 +600,7 @@ static int alarm_timer_set(struct k_itimer *timr, int=
 flags,
>  	ktime_t exp;
> =20
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
> =20
>  	if (flags & ~TIMER_ABSTIME)
>  		return -EINVAL;
> @@ -761,7 +761,7 @@ static int alarm_timer_nsleep(const clockid_t which_c=
lock, int flags,
>  	struct restart_block *restart;
> =20
>  	if (!alarmtimer_get_rtcdev())
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
> =20
>  	if (flags & ~TIMER_ABSTIME)
>  		return -EINVAL;
--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-Nx1FY5pq+xbmbZrm/SLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3T/igACgkQ57/I7JWG
EQmN7A//X/sXg2cTL0j2Ot19J5MK3rX2bZaKud0kEkANGAeAtRb8N1KQShZ9x+W8
+ogNIChLdJCBestHh+izGrzOW0rcyaU10SNbDVUWfz6hW80PU2mVea0cnok+TOdc
3s1OwcTtJHRLRqoara/jZMZhYPmQrFkJRSsAy9r+uhpBkrPLVgAU2LTSdwktasWs
z+kVTno4NLCV7mSYMDjpaYVL2GuQDYt2BLM6IVoC78pcwZaiT37DAyvVWg0KrLM5
QvURQppcMvbGvgui8E0Em+1ysCPR1e2+81wEq4ezZUqfbkaf4LdJJR8FZ899SBlM
r+LcgXgtkp7+NTYzk997EzTN27Rld2K+LiMq68cL+NPDXREZ8NpJY0xm2PK6T5g+
Wm8PlD6M4Ir7HVH0V6XfRTFRNNqNGiDdhjWysO+wWhZCwUcqJcabmSErCsyXKINF
heThgbmHzg/D2Q4jO4H6qVPNIXJHXiFKf39AwB2urssqqjxIpwkXt0OPDv+XLs1N
bofax6xzZYQ5LkDc12C4DIKzTewSf3YRdVsStsLFDs4DNg99iVxxUyNwWLC0/nfe
HeZnnOw15/MK4ZFyzmw5lySJ/5dxsKi/1nMZcdr7PyQIDGe7eF2zSMOizhqsn5GL
tTLHUyXf6uUXBpDC0TjUuCWwP5g9JOpkh51XUWBcr58hjJkehtY=
=mN9L
-----END PGP SIGNATURE-----

--=-Nx1FY5pq+xbmbZrm/SLI--
