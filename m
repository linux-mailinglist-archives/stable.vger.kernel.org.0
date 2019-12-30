Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0840212CDAF
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 09:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfL3I3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 03:29:06 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:13618 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbfL3I3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 03:29:06 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 47mVvg2XYxzQl95;
        Mon, 30 Dec 2019 09:29:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id LksFxLKl0xnj; Mon, 30 Dec 2019 09:28:56 +0100 (CET)
Date:   Mon, 30 Dec 2019 19:28:47 +1100
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20191230082847.dkriyisvu7wwxqqu@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230052036.8765-2-cyphar@cyphar.com>
 <CAHk-=wjHPCQsMeK5bFOJQnrGPfVDXTAFQK4VsBZPj5u=ZgS-QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2ttgeqhlie5hzgct"
Content-Disposition: inline
In-Reply-To: <CAHk-=wjHPCQsMeK5bFOJQnrGPfVDXTAFQK4VsBZPj5u=ZgS-QA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2ttgeqhlie5hzgct
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-29, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sun, Dec 29, 2019 at 9:21 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > +       if (d_is_symlink(mp->m_dentry) ||
> > +           d_is_symlink(mnt->mnt.mnt_root))
> > +               return -EINVAL;
>=20
> So I don't hate this kind of check in general - overmounting a symlink
> sounds odd, but at the same time I get the feeling that the real issue
> is that something went wrong earlier.
>=20
> Yeah, the mount target kind of _is_ a path, but at the same time, we
> most definitely want to have the permission to really open the
> directory in question, don't we, and I don't see that we should accept
> a O_PATH file descriptor.

The new mount API uses O_PATH under the hood (which is a good thing
since some files you'd like to avoid actually opening -- FIFOs are the
obvious example) so I'm not sure that's something we could really avoid.

But if we block O_PATH for mounts this will achieve the same thing,
because the only way to get a file descriptor that references a symlink
is through (O_PATH | O_NOFOLLOW).

> I feel like the only valid use of "O_PATH" files is to then use them
> as the base for an openat() and friends (ie fchmodat/execveat() etc).

See below, we use this for all sorts of dirty^Wclever tricks.

> But maybe I'm completely wrong, and people really do want O_PATH
> handling exactly for mounting too. It does sound a bit odd. By
> definition, mounting wants permissions to the mount-point, so what's
> the point of using O_PATH?

When you go through O_PATH, you still get a proper 'struct path' which
means that for operations such as mount (or open) you will operate on
the *real* underlying file.

This is part of what makes magic-links so useful (but also quite
terrifying).

> For example, is the problem that when you do a proper
>=20
>   fd =3D open("somepath", O_PATH);
>=20
> in one process, and then another thread does
>=20
>    fd =3D open("/proc/<pid>/fd/<opathfd>", O_RDWR);
>=20
> then we get confused and do bad things on that *second* open? Because
> now the second open doesn't have O_PATH, and doesn't ghet marked
> FMODE_PATH, but the underlying file descriptor is one of those limited
> "is really only useful for openat() and friends".

Actually, this isn't true (for the same reason as above) -- when you do
a re-open through /proc/$pid/fd/$n you get a real-as-a-heart-attack file
descriptor. We make lots of use of this in container runtimes in order
to do some dirty^Wfun tricks that help us harden the runtime against
malicious container processes.

You might recall that when I was posting the earlier revisions of
openat2(), I also included a patch for O_EMPTYPATH (which basically did
a re-open of /proc/self/fd/$dfd but without needing /proc). That had
precisely the same semantics so that you could do the same operation
without procfs. That patch was dropped before Al merged openat2(), but I
am probably going to revive it for the reasons I outlined below.

> I dunno. I haven't thought through the whole thing. But the oopses you
> quote seem like we're really doing something wrong, and it really does
> feel like your patch in no way _fixes_ the wrong thing we're doing,
> it's just hiding the symptoms.

That's fair enough.

I'll be honest, the real reason why I don't want mounts over symlinks to
be possible is for an entirely different reason. I'm working on a safe
path resolution library to accompany openat2()[1] -- and one of the
things I want to do is to harden all of our uses of procfs (such that if
we are running in a context where procfs has been messed with -- such as
having files bind-mounted -- we can detect it and abort). The issue with
symlinks is that we need to be able to operate on magic-links (such as
/proc/self/fd/$n and /proc/self/exe) -- and if it's possible bind-mount
over those magic-links then we can't detect it at all.

openat2(RESOLVE_NO_XDEV) would block it, but it also blocks going
through magic-links which change your mount (which would almost always
be true). You can't trust /proc/self/mountinfo by definition -- not just
because of the TOCTOU race but also because you can't depend on /proc to
harden against a "bad" /proc. All other options such as
umount2(MNT_EXPIRE) won't help with magic-links because we cannot take
an O_PATH to a magic-link and follow it -- O_PATHs of symlinks are
completely stunted in this respect.

If allowing bind-mounts over symlinks is allowed (which I don't have a
problem with really), it just means we'll need a few more kernel pieces
to get this hardening to work. But these features would be useful
outside of the problems I'm dealing with (O_EMPTYPATH and some kind of
pidfd-based interface to grab the equivalent of /proc/self/exe and a few
other such magic-link targets).

[1]: https://github.com/openSUSE/libpathrs

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--2ttgeqhlie5hzgct
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgm1PAAKCRCdlLljIbnQ
EgySAP9VrQ+iD1l5aOAWe2wFG8Jw0u9h3RrYrsF6ygoOD7rhYgEAjl6Xtd4ayz7s
rKcquB9aKdCEYTJMzkPShbvhgHd0rAc=
=ff9q
-----END PGP SIGNATURE-----

--2ttgeqhlie5hzgct--
