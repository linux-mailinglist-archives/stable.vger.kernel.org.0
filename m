Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7883CF9AE
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 14:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfJHMYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 08:24:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40292 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfJHMYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 08:24:20 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id E340C80307; Tue,  8 Oct 2019 14:24:01 +0200 (CEST)
Date:   Tue, 8 Oct 2019 14:24:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <treding@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        linux-rockchip@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 061/106] PCI: rockchip: Propagate errors for
 optional regulators
Message-ID: <20191008122416.GE608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171149.476262829@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
In-Reply-To: <20191006171149.476262829@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-10-06 19:21:07, Greg Kroah-Hartman wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> [ Upstream commit 0e3ff0ac5f71bdb6be2a698de0ed0c7e6e738269 ]
>=20
> regulator_get_optional() can fail for a number of reasons besides probe
> deferral. It can for example return -ENOMEM if it runs out of memory as
> it tries to allocate data structures. Propagating only -EPROBE_DEFER is
> problematic because it results in these legitimately fatal errors being
> treated as "regulator not specified in DT".
>=20
> What we really want is to ignore the optional regulators only if they
> have not been specified in DT. regulator_get_optional() returns -ENODEV
> in this case, so that's the special case that we need to handle. So we
> propagate all errors, except -ENODEV, so that real failures will still
> cause the driver to fail probe.

61,62,63,64: Is this fixing any real bug? Why is it suitable for
-stable?

								Pavel

> +++ b/drivers/pci/controller/pcie-rockchip-host.c
> @@ -608,29 +608,29 @@ static int rockchip_pcie_parse_host_dt(struct rockc=
hip_pcie *rockchip)
> =20
>  	rockchip->vpcie12v =3D devm_regulator_get_optional(dev, "vpcie12v");
>  	if (IS_ERR(rockchip->vpcie12v)) {
> -		if (PTR_ERR(rockchip->vpcie12v) =3D=3D -EPROBE_DEFER)
> -			return -EPROBE_DEFER;
> +		if (PTR_ERR(rockchip->vpcie12v) !=3D -ENODEV)
> +			return PTR_ERR(rockchip->vpcie12v);
>  		dev_info(dev, "no vpcie12v regulator found\n");
>  	}
> =20
>  	rockchip->vpcie3v3 =3D devm_regulator_get_optional(dev, "vpcie3v3");
>  	if (IS_ERR(rockchip->vpcie3v3)) {
> -		if (PTR_ERR(rockchip->vpcie3v3) =3D=3D -EPROBE_DEFER)
> -			return -EPROBE_DEFER;
> +		if (PTR_ERR(rockchip->vpcie3v3) !=3D -ENODEV)
> +			return PTR_ERR(rockchip->vpcie3v3);
>  		dev_info(dev, "no vpcie3v3 regulator found\n");
>  	}
> =20
>  	rockchip->vpcie1v8 =3D devm_regulator_get_optional(dev, "vpcie1v8");
>  	if (IS_ERR(rockchip->vpcie1v8)) {
> -		if (PTR_ERR(rockchip->vpcie1v8) =3D=3D -EPROBE_DEFER)
> -			return -EPROBE_DEFER;
> +		if (PTR_ERR(rockchip->vpcie1v8) !=3D -ENODEV)
> +			return PTR_ERR(rockchip->vpcie1v8);
>  		dev_info(dev, "no vpcie1v8 regulator found\n");
>  	}
> =20
>  	rockchip->vpcie0v9 =3D devm_regulator_get_optional(dev, "vpcie0v9");
>  	if (IS_ERR(rockchip->vpcie0v9)) {
> -		if (PTR_ERR(rockchip->vpcie0v9) =3D=3D -EPROBE_DEFER)
> -			return -EPROBE_DEFER;
> +		if (PTR_ERR(rockchip->vpcie0v9) !=3D -ENODEV)
> +			return PTR_ERR(rockchip->vpcie0v9);
>  		dev_info(dev, "no vpcie0v9 regulator found\n");
>  	}
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2cf/AACgkQMOfwapXb+vJv3ACfRzDkFXlTi9tPJOxO6+xiSAgn
z9oAnjZ9WXSOdp7sZSsix4hoHFpYHA7p
=2wkE
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
