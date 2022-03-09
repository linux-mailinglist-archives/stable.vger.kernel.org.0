Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6930F4D2D80
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 11:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiCIKz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 05:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiCIKz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 05:55:26 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458D611D789;
        Wed,  9 Mar 2022 02:54:22 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 873DC1C0B77; Wed,  9 Mar 2022 11:54:20 +0100 (CET)
Date:   Wed, 9 Mar 2022 11:54:20 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 012/105] dmaengine: shdma: Fix runtime PM imbalance
 on error
Message-ID: <20220309105420.GA22677@duo.ucw.cz>
References: <20220307091644.179885033@linuxfoundation.org>
 <20220307091644.529997660@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20220307091644.529997660@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Yongzhi Liu <lyz_cs@pku.edu.cn>
>=20
> [ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]
>=20
> pm_runtime_get_() increments the runtime PM usage counter even
> when it returns an error code, thus a matching decrement is needed on
> the error handling path to keep the counter balanced.

This patch will break things.

Notice that -ret is ignored (checked 4.4 and 5.10), so we don't
actually abort/return error; we just printk. We'll do two
pm_runtime_put's after the "fix".

Please drop from -stable.

It was discussed during AUTOSEL review:

Date: Fri, 25 Feb 2022 14:25:10 +0800 (GMT+08:00)
=46rom: =E5=88=98=E6=B0=B8=E5=BF=97 <lyz_cs@pku.edu.cn>
To: pavel machek <pavel@denx.de>
Cc: sasha levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
	imbalance on error

Best regards,
	                                                        Pavel

> +++ b/drivers/dma/sh/shdma-base.c
> @@ -115,8 +115,10 @@ static dma_cookie_t shdma_tx_submit(struct dma_async=
_tx_descriptor *tx)
>  		ret =3D pm_runtime_get(schan->dev);
> =20
>  		spin_unlock_irq(&schan->chan_lock);
> -		if (ret < 0)
> +		if (ret < 0) {
>  			dev_err(schan->dev, "%s(): GET =3D %d\n", __func__, ret);
> +			pm_runtime_put(schan->dev);
> +		}
> =20
>  		pm_runtime_barrier(schan->dev);
> =20
> --=20
> 2.34.1
>=20
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYiiHXAAKCRAw5/Bqldv6
8ombAJ9B/Wg0wRqXoPkjSCwo7F7TehDIMACfYKFLokbbzHMu0fScRKa2kKDNstA=
=H7B2
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
