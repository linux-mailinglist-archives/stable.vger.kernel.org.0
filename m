Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C6A3F8540
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 12:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241305AbhHZKY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 06:24:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50808 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbhHZKYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 06:24:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 98D8B1C0B7A; Thu, 26 Aug 2021 12:23:37 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:23:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     stable@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org
Subject: CVE-2021-3600 aka bpf: Fix 32 bit src register truncation on div/mod
Message-ID: <20210826102337.GA7362@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As far as I can tell, CVE-2021-3600 is still a problem for 4.14 and
4.19.

Unfortunately, those kernels lack BPF_JMP32 support, and that support
is too big and intrusive to backport.

So I tried to come up with solution without JMP32 support... only to
end up with not seeing the bug in the affected code.

Changelog says:

    bpf: Fix 32 bit src register truncation on div/mod
   =20
    While reviewing a different fix, John and I noticed an oddity in one of=
 the
    BPF program dumps that stood out, for example:
   =20
      # bpftool p d x i 13
       0: (b7) r0 =3D 808464450
       1: (b4) w4 =3D 808464432
       2: (bc) w0 =3D w0
       3: (15) if r0 =3D=3D 0x0 goto pc+1
       4: (9c) w4 %=3D w0
      [...]
   =20
    In line 2 we noticed that the mov32 would 32 bit truncate the original =
src
    register for the div/mod operation. While for the two operations the dst
    register is typically marked unknown e.g. from adjust_scalar_min_max_va=
ls()
    the src register is not, and thus verifier keeps tracking original boun=
ds,
    simplified:

So this explains "mov32 w0, w0" is problematic, and fixes the bug by
replacing it with jmp32. Unfortunately, I can't do that in 4.19; plus
I don't really see how the bug is solved -- we avoided adding mov32
sequence that triggers the problem, but the problematic sequence could
still be produced by the userspace, no?

Does adjust_scalar_min_max_vals still need fixing?

Do you have any hints how to solve this in 4.19?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSdrqQAKCRAw5/Bqldv6
8rK9AJ9kEm63Lbsbk8N3qBjuKHwwcGEstQCeK9JGBYjsg/VAmJ9wFUCiW+gfTSE=
=T4Yk
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
