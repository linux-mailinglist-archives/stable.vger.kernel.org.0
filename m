Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2137201CDD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 23:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391867AbgFSVHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 17:07:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50614 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391572AbgFSVHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 17:07:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0A47C1C0C12; Fri, 19 Jun 2020 23:07:20 +0200 (CEST)
Date:   Fri, 19 Jun 2020 23:07:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 182/267] spi: dw: Return any value retrieved from
 the dma_transfer callback
Message-ID: <20200619210719.GB12233@amd>
References: <20200619141648.840376470@linuxfoundation.org>
 <20200619141657.498868116@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <20200619141657.498868116@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-06-19 16:32:47, Greg Kroah-Hartman wrote:
> From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
>=20
> [ Upstream commit f0410bbf7d0fb80149e3b17d11d31f5b5197873e ]
>=20
> DW APB SSI DMA-part of the driver may need to perform the requested
> SPI-transfer synchronously. In that case the dma_transfer() callback
> will return 0 as a marker of the SPI transfer being finished so the
> SPI core doesn't need to wait and may proceed with the SPI message
> trasnfers pumping procedure. This will be needed to fix the problem
> when DMA transactions are finished, but there is still data left in
> the SPI Tx/Rx FIFOs being sent/received. But for now make dma_transfer
> to return 1 as the normal dw_spi_transfer_one() method.

As far as I understand, this is support for new SoC, not a fix?

> +++ b/drivers/spi/spi-dw.c
> @@ -383,11 +383,8 @@ static int dw_spi_transfer_one(struct spi_controller=
 *master,
> =20
>  	spi_enable_chip(dws, 1);
> =20
> -	if (dws->dma_mapped) {
> -		ret =3D dws->dma_ops->dma_transfer(dws, transfer);
> -		if (ret < 0)
> -			return ret;
> -	}
> +	if (dws->dma_mapped)
> +		return dws->dma_ops->dma_transfer(dws, transfer);
> =20
>  	if (chip->poll_mode)
>  		return poll_transfer(dws);

Mainline patch simply changes return value, but code is different in
v4.19, and poll_transfer will now be avoided when dws->dma_mapped. Is
that a problem?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7tKQcACgkQMOfwapXb+vJ1sgCeOJVyrkyrloM2p+RmL54QRIPJ
CLQAn1uKYJOgsc+yYzmNLkQTUJ86pN4t
=lPtX
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
