Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848D5101915
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfKSFXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfKSFXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296D522317;
        Tue, 19 Nov 2019 05:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140983;
        bh=0eiYQG37A8Xn/Xd+7hEkrTBHoUpMbmNpFaZdQfNiSo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWWBCJORBZOrDQZESfnaCa9/4sWVOQ2IDCbpCSKZl1Bu2G0GDU+Skx7tn7TTVLNKV
         lVckb9VeMypXWlgXk+vXUvJBIJswweC8tcz6r/XX0MhF27WZtEIIGQRC449NxgrNAt
         TJK+9WoYNE8OajsGIcnvQ+8w1+geydop7gQ8iGKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Keith Busch <keith.busch@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 46/48] mm/memory_hotplug: fix try_offline_node()
Date:   Tue, 19 Nov 2019 06:20:06 +0100
Message-Id: <20191119051029.239343815@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 2c91f8fc6c999fe10185d8ad99fda1759f662f70 upstream.

try_offline_node() is pretty much broken right now:

 - The node span is updated when onlining memory, not when adding it. We
   ignore memory that was mever onlined. Bad.

 - We touch possible garbage memmaps. The pfn_to_nid(pfn) can easily
   trigger a kernel panic. Bad for memory that is offline but also bad
   for subsection hotadd with ZONE_DEVICE, whereby the memmap of the
   first PFN of a section might contain garbage.

 - Sections belonging to mixed nodes are not properly considered.

As memory blocks might belong to multiple nodes, we would have to walk
all pageblocks (or at least subsections) within present sections.
However, we don't have a way to identify whether a memmap that is not
online was initialized (relevant for ZONE_DEVICE).  This makes things
more complicated.

Luckily, we can piggy pack on the node span and the nid stored in memory
blocks.  Currently, the node span is grown when calling
move_pfn_range_to_zone() - e.g., when onlining memory, and shrunk when
removing memory, before calling try_offline_node().  Sysfs links are
created via link_mem_sections(), e.g., during boot or when adding
memory.

If the node still spans memory or if any memory block belongs to the
nid, we don't set the node offline.  As memory blocks that span multiple
nodes cannot get offlined, the nid stored in memory blocks is reliable
enough (for such online memory blocks, the node still spans the memory).

Introduce for_each_memory_block() to efficiently walk all memory blocks.

Note: We will soon stop shrinking the ZONE_DEVICE zone and the node span
when removing ZONE_DEVICE memory to fix similar issues (access of
garbage memmaps) - until we have a reliable way to identify whether
these memmaps were properly initialized.  This implies later, that once
a node had ZONE_DEVICE memory, we won't be able to set a node offline -
which should be acceptable.

Since commit f1dd2cd13c4b ("mm, memory_hotplug: do not associate
hotadded memory to zones until online") memory that is added is not
assoziated with a zone/node (memmap not initialized).  The introducing
commit 60a5a19e7419 ("memory-hotplug: remove sysfs file of node")
already missed that we could have multiple nodes for a section and that
the zone/node span is updated when onlining pages, not when adding them.

I tested this by hotplugging two DIMMs to a memory-less and cpu-less
NUMA node.  The node is properly onlined when adding the DIMMs.  When
removing the DIMMs, the node is properly offlined.

Masayoshi Mizuma reported:

: Without this patch, memory hotplug fails as panic:
:
:  BUG: kernel NULL pointer dereference, address: 0000000000000000
:  ...
:  Call Trace:
:   remove_memory_block_devices+0x81/0xc0
:   try_remove_memory+0xb4/0x130
:   __remove_memory+0xa/0x20
:   acpi_memory_device_remove+0x84/0x100
:   acpi_bus_trim+0x57/0x90
:   acpi_bus_trim+0x2e/0x90
:   acpi_device_hotplug+0x2b2/0x4d0
:   acpi_hotplug_work_fn+0x1a/0x30
:   process_one_work+0x171/0x380
:   worker_thread+0x49/0x3f0
:   kthread+0xf8/0x130
:   ret_from_fork+0x35/0x40

[david@redhat.com: v3]
  Link: http://lkml.kernel.org/r/20191102120221.7553-1-david@redhat.com
Link: http://lkml.kernel.org/r/20191028105458.28320-1-david@redhat.com
Fixes: 60a5a19e7419 ("memory-hotplug: remove sysfs file of node")
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online") # visiable after d0dc12e86b319
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/memory.c  |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/memory.h |    1 +
 mm/memory_hotplug.c    |   47 +++++++++++++++++++++++++++++------------------
 3 files changed, 66 insertions(+), 18 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -884,3 +884,39 @@ int walk_memory_blocks(unsigned long sta
 	}
 	return ret;
 }
+
+struct for_each_memory_block_cb_data {
+	walk_memory_blocks_func_t func;
+	void *arg;
+};
+
+static int for_each_memory_block_cb(struct device *dev, void *data)
+{
+	struct memory_block *mem = to_memory_block(dev);
+	struct for_each_memory_block_cb_data *cb_data = data;
+
+	return cb_data->func(mem, cb_data->arg);
+}
+
+/**
+ * for_each_memory_block - walk through all present memory blocks
+ *
+ * @arg: argument passed to func
+ * @func: callback for each memory block walked
+ *
+ * This function walks through all present memory blocks, calling func on
+ * each memory block.
+ *
+ * In case func() returns an error, walking is aborted and the error is
+ * returned.
+ */
+int for_each_memory_block(void *arg, walk_memory_blocks_func_t func)
+{
+	struct for_each_memory_block_cb_data cb_data = {
+		.func = func,
+		.arg = arg,
+	};
+
+	return bus_for_each_dev(&memory_subsys, NULL, &cb_data,
+				for_each_memory_block_cb);
+}
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -120,6 +120,7 @@ extern struct memory_block *find_memory_
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
+extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t func);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1687,6 +1687,18 @@ static int check_cpu_on_node(pg_data_t *
 	return 0;
 }
 
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
 /**
  * try_offline_node
  * @nid: the node ID
@@ -1699,25 +1711,24 @@ static int check_cpu_on_node(pg_data_t *
 void try_offline_node(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	unsigned long start_pfn = pgdat->node_start_pfn;
-	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-
-		if (!present_section_nr(section_nr))
-			continue;
-
-		if (pfn_to_nid(pfn) != nid)
-			continue;
-
-		/*
-		 * some memory sections of this node are not removed, and we
-		 * can't offline node now.
-		 */
+	int rc;
+
+	/*
+	 * If the node still spans pages (especially ZONE_DEVICE), don't
+	 * offline it. A node spans memory after move_pfn_range_to_zone(),
+	 * e.g., after the memory block was onlined.
+	 */
+	if (pgdat->node_spanned_pages)
+		return;
+
+	/*
+	 * Especially offline memory blocks might not be spanned by the
+	 * node. They will get spanned by the node once they get onlined.
+	 * However, they link to the node in sysfs and can get onlined later.
+	 */
+	rc = for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+	if (rc)
 		return;
-	}
 
 	if (check_cpu_on_node(pgdat))
 		return;


