Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE60F102EB8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 22:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfKSV6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 16:58:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34782 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfKSV6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 16:58:47 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8EFDB1C1998; Tue, 19 Nov 2019 22:58:45 +0100 (CET)
Date:   Tue, 19 Nov 2019 22:58:44 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Honghui Zhang <honghui.zhang@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 242/422] PCI: mediatek: Fix unchecked return value
Message-ID: <20191119215844.GB4495@amd>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051414.700418537@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20191119051414.700418537@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Tue 2019-11-19 06:17:19, Greg Kroah-Hartman wrote:

>=20
> [ Upstream commit 17a0a1e5f6c4bd6df17834312ff577c1373d87b8 ]
>=20
> Check return value of devm_pci_remap_iospace().
>=20
> index c5ff6ca65eab2..0d100f56cb884 100644
> --- a/drivers/pci/controller/pcie-mediatek.c
> +++ b/drivers/pci/controller/pcie-mediatek.c
> @@ -1120,7 +1120,9 @@ static int mtk_pcie_request_resources(struct mtk_pc=
ie *pcie)
>  	if (err < 0)
>  		return err;
> =20
> -	devm_pci_remap_iospace(dev, &pcie->pio, pcie->io.start);
> +	err =3D devm_pci_remap_iospace(dev, &pcie->pio, pcie->io.start);
> +	if (err)
> +		return err;
> =20
>  	return 0;
>  }

You can just do return devm_pci_remap_iospace(dev, &pcie->pio,
pcie->io.start); instead. No need for if ()...

Best regards,
							Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3UZZQACgkQMOfwapXb+vK0QACfXZTdiE8wGbfw4CEh5iP/vG0F
lmMAoK5jg7QR4jsfuIQ4YIllXnxMHCGX
=eoZO
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
