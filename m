Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325BD2DF212
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 00:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgLSXOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 18:14:10 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34488 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgLSXOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 18:14:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4F9D01C0B77; Sun, 20 Dec 2020 00:13:13 +0100 (CET)
Date:   Sun, 20 Dec 2020 00:13:13 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.9 14/49] net: stmmac: dwmac-meson8b: fix mask
 definition of the m250_sel mux
Message-ID: <20201219231312.GA4206@duo.ucw.cz>
References: <20201219125344.671832095@linuxfoundation.org>
 <20201219125345.376925474@linuxfoundation.org>
 <20201219215139.GA29536@amd>
 <CAFBinCBRe3Oacqce1EDQpoNmEhXeUxJrA43RTA0+_fVciDJzhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <CAFBinCBRe3Oacqce1EDQpoNmEhXeUxJrA43RTA0+_fVciDJzhg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2020-12-19 23:38:25, Martin Blumenstingl wrote:
> Hi Pavel,
>=20
> On Sat, Dec 19, 2020 at 10:51 PM Pavel Machek <pavel@ucw.cz> wrote:
> [...]
> > I can't say I like this one:
> >
> >
> > >       clk_configs->m250_mux.reg =3D dwmac->regs + PRG_ETH0;
> > > -     clk_configs->m250_mux.shift =3D PRG_ETH0_CLK_M250_SEL_SHIFT;
> > > -     clk_configs->m250_mux.mask =3D PRG_ETH0_CLK_M250_SEL_MASK;
> > > +     clk_configs->m250_mux.shift =3D __ffs(PRG_ETH0_CLK_M250_SEL_MAS=
K);
> >
> > It replaces constant with computation done at runtime; compiler can't
> > optimize it as __ffs is implemented with asm().
> what do you suggest to use instead?
> personally I don't see a problem because this is only called once at
> driver probe time.

I believe canonical solution is version before this patch, just with
fixed values....

I mean yes, computation at runtime is not end of the world, but it is
both slower and needs more code space...

Best regards,

								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX96JCAAKCRAw5/Bqldv6
8kG3AJ9TFnaLlImgKAwuTjJSWWARH7RfeACgjwWXTvcOmAm6t7PKUvgihNopFLA=
=89oe
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
