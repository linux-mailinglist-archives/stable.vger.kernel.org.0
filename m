Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC6340598
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 13:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCRMfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 08:35:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52158 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCRMei (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 08:34:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 32A641C0B7D; Thu, 18 Mar 2021 13:34:36 +0100 (CET)
Date:   Thu, 18 Mar 2021 13:34:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 041/290] net: enetc: force the RGMII speed and
 duplex instead of operating in inband mode
Message-ID: <20210318123435.GA8812@duo.ucw.cz>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135543.317947345@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20210315135543.317947345@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> It has been reported that RGMII is broken in fixed-link, and that is not
> surprising considering the fact that no PHY is attached to the MAC in
> that case, but a switch.

Okay, but there's something wrong in the code.

> This brings us to the topic of the patch: the enetc driver should have
> not enabled the optional in-band status signaling for RGMII unconditional=
ly,
> but should have forced the speed and duplex to what was resolved by
> phylink.

> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -494,13 +494,20 @@ static void enetc_configure_port_mac(str
> =20
>  static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mo=
de)
>  {
=2E..
> +	u32 val;
> +
> +	if (phy_interface_mode_is_rgmii(phy_mode)) {
> +		val =3D enetc_port_rd(hw, ENETC_PM0_IF_MODE);
> +		val &=3D ~ENETC_PM0_IFM_EN_AUTO;
> +		val &=3D ENETC_PM0_IFM_IFMODE_MASK;
> +		val |=3D ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
> +		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
> +	}

val clears ENETC_PM0_IFM_EN_AUTO bit, then the bit is cleared again,
preserving just IFMODE bits, then ors the IFMODE bits with new values.

I believe this is needed:

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
									Pavel

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_pf.c
index 83187cd59fdd..446ad4c43fab 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -499,7 +499,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_i=
nterface_t phy_mode)
 	if (phy_interface_mode_is_rgmii(phy_mode)) {
 		val =3D enetc_port_rd(hw, ENETC_PM0_IF_MODE);
 		val &=3D ~ENETC_PM0_IFM_EN_AUTO;
-		val &=3D ENETC_PM0_IFM_IFMODE_MASK;
+		val &=3D ~ENETC_PM0_IFM_IFMODE_MASK;
 		val |=3D ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
 	}


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYFNI2wAKCRAw5/Bqldv6
8rfmAKC+2NLtn0Ev4aQO2XeCotEz714UeACgwwExRyN/HyzwIze9/gxKal/+z8U=
=wAOP
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
