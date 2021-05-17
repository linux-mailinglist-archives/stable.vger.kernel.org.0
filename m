Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA16B3824DC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 08:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbhEQG6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 02:58:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49108 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbhEQG6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 02:58:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 27B081C0B79; Mon, 17 May 2021 08:57:17 +0200 (CEST)
Date:   Mon, 17 May 2021 08:57:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 380/530] udp: never accept GSO_FRAGLIST packets
Message-ID: <20210517065716.GA15967@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144832.263718249@linuxfoundation.org>
 <20210515083717.GD30461@amd>
 <2e1ffc55aedb5d10eacce34cb7a5809138528d03.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <2e1ffc55aedb5d10eacce34cb7a5809138528d03.camel@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Paolo Abeni <pabeni@redhat.com>
> > >=20
> > > [ Upstream commit 78352f73dc5047f3f744764cc45912498c52f3c9 ]
> > >=20
> > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > the sockets without the expected segmentation.
> > >=20
> > > This change addresses the issue introducing and maintaining
> > > a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> > > or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> > > accordingly.
> > >=20
> > > UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> > > zeroed.
> >=20
> > What is going on here? accept_udp_fraglist variable is read-only.
>=20
> Thank you for checking this!
>=20
> The 'accept_udp_fraglist' field is implicitly initilized to zero at UDP
> socket allocation time (done by sk_alloc).
>=20
> So this patch effectively force segmentation of SKB_GSO_FRAGLIST
> packets via the udp_unexpected_gso() helper.
>=20
> We introduce the above field instead of unconditionally
> segmenting SKB_GSO_FRAGLIST, because the next patch will use it (to
> avoid unneeded segmentation for performance's sake for UDP tunnel), as
> you noted.

Ok, but there's no follow up patch queued for 5.10...? Do we still
need it there?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCiE8wACgkQMOfwapXb+vKSSgCfeZuo7JR4uQEcDMFvMIhUOThF
NHgAoKG9x+sITu6mXb4M4mLem5qKlaV3
=ws9+
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
