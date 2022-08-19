Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF46599CC4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349187AbiHSNK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 09:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349227AbiHSNK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 09:10:27 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01177C924F;
        Fri, 19 Aug 2022 06:10:25 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 422631C0003; Fri, 19 Aug 2022 15:10:24 +0200 (CEST)
Date:   Fri, 19 Aug 2022 15:10:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liang He <windhl@126.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 218/779] regulator: of: Fix refcount leak bug in
 of_get_regulation_constraints()
Message-ID: <20220819131023.GB11901@duo.ucw.cz>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180346.599459531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <20220815180346.599459531@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Liang He <windhl@126.com>
>=20
> [ Upstream commit 66efb665cd5ad69b27dca8571bf89fc6b9c628a4 ]
>=20
> We should call the of_node_put() for the reference returned by
> of_get_child_by_name() which has increased the refcount.

Looks okay,

> +++ b/drivers/regulator/of_regulator.c
> @@ -264,8 +264,12 @@ static int of_get_regulation_constraints(struct devi=
ce *dev,
>  		}
> =20
>  		suspend_np =3D of_get_child_by_name(np, regulator_states[i]);
> -		if (!suspend_np || !suspend_state)
> +		if (!suspend_np)
>  			continue;
> +		if (!suspend_state) {
> +			of_node_put(suspend_np);
> +			continue;
> +		}
> =20

but note that of_node_put(NULL) should be okay, so this can be cleaned
up.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYv+LvwAKCRAw5/Bqldv6
8p0oAJ0TPKM6K3efzN4HCt1pYNDKkDVDLgCdGa7YicDIRb2Q2bd1/AA7pD9hzjE=
=DwFx
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
