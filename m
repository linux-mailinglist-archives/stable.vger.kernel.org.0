Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C83577451
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 06:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiGQEiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 00:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiGQEiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 00:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC848220FE;
        Sat, 16 Jul 2022 21:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D3F60FB5;
        Sun, 17 Jul 2022 04:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90AFC3411E;
        Sun, 17 Jul 2022 04:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032678;
        bh=nzpO4emgmNMUvGHnf6O8M3OIlScM1Tb4QLT3Vau0fig=;
        h=Date:To:From:Subject:From;
        b=SlQFdKbkU1HMgfnMxc6/uULfX9z/A7wBfWOxzlY2AZ3eE4jpe3dHZYVk0WTCKsA3G
         fpResxRtu3Q3tbix57PENsn5i9rzJh3cnO0K3QBszUa1k5YlLn/c+jLso10y3PvHD9
         0mkjGrN6+hw1SpKCT0Tcj3mDiffoqOw75tBRwQDg=
Date:   Sat, 16 Jul 2022 21:37:58 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, osalvador@suse.de,
        mike.kravetz@oracle.com, liushixin2@huawei.com,
        linmiaohe@huawei.com, david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch removed from -mm tree
Message-Id: <20220717043758.D90AFC3411E@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: separate path for hwpoison entry in copy_hugetlb_page_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hugetlb: separate path for hwpoison entry in copy_hugetlb_page_range()
Date: Mon, 4 Jul 2022 10:33:05 +0900

Originally copy_hugetlb_page_range() handles migration entries and
hwpoisoned entries in similar manner.  But recently the related code path
has more code for migration entries, and when
is_writable_migration_entry() was converted to
!is_readable_migration_entry(), hwpoison entries on source processes got
to be unexpectedly updated (which is legitimate for migration entries, but
not for hwpoison entries).  This results in unexpected serious issues like
kernel panic when forking processes with hwpoison entries in pmd.

Separate the if branch into one for hwpoison entries and one for migration
entries.

Link: https://lkml.kernel.org/r/20220704013312.2415700-3-naoya.horiguchi@linux.dev
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>	[5.18]
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range
+++ a/mm/hugetlb.c
@@ -4788,8 +4788,13 @@ again:
 			 * sharing with another vma.
 			 */
 			;
-		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
-				    is_hugetlb_entry_hwpoisoned(entry))) {
+		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
+			bool uffd_wp = huge_pte_uffd_wp(entry);
+
+			if (!userfaultfd_wp(dst_vma) && uffd_wp)
+				entry = huge_pte_clear_uffd_wp(entry);
+			set_huge_pte_at(dst, addr, dst_pte, entry);
+		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 			bool uffd_wp = huge_pte_uffd_wp(entry);
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

