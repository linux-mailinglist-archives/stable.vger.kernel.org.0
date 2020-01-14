Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC413B354
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 21:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgANUCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 15:02:22 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:60288 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgANUCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 15:02:22 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 47y1Zf2B6hzKmVl;
        Tue, 14 Jan 2020 21:02:18 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id 8yIjXp1Taw1j; Tue, 14 Jan 2020 21:02:14 +0100 (CET)
Date:   Wed, 15 Jan 2020 07:01:50 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20200114200150.ryld4npoblns2ybe@yavin>
References: <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
 <20200114045733.GW8904@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yw32mmv2xicgi7vl"
Content-Disposition: inline
In-Reply-To: <20200114045733.GW8904@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yw32mmv2xicgi7vl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-14, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Jan 11, 2020 at 08:07:19AM +1100, Aleksa Sarai wrote:
>=20
> > If I'm understanding this proposal correctly, this would be a problem
> > for the libpathrs use-case -- if this is done then there's no way to
> > avoid a TOCTOU with someone mounting and the userspace program checking
> > whether something is a mountpoint (unless you have Linux >5.6 and
> > RESOLVE_NO_XDEV). Today, you can (in theory) do it with MNT_EXPIRE:
> >=20
> >   1. Open the candidate directory.
> >   2. umount2(MNT_EXPIRE) the fd.
> >     * -EINVAL means it wasn't a mountpoint when we got the fd, and the
> > 	  fd is a stable handle to the underlying directory.
> > 	* -EAGAIN or -EBUSY means that it was a mountpoint or became a
> > 	  mountpoint after the fd was opened (we don't care about that, but
> > 	  fail-safe is better here).
> >   3. Use the fd from (1) for all operations.
>=20
> ... except that foo/../bar *WILL* cross into the covering mount, on any
> kernel that supports ...at(2) at all, so I would be very cautious about
> any kind "hardening" claims in that case.

In the use-case I have, we would have full control over what the path
being opened is (and thus you wouldn't open "foo/../bar"). But I agree
that generally the MNT_EXPIRE solution is really non-ideal anyway.

Not to mention that we're still screwed when it comes to using
magic-links (because if someone bind-mounts a magic-link over a
magic-link there's absolutely no race-free way to be sure that we're
traversing the right magic-link -- for that we'll need to have a
different solution).

> I'm not sure about Linus' proposal - it looks rather convoluted and we
> get a hard to describe twist of semantics in an area (procfs symlinks
> vs. mount traversal) on top of everything else in there...

Yeah, I agree.

> 1) do you see any problems on your testcases with the current #fixes?
> That's commit 7a955b7363b8 as branch tip.

I will take a quick look later today, but I'm currently at a conference.

> 2) do you have any updates you would like to fold into stuff in
> #work.openat2?  Right now I have a local variant of #work.namei (with
> fairly cosmetical change compared to vfs.git one) that merges clean
> with #work.openat2; I would like to do any updates/fold-ins/etc.
> of #work.openat2 *before* doing a merge and continuing to work on
> top of the merge results...

Yes, there were two patches I sent a while ago[1]. I can re-send them if
you like. The second patch switches open_how->mode to a u64, but I'm
still on the fence about whether that makes sense to do...

[1]: https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar@cyphar.com/

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--yw32mmv2xicgi7vl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXh4eKwAKCRCdlLljIbnQ
EohNAP9bZokE7Mx988k9i8bCb2VifwEsK32qWbBGbd1mfrCgcAD9FPGxR3BU2iR4
1M+DPlD/ZTxDuzJUo2DWSGfEWzl2hAQ=
=b/NS
-----END PGP SIGNATURE-----

--yw32mmv2xicgi7vl--
