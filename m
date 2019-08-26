Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A059D85C
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbfHZVbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfHZVbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C9E21881;
        Mon, 26 Aug 2019 21:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855108;
        bh=xxL/m9v2UQjKjH8kZ5djkMH5Q330C0Vl+wTGhhit/j0=;
        h=Date:From:To:Subject:From;
        b=FevK+hPxnT3T1ywQFuy5wuwEBBCHiON1X2iQi+gW5BLy63/9WrjafGerYVJUGZkQ1
         RLFnKxi7uQln6a1uxEfAwILOI7X6yr5fk+9xEVn/DYUmzzo7N2xaYWQbNpY97iCF+C
         qB1Hi7nEM9EuKTXjFsu2NXUq4278WFSPCw0bPJjM=
Date:   Mon, 26 Aug 2019 14:31:48 -0700
From:   akpm@linux-foundation.org
To:     kirill@shutemov.name, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged] mm-page_owner-handle-thp-splits-correctly.patch
 removed from -mm tree
Message-ID: <20190826213148.2ORv7s9mN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_owner: handle THP splits correctly
has been removed from the -mm tree.  Its filename was
     mm-page_owner-handle-thp-splits-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: handle THP splits correctly

THP splitting path is missing the split_page_owner() call that
split_page() has.  As a result, split THP pages are wrongly reported in
the page_owner file as order-9 pages.  Furthermore when the former head
page is freed, the remaining former tail pages are not listed in the
page_owner file at all.  This patch fixes that by adding the
split_page_owner() call into __split_huge_page().

Link: http://lkml.kernel.org/r/20190820131828.22684-2-vbabka@suse.cz
Fixes: a9627bc5e34e ("mm/page_owner: introduce split_page_owner and replace manual handling")
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-page_owner-handle-thp-splits-correctly
+++ a/mm/huge_memory.c
@@ -32,6 +32,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/page_owner.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2516,6 +2517,9 @@ static void __split_huge_page(struct pag
 	}
 
 	ClearPageCompound(head);
+
+	split_page_owner(head, HPAGE_PMD_ORDER);
+
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
 		/* Additional pin to swap cache */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-record-page-owner-for-each-subpage.patch
mm-page_owner-keep-owner-info-when-freeing-the-page.patch
mm-page_owner-debug_pagealloc-save-and-dump-freeing-stack-trace.patch
mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone-fix-2.patch
mm-reclaim-cleanup-should_continue_reclaim.patch
mm-compaction-raise-compaction-priority-after-it-withdrawns.patch

