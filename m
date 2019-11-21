Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF9710501A
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 11:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUKOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 05:14:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38206 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUKOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 05:14:24 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5C7D21C1B4D; Thu, 21 Nov 2019 11:14:22 +0100 (CET)
Date:   Thu, 21 Nov 2019 11:14:21 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 068/422] ASoC: meson: axg-fifo: report interrupt
 request failure
Message-ID: <20191121101421.GA26882@amd>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051404.060509734@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20191119051404.060509734@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Return value of request_irq() was irgnored. Fix this and report
> the failure if any

>  1 file changed, 2 insertions(+)
>=20
> diff --git a/sound/soc/meson/axg-fifo.c b/sound/soc/meson/axg-fifo.c
> index 30262550e37b1..0e4f65e654c4b 100644
> --- a/sound/soc/meson/axg-fifo.c
> +++ b/sound/soc/meson/axg-fifo.c
> @@ -203,6 +203,8 @@ static int axg_fifo_pcm_open(struct snd_pcm_substream=
 *ss)
> =20
>  	ret =3D request_irq(fifo->irq, axg_fifo_pcm_irq_block, 0,
>  			  dev_name(dev), ss);
> +	if (ret)
> +		return ret;
> =20
>  	/* Enable pclk to access registers and clock the fifo ip */
>  	ret =3D clk_prepare_enable(fifo->pclk);

While this is not incorrect...=20

Do we need to free_irq in case of clk_prepare_enable() or other stuff
below fails?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3WY30ACgkQMOfwapXb+vLnXgCgur1j0sJDDo2M15cCY4ZXGC0i
wlgAnjJ/0Xc7penvWzR0V4XRQAlQ5E08
=h8oD
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
