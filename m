Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C7288DD0
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfHJUtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54622 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbfHJUn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDT-00053s-9x; Sat, 10 Aug 2019 21:43:55 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003kd-PO; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Roman Kagan" <rkagan@virtuozzo.com>,
        "Denis V. Lunev" <den@openvz.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Igor Redko" <redkoi@virtuozzo.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.617883725@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 143/157] mm/page_alloc.c: calculate 'available'
 memory in a separate function
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Redko <redkoi@virtuozzo.com>

commit d02bd27bd33dd7e8d22594cd568b81be0cb584cd upstream.

Add a new field, VIRTIO_BALLOON_S_AVAIL, to virtio_balloon memory
statistics protocol, corresponding to 'Available' in /proc/meminfo.

It indicates to the hypervisor how big the balloon can be inflated
without pushing the guest system to swap.  This metric would be very
useful in VM orchestration software to improve memory management of
different VMs under overcommit.

This patch (of 2):

Factor out calculation of the available memory counter into a separate
exportable function, in order to be able to use it in other parts of the
kernel.

In particular, it appears a relevant metric to report to the hypervisor
via virtio-balloon statistics interface (in a followup patch).

Signed-off-by: Igor Redko <redkoi@virtuozzo.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16 as dependency of commit a1078e821b60
 "xen: let alloc_xenballooned_pages() fail if not enough memory free"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/proc/meminfo.c  | 31 +------------------------------
 include/linux/mm.h |  1 +
 mm/page_alloc.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 30 deletions(-)

--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -27,10 +27,7 @@ static int meminfo_proc_show(struct seq_
 	struct vmalloc_info vmi;
 	long cached;
 	long available;
-	unsigned long pagecache;
-	unsigned long wmark_low = 0;
 	unsigned long pages[NR_LRU_LISTS];
-	struct zone *zone;
 	int lru;
 
 /*
@@ -51,33 +48,7 @@ static int meminfo_proc_show(struct seq_
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
 		pages[lru] = global_page_state(NR_LRU_BASE + lru);
 
-	for_each_zone(zone)
-		wmark_low += zone->watermark[WMARK_LOW];
-
-	/*
-	 * Estimate the amount of memory available for userspace allocations,
-	 * without causing swapping.
-	 */
-	available = i.freeram - totalreserve_pages;
-
-	/*
-	 * Not all the page cache can be freed, otherwise the system will
-	 * start swapping. Assume at least half of the page cache, or the
-	 * low watermark worth of cache, needs to stay.
-	 */
-	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
-	pagecache -= min(pagecache / 2, wmark_low);
-	available += pagecache;
-
-	/*
-	 * Part of the reclaimable slab consists of items that are in use,
-	 * and cannot be freed. Cap this estimate at the low watermark.
-	 */
-	available += global_page_state(NR_SLAB_RECLAIMABLE) -
-		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
-
-	if (available < 0)
-		available = 0;
+	available = si_mem_available();
 
 	/*
 	 * Tagged format, for easy grepping and expansion.
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1699,6 +1699,7 @@ extern int __meminit init_per_zone_wmark
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
+extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3072,6 +3072,49 @@ static inline void show_node(struct zone
 		printk("Node %d ", zone_to_nid(zone));
 }
 
+long si_mem_available(void)
+{
+	long available;
+	unsigned long pagecache;
+	unsigned long wmark_low = 0;
+	unsigned long pages[NR_LRU_LISTS];
+	struct zone *zone;
+	int lru;
+
+	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
+		pages[lru] = global_page_state(NR_LRU_BASE + lru);
+
+	for_each_zone(zone)
+		wmark_low += zone->watermark[WMARK_LOW];
+
+	/*
+	 * Estimate the amount of memory available for userspace allocations,
+	 * without causing swapping.
+	 */
+	available = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
+
+	/*
+	 * Not all the page cache can be freed, otherwise the system will
+	 * start swapping. Assume at least half of the page cache, or the
+	 * low watermark worth of cache, needs to stay.
+	 */
+	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
+	pagecache -= min(pagecache / 2, wmark_low);
+	available += pagecache;
+
+	/*
+	 * Part of the reclaimable slab consists of items that are in use,
+	 * and cannot be freed. Cap this estimate at the low watermark.
+	 */
+	available += global_page_state(NR_SLAB_RECLAIMABLE) -
+		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
+
+	if (available < 0)
+		available = 0;
+	return available;
+}
+EXPORT_SYMBOL_GPL(si_mem_available);
+
 void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages;

