Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA2C1689ED
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 23:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgBUW21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 17:28:27 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40460 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgBUW21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 17:28:27 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A35051C1CBB; Fri, 21 Feb 2020 23:28:25 +0100 (CET)
Date:   Fri, 21 Feb 2020 23:28:25 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 114/191] ASoC: atmel: fix build error with
 CONFIG_SND_ATMEL_SOC_DMA=m
Message-ID: <20200221222825.GB14067@amd>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072304.590894861@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20200221072304.590894861@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 8fea78029f5e6ed734ae1957bef23cfda1af4354 ]
>=20
> If CONFIG_SND_ATMEL_SOC_DMA=3Dm, build error:
>=20
> sound/soc/atmel/atmel_ssc_dai.o: In function `atmel_ssc_set_audio':
> (.text+0x7cd): undefined reference to `atmel_pcm_dma_platform_register'
>=20
> Function atmel_pcm_dma_platform_register is defined under
> CONFIG SND_ATMEL_SOC_DMA, so select SND_ATMEL_SOC_DMA in
> CONFIG SND_ATMEL_SOC_SSC, same to CONFIG_SND_ATMEL_SOC_PDC.

4.19 code has significant differences from mainline in this area.

4.19:
config SND_ATMEL_SOC_DMA
        tristate
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	default m if SND_ATMEL_SOC_SSC_DMA=3Dm && SND_ATMEL_SOC_SSC=3Dm
=2E..

mainline:
config SND_ATMEL_SOC_DMA
        tristate
        select SND_SOC_GENERIC_DMAENGINE_PCM
=2E..

Extra 'default m if' line in 4.19 should already prevent this bug,
additional select statements are not neccessary.

Best regards,
								Pavel

> +++ b/sound/soc/atmel/Kconfig
> @@ -25,6 +25,8 @@ config SND_ATMEL_SOC_DMA
> =20
>  config SND_ATMEL_SOC_SSC_DMA
>  	tristate
> +	select SND_ATMEL_SOC_DMA
> +	select SND_ATMEL_SOC_PDC
> =20
>  config SND_ATMEL_SOC_SSC
>  	tristate

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl5QWYgACgkQMOfwapXb+vL3xwCgsnEahVgLj35jKntnGsfHqdiq
Ua4AmwX5KOLir2T1eAQHcdqj4Wy+dXbe
=6p6t
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
