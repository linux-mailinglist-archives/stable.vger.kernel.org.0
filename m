Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E620D56AA
	for <lists+stable@lfdr.de>; Sun, 13 Oct 2019 17:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfJMPry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Oct 2019 11:47:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46256 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfJMPry (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Oct 2019 11:47:54 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 472C580264; Sun, 13 Oct 2019 17:47:37 +0200 (CEST)
Date:   Sun, 13 Oct 2019 17:47:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Li RongQing <lirongqing@baidu.com>,
        Liang ZhiCheng <liangzhicheng@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.19 032/114] timer: Read jiffies once when forwarding
 base clk
Message-ID: <20191013154748.GG13278@amd>
References: <20191010083544.711104709@linuxfoundation.org>
 <20191010083600.488625019@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zGQnqpIoxlsbsOfg"
Content-Disposition: inline
In-Reply-To: <20191010083600.488625019@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zGQnqpIoxlsbsOfg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-10-10 10:35:39, Greg Kroah-Hartman wrote:
> From: Li RongQing <lirongqing@baidu.com>
>=20
> commit e430d802d6a3aaf61bd3ed03d9404888a29b9bf9 upstream.
>=20
> The reason is that the code in collect_expired_timers() uses jiffies
> unprotected:
>=20
>     if (next_event > jiffies)
>         base->clk =3D jiffies;
>=20
> As the compiler is allowed to reload the value base->clk can advance
> between the check and the store and in the worst case advance farther than
> next event. That causes the timer expiry to be delayed until the wheel
> pointer wraps around.
>=20
> Convert the code to use READ_ONCE()

Does it really need to use READ_ONCE? "jiffies" is already volatile,
READ_ONCE just adds another volatile...

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zGQnqpIoxlsbsOfg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2jRyQACgkQMOfwapXb+vKgrwCgrBFIRqFiK628STmDwRD+5BUm
qeoAnAxNZN5Sh0QC75vzOuKZOHTkHCc+
=daKA
-----END PGP SIGNATURE-----

--zGQnqpIoxlsbsOfg--
