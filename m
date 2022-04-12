Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF94FD6B0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351648AbiDLHV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351847AbiDLHNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A98386;
        Mon, 11 Apr 2022 23:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527F3B81B47;
        Tue, 12 Apr 2022 06:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4D9C385A6;
        Tue, 12 Apr 2022 06:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746414;
        bh=dTR6SfiSLtwiyxMdwW4U/3rWA7waMXIis8gdthuGMos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knel5eCdo+9KV9yr6UtQIg9Y8IPIFeTuLZ1metKOj3iBr+of2EBjTX6NLiDDtfRNf
         SJVupeiES1m4tsZvnoL8iBYnEveqFSFUfQRoFuc9g6uhrsd7VSNIo9CA8hiOCGwvtq
         tX4ZJRGpicZeSHiOSacy+Ly+HqxQcalpTwzW09/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Alistair Popple <apopple@nvidia.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 267/277] mm: dont skip swap entry even if zap_details specified
Date:   Tue, 12 Apr 2022 08:31:10 +0200
Message-Id: <20220412062949.770315294@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 5abfd71d936a8aefd9f9ccd299dea7a164a5d455 upstream.

Patch series "mm: Rework zap ptes on swap entries", v5.

Patch 1 should fix a long standing bug for zap_pte_range() on
zap_details usage.  The risk is we could have some swap entries skipped
while we should have zapped them.

Migration entries are not the major concern because file backed memory
always zap in the pattern that "first time without page lock, then
re-zap with page lock" hence the 2nd zap will always make sure all
migration entries are already recovered.

However there can be issues with real swap entries got skipped
errornoously.  There's a reproducer provided in commit message of patch
1 for that.

Patch 2-4 are cleanups that are based on patch 1.  After the whole
patchset applied, we should have a very clean view of zap_pte_range().

Only patch 1 needs to be backported to stable if necessary.

This patch (of 4):

The "details" pointer shouldn't be the token to decide whether we should
skip swap entries.

For example, when the callers specified details->zap_mapping==NULL, it
means the user wants to zap all the pages (including COWed pages), then
we need to look into swap entries because there can be private COWed
pages that was swapped out.

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
genuine swap entries too.

To be explicit, we should still remember to keep the private entries if
even_cows==false, and always zap them when even_cows==true.

The issue seems to exist starting from the initial commit of git.

[peterx@redhat.com: comment tweaks]
  Link: https://lkml.kernel.org/r/20220217060746.71256-2-peterx@redhat.com

Link: https://lkml.kernel.org/r/20220217060746.71256-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220216094810.60572-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220216094810.60572-2-peterx@redhat.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1301,6 +1301,17 @@ copy_page_range(struct vm_area_struct *d
 	return ret;
 }
 
+/* Whether we should zap all COWed (private) pages too */
+static inline bool should_zap_cows(struct zap_details *details)
+{
+	/* By default, zap all pages */
+	if (!details)
+		return true;
+
+	/* Or, we zap COWed pages only if the caller wants to */
+	return !details->check_mapping;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1396,16 +1407,18 @@ again:
 			continue;
 		}
 
-		/* If details->check_mapping, we leave swap entries. */
-		if (unlikely(details))
-			continue;
-
-		if (!non_swap_entry(entry))
+		if (!non_swap_entry(entry)) {
+			/* Genuine swap entry, hence a private anon page */
+			if (!should_zap_cows(details))
+				continue;
 			rss[MM_SWAPENTS]--;
-		else if (is_migration_entry(entry)) {
+		} else if (is_migration_entry(entry)) {
 			struct page *page;
 
 			page = pfn_swap_entry_to_page(entry);
+			if (details && details->check_mapping &&
+			    details->check_mapping != page_rmapping(page))
+				continue;
 			rss[mm_counter(page)]--;
 		}
 		if (unlikely(!free_swap_and_cache(entry)))


