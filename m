Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090062E3DE5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437914AbgL1OV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502245AbgL1OVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F5C2063A;
        Mon, 28 Dec 2020 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165219;
        bh=qtsEKy5ZXF8em1TQ1ZvSRUrYNAtf84KIJgezj7ANK8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWA5kzBcF3K6ds+KLHAAQnlkC10Vv83WQ9SObe7TpK37617alMmqBty/QshgcwTXK
         tYbGHvsvQ49XhDLKrdjk2M0j6hwSwXk1F6lYNmhR5PcAItaiwn2stupSwZSuvDuei6
         EBukBZ4Z37qhJjAQ3pQ2bYXLKGdgcsLRRxa43E08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 455/717] mm,memory_failure: always pin the page in madvise_inject_error
Date:   Mon, 28 Dec 2020 13:47:33 +0100
Message-Id: <20201228125042.767776904@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>

[ Upstream commit 1e8aaedb182d6ddffc894b832e4962629907b3e0 ]

madvise_inject_error() uses get_user_pages_fast to translate the address
we specified to a page.  After [1], we drop the extra reference count for
memory_failure() path.  That commit says that memory_failure wanted to
keep the pin in order to take the page out of circulation.

The truth is that we need to keep the page pinned, otherwise the page
might be re-used after the put_page() and we can end up messing with
someone else's memory.

E.g:

CPU0
process X					CPU1
 madvise_inject_error
  get_user_pages
   put_page
					page gets reclaimed
					process Y allocates the page
  memory_failure
   // We mess with process Y memory

madvise() is meant to operate on a self address space, so messing with
pages that do not belong to us seems the wrong thing to do.
To avoid that, let us keep the page pinned for memory_failure as well.

Pages for DAX mappings will release this extra refcount in
memory_failure_dev_pagemap.

[1] ("23e7b5c2e271: mm, madvise_inject_error:
      Let memory_failure() optionally take a page reference")

Link: https://lkml.kernel.org/r/20201207094818.8518-1-osalvador@suse.de
Fixes: 23e7b5c2e271 ("mm, madvise_inject_error: Let memory_failure() optionally take a page reference")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c        | 9 +--------
 mm/memory-failure.c | 6 ++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 13f5677b93222..9abf4c5f2bce2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -908,14 +908,7 @@ static int madvise_inject_error(int behavior,
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			/*
-			 * Drop the page reference taken by get_user_pages_fast(). In
-			 * the absence of MF_COUNT_INCREASED the memory_failure()
-			 * routine is responsible for pinning the page to prevent it
-			 * from being released back to the page allocator.
-			 */
-			put_page(page);
-			ret = memory_failure(pfn, 0);
+			ret = memory_failure(pfn, MF_COUNT_INCREASED);
 		}
 
 		if (ret)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 71295bb984af6..fd653c9953cfd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1231,6 +1231,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	loff_t start;
 	dax_entry_t cookie;
 
+	if (flags & MF_COUNT_INCREASED)
+		/*
+		 * Drop the extra refcount in case we come from madvise().
+		 */
+		put_page(page);
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
-- 
2.27.0



