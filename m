Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9C23B554A
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhF0VzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231713AbhF0VzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C69AF61C32;
        Sun, 27 Jun 2021 21:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830755;
        bh=lwSo3++hm/faJmgVZDRI49qp8rZ955xcPnE4qwwZA9M=;
        h=Date:From:To:Subject:From;
        b=sKDE8yVcGJLJUqTTbn1EwmoE8wDfZfFZpwMOCVdCVVRfJr5Ik40K5cP8xe4nQr+77
         CEzyL/fMnhBjJN3/F/Fwg6y3pj/hQeFlz+aLCTHTt3940/wj0HNNnNdWkerM1Hhs6F
         fGfTmYdqt0IjyDI5F9oPC7su3ZFH0Ae9ZVrQIQBQ=
Date:   Sun, 27 Jun 2021 14:52:34 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, stable@vger.kernel.org
Subject:  [merged]
 mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch
 removed from -mm tree
Message-ID: <20210627215234.6qty3u8gL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare

I found it by pure code review, that pte_same_as_swp() of unuse_vma()
didn't take uffd-wp bit into account when comparing ptes. 
pte_same_as_swp() returning false negative could cause failure to swapoff
swap ptes that was wr-protected by userfaultfd.

Link: https://lkml.kernel.org/r/20210603180546.9083-1-peterx@redhat.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[5.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   15 +++++++++++----
 mm/swapfile.c           |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/swapops.h~mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare
+++ a/include/linux/swapops.h
@@ -23,6 +23,16 @@
 #define SWP_TYPE_SHIFT	(BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
 #define SWP_OFFSET_MASK	((1UL << SWP_TYPE_SHIFT) - 1)
 
+/* Clear all flags but only keep swp_entry_t related information */
+static inline pte_t pte_swp_clear_flags(pte_t pte)
+{
+	if (pte_swp_soft_dirty(pte))
+		pte = pte_swp_clear_soft_dirty(pte);
+	if (pte_swp_uffd_wp(pte))
+		pte = pte_swp_clear_uffd_wp(pte);
+	return pte;
+}
+
 /*
  * Store a type+offset into a swp_entry_t in an arch-independent format
  */
@@ -66,10 +76,7 @@ static inline swp_entry_t pte_to_swp_ent
 {
 	swp_entry_t arch_entry;
 
-	if (pte_swp_soft_dirty(pte))
-		pte = pte_swp_clear_soft_dirty(pte);
-	if (pte_swp_uffd_wp(pte))
-		pte = pte_swp_clear_uffd_wp(pte);
+	pte = pte_swp_clear_flags(pte);
 	arch_entry = __pte_to_swp_entry(pte);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
--- a/mm/swapfile.c~mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare
+++ a/mm/swapfile.c
@@ -1900,7 +1900,7 @@ unsigned int count_swap_pages(int type,
 
 static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
 {
-	return pte_same(pte_swp_clear_soft_dirty(pte), swp_pte);
+	return pte_same(pte_swp_clear_flags(pte), swp_pte);
 }
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup_benchmark-support-threading.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch

