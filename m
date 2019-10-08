Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064FACF9A5
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 14:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbfJHMUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 08:20:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40190 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfJHMUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 08:20:04 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id C2B588039E; Tue,  8 Oct 2019 14:19:46 +0200 (CEST)
Date:   Tue, 8 Oct 2019 14:20:01 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 018/106] clk: actions: Dont reference clk_init_data
 after registration
Message-ID: <20191008122001.GD608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171132.803572044@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <20191006171132.803572044@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-10-06 19:20:24, Greg Kroah-Hartman wrote:
> From: Stephen Boyd <sboyd@kernel.org>
>=20
> [ Upstream commit cf9ec1fc6d7cceb73e7f1efd079d2eae173fdf57 ]
>=20
> A future patch is going to change semantics of clk_register() so that
> clk_hw::init is guaranteed to be NULL after a clk is registered. Avoid
> referencing this member here so that we don't run into NULL pointer
> exceptions.

18,19,20,21: I see the patches make sense for mainline, but why were
they selected for stable?

								Pavel


> +++ b/drivers/clk/actions/owl-common.c
> @@ -67,16 +67,17 @@ int owl_clk_probe(struct device *dev, struct clk_hw_o=
necell_data *hw_clks)
>  	struct clk_hw *hw;
> =20
>  	for (i =3D 0; i < hw_clks->num; i++) {
> +		const char *name;
> =20
>  		hw =3D hw_clks->hws[i];
> -
>  		if (IS_ERR_OR_NULL(hw))
>  			continue;
> =20
> +		name =3D hw->init->name;
>  		ret =3D devm_clk_hw_register(dev, hw);
>  		if (ret) {
>  			dev_err(dev, "Couldn't register clock %d - %s\n",
> -				i, hw->init->name);
> +				i, name);
>  			return ret;
>  		}
>  	}

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2cfvEACgkQMOfwapXb+vJyuQCgk/YWyTypT/1mZP1qUfsMPV92
ZGsAoLJ8l/niXr2y2E0biDeag/lEu9M+
=31KL
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
