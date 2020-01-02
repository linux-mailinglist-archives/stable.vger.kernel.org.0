Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AD212E1FA
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 04:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbgABD7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 22:59:40 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:16274 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgABD7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 22:59:40 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 47pDnP4gX9zQlB7;
        Thu,  2 Jan 2020 04:59:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id 86V7dup9i5m4; Thu,  2 Jan 2020 04:59:33 +0100 (CET)
Date:   Thu, 2 Jan 2020 14:59:20 +1100
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
Message-ID: <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tef6rv2ffqcfqgo6"
Content-Disposition: inline
In-Reply-To: <20200101234009.GB8904@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tef6rv2ffqcfqgo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Jan 02, 2020 at 01:44:07AM +1100, Aleksa Sarai wrote:
>=20
> > Thanks, this fixes the issue for me (and also fixes another reproducer I
> > found -- mounting a symlink on top of itself then trying to umount it).
> >=20
> > Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> > Tested-by: Aleksa Sarai <cyphar@cyphar.com>
>=20
> Pushed into #fixes.

Thanks. One other thing I noticed is that umount applies to the
underlying symlink rather than the mountpoint on top. So, for example
(using the same scripts I posted in the thread):

  # ln -s /tmp/foo link
  # ./mount_to_symlink /etc/passwd link
  # umount -l link # will attempt to unmount "/tmp/foo"

Is that intentional?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--tef6rv2ffqcfqgo6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXg1qlQAKCRCdlLljIbnQ
EjpjAP9+cSE8vOT4mUYl4IC31Io/0FRApXDAbaIGxDhJ1uYJQAD+IuziuN4KXZzb
2vUrlYkc86XaKC4oX0suOlWHXbaUdgE=
=iYvs
-----END PGP SIGNATURE-----

--tef6rv2ffqcfqgo6--
