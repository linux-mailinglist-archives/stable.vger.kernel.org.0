Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765C012CDB9
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 09:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfL3Icl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 03:32:41 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:39240 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbfL3Ick (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 03:32:40 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 47mVzn5sqlzQlBT;
        Mon, 30 Dec 2019 09:32:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id w6FHZ5EZimpG; Mon, 30 Dec 2019 09:32:34 +0100 (CET)
Date:   Mon, 30 Dec 2019 19:32:24 +1100
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
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20191230083224.sbk2jspqmup43obs@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <CAHk-=whxNw7hYT6bJn9mVrB_a=7Y-irmpaPsp1R4xbHHkicv7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4jbwm72isg7wdcgm"
Content-Disposition: inline
In-Reply-To: <CAHk-=whxNw7hYT6bJn9mVrB_a=7Y-irmpaPsp1R4xbHHkicv7g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4jbwm72isg7wdcgm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-29, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sun, Dec 29, 2019 at 11:30 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> >     BUG: kernel NULL pointer dereference, address: 0000000000000000
>=20
> Would you mind building with debug info, and then running the oops through
>=20
>  scripts/decode_stacktrace.sh
>=20
> which makes those addresses much more legible.

Will do.

> >     #PF: supervisor instruction fetch in kernel mode
> >     #PF: error_code(0x0010) - not-present page
>=20
> Somebody jumped through a NULL pointer.
>=20
> >     RAX: 0000000000000000 RBX: ffff906d0cc3bb40 RCX: 0000000000000abc
> >     RDX: 0000000000000089 RSI: ffff906d74623cc0 RDI: ffff906d74475df0
> >     RBP: ffff906d74475df0 R08: ffffd70b7fb24c20 R09: ffff906d066a5000
> >     R10: 0000000000000000 R11: 8080807fffffffff R12: ffff906d74623cc0
> >     R13: 0000000000000089 R14: ffffb70b82963dc0 R15: 0000000000000080
> >     FS:  00007fbc2a8f0540(0000) GS:ffff906dcf500000(0000) knlGS:0000000=
000000000
> >     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     CR2: ffffffffffffffd6 CR3: 00000003c68f8001 CR4: 00000000003606e0
> >     Call Trace:
> >      __lookup_slow+0x94/0x160
>=20
> And "__lookup_slow()" has two indirect calls (they aren't obvious with
> retpoline, but look for something  like
>=20
>         call __x86_indirect_thunk_rax
>=20
> which is the modern sad way of doing "call *%rax"). One is for
> revalidatinging an old dentry, but the one I _suspect_ you trigger is
> this one:
>=20
>                 old =3D inode->i_op->lookup(inode, dentry, flags);
>=20
> but I thought we only could get here if we know it's a directory.
>=20
> How did we miss the "d_can_lookup()", which is what should check that
> yes, we can call that ->lookup() routine.

I'll try applying a trivial patch to add d_can_lookup() to see if it
fixes the immediate issue.

> This is why I have that suspicion that it's somehow that O_PATH fd
> opened in another process without O_PATH causes confusion...
>=20
> So what I think has happened is that because of the O_PATH thing,
> we've ended up with an inode that has never been truly opened (because
> O_PATH skips that part), but then with the /proc/<pid>/fd/xyz open, we
> now have a file descriptor that _looks_ like it is valid, and we're
> treating that inode as if it can be used.

I'm not sure I agree -- as I mentioned in my other mail, re-opening
through /proc/self/fd/$n works *very* well and has for a long time (in
fact, both LXC and runc depend on this working).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--4jbwm72isg7wdcgm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgm2FQAKCRCdlLljIbnQ
Es8nAQDVLlsiprSDBJzgPUIJzecdqNxCZqJKorIf34AfFNF2FgD/YY1dxfmAH2LS
EX3M69u6T8mfTLPNWSZlIyF13X2S2w4=
=JUfW
-----END PGP SIGNATURE-----

--4jbwm72isg7wdcgm--
