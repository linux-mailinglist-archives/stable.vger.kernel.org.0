Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D836249832C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiAXPLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:11:20 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42116 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbiAXPLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:11:20 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC103-0006V3-2F; Mon, 24 Jan 2022 16:11:19 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC102-009qo0-GG;
        Mon, 24 Jan 2022 16:11:18 +0100
Date:   Mon, 24 Jan 2022 16:11:18 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 4.14,4.19] mips,s390,sh,sparc: gup: Work around the "COW can
 break either way" issue
Message-ID: <Ye7BluXgj+5i9VUb@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uVhfOyiEcN8oqAxW"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uVhfOyiEcN8oqAxW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In Linux 4.14 and 4.19 these architectures still have their own
implementations of get_user_pages_fast().  These also need to force
the write flag on when taking the fast path.

Fixes: 407faed92b4a ("gup: document and work around "COW can break either w=
ay" issue")
Fixes: 5e24029791e8 ("gup: document and work around "COW can break either w=
ay" issue")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/mm/gup.c  | 9 ++++++++-
 arch/s390/mm/gup.c  | 9 ++++++++-
 arch/sh/mm/gup.c    | 9 ++++++++-
 arch/sparc/mm/gup.c | 9 ++++++++-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 5a4875cac1ec..2e7a0d201c09 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -274,7 +274,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
ges, int write,
 		next =3D pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr =3D next, addr !=3D end);
 	local_irq_enable();
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 9b5b866d8adf..5389bf5bc828 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -287,7 +287,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
ges, int write,
=20
 	might_sleep();
 	start &=3D PAGE_MASK;
-	nr =3D __get_user_pages_fast(start, nr_pages, write, pages);
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
+	nr =3D __get_user_pages_fast(start, nr_pages, 1, pages);
 	if (nr =3D=3D nr_pages)
 		return nr;
=20
diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index 56c86ca98ecf..23fa2fc8aabc 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -242,7 +242,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
ges, int write,
 		next =3D pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr =3D next, addr !=3D end);
 	local_irq_enable();
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index aee6dba83d0e..f291d34a1cd5 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -303,7 +303,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
ges, int write,
 		next =3D pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr =3D next, addr !=3D end);
=20

--uVhfOyiEcN8oqAxW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHuwY0ACgkQ57/I7JWG
EQm2Lw//fY+35Q/WWSlKGBfCwbX6oA5N04WaNq2XGyoqdO06Kj5UG0Hlllg72PVw
Zvv/hd+Ex+OzMZVzQWFRY0GxSwQ4JRdmFfm2tuDCtMvWN71UxhqAI2rHEgMD/eRd
S3lgP2I855CUq7ajzBbjnL/G4NT2ACSn7wawSXPXEi9V7KHmMv5XkthyMuYb9bSr
QHlKMa8cebOFDRDC0z9C7KZL24kKe4GZxDe/tm/CRfvs7S80KBxdB/Nsdkb/d2XI
vljQS40+mOirPu5JIqcUDwo9r2NuYpiiZr6ebgMCVS5OrApkTMmzpKa1px9YS+ly
KHq7ZiIqWbC2sn0tpK3ZNjYJ0bqSaWfW1eIfLDBwmMH32Kv8CxKfzBmtq0T+wADb
M+3IK3fkWQFPX5TXh1hGcYQQzUvpS6gvZzTxZgLFsOXj2dYPSxH+ZE0iUJjQhFNr
p86zdU+PgQxpPnp8WZHu9XixyFO8n0GM1XlfJHb5gSTxJ63wlz0Ym1zTbSOX4VgF
6/C+13tXtXy0cSP84tHxN36EZwNoz/keU37Ia3m4uu4XC9hwOeJJr/khj+1Ou2fV
uqRCo3X+XYB94SNr+g458XpWgIu3kvBiuMNblYBh1AElozHSGesYhzKAD9VPVHGI
20ITDBn2xf1p86E90vuEx9j64eIYNpHlKL8L10ixsuhjY74M43A=
=cFqk
-----END PGP SIGNATURE-----

--uVhfOyiEcN8oqAxW--
