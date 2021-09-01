Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1E63FE38D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhIAULp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:11:45 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46236 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhIAULp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 16:11:45 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 928ED1C0B7F; Wed,  1 Sep 2021 22:10:46 +0200 (CEST)
Date:   Wed, 1 Sep 2021 22:10:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/103] ice: do not abort devlink info if board
 identifier cant be found
Message-ID: <20210901201046.GC8962@duo.ucw.cz>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.400339475@linuxfoundation.org>
 <20210901194236.GA8962@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <20210901194236.GA8962@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > The devlink dev info command reports version information about the
> > device and firmware running on the board. This includes the "board.id"
> > field which is supposed to represent an identifier of the board design.
> > The ice driver uses the Product Board Assembly identifier for this.
> >=20
> > In some cases, the PBA is not present in the NVM. If this happens,
> > devlink dev info will fail with an error. Instead, modify the
> > ice_info_pba function to just exit without filling in the context
> > buffer. This will cause the board.id field to be skipped. Log a dev_dbg
> > message in case someone wants to confirm why board.id is not showing up
> > for them.
>=20
> Will it cause field to be skipped? I believe buffer will not be
> initialized which will result in some confusion...

IOW I believe this is good idea.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/eth=
ernet/intel/ice/ice_devlink.c
index f18ce43b7e74..7034704b1b50 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -22,10 +22,12 @@ static int ice_info_pba(struct ice_pf *pf, char *buf, s=
ize_t len)
 	enum ice_status status;
=20
 	status =3D ice_read_pba_string(hw, (u8 *)buf, len);
-	if (status)
+	if (status) {
+		*buf =3D 0;
 		/* We failed to locate the PBA, so just skip this entry */
 		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board Assembly string=
, status %s\n",
 			ice_stat_str(status));
+	}
=20
 	return 0;
 }

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYS/eRgAKCRAw5/Bqldv6
8rD3AJ4v++4A3ckn6ERC+g7sW3FQ+A3Y7gCfR2/DnUejV0yQt6WJDIUuLpb4Ng0=
=Ok0J
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
