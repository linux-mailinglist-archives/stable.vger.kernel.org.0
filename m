Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F853E8AD3
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhHKHLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:11:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38240 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhHKHLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 03:11:30 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 39AF21C0B76; Wed, 11 Aug 2021 09:11:06 +0200 (CEST)
Date:   Wed, 11 Aug 2021 09:11:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 130/135] net: qede: Fix end of loop tests for
 list_for_each_entry
Message-ID: <20210811071105.GA10829@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.220428504@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20210810173000.220428504@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 795e3d2ea68e489ee7039ac29e98bfea0e34a96c ]
>=20
> The list_for_each_entry() iterator, "vlan" in this code, can never be
> NULL so the warning will never be printed.

Could someone double-check this? Because changelog is not accurate;
condition is using logical or, so warning can be printed. I don't
really see a bug with the old code.

New code is quite confusing, and if the vlan with required vic is the
"head" one, it will do the wrong thing, no?

Best regards,
								Pavel

> +++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
> @@ -842,7 +842,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __b=
e16 proto, u16 vid)
>  		if (vlan->vid =3D=3D vid)
>  			break;
> =20
> -	if (!vlan || (vlan->vid !=3D vid)) {
> +	if (list_entry_is_head(vlan, &edev->vlan_list, list)) {
>  		DP_VERBOSE(edev, (NETIF_MSG_IFUP | NETIF_MSG_IFDOWN),
>  			   "Vlan isn't configured\n");
>  		goto out;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRN4CQAKCRAw5/Bqldv6
8oWdAJ40iXM9RWRnOMRdz8yoM9pxCKWjkwCggWdRY9om8nbfaB+K0uxa/hDiFSE=
=AuQV
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
