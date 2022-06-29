Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DF15600A7
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 15:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiF2NGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 09:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiF2NGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 09:06:20 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A696D34BA6;
        Wed, 29 Jun 2022 06:06:18 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 641811C0C05; Wed, 29 Jun 2022 15:06:17 +0200 (CEST)
Date:   Wed, 29 Jun 2022 15:06:17 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        yangtiezhu@loongson.cn, linux-mips@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 11/13] mips/pic32/pic32mzda: Fix refcount
 leak bugs
Message-ID: <20220629130617.GE13395@duo.ucw.cz>
References: <20220628022657.597208-1-sashal@kernel.org>
 <20220628022657.597208-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Content-Disposition: inline
In-Reply-To: <20220628022657.597208-11-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Liang He <windhl@126.com>
>=20
> [ Upstream commit eb9e9bc4fa5fb489c92ec588b3fb35f042ba6d86 ]
>=20
> of_find_matching_node(), of_find_compatible_node() and
> of_find_node_by_path() will return node pointers with refcout
> incremented. We should call of_node_put() when they are not
> used anymore.

It looks like this may introduces an use-after-free bug:

> +++ b/arch/mips/pic32/pic32mzda/init.c
> @@ -131,13 +131,18 @@ static int __init pic32_of_prepare_platform_data(st=
ruct of_dev_auxdata *lookup)
>  		np =3D of_find_compatible_node(NULL, NULL, lookup->compatible);
>  		if (np) {
>  			lookup->name =3D (char *)np->name;
> -			if (lookup->phys_addr)
> +			if (lookup->phys_addr) {
> +				of_node_put(np);
>  				continue;
> +			}
>  			if (!of_address_to_resource(np, 0, &res))
>  				lookup->phys_addr =3D res.start;
> +			of_node_put(np);
>  		}
>  	}

lookup->name now contains pointer taken from np->name, but we did
put() on the np. What guarantees np->name is not freed?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYrxOSQAKCRAw5/Bqldv6
8sEMAJ9Wi5qZTh56Crna6boxGUkle0M5/QCgsd1WeGfdmFHYdY1YLbCN29nJ5yA=
=mGn2
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
