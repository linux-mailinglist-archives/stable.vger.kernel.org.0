Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCBA3DDEAF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhHBRkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 13:40:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50402 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhHBRky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 13:40:54 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B81B11C0B76; Mon,  2 Aug 2021 19:40:43 +0200 (CEST)
Date:   Mon, 2 Aug 2021 19:40:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 45/67] octeontx2-pf: Fix interface down flag on error
Message-ID: <20210802174042.GA26978@amd>
References: <20210802134339.023067817@linuxfoundation.org>
 <20210802134340.561715991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20210802134340.561715991@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This patch fixes the issue by setting the INTF_DOWN flag on
> error and free the resources in otx2_stop only if the flag is
> not set.

Ok.

ernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 662fb80dbb9d..c6d408de0605 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -230,15 +230,14 @@ static int otx2_set_channels(struct net_device *dev,
>  	err =3D otx2_set_real_num_queues(dev, channel->tx_count,
>  				       channel->rx_count);
>  	if (err)
> -		goto fail;
> +		return err;
>

But with the new flag, this change is not neccessary, right?

Plus, it will lead to surprising result of otx2_set_channels() downing
interface on failure, no?

>  	pfvf->hw.rx_queues =3D channel->rx_count;
>  	pfvf->hw.tx_queues =3D channel->tx_count;
>  	pfvf->qset.cq_cnt =3D pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
> =20
> -fail:
>  	if (if_up)
> -		dev->netdev_ops->ndo_open(dev);
> +		err =3D dev->netdev_ops->ndo_open(dev);

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEILhoACgkQMOfwapXb+vKktQCfe506Iq2SZQREkipDcqLbyZlj
fNEAni6O4PzXunUBbIBzyuea7ULK5bZn
=XtTo
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
