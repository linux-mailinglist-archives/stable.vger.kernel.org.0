Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B843B6AD2
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 00:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhF1WIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 18:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhF1WIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 18:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7BB461CD7;
        Mon, 28 Jun 2021 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624917983;
        bh=2DquL9NnSEPjyDvtIV/fL/A0XUE0qsT9ZHx91TwHmE8=;
        h=Date:From:To:Subject:From;
        b=V2Fw9ATGor7g8fCHtFM1p7n8moElUqVA9tjNCGhsAArFsDt8v+R2sJzYVEWQhhIP5
         28DYoOADZ8U56Uy8J31c2oJVOLLoNNRjKpb0wl+Htlj6dGz4U2wqn3MRey9NwIWDZ2
         B2ibsbfalsuN/Bx9pvCxHyXjcDpKBk19cKI41nLE=
Date:   Mon, 28 Jun 2021 15:06:22 -0700
From:   akpm@linux-foundation.org
To:     brouer@redhat.com, dan.carpenter@oracle.com,
        davej@codemonkey.org.uk, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-correct-return-value-of-populated-elements-?=
 =?US-ASCII?Q?if-bulk-array-is-populated.patch?= added to -mm tree
Message-ID: <20210628220622.QS9jDZAcU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: correct return value of populated elements if bulk array is populated
has been added to the -mm tree.  Its filename is
     mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: correct return value of populated elements if bulk array is populated

Dave Jones reported the following

	This made it into 5.13 final, and completely breaks NFSD for me
	(Serving tcp v3 mounts).  Existing mounts on clients hang, as do
	new mounts from new clients.  Rebooting the server back to rc7
	everything recovers.

The commit b3b64ebd3822 ("mm/page_alloc: do bulk array bounds check after
checking populated elements") returns the wrong value if the array is
already populated which is interpreted as an allocation failure.  Dave
reported this fixes his problem and it also passed a test running dbench
over NFS.

Link: https://lkml.kernel.org/r/20210628150219.GC3840@techsingularity.net
Fixes: b3b64ebd3822 ("mm/page_alloc: do bulk array bounds check after checking populated elements")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Tested-by: Dave Jones <davej@codemonkey.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org> [5.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated
+++ a/mm/page_alloc.c
@@ -5058,7 +5058,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 
 	/* Already populated array? */
 	if (unlikely(page_array && nr_pages - nr_populated == 0))
-		return 0;
+		return nr_populated;
 
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch
mm-page_alloc-move-free_the_page.patch
mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch
mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

