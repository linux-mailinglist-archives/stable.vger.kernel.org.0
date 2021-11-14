Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE17A44F8D2
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 16:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhKNPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 10:54:51 -0500
Received: from bluehome.net ([96.66.250.149]:60612 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhKNPyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 10:54:49 -0500
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id DE1574B40861
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 07:51:54 -0800 (PST)
Date:   Sun, 14 Nov 2021 07:51:53 -0800
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: MIPS: fix *-pkg builds for loongson2ef platform
Message-ID: <20211114075153.5e0ca309@valencia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/PlvXrcraHGA/H4H/sbAN5Lo"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/PlvXrcraHGA/H4H/sbAN5Lo
Content-Type: multipart/mixed; boundary="MP_/roZ47d3x750nxt36Zama.nR"

--MP_/roZ47d3x750nxt36Zama.nR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello, stable maintainers.

I'd like to request the change made by
cca2aac8acf470b01066f559acd7146fc4c32ae8 be applied to the 5.15 and
5.14 series so as to address the build failure. That patch doesn't
apply to 5.14 as-is so I am attaching a backported version of the patch
that does.

--MP_/roZ47d3x750nxt36Zama.nR
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-MIPS-fix-pkg-builds-for-loongson2ef-platform.patch

=46rom 1817d870345062bbc91b35cd2324556d27ce8010 Mon Sep 17 00:00:00 2001
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 14 Nov 2021 07:47:31 -0800
Subject: [PATCH] MIPS: fix *-pkg builds for loongson2ef platform

commit cca2aac8acf470b01066f559acd7146fc4c32ae8 upstream.

Since commit 805b2e1d427a ("kbuild: include Makefile.compiler only when
compiler is needed"), package builds for the loongson2f platform fail.

  $ make ARCH=3Dmips CROSS_COMPILE=3Dmips64-linux- lemote2f_defconfig binde=
b-pkg
    [ snip ]
  sh ./scripts/package/builddeb
  arch/mips/loongson2ef//Platform:36: *** only binutils >=3D 2.20.2 have ne=
eded option -mfix-loongson2f-nop.  Stop.
  cp: cannot stat '': No such file or directory
  make[5]: *** [scripts/Makefile.package:87: intdeb-pkg] Error 1
  make[4]: *** [Makefile:1558: intdeb-pkg] Error 2
  make[3]: *** [debian/rules:13: binary-arch] Error 2
  dpkg-buildpackage: error: debian/rules binary subprocess returned exit st=
atus 2
  make[2]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
  make[1]: *** [Makefile:1558: bindeb-pkg] Error 2
  make: *** [Makefile:350: __build_one_by_one] Error 2

The reason is because "make image_name" fails.

  $ make ARCH=3Dmips CROSS_COMPILE=3Dmips64-linux- image_name
  arch/mips/loongson2ef//Platform:36: *** only binutils >=3D 2.20.2 have ne=
eded option -mfix-loongson2f-nop.  Stop.

In general, adding $(error ...) in the parse stage is troublesome,
and it is pointless to check toolchains even if we are not building
anything. Do not include Kbuild.platform in such cases.

Fixes: 805b2e1d427a ("kbuild: include Makefile.compiler only when compiler =
is needed")
Reported-by: Jason Self <jason@bluehome.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Jason Self <jason@bluehome.net>
---
 arch/mips/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 653befc1b..0dfef0bea 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -254,7 +254,9 @@ endif
 #
 # Board-dependent options and extra files
 #
+ifdef need-compiler
 include arch/mips/Kbuild.platforms
+endif
=20
 ifdef CONFIG_PHYSICAL_START
 load-y					=3D $(CONFIG_PHYSICAL_START)
--=20
2.33.1


--MP_/roZ47d3x750nxt36Zama.nR--

--Sig_/PlvXrcraHGA/H4H/sbAN5Lo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmGRMJkACgkQnQ2zG1Ra
MZh6OQ/+JoegsyYokJhb6SxQlG2u9jzYDHAzpt5YfjVtfPLgi4doq6MzmAcZ7DD0
WtwNOfj1y47X1BjdI7zdVP14pu3UkZaDPJGe34/6LzxvvrkoYqGcoigK/Xe4JA4p
bcfqjoChC4AgvwcT0gSEZXA+r/nK7ejny3zcMfmex755ABBmWxS2jInZk46tJmFl
FRrLo74lj0eRhg2XOe6ze4QXx/URfNjNiEajHgqz5nb3EkfVySHnbbi5FlrFtrjk
U65xbvxUwf+o1tFVOXWLplGjIhpRyWSBE/t/OFm0W2ZvP+s9phJhlLHMC8Ynl67D
bZFtviDLtR7s5o4LzuY82gJOa9LitY4xNFlMhoFg+SIdPpP+Ewdl2aO+0jch7Ymd
3nQfsyF6QldlwYDbJWjME8qv4dAAzAnPb3UqLHvE7QrtRTe6X0QYEjGD9MGPnnWq
zOiyWUvFzf6dHkqRGjPxMbzmrITGofEs95+IoR0tUNlk3aDgm4MdR0tnD1LTi50q
h7rjteMOl4Ox7N8xuaXZsgqj/MsEjFEo7OyYb6wWkEKWj++UAp/6agUPwoaW5o2G
vBcC4tUb8wbScfjnZBR7RZ1qnNnxrNdoLFM7wlkfJkfyVtVhCWOF/L4A6z+Bj18e
lvQWAexaDZmCOwpWKFZKgvOWDgJ5rfudrn1j+NoqzEWjBWee/pQ=
=8MVL
-----END PGP SIGNATURE-----

--Sig_/PlvXrcraHGA/H4H/sbAN5Lo--
