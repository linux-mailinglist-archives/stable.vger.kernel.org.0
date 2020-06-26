Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F402520B1C0
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgFZMxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 08:53:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:32918 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgFZMxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 08:53:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1843A1C0BD2; Fri, 26 Jun 2020 14:53:51 +0200 (CEST)
Date:   Fri, 26 Jun 2020 14:53:50 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 023/206] PCI: aardvark: Dont blindly enable ASPM L0s
 and dont write to read-only register
Message-ID: <20200626125350.GA29985@duo.ucw.cz>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195318.115434987@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20200623195318.115434987@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 90c6cb4a355e7befcb557d217d1d8b8bd5875a05 ]
>=20
> Trying to change Link Status register does not have any effect as this
> is a read-only register. Trying to overwrite bits for Negotiated Link
> Width does not make sense.

I don't quite get it. This says register is read only...

> In future proper change of link width can be done via Lane Count Select
> bits in PCIe Control 0 register.
>=20
> Trying to unconditionally enable ASPM L0s via ASPM Control bits in Link
> Control register is wrong. There should be at least some detection if
> endpoint supports L0s as isn't mandatory.

=2E...and this says it is wrong to set the bits as ASPM L0 is not
mandatory.

> +++ b/drivers/pci/controller/pci-aardvark.c
> @@ -321,10 +321,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pci=
e)
> =20
>  	advk_pcie_wait_for_link(pcie);
> =20
> -	reg =3D PCIE_CORE_LINK_L0S_ENTRY |
> -		(1 << PCIE_CORE_LINK_WIDTH_SHIFT);
> -	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
> -
>  	reg =3D advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
>  	reg |=3D PCIE_CORE_CMD_MEM_ACCESS_EN |
>  		PCIE_CORE_CMD_IO_ACCESS_EN |

=2E..but we only do single write.

So which is it?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvXv3gAKCRAw5/Bqldv6
8uDQAJ4v6dHV/UgcrjwxOxeOYz/91bBkNACeO9nnJMZcVFUcquKh7mEu2tEYJCI=
=V7UJ
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
