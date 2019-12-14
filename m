Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBD611F38D
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfLNSop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 13:44:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47372 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfLNSop (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 13:44:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1igCPC-0003pB-Ts; Sat, 14 Dec 2019 18:44:42 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1igCPC-0007pG-GJ; Sat, 14 Dec 2019 18:44:42 +0000
Message-ID: <48f5d55352e57e85925e98741331725109369476.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 04/72] leds: leds-lp5562 allow firmware files up to
 the maximum length
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Nick Stoughton <nstoughton@logitech.com>
Date:   Sat, 14 Dec 2019 18:44:37 +0000
In-Reply-To: <20191214083755.GA16834@duo.ucw.cz>
References: <lsq.1575813164.154362148@decadent.org.uk>
         <lsq.1575813165.827469937@decadent.org.uk>
         <20191214083755.GA16834@duo.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-8JBTCm4n1ufoD71qgRks"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-8JBTCm4n1ufoD71qgRks
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-12-14 at 09:37 +0100, Pavel Machek wrote:
> On Sun 2019-12-08 13:52:48, Ben Hutchings wrote:
> > 3.16.79-rc1 review patch.  If anyone has any objections, please let
> > me know.
>=20
> Nobody is hitting this one and noone cares. Not a serious bug as
> described in stable rules.
>=20
> I'd recommend dropping.

This has already been included in 3.16.79 (and updates for other stable
branches), so unless it causes a problem I don't intend to revert it.

Ben.

> > ------------------
> >=20
> > From: Nick Stoughton <nstoughton@logitech.com>
> >=20
> > commit ed2abfebb041473092b41527903f93390d38afa7 upstream.
> >=20
> > Firmware files are in ASCII, using 2 hex characters per byte. The
> > maximum length of a firmware string is therefore
> >=20
> > 16 (commands) * 2 (bytes per command) * 2 (characters per byte) =3D 64
> >=20
> > Fixes: ff45262a85db ("leds: add new LP5562 LED driver")
> > Signed-off-by: Nick Stoughton <nstoughton@logitech.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/leds/leds-lp5562.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > --- a/drivers/leds/leds-lp5562.c
> > +++ b/drivers/leds/leds-lp5562.c
> > @@ -263,7 +263,11 @@ static void lp5562_firmware_loaded(struc
> >  {
> >  	const struct firmware *fw =3D chip->fw;
> > =20
> > -	if (fw->size > LP5562_PROGRAM_LENGTH) {
> > +	/*
> > +	 * the firmware is encoded in ascii hex character, with 2 chars
> > +	 * per byte
> > +	 */
> > +	if (fw->size > (LP5562_PROGRAM_LENGTH * 2)) {
> >  		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
> >  			fw->size);
> >  		return;
--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.



--=-8JBTCm4n1ufoD71qgRks
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl31LZUACgkQ57/I7JWG
EQnG/Q/+J8w6IUF5IYasSuYv7QslTWpSAnzZ7KuYH6zqbdO/Ofo/NiYPmFeCVT7j
O8z/+ZybZgBmUT8R8B1j3TgAU3YN/kbE7aZC2FBcgaUYBKCl5oH9Nogm2ji/LRjM
t7QYsU2x2uE3S286kLW+/PYvQZz5AJ+vpt5NJ3/2PBOoEG79nooMfnOZtspGokEH
w4DZFLpkKpI76NBzeXZ6qWjiKL6J4iQg2D36e+Qfy6xvDu4FSNArq3UUE46/s08h
soiJHoPJCyf29y7z7gM61gpI4ekIw1QrSroAujr+yT3usmhDclg4jf9wef37LXRj
qSWdcD9aV8V4pNIHdLnGfR79orR7ZhVlS7qgesrpjQnz+p6HzrL/esMdV9dkzFgO
ikgmIQN7tpYWyyDPNBV1qAwAcsBxSHb6E+1/xkpneo40BKK5KfrxeRzKF/iKXQqw
+le3K3FSuRUSgFFGBW0mWYISpFoCHIJJtWe6rlgTElcoApNQkI4JNhjCGCMs3idI
/dVcWxZN/yhfJF5eU3reSEP/aQE24f5Q7U46vtKsKpPF3+qg03tcChvfnpEXk6qx
xfGpk7gI1JnoeSNJWgQPbdqRoP+sP9+f4o9PdCaS5UzOWcdhmWaEkk0KFrPiHPx5
sdA5lVT7UGlphi1e7GzOzeNy/qK9fw4RyOfysVhf+0y+zzswCpY=
=59ot
-----END PGP SIGNATURE-----

--=-8JBTCm4n1ufoD71qgRks--
