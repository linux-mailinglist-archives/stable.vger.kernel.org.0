Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F312DF2A
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 15:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgAAOob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 09:44:31 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:32404 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgAAOob (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 09:44:31 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 47nv7v6kC5zQlCT;
        Wed,  1 Jan 2020 15:44:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id gxnyw7SGBm-n; Wed,  1 Jan 2020 15:44:20 +0100 (CET)
Date:   Thu, 2 Jan 2020 01:44:07 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xjferel7t3bvq2hc"
Content-Disposition: inline
In-Reply-To: <20200101030815.GA17593@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xjferel7t3bvq2hc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Jan 01, 2020 at 12:54:46AM +0000, Al Viro wrote:
> > Note, BTW, that lookup_last() (aka walk_component()) does just
> > that - we only hit step_into() on LAST_NORM.  The same goes
> > for do_last().  mountpoint_last() not doing the same is _not_
> > intentional - it's definitely a bug.
> >=20
> > Consider your testcase; link points to . here.  So the only
> > thing you could expect from trying to follow it would be
> > the directory 'link' lives in.  And you don't have it
> > when you reach the fscker via /proc/self/fd/3; what happens
> > instead is nd->path set to ./link (by nd_jump_link()) *AND*
> > step_into() called, pushing the same ./link onto stack.
> > It violates all kinds of assumptions made by fs/namei.c -
> > when pushing a symlink onto stack nd->path is expected to
> > contain the base directory for resolving it.
> >=20
> > I'm fairly sure that this is the cause of at least some
> > of the insanity you've caught; there always could be
> > something else, of course, but this hole needs to be
> > closed in any case.
>=20
> ... and with removal of now unused local variable, that's
>=20
> mountpoint_last(): fix the treatment of LAST_BIND
>=20
> step_into() should be attempted only in LAST_NORM
> case, when we have the parent directory (in nd->path).
> We get away with that for LAST_DOT and LOST_DOTDOT,
> since those can't be symlinks, making step_init() and
> equivalent of path_to_nameidata() - we do a bit of
> useless work, but that's it.  For LAST_BIND (i.e.
> the case when we'd just followed a procfs-style
> symlink) we really can't go there - result might
> be a symlink and we really can't attempt following
> it.
>=20
> lookup_last() and do_last() do handle that properly;
> mountpoint_last() should do the same.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks, this fixes the issue for me (and also fixes another reproducer I
found -- mounting a symlink on top of itself then trying to umount it).

Reported-by: Aleksa Sarai <cyphar@cyphar.com>
Tested-by: Aleksa Sarai <cyphar@cyphar.com>

As for the original topic of bind-mounting symlinks -- given this is a
supported feature, would you be okay with me sending an updated
O_EMPTYPATH series?

> ---
> diff --git a/fs/namei.c b/fs/namei.c
> index d6c91d1e88cb..13f9f973722b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2643,7 +2643,6 @@ EXPORT_SYMBOL(user_path_at_empty);
>  static int
>  mountpoint_last(struct nameidata *nd)
>  {
> -	int error =3D 0;
>  	struct dentry *dir =3D nd->path.dentry;
>  	struct path path;
> =20
> @@ -2656,10 +2655,7 @@ mountpoint_last(struct nameidata *nd)
>  	nd->flags &=3D ~LOOKUP_PARENT;
> =20
>  	if (unlikely(nd->last_type !=3D LAST_NORM)) {
> -		error =3D handle_dots(nd, nd->last_type);
> -		if (error)
> -			return error;
> -		path.dentry =3D dget(nd->path.dentry);
> +		return handle_dots(nd, nd->last_type);
>  	} else {
>  		path.dentry =3D d_lookup(dir, &nd->last);
>  		if (!path.dentry) {


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--xjferel7t3bvq2hc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgywNAAKCRCdlLljIbnQ
EsuYAQDIYw8NDiAZ+6tshuBDOmloG4oZ5/lI0VBqyR9iCJagsAEAvR+VsXd2zUhu
+siCNs00CJsZyNZ2Cez3Ln/1mdJj4A0=
=Br0a
-----END PGP SIGNATURE-----

--xjferel7t3bvq2hc--
