Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACA831075B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 10:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBEJKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 04:10:31 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58036 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhBEJHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 04:07:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 223F61C0B79; Fri,  5 Feb 2021 10:07:00 +0100 (CET)
Date:   Fri, 5 Feb 2021 10:06:59 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <20210205090659.GA22517@amd>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <YBu1d0+nfbWGfMtj@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2021-02-04 09:51:03, Greg Kroah-Hartman wrote:
> On Thu, Feb 04, 2021 at 08:26:04AM +0100, Jiri Slaby wrote:
> > On 04. 02. 21, 7:20, Greg Kroah-Hartman wrote:
> > > On Thu, Feb 04, 2021 at 05:59:42AM +0000, Jari Ruusu wrote:
> > > > Greg,
> > > > I hope that your linux kernel release scripts are
> > > > implemented in a way that understands that PATCHLEVEL=3D and
> > > > SUBLEVEL=3D numbers in top-level linux Makefile are encoded
> > > > as 8-bit numbers for LINUX_VERSION_CODE and
> > > > KERNEL_VERSION() macros, and must stay in range 0...255.
> > > > These 8-bit limits are hardcoded in both kernel source and
> > > > userspace ABI.
> > > >=20
> > > > After 4.9.255 and 4.4.255, your scripts should be
> > > > incrementing a number in EXTRAVERSION=3D in top-level
> > > > linux Makefile.
> > >=20
> > > Should already be fixed in linux-next, right?
> >=20
> > I assume you mean:
> > commit 537896fabed11f8d9788886d1aacdb977213c7b3
> > Author: Sasha Levin <sashal@kernel.org>
> > Date:   Mon Jan 18 14:54:53 2021 -0500
> >=20
> >     kbuild: give the SUBLEVEL more room in KERNEL_VERSION
> >=20
> > That would IMO break userspace as definition of kernel version has chan=
ged.
> > And that one is UAPI/ABI (see include/generated/uapi/linux/version.h) as
> > Jari writes. For example will glibc still work:
> > http://sourceware.org/git/?p=3Dglibc.git;a=3Dblob;f=3Dsysdeps/unix/sysv=
/linux/configure.ac;h=3D13abda0a51484c5951ffc6d718aa36b72f3a9429;hb=3DHEAD#=
l14
> >=20
> > ? Or gcc 10 (11 will have this differently):
> > https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dblob;f=3Dgcc/config/bpf/bpf.c;=
hb=3Dee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l165
> >=20
> > and
> >=20
> > https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dblob;f=3Dgcc/config/bpf/bpf-he=
lpers.h;hb=3Dee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l53
>=20
> Ugh, I thought this was an internal representation, not an external one
> :(
>=20
> > It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + =
Z)
> > assumptions all around the world. So this doesn't look like a good idea.
>=20
> Ok, so what happens if we "wrap"?  What will break with that?  At first
> glance, I can't see anything as we keep the padding the same, and our
> build scripts seem to pick the number up from the Makefile and treat it
> like a string.
>=20
> It's only the crazy out-of-tree kernel stuff that wants to do minor
> version checks that might go boom.  And frankly, I'm not all that
> concerned if they have problems :)
>=20
> So, let's leave it alone and just see what happens!

Yeah, stable is a great place to do the experiments. Not that this is
the first time :-(.
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAdCrMACgkQMOfwapXb+vLjngCaAjjD5mUF+Nb1LcxkIk7LgvKS
A7EAoI2Ulw6+CpcR2hYtxNEtEBLeN6Te
=NBbj
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
