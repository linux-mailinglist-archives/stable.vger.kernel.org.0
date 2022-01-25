Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE45149BBF9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiAYTVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:21:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50250 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiAYTUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:20:43 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 064A61C0B88; Tue, 25 Jan 2022 20:20:39 +0100 (CET)
Date:   Tue, 25 Jan 2022 20:20:38 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        rkardell@mida.se,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 066/114] media: m920x: dont use stack on USB reads
Message-ID: <20220125192038.GB5395@duo.ucw.cz>
References: <20220124183927.095545464@linuxfoundation.org>
 <20220124183929.139516454@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20220124183929.139516454@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1LKvkjL3sHcu1TtY
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

Maybe the driver is buggy, but the fix is not okay.

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

kfree(NULL). You probably did not want to do that.

> +				goto unlock;
> +			}
> +
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

Memory leak here.

> +				msg[i].buf[j] =3D read[0];
>  			}
> +
> +			kfree(read);
>  		} else {
>  			for (j =3D 0; j < msg[i].len; j++) {
>  				/* Last byte of transaction? Then send STOP. */

Plus really running malloc in a loop like that looks strange.

Anyway, this should stop the leaks.

Best regards,
									Pavel

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/=
m920x.c
index 691e05833db1..da81fa189b5d 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
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

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfBNhgAKCRAw5/Bqldv6
8t7LAJoDhqGxBvYonwdoJn/5f2zVgq8lOACgt6NRIlXWvC7bZ4FmODlxwjEKzoQ=
=3Hof
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
