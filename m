Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68C84E6C0F
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 02:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354799AbiCYBgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 21:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357474AbiCYBew (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD24C12E8;
        Thu, 24 Mar 2022 18:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99136B82726;
        Fri, 25 Mar 2022 01:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39535C340ED;
        Fri, 25 Mar 2022 01:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171970;
        bh=2xRjG0TAX9wdABTQj/Q9IDV4oZQXMOnRMl1YwU9V2Ss=;
        h=Date:To:From:Subject:From;
        b=oa2zyt2rrHqzNqaj4S/fyR+WUjWp7inwvfBQxArTJlum0NiM5ndzqhdJTSicuNeUT
         0xlC6umGexsG7VnRq+Z4rHCHE0zW/oAwwkB271BgxVPr9xxjCfYDtoMbzHqW4pxhFm
         KVENMqUNELfalJPgY7QC/V3sHSfZdIbLwdP4JMZk=
Date:   Thu, 24 Mar 2022 18:32:49 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        stable@vger.kernel.org, huntbag@linux.vnet.ibm.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch removed from -mm tree
Message-Id: <20220325013250.39535C340ED@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: only re-generate demotion targets when a numa node changes its N_CPU state
has been removed from the -mm tree.  Its filename was
     mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: only re-generate demotion targets when a numa node changes its N_CPU state

Abhishek reported that after patch [1], hotplug operations are taking
~double the expected time.  [2]

The reason behind is that the CPU callbacks that migrate_on_reclaim_init()
sets always call set_migration_target_nodes() whenever a CPU is brought
up/down.

But we only care about numa nodes going from having cpus to become
cpuless, and vice versa, as that influences the demotion_target order.

We do already have two CPU callbacks (vmstat_cpu_online() and
vmstat_cpu_dead()) that check exactly that, so get rid of the CPU
callbacks in migrate_on_reclaim_init() and only call
set_migration_target_nodes() from vmstat_cpu_{dead,online}() whenever a
numa node change its N_CPU state.

[1] https://lore.kernel.org/linux-mm/20210721063926.3024591-2-ying.huang@intel.com/
[2] https://lore.kernel.org/linux-mm/eb438ddd-2919-73d4-bd9f-b7eecdd9577a@linux.vnet.ibm.com/

[osalvador@suse.de: add feedback from Huang Ying]
  Link: https://lkml.kernel.org/r/20220314150945.12694-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20220310120749.23077-1-osalvador@suse.de
Fixes: 884a6e5d1f93b ("mm/migrate: update node demotion order on hotplug events")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Abhishek Goel <huntbag@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Abhishek Goel <huntbag@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    8 ++++++
 mm/migrate.c            |   47 ++++++++------------------------------
 mm/vmstat.c             |   13 +++++++++-
 3 files changed, 30 insertions(+), 38 deletions(-)

--- a/include/linux/migrate.h~mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state
+++ a/include/linux/migrate.h
@@ -48,7 +48,15 @@ int folio_migrate_mapping(struct address
 		struct folio *newfolio, struct folio *folio, int extra_count);
 
 extern bool numa_demotion_enabled;
+extern void migrate_on_reclaim_init(void);
+#ifdef CONFIG_HOTPLUG_CPU
+extern void set_migration_target_nodes(void);
 #else
+static inline void set_migration_target_nodes(void) {}
+#endif
+#else
+
+static inline void set_migration_target_nodes(void) {}
 
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t new,
--- a/mm/migrate.c~mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state
+++ a/mm/migrate.c
@@ -3209,7 +3209,7 @@ again:
 /*
  * For callers that do not hold get_online_mems() already.
  */
-static void set_migration_target_nodes(void)
+void set_migration_target_nodes(void)
 {
 	get_online_mems();
 	__set_migration_target_nodes();
@@ -3273,51 +3273,24 @@ static int __meminit migrate_on_reclaim_
 	return notifier_from_errno(0);
 }
 
-/*
- * React to hotplug events that might affect the migration targets
- * like events that online or offline NUMA nodes.
- *
- * The ordering is also currently dependent on which nodes have
- * CPUs.  That means we need CPU on/offline notification too.
- */
-static int migration_online_cpu(unsigned int cpu)
-{
-	set_migration_target_nodes();
-	return 0;
-}
-
-static int migration_offline_cpu(unsigned int cpu)
-{
-	set_migration_target_nodes();
-	return 0;
-}
-
-static int __init migrate_on_reclaim_init(void)
+void __init migrate_on_reclaim_init(void)
 {
-	int ret;
-
 	node_demotion = kmalloc_array(nr_node_ids,
 				      sizeof(struct demotion_nodes),
 				      GFP_KERNEL);
 	WARN_ON(!node_demotion);
 
-	ret = cpuhp_setup_state_nocalls(CPUHP_MM_DEMOTION_DEAD, "mm/demotion:offline",
-					NULL, migration_offline_cpu);
+	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
 	/*
-	 * In the unlikely case that this fails, the automatic
-	 * migration targets may become suboptimal for nodes
-	 * where N_CPU changes.  With such a small impact in a
-	 * rare case, do not bother trying to do anything special.
+	 * At this point, all numa nodes with memory/CPus have their state
+	 * properly set, so we can build the demotion order now.
+	 * Let us hold the cpu_hotplug lock just, as we could possibily have
+	 * CPU hotplug events during boot.
 	 */
-	WARN_ON(ret < 0);
-	ret = cpuhp_setup_state(CPUHP_AP_MM_DEMOTION_ONLINE, "mm/demotion:online",
-				migration_online_cpu, NULL);
-	WARN_ON(ret < 0);
-
-	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
-	return 0;
+	cpus_read_lock();
+	set_migration_target_nodes();
+	cpus_read_unlock();
 }
-late_initcall(migrate_on_reclaim_init);
 #endif /* CONFIG_HOTPLUG_CPU */
 
 bool numa_demotion_enabled = false;
--- a/mm/vmstat.c~mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state
+++ a/mm/vmstat.c
@@ -28,6 +28,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_ext.h>
 #include <linux/page_owner.h>
+#include <linux/migrate.h>
 
 #include "internal.h"
 
@@ -2049,7 +2050,12 @@ static void __init init_cpu_node_state(v
 static int vmstat_cpu_online(unsigned int cpu)
 {
 	refresh_zone_stat_thresholds();
-	node_set_state(cpu_to_node(cpu), N_CPU);
+
+	if (!node_state(cpu_to_node(cpu), N_CPU)) {
+		node_set_state(cpu_to_node(cpu), N_CPU);
+		set_migration_target_nodes();
+	}
+
 	return 0;
 }
 
@@ -2072,6 +2078,8 @@ static int vmstat_cpu_dead(unsigned int
 		return 0;
 
 	node_clear_state(node, N_CPU);
+	set_migration_target_nodes();
+
 	return 0;
 }
 
@@ -2103,6 +2111,9 @@ void __init init_mm_internals(void)
 
 	start_shepherd_timer();
 #endif
+#if defined(CONFIG_MIGRATION) && defined(CONFIG_HOTPLUG_CPU)
+	migrate_on_reclaim_init();
+#endif
 #ifdef CONFIG_PROC_FS
 	proc_create_seq("buddyinfo", 0444, NULL, &fragmentation_op);
 	proc_create_seq("pagetypeinfo", 0400, NULL, &pagetypeinfo_op);
_

Patches currently in -mm which might be from osalvador@suse.de are


