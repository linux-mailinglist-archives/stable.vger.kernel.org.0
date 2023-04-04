Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477876D5EED
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjDDL1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDDL1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:27:03 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A07195
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:27:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 678471C0E01; Tue,  4 Apr 2023 13:27:01 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:27:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 051/173] net: dsa: mt7530: move setting ssc_delta to
 PHY_INTERFACE_MODE_TRGMII case
Message-ID: <ZCwJhAfrTIPorVTw@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.096716862@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xL+ikprMmmbWsSJq"
Content-Disposition: inline
In-Reply-To: <20230403140416.096716862@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xL+ikprMmmbWsSJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]
>=20
> Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_TRGMII
> case as it's only needed when trgmii is used.

This one is very wrong for 5.10. ssc_delta is unconditionally used
below, and it will not use uninitialized variable.

(In mainline, that code is protected by if (trgint), so it does not
have this problem).

Best regards,
								Pavel

> +++ b/drivers/net/dsa/mt7530.c
> @@ -403,6 +403,10 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_inte=
rface_t interface)
>  		break;
>  	case PHY_INTERFACE_MODE_TRGMII:
>  		trgint =3D 1;
> +		if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
> +			ssc_delta =3D 0x57;
> +		else
> +			ssc_delta =3D 0x87;
>  		if (priv->id =3D=3D ID_MT7621) {
>  			/* PLL frequency: 150MHz: 1.2GBit */
>  			if (xtal =3D=3D HWTRAP_XTAL_40MHZ)
> @@ -422,11 +426,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_inte=
rface_t interface)
>  		return -EINVAL;
>  	}
> =20
> -	if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
> -		ssc_delta =3D 0x57;
> -	else
> -		ssc_delta =3D 0x87;
> -
>  	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
>  		   P6_INTF_MODE(trgint));
> =20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--xL+ikprMmmbWsSJq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwJhAAKCRAw5/Bqldv6
8mYeAJ4w3zv0OY2gBX4ssOR3SzI65IpJTACfWhRCc5Ju6H5SdLg1JjYI0QN+5+o=
=AvMh
-----END PGP SIGNATURE-----

--xL+ikprMmmbWsSJq--
