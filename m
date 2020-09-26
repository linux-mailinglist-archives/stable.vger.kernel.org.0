Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B33527969F
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 06:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgIZETe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 00:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgIZETe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 00:19:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DFF320882;
        Sat, 26 Sep 2020 04:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601093972;
        bh=usSBJeQ8z9EC87empoXgaCPunCczq1s1yFugQTQwcUc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EwEPqfL7SdVssscBl3RuNWldsF01lgY1/p/j98DVLSK7VVlcnVUnzp+kE+vrDpIqW
         5TAEahOPor2r9JjyvRu+Xs944ZFmXJqpNdQBpr06+J077Lfc6Mqm40M2U5ELliRWgF
         DpLLNCfO7Jo4HNy+r3HbGvJ/ecjKoSatO2Uu0eAs=
Date:   Fri, 25 Sep 2020 21:19:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cheloha@linux.ibm.com, david@redhat.com,
        fenghua.yu@intel.com, gregkh@linuxfoundation.org,
        ldufour@linux.ibm.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, nathanl@linux.ibm.com,
        osalvador@suse.de, rafael@kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 9/9] mm: don't rely on system state to detect
 hot-plug operations
Message-ID: <20200926041931.4jyPIAVMX%akpm@linux-foundation.org>
In-Reply-To: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm: don't rely on system state to detect hot-plug operations

In register_mem_sect_under_node() the system_state's value is checked to
detect whether the call is made during boot time or during an hot-plug
operation. Unfortunately, that check against SYSTEM_BOOTING is wrong
because regular memory is registered at SYSTEM_SCHEDULING state. In
addition, memory hot-plug operation can be triggered at this system state
by the ACPI [1]. So checking against the system state is not enough.

The consequence is that on system with interleaved node's ranges like this:
 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

This can be seen on PowerPC LPAR after multiple memory hot-plug and
hot-unplug operations are done. At the next reboot the node's memory ranges
can be interleaved and since the call to link_mem_sections() is made in
topology_init() while the system is in the SYSTEM_SCHEDULING state, the
node's id is not checked, and the sections registered to multiple nodes:

$ ls -l /sys/devices/system/memory/memory21/node*
total 0
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2

In that case, the system is able to boot but if later one of theses memory
blocks is hot-unplugged and then hot-plugged, the sysfs inconsistency is
detected and this is triggering a BUG_ON():

------------[ cut here ]------------
kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
Oops: Exception in kernel mode, sig: 5 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
CFAR: c000000000846d20 IRQMASK: 0
GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
NIP [c000000000403f34] add_memory_resource+0x244/0x340
LR [c000000000403f2c] add_memory_resource+0x23c/0x340
Call Trace:
[c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
[c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
[c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
[c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
[c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
[c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
[c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
[c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
[c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
[c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
[c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
[c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
[c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
Instruction dump:
48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
---[ end trace 562fd6c109cd0fb2 ]---

This patch addresses the root cause by not relying on the system_state
value to detect whether the call is due to a hot-plug operation. An extra
parameter is added to link_mem_sections() detailing whether the operation
is due to a hot-plug operation.

[1] According to Oscar Salvador, using this qemu command line, ACPI memory
hotplug operations are raised at SYSTEM_SCHEDULING state:

$QEMU -enable-kvm -machine pc -smp 4,sockets=4,cores=1,threads=1 -cpu host -monitor pty \
        -m size=$MEM,slots=255,maxmem=4294967296k  \
        -numa node,nodeid=0,cpus=0-3,mem=512 -numa node,nodeid=1,mem=512 \
        -object memory-backend-ram,id=memdimm0,size=134217728 -device pc-dimm,node=0,memdev=memdimm0,id=dimm0,slot=0 \
        -object memory-backend-ram,id=memdimm1,size=134217728 -device pc-dimm,node=0,memdev=memdimm1,id=dimm1,slot=1 \
        -object memory-backend-ram,id=memdimm2,size=134217728 -device pc-dimm,node=0,memdev=memdimm2,id=dimm2,slot=2 \
        -object memory-backend-ram,id=memdimm3,size=134217728 -device pc-dimm,node=0,memdev=memdimm3,id=dimm3,slot=3 \
        -object memory-backend-ram,id=memdimm4,size=134217728 -device pc-dimm,node=1,memdev=memdimm4,id=dimm4,slot=4 \
        -object memory-backend-ram,id=memdimm5,size=134217728 -device pc-dimm,node=1,memdev=memdimm5,id=dimm5,slot=5 \
        -object memory-backend-ram,id=memdimm6,size=134217728 -device pc-dimm,node=1,memdev=memdimm6,id=dimm6,slot=6 \

Link: https://lkml.kernel.org/r/20200915094143.79181-3-ldufour@linux.ibm.com
Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |   85 ++++++++++++++++++++++++++---------------
 include/linux/node.h |   11 +++--
 mm/memory_hotplug.c  |    3 -
 3 files changed, 64 insertions(+), 35 deletions(-)

--- a/drivers/base/node.c~mm-dont-rely-on-system-state-to-detect-hot-plug-operations
+++ a/drivers/base/node.c
@@ -761,14 +761,36 @@ static int __ref get_nid_for_pfn(unsigne
 	return pfn_to_nid(pfn);
 }
 
+static int do_register_memory_block_under_node(int nid,
+					       struct memory_block *mem_blk)
+{
+	int ret;
+
+	/*
+	 * If this memory block spans multiple nodes, we only indicate
+	 * the last processed node.
+	 */
+	mem_blk->nid = nid;
+
+	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
+				       &mem_blk->dev.kobj,
+				       kobject_name(&mem_blk->dev.kobj));
+	if (ret)
+		return ret;
+
+	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+				&node_devices[nid]->dev.kobj,
+				kobject_name(&node_devices[nid]->dev.kobj));
+}
+
 /* register memory section under specified node if it spans that node */
-static int register_mem_sect_under_node(struct memory_block *mem_blk,
-					 void *arg)
+static int register_mem_block_under_node_early(struct memory_block *mem_blk,
+					       void *arg)
 {
 	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
 	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
 	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
-	int ret, nid = *(int *)arg;
+	int nid = *(int *)arg;
 	unsigned long pfn;
 
 	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
@@ -785,39 +807,34 @@ static int register_mem_sect_under_node(
 		}
 
 		/*
-		 * We need to check if page belongs to nid only for the boot
-		 * case, during hotplug we know that all pages in the memory
-		 * block belong to the same node.
-		 */
-		if (system_state == SYSTEM_BOOTING) {
-			page_nid = get_nid_for_pfn(pfn);
-			if (page_nid < 0)
-				continue;
-			if (page_nid != nid)
-				continue;
-		}
-
-		/*
-		 * If this memory block spans multiple nodes, we only indicate
-		 * the last processed node.
+		 * We need to check if page belongs to nid only at the boot
+		 * case because node's ranges can be interleaved.
 		 */
-		mem_blk->nid = nid;
-
-		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
-					&mem_blk->dev.kobj,
-					kobject_name(&mem_blk->dev.kobj));
-		if (ret)
-			return ret;
+		page_nid = get_nid_for_pfn(pfn);
+		if (page_nid < 0)
+			continue;
+		if (page_nid != nid)
+			continue;
 
-		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
-				&node_devices[nid]->dev.kobj,
-				kobject_name(&node_devices[nid]->dev.kobj));
+		return do_register_memory_block_under_node(nid, mem_blk);
 	}
 	/* mem section does not span the specified node */
 	return 0;
 }
 
 /*
+ * During hotplug we know that all pages in the memory block belong to the same
+ * node.
+ */
+static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
+						 void *arg)
+{
+	int nid = *(int *)arg;
+
+	return do_register_memory_block_under_node(nid, mem_blk);
+}
+
+/*
  * Unregister a memory block device under the node it spans. Memory blocks
  * with multiple nodes cannot be offlined and therefore also never be removed.
  */
@@ -832,11 +849,19 @@ void unregister_memory_block_under_nodes
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
+int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		      enum meminit_context context)
 {
+	walk_memory_blocks_func_t func;
+
+	if (context == MEMINIT_HOTPLUG)
+		func = register_mem_block_under_node_hotplug;
+	else
+		func = register_mem_block_under_node_early;
+
 	return walk_memory_blocks(PFN_PHYS(start_pfn),
 				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
-				  register_mem_sect_under_node);
+				  func);
 }
 
 #ifdef CONFIG_HUGETLBFS
--- a/include/linux/node.h~mm-dont-rely-on-system-state-to-detect-hot-plug-operations
+++ a/include/linux/node.h
@@ -99,11 +99,13 @@ extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
-extern int link_mem_sections(int nid, unsigned long start_pfn,
-			     unsigned long end_pfn);
+int link_mem_sections(int nid, unsigned long start_pfn,
+		      unsigned long end_pfn,
+		      enum meminit_context context);
 #else
 static inline int link_mem_sections(int nid, unsigned long start_pfn,
-				    unsigned long end_pfn)
+				    unsigned long end_pfn,
+				    enum meminit_context context)
 {
 	return 0;
 }
@@ -128,7 +130,8 @@ static inline int register_one_node(int
 		if (error)
 			return error;
 		/* link memory sections under this node */
-		error = link_mem_sections(nid, start_pfn, end_pfn);
+		error = link_mem_sections(nid, start_pfn, end_pfn,
+					  MEMINIT_EARLY);
 	}
 
 	return error;
--- a/mm/memory_hotplug.c~mm-dont-rely-on-system-state-to-detect-hot-plug-operations
+++ a/mm/memory_hotplug.c
@@ -1080,7 +1080,8 @@ int __ref add_memory_resource(int nid, s
 	}
 
 	/* link memory sections under this node.*/
-	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1));
+	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
+				MEMINIT_HOTPLUG);
 	BUG_ON(ret);
 
 	/* create new memmap entry */
_
