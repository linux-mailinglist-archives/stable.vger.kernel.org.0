Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541AD6E3ABD
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjDPRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDPRmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4510CB;
        Sun, 16 Apr 2023 10:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B43860F01;
        Sun, 16 Apr 2023 17:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C31C433EF;
        Sun, 16 Apr 2023 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666918;
        bh=HgwYJBdZK/mKhljp4rHZ82TujPNi37wyFeqrp7iL4dU=;
        h=Date:To:From:Subject:From;
        b=ChINGd6y0zbqIoyEtg4jIw1qHOGhOWuUJfmOG0DyHiyQ63HFyARDqX1oXqs+cP8PE
         ec+wnmFpRCdZwcQGw3EUfO6A9r9BV8akCKVhsyFyKTBvo3QMiN/z9yqUoKR9HuFeSv
         6Q4U9ziRE/uqajmO7wesjAsjt694wbIYRctcOgGY=
Date:   Sun, 16 Apr 2023 10:41:57 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        david@redhat.com, axelrasmussen@google.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch removed from -mm tree
Message-Id: <20230416174157.E6C31C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: check again on anon uffd-wp during isolation
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/khugepaged: check again on anon uffd-wp during isolation
Date: Wed, 5 Apr 2023 11:51:20 -0400

Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd
round done in __collapse_huge_page_isolate() after
hpage_collapse_scan_pmd(), during which all the locks will be released
temporarily.  It means the pgtable can change during this phase before 2nd
round starts.

It's logically possible some ptes got wr-protected during this phase, and
we can errornously collapse a thp without noticing some ptes are
wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only
did that for the 1st phase, not the 2nd phase.

Since __collapse_huge_page_isolate() happens after a round of small page
swapins, we don't need to worry on any !present ptes - if it existed
khugepaged will already bail out.  So we only need to check present ptes
with uffd-wp bit set there.

This is something I found only but never had a reproducer, I thought it
was one caused a bug in Muhammad's recent pagemap new ioctl work, but it
turns out it's not the cause of that but an userspace bug.  However this
seems to still be a real bug even with a very small race window, still
worth to have it fixed and copy stable.

Link: https://lkml.kernel.org/r/20230405155120.3608140-1-peterx@redhat.com
Fixes: e1e267c7928f ("khugepaged: skip collapse if uffd-wp detected")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation
+++ a/mm/khugepaged.c
@@ -573,6 +573,10 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
+		if (pte_uffd_wp(pteval)) {
+			result = SCAN_PTE_UFFD_WP;
+			goto out;
+		}
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch

