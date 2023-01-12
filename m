Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75733666776
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbjALAPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjALAPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B94D111;
        Wed, 11 Jan 2023 16:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78C4DB81D81;
        Thu, 12 Jan 2023 00:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19090C433D2;
        Thu, 12 Jan 2023 00:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482501;
        bh=Bx3ZZvZzZ6Hkf8ZJpC4BDi338OlBUbysAdb/QRc9/bc=;
        h=Date:To:From:Subject:From;
        b=NtNjwYTLIuYP/WTAiTPMl9wldLRzHNhapzwUI8yAGIOLoIM5OSU17jgsaJwsHuHuH
         U4H+IUj5GFO6df+6a0JDqGXPQq5gz4JnNKaMxZQmrvkHkw6rk7wZS9ejQI0UCAt64V
         faNpoyXTGgFC6ASm9G06V9PUM80JJAvyNYxIGLwQ=
Date:   Wed, 11 Jan 2023 16:14:59 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch removed from -mm tree
Message-Id: <20230112001501.19090C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()
Date: Thu, 22 Dec 2022 21:55:11 +0100

We have to update the uffd-wp SWP PTE bit independent of the type of
migration entry.  Currently, if we're unlucky and we want to install/clear
the uffd-wp bit just while we're migrating a read-only mapped hugetlb
page, we would miss to set/clear the uffd-wp bit.

Further, if we're processing a readable-exclusive migration entry and
neither want to set or clear the uffd-wp bit, we could currently end up
losing the uffd-wp bit.  Note that the same would hold for writable
migrating entries, however, having a writable migration entry with the
uffd-wp bit set would already mean that something went wrong.

Note that the change from !is_readable_migration_entry ->
writable_migration_entry is harmless and actually cleaner, as raised by
Miaohe Lin and discussed in [1].

[1] https://lkml.kernel.org/r/90dd6a93-4500-e0de-2bf0-bf522c311b0c@huawei.com

Link: https://lkml.kernel.org/r/20221222205511.675832-3-david@redhat.com
Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection
+++ a/mm/hugetlb.c
@@ -6662,10 +6662,9 @@ unsigned long hugetlb_change_protection(
 		} else if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 			struct page *page = pfn_swap_entry_to_page(entry);
+			pte_t newpte = pte;
 
-			if (!is_readable_migration_entry(entry)) {
-				pte_t newpte;
-
+			if (is_writable_migration_entry(entry)) {
 				if (PageAnon(page))
 					entry = make_readable_exclusive_migration_entry(
 								swp_offset(entry));
@@ -6673,13 +6672,15 @@ unsigned long hugetlb_change_protection(
 					entry = make_readable_migration_entry(
 								swp_offset(entry));
 				newpte = swp_entry_to_pte(entry);
-				if (uffd_wp)
-					newpte = pte_swp_mkuffd_wp(newpte);
-				else if (uffd_wp_resolve)
-					newpte = pte_swp_clear_uffd_wp(newpte);
-				set_huge_pte_at(mm, address, ptep, newpte);
 				pages++;
 			}
+
+			if (uffd_wp)
+				newpte = pte_swp_mkuffd_wp(newpte);
+			else if (uffd_wp_resolve)
+				newpte = pte_swp_clear_uffd_wp(newpte);
+			if (!pte_same(pte, newpte))
+				set_huge_pte_at(mm, address, ptep, newpte);
 		} else if (unlikely(is_pte_marker(pte))) {
 			/* No other markers apply for now. */
 			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch
selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch

