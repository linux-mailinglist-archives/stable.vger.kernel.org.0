Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3630A1A
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 10:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfEaIT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 04:19:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49418 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfEaIT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 04:19:28 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 4AC6C80337; Fri, 31 May 2019 10:19:15 +0200 (CEST)
Date:   Fri, 31 May 2019 10:19:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/276] media: stm32-dcmi: return appropriate error
 codes during probe
Message-ID: <20190531081924.GA19447@amd>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030530.607146114@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20190530030530.607146114@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit b5b5a27bee5884860798ffd0f08e611a3942064b ]
>=20
> During probe, return the provided errors value instead of -ENODEV.
> This allows the driver to be deferred probed if needed.

This is not correct AFAICT.


> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -1673,8 +1673,9 @@ static int dcmi_probe(struct platform_device *pdev)
> =20
>  	irq =3D platform_get_irq(pdev, 0);
>  	if (irq <=3D 0) {
> -		dev_err(&pdev->dev, "Could not get irq\n");
> -		return -ENODEV;
> +		if (irq !=3D -EPROBE_DEFER)
> +			dev_err(&pdev->dev, "Could not get irq\n");
> +		return irq;
>  	}
> =20
>  	dcmi->res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);

irq =3D=3D 0 is clearly means error here, but will be interpretted as
success when returned to the caller.

As device is not initialized at that point, I'd expect some kind of
crash later.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzw44wACgkQMOfwapXb+vLDOwCeNYqfWuF93hTtnqrgIlbrnaEN
32cAnirXKL4nHTPzW92LREyXxKlUqgAq
=i5R3
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
