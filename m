Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C54B9623
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 03:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiBQC5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 21:57:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiBQC5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 21:57:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C1BB12F3;
        Wed, 16 Feb 2022 18:57:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8051CB820DC;
        Thu, 17 Feb 2022 02:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173DDC004E1;
        Thu, 17 Feb 2022 02:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066619;
        bh=ePhX2RruMr9W49uP2YRCaqDU5OcuHvPV81rxXcCZpwc=;
        h=Date:To:From:Subject:From;
        b=1L0SX12tz1toejMzuSH5aCRun4IGA06vUxsIO+yYTj6YwMG/6tVbD60VVpU8BzJne
         RsV8SJuCFD+ZSAPALOzX+PoVbfNvfOqBoQNGQRnqFriyrvqycXJ0srw/7QPg/i5I35
         S2WlCMHPa2qw9qgAPJcoj5jRXM0F2jOR9ODQplA8=
Date:   Wed, 16 Feb 2022 18:56:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, shy828301@gmail.com, kirill@shutemov.name,
        jhubbard@nvidia.com, hughd@google.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-skip-swap-entry-even-if-zap_details-specified.patch added to -mm tree
Message-Id: <20220217025659.173DDC004E1@smtp.kernel.org>
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
     Subject: mm: don't skip swap entry even if zap_details specified
has been added to the -mm tree.  Its filename is
     mm-dont-skip-swap-entry-even-if-zap_details-specified.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-skip-swap-entry-even-if-zap_details-specified.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-skip-swap-entry-even-if-zap_details-specified.patch

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
Subject: mm: don't skip swap entry even if zap_details specified

Patch series "mm: Rework zap ptes on swap entries", v4.

Patch 1 should fix a long standing bug for zap_pte_range() on zap_details
usage.  The risk is we could have some swap entries skipped while we should
have zapped them.

Migration entries are not the major concern because file backed memory always
zap in the pattern that "first time without page lock, then re-zap with page
lock" hence the 2nd zap will always make sure all migration entries are already
recovered.

However there can be issues with real swap entries got skipped errornoously.
There's a reproducer provided in commit message of patch 1 for that.

Patch 2-4 are cleanups that are based on patch 1.  After the whole patchset
applied, we should have a very clean view of zap_pte_range().

Only patch 1 needs to be backported to stable if necessary.


This patch (of 4):

The "details" pointer shouldn't be the token to decide whether we should
skip swap entries.  For example, when the caller specified
details->zap_mapping==NULL, it means the caller wants to zap all the pages
(including COWed pages), then we need to look into swap entries because
there can be private COWed pages that was swapped out.

Skipping some swap entries when details is non-NULL may lead to wrongly
leaving some of the swap entries while we should have zapped them.

A reproducer of the problem:

===8<===
        #define _GNU_SOURCE         /* See feature_test_macros(7) */
        #include <stdio.h>
        #include <assert.h>
        #include <unistd.h>
        #include <sys/mman.h>
        #include <sys/types.h>

        int page_size;
        int shmem_fd;
        char *buffer;

        void main(void)
        {
                int ret;
                char val;

                page_size = getpagesize();
                shmem_fd = memfd_create("test", 0);
                assert(shmem_fd >= 0);

                ret = ftruncate(shmem_fd, page_size * 2);
                assert(ret == 0);

                buffer = mmap(NULL, page_size * 2, PROT_READ | PROT_WRITE,
                                MAP_PRIVATE, shmem_fd, 0);
                assert(buffer != MAP_FAILED);

                /* Write private page, swap it out */
                buffer[page_size] = 1;
                madvise(buffer, page_size * 2, MADV_PAGEOUT);

                /* This should drop private buffer[page_size] already */
                ret = ftruncate(shmem_fd, page_size);
                assert(ret == 0);
                /* Recover the size */
                ret = ftruncate(shmem_fd, page_size * 2);
                assert(ret == 0);

                /* Re-read the data, it should be all zero */
                val = buffer[page_size];
                if (val == 0)
                        printf("Good\n");
                else
                        printf("BUG\n");
        }
===8<===

We don't need to touch up the pmd path, because pmd never had a issue with
swap entries.  For example, shmem pmd migration will always be split into
pte level, and same to swapping on anonymous.

Add another helper should_zap_cows() so that we can also check whether we
should zap private mappings when there's no page pointer specified.

This patch drops that trick, so we handle swap ptes coherently.  Meanwhile
we should do the same check upon migration entry, hwpoison entry and
genuine swap entries too.  To be explicit, we should still remember to
keep the private entries if even_cows==false, and always zap them when
even_cows==true.

The issue seems to exist starting from the initial commit of git.

Link: https://lkml.kernel.org/r/20220216094810.60572-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220216094810.60572-2-peterx@redhat.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-dont-skip-swap-entry-even-if-zap_details-specified
+++ a/mm/memory.c
@@ -1313,6 +1313,17 @@ struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
 };
 
+/* Whether we should zap all COWed (private) pages too */
+static inline bool should_zap_cows(struct zap_details *details)
+{
+	/* By default, zap all pages */
+	if (!details)
+		return true;
+
+	/* Or, we zap COWed pages only if the caller wants to */
+	return !details->zap_mapping;
+}
+
 /*
  * We set details->zap_mapping when we want to unmap shared but keep private
  * pages. Return true if skip zapping this page, false otherwise.
@@ -1320,11 +1331,15 @@ struct zap_details {
 static inline bool
 zap_skip_check_mapping(struct zap_details *details, struct page *page)
 {
-	if (!details || !page)
+	/* If we can make a decision without *page.. */
+	if (should_zap_cows(details))
+		return false;
+
+	/* E.g. zero page */
+	if (!page)
 		return false;
 
-	return details->zap_mapping &&
-		(details->zap_mapping != page_rmapping(page));
+	return details->zap_mapping != page_rmapping(page);
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
@@ -1405,17 +1420,29 @@ again:
 			continue;
 		}
 
-		/* If details->check_mapping, we leave swap entries. */
-		if (unlikely(details))
-			continue;
-
-		if (!non_swap_entry(entry))
+		if (!non_swap_entry(entry)) {
+			/*
+			 * If this is a genuine swap entry, then it must be an
+			 * private anon page.  If the caller wants to skip
+			 * COWed pages, ignore it.
+			 */
+			if (!should_zap_cows(details))
+				continue;
 			rss[MM_SWAPENTS]--;
-		else if (is_migration_entry(entry)) {
+		} else if (is_migration_entry(entry)) {
 			struct page *page;
 
 			page = pfn_swap_entry_to_page(entry);
+			if (zap_skip_check_mapping(details, page))
+				continue;
 			rss[mm_counter(page)]--;
+		} else if (is_hwpoison_entry(entry)) {
+			/* If the caller wants to skip COWed pages, ignore it */
+			if (!should_zap_cows(details))
+				continue;
+		} else {
+			/* We should have covered all the swap entry types */
+			WARN_ON_ONCE(1);
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
 			print_bad_pte(vma, addr, ptent, NULL);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch
mm-dont-skip-swap-entry-even-if-zap_details-specified.patch
mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
mm-change-zap_detailszap_mapping-into-even_cows.patch
mm-rework-swap-handling-of-zap_pte_range.patch

