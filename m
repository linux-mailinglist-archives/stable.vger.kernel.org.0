Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093A624B8D9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHTL3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgHTKFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:05:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7C720724;
        Thu, 20 Aug 2020 10:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917940;
        bh=Bnhybgps70jCzF8JjGbVuzfSU5kD4eHDHTpa2CI03wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrv82OfNLdfVvCBIQLR6p7u6J7KvPUMZ+3WDYeht5b1RSRlq4Si5sjVySu1/wDRuz
         uBylqH/2AhgdM3BTaucbo4iQQzvUSBjylcK4/4HHWUyLq1jAoxPw+6YKhLb90LZbH6
         RN0yqnlk9K4pzZkd4FMOcTNTAD3EijpLoOxh7EUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH 4.9 211/212] mm: Avoid calling build_all_zonelists_init under hotplug context
Date:   Thu, 20 Aug 2020 11:23:04 +0200
Message-Id: <20200820091612.997125429@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>

Recently a customer of ours experienced a crash when booting the
system while enabling memory-hotplug.

The problem is that Normal zones on different nodes don't get their private
zone->pageset allocated, and keep sharing the initial boot_pageset.
The sharing between zones is normally safe as explained by the comment for
boot_pageset - it's a percpu structure, and manipulations are done with
disabled interrupts, and boot_pageset is set up in a way that any page placed
on its pcplist is immediately flushed to shared zone's freelist, because
pcp->high == 1.
However, the hotplug operation updates pcp->high to a higher value as it
expects to be operating on a private pageset.

The problem is in build_all_zonelists(), which is called when the first range
of pages is onlined for the Normal zone of node X or Y:

	if (system_state == SYSTEM_BOOTING) {
		build_all_zonelists_init();
	} else {
	#ifdef CONFIG_MEMORY_HOTPLUG
		if (zone)
			setup_zone_pageset(zone);
	#endif
		/* we have to stop all cpus to guarantee there is no user
		of zonelist */
		stop_machine(__build_all_zonelists, pgdat, NULL);
		/* cpuset refresh routine should be here */
	}

When called during hotplug, it should execute the setup_zone_pageset(zone)
which allocates the private pageset.
However, with memhp_default_state=online, this happens early while
system_state == SYSTEM_BOOTING is still true, hence this step is skipped.
(and build_all_zonelists_init() is probably unsafe anyway at this point).

Another hotplug operation on the same zone then leads to zone_pcp_update(zone)
called from online_pages(), which updates the pcp->high for the shared
boot_pageset to a value higher than 1.
At that point, pages freed from Node X and Y Normal zones can end up on the same
pcplist and from there they can be freed to the wrong zone's freelist,
leading to the corruption and crashes.

Please, note that upstream has fixed that differently (and unintentionally) by
adding another boot state (SYSTEM_SCHEDULING), which is set before smp_init().
That should happen before memory hotplug events even with memhp_default_state=online.
Backporting that would be too intrusive.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
Debugged-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com> # for stable trees
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |    3 ++-
 init/main.c            |    2 +-
 mm/memory_hotplug.c    |   10 +++++-----
 mm/page_alloc.c        |    7 ++++---
 4 files changed, 12 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -756,7 +756,8 @@ static inline bool is_dev_zone(const str
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
+void build_all_zonelists(pg_data_t *pgdat, struct zone *zone,
+			 bool hotplug_context);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int classzone_idx, unsigned int alloc_flags,
--- a/init/main.c
+++ b/init/main.c
@@ -512,7 +512,7 @@ asmlinkage __visible void __init start_k
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	boot_cpu_hotplug_init();
 
-	build_all_zonelists(NULL, NULL);
+	build_all_zonelists(NULL, NULL, false);
 	page_alloc_init();
 
 	pr_notice("Kernel command line: %s\n", boot_command_line);
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1125,7 +1125,7 @@ int __ref online_pages(unsigned long pfn
 	mutex_lock(&zonelists_mutex);
 	if (!populated_zone(zone)) {
 		need_zonelists_rebuild = 1;
-		build_all_zonelists(NULL, zone);
+		build_all_zonelists(NULL, zone, true);
 	}
 
 	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
@@ -1146,7 +1146,7 @@ int __ref online_pages(unsigned long pfn
 	if (onlined_pages) {
 		node_states_set_node(nid, &arg);
 		if (need_zonelists_rebuild)
-			build_all_zonelists(NULL, NULL);
+			build_all_zonelists(NULL, NULL, true);
 		else
 			zone_pcp_update(zone);
 	}
@@ -1220,7 +1220,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 	 * to access not-initialized zonelist, build here.
 	 */
 	mutex_lock(&zonelists_mutex);
-	build_all_zonelists(pgdat, NULL);
+	build_all_zonelists(pgdat, NULL, true);
 	mutex_unlock(&zonelists_mutex);
 
 	/*
@@ -1276,7 +1276,7 @@ int try_online_node(int nid)
 
 	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
 		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL, NULL);
+		build_all_zonelists(NULL, NULL, true);
 		mutex_unlock(&zonelists_mutex);
 	}
 
@@ -2016,7 +2016,7 @@ repeat:
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL, NULL);
+		build_all_zonelists(NULL, NULL, true);
 		mutex_unlock(&zonelists_mutex);
 	} else
 		zone_pcp_update(zone);
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4608,7 +4608,7 @@ int numa_zonelist_order_handler(struct c
 			user_zonelist_order = oldval;
 		} else if (oldval != user_zonelist_order) {
 			mutex_lock(&zonelists_mutex);
-			build_all_zonelists(NULL, NULL);
+			build_all_zonelists(NULL, NULL, false);
 			mutex_unlock(&zonelists_mutex);
 		}
 	}
@@ -4988,11 +4988,12 @@ build_all_zonelists_init(void)
  * (2) call of __init annotated helper build_all_zonelists_init
  * [protected by SYSTEM_BOOTING].
  */
-void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
+void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone,
+			       bool hotplug_context)
 {
 	set_zonelist_order();
 
-	if (system_state == SYSTEM_BOOTING) {
+	if (system_state == SYSTEM_BOOTING && !hotplug_context) {
 		build_all_zonelists_init();
 	} else {
 #ifdef CONFIG_MEMORY_HOTPLUG


