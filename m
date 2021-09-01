Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D569F3FE33D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbhIATnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:43:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41884 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344117AbhIATnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 15:43:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DE8531C0B7F; Wed,  1 Sep 2021 21:42:36 +0200 (CEST)
Date:   Wed, 1 Sep 2021 21:42:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/103] ice: do not abort devlink info if board
 identifier cant be found
Message-ID: <20210901194236.GA8962@duo.ucw.cz>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.400339475@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20210901122301.400339475@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jacob Keller <jacob.e.keller@intel.com>
>=20
> [ Upstream commit a8f89fa27773a8c96fd09fb4e2f4892d794f21f6 ]
>=20
> The devlink dev info command reports version information about the
> device and firmware running on the board. This includes the "board.id"
> field which is supposed to represent an identifier of the board design.
> The ice driver uses the Product Board Assembly identifier for this.
>=20
> In some cases, the PBA is not present in the NVM. If this happens,
> devlink dev info will fail with an error. Instead, modify the
> ice_info_pba function to just exit without filling in the context
> buffer. This will cause the board.id field to be skipped. Log a dev_dbg
> message in case someone wants to confirm why board.id is not showing up
> for them.

Will it cause field to be skipped? I believe buffer will not be
initialized which will result in some confusion...

Best regards,
							Pavel

> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -23,7 +23,9 @@ static int ice_info_pba(struct ice_pf *pf, char *buf, s=
ize_t len)
> =20
>  	status =3D ice_read_pba_string(hw, (u8 *)buf, len);
>  	if (status)
> -		return -EIO;
> +		/* We failed to locate the PBA, so just skip this entry */
> +		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board Assembly stri=
ng, status %s\n",
> +			ice_stat_str(status));
> =20
>  	return 0;
>  }

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYS/XrAAKCRAw5/Bqldv6
8iKsAJ4rSW8qJZhHwStBU5di4R9xTrJCkACeOK1vtzuDDfZj6mgROfvT3pzz02A=
=zWv5
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
