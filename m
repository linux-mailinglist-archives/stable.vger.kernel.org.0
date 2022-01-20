Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9AD494B98
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 11:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbiATK0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 05:26:03 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52624 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiATK0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 05:26:03 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E9F0F1C0B9D; Thu, 20 Jan 2022 11:26:01 +0100 (CET)
Date:   Thu, 20 Jan 2022 11:26:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        rkardell@mida.se, mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 11/29] media: m920x: don't use stack on USB
 reads
Message-ID: <20220120102601.GB14998@amd>
References: <20220118030822.1955469-1-sashal@kernel.org>
 <20220118030822.1955469-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20220118030822.1955469-11-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>=20
> [ Upstream commit a2ab06d7c4d6bfd0b545a768247a70463e977e27 ]
>=20
> Using stack-allocated pointers for USB message data don't work.
> This driver is almost OK with that, except for the I2C read
> logic.
>=20
> Fix it by using a temporary read buffer, just like on all other
> calls to m920x_read().

This introduces memory leak... and I don't believe it really fixes the
problem.

> index eafc5c82467f4..5b806779e2106 100644
> --- a/drivers/media/usb/dvb-usb/m920x.c
> +++ b/drivers/media/usb/dvb-usb/m920x.c
> @@ -284,6 +284,13 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, =
struct i2c_msg msg[], int nu
>  			/* Should check for ack here, if we knew how. */
>  		}
>  		if (msg[i].flags & I2C_M_RD) {
> +			char *read =3D kmalloc(1, GFP_KERNEL);
> +			if (!read) {
> +				ret =3D -ENOMEM;
> +				kfree(read);
> +				goto unlock;
> +			}

kfree(NULL);

>  			for (j =3D 0; j < msg[i].len; j++) {
>  				/* Last byte of transaction?
>  				 * Send STOP, otherwise send ACK. */
> @@ -291,9 +298,12 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, =
struct i2c_msg msg[], int nu
> =20
>  				if ((ret =3D m920x_read(d->udev, M9206_I2C, 0x0,
>  						      0x20 | stop,
> -						      &msg[i].buf[j], 1)) !=3D 0)
> +						      read, 1)) !=3D 0)
>  					goto unlock;

Memory leak of read.

> +				msg[i].buf[j] =3D read[0];
>  			}
> +
> +			kfree(read);
>  		} else {
>  			for (j =3D 0; j < msg[i].len; j++) {
>  				/* Last byte of transaction? Then send STOP. */

But more importantly, do we have exact copy of the read problem just
below, during write?

Best regards,
								Pavel

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/=
m920x.c
index 691e05833db1..e5ee54324a28 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -250,7 +250,7 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, str=
uct i2c_msg msg[], int nu
 {
 	struct dvb_usb_device *d =3D i2c_get_adapdata(adap);
 	int i, j;
-	int ret =3D 0;
+	int ret;
=20
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -277,7 +277,6 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, str=
uct i2c_msg msg[], int nu
 			char *read =3D kmalloc(1, GFP_KERNEL);
 			if (!read) {
 				ret =3D -ENOMEM;
-				kfree(read);
 				goto unlock;
 			}
=20
@@ -288,8 +287,10 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, st=
ruct i2c_msg msg[], int nu
=20
 				if ((ret =3D m920x_read(d->udev, M9206_I2C, 0x0,
 						      0x20 | stop,
-						      read, 1)) !=3D 0)
+						      read, 1)) !=3D 0) {
+					kfree(read);
 					goto unlock;
+				}
 				msg[i].buf[j] =3D read[0];
 			}
=20


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHpOLkACgkQMOfwapXb+vK1tACgmHbcATCI8NZGWJcnrMDiyHwQ
TA8AoLPVH8buRwXyQ01lJbmwGygSUpZW
=0cJZ
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
