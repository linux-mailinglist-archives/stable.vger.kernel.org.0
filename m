Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA731443F3
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 19:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgAUSDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 13:03:14 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33749 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729261AbgAUSDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 13:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579629792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UF/PkcANm57Eh1tDw6DcKK7aTyoekC9tB6sajNqHYk8=;
        b=Bf1Ry20Enzx97O4vMpFXFJjMt6UTAL80ypKWZQkHYV/fF+ixrhgjsHMdqxxlWBFqzHHopS
        dW3qKaDxFr3zscXa7/WvMCt+Nt56hoVkKA3QpBWCXp1zfeKuOBmr48syXrYweX5ql21jnc
        t0EWVV2w3czBihFJCGDPRX8rCpF6o2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-poM-FsptPLuducToXA4oOg-1; Tue, 21 Jan 2020 13:03:05 -0500
X-MC-Unique: poM-FsptPLuducToXA4oOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91594DBA3;
        Tue, 21 Jan 2020 18:03:03 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED92C5C1C3;
        Tue, 21 Jan 2020 18:02:58 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v2 17/24] mm/memory_hotplug: remove memory block devices before arch_remove_memory()
Date:   Tue, 21 Jan 2020 19:01:43 +0100
Message-Id: <20200121180150.37454-18-david@redhat.com>
In-Reply-To: <20200121180150.37454-1-david@redhat.com>
References: <20200121180150.37454-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4c4b7f9ba9486c565aead99a198ceeef73ae81f6 upstream.

Let's factor out removing of memory block devices, which is only
necessary for memory added via add_memory() and friends that created
memory block devices.  Remove the devices before calling
arch_remove_memory().

This finishes factoring out memory block device handling from
arch_add_memory() and arch_remove_memory().

Link: http://lkml.kernel.org/r/20190527111152.16324-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "mike.travis@hpe.com" <mike.travis@hpe.com>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c  | 37 ++++++++++++++++++-------------------
 drivers/base/node.c    | 11 ++++++-----
 include/linux/memory.h |  2 +-
 include/linux/node.h   |  6 ++----
 mm/memory_hotplug.c    |  5 +++--
 5 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index b89b9c3efa59..fdda7a6d712e 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -768,32 +768,31 @@ int create_memory_block_devices(unsigned long start=
, unsigned long size)
 	return ret;
 }
=20
-void unregister_memory_section(struct mem_section *section)
+/*
+ * Remove memory block devices for the given memory area. Start and size
+ * have to be aligned to memory block granularity. Memory block devices
+ * have to be offline.
+ */
+void remove_memory_block_devices(unsigned long start, unsigned long size=
)
 {
+	const int start_block_id =3D pfn_to_block_id(PFN_DOWN(start));
+	const int end_block_id =3D pfn_to_block_id(PFN_DOWN(start + size));
 	struct memory_block *mem;
+	int block_id;
=20
-	if (WARN_ON_ONCE(!present_section(section)))
+	if (WARN_ON_ONCE(!IS_ALIGNED(start, memory_block_size_bytes()) ||
+			 !IS_ALIGNED(size, memory_block_size_bytes())))
 		return;
=20
 	mutex_lock(&mem_sysfs_mutex);
-
-	/*
-	 * Some users of the memory hotplug do not want/need memblock to
-	 * track all sections. Skip over those.
-	 */
-	mem =3D find_memory_block(section);
-	if (!mem)
-		goto out_unlock;
-
-	unregister_mem_sect_under_nodes(mem, __section_nr(section));
-
-	mem->section_count--;
-	if (mem->section_count =3D=3D 0)
+	for (block_id =3D start_block_id; block_id !=3D end_block_id; block_id+=
+) {
+		mem =3D find_memory_block_by_id(block_id, NULL);
+		if (WARN_ON_ONCE(!mem))
+			continue;
+		mem->section_count =3D 0;
+		unregister_memory_block_under_nodes(mem);
 		unregister_memory(mem);
-	else
-		put_device(&mem->dev);
-
-out_unlock:
+	}
 	mutex_unlock(&mem_sysfs_mutex);
 }
=20
diff --git a/drivers/base/node.c b/drivers/base/node.c
index c3968e2d0a98..1211794d658c 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -453,9 +453,10 @@ int register_mem_sect_under_node(struct memory_block=
 *mem_blk, void *arg)
 	return 0;
 }
=20
-/* unregister memory section under all nodes that it spans */
-int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
-				    unsigned long phys_index)
+/*
+ * Unregister memory block device under all nodes that it spans.
+ */
+int unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 {
 	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -468,8 +469,8 @@ int unregister_mem_sect_under_nodes(struct memory_blo=
ck *mem_blk,
 		return -ENOMEM;
 	nodes_clear(*unlinked_nodes);
=20
-	sect_start_pfn =3D section_nr_to_pfn(phys_index);
-	sect_end_pfn =3D sect_start_pfn + PAGES_PER_SECTION - 1;
+	sect_start_pfn =3D section_nr_to_pfn(mem_blk->start_section_nr);
+	sect_end_pfn =3D section_nr_to_pfn(mem_blk->end_section_nr);
 	for (pfn =3D sect_start_pfn; pfn <=3D sect_end_pfn; pfn++) {
 		int nid;
=20
diff --git a/include/linux/memory.h b/include/linux/memory.h
index db3e8567f900..f26a5417ec5d 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -112,7 +112,7 @@ extern void unregister_memory_notifier(struct notifie=
r_block *nb);
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb=
);
 int create_memory_block_devices(unsigned long start, unsigned long size)=
;
-extern void unregister_memory_section(struct mem_section *);
+void remove_memory_block_devices(unsigned long start, unsigned long size=
);
 extern int memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
 extern int memory_isolate_notify(unsigned long val, void *v);
diff --git a/include/linux/node.h b/include/linux/node.h
index 257bb3d6d014..9a6db437f2d1 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -72,8 +72,7 @@ extern int register_cpu_under_node(unsigned int cpu, un=
signed int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)=
;
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
 						void *arg);
-extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
-					   unsigned long phys_index);
+extern int unregister_memory_block_under_nodes(struct memory_block *mem_=
blk);
=20
 #ifdef CONFIG_HUGETLBFS
 extern void register_hugetlbfs_with_node(node_registration_func_t doregi=
ster,
@@ -105,8 +104,7 @@ static inline int register_mem_sect_under_node(struct=
 memory_block *mem_blk,
 {
 	return 0;
 }
-static inline int unregister_mem_sect_under_nodes(struct memory_block *m=
em_blk,
-						  unsigned long phys_index)
+static inline int unregister_memory_block_under_nodes(struct memory_bloc=
k *mem_blk)
 {
 	return 0;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 414771114685..7a1c9fbf9f41 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -481,8 +481,6 @@ static void __remove_section(struct zone *zone, struc=
t mem_section *ms,
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
=20
-	unregister_memory_section(ms);
-
 	scn_nr =3D __section_nr(ms);
 	start_pfn =3D section_nr_to_pfn((unsigned long)scn_nr);
 	__remove_zone(zone, start_pfn);
@@ -1914,6 +1912,9 @@ void __ref __remove_memory(int nid, u64 start, u64 =
size)
 	memblock_free(start, size);
 	memblock_remove(start, size);
=20
+	/* remove memory block devices before removing memory */
+	remove_memory_block_devices(start, size);
+
 	arch_remove_memory(nid, start, size, NULL);
 	__release_memory_resource(start, size);
=20
--=20
2.24.1

