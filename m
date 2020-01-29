Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2D014D337
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 23:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgA2WrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 17:47:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51124 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgA2WrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 17:47:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2802B1C25FC; Wed, 29 Jan 2020 23:47:20 +0100 (CET)
Date:   Wed, 29 Jan 2020 23:47:19 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Wen Huang <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 4.19 63/92] libertas: Fix two buffer overflows at parsing
 bss descriptor
Message-ID: <20200129224719.GA4342@amd>
References: <20200128135809.344954797@linuxfoundation.org>
 <20200128135817.338824312@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20200128135817.338824312@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Wen Huang <huangwenabc@gmail.com>
>=20
> commit e5e884b42639c74b5b57dc277909915c0aefc8bb upstream.

> --- a/drivers/net/wireless/marvell/libertas/cfg.c
> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> @@ -1717,6 +1721,9 @@ static int lbs_ibss_join_existing(struct
>  	struct cmd_ds_802_11_ad_hoc_join cmd;
>  	u8 preamble =3D RADIO_PREAMBLE_SHORT;
>  	int ret =3D 0;
> +	int hw, i;
> +	u8 rates_max;
> +	u8 *rates;
> =20
>  	/* TODO: set preamble based on scan result */
>  	ret =3D lbs_set_radio(priv, preamble, 1);
> @@ -1775,9 +1782,12 @@ static int lbs_ibss_join_existing(struct
>  	if (!rates_eid) {
>  		lbs_add_rates(cmd.bss.rates);
>  	} else {
> -		int hw, i;
> -		u8 rates_max =3D rates_eid[1];
> -		u8 *rates =3D cmd.bss.rates;
> +		rates_max =3D rates_eid[1];

I believe original version (with variables being local to the else)
was better.

> +		if (rates_max > MAX_RATES) {
> +			lbs_deb_join("invalid rates");
> +			goto out;
> +		}
> +		rates =3D cmd.bss.rates;

"goto out" goes to "return ret". ret will be 0 at this point, so this
will return success. I don't think that's right.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4yC3cACgkQMOfwapXb+vLVyACghs8u7hPnfijLNpwrwjW0IPzt
lnwAoLHj4z9g4PWXiUk2z9YnHxQi4DUV
=9E6d
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
