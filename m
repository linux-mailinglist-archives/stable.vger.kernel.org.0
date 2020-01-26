Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A03149A11
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 11:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgAZK0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 05:26:38 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48588 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbgAZK0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 05:26:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AEBE51C228F; Sun, 26 Jan 2020 11:26:35 +0100 (CET)
Date:   Sun, 26 Jan 2020 11:26:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 521/639] rtc: pcf2127: bugfix: read rtc disables
 watchdog
Message-ID: <20200126102634.GA19082@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093154.044998307@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20200124093154.044998307@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-01-24 10:31:31, Greg Kroah-Hartman wrote:
> From: Bruno Thomsen <bruno.thomsen@gmail.com>
>=20
> [ Upstream commit 7f43020e3bdb63d65661ed377682702f8b34d3ea ]
>=20
> The previous fix listed bulk read of registers as root cause of
> accendential disabling of watchdog, since the watchdog counter
> register (WD_VAL) was zeroed.
>=20
> Fixes: 3769a375ab83 rtc: pcf2127: bulk read only date and time registers.
>=20
> Tested with the same PCF2127 chip as Sean reveled root cause
> of WD_VAL register value zeroing was caused by reading CTRL2
> register which is one of the watchdog feature control registers.
>=20
> So the solution is to not read the first two control registers
> (CTRL1 and CTRL2) in pcf2127_rtc_read_time as they are not
> needed anyway. Size of local buf variable is kept to allow
> easy usage of register defines to improve readability of code.

Should the array be zeroed before or something? This way, one array
contains both undefined values and valid data...

> Debug trace line was updated after CTRL1 and CTRL2 are no longer
> read from the chip. Also replaced magic numbers in buf access
> with register defines.

That part is not an improvement. Previously the code was formatted so
that you could parse what is being printed.

Best regards,							Pavel

> @@ -91,14 +85,12 @@ static int pcf2127_rtc_read_time(struct device *dev, =
struct rtc_time *tm)
>  	}
> =20
>  	dev_dbg(dev,
> -		"%s: raw data is cr1=3D%02x, cr2=3D%02x, cr3=3D%02x, "
> -		"sec=3D%02x, min=3D%02x, hr=3D%02x, "
> +		"%s: raw data is cr3=3D%02x, sec=3D%02x, min=3D%02x, hr=3D%02x, "
>  		"mday=3D%02x, wday=3D%02x, mon=3D%02x, year=3D%02x\n",
> -		__func__,
> -		buf[0], buf[1], buf[2],
> -		buf[3], buf[4], buf[5],
> -		buf[6], buf[7], buf[8], buf[9]);
> -
> +		__func__, buf[PCF2127_REG_CTRL3], buf[PCF2127_REG_SC],
> +		buf[PCF2127_REG_MN], buf[PCF2127_REG_HR],
> +		buf[PCF2127_REG_DM], buf[PCF2127_REG_DW],
> +		buf[PCF2127_REG_MO], buf[PCF2127_REG_YR]);
> =20
>  	tm->tm_sec =3D bcd2bin(buf[PCF2127_REG_SC] & 0x7F);
>  	tm->tm_min =3D bcd2bin(buf[PCF2127_REG_MN] & 0x7F);
> --=20
> 2.20.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXi1pWgAKCRAw5/Bqldv6
8lXvAKCuBbJsd+Ad8O49Zkovk64+OagFnACfXDkYo06jdIlgrJvug0hvl1dpMuo=
=GfFi
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
