Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A01AB619
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389841AbgDPDMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389423AbgDPDL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:11:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31AEA2076D;
        Thu, 16 Apr 2020 03:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587006718;
        bh=BvKioa8lwuWuOYcz+6rQc6W/ASszKvifKTVQtQsB6AU=;
        h=Date:From:To:Subject:From;
        b=hShtKi37u8xaCe5LDWuf2VgWcNxne7mOYATO/3oFZ3oBqUZV+sOiRgF0/tLYCqHGE
         CFspdIMq2i9qvS+Eu73G+E/JrdXHcXAvluaYm7hAF9t1+zYqqseUUzXPijnkLZ+HmA
         p+bXc2sEKcXaqU3zftDlPuKAW6PFF6/J+g1zDjBE=
Date:   Wed, 15 Apr 2020 20:11:57 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, daniel.m.jordan@oracle.com,
        david@redhat.com, jmorris@namei.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, sashal@kernel.org,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        vbabka@suse.cz, yiwei@redhat.com
Subject:  +
 mm-initialize-deferred-pages-with-interrupts-enabled.patch added to -mm
 tree
Message-ID: <20200416031157.f_goQGn35%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: initialize deferred pages with interrupts enabled
has been added to the -mm tree.  Its filename is
     mm-initialize-deferred-pages-with-interrupts-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-deferred-pages-with-interrupts-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-deferred-pages-with-interrupts-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm: initialize deferred pages with interrupts enabled

Initializing struct pages is a long task and keeping interrupts disabled
for the duration of this operation introduces a number of problems.

1. jiffies are not updated for long period of time, and thus incorrect time
   is reported. See proposed solution and discussion here:
   lkml/20200311123848.118638-1-shile.zhang@linux.alibaba.com
2. It prevents farther improving deferred page initialization by allowing
   intra-node multi-threading.

We are keeping interrupts disabled to solve a rather theoretical problem
that was never observed in real world (See 3a2d7fa8a3d5).

Let's keep interrupts enabled. In case we ever encounter a scenario where
an interrupt thread wants to allocate large amount of memory this early in
boot we can deal with that by growing zone (see deferred_grow_zone()) by
the needed amount before starting deferred_init_memmap() threads.

Before:
[    1.232459] node 0 initialised, 12058412 pages in 1ms

After:
[    1.632580] node 0 initialised, 12051227 pages in 436ms

Link: http://lkml.kernel.org/r/20200403140952.17177-3-pasha.tatashin@soleen.com
Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Reported-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Yiqian Wei <yiwei@redhat.com>
Cc: <stable@vger.kernel.org>	[4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/page_alloc.c        |   20 +++++++-------------
 2 files changed, 9 insertions(+), 13 deletions(-)

--- a/include/linux/mmzone.h~mm-initialize-deferred-pages-with-interrupts-enabled
+++ a/include/linux/mmzone.h
@@ -678,6 +678,8 @@ typedef struct pglist_data {
 	/*
 	 * Must be held any time you expect node_start_pfn,
 	 * node_present_pages, node_spanned_pages or nr_zones to stay constant.
+	 * Also synchronizes pgdat->first_deferred_pfn during deferred page
+	 * init.
 	 *
 	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
--- a/mm/page_alloc.c~mm-initialize-deferred-pages-with-interrupts-enabled
+++ a/mm/page_alloc.c
@@ -1843,6 +1843,13 @@ static int __init deferred_init_memmap(v
 	BUG_ON(pgdat->first_deferred_pfn > pgdat_end_pfn(pgdat));
 	pgdat->first_deferred_pfn = ULONG_MAX;
 
+	/*
+	 * Once we unlock here, the zone cannot be grown anymore, thus if an
+	 * interrupt thread must allocate this early in boot, zone must be
+	 * pre-grown prior to start of deferred page initialization.
+	 */
+	pgdat_resize_unlock(pgdat, &flags);
+
 	/* Only the highest zone is deferred so find it */
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 		zone = pgdat->node_zones + zid;
@@ -1865,8 +1872,6 @@ static int __init deferred_init_memmap(v
 		touch_nmi_watchdog();
 	}
 zone_empty:
-	pgdat_resize_unlock(pgdat, &flags);
-
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
@@ -1909,17 +1914,6 @@ deferred_grow_zone(struct zone *zone, un
 	pgdat_resize_lock(pgdat, &flags);
 
 	/*
-	 * If deferred pages have been initialized while we were waiting for
-	 * the lock, return true, as the zone was grown.  The caller will retry
-	 * this zone.  We won't return to this function since the caller also
-	 * has this static branch.
-	 */
-	if (!static_branch_unlikely(&deferred_pages)) {
-		pgdat_resize_unlock(pgdat, &flags);
-		return true;
-	}
-
-	/*
 	 * If someone grew this zone while we were waiting for spinlock, return
 	 * true, as there might be enough pages already.
 	 */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-initialize-deferred-pages-with-interrupts-enabled.patch
mm-call-cond_resched-from-deferred_init_memmap.patch

