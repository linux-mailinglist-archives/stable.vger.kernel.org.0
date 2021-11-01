Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D467C44210F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 20:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhKATvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhKATvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 15:51:33 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2758FC061714;
        Mon,  1 Nov 2021 12:49:00 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u17so3195000plg.9;
        Mon, 01 Nov 2021 12:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PKFRq9HbcghGVdCADEk0F25dG6nzRjSV9nvm54bAxok=;
        b=GF5pX1FCoKVkDqtx4hZJbmPDkjQY3uA4vRV4wZhR4A6cU0yXIg1odvM7maJzRpKrv2
         TrNV860oSWX0FeUk1CovvzLwfQmdlGwxFWQCjfV7ybHg++6QwLOL2AKPqEMVVvg7qeP3
         XAPIhvNtu8P2vTRcLiE4g1atGyh8+PPJZJFnk1scAkTpzRCe3yO0xWOZjN1U6oX1dvVu
         AlSwJFYmTzYge+/O/iea6ovFR37dpDoVbsb1s7MtFrze9iWvBQ9EyMO7wpWt0Grm6vjx
         Wv5vMpsIMZU3/qFsWLvNHBlCzO6AmW4OyJ9+ESjAMftwlMMqH1JpQqXTf/+G/eIuMbYv
         VmiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PKFRq9HbcghGVdCADEk0F25dG6nzRjSV9nvm54bAxok=;
        b=f1PhLN1qKCqubBgFWzQf1VcN/sWS3abb3HBigDjtyyCbQqJOcvfJPvzBKZHByMGRsv
         O+YKKoNbaV+MUepDwEHKmd5yeCr5CduXk89v0B9t9t5dHmIIbD2BD2ZoSgZocgvuzcXj
         avOWRb7UAXBPkJVt8nZ/uhCSpuLDd7JOf0h0/8XtkVcd2faWHSE7l9HT2dAKd2LbloE3
         1CuIjIDTcOHNa39zK0RKPriNuOXKqyu431eWANxxItQjGxWmMqfYa86JMvOZV28zHMBg
         0YOKIkSaNhVP865Ht60+Ss60fIZqnnI3/pXBbmlztaAgbqnPRmHbLtMGjsOh/8AS7Jgz
         teHg==
X-Gm-Message-State: AOAM533KOZpPJhofSdEUHfMHlETB3CegKyGzUEAB282tE9+ElRc8gkmd
        iB9FAkyl/sTdRXK4QwYyUXE=
X-Google-Smtp-Source: ABdhPJw8SGBgSebBiMYcJiqbo8z+BLaUb9mWPrtdsu+eRZvzQE3oxzKuH7Z2VrtVHfW8pdNma16kLA==
X-Received: by 2002:a17:902:aa03:b0:13f:a07e:da04 with SMTP id be3-20020a170902aa0300b0013fa07eda04mr26731470plb.80.1635796139672;
        Mon, 01 Nov 2021 12:48:59 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id j6sm13496754pgq.0.2021.11.01.12.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 12:48:58 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, naoya.horiguchi@nec.com,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        willy@infradead.org, osalvador@suse.de, peterx@redhat.com,
        akpm@linux-foundation.org
Cc:     shy828301@gmail.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [stable 5.10 PATCH] mm: hwpoison: remove the unnecessary THP check
Date:   Mon,  1 Nov 2021 12:48:56 -0700
Message-Id: <20211101194856.305642-1-shy828301@gmail.com>
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
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
depends on this one.

 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5d880d4eb9a2..bf601283fcf3 100644
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

