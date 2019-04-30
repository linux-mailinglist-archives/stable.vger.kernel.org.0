Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AD9F681
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfD3Lsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbfD3Lse (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5748217D4;
        Tue, 30 Apr 2019 11:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624913;
        bh=65pmRMBbYo3ufkKxy7b3RcIhY3PhDiYvr8C95TKgmdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c01D11wBct3nYWbP7oY1ZjQUtcCf9BbCkVzgBKe38njCC6gW3c4Kkvo2WiqzPK3Kb
         ELHoCfkKTj7sx5wD50hVjgLAToA01SgTbVSQzvx/UcRk3w64FkWBqtX9mfWhoo/vH/
         LNmpvse/f+fvOJd4PG4YdUCJ95x06QHMBJBZ3d2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.0 20/89] mm: do not boost watermarks to avoid fragmentation for the DISCONTIG memory model
Date:   Tue, 30 Apr 2019 13:38:11 +0200
Message-Id: <20190430113611.028764341@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 24512228b7a3f412b5a51f189df302616b021c33 upstream.

Mikulas Patocka reported that commit 1c30844d2dfe ("mm: reclaim small
amounts of memory when an external fragmentation event occurs") "broke"
memory management on parisc.

The machine is not NUMA but the DISCONTIG model creates three pgdats
even though it's a UMA machine for the following ranges

        0) Start 0x0000000000000000 End 0x000000003fffffff Size   1024 MB
        1) Start 0x0000000100000000 End 0x00000001bfdfffff Size   3070 MB
        2) Start 0x0000004040000000 End 0x00000040ffffffff Size   3072 MB

Mikulas reported:

	With the patch 1c30844d2, the kernel will incorrectly reclaim the
	first zone when it fills up, ignoring the fact that there are two
	completely free zones. Basiscally, it limits cache size to 1GiB.

	For example, if I run:
	# dd if=/dev/sda of=/dev/null bs=1M count=2048

	- with the proper kernel, there should be "Buffers - 2GiB"
	when this command finishes. With the patch 1c30844d2, buffers
	will consume just 1GiB or slightly more, because the kernel was
	incorrectly reclaiming them.

The page allocator and reclaim makes assumptions that pgdats really
represent NUMA nodes and zones represent ranges and makes decisions on
that basis.  Watermark boosting for small pgdats leads to unexpected
results even though this would have behaved reasonably on SPARSEMEM.

DISCONTIG is essentially deprecated and even parisc plans to move to
SPARSEMEM so there is no need to be fancy, this patch simply disables
watermark boosting by default on DISCONTIGMEM.

Link: http://lkml.kernel.org/r/20190419094335.GJ18914@techsingularity.net
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sysctl/vm.txt |   16 ++++++++--------
 mm/page_alloc.c             |   13 +++++++++++++
 2 files changed, 21 insertions(+), 8 deletions(-)

--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -866,14 +866,14 @@ The intent is that compaction has less w
 increase the success rate of future high-order allocations such as SLUB
 allocations, THP and hugetlbfs pages.
 
-To make it sensible with respect to the watermark_scale_factor parameter,
-the unit is in fractions of 10,000. The default value of 15,000 means
-that up to 150% of the high watermark will be reclaimed in the event of
-a pageblock being mixed due to fragmentation. The level of reclaim is
-determined by the number of fragmentation events that occurred in the
-recent past. If this value is smaller than a pageblock then a pageblocks
-worth of pages will be reclaimed (e.g.  2MB on 64-bit x86). A boost factor
-of 0 will disable the feature.
+To make it sensible with respect to the watermark_scale_factor
+parameter, the unit is in fractions of 10,000. The default value of
+15,000 on !DISCONTIGMEM configurations means that up to 150% of the high
+watermark will be reclaimed in the event of a pageblock being mixed due
+to fragmentation. The level of reclaim is determined by the number of
+fragmentation events that occurred in the recent past. If this value is
+smaller than a pageblock then a pageblocks worth of pages will be reclaimed
+(e.g.  2MB on 64-bit x86). A boost factor of 0 will disable the feature.
 
 =============================================================
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -266,7 +266,20 @@ compound_page_dtor * const compound_page
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
+#ifdef CONFIG_DISCONTIGMEM
+/*
+ * DiscontigMem defines memory ranges as separate pg_data_t even if the ranges
+ * are not on separate NUMA nodes. Functionally this works but with
+ * watermark_boost_factor, it can reclaim prematurely as the ranges can be
+ * quite small. By default, do not boost watermarks on discontigmem as in
+ * many cases very high-order allocations like THP are likely to be
+ * unsupported and the premature reclaim offsets the advantage of long-term
+ * fragmentation avoidance.
+ */
+int watermark_boost_factor __read_mostly;
+#else
 int watermark_boost_factor __read_mostly = 15000;
+#endif
 int watermark_scale_factor = 10;
 
 static unsigned long nr_kernel_pages __initdata;


