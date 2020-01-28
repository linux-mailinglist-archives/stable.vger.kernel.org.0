Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AED14B20E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgA1JvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgA1JvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72SdbaJ4/IJRXbpxtNMbuMiXfQLcQVRYkn12Z1ngsTA=;
        b=aOlhcgshT6javYK6o0papfeEF8PBK5BdlMor23+dPpMxFAq1DdI4So40KqBEL8XmKTQfCY
        pt5QHGISB3qLeeB8fXlOl4wo7vJ8CXklCyxTO4BauWw6iv3Zueujl7sRt8l6cOX+5ZKSGz
        +MUQFssIfbmCzbLC2SE8PDa3epl4vRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Y9TFb9LFO4GSrZ3CmDwMxg-1; Tue, 28 Jan 2020 04:51:16 -0500
X-MC-Unique: Y9TFb9LFO4GSrZ3CmDwMxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37BBC801E67;
        Tue, 28 Jan 2020 09:51:15 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B0C560BE0;
        Tue, 28 Jan 2020 09:51:12 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 16/24] mm/memory_hotplug: create memory block devices after arch_add_memory()
Date:   Tue, 28 Jan 2020 10:50:13 +0100
Message-Id: <20200128095021.8076-17-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit db051a0dac13db24d58470d75cee0ce7c6b031a1 upstream.

Only memory to be added to the buddy and to be onlined/offlined by user
space using /sys/devices/system/memory/...  needs (and should have!)
memory block devices.

Factor out creation of memory block devices.  Create all devices after
arch_add_memory() succeeded.  We can later drop the want_memblock
parameter, because it is now effectively stale.

Only after memory block devices have been added, memory can be onlined
by user space.  This implies, that memory is not visible to user space
at all before arch_add_memory() succeeded.

While at it
 - use WARN_ON_ONCE instead of BUG_ON in moved unregister_memory()
 - introduce find_memory_block_by_id() to search via block id
 - Use find_memory_block_by_id() in init_memory_block() to catch
   duplicates

Link: http://lkml.kernel.org/r/20190527111152.16324-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "mike.travis@hpe.com" <mike.travis@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c  | 82 +++++++++++++++++++++++++++---------------
 include/linux/memory.h |  2 +-
 mm/memory_hotplug.c    | 15 ++++----
 3 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index f9818d75ac43..b89b9c3efa59 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -39,6 +39,11 @@ static inline int base_memory_block_id(int section_nr)
 	return section_nr / sections_per_block;
 }
=20
+static inline int pfn_to_block_id(unsigned long pfn)
+{
+	return base_memory_block_id(pfn_to_section_nr(pfn));
+}
+
 static int memory_subsys_online(struct device *dev);
 static int memory_subsys_offline(struct device *dev);
=20
@@ -591,10 +596,9 @@ int __weak arch_get_memory_phys_device(unsigned long=
 start_pfn)
  * A reference for the returned object is held and the reference for the
  * hinted object is released.
  */
-struct memory_block *find_memory_block_hinted(struct mem_section *sectio=
n,
-					      struct memory_block *hint)
+static struct memory_block *find_memory_block_by_id(int block_id,
+						    struct memory_block *hint)
 {
-	int block_id =3D base_memory_block_id(__section_nr(section));
 	struct device *hintdev =3D hint ? &hint->dev : NULL;
 	struct device *dev;
=20
@@ -606,6 +610,14 @@ struct memory_block *find_memory_block_hinted(struct=
 mem_section *section,
 	return to_memory_block(dev);
 }
=20
+struct memory_block *find_memory_block_hinted(struct mem_section *sectio=
n,
+					      struct memory_block *hint)
+{
+	int block_id =3D base_memory_block_id(__section_nr(section));
+
+	return find_memory_block_by_id(block_id, hint);
+}
+
 /*
  * For now, we have a linear search to go find the appropriate
  * memory_block corresponding to a particular phys_index. If
@@ -667,6 +679,11 @@ static int init_memory_block(struct memory_block **m=
emory, int block_id,
 	unsigned long start_pfn;
 	int ret =3D 0;
=20
+	mem =3D find_memory_block_by_id(block_id, NULL);
+	if (mem) {
+		put_device(&mem->dev);
+		return -EEXIST;
+	}
 	mem =3D kzalloc(sizeof(*mem), GFP_KERNEL);
 	if (!mem)
 		return -ENOMEM;
@@ -704,44 +721,53 @@ static int add_memory_block(int base_section_nr)
 	return 0;
 }
=20
+static void unregister_memory(struct memory_block *memory)
+{
+	if (WARN_ON_ONCE(memory->dev.bus !=3D &memory_subsys))
+		return;
+
+	/* drop the ref. we got via find_memory_block() */
+	put_device(&memory->dev);
+	device_unregister(&memory->dev);
+}
+
 /*
- * need an interface for the VM to add new memory regions,
- * but without onlining it.
+ * Create memory block devices for the given memory area. Start and size
+ * have to be aligned to memory block granularity. Memory block devices
+ * will be initialized as offline.
  */
-int hotplug_memory_register(int nid, struct mem_section *section)
+int create_memory_block_devices(unsigned long start, unsigned long size)
 {
-	int block_id =3D base_memory_block_id(__section_nr(section));
-	int ret =3D 0;
+	const int start_block_id =3D pfn_to_block_id(PFN_DOWN(start));
+	int end_block_id =3D pfn_to_block_id(PFN_DOWN(start + size));
 	struct memory_block *mem;
+	unsigned long block_id;
+	int ret =3D 0;
=20
-	mutex_lock(&mem_sysfs_mutex);
+	if (WARN_ON_ONCE(!IS_ALIGNED(start, memory_block_size_bytes()) ||
+			 !IS_ALIGNED(size, memory_block_size_bytes())))
+		return -EINVAL;
=20
-	mem =3D find_memory_block(section);
-	if (mem) {
-		mem->section_count++;
-		put_device(&mem->dev);
-	} else {
+	mutex_lock(&mem_sysfs_mutex);
+	for (block_id =3D start_block_id; block_id !=3D end_block_id; block_id+=
+) {
 		ret =3D init_memory_block(&mem, block_id, MEM_OFFLINE);
 		if (ret)
-			goto out;
-		mem->section_count++;
+			break;
+		mem->section_count =3D sections_per_block;
+	}
+	if (ret) {
+		end_block_id =3D block_id;
+		for (block_id =3D start_block_id; block_id !=3D end_block_id;
+		     block_id++) {
+			mem =3D find_memory_block_by_id(block_id, NULL);
+			mem->section_count =3D 0;
+			unregister_memory(mem);
+		}
 	}
-
-out:
 	mutex_unlock(&mem_sysfs_mutex);
 	return ret;
 }
=20
-static void
-unregister_memory(struct memory_block *memory)
-{
-	BUG_ON(memory->dev.bus !=3D &memory_subsys);
-
-	/* drop the ref. we got via find_memory_block() */
-	put_device(&memory->dev);
-	device_unregister(&memory->dev);
-}
-
 void unregister_memory_section(struct mem_section *section)
 {
 	struct memory_block *mem;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 474c7c60c8f2..db3e8567f900 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -111,7 +111,7 @@ extern int register_memory_notifier(struct notifier_b=
lock *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb=
);
-int hotplug_memory_register(int nid, struct mem_section *section);
+int create_memory_block_devices(unsigned long start, unsigned long size)=
;
 extern void unregister_memory_section(struct mem_section *);
 extern int memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6b5ce0bd907f..414771114685 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -256,13 +256,7 @@ static int __meminit __add_section(int nid, unsigned=
 long phys_start_pfn,
 		return -EEXIST;
=20
 	ret =3D sparse_add_one_section(nid, phys_start_pfn, altmap);
-	if (ret < 0)
-		return ret;
-
-	if (!want_memblock)
-		return 0;
-
-	return hotplug_memory_register(nid, __pfn_to_section(phys_start_pfn));
+	return ret < 0 ? ret : 0;
 }
=20
 /*
@@ -1096,6 +1090,13 @@ int __ref add_memory_resource(int nid, struct reso=
urce *res, bool online)
 	if (ret < 0)
 		goto error;
=20
+	/* create memory block devices after memory was added */
+	ret =3D create_memory_block_devices(start, size);
+	if (ret) {
+		arch_remove_memory(nid, start, size, NULL);
+		goto error;
+	}
+
 	if (new_node) {
 		/* If sysfs file of new node can't be created, cpu on the node
 		 * can't be hot-added. There is no rollback way now.
--=20
2.24.1

