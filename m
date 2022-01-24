Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DB4498180
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbiAXNzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:55:17 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:41958 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiAXNzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:55:17 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nBzYD-0004z6-Bv; Mon, 24 Jan 2022 14:38:29 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nBzYC-009hn2-Qk;
        Mon, 24 Jan 2022 14:38:28 +0100
Date:   Mon, 24 Jan 2022 14:38:28 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 4.9 1/2] Revert "gup: document and work around "COW can break
 either way" issue"
Message-ID: <Ye6r1M/jrcVrUDXQ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LvqzuX1fgUNnLBkz"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LvqzuX1fgUNnLBkz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This reverts commit 9bbd42e79720122334226afad9ddcac1c3e6d373, which
was commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.  The
backport was incorrect and incomplete:

* It forced the write flag on in the generic __get_user_pages_fast(),
  whereas only get_user_pages_fast() was supposed to do that.
* It only fixed the generic RCU-based implementation used by arm,
  arm64, and powerpc.  Before Linux 4.13, several other architectures
  had their own implementations: mips, s390, sparc, sh, and x86.

This will be followed by a (hopefully) correct backport.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
---
 mm/gup.c         | 48 ++++++++----------------------------------------
 mm/huge_memory.c |  7 ++++---
 2 files changed, 12 insertions(+), 43 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 301dd96ef176..6bb7a8eb7f82 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -61,22 +61,13 @@ static int follow_pfn_pte(struct vm_area_struct *vma, u=
nsigned long address,
 }
=20
 /*
- * FOLL_FORCE or a forced COW break can write even to unwritable pte's,
- * but only after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE can write to even unwritable pte's, but only
+ * after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) || ((flags & FOLL_COW) && pte_dirty(pte));
-}
-
-/*
- * A (separate) COW fault might break the page the other way and
- * get_user_pages() would return the page from what is now the wrong
- * VM. So we need to force a COW break at GUP time even for reads.
- */
-static inline bool should_force_cow_break(struct vm_area_struct *vma, unsi=
gned int flags)
-{
-	return is_cow_mapping(vma->vm_flags) && (flags & FOLL_GET);
+	return pte_write(pte) ||
+		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
 }
=20
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -586,18 +577,12 @@ static long __get_user_pages(struct task_struct *tsk,=
 struct mm_struct *mm,
 			if (!vma || check_vma_flags(vma, gup_flags))
 				return i ? : -EFAULT;
 			if (is_vm_hugetlb_page(vma)) {
-				if (should_force_cow_break(vma, foll_flags))
-					foll_flags |=3D FOLL_WRITE;
 				i =3D follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
-						foll_flags);
+						gup_flags);
 				continue;
 			}
 		}
-
-		if (should_force_cow_break(vma, foll_flags))
-			foll_flags |=3D FOLL_WRITE;
-
 retry:
 		/*
 		 * If we have a pending SIGKILL, don't keep faulting pages and
@@ -1518,10 +1503,6 @@ static int gup_pud_range(pgd_t pgd, unsigned long ad=
dr, unsigned long end,
 /*
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall b=
ack to
  * the regular GUP. It will only return non-negative values.
- *
- * Careful, careful! COW breaking can go either way, so a non-write
- * access can get ambiguous page results. If you call this function without
- * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -1551,12 +1532,6 @@ int __get_user_pages_fast(unsigned long start, int n=
r_pages, int write,
 	 *
 	 * We do not adopt an rcu_read_lock(.) here as we also want to
 	 * block IPIs that come from THPs splitting.
-	 *
-	 * NOTE! We allow read-only gup_fast() here, but you'd better be
-	 * careful about possible COW pages. You'll get _a_ COW page, but
-	 * not necessarily the one you intended to get depending on what
-	 * COW event happens after this. COW may break the page copy in a
-	 * random direction.
 	 */
=20
 	local_irq_save(flags);
@@ -1567,22 +1542,15 @@ int __get_user_pages_fast(unsigned long start, int =
nr_pages, int write,
 		next =3D pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			break;
-		/*
-		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
-		 * because get_user_pages() may need to cause an early COW in
-		 * order to avoid confusing the normal COW routines. So only
-		 * targets that are already writable are safe to do by just
-		 * looking at the page tables.
-		 */
 		if (unlikely(pgd_huge(pgd))) {
-			if (!gup_huge_pgd(pgd, pgdp, addr, next, 1,
+			if (!gup_huge_pgd(pgd, pgdp, addr, next, write,
 					  pages, &nr))
 				break;
 		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
-					 PGDIR_SHIFT, next, 1, pages, &nr))
+					 PGDIR_SHIFT, next, write, pages, &nr))
 				break;
-		} else if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
+		} else if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			break;
 	} while (pgdp++, addr =3D next, addr !=3D end);
 	local_irq_restore(flags);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3f3a86cc62b6..91f33bb43f17 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1135,12 +1135,13 @@ int do_huge_pmd_wp_page(struct fault_env *fe, pmd_t=
 orig_pmd)
 }
=20
 /*
- * FOLL_FORCE or a forced COW break can write even to unwritable pmd's,
- * but only after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE can write to even unwritable pmd's, but only
+ * after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) || ((flags & FOLL_COW) && pmd_dirty(pmd));
+	return pmd_write(pmd) ||
+	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
 }
=20
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,


--LvqzuX1fgUNnLBkz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHuq8sACgkQ57/I7JWG
EQlyqRAAncSoGfgudY0mIvNUfmvMso7uK+aUaXgS/FydFhM6a69r1utzsN7zk5J9
hL/A5wN/GD0PncoKNFiPC+5Sg08rIasHnckmWWZcCEsMQHs7PAb9ihSE1a2bJ+PX
JRV4SFd08kUEfr7KS+RjONDdfgY0GBIzRnA+k040SBorZWrSYp2FLTU5WgMcXVYi
9kEv+I9FDuwmrA/1NM/laaqyjocl384XBi1TaLgm5erXTxqhqYEXcsFXlLs5cArC
wp2imhae7cExa3wMEuln+OlvBkqaZiIhWVwhD262qTcx8Ru07ibwPU/5jwxjjWJ1
MdLfZOFjPABSUJdO/nzpk0xZsV/1h6PXXmgkJOFGAu5EudLfRvh6ik8RFNBqinHt
7CGXfANt5lbPdXSbLJl/KftRAHcbM5iHy/ydX0rNXabaL40f1/DUCaVcxuO5T7eT
DxxKhdrK05CPY7gvyu3/WzNtKLKscXfzPHsrPqz30KE9b/Yp2rf/suo3iwX3Nfie
gXbJkYQZ+nar/8Yrc0upK08gVDj8IOHRSsh97qhrUeu3Qbm/5wMp6tXf8/YxX0ZZ
v0h4C9bnnn+yPsgD0XKwFz1k9zs0ZIHQDFsnYr6gRcruEG5EPjhf5x6sVVrV/+bp
5ARp3WZvGJwUlTm4naw+cwulPFj+wKRRUXuRIhL4Qkg/haq1d2E=
=zjDh
-----END PGP SIGNATURE-----

--LvqzuX1fgUNnLBkz--
