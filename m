Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCBB714B216
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgA1Jvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40950 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbgA1Jvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBDk1XgW0lkxRBSVePczRA0UBI9ESGrB1ATzpWziNOg=;
        b=OmgJh73fABoBuVIp7uiV+qclYc70S6p77wjfkw/0cOoi2mmZMpMwgm+OV/WLnvn/8e05oJ
        T4rjGYgUiQ4HuzE98qHOc+MC/NedFHgPumo26AIL9/fYNrIU+m4/qUVXxVhoX2BJh1+DVt
        C9+Vgw0k1REZiEaVSftYSz3HCsifzSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-QTuVuxwLPY6XPmGTSs3FTw-1; Tue, 28 Jan 2020 04:51:49 -0500
X-MC-Unique: QTuVuxwLPY6XPmGTSs3FTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3970C8010D8;
        Tue, 28 Jan 2020 09:51:48 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 949B560BE0;
        Tue, 28 Jan 2020 09:51:43 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v3 23/24] mm/memory_hotplug: fix try_offline_node()
Date:   Tue, 28 Jan 2020 10:50:20 +0100
Message-Id: <20200128095021.8076-24-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2c91f8fc6c999fe10185d8ad99fda1759f662f70 upstream.

-- snip --

Only contextual issues:
- Unrelated check_and_unmap_cpu_on_node() changes are missing.
- Unrelated walk_memory_blocks() has not been moved/refactored yet.

-- snip --

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
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memor=
y to zones until online") # visiable after d0dc12e86b319
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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c  | 36 +++++++++++++++++++++++++++++++++++
 include/linux/memory.h |  2 ++
 mm/memory_hotplug.c    | 43 ++++++++++++++++++++++++++----------------
 3 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index fde8d34a1c16..e270abc86d46 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -862,3 +862,39 @@ int __init memory_dev_init(void)
 		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
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
+	struct memory_block *mem =3D to_memory_block(dev);
+	struct for_each_memory_block_cb_data *cb_data =3D data;
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
+ * This function walks through all present memory blocks, calling func o=
n
+ * each memory block.
+ *
+ * In case func() returns an error, walking is aborted and the error is
+ * returned.
+ */
+int for_each_memory_block(void *arg, walk_memory_blocks_func_t func)
+{
+	struct for_each_memory_block_cb_data cb_data =3D {
+		.func =3D func,
+		.arg =3D arg,
+	};
+
+	return bus_for_each_dev(&memory_subsys, NULL, &cb_data,
+				for_each_memory_block_cb);
+}
diff --git a/include/linux/memory.h b/include/linux/memory.h
index f26a5417ec5d..5c411365cdbe 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -119,6 +119,8 @@ extern int memory_isolate_notify(unsigned long val, v=
oid *v);
 extern struct memory_block *find_memory_block_hinted(struct mem_section =
*,
 							struct memory_block *);
 extern struct memory_block *find_memory_block(struct mem_section *);
+typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
+extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t fu=
nc);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
=20
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 888fcbdf97cf..7ab34360920b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1812,6 +1812,18 @@ static int check_and_unmap_cpu_on_node(pg_data_t *=
pgdat)
 	return 0;
 }
=20
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void =
*arg)
+{
+	int nid =3D *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid =3D=3D nid ? -EEXIST : 0;
+}
+
 /**
  * try_offline_node
  * @nid: the node ID
@@ -1824,25 +1836,24 @@ static int check_and_unmap_cpu_on_node(pg_data_t =
*pgdat)
 void try_offline_node(int nid)
 {
 	pg_data_t *pgdat =3D NODE_DATA(nid);
-	unsigned long start_pfn =3D pgdat->node_start_pfn;
-	unsigned long end_pfn =3D start_pfn + pgdat->node_spanned_pages;
-	unsigned long pfn;
-
-	for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D PAGES_PER_SECTION) {
-		unsigned long section_nr =3D pfn_to_section_nr(pfn);
-
-		if (!present_section_nr(section_nr))
-			continue;
+	int rc;
=20
-		if (pfn_to_nid(pfn) !=3D nid)
-			continue;
+	/*
+	 * If the node still spans pages (especially ZONE_DEVICE), don't
+	 * offline it. A node spans memory after move_pfn_range_to_zone(),
+	 * e.g., after the memory block was onlined.
+	 */
+	if (pgdat->node_spanned_pages)
+		return;
=20
-		/*
-		 * some memory sections of this node are not removed, and we
-		 * can't offline node now.
-		 */
+	/*
+	 * Especially offline memory blocks might not be spanned by the
+	 * node. They will get spanned by the node once they get onlined.
+	 * However, they link to the node in sysfs and can get onlined later.
+	 */
+	rc =3D for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+	if (rc)
 		return;
-	}
=20
 	if (check_and_unmap_cpu_on_node(pgdat))
 		return;
--=20
2.24.1

