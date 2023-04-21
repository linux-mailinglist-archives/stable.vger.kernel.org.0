Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE8F6EB3EB
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 23:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjDUVwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 17:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbjDUVwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 17:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8674E10E6;
        Fri, 21 Apr 2023 14:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F70B6532C;
        Fri, 21 Apr 2023 21:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7312EC4339B;
        Fri, 21 Apr 2023 21:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113952;
        bh=BOUkNt6qK7/zAGuXR7ZDwHwJWMRUDHqkhTK6x5wFfAQ=;
        h=Date:To:From:Subject:From;
        b=TMNlKeO0hKB6PDzrruOVe6wJx2EJv4M4DNes3HyWwcC0ra1A7wLS0DGAWS/pPJgTA
         88p8pz70DmGJpBQ7cTGIN6sH1+C8XdAYRiEmYYKChdQU4ZRYM4bTqW1QXNi0sxm0lA
         QjQLqJ2BX0B6VlaeT6gFT1wP8NIUgip8ltjW1brk=
Date:   Fri, 21 Apr 2023 14:52:31 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nadav.amit@gmail.com, mpenttil@redhat.com, mike.kravetz@oracle.com,
        david@redhat.com, axelrasmussen@google.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-uffd-wp-during-fork.patch removed from -mm tree
Message-Id: <20230421215232.7312EC4339B@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix uffd-wp during fork()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uffd-wp-during-fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix uffd-wp during fork()
Date: Mon, 17 Apr 2023 15:53:12 -0400

Patch series "mm/hugetlb: More fixes around uffd-wp vs fork() / RO pins",
v2.


This patch (of 6):

There're a bunch of things that were wrong:

  - Reading uffd-wp bit from a swap entry should use pte_swp_uffd_wp()
    rather than huge_pte_uffd_wp().

  - When copying over a pte, we should drop uffd-wp bit when
    !EVENT_FORK (aka, when !userfaultfd_wp(dst_vma)).

  - When doing early CoW for private hugetlb (e.g. when the parent page was
    pinned), uffd-wp bit should be properly carried over if necessary.

No bug reported probably because most people do not even care about these
corner cases, but they are still bugs and can be exposed by the recent unit
tests introduced, so fix all of them in one shot.

Link: https://lkml.kernel.org/r/20230417195317.898696-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20230417195317.898696-2-peterx@redhat.com
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wp-during-fork
+++ a/mm/hugetlb.c
@@ -4953,11 +4953,15 @@ static bool is_hugetlb_entry_hwpoisoned(
 
 static void
 hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
-		     struct folio *new_folio)
+		      struct folio *new_folio, pte_t old)
 {
+	pte_t newpte = make_huge_pte(vma, &new_folio->page, 1);
+
 	__folio_mark_uptodate(new_folio);
 	hugepage_add_new_anon_rmap(new_folio, vma, addr);
-	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, &new_folio->page, 1));
+	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(old))
+		newpte = huge_pte_mkuffd_wp(newpte);
+	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte);
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
 }
@@ -5032,14 +5036,12 @@ again:
 			 */
 			;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
-			bool uffd_wp = huge_pte_uffd_wp(entry);
-
-			if (!userfaultfd_wp(dst_vma) && uffd_wp)
+			if (!userfaultfd_wp(dst_vma))
 				entry = huge_pte_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
-			bool uffd_wp = huge_pte_uffd_wp(entry);
+			bool uffd_wp = pte_swp_uffd_wp(entry);
 
 			if (!is_readable_migration_entry(swp_entry) && cow) {
 				/*
@@ -5050,10 +5052,10 @@ again:
 							swp_offset(swp_entry));
 				entry = swp_entry_to_pte(swp_entry);
 				if (userfaultfd_wp(src_vma) && uffd_wp)
-					entry = huge_pte_mkuffd_wp(entry);
+					entry = pte_swp_mkuffd_wp(entry);
 				set_huge_pte_at(src, addr, src_pte, entry);
 			}
-			if (!userfaultfd_wp(dst_vma) && uffd_wp)
+			if (!userfaultfd_wp(dst_vma))
 				entry = huge_pte_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_pte_marker(entry))) {
@@ -5118,7 +5120,8 @@ again:
 					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
-				hugetlb_install_folio(dst_vma, dst_pte, addr, new_folio);
+				hugetlb_install_folio(dst_vma, dst_pte, addr,
+						      new_folio, src_pte_old);
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				continue;
@@ -5136,6 +5139,9 @@ again:
 				entry = huge_pte_wrprotect(entry);
 			}
 
+			if (!userfaultfd_wp(dst_vma))
+				entry = huge_pte_clear_uffd_wp(entry);
+
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 			hugetlb_count_add(npages, dst);
 		}
_

Patches currently in -mm which might be from peterx@redhat.com are


