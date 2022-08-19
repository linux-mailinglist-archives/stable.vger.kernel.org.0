Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE86A599CB5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348742AbiHSNO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 09:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348424AbiHSNO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 09:14:27 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6F619C31;
        Fri, 19 Aug 2022 06:14:26 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 13F2B1C0003; Fri, 19 Aug 2022 15:14:25 +0200 (CEST)
Date:   Fri, 19 Aug 2022 15:14:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 565/779] ASoC: mt6797-mt6351: Fix refcount leak in
 mt6797_mt6351_dev_probe
Message-ID: <20220819131424.GC11901@duo.ucw.cz>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180401.467155717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <20220815180401.467155717@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Miaoqian Lin <linmq006@gmail.com>
>=20
> [ Upstream commit 7472eb8d7dd12b6b9b1a4f4527719cc9c7f5965f ]
>=20
> of_parse_phandle() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when not need anymore.
> Add missing of_node_put() to avoid refcount leak.

AFAICT this has serious problems:

> +++ b/sound/soc/mediatek/mt6797/mt6797-mt6351.c
> @@ -217,7 +217,8 @@ static int mt6797_mt6351_dev_probe(struct platform_de=
vice *pdev)
>  	if (!codec_node) {
>  		dev_err(&pdev->dev,
>  			"Property 'audio-codec' missing or invalid\n");
> -		return -EINVAL;
> +		ret =3D -EINVAL;
> +		goto put_platform_node;
>  	}
>  	for_each_card_prelinks(card, i, dai_link) {
>  		if (dai_link->codecs->name)
> @@ -230,6 +231,9 @@ static int mt6797_mt6351_dev_probe(struct platform_de=
vice *pdev)
>  		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
>  			__func__, ret);
> =20
> +	of_node_put(codec_node);
> +put_platform_node:
> +	of_node_put(platform_node);
>  	return ret;
>  }

platform_node is stashed away in struct, and so is codec_node; we
should not be freeing those references in success case, right?

                dai_link->platforms->of_node =3D platform_node;

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYv+MsAAKCRAw5/Bqldv6
8lRcAJ9hyOCiDVWb3RAM5/pp+76QaJb1zwCfTF/SH5XHwMA4dbrA9qYxUcJ7fY8=
=gdKK
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
