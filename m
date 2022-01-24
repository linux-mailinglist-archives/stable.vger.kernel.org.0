Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12D8498182
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbiAXNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:55:23 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:41968 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiAXNzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:55:22 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nBzbT-0004zK-IJ; Mon, 24 Jan 2022 14:41:51 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nBzbS-009hoT-Vv;
        Mon, 24 Jan 2022 14:41:50 +0100
Date:   Mon, 24 Jan 2022 14:41:50 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, aarcange@redhat.com,
        willy@infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 4.9 2/2] gup: document and work around "COW can break either
 way" issue
Message-ID: <Ye6snojxPZQErYTw@decadent.org.uk>
References: <Ye6r1M/jrcVrUDXQ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CviTYG5SuAF1uBSj"
Content-Disposition: inline
In-Reply-To: <Ye6r1M/jrcVrUDXQ@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CviTYG5SuAF1uBSj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Linus Torvalds <torvalds@linux-foundation.org>

commit 9bbd42e79720122334226afad9ddcac1c3e6d373 upstream.

Doing a "get_user_pages()" on a copy-on-write page for reading can be
ambiguous: the page can be COW'ed at any time afterwards, and the
direction of a COW event isn't defined.

Yes, whoever writes to it will generally do the COW, but if the thread
that did the get_user_pages() unmapped the page before the write (and
that could happen due to memory pressure in addition to any outright
action), the writer could also just take over the old page instead.

End result: the get_user_pages() call might result in a page pointer
that is no longer associated with the original VM, and is associated
with - and controlled by - another VM having taken it over instead.

So when doing a get_user_pages() on a COW mapping, the only really safe
thing to do would be to break the COW when getting the page, even when
only getting it for reading.

At the same time, some users simply don't even care.

For example, the perf code wants to look up the page not because it
cares about the page, but because the code simply wants to look up the
physical address of the access for informational purposes, and doesn't
really care about races when a page might be unmapped and remapped
elsewhere.

This adds logic to force a COW event by setting FOLL_WRITE on any
copy-on-write mapping when FOLL_GET (or FOLL_PIN) is used to get a page
pointer as a result.

The current semantics end up being:

 - __get_user_pages_fast(): no change. If you don't ask for a write,
   you won't break COW. You'd better know what you're doing.

 - get_user_pages_fast(): the fast-case "look it up in the page tables
   without anything getting mmap_sem" now refuses to follow a read-only
   page, since it might need COW breaking.  Which happens in the slow
   path - the fast path doesn't know if the memory might be COW or not.

 - get_user_pages() (including the slow-path fallback for gup_fast()):
   for a COW mapping, turn on FOLL_WRITE for FOLL_GET/FOLL_PIN, with
   very similar semantics to FOLL_FORCE.

If it turns out that we want finer granularity (ie "only break COW when
it might actually matter" - things like the zero page are special and
don't need to be broken) we might need to push these semantics deeper
into the lookup fault path.  So if people care enough, it's possible
that we might end up adding a new internal FOLL_BREAK_COW flag to go
with the internal FOLL_COW flag we already have for tracking "I had a
COW".

Alternatively, if it turns out that different callers might want to
explicitly control the forced COW break behavior, we might even want to
make such a flag visible to the users of get_user_pages() instead of
using the above default semantics.

But for now, this is mostly commentary on the issue (this commit message
being a lot bigger than the patch, and that patch in turn is almost all
comments), with that minimal "enable COW breaking early" logic using the
existing FOLL_WRITE behavior.

[ It might be worth noting that we've always had this ambiguity, and it
  could arguably be seen as a user-space issue.

  You only get private COW mappings that could break either way in
  situations where user space is doing cooperative things (ie fork()
  before an execve() etc), but it _is_ surprising and very subtle, and
  fork() is supposed to give you independent address spaces.

  So let's treat this as a kernel issue and make the semantics of
  get_user_pages() easier to understand. Note that obviously a true
  shared mapping will still get a page that can change under us, so this
  does _not_ mean that get_user_pages() somehow returns any "stable"
  page ]

[surenb: backport notes
	Replaced (gup_flags | FOLL_WRITE) with write=3D1 in gup_pgd_range.
	Removed FOLL_PIN usage in should_force_cow_break since it's missing in
	the earlier kernels.]

Reported-by: Jann Horn <jannh@google.com>
Tested-by: Christoph Hellwig <hch@lst.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill Shutemov <kirill@shutemov.name>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[surenb: backport to 4.19 kernel]
Cc: stable@vger.kernel.org # 4.19.x
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9:
 - Generic get_user_pages_fast() calls __get_user_pages_fast() here,
   so make it pass write=3D1
 - Various architectures have their own implementations of
   get_user_pages_fast(), so apply the corresponding change there
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/mm/gup.c  |  9 ++++++++-
 arch/s390/mm/gup.c  |  9 ++++++++-
 arch/sh/mm/gup.c    |  9 ++++++++-
 arch/sparc/mm/gup.c |  9 ++++++++-
 arch/x86/mm/gup.c   |  9 ++++++++-
 mm/gup.c            | 44 ++++++++++++++++++++++++++++++++++++++------
 mm/huge_memory.c    |  7 +++----
 7 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index d8c3c159289a..71a19d20bbb7 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -271,7 +271,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
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
index cf045f56581e..be1e2ed6405d 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -261,7 +261,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
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
index 063c298ba56c..7fec66e34af0 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -239,7 +239,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
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
index cd0e32bbcb1d..685679f87988 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -218,7 +218,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
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
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 82f727fbbbd2..549f89fb3abc 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -454,7 +454,14 @@ int get_user_pages_fast(unsigned long start, int nr_pa=
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
diff --git a/mm/gup.c b/mm/gup.c
index 6bb7a8eb7f82..0b80bf3878dc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -61,13 +61,22 @@ static int follow_pfn_pte(struct vm_area_struct *vma, u=
nsigned long address,
 }
=20
 /*
- * FOLL_FORCE can write to even unwritable pte's, but only
- * after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE or a forced COW break can write even to unwritable pte's,
+ * but only after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+	return pte_write(pte) || ((flags & FOLL_COW) && pte_dirty(pte));
+}
+
+/*
+ * A (separate) COW fault might break the page the other way and
+ * get_user_pages() would return the page from what is now the wrong
+ * VM. So we need to force a COW break at GUP time even for reads.
+ */
+static inline bool should_force_cow_break(struct vm_area_struct *vma, unsi=
gned int flags)
+{
+	return is_cow_mapping(vma->vm_flags) && (flags & FOLL_GET);
 }
=20
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -577,12 +586,18 @@ static long __get_user_pages(struct task_struct *tsk,=
 struct mm_struct *mm,
 			if (!vma || check_vma_flags(vma, gup_flags))
 				return i ? : -EFAULT;
 			if (is_vm_hugetlb_page(vma)) {
+				if (should_force_cow_break(vma, foll_flags))
+					foll_flags |=3D FOLL_WRITE;
 				i =3D follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
-						gup_flags);
+						foll_flags);
 				continue;
 			}
 		}
+
+		if (should_force_cow_break(vma, foll_flags))
+			foll_flags |=3D FOLL_WRITE;
+
 retry:
 		/*
 		 * If we have a pending SIGKILL, don't keep faulting pages and
@@ -1503,6 +1518,10 @@ static int gup_pud_range(pgd_t pgd, unsigned long ad=
dr, unsigned long end,
 /*
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall b=
ack to
  * the regular GUP. It will only return non-negative values.
+ *
+ * Careful, careful! COW breaking can go either way, so a non-write
+ * access can get ambiguous page results. If you call this function without
+ * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -1532,6 +1551,12 @@ int __get_user_pages_fast(unsigned long start, int n=
r_pages, int write,
 	 *
 	 * We do not adopt an rcu_read_lock(.) here as we also want to
 	 * block IPIs that come from THPs splitting.
+	 *
+	 * NOTE! We allow read-only gup_fast() here, but you'd better be
+	 * careful about possible COW pages. You'll get _a_ COW page, but
+	 * not necessarily the one you intended to get depending on what
+	 * COW event happens after this. COW may break the page copy in a
+	 * random direction.
 	 */
=20
 	local_irq_save(flags);
@@ -1580,7 +1605,14 @@ int get_user_pages_fast(unsigned long start, int nr_=
pages, int write,
 	int nr, ret;
=20
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
 	ret =3D nr;
=20
 	if (nr < nr_pages) {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 91f33bb43f17..3f3a86cc62b6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1135,13 +1135,12 @@ int do_huge_pmd_wp_page(struct fault_env *fe, pmd_t=
 orig_pmd)
 }
=20
 /*
- * FOLL_FORCE can write to even unwritable pmd's, but only
- * after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE or a forced COW break can write even to unwritable pmd's,
+ * but only after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	return pmd_write(pmd) || ((flags & FOLL_COW) && pmd_dirty(pmd));
 }
=20
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,

--CviTYG5SuAF1uBSj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHurJ4ACgkQ57/I7JWG
EQnzmg//Ujdt3FtOfTRO4ufj2a8kUddur5j3onbybs2du/MhfeH+w4rsAncVs/Uz
yoEZDymOlYznnhh612HGx8Z/dcOPYPb8PVVK7jLLNUEyg6bCVgi61hq1tNzEw3WT
bN6SITb/ZYxKq1JPwhWGI1x5gEPtO5NH9TThuW931wWFXDSwO9/e1F32YnC/a+dV
Oy7ypOE+ZUGr0+9GVccG2ZNLweFinNEN/2TCnYjEMasKEkYdfVl+hrehvJFRvzMg
+/3i25+R2PijE7pmVOdwS3/khIENEoTMj3lCHbDIM/tS0A1qcdRmWtEg7bgx2MH/
E11frleWMLZ3/4Lka4YGhqR64TklGz8S9B9Rpp7JxIXaM4/p338ql9luOYvTLDxb
gJdLTynLRFSO2mX2o/JIxG0dVLtkCaf1gsDDDG4p+x2txq8sDKKXjc7xxPP1zQzw
AuQL6QT/2uk+JSxVhp55ZLmrDBYz+UFXprTqPEMnqky9Cwn0fCoXD0V9ECbDuuqn
HePzagFdJiZlkzQtQMhJkCPbePf1wx2kEZKO4LfH6xskwp2+tmADD1VNOEBMWdn1
zUBRuZ7nSgEee3wr/fUSmhGgHKJoD3e0YcNgGr1vrmPsW9YcB7aabYzAWSMsBIma
928+FHsMlcImpExyPKCW9pAmpsjOZ3bdVtfN5Lk8ULTsljYsQp4=
=ZOu9
-----END PGP SIGNATURE-----

--CviTYG5SuAF1uBSj--
