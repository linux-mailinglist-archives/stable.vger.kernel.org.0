Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A8B46E6FD
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 11:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhLIKwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 05:52:17 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:42938 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhLIKwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 05:52:16 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 744D2210FF;
        Thu,  9 Dec 2021 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639046922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SSQmDk3q7sHfu7o9XE7LmloN7f0Ebyxqu8tzZjKkvGs=;
        b=WNRvD8SGFbr3ukCQhTktI9c3bKVj0pTjSD3tZ8ggNa+cGspkTSH+hfAocP8CqsBeNT2XXT
        hK3IvWZ+qCX/21SnjLpQAfNt3i4WAitEIIvS9XZ5/uCf07FHMVCocagskmCQ+3ahDoCMUq
        VPZ06VLEWvf8L8BBdZrUx6IEnWQNh7M=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3FD50A3B81;
        Thu,  9 Dec 2021 10:48:42 +0000 (UTC)
Date:   Thu, 9 Dec 2021 11:48:38 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nico Pache <npache@redhat.com>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbHfBgPQMkjtuHYF@dhcp22.suse.cz>
References: <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc Nico who has reported a similar problem]

Another attempt to handle the issue. Can you give this a try please?
David could you have a look whether anything hotplug related is missing
at this stage. Once we are settled on this fix I would like to get rid
of the node_state (offline/online) but that is a work on top.
---
From 36782ebaab2eaec637627506ab627c554bb948de Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Thu, 9 Dec 2021 10:00:02 +0100
Subject: [PATCH] mm: handle uninitialized numa nodes gracefully

We have had several reports [1][2][3] that page allocator blows up when
an allocation from a possible node is requested. The underlying reason
is that NODE_DATA for the specific node is not allocated.

NUMA specific initialization is arch specific and it can vary a lot.
E.g. x86 tries to initialize all nodes that have some cpu affinity (see
init_cpu_to_node) but this can be insufficient because the node might be
cpuless for example.

One way to address this problem would be to check for !node_online nodes
when trying to get a zonelist and silently fall back to another node.
That is unfortunately adding a branch into allocator hot path and it
doesn't handle any other potential NODE_DATA users.

This patch takes a different approach (following a lead of [3]) and it
pre allocates pgdat for all possible nodes in an arch indipendent code
- free_area_init. All uninitialized nodes are treated as memoryless
nodes. node_state of the node is not changed because that would lead to
other side effects - e.g. sysfs representation of such a node and from
past discussions [4] it is known that some tools might have problems
digesting that.

Newly allocated pgdat only gets a minimal initialization and the rest of
the work is expected to be done by the memory hotplug - hotadd_new_pgdat
(renamed to hotadd_init_pgdat).

generic_alloc_nodedata is changed to use the memblock allocator because
neither page nor slab allocators are available at the stage when all
pgdats are allocated. Hotplug doesn't allocate pgdat anymore so we can
use the early boot allocator. The only arch specific implementation is
ia64 and that is changed to use the early allocator as well.

Reported-by: Alexey Makhalov <amakhalov@vmware.com>
Reported-by: Nico Pache <npache@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>

[1] http://lkml.kernel.org/r/20211101201312.11589-1-amakhalov@vmware.com
[2] http://lkml.kernel.org/r/20211207224013.880775-1-npache@redhat.com
[3] http://lkml.kernel.org/r/20190114082416.30939-1-mhocko@kernel.org
[4] http://lkml.kernel.org/r/20200428093836.27190-1-srikar@linux.vnet.ibm.com
---
 arch/ia64/mm/discontig.c       |  2 +-
 include/linux/memory_hotplug.h |  5 ++---
 mm/memory_hotplug.c            | 21 +++++++++------------
 mm/page_alloc.c                | 34 +++++++++++++++++++++++++++++++---
 4 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 791d4176e4a6..9a7a09e0aa52 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -613,7 +613,7 @@ pg_data_t *arch_alloc_nodedata(int nid)
 {
 	unsigned long size = compute_pernodesize(nid);
 
-	return kzalloc(size, GFP_KERNEL);
+	return memblock_alloc(size, SMP_CACHE_BYTES);
 }
 
 void arch_free_nodedata(pg_data_t *pgdat)
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index be48e003a518..38f8d33f0884 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -176,14 +176,13 @@ extern void arch_refresh_nodedata(int nid, pg_data_t *pgdat);
 
 #ifdef CONFIG_NUMA
 /*
- * If ARCH_HAS_NODEDATA_EXTENSION=n, this func is used to allocate pgdat.
- * XXX: kmalloc_node() can't work well to get new node's memory at this time.
+ * XXX: node aware allocation can't work well to get new node's memory at this time.
  *	Because, pgdat for the new node is not allocated/initialized yet itself.
  *	To use new node's memory, more consideration will be necessary.
  */
 #define generic_alloc_nodedata(nid)				\
 ({								\
-	kzalloc(sizeof(pg_data_t), GFP_KERNEL);			\
+	memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);	\
 })
 /*
  * This definition is just for error path in node hotadd.
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 852041f6be41..2d38a431f62f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1161,19 +1161,21 @@ static void reset_node_present_pages(pg_data_t *pgdat)
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-static pg_data_t __ref *hotadd_new_pgdat(int nid)
+static pg_data_t __ref *hotadd_init_pgdat(int nid)
 {
 	struct pglist_data *pgdat;
 
 	pgdat = NODE_DATA(nid);
-	if (!pgdat) {
-		pgdat = arch_alloc_nodedata(nid);
-		if (!pgdat)
-			return NULL;
 
+	/*
+	 * NODE_DATA is preallocated (free_area_init) but its internal
+	 * state is not allocated completely. Add missing pieces.
+	 * Completely offline nodes stay around and they just need
+	 * reintialization.
+	 */
+	if (!pgdat->per_cpu_nodestats) {
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
-		arch_refresh_nodedata(nid, pgdat);
 	} else {
 		int cpu;
 		/*
@@ -1192,8 +1194,6 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid)
 		}
 	}
 
-	/* we can use NODE_DATA(nid) from here */
-	pgdat->node_id = nid;
 	pgdat->node_start_pfn = 0;
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
@@ -1245,7 +1245,7 @@ static int __try_online_node(int nid, bool set_node_online)
 	if (node_online(nid))
 		return 0;
 
-	pgdat = hotadd_new_pgdat(nid);
+	pgdat = hotadd_init_pgdat(nid);
 	if (!pgdat) {
 		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
 		ret = -ENOMEM;
@@ -1444,9 +1444,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	return ret;
 error:
-	/* rollback pgdat allocation and others */
-	if (new_node)
-		rollback_node_hotadd(nid);
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
 error_mem_hotplug_end:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..f2ceffadf4eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
 	if (self && !node_online(self->node_id)) {
 		build_zonelists(self);
 	} else {
-		for_each_online_node(nid) {
+		/*
+		 * All possible nodes have pgdat preallocated
+		 * free_area_init
+		 */
+		for_each_node(nid) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			build_zonelists(pgdat);
@@ -8032,8 +8036,32 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
+	for_each_node(nid) {
+		pg_data_t *pgdat;
+
+		if (!node_online(nid)) {
+			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);
+
+			/* Allocator not initialized yet */
+			pgdat = arch_alloc_nodedata(nid);
+			if (!pgdat) {
+				pr_err("Cannot allocate %zuB for node %d.\n",
+						sizeof(*pgdat), nid);
+				continue;
+			}
+			arch_refresh_nodedata(nid, pgdat);
+			free_area_init_memoryless_node(nid);
+			/*
+			 * not marking this node online because we do not want to
+			 * confuse userspace by sysfs files/directories for node
+			 * without any memory attached to it (see topology_init)
+			 * The pgdat will get fully initialized when a memory is
+			 * hotpluged into it by hotadd_init_pgdat
+			 */
+			continue;
+		}
+
+		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
-- 
2.30.2

-- 
Michal Hocko
SUSE Labs
