Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DD7599CBB
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348921AbiHSNRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 09:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348756AbiHSNRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 09:17:03 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C102EE4A6;
        Fri, 19 Aug 2022 06:17:01 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1E8FE1C0003; Fri, 19 Aug 2022 15:17:00 +0200 (CEST)
Date:   Fri, 19 Aug 2022 15:16:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 564/779] ASoC: mediatek: mt8173: Fix refcount leak
 in mt8173_rt5650_rt5676_dev_probe
Message-ID: <20220819131659.GD11901@duo.ucw.cz>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180401.426152365@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <20220815180401.426152365@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> From: Miaoqian Lin <linmq006@gmail.com>
>=20
> [ Upstream commit ae4f11c1ed2d67192fdf3d89db719ee439827c11 ]
>=20
> of_parse_phandle() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when not need anymore.
> Fix missing of_node_put() in error paths.

Is this correct?

> +++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
> @@ -256,14 +256,16 @@ static int mt8173_rt5650_rt5676_dev_probe(struct pl=
atform_device *pdev)
>  	if (!mt8173_rt5650_rt5676_dais[DAI_LINK_CODEC_I2S].codecs[0].of_node) {
>  		dev_err(&pdev->dev,
>  			"Property 'audio-codec' missing or invalid\n");
> -		return -EINVAL;
> +		ret =3D -EINVAL;
> +		goto put_node;
>  	}
=2E..
>  		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
>  			__func__, ret);
> =20
> +put_node:
>  	of_node_put(platform_node);
>  	return ret;
>  }

In success case, platform_node is stored:

		dai_link->platforms->of_node =3D platform_node;

I guess we should not be doing put in that case.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYv+NSwAKCRAw5/Bqldv6
8gFnAJ9yZOI3voz9OdP8eQBPwHploibRfQCgliraqSKTb2XKFtOzZf8J6KbJI5E=
=77mI
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
