Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0672813784B
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 22:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgAJVHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 16:07:43 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:23372 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgAJVHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 16:07:42 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 47vbCv5hSczKmhn;
        Fri, 10 Jan 2020 22:07:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id hIHoHiMQzTgm; Fri, 10 Jan 2020 22:07:33 +0100 (CET)
Date:   Sat, 11 Jan 2020 08:07:19 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200110210719.ktg3l2kwjrdutlh6@yavin>
References: <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ngr34thsixezvd7j"
Content-Disposition: inline
In-Reply-To: <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ngr34thsixezvd7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Jan 7, 2020 at 7:13 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Another interesting question is whether we want O_PATH open
> > to trigger automounts.
>=20
> It does sound like they shouldn't, but as you say:
>=20
> >     The thing is, we do *NOT* trigger them
> > (or traverse mountpoints) at the starting point of lookups.
> > I believe it's a mistake (and mine, at that), but I doubt that
> > there's anything that can be done about it at that point.
> > It's a user-visible behaviour [..]
>=20
> Hmm. I wonder how set in stone that is. We may have two decades of
> history of not doing it at start point of lookups, but we do *not*
> have two decades of history of O_PATH.
>=20
> So what I think we agree would be sane behavior would be for O_PATH
> opens to not trigger automounts (unless there's a slash at the end,
> whatever), but _do_ add the mount-point traversal to the beginning of
> lookups.
>=20
> But only do it for the actual O_PATH fd case, not the cwd/root/non-O_PATH=
 case.
>=20
> That way we maintain original behavior: if somebody overmounts your
> cwd, you still see the pre-mount directory on lookups, because your
> cwd is "under" the mount.
>=20
> But if you open a file with O_PATH, and somebody does a mount
> _afterwards_, the openat() will see that later mount and/or do the
> automount.
>=20
> Don't you think that would be the more sane/obvious semantics of how
> O_PATH should work?

If I'm understanding this proposal correctly, this would be a problem
for the libpathrs use-case -- if this is done then there's no way to
avoid a TOCTOU with someone mounting and the userspace program checking
whether something is a mountpoint (unless you have Linux >5.6 and
RESOLVE_NO_XDEV). Today, you can (in theory) do it with MNT_EXPIRE:

  1. Open the candidate directory.
  2. umount2(MNT_EXPIRE) the fd.
    * -EINVAL means it wasn't a mountpoint when we got the fd, and the
	  fd is a stable handle to the underlying directory.
	* -EAGAIN or -EBUSY means that it was a mountpoint or became a
	  mountpoint after the fd was opened (we don't care about that, but
	  fail-safe is better here).
  3. Use the fd from (1) for all operations.

Don't get me wrong, I want to fix this issue *properly* by adding some
new kernel features that allow us to avoid worrying about
mounts-over-magiclinks -- but on old kernels (which libpathrs cares
about) I would be worried about changes like this being backported
resulting in it being not possible to implement the hardening I
mentioned up-thread.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ngr34thsixezvd7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXhjnhAAKCRCdlLljIbnQ
EhaiAP9e9kkZEWJCnBThFyXtSMRZyNVXHckugjlX6Ia4tELkfwD+KmuEPaDHPZsv
ZqHH8TBxEFo6jF26WNsOXtxaBZwFsQ0=
=uAob
-----END PGP SIGNATURE-----

--ngr34thsixezvd7j--
