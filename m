Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8572ED8B03
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 10:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbfJPIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 04:32:39 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:28169 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbfJPIcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 04:32:39 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id 5201CA1F82;
        Wed, 16 Oct 2019 10:32:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id VpkJpA2e4UPE; Wed, 16 Oct 2019 10:32:29 +0200 (CEST)
Date:   Wed, 16 Oct 2019 19:32:19 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Message-ID: <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jvbscg62ooyqvvh3"
Content-Disposition: inline
In-Reply-To: <20191014163307.GG18794@devbig004.ftw2.facebook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jvbscg62ooyqvvh3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-14, Tejun Heo <tj@kernel.org> wrote:
> Hello, Aleksa.
>=20
> On Tue, Oct 15, 2019 at 02:59:31AM +1100, Aleksa Sarai wrote:
> > On 2019-10-14, Tejun Heo <tj@kernel.org> wrote:
> > > On Sat, Oct 12, 2019 at 12:05:39PM +1100, Aleksa Sarai wrote:
> > > > Because pids->limit can be changed concurrently (but we don't want =
to
> > > > take a lock because it would be needlessly expensive), use the
> > > > appropriate memory barriers.
> > >=20
> > > I can't quite tell what problem it's fixing.  Can you elaborate a
> > > scenario where the current code would break that your patch fixes?
> >=20
> > As far as I can tell, not using *_ONCE() here means that if you had a
> > process changing pids->limit from A to B, a process might be able to
> > temporarily exceed pids->limit -- because pids->limit accesses are not
> > protected by mutexes and the C compiler can produce confusing
> > intermediate values for pids->limit[1].
> >
> > But this is more of a correctness fix than one fixing an actually
> > exploitable bug -- given the kernel memory model work, it seems like a
> > good idea to just use READ_ONCE() and WRITE_ONCE() for shared memory
> > access.
>=20
> READ/WRITE_ONCE provides protection against compiler generating
> multiple accesses for a single operation.  It won't prevent split
> writes / reads of 64bit variables on 32bit machines.  For that, you'd
> have to switch them to atomic64_t's.

Maybe I'm misunderstanding Documentation/atomic_t.txt, but it looks to
me like it's explicitly saying that I shouldn't use atomic64_t if I'm
just using it for fetching and assignment.

> The non-RMW ops are (typically) regular LOADs and STOREs and are
> canonically implemented using READ_ONCE(), WRITE_ONCE(),
> smp_load_acquire() and smp_store_release() respectively. Therefore, if
> you find yourself only using the Non-RMW operations of atomic_t, you
> do not in fact need atomic_t at all and are doing it wrong.

As for 64-bit on 32-bit machines -- that is a separate issue, but from
[1] it seems to me like there are more problems that *_ONCE() fixes than
just split reads and writes.

[1]: https://lwn.net/Articles/793253/

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--jvbscg62ooyqvvh3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXabVjwAKCRCdlLljIbnQ
Eo+bAP4twCdIzc/3irINS1h8+SDHb5Id/IYDo/ool67sAVKdmAD/ddb+01/LuSQE
N1Ie5O8BQm/MY6wpbxlAT69EyW1n8QY=
=rCSZ
-----END PGP SIGNATURE-----

--jvbscg62ooyqvvh3--
