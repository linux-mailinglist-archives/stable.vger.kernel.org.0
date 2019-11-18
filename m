Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD11100833
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfKRP0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:26:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35512 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbfKRP0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:26:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AC5F21C1802; Mon, 18 Nov 2019 16:25:58 +0100 (CET)
Date:   Mon, 18 Nov 2019 16:25:58 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 56/81] kernel/sysctl.c: do not override max_threads
 provided by userspace
Message-ID: <20191118152558.GA26236@duo.ucw.cz>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214842.621065901@linuxfoundation.org>
 <20191017105940.GA5966@amd>
 <20191017110516.GG24485@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20191017110516.GG24485@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Michal Hocko <mhocko@suse.com>
> > >=20
> > > commit b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40 upstream.
> > >=20
> > > Partially revert 16db3d3f1170 ("kernel/sysctl.c: threads-max observe
> > > limits") because the patch is causing a regression to any workload wh=
ich
> > > needs to override the auto-tuning of the limit provided by kernel.
> > >=20
> > > set_max_threads is implementing a boot time guesstimate to provide a
> > > sensible limit of the concurrently running threads so that runaways w=
ill
> > > not deplete all the memory.  This is a good thing in general but there
> > > are workloads which might need to increase this limit for an applicat=
ion
> > > to run (reportedly WebSpher MQ is affected) and that is simply not
> > > possible after the mentioned change.  It is also very dubious to
> > > override an admin decision by an estimation that doesn't have any dir=
ect
> > > relation to correctness of the kernel operation.
> > >=20
> > > Fix this by dropping set_max_threads from sysctl_max_threads so any
> > > value is accepted as long as it fits into MAX_THREADS which is import=
ant
> > > to check because allowing more threads could break internal robust fu=
tex
> > > restriction.  While at it, do not use MIN_THREADS as the lower bounda=
ry
> > > because it is also only a heuristic for automatic estimation and admin
> > > might have a good reason to stop new threads to be created even when
> > > below this limit.
> >=20
> > Ok, why not, but I smell followup work could be done:
> >=20
> > > @@ -2635,7 +2635,7 @@ int sysctl_max_threads(struct ctl_table
> > >  	if (ret || !write)
> > >  		return ret;
> > > =20
> > > -	set_max_threads(threads);
> > > +	max_threads =3D threads;
> > > =20
> >=20
> > AFAICT set_max_threads can now become __init.
>=20
> Yes. Care to send a patch?

I'm not usually hacking in that area. Could you do that?

> > Plus, I don't see any locking here, should this be WRITE_ONCE() at
> > minimum?
>=20
> Why would that matter? Do you expect several root processes race to set
> the value?

Well, for example to warn humans that this code is accessing unlocked
variable. Second, as is, code is not valid C and compilers are
allowed to do strange stuff ("undefined behaviour"). Third, there are
concurency checkers that will not like this one.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdK4BgAKCRAw5/Bqldv6
8jhNAKCIHYsvVTsQZIFjD8mF57s56P5jGQCeI6LKsnyR/vGN+ve0bAJx5KxTWF8=
=oWaa
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
