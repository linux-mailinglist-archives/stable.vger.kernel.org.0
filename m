Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF15EA5AB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiIZMLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbiIZMK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:10:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034AE81684;
        Mon, 26 Sep 2022 03:57:11 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D61A31C09D7; Mon, 26 Sep 2022 12:40:39 +0200 (CEST)
Date:   Mon, 26 Sep 2022 12:40:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 10/30] mips/pic32/pic32mzda: Fix refcount leak bugs
Message-ID: <20220926104042.GD8978@amd>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.537955607@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
In-Reply-To: <20220926100736.537955607@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit eb9e9bc4fa5fb489c92ec588b3fb35f042ba6d86 ]
>=20
> of_find_matching_node(), of_find_compatible_node() and
> of_find_node_by_path() will return node pointers with refcout
> incremented. We should call of_node_put() when they are not
> used anymore.

True. But we absolutely should not call put when we still use the
reference.

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

As we stored np->name in lookup, we should not be putting that node,
we are still using it.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmMxgaoACgkQMOfwapXb+vKqygCfXpKlHSst+dGtKDekJry/dOhh
JUMAn2T9uxpsKom/nI/vOyoqyApFhOFK
=yziF
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
