Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EFA2B6415
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbgKQNof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732850AbgKQNkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EBE2467A;
        Tue, 17 Nov 2020 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620419;
        bh=yJzKDwnp94Q/L/qdDqO8mmVFGg1PNfnZcPHUCBIo92g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwwOusEmiODXIGjc5SVAy6KpV5lX9f5SO0DY5U7rWJDN7I9LTFFXlnN7qlxdCzj5+
         EnXBwemPgZ736fXxHIWJ9bDd/xwTI+ZNBhXeEtyC2+CkY7L51UtCPKbYO27T5JpEcG
         p3lqbKC+i8u8+4bYCGIU8nnh2SGgfPvDBqRg1RnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Vaneet Narang <v.narang@samsung.com>,
        Maninder Singh <maninder1.s@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 212/255] mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
Date:   Tue, 17 Nov 2020 14:05:52 +0100
Message-Id: <20201117122149.253216909@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 2da9f6305f306ffbbb44790675799328fb73119d upstream.

Previously the negated unsigned long would be cast back to signed long
which would have the correct negative value.  After commit 730ec8c01a2b
("mm/vmscan.c: change prototype for shrink_page_list"), the large
unsigned int converts to a large positive signed long.

Symptoms include CMA allocations hanging forever holding the cma_mutex
due to alloc_contig_range->...->isolate_migratepages_block waiting
forever in "while (unlikely(too_many_isolated(pgdat)))".

[akpm@linux-foundation.org: fix -stat.nr_lazyfree_fail as well, per Michal]

Fixes: 730ec8c01a2b ("mm/vmscan.c: change prototype for shrink_page_list")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vaneet Narang <v.narang@samsung.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201029032320.1448441-1-npiggin@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1514,7 +1514,8 @@ unsigned int reclaim_clean_pages_from_li
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
 			TTU_IGNORE_ACCESS, &stat, true);
 	list_splice(&clean_pages, page_list);
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -nr_reclaimed);
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
+			    -(long)nr_reclaimed);
 	/*
 	 * Since lazyfree pages are isolated from file LRU from the beginning,
 	 * they will rotate back to anonymous LRU in the end if it failed to
@@ -1524,7 +1525,7 @@ unsigned int reclaim_clean_pages_from_li
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_ANON,
 			    stat.nr_lazyfree_fail);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
-			    -stat.nr_lazyfree_fail);
+			    -(long)stat.nr_lazyfree_fail);
 	return nr_reclaimed;
 }
 


