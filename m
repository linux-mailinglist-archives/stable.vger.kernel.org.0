Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA612DF1E1
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 22:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgLSVwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 16:52:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55082 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgLSVwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 16:52:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DB3B71C0B77; Sat, 19 Dec 2020 22:51:39 +0100 (CET)
Date:   Sat, 19 Dec 2020 22:51:39 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.9 14/49] net: stmmac: dwmac-meson8b: fix mask
 definition of the m250_sel mux
Message-ID: <20201219215139.GA29536@amd>
References: <20201219125344.671832095@linuxfoundation.org>
 <20201219125345.376925474@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20201219125345.376925474@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>=20
> [ Upstream commit 82ca4c922b8992013a238d65cf4e60cc33e12f36 ]
>=20
> The m250_sel mux clock uses bit 4 in the PRG_ETH0 register. Fix this by
> shifting the PRG_ETH0_CLK_M250_SEL_MASK accordingly as the "mask" in
> struct clk_mux expects the mask relative to the "shift" field in the
> same struct.
>=20
> While here, get rid of the PRG_ETH0_CLK_M250_SEL_SHIFT macro and use
> __ffs() to determine it from the existing PRG_ETH0_CLK_M250_SEL_MASK
> macro.

I can't say I like this one:


>  	clk_configs->m250_mux.reg =3D dwmac->regs + PRG_ETH0;
> -	clk_configs->m250_mux.shift =3D PRG_ETH0_CLK_M250_SEL_SHIFT;
> -	clk_configs->m250_mux.mask =3D PRG_ETH0_CLK_M250_SEL_MASK;
> +	clk_configs->m250_mux.shift =3D __ffs(PRG_ETH0_CLK_M250_SEL_MASK);

It replaces constant with computation done at runtime; compiler can't
optimize it as __ffs is implemented with asm().

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/edesACgkQMOfwapXb+vLNhACeNKD0qJvCjQyfRTkrm7ragROq
cS0An10DURGbZBZzo+5tsladCnjNC4n3
=b7bN
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
