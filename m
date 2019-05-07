Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212C415C9C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfEGGEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfEGFeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFED20B7C;
        Tue,  7 May 2019 05:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207263;
        bh=oXIr1mm3+pichJjL+9iVnU0mTDTTZQqC5fQkWc/FwsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZclECnsY76yV+4pSX8M9VuXUDZJlS6Pz+40P6Mf3s1hLCDJCcP/x4JsUDpy9gOYJ
         ZPGWegaNJtqV7DVTNiAXlyS5LUNdU1FcHbFv1NC/sHVYwau2rnLsvAuG1nLqbDNSHi
         Ii2/oEWAYydoU2bBnQpPhRMJriNdtg+5tgQJghi8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.0 57/99] mm/hotplug: treat CMA pages as unmovable
Date:   Tue,  7 May 2019 01:31:51 -0400
Message-Id: <20190507053235.29900-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 1a9f219157b22d0ffb340a9c5f431afd02cd2cf3 ]

has_unmovable_pages() is used by allocating CMA and gigantic pages as
well as the memory hotplug.  The later doesn't know how to offline CMA
pool properly now, but if an unused (free) CMA page is encountered, then
has_unmovable_pages() happily considers it as a free memory and
propagates this up the call chain.  Memory offlining code then frees the
page without a proper CMA tear down which leads to an accounting issues.
Moreover if the same memory range is onlined again then the memory never
gets back to the CMA pool.

State after memory offline:

 # grep cma /proc/vmstat
 nr_free_cma 205824

 # cat /sys/kernel/debug/cma/cma-kvm_cma/count
 209920

Also, kmemleak still think those memory address are reserved below but
have already been used by the buddy allocator after onlining.  This
patch fixes the situation by treating CMA pageblocks as unmovable except
when has_unmovable_pages() is called as part of CMA allocation.

  Offlined Pages 4096
  kmemleak: Cannot insert 0xc000201f7d040008 into the object search tree (overlaps existing)
  Call Trace:
    dump_stack+0xb0/0xf4 (unreliable)
    create_object+0x344/0x380
    __kmalloc_node+0x3ec/0x860
    kvmalloc_node+0x58/0x110
    seq_read+0x41c/0x620
    __vfs_read+0x3c/0x70
    vfs_read+0xbc/0x1a0
    ksys_read+0x7c/0x140
    system_call+0x5c/0x70
  kmemleak: Kernel memory leak detector disabled
  kmemleak: Object 0xc000201cc8000000 (size 13757317120):
  kmemleak:   comm "swapper/0", pid 0, jiffies 4294937297
  kmemleak:   min_count = -1
  kmemleak:   count = 0
  kmemleak:   flags = 0x5
  kmemleak:   checksum = 0
  kmemleak:   backtrace:
       cma_declare_contiguous+0x2a4/0x3b0
       kvm_cma_reserve+0x11c/0x134
       setup_arch+0x300/0x3f8
       start_kernel+0x9c/0x6e8
       start_here_common+0x1c/0x4b0
  kmemleak: Automatic memory scanning thread ended

[cai@lca.pw: use is_migrate_cma_page() and update commit log]
  Link: http://lkml.kernel.org/r/20190416170510.20048-1-cai@lca.pw
Link: http://lkml.kernel.org/r/20190413002623.8967-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 318ef6ccdb3b..eedb57f9b40b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7945,7 +7945,10 @@ void *__init alloc_large_system_hash(const char *tablename,
 bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
 			 int migratetype, int flags)
 {
-	unsigned long pfn, iter, found;
+	unsigned long found;
+	unsigned long iter = 0;
+	unsigned long pfn = page_to_pfn(page);
+	const char *reason = "unmovable page";
 
 	/*
 	 * TODO we could make this much more efficient by not checking every
@@ -7955,17 +7958,20 @@ bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
 	 * can still lead to having bootmem allocations in zone_movable.
 	 */
 
-	/*
-	 * CMA allocations (alloc_contig_range) really need to mark isolate
-	 * CMA pageblocks even when they are not movable in fact so consider
-	 * them movable here.
-	 */
-	if (is_migrate_cma(migratetype) &&
-			is_migrate_cma(get_pageblock_migratetype(page)))
-		return false;
+	if (is_migrate_cma_page(page)) {
+		/*
+		 * CMA allocations (alloc_contig_range) really need to mark
+		 * isolate CMA pageblocks even when they are not movable in fact
+		 * so consider them movable here.
+		 */
+		if (is_migrate_cma(migratetype))
+			return false;
+
+		reason = "CMA page";
+		goto unmovable;
+	}
 
-	pfn = page_to_pfn(page);
-	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
+	for (found = 0; iter < pageblock_nr_pages; iter++) {
 		unsigned long check = pfn + iter;
 
 		if (!pfn_valid_within(check))
@@ -8045,7 +8051,7 @@ bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
 unmovable:
 	WARN_ON_ONCE(zone_idx(zone) == ZONE_MOVABLE);
 	if (flags & REPORT_FAILURE)
-		dump_page(pfn_to_page(pfn+iter), "unmovable page");
+		dump_page(pfn_to_page(pfn + iter), reason);
 	return true;
 }
 
-- 
2.20.1

