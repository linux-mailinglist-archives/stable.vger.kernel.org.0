Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653265F40A4
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 12:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJDKQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 06:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJDKQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 06:16:33 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC94F2BE23;
        Tue,  4 Oct 2022 03:16:31 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 298091C0036; Tue,  4 Oct 2022 12:16:30 +0200 (CEST)
Date:   Tue, 4 Oct 2022 12:16:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Junxiao Chang <junxiao.chang@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Jimmy JS Chen <jimmyjs.chen@adlinktech.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Looi@vger.kernel.org
Subject: Re: [PATCH 5.10 46/52] net: stmmac: power up/down serdes in
 stmmac_open/release
Message-ID: <20221004101627.GA30005@duo.ucw.cz>
References: <20221003070718.687440096@linuxfoundation.org>
 <20221003070720.101874721@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20221003070720.101874721@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The issue is related with serdes which impacts clock.  There is
> serdes in ADLink I-Pi SMARC board ethernet controller. Please refer to
> commit b9663b7ca6ff78 ("net: stmmac: Enable SERDES power up/down sequence=
")
> for detial. When issue is reproduced, DMA engine clock is not ready
> because serdes is not powered up.

I don't believe you got the error handling right.

> index 27b7bb64a028..41e71a26b1ad 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2907,6 +2907,15 @@ static int stmmac_open(struct net_device *dev)
>  		goto init_error;
>  	}
> =20
> +	if (priv->plat->serdes_powerup) {
> +		ret =3D priv->plat->serdes_powerup(dev, priv->plat->bsp_priv);
> +		if (ret < 0) {
> +			netdev_err(priv->dev, "%s: Serdes powerup failed\n",
> +				   __func__);
> +			goto init_error;
> +		}
> +	}

Ok, so serdes is powered up here.

>  	ret =3D stmmac_hw_setup(dev, true);
>  	if (ret < 0) {
>  		netdev_err(priv->dev, "%s: Hw setup failed\n",

But this goes to init_error, and exits w/o powering serdes down. Error
handling needs to be fixed AFAICT.

Best regards,
								Pavel
--
    echo 'DENX Software Engineering GmbH,      Managing Director: Wolfgang =
Denk'
    echo 'HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Ger=
many'

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYzwH+wAKCRAw5/Bqldv6
8kD0AKC1PZqySUpyok9Fn8lkj0b6roq4qQCgurqBtEAAoTZG96L0TSCt2D1M1Ys=
=v+0S
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
