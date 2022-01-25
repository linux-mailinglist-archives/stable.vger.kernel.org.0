Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362BF49B25A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 11:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376721AbiAYKu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 05:50:27 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55854 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376602AbiAYKrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 05:47:42 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BDB371C0B76; Tue, 25 Jan 2022 11:47:25 +0100 (CET)
Date:   Tue, 25 Jan 2022 11:47:25 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 262/563] uio: uio_dmem_genirq: Catch the Exception
Message-ID: <20220125104725.GA19281@duo.ucw.cz>
References: <20220124184024.407936072@linuxfoundation.org>
 <20220124184033.490683244@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20220124184033.490683244@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>=20
> [ Upstream commit eec91694f927d1026974444eb6a3adccd4f1cbc2 ]
>=20
> The return value of dma_set_coherent_mask() is not always 0.
> To catch the exception in case that dma is not support the mask.
>=20
> Fixes: 0a0c3b5a24bd ("Add new uio device for dynamic memory allocation")


> +++ b/drivers/uio/uio_dmem_genirq.c
> @@ -183,7 +183,11 @@ static int uio_dmem_genirq_probe(struct platform_dev=
ice *pdev)
>  		goto bad0;
>  	}
> =20
> -	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> +	ret =3D dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(&pdev->dev, "DMA enable failed\n");
> +		return ret;
> +	}

Handing errors is good, but you may not directly return here as it
would leak the resources. Something like this?

Signed-off-by: Pavel Machek <pavel@denx.de>

Best regards,
								Pavel

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index bf39a424ea77..7b80d0c02735 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -186,7 +186,7 @@ static int uio_dmem_genirq_probe(struct platform_device=
 *pdev)
 	ret =3D dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(&pdev->dev, "DMA enable failed\n");
-		return ret;
+		goto bad0;
 	}
=20
 	priv->uioinfo =3D uioinfo;



--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYe/VPQAKCRAw5/Bqldv6
8oUIAJ9/7cpk9jh44ON8YaFNToFokd9auQCfcVbS8avbK2Kv861oa1mJdPLGrI8=
=2Gqd
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
