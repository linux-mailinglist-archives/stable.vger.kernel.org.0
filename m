Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3969439690C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhEaUiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:38:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52500 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhEaUiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:38:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EAB181C0B76; Mon, 31 May 2021 22:36:38 +0200 (CEST)
Date:   Mon, 31 May 2021 22:36:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 35/54] ALSA: sb8: Add a comment note regarding an
 unused pointer
Message-ID: <20210531203638.GA19276@amd>
References: <20210531130635.070310929@linuxfoundation.org>
 <20210531130636.180684287@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20210531130636.180684287@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit a28591f61b60fac820c6de59826ffa710e5e314e ]
>=20
> The field "fm_res" of "struct snd_sb8" is never used/dereferenced
> throughout the sb8.c code. Therefore there is no need for any null value
> check after the "request_region()".
>=20
> Add a comment note to make developers know about this and prevent any
> "NULL check" patches on this part of code.
>=20
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
> Link: https://lore.kernel.org/r/20210503115736.2104747-36-gregkh@linuxfou=
ndation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This simply adds a comment... As I'm pretty sure anyone trying to
"fix" this will try that on mainline, it is even very useful comment.

That's something our documentation says we don't do in stable. I'd
prefer it not to be in.

Best regards,
								Pavel

> +++ b/sound/isa/sb/sb8.c
> @@ -109,7 +109,11 @@ static int snd_sb8_probe(struct device *pdev, unsign=
ed int dev)
>  	acard =3D card->private_data;
>  	card->private_free =3D snd_sb8_free;
> =20
> -	/* block the 0x388 port to avoid PnP conflicts */
> +	/*
> +	 * Block the 0x388 port to avoid PnP conflicts.
> +	 * No need to check this value after request_region,
> +	 * as we never do anything with it.
> +	 */
>  	acard->fm_res =3D request_region(0x388, 4, "SoundBlaster FM");
> =20
>  	if (port[dev] !=3D SNDRV_AUTO_PORT) {

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC1SNYACgkQMOfwapXb+vI1TwCcDjiflmigJr8ijmGsM1vnGUlo
O4QAoJl7lbmOMHi5aOLznIXRH+XFroSC
=ry0e
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
