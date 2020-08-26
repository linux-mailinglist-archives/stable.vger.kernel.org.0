Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D212524C4
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 02:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHZAik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 20:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgHZAik (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 20:38:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F168E20737;
        Wed, 26 Aug 2020 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598402319;
        bh=FTTpw/iHR2T6EVlznk4a/o+pDus8FlyY5Z0rM0R5LNw=;
        h=Date:From:To:Subject:From;
        b=ARIyR3mqRSOkOvi6FFK+kIvWHs3wNzeWwtPgnPWpJNtn7OtItxRvzraz3yl3W84lg
         3ZRgIJ7ci0wXv6ybymQhQXuLMZM2wrO1SBbXs7TK1zrs+CHCLcKkDFOaZkKpTxVXfm
         AEz5+13SMHvHEQMeT6vJ0V1lcYLY/gxUVKpRHyd8=
Date:   Tue, 25 Aug 2020 17:38:38 -0700
From:   akpm@linux-foundation.org
To:     alistair@popple.id.au, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, stable@vger.kernel.org
Subject:  + mm-rmap-fixup-copying-of-soft-dirty-and-uffd-ptes.patch
 added to -mm tree
Message-ID: <20200826003838.aqAgh1Wow%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/rmap: fixup copying of soft dirty and uffd ptes
has been added to the -mm tree.  Its filename is
     mm-rmap-fixup-copying-of-soft-dirty-and-uffd-ptes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fixup-copying-of-soft=
-dirty-and-uffd-ptes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fixup-copying-of-soft=
-dirty-and-uffd-ptes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Alistair Popple <alistair@popple.id.au>
Subject: mm/rmap: fixup copying of soft dirty and uffd ptes

During memory migration a pte is temporarily replaced with a migration
swap pte.  Some pte bits from the existing mapping such as the soft-dirty
and uffd write-protect bits are preserved by copying these to the
temporary migration swap pte.

However these bits are not stored at the same location for swap and
non-swap ptes.  Therefore testing these bits requires using the
appropriate helper function for the given pte type.

Unfortunately several code locations were found where the wrong helper
function is being used to test soft_dirty and uffd_wp bits which leads to
them getting incorrectly set or cleared during page-migration.

Fix these by using the correct tests based on pte type.

Link: https://lkml.kernel.org/r/20200825064232.10023-2-alistair@popple.id.au
Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page i=
n migration")
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while c=
ollecting pages")
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Alistair Popple <alistair@popple.id.au>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Alistair Popple <alistair@popple.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   15 +++++++++++----
 mm/rmap.c    |    9 +++++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-rmap-fixup-copying-of-soft-dirty-and-uffd-ptes
+++ a/mm/migrate.c
@@ -2427,10 +2427,17 @@ again:
 			entry =3D make_migration_entry(page, mpfn &
 						     MIGRATE_PFN_WRITE);
 			swp_pte =3D swp_entry_to_pte(entry);
-			if (pte_soft_dirty(pte))
-				swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
-			if (pte_uffd_wp(pte))
-				swp_pte =3D pte_swp_mkuffd_wp(swp_pte);
+			if (pte_present(pte)) {
+				if (pte_soft_dirty(pte))
+					swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
+				if (pte_uffd_wp(pte))
+					swp_pte =3D pte_swp_mkuffd_wp(swp_pte);
+			} else {
+				if (pte_swp_soft_dirty(pte))
+					swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
+				if (pte_swp_uffd_wp(pte))
+					swp_pte =3D pte_swp_mkuffd_wp(swp_pte);
+			}
 			set_pte_at(mm, addr, ptep, swp_pte);
=20
 			/*
--- a/mm/rmap.c~mm-rmap-fixup-copying-of-soft-dirty-and-uffd-ptes
+++ a/mm/rmap.c
@@ -1511,9 +1511,14 @@ static bool try_to_unmap_one(struct page
 			 */
 			entry =3D make_migration_entry(page, 0);
 			swp_pte =3D swp_entry_to_pte(entry);
-			if (pte_soft_dirty(pteval))
+
+			/*
+			 * pteval maps a zone device page and is therefore
+			 * a swap pte.
+			 */
+			if (pte_swp_soft_dirty(pteval))
 				swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
-			if (pte_uffd_wp(pteval))
+			if (pte_swp_uffd_wp(pteval))
 				swp_pte =3D pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 			/*
_

Patches currently in -mm which might be from alistair@popple.id.au are

mm-migrate-fixup-setting-uffd_wp-flag.patch
mm-rmap-fixup-copying-of-soft-dirty-and-uffd-ptes.patch

