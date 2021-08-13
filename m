Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE67E3EB3FB
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhHMKY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:24:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55512 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbhHMKY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:24:57 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 63D9E1C0B76; Fri, 13 Aug 2021 12:24:30 +0200 (CEST)
Date:   Fri, 13 Aug 2021 12:24:29 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <20210813102429.GA28610@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20210813095429.GA21912@1wt.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2021-08-13 11:54:29, Willy Tarreau wrote:
> Hi Pavel,
>=20
> On Fri, Aug 13, 2021 at 11:31:04AM +0200, Pavel Machek wrote:
> > > > If we could agree on
> > > >=20
> > > > Commit: (SHA)
> > > >=20
> > > > in the beggining of body, that would be great.
> > > >=20
> > > > Upstream: (SHA)
> > > >=20
> > > > in sign-off area would be even better.
> > >=20
> > > What exactly are you trying to do when you find a sha1?  For some rea=
son
> > > my scripts work just fine with a semi-free-form way that we currently
> > > have been doing this for the past 17+ years.  What are you attempting=
 to
> > > do that requires such a fixed format?
> >=20
> > Is there any problem having a fixed format? You are producing -stable
> > kernels, so you are not the one needing such functionality.
>=20
> When I was doing extended LTS in the past, I used to restart from
> Greg's closest branch (e.g. 4.4.y for latest 3.10.y) and needed
> exactly that. It was pretty easy in the end, as you'll essentially
> find two formats (one form from net and the other for the rest of
> the patches):
>=20
>   - commit XXXX upstream
>   - [ Upstream commit XXXX ]
>=20
> I ended up writing this trivial script that did the job well for me
> and also supported the "git cherry-pick -x" format that I was using
> a lot. Feel free to reuse that as a starting point, here it comes, a
> bit covered in dust :-)

Please see previous discussion. Yes, I have my regexps, too, but there
are variations, and there were even false positives.. One of them is
in this email thread.

Greg suggests to simply ignore context and look for SHA1 sum; that
does not work, either.

So what I'm asking is for single, easy to parse format. I don't quite
care what it is, but

Upstream: (SHA)

would be best.

Best regards,
								Pavel


> Willy
>=20
> #!/bin/bash
>=20
> die() {
>         [ "$#" -eq 0 ] || echo "$*" >&2
>         exit 1
> }
>=20
> [ -n "$1" ] || die "Usage: ${0##*/} <commit>|<file>"
>=20
> upstream=3D( )
> if [ -s "$1" ]; then
>         upstream=3D( $(sed -n -e '/^$/,/^./s/^commit \([0-9a-f]*\) upstre=
am\.$/\1/p' \
>                             -e 's/^\[ Upstream commit \([0-9a-f]*\) \]$/\=
1/p' \
>                             -e 's/^(cherry picked from commit \([0-9a-f]*=
\))/\1/p' "$1") )
> else
>         upstream=3D( $(git log -1 --pretty --format=3D%B "$1" | \
>                      sed -n -e '1,3s/^commit \([0-9a-f]*\) upstream\.$/\1=
/p' \
>                             -e 's/^\[ Upstream commit \([0-9a-f]*\) \]$/\=
1/p' \
>                             -e 's/^(cherry picked from commit \([0-9a-f]*=
\))/\1/p') )
> fi
>=20
> [ "${#upstream[@]}" -gt 0 ] || die "No upstream commit ID found."
>=20
> echo "${upstream[0]}"

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRZIXQAKCRAw5/Bqldv6
8sqBAJ41kruMaMcWRZScZBoXI4W+ShwIhgCeL6u/S9BtBLyNrTejc26AiwnnNSU=
=mlAp
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
