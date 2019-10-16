Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D89D95B1
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405062AbfJPPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 11:35:34 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:16483 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405055AbfJPPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 11:35:34 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id 1ED8AA1149;
        Wed, 16 Oct 2019 17:35:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 9R7HIXzq1RpU; Wed, 16 Oct 2019 17:35:28 +0200 (CEST)
Date:   Thu, 17 Oct 2019 02:35:20 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Message-ID: <20191016153520.zet5mn5xsygig4xc@yavin.dot.cyphar.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
 <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
 <20191016142756.GN18794@devbig004.ftw2.facebook.com>
 <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gae43k7kt3kmufic"
Content-Disposition: inline
In-Reply-To: <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gae43k7kt3kmufic
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-17, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-10-16, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Aleksa.
> >=20
> > On Wed, Oct 16, 2019 at 07:32:19PM +1100, Aleksa Sarai wrote:
> > > Maybe I'm misunderstanding Documentation/atomic_t.txt, but it looks to
> > > me like it's explicitly saying that I shouldn't use atomic64_t if I'm
> > > just using it for fetching and assignment.
> >=20
> > Hah, where is it saying that?
>=20
> Isn't that what this says:
>=20
> > Therefore, if you find yourself only using the Non-RMW operations of
> > atomic_t, you do not in fact need atomic_t at all and are doing it
> > wrong.
>=20
> Doesn't using just atomic64_read() and atomic64_set() fall under "only
> using the non-RMW operations of atomic_t"? But yes, I agree that any
> locking is overkill.
>=20
> > > As for 64-bit on 32-bit machines -- that is a separate issue, but from
> > > [1] it seems to me like there are more problems that *_ONCE() fixes t=
han
> > > just split reads and writes.
> >=20
> > Your explanations are too wishy washy.  If you wanna fix it, please do
> > it correctly.  R/W ONCE isn't the right solution here.
>=20
> Sure, I will switch it to use atomic64_read() and atomic64_set() instead
> if that's what you'd prefer. Though I will mention that on quite a few
> architectures atomic64_read() is defined as:
>=20
>   #define atomic64_read(v)        READ_ONCE((v)->counter)

Though I guess that's because on those architectures it turns out that
READ_ONCE is properly atomic?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--gae43k7kt3kmufic
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXac4XgAKCRCdlLljIbnQ
EqfmAQCvvl9RoS0Za1ejIafzulKxMufJWahNQcrCVULRur+MvwEA+lhgaq8rJ/Qb
48BFtp02gSX3aYFTdGOSILPOV6Op+Ak=
=c8Qz
-----END PGP SIGNATURE-----

--gae43k7kt3kmufic--
