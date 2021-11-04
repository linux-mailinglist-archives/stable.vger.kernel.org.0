Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6FA445B7E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhKDVKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhKDVKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 17:10:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F37C061714;
        Thu,  4 Nov 2021 14:07:55 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l3so5077852pfu.13;
        Thu, 04 Nov 2021 14:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9BiJt54qFZ/VuFOPoUw2HvY4OErYWaH/g0QELRHYaEM=;
        b=JR2B77A7w9AxNwZiwRneH3U+LDgO7FF6to59gQG7raqqjhoqQaITMu1qzPmDRxdQ1e
         HkM5PZsZZjGaSa5A4x03k5PzwVqNfTluN5kCPt/LHWA/+bnTDiLKzoutgfmfRiOO7OBi
         3779F30Gzg9jNMvKNqo7IDTzrryKU/Wb4nxdSMkuW7Ga2wQAAMxb5mrowJtGyuEtiXqs
         32kh0w+PYo/X9QHiehvQ5HNlxhCZWNo3HJntQsU+49r7PWh4LRpPFlMCKEsyR5cz4/v8
         aLX5xkCun5dKl184rAsaLUawLTit6+7yG8rhTwRn26uqCAKeFkyMaPKad7jMSi4ntbw9
         Ulng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9BiJt54qFZ/VuFOPoUw2HvY4OErYWaH/g0QELRHYaEM=;
        b=bvRZAzV2a8Ikz9NzMc689wFTBBulfMxQ8hoeMh+kPfPc4K+e7z3y91x4vW8haZmTnK
         Wyd/R6uHHl8/qGHnAI8SSpyCfgjsViA4WHuam28LZ/CATqtYf1mliXkEZlhgU1+sfNKt
         Hoqhdlj4NcF2EtvZ8MEXeLqF6z2gakQTNc8ghj9QYZdOm3dc/JnoMyH3poRaBfTo8Gse
         7H5jvigjoH7sx1giHM6pN/o2aWvXLqRCgkDnX6JP09Y79uRIK50WW5VUO2jWZyneeQ9V
         NyFSCRpYR+SAE0MUt0W2jvVog+3c9POgGHvCbUcM6fdcjmBuErAi5EFqu9imR0afjDwL
         0WnQ==
X-Gm-Message-State: AOAM533IQMbj5gNzHGXx4+7fwy+oyju5/FTs8ScY9aclLjFvrL+O9X6M
        kW8Pl3n02K/ZOR56rJ1MPPQ=
X-Google-Smtp-Source: ABdhPJzL5YjCBbrnkOB2UCcpqKtJy28zI2Io3AbzarVO6TBw75pVAsBTv/HqC8QT0vlEL6Drk+j7sw==
X-Received: by 2002:a65:4bca:: with SMTP id p10mr26097982pgr.391.1636060075178;
        Thu, 04 Nov 2021 14:07:55 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id s69sm4523688pgc.43.2021.11.04.14.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 14:07:54 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, naoya.horiguchi@nec.com,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        willy@infradead.org, osalvador@suse.de, peterx@redhat.com,
        akpm@linux-foundation.org
Cc:     shy828301@gmail.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [stable 5.10 v2 PATCH 1/2] mm: hwpoison: remove the unnecessary THP check
Date:   Thu,  4 Nov 2021 14:07:51 -0700
Message-Id: <20211104210752.390351-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.

When handling THP hwpoison checked if the THP is in allocation or free
stage since hwpoison may mistreat it as hugetlb page.  After commit
415c64c1453a ("mm/memory-failure: split thp earlier in memory error
handling") the problem has been fixed, so this check is no longer
needed.  Remove it.  The side effect of the removal is hwpoison may
report unsplit THP instead of unknown error for shmem THP.  It seems not
like a big deal.

The following patch "mm: filemap: check if THP has hwpoisoned subpage
for PMD page fault" depends on this, which fixes shmem THP with
hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
backported to -stable as well.

Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 01445ddff58d..bd2cd4dd59b6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -956,20 +956,6 @@ static int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
-	if (!PageHuge(head) && PageTransHuge(head)) {
-		/*
-		 * Non anonymous thp exists only in allocation/free time. We
-		 * can't handle such a case correctly, so let's give it up.
-		 * This should be better than triggering BUG_ON when kernel
-		 * tries to touch the "partially handled" page.
-		 */
-		if (!PageAnon(head)) {
-			pr_err("Memory failure: %#lx: non anonymous thp\n",
-				page_to_pfn(page));
-			return 0;
-		}
-	}
-
 	if (get_page_unless_zero(head)) {
 		if (head == compound_head(page))
 			return 1;
-- 
2.26.2

