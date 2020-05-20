Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214781DB8B0
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 17:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgETPvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 11:51:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34508 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgETPvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 11:51:43 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbR0P-0007Ww-KZ; Wed, 20 May 2020 16:51:41 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbR0P-007IXb-7x; Wed, 20 May 2020 16:51:41 +0100
Message-ID: <08276329b2ec77d11881ff0cae2562f08da66baf.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 37/99] clk: tegra: Mark fuse clock as critical
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Date:   Wed, 20 May 2020 16:51:36 +0100
In-Reply-To: <lsq.1589984008.801885396@decadent.org.uk>
References: <lsq.1589984008.801885396@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-HhFPE6gpZD5IGNS1vMOU"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-HhFPE6gpZD5IGNS1vMOU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-05-20 at 15:14 +0100, Ben Hutchings wrote:
> 3.16.84-rc1 review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Stephen Warren <swarren@nvidia.com>
>=20
> commit bf83b96f87ae2abb1e535306ea53608e8de5dfbb upstream.

I've now dropped this, as CLK_IS_CRITICAL is not implemented on 3.16.

Ben.

> For a little over a year, U-Boot on Tegra124 has configured the flow
> controller to perform automatic RAM re-repair on off->on power
> transitions of the CPU rail[1]. This is mandatory for correct operation
> of Tegra124. However, RAM re-repair relies on certain clocks, which the
> kernel must enable and leave running. The fuse clock is one of those
> clocks. Mark this clock as critical so that LP1 power mode (system
> suspend) operates correctly.
>=20
> [1] 3cc7942a4ae5 ARM: tegra: implement RAM repair
>=20
> Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/clk/tegra/clk-tegra-periph.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> --- a/drivers/clk/tegra/clk-tegra-periph.c
> +++ b/drivers/clk/tegra/clk-tegra-periph.c
> @@ -517,7 +517,11 @@ static struct tegra_periph_init_data gat
>  	GATE("vcp", "clk_m", 29, 0, tegra_clk_vcp, 0),
>  	GATE("apbdma", "clk_m", 34, 0, tegra_clk_apbdma, 0),
>  	GATE("kbc", "clk_32k", 36, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET,=
 tegra_clk_kbc, 0),
> -	GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, 0),
> +	/*
> +	 * Critical for RAM re-repair operation, which must occur on resume
> +	 * from LP1 system suspend and as part of CCPLEX cluster switching.
> +	 */
> +	GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, CLK_IS_C=
RITICAL),
>  	GATE("fuse_burn", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse_burn=
, 0),
>  	GATE("kfuse", "clk_m", 40, TEGRA_PERIPH_ON_APB, tegra_clk_kfuse, 0),
>  	GATE("apbif", "clk_m", 107, TEGRA_PERIPH_ON_APB, tegra_clk_apbif, 0),
>=20
--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken



--=-HhFPE6gpZD5IGNS1vMOU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7FUggACgkQ57/I7JWG
EQkWDxAAu5MPB6sH+UD5M+rqoTVuv6u3+xpVNpB1ud7i35VbhBDXCxJ0eER+x1HN
ywxc11cdIxX1q1WjOcjWE7rF+KPSOJAABBMfExitsvaPOVI9B0km5xHX0KXtUl7M
6zuK+/89tlANyzBZW3xAWwFjCLLszDAzFHtYkMgZFPhGlaPnG6Zaek0Oz/iZ6dB3
WM8yyC6/qUcs+AVaHUvG4fPqv7QL+nXtLVnnPusSJBLUpK68fUFa4WJKRLmLBa7E
6A/XN9FlMb0R+3icsed48h43CkdOMBGQ/sbn2DmWb7+3w0Iz5PFA6da1hBZmA2f7
UGdOkfoS4yYe00Gp3NAMgrTEU+amKMFg6xWfcgiTqC5fWN2F6JYbAD2Zc96MyQjJ
+v0zlCHFolQN+dbfSwwIgJ99/e7N9hcWcXw7mgXY15Vgfj3GZf0ydhxWz7NgC7Q4
mXmaQdArP7snHoO3yzj4oV5xhva3HjCyDJCINXlVQ01T8R0MepTlZvTV+qxtNpjd
sgXJ0fsdVW51oDvoxyiA/gQ9013LKcE9PTXd7EjnH02SutuOPlynlczfnYWorR3s
Q2lGy9MLIw1jvMyKSK8hp9evOQbeOrxs8JuIeXt7jjrB5seTrqLppd6Hv5wyrrEx
ZEru0XzJ+qmlWBx6mVrcw3om9zxtuwUbPJ4vrgHPSgwFublmHgw=
=sl0g
-----END PGP SIGNATURE-----

--=-HhFPE6gpZD5IGNS1vMOU--
