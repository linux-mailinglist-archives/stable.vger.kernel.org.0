Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF14827C6F1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgI2LuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbgI2Ltp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B784F2074A;
        Tue, 29 Sep 2020 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380184;
        bh=i0QG7aoL1XIU3Ur52eFi/co9Xg6Mr1n7g+3XEwCAy4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0G2sNv+J0RAnc/3JBp5DJNt1f0SGXgT3zjHEz8sE+A965sasbHzQ1a6ia9koGG6Z
         WsYNe1n11U2PKRbvQPuYD8YMiqOm0eAyDm+AQsqfRH1RJwuY51Njj/Dy2BKP5aJcSB
         idvhcqzVUp195sBrKF1uIYchESJTAZOrz3EJkaTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Scott Cheloha <cheloha@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 93/99] mm: replace memmap_context by meminit_context
Date:   Tue, 29 Sep 2020 13:02:16 +0200
Message-Id: <20200929105934.325620504@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

commit c1d0da83358a2316d9be7f229f26126dbaa07468 upstream.

Patch series "mm: fix memory to node bad links in sysfs", v3.

Sometimes, firmware may expose interleaved memory layout like this:

 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

In that case, we can see memory blocks assigned to multiple nodes in
sysfs:

  $ ls -l /sys/devices/system/memory/memory21
  total 0
  lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
  lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
  -rw-r--r-- 1 root root 65536 Aug 24 05:27 online
  -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_device
  -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_index
  drwxr-xr-x 2 root root     0 Aug 24 05:27 power
  -r--r--r-- 1 root root 65536 Aug 24 05:27 removable
  -rw-r--r-- 1 root root 65536 Aug 24 05:27 state
  lrwxrwxrwx 1 root root     0 Aug 24 05:25 subsystem -> ../../../../bus/memory
  -rw-r--r-- 1 root root 65536 Aug 24 05:25 uevent
  -r--r--r-- 1 root root 65536 Aug 24 05:27 valid_zones

The same applies in the node's directory with a memory21 link in both
the node1 and node2's directory.

This is wrong but doesn't prevent the system to run.  However when
later, one of these memory blocks is hot-unplugged and then hot-plugged,
the system is detecting an inconsistency in the sysfs layout and a
BUG_ON() is raised:

  kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
  CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
  Call Trace:
    add_memory_resource+0x23c/0x340 (unreliable)
    __add_memory+0x5c/0xf0
    dlpar_add_lmb+0x1b4/0x500
    dlpar_memory+0x1f8/0xb80
    handle_dlpar_errorlog+0xc0/0x190
    dlpar_store+0x198/0x4a0
    kobj_attr_store+0x30/0x50
    sysfs_kf_write+0x64/0x90
    kernfs_fop_write+0x1b0/0x290
    vfs_write+0xe8/0x290
    ksys_write+0xdc/0x130
    system_call_exception+0x160/0x270
    system_call_common+0xf0/0x27c

This has been seen on PowerPC LPAR.

The root cause of this issue is that when node's memory is registered,
the range used can overlap another node's range, thus the memory block
is registered to multiple nodes in sysfs.

There are two issues here:

 (a) The sysfs memory and node's layouts are broken due to these
     multiple links

 (b) The link errors in link_mem_sections() should not lead to a system
     panic.

To address (a) register_mem_sect_under_node should not rely on the
system state to detect whether the link operation is triggered by a hot
plug operation or not.  This is addressed by the patches 1 and 2 of this
series.

Issue (b) will be addressed separately.

This patch (of 2):

The memmap_context enum is used to detect whether a memory operation is
due to a hot-add operation or happening at boot time.

Make it general to the hotplug operation and rename it as
meminit_context.

There is no functional change introduced by this patch

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200915094143.79181-1-ldufour@linux.ibm.com
Link: https://lkml.kernel.org/r/20200915132624.9723-1-ldufour@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/ia64/mm/init.c    |    6 +++---
 include/linux/mm.h     |    2 +-
 include/linux/mmzone.h |   11 ++++++++---
 mm/memory_hotplug.c    |    2 +-
 mm/page_alloc.c        |   10 +++++-----
 5 files changed, 18 insertions(+), 13 deletions(-)

--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end,
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL);
+				 MEMINIT_EARLY, NULL);
 	return 0;
 }
 
@@ -547,8 +547,8 @@ memmap_init (unsigned long size, int nid
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
-		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY,
-				NULL);
+		memmap_init_zone(size, nid, zone, start_pfn,
+				 MEMINIT_EARLY, NULL);
 	} else {
 		struct page *start;
 		struct memmap_init_callback_data args;
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2445,7 +2445,7 @@ extern int __meminit __early_pfn_to_nid(
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum memmap_context, struct vmem_altmap *);
+		enum meminit_context, struct vmem_altmap *);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -799,10 +799,15 @@ bool zone_watermark_ok(struct zone *z, u
 		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx);
-enum memmap_context {
-	MEMMAP_EARLY,
-	MEMMAP_HOTPLUG,
+/*
+ * Memory initialization context, use to differentiate memory added by
+ * the platform statically or via memory hotplug interface.
+ */
+enum meminit_context {
+	MEMINIT_EARLY,
+	MEMINIT_HOTPLUG,
 };
+
 extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
 				     unsigned long size);
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -719,7 +719,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			MEMMAP_HOTPLUG, altmap);
+			 MEMINIT_HOTPLUG, altmap);
 
 	set_zone_contiguous(zone);
 }
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5952,7 +5952,7 @@ overlap_memmap_init(unsigned long zone,
  * done. Non-atomic initialization, single-pass.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum memmap_context context,
+		unsigned long start_pfn, enum meminit_context context,
 		struct vmem_altmap *altmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
@@ -5984,7 +5984,7 @@ void __meminit memmap_init_zone(unsigned
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context == MEMMAP_EARLY) {
+		if (context == MEMINIT_EARLY) {
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
 			if (defer_init(nid, pfn, end_pfn))
@@ -5993,7 +5993,7 @@ void __meminit memmap_init_zone(unsigned
 
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
+		if (context == MEMINIT_HOTPLUG)
 			__SetPageReserved(page);
 
 		/*
@@ -6076,7 +6076,7 @@ void __ref memmap_init_zone_device(struc
 		 * check here not to call set_pageblock_migratetype() against
 		 * pfn out of zone.
 		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in section_activate()
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
@@ -6114,7 +6114,7 @@ void __meminit __weak memmap_init(unsign
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn,
-					 MEMMAP_EARLY, NULL);
+					 MEMINIT_EARLY, NULL);
 		}
 	}
 }


