Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0861F30B95
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 11:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfEaJbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 05:31:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51268 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfEaJbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 05:31:35 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 3090680225; Fri, 31 May 2019 11:31:23 +0200 (CEST)
Date:   Fri, 31 May 2019 11:31:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Fabien DESSENNE <fabien.dessenne@st.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/276] media: stm32-dcmi: return appropriate error
 codes during probe
Message-ID: <20190531093132.GB23111@amd>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030530.607146114@linuxfoundation.org>
 <20190531081924.GA19447@amd>
 <180d29ba-74cc-08ae-35f6-cb58c1d79297@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <180d29ba-74cc-08ae-35f6-cb58c1d79297@st.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2019-05-31 08:39:18, Fabien DESSENNE wrote:
> Hi Pavel
>=20
>=20
> On 31/05/2019 10:19 AM, Pavel Machek wrote:
> > Hi!
> >
> >> [ Upstream commit b5b5a27bee5884860798ffd0f08e611a3942064b ]
> >>
> >> During probe, return the provided errors value instead of -ENODEV.
> >> This allows the driver to be deferred probed if needed.
> > This is not correct AFAICT.
>=20
>=20
> The driver gets defer probed *if needed*. *if needed* is for the case=20
> where platform_get_irq returns -EPROBE_DEFER, which happens if the irq=20
> controller is not ready yet.
>=20
> Of course, for the other cases, the probe would just fail.

"This" was referring to code below. Sorry for confusion.

Best regards,
								Pavel

> >> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> >> @@ -1673,8 +1673,9 @@ static int dcmi_probe(struct platform_device *pd=
ev)
> >>  =20
> >>   	irq =3D platform_get_irq(pdev, 0);
> >>   	if (irq <=3D 0) {
> >> -		dev_err(&pdev->dev, "Could not get irq\n");
> >> -		return -ENODEV;
> >> +		if (irq !=3D -EPROBE_DEFER)
> >> +			dev_err(&pdev->dev, "Could not get irq\n");
> >> +		return irq;
> >>   	}
> >>  =20
> >>   	dcmi->res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > irq =3D=3D 0 is clearly means error here, but will be interpretted as
> > success when returned to the caller.
>=20
>=20
> Thank you for pointing this.
>=20
> It shall be 'return irq ? irq : -ENXIO;'=A0 I will send a fix for this.
>=20
>=20
> >
> > As device is not initialized at that point, I'd expect some kind of
> > crash later.
> > 									Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzw9HQACgkQMOfwapXb+vIV7ACeO8GxyntB9vgzDVIFsslbbaA/
IuIAoMMUsxcd1ECPPI3yeSyo2ZazTOQK
=BUEt
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
