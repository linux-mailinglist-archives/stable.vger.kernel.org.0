Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9056564B39
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 03:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiGDBkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 21:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGDBkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 21:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E61062DA;
        Sun,  3 Jul 2022 18:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B34B61354;
        Mon,  4 Jul 2022 01:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB77C341C6;
        Mon,  4 Jul 2022 01:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656898822;
        bh=QRatlFXOdrJZqOJ8piCY0aN4RQSwBF3IVmNUc6PNudU=;
        h=Date:To:From:Subject:From;
        b=1d+AmekX6yzF7bbHsbMPA9fY1cHdHdlRsnWZnamhqcCFObLy7oesn1LFI2VZmB6SI
         XxPPcaT1RTtQUxIof2wJAkY3YP5IzbnodBVvgiAxHZgzyEYFLQJqJAEalG0M5PGR5i
         TgoQXITuHKtdIlBKmrVT08NnPvIh6m9h5qyynHj8=
Date:   Sun, 03 Jul 2022 18:40:21 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, osalvador@suse.de,
        mike.kravetz@oracle.com, liushixin2@huawei.com,
        linmiaohe@huawei.com, david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch added to mm-unstable branch
Message-Id: <20220704014022.5EB77C341C6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: separate path for hwpoison entry in copy_hugetlb_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch

This patch will later appear in the mm-unstable branch at
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
@@ -4802,8 +4802,13 @@ again:
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
mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

