Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B719498508
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243523AbiAXQlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:41:16 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42316 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243816AbiAXQlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:41:15 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2P2-00072V-Ve; Mon, 24 Jan 2022 17:41:12 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2P2-009zHq-7F;
        Mon, 24 Jan 2022 17:41:12 +0100
Date:   Mon, 24 Jan 2022 17:41:12 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        ". Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 4.9 1/4] mm: add follow_pte_pmd()
Message-ID: <Ye7WqMoYNyxOqWId@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7PJpdcUOVP20QEjC"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7PJpdcUOVP20QEjC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Ross Zwisler <ross.zwisler@linux.intel.com>

commit 097963959594c5eccaba42510f7033f703211bda upstream.

Patch series "Write protect DAX PMDs in *sync path".

Currently dax_mapping_entry_mkclean() fails to clean and write protect
the pmd_t of a DAX PMD entry during an *sync operation.  This can result
in data loss, as detailed in patch 2.

This series is based on Dan's "libnvdimm-pending" branch, which is the
current home for Jan's "dax: Page invalidation fixes" series.  You can
find a working tree here:

  https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=3Dd=
ax_pmd_clean

This patch (of 2):

Similar to follow_pte(), follow_pte_pmd() allows either a PTE leaf or a
huge page PMD leaf to be found and returned.

Link: http://lkml.kernel.org/r/1482272586-21177-2-git-send-email-ross.zwisl=
er@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7a4c035b187f..81ee5d0b2642 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1269,6 +1269,8 @@ int copy_page_range(struct mm_struct *dst, struct mm_=
struct *src,
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
diff --git a/mm/memory.c b/mm/memory.c
index c2890dc104d9..2b2cc69ddcce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3780,8 +3780,8 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, uns=
igned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
=20
-static int __follow_pte(struct mm_struct *mm, unsigned long address,
-		pte_t **ptepp, spinlock_t **ptlp)
+static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+		pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -3798,11 +3798,20 @@ static int __follow_pte(struct mm_struct *mm, unsig=
ned long address,
=20
 	pmd =3D pmd_offset(pud, address);
 	VM_BUG_ON(pmd_trans_huge(*pmd));
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto out;
=20
-	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
-	if (pmd_huge(*pmd))
+	if (pmd_huge(*pmd)) {
+		if (!pmdpp)
+			goto out;
+
+		*ptlp =3D pmd_lock(mm, pmd);
+		if (pmd_huge(*pmd)) {
+			*pmdpp =3D pmd;
+			return 0;
+		}
+		spin_unlock(*ptlp);
+	}
+
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
=20
 	ptep =3D pte_offset_map_lock(mm, pmd, address, ptlp);
@@ -3825,9 +3834,23 @@ static inline int follow_pte(struct mm_struct *mm, u=
nsigned long address,
=20
 	/* (void) is needed to make gcc happy */
 	(void) __cond_lock(*ptlp,
-			   !(res =3D __follow_pte(mm, address, ptepp, ptlp)));
+			   !(res =3D __follow_pte_pmd(mm, address, ptepp, NULL,
+					   ptlp)));
+	return res;
+}
+
+int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
+{
+	int res;
+
+	/* (void) is needed to make gcc happy */
+	(void) __cond_lock(*ptlp,
+			   !(res =3D __follow_pte_pmd(mm, address, ptepp, pmdpp,
+					   ptlp)));
 	return res;
 }
+EXPORT_SYMBOL(follow_pte_pmd);
=20
 /**
  * follow_pfn - look up PFN at a user virtual address


--7PJpdcUOVP20QEjC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu1qMACgkQ57/I7JWG
EQms6hAAxRicDzU+Es6jYRDrqNQSe4g+va/ooFHsaWOyCRYsCeOZtcY2C7CGi5dz
WqzE1XkFi1a8NTQ6ZAGh7n4s2K37w/z+jn+2QGiT5buT7ZY8rtmuJpn6rcHmpAk4
mFfPKwyoiwees33tzwjjVI4v1oT1TlE5WcvR9O3pSENA+jsGulx8bCE14zD0HECm
mfMcAvX4tDMEJI2RRqdfUPB34D/5zf8rcl1xrg2fCsDYVeNmYlPqv+YXbqUa/Kpn
BiuZ5OT7CEAcL+axg6IWb5c9IELMh7s0QTwG35TosQlTfVi7pqJTV9KQkCC5EeP8
VY5iBiVN8NLzFIJwoApUdq+w31GKyQf364/f5iGZ+yeCD5dAtFwpDNwEn8zfbuwZ
sdNBDLTmotd7iqYobrZ9aQH9pQvBxNQM7S92AmA2DozJbY2UXkbacok+cyKf0HAk
s3gi3aW69bnPmyKD4pxZEKPdtvu9nMgxgN5Jx8rMshGAw6PkZzR0EDjkyss/Piwf
pm3tG2KS9v6a08JsWmEsD0JDKpvBhvmLoK0zJH1o9avrN4CuE2wb61Jn3R0Q1j9b
cpc+GDA/wBjG8OxklcLOPx/viHZbFOZFL30yviArNY2ghwpAq2aDunn5tGKMHb9F
tyWxQM7EIRWeORx8CsFQGbV4YO6lZjd/CwydeJmrsVzqYKRutls=
=IjFR
-----END PGP SIGNATURE-----

--7PJpdcUOVP20QEjC--
