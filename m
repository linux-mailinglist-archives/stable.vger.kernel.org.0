Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4E11EAC2
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 19:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbfLMS5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 13:57:17 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:53798 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbfLMS5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 13:57:17 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 03D531C25CF; Fri, 13 Dec 2019 19:57:14 +0100 (CET)
Date:   Fri, 13 Dec 2019 19:57:14 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: Re: Regression from "mm/vmalloc: Sync unmappings in
 __purge_vmap_area_lazy()" in stable kernels
Message-ID: <20191213185714.GA25552@duo.ucw.cz>
References: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'd like to report a very severe performance regression due to
>=20
>     mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy() in stable ker=
nels
>=20
> in v4.19.88. I believe this was included since v4.19.67. It is also
> in all the other LTS kernels, except 3.16.
>=20
> So today I switched an x86_64 production server from v5.1.21 to
> v4.19.88, because we kept hitting runaway kcompactd and kswapd.
> Plus there was a significant increase in memory usage compared to
> v5.1.5. I'm still bisecting that on another production server.
>=20
> The service we run is one of the largest forums in Taiwan [1].
> It is a terminal-based bulletin board system running over telnet,
> SSH or a custom WebSocket bridge. The service itself is the
> one-process-per-user type of design from the old days. This
> means a lot of forks when there are user spikes or reconnections.

Sounds like fun :-).

I noticed that there's something vmalloc-related in 4.19.89,

Subject: [PATCH 4.19 210/243] x86/mm/32: Sync only to VMALLOC_END in
        vmalloc_sync_all()
=46rom: Joerg Roedel <jroedel@suse.de>
commit 9a62d20027da3164a22244d9f022c0c987261687 upstream.

But looking at the changelog again, it may not solve the performance
problem.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfPfCgAKCRAw5/Bqldv6
8hujAJ9vgAJZWY/9o6p4g+ok6VuXj5Y6DACgt1Ce95fPuPcqH5mdNPXquxUCpYc=
=sVge
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
