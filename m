Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5C13FE900
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 07:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhIBF5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 01:57:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50534 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbhIBF5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 01:57:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1057C1C0BA1; Thu,  2 Sep 2021 07:56:36 +0200 (CEST)
Date:   Thu, 2 Sep 2021 07:56:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/103] ice: do not abort devlink info if board
 identifier cant be found
Message-ID: <20210902055635.GA17629@duo.ucw.cz>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.400339475@linuxfoundation.org>
 <20210901194236.GA8962@duo.ucw.cz>
 <20210901201046.GC8962@duo.ucw.cz>
 <8168c579-9ba7-2c31-42b3-9ad88760110a@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <8168c579-9ba7-2c31-42b3-9ad88760110a@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>> The devlink dev info command reports version information about the
> >>> device and firmware running on the board. This includes the "board.id"
> >>> field which is supposed to represent an identifier of the board desig=
n.
> >>> The ice driver uses the Product Board Assembly identifier for this.
> >>>
> >>> In some cases, the PBA is not present in the NVM. If this happens,
> >>> devlink dev info will fail with an error. Instead, modify the
> >>> ice_info_pba function to just exit without filling in the context
> >>> buffer. This will cause the board.id field to be skipped. Log a dev_d=
bg
> >>> message in case someone wants to confirm why board.id is not showing =
up
> >>> for them.
> >>
> >> Will it cause field to be skipped? I believe buffer will not be
> >> initialized which will result in some confusion...
> >=20
> > IOW I believe this is good idea.
>=20
> It's not necessary, but I agree its not obvious without the full
> context. The caller of ice_info_pba memsets the buffer before calling
> each info reporter. Its already a known semantics that leaving the
> buffer alone will skip the entry.
>=20
> See the code below for what we do.
>=20
> >                 memset(ctx->buf, 0, sizeof(ctx->buf));
> >=20
> >                 err =3D ice_devlink_versions[i].getter(pf, ctx);
> >                 if (err) {
> >                         NL_SET_ERR_MSG_MOD(extack, "Unable to obtain ve=
rsion info");
> >                         goto out_free_ctx;
> >                 }

That memset is not present in 5.10 I was reviewing. I agree that
backporting the memset to 5.10 is better then my patch.

> We memset the buffer, call the getter, and if that doesn't modify the
> buffer, we call the fallack, and then check again if its still empty.
>=20
> Because we memset each time, we don't need to assign *buf =3D 0.
>=20
> I guess its more clear that we're doing the correct thing here, but
> these functions are build-for-purpose to use as pointers in this API and
> aren't public, so I think it is fine to leave it as is.

Yes, code is okay in mainline, but the memset is not present in
5.10-stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYTBnkwAKCRAw5/Bqldv6
8tEyAJ9PNrc5497CjlPnJuiOG+D4+LsLmACgpcGl1owPvR5qQtMEucZrXP90e0g=
=8Mxd
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
