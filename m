Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2846547CB
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 22:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiLVVXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 16:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLVVXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 16:23:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7275F13F2F;
        Thu, 22 Dec 2022 13:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24A37B81F76;
        Thu, 22 Dec 2022 21:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD80C433EF;
        Thu, 22 Dec 2022 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671744223;
        bh=5FYm8ff9PhR5cRsUP72mq7yHpLwA0cLjyq9+cHK73Kk=;
        h=Date:To:From:Subject:From;
        b=ZM8F/7SFizPTTAvaHBXTTgak10LYvqHrrpuAoofa8C4RRNOOQH5BoBAnD32fEfUvC
         WMHAG8NdQIIHDwx7Nsf+Resc3rAxfFgPpOXKmevLxFUX53RzHl2CKDwvUIfeZPqNya
         gaN+gXW+LBQBmaD8glDons5kzsEgOJMFH6M1hw6E=
Date:   Thu, 22 Dec 2022 13:23:43 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch added to mm-hotfixes-unstable branch
Message-Id: <20221222212343.BAD80C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch

