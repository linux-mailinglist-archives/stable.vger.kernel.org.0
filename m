Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36929FD2F
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 06:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgJ3FZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 01:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgJ3FZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 01:25:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 608D520729;
        Fri, 30 Oct 2020 05:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604035551;
        bh=gAT79GLZVxUw2rKYQQvqZZKjWLlDPBUmBVKjKngl/pM=;
        h=Date:From:To:Subject:From;
        b=quGK8piOH9e8nJOb+jsjOI78tV5WaHQHGgdHq3WAjI6xkjRmXc8/x26w9rQtSAD7H
         O9Kdi8d/eljAEwPJvy2UYhaefS+ejP++2fbkQb/2gMLAw02n/+tDzfhJ5iz2czkJoW
         QrNBzkSlFnk6Wl2uL+swBwYcuzT5zCYos3P32VFw=
Date:   Thu, 29 Oct 2020 22:25:49 -0700
From:   akpm@linux-foundation.org
To:     a.sahrawat@samsung.com, maninder1.s@samsung.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        stable@vger.kernel.org, v.narang@samsung.com, vbabka@suse.cz
Subject:  +
 mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch added to -mm tree
Message-ID: <20201030052549.gngsbJV4H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit

Previously the negated unsigned long would be cast back to signed long
which would have the correct negative value.  After commit 730ec8c01a2b
("mm/vmscan.c: change prototype for shrink_page_list"), the large unsigned
int converts to a large positive signed long.

Symptoms include CMA allocations hanging forever holding the cma_mutex due
to alloc_contig_range->...->isolate_migratepages_block waiting forever in
"while (unlikely(too_many_isolated(pgdat)))".

Link: https://lkml.kernel.org/r/20201029032320.1448441-1-npiggin@gmail.com
Fixes: 730ec8c01a2b ("mm/vmscan.c: change prototype for shrink_page_list")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Vaneet Narang <v.narang@samsung.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit
+++ a/mm/vmscan.c
@@ -1516,7 +1516,7 @@ unsigned int reclaim_clean_pages_from_li
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
 			TTU_IGNORE_ACCESS, &stat, true);
 	list_splice(&clean_pages, page_list);
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -nr_reclaimed);
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -(long)nr_reclaimed);
 	/*
 	 * Since lazyfree pages are isolated from file LRU from the beginning,
 	 * they will rotate back to anonymous LRU in the end if it failed to
_

Patches currently in -mm which might be from npiggin@gmail.com are

mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch

