Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E2A3BA937
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 17:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhGCPYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 11:24:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39214 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhGCPYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 11:24:54 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4C3431C0B81; Sat,  3 Jul 2021 17:22:19 +0200 (CEST)
Date:   Sat, 3 Jul 2021 17:22:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 055/101] net: ll_temac: Add memory-barriers for TX
 BD access
Message-ID: <20210703152218.GD3004@amd>
References: <20210628142607.32218-1-sashal@kernel.org>
 <20210628142607.32218-56-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline
In-Reply-To: <20210628142607.32218-56-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add a couple of memory-barriers to ensure correct ordering of read/write
> access to TX BDs.

So... this is dealing with CPU-to-device consistency, not CPU-to-CPU,
right?

> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -774,12 +774,15 @@ static void temac_start_xmit_done(struct net_device=
 *ndev)
>  	stat =3D be32_to_cpu(cur_p->app0);
> =20
>  	while (stat & STS_CTRL_APP0_CMPLT) {
> +		/* Make sure that the other fields are read after bd is
> +		 * released by dma
> +		 */
> +		rmb();
>  		dma_unmap_single(ndev->dev.parent,

Full barrier, as expected.

> @@ -788,6 +791,12 @@ static void temac_start_xmit_done(struct net_device =
*ndev)
>  		ndev->stats.tx_packets++;
>  		ndev->stats.tx_bytes +=3D be32_to_cpu(cur_p->len);
> =20
> +		/* app0 must be visible last, as it is used to flag
> +		 * availability of the bd
> +		 */
> +		smp_mb();

SMP-only barrier, but full barrier is needed here AFAICT.

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDggKoACgkQMOfwapXb+vLB9QCgjq4eIi/uFYHs2xZAShWTlO9G
WMIAn3jtHyDFjeYsVzCIwEmzWCcIKzHA
=R+tk
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
