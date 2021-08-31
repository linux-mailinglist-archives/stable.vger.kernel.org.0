Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127573FC83D
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 15:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhHaNbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 09:31:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39428 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhHaNbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 09:31:50 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7F8DA1C0B79; Tue, 31 Aug 2021 15:30:53 +0200 (CEST)
Date:   Tue, 31 Aug 2021 15:30:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org
Subject: Re: CVE-2021-3600 aka bpf: Fix 32 bit src register truncation on
 div/mod
Message-ID: <20210831133053.GA32426@duo.ucw.cz>
References: <20210826102337.GA7362@duo.ucw.cz>
 <YS0lqmZg5Lq0scVv@mussarela>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <YS0lqmZg5Lq0scVv@mussarela>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > So this explains "mov32 w0, w0" is problematic, and fixes the bug by
> > replacing it with jmp32. Unfortunately, I can't do that in 4.19; plus
> > I don't really see how the bug is solved -- we avoided adding mov32
> > sequence that triggers the problem, but the problematic sequence could
> > still be produced by the userspace, no?
> >=20
> > Does adjust_scalar_min_max_vals still need fixing?
> >=20
> > Do you have any hints how to solve this in 4.19?

> I have just sent the fixes for 4.14. I sent fixes for 4.19 last Friday.
>=20
> The problem here is that the verifier assumes the source register has a g=
iven
> value, but the fixups change that value to something else when it is trun=
cated.
>=20
> The fixups run after the verifier, so a similar sequence produced by user=
space
> will be correctly verified, so no fixes are necessary on adjust_scalar_mi=
n_max
> for this specific issue. The fixed-up code is not verified again.

Thanks, understood.

> The challenge in providing those fixes to 4.14 and 4.19 is the absence of=
 JMP32
> in those kernels. So, AX was taken as a temporary, so it would still work=
 on
> JITs.

Yes, I got that far. I have seen the patches for 4.19 and 4.14, and
they should fix my problems. Thanks a lot for them.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYS4vDQAKCRAw5/Bqldv6
8qDgAJ0bm7OWm/wylXX8uShwf5qRCpRJHwCfaIxAey3KNwcbTgwPdbp8O7vts3Y=
=lf2P
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
