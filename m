Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B00201CD5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 23:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391558AbgFSVEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 17:04:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50318 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389872AbgFSVEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 17:04:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0CCB51C0C0D; Fri, 19 Jun 2020 23:04:33 +0200 (CEST)
Date:   Fri, 19 Jun 2020 23:04:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 172/267] net: ethernet: fec: move GPR register
 offset and bit into DT
Message-ID: <20200619210432.GA12233@amd>
References: <20200619141648.840376470@linuxfoundation.org>
 <20200619141657.046148582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20200619141657.046148582@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 8a448bf832af537d26aa557d183a16943dce4510 ]
>=20
> The commit da722186f654 (net: fec: set GPR bit on suspend by DT
> configuration) set the GPR reigster offset and bit in driver for
> wake on lan feature.
>=20
> But it introduces two issues here:
> - one SOC has two instances, they have different bit
> - different SOCs may have different offset and bit
>=20
> So to support wake-on-lan feature on other i.MX platforms, it should
> configure the GPR reigster offset and bit from DT.

Ok, so this really is not a bugfix.

Plus, it really depends on dts changes...

> --- a/drivers/net/ethernet/freescale/fec_main.c
>  {
>  	struct device_node *gpr_np;
> +	u32 out_val[3];
>  	int ret =3D 0;
> =20
> -	if (!dev_info)
> -		return 0;
> -
> -	gpr_np =3D of_parse_phandle(np, "gpr", 0);
> +	gpr_np =3D of_parse_phandle(np, "fsl,stop-mode", 0);
>  	if (!gpr_np)
>  		return 0;
>

=2E..and those changes are not present in v4.19. There's no
fsl,stop-mode in v4.19, unlike mainline.

pavel@amd:~/cip/krc$ grep -ri fsl,stop-mode arch/arm*/boot/dts
pavel@amd:~/cip/krc$

This will break driver for everyone, AFAICT. Please drop it from
stable.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7tKGAACgkQMOfwapXb+vJY9QCgrJN07DIvUE0C26aaYsv9tyi8
IEkAn0lNnHwYtQ+QE0pz97c+xF0gF9dD
=LJx4
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
