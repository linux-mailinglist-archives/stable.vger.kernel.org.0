Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5A28B6EC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbgJLNi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbgJLNiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EE232074F;
        Mon, 12 Oct 2020 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509928;
        bh=mDCsPGLmCKZfKONAXRGl6sNY1heGZtD936mD0ykrios=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7UJ6GMTfEpGtELfblPEqyIysa7GHZELCf1hyPbc+5lgpQSFxmzwR/lzZ2iyFtS1b
         OmSP/n3Zx3AAf6Lme2+ivmZYCArtZeCUe6kbJBcN8vmTKrM7keDDqXukFuBHOIlPLA
         gpV5ZQ3BPQOJamU5vWjLzh41rF3/5a5Vk0yfKbAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Lisov <dennis.lissov@gmail.com>,
        Qian Cai <cai@lca.pw>, Hugh Dickins <hughd@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 4.19 19/49] mm/khugepaged: fix filemap page_to_pgoff(page) != offset
Date:   Mon, 12 Oct 2020 15:27:05 +0200
Message-Id: <20201012132630.341352860@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 033b5d77551167f8c24ca862ce83d3e0745f9245 upstream.

There have been elusive reports of filemap_fault() hitting its
VM_BUG_ON_PAGE(page_to_pgoff(page) != offset, page) on kernels built
with CONFIG_READ_ONLY_THP_FOR_FS=y.

Suren has hit it on a kernel with CONFIG_READ_ONLY_THP_FOR_FS=y and
CONFIG_NUMA is not set: and he has analyzed it down to how khugepaged
without NUMA reuses the same huge page after collapse_file() failed
(whereas NUMA targets its allocation to the respective node each time).
And most of us were usually testing with CONFIG_NUMA=y kernels.

collapse_file(old start)
  new_page = khugepaged_alloc_page(hpage)
  __SetPageLocked(new_page)
  new_page->index = start // hpage->index=old offset
  new_page->mapping = mapping
  xas_store(&xas, new_page)

                          filemap_fault
                            page = find_get_page(mapping, offset)
                            // if offset falls inside hpage then
                            // compound_head(page) == hpage
                            lock_page_maybe_drop_mmap()
                              __lock_page(page)

  // collapse fails
  xas_store(&xas, old page)
  new_page->mapping = NULL
  unlock_page(new_page)

collapse_file(new start)
  new_page = khugepaged_alloc_page(hpage)
  __SetPageLocked(new_page)
  new_page->index = start // hpage->index=new offset
  new_page->mapping = mapping // mapping becomes valid again

                            // since compound_head(page) == hpage
                            // page_to_pgoff(page) got changed
                            VM_BUG_ON_PAGE(page_to_pgoff(page) != offset)

An initial patch replaced __SetPageLocked() by lock_page(), which did
fix the race which Suren illustrates above.  But testing showed that it's
not good enough: if the racing task's __lock_page() gets delayed long
after its find_get_page(), then it may follow collapse_file(new start)'s
successful final unlock_page(), and crash on the same VM_BUG_ON_PAGE.

It could be fixed by relaxing filemap_fault()'s VM_BUG_ON_PAGE to a
check and retry (as is done for mapping), with similar relaxations in
find_lock_entry() and pagecache_get_page(): but it's not obvious what
else might get caught out; and khugepaged non-NUMA appears to be unique
in exposing a page to page cache, then revoking, without going through
a full cycle of freeing before reuse.

Instead, non-NUMA khugepaged_prealloc_page() release the old page
if anyone else has a reference to it (1% of cases when I tested).

Although never reported on huge tmpfs, I believe its find_lock_entry()
has been at similar risk; but huge tmpfs does not rely on khugepaged
for its normal working nearly so much as READ_ONLY_THP_FOR_FS does.

Reported-by: Denis Lisov <dennis.lissov@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206569
Link: https://lore.kernel.org/linux-mm/?q=20200219144635.3b7417145de19b65f258c943%40linux-foundation.org
Reported-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/linux-xfs/?q=20200616013309.GB815%40lca.pw
Reported-and-analyzed-by: Suren Baghdasaryan <surenb@google.com>
Fixes: 87c460a0bded ("mm/khugepaged: collapse_shmem() without freezing new_page")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # v4.9+
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -820,6 +820,18 @@ static struct page *khugepaged_alloc_hug
 
 static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
 {
+	/*
+	 * If the hpage allocated earlier was briefly exposed in page cache
+	 * before collapse_file() failed, it is possible that racing lookups
+	 * have not yet completed, and would then be unpleasantly surprised by
+	 * finding the hpage reused for the same mapping at a different offset.
+	 * Just release the previous allocation if there is any danger of that.
+	 */
+	if (*hpage && page_count(*hpage) > 1) {
+		put_page(*hpage);
+		*hpage = NULL;
+	}
+
 	if (!*hpage)
 		*hpage = khugepaged_alloc_hugepage(wait);
 


