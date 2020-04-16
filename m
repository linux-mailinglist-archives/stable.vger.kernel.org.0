Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40141AB618
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbgDPDL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPDL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:11:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2B92076A;
        Thu, 16 Apr 2020 03:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587006715;
        bh=ZkmUKM72h3ShsS1CNbxz9ZFI1gfD5ovrEr4ztSJ0J0A=;
        h=Date:From:To:Subject:From;
        b=RPuXA7YBVXf7eMFSYRvHphrlXPmrO8UvlZ1tmh2w1lu3maYYTW7OuRTPwSQAfRXAX
         T+nI0pVRl3BJpFjfBvnBQ3KHPcqcIPJCopN9KfWd5EeeRLjJlFruOV458VG9ESqd4t
         6q94MHnd7GOo45VjvJmdID/qHMjWu/3GcBRyUd4Q=
Date:   Wed, 15 Apr 2020 20:11:54 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, daniel.m.jordan@oracle.com,
        david@redhat.com, jmorris@namei.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, sashal@kernel.org,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        vbabka@suse.cz, yiwei@redhat.com
Subject:  +
 mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
 added to -mm tree
Message-ID: <20200416031154.Itbk-Om-C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init
has been added to the -mm tree.  Its filename is
     mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init

Patch series "initialize deferred pages with interrupts enabled", v4.

Keep interrupts enabled during deferred page initialization in order to
make code more modular and allow jiffies to update.

Original approach, and discussion can be found here:
 http://lkml.kernel.org/r/20200311123848.118638-1-shile.zhang@linux.alibaba.com


This patch (of 3):

deferred_init_memmap() disables interrupts the entire time, so it calls
touch_nmi_watchdog() periodically to avoid soft lockup splats.  Soon it
will run with interrupts enabled, at which point cond_resched() should be
used instead.

deferred_grow_zone() makes the same watchdog calls through code shared
with deferred init but will continue to run with interrupts disabled, so
it can't call cond_resched().

Pull the watchdog calls up to these two places to allow the first to be
changed later, independently of the second.  The frequency reduces from
twice per pageblock (init and free) to once per max order block.

Link: http://lkml.kernel.org/r/20200403140952.17177-2-pasha.tatashin@soleen.com
Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: James Morris <jmorris@namei.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Yiqian Wei <yiwei@redhat.com>
Cc: <stable@vger.kernel.org>	[4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init
+++ a/mm/page_alloc.c
@@ -1692,7 +1692,6 @@ static void __init deferred_free_pages(u
 		} else if (!(pfn & nr_pgmask)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 1;
-			touch_nmi_watchdog();
 		} else {
 			nr_free++;
 		}
@@ -1722,7 +1721,6 @@ static unsigned long  __init deferred_in
 			continue;
 		} else if (!page || !(pfn & nr_pgmask)) {
 			page = pfn_to_page(pfn);
-			touch_nmi_watchdog();
 		} else {
 			page++;
 		}
@@ -1862,8 +1860,10 @@ static int __init deferred_init_memmap(v
 	 * that we can avoid introducing any issues with the buddy
 	 * allocator.
 	 */
-	while (spfn < epfn)
+	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
+	}
 zone_empty:
 	pgdat_resize_unlock(pgdat, &flags);
 
@@ -1947,6 +1947,7 @@ deferred_grow_zone(struct zone *zone, un
 		first_deferred_pfn = spfn;
 
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
 
 		/* We should only stop along section boundaries */
 		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch

