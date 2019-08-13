Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21B8B737
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfHMLhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 07:37:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47542 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726600AbfHMLhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 07:37:39 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hxV7M-0007C4-Or; Tue, 13 Aug 2019 12:37:32 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hxV7M-0002gA-GJ; Tue, 13 Aug 2019 12:37:32 +0100
Message-ID: <8861ca0e9c4a171390b231941cd958189ca6ef33.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 043/157] ext4: brelse all indirect buffer 
 inext4_ind_remove_space()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Jari Ruusu <jariruusu@users.sourceforge.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Hulk Robot <hulkci@huawei.com>, Jan Kara <jack@suse.cz>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>
Date:   Tue, 13 Aug 2019 12:37:27 +0100
In-Reply-To: <5D523729.B7BF986@users.sourceforge.net>
References: <lsq.1565469607.761898531@decadent.org.uk>
         <5D523729.B7BF986@users.sourceforge.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-x6352Adav+lzE9GJZMu/"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-x6352Adav+lzE9GJZMu/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-13 at 07:06 +0300, Jari Ruusu wrote:
> Ben Hutchings wrote:
> > From: "zhangyi (F)" <yi.zhang@huawei.com>
> >=20
> > commit 674a2b27234d1b7afcb0a9162e81b2e53aeef217 upstream.
>=20
> [snip]
>=20
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -1481,10 +1481,14 @@ end_range:
> >                                            partial->p + 1,
> >                                            partial2->p,
> >                                            (chain+n-1) - partial);
> > -                       BUFFER_TRACE(partial->bh, "call brelse");
> > -                       brelse(partial->bh);
> > -                       BUFFER_TRACE(partial2->bh, "call brelse");
> > -                       brelse(partial2->bh);
> > +                       while (partial > chain) {
> > +                               BUFFER_TRACE(partial->bh, "call brelse"=
);
> > +                               brelse(partial->bh);
> > +                       }
> > +                       while (partial2 > chain2) {
> > +                               BUFFER_TRACE(partial2->bh, "call brelse=
");
> > +                               brelse(partial2->bh);
> > +                       }
> >                         return 0;
> >                 }
> >=20
>=20
> Above patch is really messed up. Alone that patch is livelocking
> and file system corrupting. Look at those new while loops. Once the
> while condition is true once, it is ALWAYS true, so it livelocks.

Thank you very much for this information.

> It absolutely needs follow-up patch from <yi.zhang@huawei.com>
> "ext4: cleanup bh release code in ext4_ind_remove_space()"
> upstream commit 5e86bdda41534e17621d5a071b294943cae4376e.
>=20
> For more info about how to trigger that bug, see this earlier email
>=20
> https://marc.info/?l=3Dlinux-kernel&m=3D155419973129522&w=3D2
>=20
> For 3.16 kernels you may need to set CONFIG_EXT4_USE_FOR_EXT23=3Dy
> so that ext4 code handles ext3 file systems.

As I want to release the update right now, I'll defer both of these.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson



--=-x6352Adav+lzE9GJZMu/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1SoPcACgkQ57/I7JWG
EQlMJg//W6aEnzB7UJEVpTqTkKayKeMrMjoKMV1KE+pzvoggh1QVopvFR1MoHk1T
41wwKsnQhqOchtMnay3jvW3X++2lcjREYa8ckFDz2bZxOKEHwnDyx/A+TAVmZFf5
vvn2PiV9NskLAPousCPMb/IFki6n9rM3nmYmyVwk8KmQCccX/drr6xItV9attkGI
UNF/nKoEmCqQ9XrEb3t34H4aytbHQO9MAGVQy7PHxD+XlfSpU61NTQDjOisvef/U
GxU6yVIGjhcaB/NT5x3tINMQok1G/NWmPiNkP3uAqdKQRQISpPh2SZ1lDRDI3XH1
/gdBjPtKfB6KTMA6OfRPnkZrrUUyvcOVsmjiJrUt941h0S7xMbXh9rMkxv28k6fc
0kHB8r9iwgbHH3MhWPKJ0YZeAaolSiFIAywAo/YZPnbQYDZWACtwcN+v78wVaUSw
21wFH4eksHqF4mwn57Fzip3IS6G2mMSZ2Yfz5RMg7Knr2lgm2xYZ+Ky+J5RkkFvh
8sVZp1OT5qtuVwnx6jVGgjATSP352ZD1ygVvMUpAePS6CpWIvwm0Xndx3JBIfXZm
DJ27DezImMDTpTZKFEcG9x3P4Ch3CUxvI1b/oqzqEQjncHRxbIIUhjPvGAkWUgci
xiADS7j+d+DwR3iGU07l3P5vS22oeYqY0T6IyzXpZbsL/iuF2/g=
=j5b8
-----END PGP SIGNATURE-----

--=-x6352Adav+lzE9GJZMu/--
