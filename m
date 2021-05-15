Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EF0381ADC
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 21:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbhEOTxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 15:53:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50850 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEOTxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 15:53:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B62D41C0B81; Sat, 15 May 2021 21:52:21 +0200 (CEST)
Date:   Sat, 15 May 2021 21:52:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>
Subject: Re: [PATCH 5.10 036/530] iio:adc:ad7476: Fix remove handling
Message-ID: <20210515195221.GA4103@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144820.931257479@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20210512144820.931257479@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> commit 6baee4bd63f5fdf1716f88e95c21a683e94fe30d upstream.
>=20
> This driver was in an odd half way state between devm based cleanup
> and manual cleanup (most of which was missing).
> I would guess something went wrong with a rebase or similar.
> Anyhow, this basically finishes the job as a precursor to improving
> the regulator handling.

I don't think this is correct:

> --- a/drivers/iio/adc/ad7476.c
> +++ b/drivers/iio/adc/ad7476.c
> @@ -316,25 +316,15 @@ static int ad7476_probe(struct spi_devic
>  	spi_message_init(&st->msg);
>  	spi_message_add_tail(&st->xfer, &st->msg);
> =20
> -	ret =3D iio_triggered_buffer_setup(indio_dev, NULL,
> -			&ad7476_trigger_handler, NULL);
> +	ret =3D devm_iio_triggered_buffer_setup(&spi->dev, indio_dev, NULL,
> +					      &ad7476_trigger_handler, NULL);
>  	if (ret)
> -		goto error_disable_reg;
> +		return ret;
> =20
>  	if (st->chip_info->reset)
>  		st->chip_info->reset(st);
> =20
> -	ret =3D iio_device_register(indio_dev);
> -	if (ret)
> -		goto error_ring_unregister;
> -	return 0;
> -
> -error_ring_unregister:
> -	iio_triggered_buffer_cleanup(indio_dev);
> -error_disable_reg:
> -	regulator_disable(st->reg);
> -

Regulator_disable is now removed, but we still use regulator_enable,
and we still need to keep it balanced.

> -	return ret;
> +	return devm_iio_device_register(&spi->dev, indio_dev);
>  }

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCgJnUACgkQMOfwapXb+vIgIACeNJBbhxFmGCays2US+k3vdn3b
OYkAnjoBQ4ogsSqWiYx0GGd1moQXFtDQ
=XCF+
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
