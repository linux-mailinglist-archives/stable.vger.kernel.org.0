Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC8181554
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 10:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgCKJwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 05:52:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50796 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgCKJwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 05:52:14 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4E14F1C031D; Wed, 11 Mar 2020 10:52:12 +0100 (CET)
Date:   Wed, 11 Mar 2020 10:52:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 62/86] ASoC: intel: skl: Fix pin debug prints
Message-ID: <20200311095211.GA16104@duo.ucw.cz>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124534.139727555@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20200310124534.139727555@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Takashi Iwai <tiwai@suse.de>
>=20
> commit 64bbacc5f08c01954890981c63de744df1f29a30 upstream.
>=20
> skl_print_pins() loops over all given pins but it overwrites the text
> at the very same position while increasing the returned length.
> Fix this to show the all pin contents properly.

> --- a/sound/soc/intel/skylake/skl-debug.c
> +++ b/sound/soc/intel/skylake/skl-debug.c
> @@ -42,7 +42,7 @@ static ssize_t skl_print_pins(struct skl
>  	int i;
>  	ssize_t ret =3D 0;
> =20
> -	for (i =3D 0; i < max_pin; i++)
> +	for (i =3D 0; i < max_pin; i++) {
>  		ret +=3D snprintf(buf + size, MOD_BUF - size,
>  				"%s %d\n\tModule %d\n\tInstance %d\n\t"
>  				"In-used %s\n\tType %s\n"
> @@ -53,6 +53,8 @@ static ssize_t skl_print_pins(struct skl
>  				m_pin[i].in_use ? "Used" : "Unused",
>  				m_pin[i].is_dynamic ? "Dynamic" : "Static",
>  				m_pin[i].pin_state, i);
> +		size +=3D ret;
> +	}
>  	return ret;

This may be an improvement, but I believe this should use
"scnprintf()" as snprintf can return values bigger than size passed
in.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXmi0ywAKCRAw5/Bqldv6
8jjvAJ4hb+crf0j89bpBlgTYd7Rqt6RJswCdF2GuMkp+nb7SMMxOhUYI0O71V0s=
=CzDo
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
