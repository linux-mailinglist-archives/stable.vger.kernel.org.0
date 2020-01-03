Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B30F12FCD9
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 20:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgACTHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 14:07:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45188 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbgACTHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 14:07:14 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 25F3B1C2228; Fri,  3 Jan 2020 20:07:12 +0100 (CET)
Date:   Fri, 3 Jan 2020 20:07:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.19 089/114] hrtimer: Annotate lockless access to
 timer->state
Message-ID: <20200103190711.GF14328@amd>
References: <20200102220029.183913184@linuxfoundation.org>
 <20200102220038.167049649@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <20200102220038.167049649@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Dumazet <edumazet@google.com>
>=20
> commit 56144737e67329c9aaed15f942d46a6302e2e3d8 upstream.
>=20
> syzbot reported various data-race caused by hrtimer_is_queued() reading
> timer->state. A READ_ONCE() is required there to silence the warning.
>=20
> Also add the corresponding WRITE_ONCE() when timer->state is set.
>=20
> In remove_hrtimer() the hrtimer_is_queued() helper is open coded to avoid
> loading timer->state twice.

Is there a reason why READ_ONCE is not neccessary in remove_hrtimer?

Should there be comment there explaining it?

Best regards,
								Pavel

> @@ -1002,8 +1004,9 @@ static void __remove_hrtimer(struct hrti
>  static inline int
>  remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base, b=
ool restart)
>  {
> -	if (hrtimer_is_queued(timer)) {
> -		u8 state =3D timer->state;
> +	u8 state =3D timer->state;
> +
> +	if (state & HRTIMER_STATE_ENQUEUED) {
>  		int reprogram;
> =20
>  		/*
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4PkN8ACgkQMOfwapXb+vIXSgCeLWRt9/Au7H2W6ury0qy8+LDc
5WEAn140rt5mS/Pw4LJL/cm+8edXvfPz
=8tqD
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
