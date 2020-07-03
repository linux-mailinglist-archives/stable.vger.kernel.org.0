Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A938213FDB
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 21:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGCTVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 15:21:09 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51470 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCTVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 15:21:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E91E01C0BD2; Fri,  3 Jul 2020 21:21:06 +0200 (CEST)
Date:   Fri, 3 Jul 2020 21:21:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4.19 119/131] tracing: Fix event trigger to accept
 redundant spaces
Message-ID: <20200703192102.GA31738@amd>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-120-sashal@kernel.org>
 <20200702211728.GD5787@amd>
 <20200703060439.GB6344@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20200703060439.GB6344@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > commit 6784beada631800f2c5afd567e5628c843362cee upstream.
> > >=20
> > > Fix the event trigger to accept redundant spaces in
> > > the trigger input.
> > >=20
> > > For example, these return -EINVAL
> > >=20
> > > echo " traceon" > events/ftrace/print/trigger
> > > echo "traceon  if common_pid =3D=3D 0" > events/ftrace/print/trigger
> > > echo "disable_event:kmem:kmalloc " > events/ftrace/print/trigger
> > >=20
> > > But these are hard to find what is wrong.
> > >=20
> > > To fix this issue, use skip_spaces() to remove spaces
> > > in front of actual tokens, and set NULL if there is no
> > > token.
> >=20
> > For the record, I'm not fan of this one. It is ABI change, not a
> > bugfix.
> >=20
> > Yes, it makes kernel interface "easier to use". It also changes
> > interface in the middle of stable series, and if people start relying
> > on new interface and start putting extra spaces, they'll get nasty
> > surprise when they move code to the older kernel.
>=20
> If an interface changes anywhere that breaks userspace, it needs to be
> not done, stable kernels are not an issue here or not.

I'm not saying it is a regression; I'd scream way more if that was the
case. I'm saying it is nowhere near a fix.

We really don't want userspace doing:

> > > echo " traceon" > events/ftrace/print/trigger

Because it does not work on older kernels. It will work on 4.19.131
and break on 5.6.19.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7/hR4ACgkQMOfwapXb+vKmYwCghKkPCwuF8Pk0V5QFUxPxyy/5
CWEAnj9xFfErmFoPgeAdx9X9x2gN3LFG
=UJ3w
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
