Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A29427CB4F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732630AbgI2M0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbgI2Ldc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB67C23BCA;
        Tue, 29 Sep 2020 11:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378838;
        bh=sAr3PQMBNF2dtHsMOWQNAjq7gfV0vMXJ1J9wYYZLQ48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4+4V1zbck4Y0IJZoCzUbn8+UZ03OKJO69zXsK3UnKdR8dCu+l39NzEpHwQ4CmsWq
         6CVUoKF+vEUWiSTtKBFf0WjyeuU6woBTnvX7eQLolSkWDT88cBIyGCyDetpIDXG1Qb
         XEP8j8EeS49uWr+uRfc0L4FyDLbp+kqHRI7rpJoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/245] mm/vmscan.c: fix data races using kswapd_classzone_idx
Date:   Tue, 29 Sep 2020 12:59:51 +0200
Message-Id: <20200929105953.800248087@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 5644e1fbbfe15ad06785502bbfe5751223e5841d ]

pgdat->kswapd_classzone_idx could be accessed concurrently in
wakeup_kswapd().  Plain writes and reads without any lock protection
result in data races.  Fix them by adding a pair of READ|WRITE_ONCE() as
well as saving a branch (compilers might well optimize the original code
in an unintentional way anyway).  While at it, also take care of
pgdat->kswapd_order and non-kswapd threads in allow_direct_reclaim().  The
data races were reported by KCSAN,

 BUG: KCSAN: data-race in wakeup_kswapd / wakeup_kswapd

 write to 0xffff9f427ffff2dc of 4 bytes by task 7454 on cpu 13:
  wakeup_kswapd+0xf1/0x400
  wakeup_kswapd at mm/vmscan.c:3967
  wake_all_kswapds+0x59/0xc0
  wake_all_kswapds at mm/page_alloc.c:4241
  __alloc_pages_slowpath+0xdcc/0x1290
  __alloc_pages_slowpath at mm/page_alloc.c:4512
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 1 lock held by mtest01/7454:
  #0: ffff9f425afe8808 (&mm->mmap_sem#2){++++}, at:
 do_page_fault+0x143/0x6f9
 do_user_addr_fault at arch/x86/mm/fault.c:1405
 (inlined by) do_page_fault at arch/x86/mm/fault.c:1539
 irq event stamp: 6944085
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x34c/0x57c
 irq_exit+0xa2/0xc0

 read to 0xffff9f427ffff2dc of 4 bytes by task 7472 on cpu 38:
  wakeup_kswapd+0xc8/0x400
  wake_all_kswapds+0x59/0xc0
  __alloc_pages_slowpath+0xdcc/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 1 lock held by mtest01/7472:
  #0: ffff9f425a9ac148 (&mm->mmap_sem#2){++++}, at:
 do_page_fault+0x143/0x6f9
 irq event stamp: 6793561
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x34c/0x57c
 irq_exit+0xa2/0xc0

 BUG: KCSAN: data-race in kswapd / wakeup_kswapd

 write to 0xffff90973ffff2dc of 4 bytes by task 820 on cpu 6:
  kswapd+0x27c/0x8d0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffff90973ffff2dc of 4 bytes by task 6299 on cpu 0:
  wakeup_kswapd+0xf3/0x450
  wake_all_kswapds+0x59/0xc0
  __alloc_pages_slowpath+0xdcc/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Link: http://lkml.kernel.org/r/1582749472-5171-1-git-send-email-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b93dc8fc6007f..b7d7f6d65bd5b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3109,8 +3109,9 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
 
 	/* kswapd must be awake if processes are being throttled */
 	if (!wmark_ok && waitqueue_active(&pgdat->kswapd_wait)) {
-		pgdat->kswapd_classzone_idx = min(pgdat->kswapd_classzone_idx,
-						(enum zone_type)ZONE_NORMAL);
+		if (READ_ONCE(pgdat->kswapd_classzone_idx) > ZONE_NORMAL)
+			WRITE_ONCE(pgdat->kswapd_classzone_idx, ZONE_NORMAL);
+
 		wake_up_interruptible(&pgdat->kswapd_wait);
 	}
 
@@ -3626,9 +3627,9 @@ out:
 static enum zone_type kswapd_classzone_idx(pg_data_t *pgdat,
 					   enum zone_type prev_classzone_idx)
 {
-	if (pgdat->kswapd_classzone_idx == MAX_NR_ZONES)
-		return prev_classzone_idx;
-	return pgdat->kswapd_classzone_idx;
+	enum zone_type curr_idx = READ_ONCE(pgdat->kswapd_classzone_idx);
+
+	return curr_idx == MAX_NR_ZONES ? prev_classzone_idx : curr_idx;
 }
 
 static void kswapd_try_to_sleep(pg_data_t *pgdat, int alloc_order, int reclaim_order,
@@ -3672,8 +3673,11 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int alloc_order, int reclaim_o
 		 * the previous request that slept prematurely.
 		 */
 		if (remaining) {
-			pgdat->kswapd_classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
-			pgdat->kswapd_order = max(pgdat->kswapd_order, reclaim_order);
+			WRITE_ONCE(pgdat->kswapd_classzone_idx,
+				   kswapd_classzone_idx(pgdat, classzone_idx));
+
+			if (READ_ONCE(pgdat->kswapd_order) < reclaim_order)
+				WRITE_ONCE(pgdat->kswapd_order, reclaim_order);
 		}
 
 		finish_wait(&pgdat->kswapd_wait, &wait);
@@ -3755,12 +3759,12 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
-	pgdat->kswapd_order = 0;
-	pgdat->kswapd_classzone_idx = MAX_NR_ZONES;
+	WRITE_ONCE(pgdat->kswapd_order, 0);
+	WRITE_ONCE(pgdat->kswapd_classzone_idx, MAX_NR_ZONES);
 	for ( ; ; ) {
 		bool ret;
 
-		alloc_order = reclaim_order = pgdat->kswapd_order;
+		alloc_order = reclaim_order = READ_ONCE(pgdat->kswapd_order);
 		classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
 
 kswapd_try_sleep:
@@ -3768,10 +3772,10 @@ kswapd_try_sleep:
 					classzone_idx);
 
 		/* Read the new order and classzone_idx */
-		alloc_order = reclaim_order = pgdat->kswapd_order;
+		alloc_order = reclaim_order = READ_ONCE(pgdat->kswapd_order);
 		classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
-		pgdat->kswapd_order = 0;
-		pgdat->kswapd_classzone_idx = MAX_NR_ZONES;
+		WRITE_ONCE(pgdat->kswapd_order, 0);
+		WRITE_ONCE(pgdat->kswapd_classzone_idx, MAX_NR_ZONES);
 
 		ret = try_to_freeze();
 		if (kthread_should_stop())
@@ -3816,20 +3820,23 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 		   enum zone_type classzone_idx)
 {
 	pg_data_t *pgdat;
+	enum zone_type curr_idx;
 
 	if (!managed_zone(zone))
 		return;
 
 	if (!cpuset_zone_allowed(zone, gfp_flags))
 		return;
+
 	pgdat = zone->zone_pgdat;
+	curr_idx = READ_ONCE(pgdat->kswapd_classzone_idx);
+
+	if (curr_idx == MAX_NR_ZONES || curr_idx < classzone_idx)
+		WRITE_ONCE(pgdat->kswapd_classzone_idx, classzone_idx);
+
+	if (READ_ONCE(pgdat->kswapd_order) < order)
+		WRITE_ONCE(pgdat->kswapd_order, order);
 
-	if (pgdat->kswapd_classzone_idx == MAX_NR_ZONES)
-		pgdat->kswapd_classzone_idx = classzone_idx;
-	else
-		pgdat->kswapd_classzone_idx = max(pgdat->kswapd_classzone_idx,
-						  classzone_idx);
-	pgdat->kswapd_order = max(pgdat->kswapd_order, order);
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
 
-- 
2.25.1



