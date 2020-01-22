Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892B71451F4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgAVJaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVJa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:30:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966552465B;
        Wed, 22 Jan 2020 09:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685429;
        bh=UCKobPn342Tm1h3qKa42QQhbL/sGxOKXjHDfs8QOOeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJQTyCqjE/lRe3GnAdxO/3ZwR3YESo1V4Mz7hs3eLxAS0hA/0j5iIKQqAa5Sfh8NJ
         uXJY9M8PBeFqq2dIJ679jiv1OBZVZR8f20uN6kHKjFP7fGWrOlJYOCGZb8Y5nt9F3p
         y/u4IZXaYMNzCnYdN8mcmOkZZ56iMkpp0fNmzx+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Redko <redkoi@virtuozzo.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Roman Kagan <rkagan@virtuozzo.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 11/76] mm/page_alloc.c: calculate available memory in a separate function
Date:   Wed, 22 Jan 2020 10:28:27 +0100
Message-Id: <20200122092752.743062030@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4 as dependency of commit a1078e821b60
 "xen: let alloc_xenballooned_pages() fail if not enough memory free"]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/meminfo.c  |   31 +------------------------------
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 30 deletions(-)

--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -29,10 +29,7 @@ static int meminfo_proc_show(struct seq_
 	unsigned long committed;
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
@@ -1802,6 +1802,7 @@ extern int __meminit init_per_zone_wmark
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
+extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3650,6 +3650,49 @@ static inline void show_node(struct zone
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


