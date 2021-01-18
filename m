Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766C92FADD6
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 00:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbhARXoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 18:44:03 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36962 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbhARXny (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 18:43:54 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BEE641C0B87; Tue, 19 Jan 2021 00:42:55 +0100 (CET)
Date:   Tue, 19 Jan 2021 00:42:55 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5.10 045/152] dm crypt: use GFP_ATOMIC when allocating
 crypto requests from softirq
Message-ID: <20210118234255.GA22058@duo.ucw.cz>
References: <20210118113352.764293297@linuxfoundation.org>
 <20210118113354.944646657@linuxfoundation.org>
 <20210118224431.GA26685@amd>
 <CALrw=nEgtxS_SDOP5+T0u6XZ74Hcr451L_d5QdUwDHi7ZaLQ6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <CALrw=nEgtxS_SDOP5+T0u6XZ74Hcr451L_d5QdUwDHi7ZaLQ6w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > -static void crypt_alloc_req_aead(struct crypt_config *cc,
> > > +static int crypt_alloc_req_aead(struct crypt_config *cc,
> > >                                struct convert_context *ctx)
> > >  {
> > > -     if (!ctx->r.req_aead)
> > > -             ctx->r.req_aead =3D mempool_alloc(&cc->req_pool, GFP_NO=
IO);
> > > +     if (!ctx->r.req) {
> > > +             ctx->r.req =3D mempool_alloc(&cc->req_pool, in_interrup=
t() ? GFP_ATOMIC : GFP_NOIO);
> > > +             if (!ctx->r.req)
> > > +                     return -ENOMEM;
> > > +     }
> >
> > But this one can't be good. We are now allocating different field in
> > the structure!
>=20
> Good catch! Sorry for the copy-paste. It is actually not a big deal,
> because this is not a structure, but a union:
> as long as the mempool was initialized with the correct size, it
> should be no different.

Ah. I actually thought about unions and went back to definition to see
if it is one, but was somehow blind for the moment.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYAYc/wAKCRAw5/Bqldv6
8kTHAKCvsMv3ntskMEOymJKiRe2ow7FWUQCfXxKfy10YpSK4kjXcsOW7wW7NcL8=
=masm
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
