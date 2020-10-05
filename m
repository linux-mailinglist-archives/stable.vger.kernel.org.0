Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9082841DA
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 22:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgJEU7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 16:59:16 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56674 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgJEU7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 16:59:16 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 460E61C0B7C; Mon,  5 Oct 2020 22:59:13 +0200 (CEST)
Date:   Mon, 5 Oct 2020 22:59:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4.19 38/38] netfilter: ctnetlink: add a range check for
 l3/l4 protonum
Message-ID: <20201005205912.GB27782@amd>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142110.510691312@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <20201005142110.510691312@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Will McVicker <willmcvicker@google.com>
>=20
> commit 1cc5ef91d2ff94d2bf2de3b3585423e8a1051cb6 upstream.
>=20
> The indexes to the nf_nat_l[34]protos arrays come from userspace. So
> check the tuple's family, e.g. l3num, when creating the conntrack in
> order to prevent an OOB memory access during setup.  Here is an example
> kernel panic on 4.14.180 when userspace passes in an index greater than
> NFPROTO_NUMPROTO.

Since this protects against OOB array access, should it use _nospec()
variant to protect from speculation attacks?

Best regards,
								Pavel

> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlatt
>  	if (!tb[CTA_TUPLE_IP])
>  		return -EINVAL;
> =20
> +	if (l3num !=3D NFPROTO_IPV4 && l3num !=3D NFPROTO_IPV6)
> +		return -EOPNOTSUPP;
>  	tuple->src.l3num =3D l3num;
> =20
>  	err =3D ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl97iSAACgkQMOfwapXb+vLMjACfeSXSr3aLcuqvi3ECFUw/TmMO
NjMAnRrl6xkIoDP5f9hWcptslinge78f
=0g3X
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
