Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2F4AFD3A
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiBITSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:18:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiBITSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:18:07 -0500
X-Greylist: delayed 502 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 11:18:00 PST
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [IPv6:2a00:da80:fff0:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBCDC00693D;
        Wed,  9 Feb 2022 11:18:00 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 47EA71C0B7A; Wed,  9 Feb 2022 20:07:02 +0100 (CET)
Date:   Wed, 9 Feb 2022 20:07:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 77/86] ASoC: fsl: Add missing error handling in
 pcm030_fabric_probe
Message-ID: <20220209190701.GA10459@duo.ucw.cz>
References: <20220207103757.550973048@linuxfoundation.org>
 <20220207103800.195504006@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20220207103800.195504006@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit fb25621da5702c104ce0a48de5b174ced09e5b4e upstream.
>=20
> Add the missing platform_device_put() and platform_device_del()
> before return from pcm030_fabric_probe in the error handling case.

Are you sure?

> --- a/sound/soc/fsl/pcm030-audio-fabric.c
> +++ b/sound/soc/fsl/pcm030-audio-fabric.c
> @@ -90,16 +90,21 @@ static int pcm030_fabric_probe(struct pl
>  		dev_err(&op->dev, "platform_device_alloc() failed\n");
> =20
>  	ret =3D platform_device_add(pdata->codec_device);
> -	if (ret)
> +	if (ret) {
>  		dev_err(&op->dev, "platform_device_add() failed: %d\n", ret);
> +		platform_device_put(pdata->codec_device);
> +	}
> =20
>  	ret =3D snd_soc_register_card(card);
> -	if (ret)
> +	if (ret) {
>  		dev_err(&op->dev, "snd_soc_register_card() failed: %d\n", ret);
> +		platform_device_del(pdata->codec_device);
> +		platform_device_put(pdata->codec_device);
> +	}
> =20
>  	platform_set_drvdata(op, pdata);
> -
>  	return ret;
> +
>  }

Besides interesting whitespace, this will happily do
platform_device_put() twice. I suspect it should return or
something. This does not look right.

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYgQQ1QAKCRAw5/Bqldv6
8r6yAJ0b32yBnFzeOQ+ZKSYI5cF+pD0jXQCfUFZuWjyWGVZtzMvCNHmWiEODMZs=
=FNvY
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
