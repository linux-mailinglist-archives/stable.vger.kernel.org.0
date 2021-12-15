Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAD74754F2
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 10:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbhLOJQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 04:16:34 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241064AbhLOJQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 04:16:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 956161C0B98; Wed, 15 Dec 2021 10:16:32 +0100 (CET)
Date:   Wed, 15 Dec 2021 10:16:24 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH 4.19 29/74] clk: qcom: regmap-mux: fix parent clock lookup
Message-ID: <20211215091623.GA15796@amd>
References: <20211213092930.763200615@linuxfoundation.org>
 <20211213092931.784850569@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20211213092931.784850569@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The function mux_get_parent() uses qcom_find_src_index() to find the
> parent clock index, which is incorrect: qcom_find_src_index() uses src
> enum for the lookup, while mux_get_parent() should use cfg field (which
> corresponds to the register value). Add qcom_find_cfg_index() function
> doing this kind of lookup and use it for mux parent lookup.

This appears to have problems with error handling.

> +++ b/drivers/clk/qcom/clk-regmap-mux.c
> @@ -36,7 +36,7 @@ static u8 mux_get_parent(struct clk_hw *
>  	val &=3D mask;
> =20
>  	if (mux->parent_map)
> -		return qcom_find_src_index(hw, mux->parent_map, val);
> +		return qcom_find_cfg_index(hw, mux->parent_map, val);
> =20
>  	return val;
>  }

So this returns u8.

> +int qcom_find_cfg_index(struct clk_hw *hw, const struct parent_map *map,=
 u8 cfg)
> +{
> +	int i, num_parents =3D clk_hw_get_num_parents(hw);
> +
> +	for (i =3D 0; i < num_parents; i++)
> +		if (cfg =3D=3D map[i].cfg)
> +			return i;
> +
> +	return -ENOENT;
> +}

In case of error, -ENOENT will be cast to u8 in caller. I don't
believe that is correct.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmG5smcACgkQMOfwapXb+vLfGACghGVfl/BVcx3Ba/mAycv5WK2d
V/sAn2lAERM+A4AczZUjFFhimbMajL6x
=2YmH
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
