Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7874D5841
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 03:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345691AbiCKCnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 21:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240820AbiCKCnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 21:43:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E217E192CA2;
        Thu, 10 Mar 2022 18:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AEC7B827DB;
        Fri, 11 Mar 2022 02:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CCEC340E8;
        Fri, 11 Mar 2022 02:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646966523;
        bh=JZWo3aB0MBpKqz+4vU4lOoEqjlr9eckidtvJYAyTVw4=;
        h=Date:To:From:Subject:From;
        b=RvlOHSQ//FQFBOiTi3fLVi9vXPIJbCU7PzOvdi2kKKIyYONme0BmySHh053pO3soF
         XVVpFqS/dbtOVaxKQeKMOfwTlP5jz6yUEJNUOuNCK51PkrjXDwpMjqzhQf4UNKHbSR
         pWhwYrZ0eIqUfoUmBZlA/ZKaLTY/60nq6D5C1B7U=
Date:   Thu, 10 Mar 2022 18:42:02 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        stable@vger.kernel.org, huntbag@linux.vnet.ibm.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch added to -mm tree
Message-Id: <20220311024203.22CCEC340E8@smtp.kernel.org>
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
has been added to the -mm tree.  Its filename is
     mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: only re-generate demotion targets when a numa node changes its N_CPU state

Abhishek reported that after patch [1], hotplug operations are taking
~double the expected time.  [2]

The reason behind is that the CPU callbacks that migrate_on_reclaim_init()
sets always call set_migration_target_nodes() whenever a CPU is brought
up/down.  But we only care about numa nodes going from having cpus to
become cpuless, and vice versa, as that influences the demotion_target
order.

We do already have two CPU callbacks (vmstat_cpu_online() and
vmstat_cpu_dead()) that check exactly that, so get rid of the CPU
callbacks in migrate_on_reclaim_init() and only call
set_migration_target_nodes() from vmstat_cpu_{dead,online}() whenever a
numa node change its N_CPU state.

[1] https://lore.kernel.org/linux-mm/20210721063926.3024591-2-ying.huang@intel.com/
[2] https://lore.kernel.org/linux-mm/eb438ddd-2919-73d4-bd9f-b7eecdd9577a@linux.vnet.ibm.com/

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

 include/linux/migrate.h |    8 +++++++
 mm/migrate.c            |   41 ++++----------------------------------
 mm/vmstat.c             |   13 +++++++++++-
 3 files changed, 25 insertions(+), 37 deletions(-)

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
@@ -3211,7 +3211,7 @@ again:
 /*
  * For callers that do not hold get_online_mems() already.
  */
-static void set_migration_target_nodes(void)
+void set_migration_target_nodes(void)
 {
 	get_online_mems();
 	__set_migration_target_nodes();
@@ -3275,51 +3275,20 @@ static int __meminit migrate_on_reclaim_
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
+void __init migrate_on_reclaim_init(void)
 {
-	set_migration_target_nodes();
-	return 0;
-}
-
-static int __init migrate_on_reclaim_init(void)
-{
-	int ret;
-
 	node_demotion = kmalloc_array(nr_node_ids,
 				      sizeof(struct demotion_nodes),
 				      GFP_KERNEL);
 	WARN_ON(!node_demotion);
 
-	ret = cpuhp_setup_state_nocalls(CPUHP_MM_DEMOTION_DEAD, "mm/demotion:offline",
-					NULL, migration_offline_cpu);
 	/*
-	 * In the unlikely case that this fails, the automatic
-	 * migration targets may become suboptimal for nodes
-	 * where N_CPU changes.  With such a small impact in a
-	 * rare case, do not bother trying to do anything special.
+	 * At this point, all numa nodes with memory/CPus have their state
+	 * properly set, so we can build the demotion order now.
 	 */
-	WARN_ON(ret < 0);
-	ret = cpuhp_setup_state(CPUHP_AP_MM_DEMOTION_ONLINE, "mm/demotion:online",
-				migration_online_cpu, NULL);
-	WARN_ON(ret < 0);
-
+	set_migration_target_nodes();
 	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
-	return 0;
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

arch-x86-mm-numa-do-not-initialize-nodes-twice.patch
arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch

