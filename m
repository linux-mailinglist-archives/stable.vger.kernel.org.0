Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85BB25FE1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 10:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfEVI5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 04:57:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42197 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfEVI5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 04:57:44 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 32B6D8036B; Wed, 22 May 2019 10:57:32 +0200 (CEST)
Date:   Wed, 22 May 2019 10:57:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>,
        Josh Snyder <joshs@netflix.com>,
        Michal Hocko <mhocko@suse.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Chinner <david@fromorbit.com>,
        Kevin Easton <kevin@guarana.org>,
        Matthew Wilcox <willy@infradead.org>,
        Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daniel Gruss <daniel@gruss.cc>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH 4.19 053/105] mm/mincore.c: make mincore() more
 conservative
Message-ID: <20190522085741.GB8174@amd>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115250.721190520@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20190520115250.721190520@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 134fca9063ad4851de767d1768180e5dede9a881 upstream.
>=20
> The semantics of what mincore() considers to be resident is not
> completely clear, but Linux has always (since 2.3.52, which is when
> mincore() was initially done) treated it as "page is available in page
> cache".
>=20
> That's potentially a problem, as that [in]directly exposes
> meta-information about pagecache / memory mapping state even about
> memory not strictly belonging to the process executing the syscall,
> opening possibilities for sidechannel attacks.
>=20
> Change the semantics of mincore() so that it only reveals pagecache
> information for non-anonymous mappings that belog to files that the
> calling process could (if it tried to) successfully open for writing;
> otherwise we'd be including shared non-exclusive mappings, which
>=20
>  - is the sidechannel
>=20
>  - is not the usecase for mincore(), as that's primarily used for data,
>    not (shared) text

=2E..

> @@ -189,8 +205,13 @@ static long do_mincore(unsigned long add
>  	vma =3D find_vma(current->mm, addr);
>  	if (!vma || addr < vma->vm_start)
>  		return -ENOMEM;
> -	mincore_walk.mm =3D vma->vm_mm;
>  	end =3D min(vma->vm_end, addr + (pages << PAGE_SHIFT));
> +	if (!can_do_mincore(vma)) {
> +		unsigned long pages =3D DIV_ROUND_UP(end - addr, PAGE_SIZE);
> +		memset(vec, 1, pages);
> +		return pages;
> +	}
> +	mincore_walk.mm =3D vma->vm_mm;
>  	err =3D walk_page_range(addr, end, &mincore_walk);

We normally return errors when we deny permissions; but this one just
returns success and wrong data.

Could we return -EPERM there? If not, should it at least get a
comment?

Thanks,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzlDwUACgkQMOfwapXb+vJ7DgCgoJghRiZhuM2meVZZe3AI4324
/AQAniFOm3l9roHXffisa47JlKVApofW
=OIIc
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
