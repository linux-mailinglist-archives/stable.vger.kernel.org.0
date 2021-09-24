Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F01B4169F1
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 04:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbhIXCV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 22:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243863AbhIXCV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 22:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA60C61039;
        Fri, 24 Sep 2021 02:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632449995;
        bh=P4DFQiq303G1aONpTAkM+AmBbanoTbukwuAkgf+Z+oU=;
        h=Date:From:To:Subject:From;
        b=ltX8yyfmgmVQ1Ba9AIn4bS8umDB6dT8DnIYbXGTA6FvaqaROQNOBa/oXWEJk14tyY
         b4snrzxbRFTrrIFzS002wlLvbsP3mCW+T7P2PKDKzu3HphVsdzVC5viV0AAoWfwRt0
         YVEKZMjj3HRdU/lPGmZM+Rjmlzq+O7KkVzlHJraY=
Date:   Thu, 23 Sep 2021 19:19:54 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com, liwan@redhat.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        peterx@redhat.com, stable@vger.kernel.org
Subject:  +
 mm-userfaultfd-selftests-fix-memory-corruption-with-thp-enabled.patch added
 to -mm tree
Message-ID: <20210924021954.LeF2zWXJJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: selftests: fix memory corruption with thp enabled
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-selftests-fix-memory-corruption-with-thp-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-selftests-fix-memory-corruption-with-thp-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-selftests-fix-memory-corruption-with-thp-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: selftests: fix memory corruption with thp enabled

In RHEL's gating selftests we've encountered memory corruption in the uffd
event test even with upstream kernel:

        # ./userfaultfd anon 128 4
        nr_pages: 32768, nr_pages_per_cpu: 32768
        bounces: 3, mode: rnd racing read, userfaults: 6240 missing (6240) 14729 wp (14729)
        bounces: 2, mode: racing read, userfaults: 1444 missing (1444) 28877 wp (28877)
        bounces: 1, mode: rnd read, userfaults: 6055 missing (6055) 14699 wp (14699)
        bounces: 0, mode: read, userfaults: 82 missing (82) 25196 wp (25196)
        testing uffd-wp with pagemap (pgsize=4096): done
        testing uffd-wp with pagemap (pgsize=2097152): done
        testing events (fork, remap, remove): ERROR: nr 32427 memory corruption 0 1 (errno=0, line=963)
        ERROR: faulting process failed (errno=0, line=1117)

It can be easily reproduced when global thp enabled, which is the default for
RHEL.

It's also known as a side effect of commit 0db282ba2c12 ("selftest: use
mmap instead of posix_memalign to allocate memory", 2021-07-23), which is
imho right itself on using mmap() to make sure the addresses will be
untagged even on arm.

The problem is, for each test we allocate buffers using two
allocate_area() calls.  We assumed these two buffers won't affect each
other, however they could, because mmap() could have found that the two
buffers are near each other and having the same VMA flags, so they got
merged into one VMA.

It won't be a big problem if thp is not enabled, but when thp is
agressively enabled it means when initializing the src buffer it could
accidentally setup part of the dest buffer too when there's a shared THP
that overlaps the two regions.  Then some of the dest buffer won't be able
to be trapped by userfaultfd missing mode, then it'll cause memory
corruption as described.

To fix it, do release_pages() after initializing the src buffer.

Since the previous two release_pages() calls are after
uffd_test_ctx_clear() which will unmap all the buffers anyway (which is
stronger than release pages; as unmap() also tear town pgtables), drop
them as they shouldn't really be anything useful.

We can mark the Fixes tag upon 0db282ba2c12 as it's reported to only
happen there, however the real "Fixes" IMHO should be 8ba6e8640844, as
before that commit we'll always do explicit release_pages() before
registration of uffd, and 8ba6e8640844 changed that logic by adding extra
unmap/map and we didn't release the pages at the right place.  Meanwhile I
don't have a solid glue anyway on whether posix_memalign() could always
avoid triggering this bug, hence it's safer to attach this fix to commit
8ba6e8640844.

Link: https://lkml.kernel.org/r/20210923232512.210092-1-peterx@redhat.com
Fixes: 8ba6e8640844 ("userfaultfd/selftests: reinitialize test context in each test")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Li Wang <liwan@redhat.com>
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1994931
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   23 ++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~mm-userfaultfd-selftests-fix-memory-corruption-with-thp-enabled
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -414,9 +414,6 @@ static void uffd_test_ctx_init_ext(uint6
 	uffd_test_ops->allocate_area((void **)&area_src);
 	uffd_test_ops->allocate_area((void **)&area_dst);
 
-	uffd_test_ops->release_pages(area_src);
-	uffd_test_ops->release_pages(area_dst);
-
 	userfaultfd_open(features);
 
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
@@ -437,6 +434,26 @@ static void uffd_test_ctx_init_ext(uint6
 		*(area_count(area_src, nr) + 1) = 1;
 	}
 
+	/*
+	 * After initialization of area_src, we must explicitly release pages
+	 * for area_dst to make sure it's fully empty.  Otherwise we could have
+	 * some area_dst pages be errornously initialized with zero pages,
+	 * hence we could hit memory corruption later in the test.
+	 *
+	 * One example is when THP is globally enabled, above allocate_area()
+	 * calls could have the two areas merged into a single VMA (as they
+	 * will have the same VMA flags so they're mergeable).  When we
+	 * initialize the area_src above, it's possible that some part of
+	 * area_dst could have been faulted in via one huge THP that will be
+	 * shared between area_src and area_dst.  It could cause some of the
+	 * area_dst won't be trapped by missing userfaults.
+	 *
+	 * This release_pages() will guarantee even if that happened, we'll
+	 * proactively split the thp and drop any accidentally initialized
+	 * pages within area_dst.
+	 */
+	uffd_test_ops->release_pages(area_dst);
+
 	pipefd = malloc(sizeof(int) * nr_cpus * 2);
 	if (!pipefd)
 		err("pipefd");
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-selftests-fix-memory-corruption-with-thp-enabled.patch
mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
mm-smaps-simplify-shmem-handling-of-pte-holes.patch
mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte.patch
mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch
mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch

