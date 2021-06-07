Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859D239E9B2
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 00:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFGWks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 18:40:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59988 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhFGWkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 18:40:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D8B071C0B76; Tue,  8 Jun 2021 00:38:54 +0200 (CEST)
Date:   Tue, 8 Jun 2021 00:38:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Subject: 4.19 queue: netfilter: conntrack: unregister ipv4 sockopts on error
 unwind
Message-ID: <20210607223854.GA12130@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

That patch is wrong for 4.19. Wrong version is 066585c43 in stable
queue.

    netfilter: conntrack: unregister ipv4 sockopts on error unwind

    [ Upstream commit 22cbdbcfb61acc78d5fc21ebb13ccc0d7e29f793 ]

    When ipv6 sockopt register fails, the ipv4 one needs to be
    removed.

=2E..

+++ b/net/netfilter/nf_conntrack_proto.c
@@ -962,7 +962,7 @@ int nf_conntrack_proto_init(void)
 nf_unregister_sockopt(&so_getorigdst);
 #if IS_ENABLED(CONFIG_IPV6)
cleanup_sockopt:
 -       nf_unregister_sockopt(&so_getorigdst6);
 +       nf_unregister_sockopt(&so_getorigdst);
 #endif
 return ret;

Note the context. cleanup_sockopt2: needs to do
nf_unregister_sockopt(&so_getorigdst6);, otherwise we end up
unregistering the same pointer twice.

(AFAICT it is ok in mainline and 5.10).

Best regards,
								Pavel
		  =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC+n/0ACgkQMOfwapXb+vIx2ACghpD3SphWpGXmuP2cR5+xG3ZQ
cK0AmwYDfSDg7YLowTFMotWwV9E2aXBX
=xiZC
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
