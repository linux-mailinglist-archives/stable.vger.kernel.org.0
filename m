Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C110DD60
	for <lists+stable@lfdr.de>; Sat, 30 Nov 2019 11:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfK3K2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Nov 2019 05:28:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39984 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfK3K2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Nov 2019 05:28:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B2AFF1C2566; Sat, 30 Nov 2019 11:28:04 +0100 (CET)
Date:   Sat, 30 Nov 2019 11:28:04 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 030/306] synclink_gt(): fix compat_ioctl()
Message-ID: <20191130102804.GA27380@duo.ucw.cz>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203116.924730296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20191127203116.924730296@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Al Viro <viro@zeniv.linux.org.uk>
>=20
> [ Upstream commit 27230e51349fde075598c1b59d15e1ff802f3f6e ]
>=20
> compat_ptr() for pointer-taking ones...
>=20
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> +++ b/drivers/tty/synclink_gt.c
> @@ -1186,14 +1186,13 @@ static long slgt_compat_ioctl(struct tty_struct *=
tty,
>  			 unsigned int cmd, unsigned long arg)
>  {
>  	struct slgt_info *info =3D tty->driver_data;
> -	int rc =3D -ENOIOCTLCMD;
> +	int rc;
> =20
>  	if (sanity_check(info, tty->name, "compat_ioctl"))
>  		return -ENODEV;
>  	DBGINFO(("%s compat_ioctl() cmd=3D%08X\n", info->device_name, cmd));
> =20
>  	switch (cmd) {
> -
>  	case MGSL_IOCSPARAMS32:
>  		rc =3D set_params32(info, compat_ptr(arg));
>  		break;
> @@ -1213,18 +1212,11 @@ static long slgt_compat_ioctl(struct tty_struct *=
tty,
>  	case MGSL_IOCWAITGPIO:
>  	case MGSL_IOCGXSYNC:
>  	case MGSL_IOCGXCTRL:
> -	case MGSL_IOCSTXIDLE:
> -	case MGSL_IOCTXENABLE:
> -	case MGSL_IOCRXENABLE:
> -	case MGSL_IOCTXABORT:
> -	case TIOCMIWAIT:
> -	case MGSL_IOCSIF:
> -	case MGSL_IOCSXSYNC:
> -	case MGSL_IOCSXCTRL:
> -		rc =3D ioctl(tty, cmd, arg);
> +		rc =3D ioctl(tty, cmd, (unsigned long)compat_ptr(arg));
>  		break;
> +	default:
> +		rc =3D ioctl(tty, cmd, arg);
>  	}

Ok, so this used to only pass select calls to ioctl() and now it
passes everything thanks to default: marking. I guess that's suitable
for mainline, but is it also suitable for -stable?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXeJENAAKCRAw5/Bqldv6
8lAmAKC3P9bd/9OUYHd8vx2WoqPxYOetnACdGo+Jm0+fwwF1UP5zdcy8M2a54+k=
=Vs55
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
