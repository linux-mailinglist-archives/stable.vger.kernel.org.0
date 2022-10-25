Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E370D60C656
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 10:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiJYIWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 04:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiJYIWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 04:22:41 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B853CEF5BD;
        Tue, 25 Oct 2022 01:22:39 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5DB1E1C0016; Tue, 25 Oct 2022 10:22:38 +0200 (CEST)
Date:   Tue, 25 Oct 2022 10:22:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Gow <davidgow@google.com>,
        Tales Aparecida <tales.aparecida@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 195/229] drm/amd/display: fix overflow on MIN_I64
 definition
Message-ID: <20221025082237.GB9520@duo.ucw.cz>
References: <20221024112959.085534368@linuxfoundation.org>
 <20221024113005.440623785@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20221024113005.440623785@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: David Gow <davidgow@google.com>
>=20
> [ Upstream commit 6ae0632d17759852c07e2d1e0a31c728eb6ba246 ]
>=20
> The definition of MIN_I64 in bw_fixed.c can cause gcc to whinge about
> integer overflow, because it is treated as a positive value, which is
> then negated. The temporary positive value is not necessarily
> representable.
>=20
> This causes the following warning:
> ../drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/bw_fixed.c:30:19:
> warning: integer overflow in expression =E2=80=98-9223372036854775808=E2=
=80=99 of type
> =E2=80=98long long int=E2=80=99 results in =E2=80=98-9223372036854775808=
=E2=80=99 [-Woverflow]
>   30 |         (int64_t)(-(1LL << 63))
>      |                   ^
>=20
> Writing out (-MAX_I64 - 1) works instead.

While this probably fixes the warning, better fix would be to include
limits.h which already has equivalent definitions.

Thanks and best regards,
								Pavel

> -#define MIN_I64 \
> -	(int64_t)(-(1LL << 63))
> -
>  #define MAX_I64 \
>  	(int64_t)((1ULL << 63) - 1)
> =20
> +#define MIN_I64 \
> +	(-MAX_I64 - 1)
> +
>  #define FRACTIONAL_PART_MASK \
>  	((1ULL << BW_FIXED_BITS_PER_FRACTIONAL_PART) - 1)
> =20
> --=20
> 2.35.1
>=20
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1eczQAKCRAw5/Bqldv6
8pVCAJ43iW1FofsAsPLtMMAPmphPLrb+YQCgknCNaLt+z1Rby0N/lPRR3e0r9Tw=
=H1iX
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
