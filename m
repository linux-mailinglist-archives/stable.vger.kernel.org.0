Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB311278C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 10:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfLDJdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 04:33:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54582 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfLDJdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 04:33:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id ABFCD1C25F4; Wed,  4 Dec 2019 10:33:33 +0100 (CET)
Date:   Wed, 4 Dec 2019 10:33:33 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaojun Sang <xsang@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 004/321] ASoC: compress: fix unsigned integer
 overflow check
Message-ID: <20191204093332.GA7678@amd>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223427.350424112@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20191203223427.350424112@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-12-03 23:31:10, Greg Kroah-Hartman wrote:
> From: Xiaojun Sang <xsang@codeaurora.org>
>=20
> [ Upstream commit d3645b055399538415586ebaacaedebc1e5899b0 ]
>=20
> Parameter fragments and fragment_size are type of u32. U32_MAX is
> the correct check.

Why is this in stable? I doubt raising limit from 2GB to 4GB can be
called bugfix... kmalloc() will have problems allocating huge ammount
of memory, anyway.

Best regards,

							Pavel

> +++ b/sound/core/compress_offload.c
> @@ -529,7 +529,7 @@ static int snd_compress_check_input(struct snd_compr_=
params *params)
>  {
>  	/* first let's check the buffer parameter's */
>  	if (params->buffer.fragment_size =3D=3D 0 ||
> -	    params->buffer.fragments > INT_MAX / params->buffer.fragment_size ||
> +	    params->buffer.fragments > U32_MAX / params->buffer.fragment_size ||
>  	    params->buffer.fragments =3D=3D 0)
>  		return -EINVAL;
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3nfWwACgkQMOfwapXb+vKhbwCeOnJceAMnvxw3Jj0PQwdln5jf
WtAAmgLH4ATryXReAWBdS2wEKCl+xohc
=rTAe
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
