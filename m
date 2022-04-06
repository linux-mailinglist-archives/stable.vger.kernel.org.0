Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33D74F6C8F
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiDFVZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbiDFVYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:24:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 523651CCACC
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 13:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649276403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y6AHHLD9ALvMEWgiEVKcbVnhb1N4MGAMpb0FIQGAfjo=;
        b=jQ2UBh4r2o2nBHuDe8yxJYivahc2zrGSJLYDooxHmFrY8Ia2dH9iu4qgIVEso1t4GBiVml
        8EEcJs24dL0cGLk/0nFCj4H5xAItoPN2cChkvq6Lly2oe7vB67Pge7mqt1757YcGAEF8Ep
        EG2AxeBynLJInOAMV2o4akK8qAuLO+8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-15o-5UhbNkWBZeVNdGVEXw-1; Wed, 06 Apr 2022 16:20:02 -0400
X-MC-Unique: 15o-5UhbNkWBZeVNdGVEXw-1
Received: by mail-il1-f200.google.com with SMTP id x1-20020a056e020f0100b002c98fce9c13so2482018ilj.3
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 13:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y6AHHLD9ALvMEWgiEVKcbVnhb1N4MGAMpb0FIQGAfjo=;
        b=jBHBPAlgnwtT8FKyRF2RsqMjFftC0MKiNN73a90VHEuPaUdgpUT0AiBlEGN1Jqh5dY
         qPKEM0iHr3iv71ObuLKw1F6612Tk6iVYUsricZLDe5OcfbVd9IK4gjpUAWv3fQEYwhiL
         QXywdWtxCP1gc5QW/nhPifrZvfRIq3zYZ60iJ8AJInVYyttRXgKJOnwpHFiXTDiU0hI9
         kTlIHgAm6C0hBRSbfdvElPvO/4Zgrt5j/tfYX3M6IrRvdrRHwbBrkslaHFKaD/ZBz3it
         b0I77pjPFhN4CO6zZM9CjP8/immiUMuS5x/eSy0TpD7KuXKUziTRf5CNgtqR7DBerPPI
         3E1w==
X-Gm-Message-State: AOAM532hD5HAeNdfNeVCXKi7bmUhH4J1jr920bjiFPBVyYN1UfAB9fZM
        1Ecct3NE3j+K67FhIH1veS5a7Q0814T8p0NujQR7KBRkuiFwYhOoVIU3HCb0buFGdpMFV4EyvHL
        SuSm/CAokz2bBy32A
X-Received: by 2002:a05:6602:26cd:b0:649:2bae:a63a with SMTP id g13-20020a05660226cd00b006492baea63amr4963770ioo.148.1649276401580;
        Wed, 06 Apr 2022 13:20:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/MS3eBdeTZJ2bpXKl9PxSXDAHXQI7KRoOUCjnjywmKg+Y4g9oEHXI8KDmMj550EjuP7HR1Q==
X-Received: by 2002:a05:6602:26cd:b0:649:2bae:a63a with SMTP id g13-20020a05660226cd00b006492baea63amr4963760ioo.148.1649276401319;
        Wed, 06 Apr 2022 13:20:01 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id x186-20020a6bc7c3000000b00648deae6630sm11248491iof.54.2022.04.06.13.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:20:00 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:19:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        david@redhat.com, hughd@google.com, jhubbard@nvidia.com,
        kirill@shutemov.name, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: don't skip swap entry even if
 zap_details specified" failed to apply to 5.15-stable tree
Message-ID: <Yk31709QxFzKHPta@xz-m1.local>
References: <1648817504102234@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/WFeP7NRMf8M9+cU"
Content-Disposition: inline
In-Reply-To: <1648817504102234@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/WFeP7NRMf8M9+cU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline



--/WFeP7NRMf8M9+cU
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="patch-5.15.y"

From 11fad3a3088d5059cc6b12314c679ba1547a7224 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 22 Mar 2022 14:42:15 -0700
Subject: [PATCH] mm: don't skip swap entry even if zap_details specified

NOTE: this is cherry-picked from 5abfd71d936a8aefd9f9ccd299dea7a164a5d455
but backported explicitly to stable branch.

A few notes:

  - zap_mapping used to be called check_mapping.

  - The patch is simplified, e.g. we don't add hwpoison handling or
    explicit WARN_ON_ONCE() but only start to look after all swap entries.

  - There was no zap_skip_check_mapping() yet in the branch, so it's
    written in the full form to check against zap_details.check_mapping for
    the migration entry checks.

Original commit message below.

=============================

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
(cherry picked from commit 5abfd71d936a8aefd9f9ccd299dea7a164a5d455)
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/memory.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c52be6d6b605..13a5b8bea918 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1301,6 +1301,17 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
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
@@ -1396,16 +1407,18 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
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
-- 
2.32.0


--/WFeP7NRMf8M9+cU--

