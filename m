Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DF3200DE5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390868AbgFSPCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390859AbgFSPCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E3D21D7F;
        Fri, 19 Jun 2020 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578957;
        bh=TO7lJZkvm+n9sKseYVA036zSbTtWhhsY1sSle3h3vMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmlXkAJmykQ/WFi9g2jMLGihr2ZhqmVEDAHRlspkVkD3yk0Ncj7lvxqdyVQ60YYQq
         /8uet6E1ksBSkDTPZCB52Y5qGTllfClsEeMT2bDBZC5X6ktFQxskSFQcWWqrF00lL7
         buMX1x/EuY0LvWcZaoJpZC4U+uChwr78gJ4W+AkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        James Morris <jmorris@namei.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>, Yiqian Wei <yiwei@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 191/267] mm: initialize deferred pages with interrupts enabled
Date:   Fri, 19 Jun 2020 16:32:56 +0200
Message-Id: <20200619141657.904529608@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

commit 3d060856adfc59afb9d029c233141334cfaba418 upstream.

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

Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Reported-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Yiqian Wei <yiwei@redhat.com>
Cc: <stable@vger.kernel.org>	[4.17+]
Link: http://lkml.kernel.org/r/20200403140952.17177-3-pasha.tatashin@soleen.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mmzone.h |    2 ++
 mm/page_alloc.c        |   19 +++++++------------
 2 files changed, 9 insertions(+), 12 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -638,6 +638,8 @@ typedef struct pglist_data {
 	/*
 	 * Must be held any time you expect node_start_pfn, node_present_pages
 	 * or node_spanned_pages stay constant.
+	 * Also synchronizes pgdat->first_deferred_pfn during deferred page
+	 * init.
 	 *
 	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1586,6 +1586,13 @@ static int __init deferred_init_memmap(v
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
@@ -1610,7 +1617,6 @@ static int __init deferred_init_memmap(v
 		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
 		deferred_free_pages(nid, zid, spfn, epfn);
 	}
-	pgdat_resize_unlock(pgdat, &flags);
 
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
@@ -1657,17 +1663,6 @@ deferred_grow_zone(struct zone *zone, un
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


