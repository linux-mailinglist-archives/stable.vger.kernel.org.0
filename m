Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525353775DF
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 10:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEIIZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 04:25:41 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57648 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhEIIZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 04:25:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0851F1C0B76; Sun,  9 May 2021 10:24:37 +0200 (CEST)
Date:   Sun, 9 May 2021 10:24:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     wens@csie.org, stable@vger.kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, pablo@netfilter.org
Subject: [PATCH 4.4] netfilter: x_tables: Use correct memory barriers.
Message-ID: <20210509082436.GA25504@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


=46rom: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit 175e476b8cdf2a4de7432583b49c871345e4f8a1 upstream.

When a new table value was assigned, it was followed by a write memory
barrier. This ensured that all writes before this point would complete
before any writes after this point. However, to determine whether the
rules are unused, the sequence counter is read. To ensure that all
writes have been done before these reads, a full memory barrier is
needed, not just a write memory barrier. The same argument applies when
incrementing the counter, before the rules are read.

Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
reported in cc00bcaa5899 (which is still present), while still
maintaining the same speed of replacing tables.

The smb_mb() barriers potentially slow the packet path, however testing
has shown no measurable change in performance on a 4-core MIPS64
platform.

Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Ported to stable, affected barrier is added by d3d40f237480abf3268956daf18=
cdc56edd32834 in mainline]
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/netfilter/x_tables.c           | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index 6923e4049de3..304b60b49526 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -327,7 +327,7 @@ static inline unsigned int xt_write_recseq_begin(void)
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
=20
 	return addend;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8caae1c5d93d..8878f859c6de 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1146,6 +1146,9 @@ xt_replace_table(struct xt_table *table,
 	smp_wmb();
 	table->private =3D newinfo;
=20
+	/* make sure all cpus see new ->private value */
+	smp_mb();
+
 	/*
 	 * Even though table entries have now been swapped, other CPU's
 	 * may still be using the old entries. This is okay, because
--=20
2.11.0


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCXnEMACgkQMOfwapXb+vIrnwCeMzQpKoN5TBfohZEvkosxATid
PsUAoJL4xwmj+dhUtAMeZERuuK5Hc9e7
=zbtg
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
