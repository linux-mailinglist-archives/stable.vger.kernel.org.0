Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D4217930E
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgCDPNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:13:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57444 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgCDPNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 10:13:18 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 143A51C031D; Wed,  4 Mar 2020 16:13:17 +0100 (CET)
Date:   Wed, 4 Mar 2020 16:13:16 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 04/87] drm/msm: Set dma maximum segment size for mdss
Message-ID: <20200304151316.GA2367@duo.ucw.cz>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174349.401386271@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20200303174349.401386271@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Turning on CONFIG_DMA_API_DEBUG_SG results in the following error:
>=20
> [   12.078665] msm ae00000.mdss: DMA-API: mapping sg segment longer than =
device claims to support [len=3D3526656] [max=3D65536]
> [   12.089870] WARNING: CPU: 6 PID: 334 at
> /mnt/host/source/src/third_party/kernel/v4.19/kernel/dma/debug.c:1301
> debug_dma_map_sg+0x1dc/0x318

This one leaks resources in the (very improbable) case of error; it
needs to goto cleanup instead of simply returning.

> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -492,6 +492,14 @@ static int msm_drm_init(struct device *dev, struct d=
rm_driver *drv)
>  	if (ret)
>  		goto err_msm_uninit;
> =20
> +	if (!dev->dma_parms) {
> +		dev->dma_parms =3D devm_kzalloc(dev, sizeof(*dev->dma_parms),
> +					      GFP_KERNEL);
> +		if (!dev->dma_parms)
> +			return -ENOMEM;
> +	}
> +	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> +
>  	msm_gem_shrinker_init(ddev);
> =20

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXl/FjAAKCRAw5/Bqldv6
8rTIAJ4/hePVrpzv/17tNe4THoUwLxsNIQCgmmOuDfrbfxZjctYeTlR8ZcTce2s=
=f9d2
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
