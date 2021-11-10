Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8AB44C7EF
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhKJS5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhKJSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34562619E0;
        Wed, 10 Nov 2021 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570117;
        bh=ujny/hXFp3AvZh0QyayQ+Hh5MkuhK45jjzRAg3IQCKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PA3KzbzdLFl+69MY+b2oqPe51QtDmDQKJynQYxPzZuRlfgTJOPb6vCVtvkY25gFeH
         uNNQgbS02/zncmkeyfrmImLaLnnpVoRBBz/i2/+iJm6SnfjWujSsRYtM3+h5gYnfz+
         bHsBhjsK1AV7cPmxRLBKQM5tLM02UpauOOENZabI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 04/21] mm: hwpoison: remove the unnecessary THP check
Date:   Wed, 10 Nov 2021 19:43:50 +0100
Message-Id: <20211110182003.102822046@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -956,20 +956,6 @@ static int get_hwpoison_page(struct page
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


