Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7725514B211
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgA1Jvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57498 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgA1Jvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTtwNHdS2IIpvaTdfYSk+ONIaqPDsbPlM+ndeM14IWo=;
        b=BMj8Saf4mqTziMryhTRV0mCXHDLnRFYC+JtSmrfbHq1JAZWFUHwPQl87PIwrn3yilSoZyw
        Gl2ijPpJvodUAKyo30mEOczL8xC6QD2yPsQcGeqjFB6nUlALlp/p5LpvBkAR1uMbSC1G5v
        +vXDLV9ym0qZp83U+DSQmjRjxfU2fd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-_mzcxih2NNGBpapVpTVJaA-1; Tue, 28 Jan 2020 04:51:31 -0500
X-MC-Unique: _mzcxih2NNGBpapVpTVJaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F1A7800D48;
        Tue, 28 Jan 2020 09:51:30 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E9B360BE0;
        Tue, 28 Jan 2020 09:51:22 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 18/24] mm/memory_hotplug: make unregister_memory_block_under_nodes() never fail
Date:   Tue, 28 Jan 2020 10:50:15 +0100
Message-Id: <20200128095021.8076-19-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a31b264c2b415b29660da0bc2ba291a98629ce51 upstream.

We really don't want anything during memory hotunplug to fail.  We
always pass a valid memory block device, that check can go.  Avoid
allocating memory and eventually failing.  As we are always called under
lock, we can use a static piece of memory.  This avoids having to put
the structure onto the stack, having to guess about the stack size of
callers.

Patch inspired by a patch from Oscar Salvador.

In the future, there might be no need to iterate over nodes at all.
mem->nid should tell us exactly what to remove.  Memory block devices
with mixed nodes (added during boot) should properly fenced off and
never removed.

Link: http://lkml.kernel.org/r/20190527111152.16324-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "mike.travis@hpe.com" <mike.travis@hpe.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
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
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/node.c  | 18 +++++-------------
 include/linux/node.h |  5 ++---
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 1211794d658c..bdff237f4167 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -455,20 +455,14 @@ int register_mem_sect_under_node(struct memory_bloc=
k *mem_blk, void *arg)
=20
 /*
  * Unregister memory block device under all nodes that it spans.
+ * Has to be called with mem_sysfs_mutex held (due to unlinked_nodes).
  */
-int unregister_memory_block_under_nodes(struct memory_block *mem_blk)
+void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 {
-	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
+	static nodemask_t unlinked_nodes;
=20
-	if (!mem_blk) {
-		NODEMASK_FREE(unlinked_nodes);
-		return -EFAULT;
-	}
-	if (!unlinked_nodes)
-		return -ENOMEM;
-	nodes_clear(*unlinked_nodes);
-
+	nodes_clear(unlinked_nodes);
 	sect_start_pfn =3D section_nr_to_pfn(mem_blk->start_section_nr);
 	sect_end_pfn =3D section_nr_to_pfn(mem_blk->end_section_nr);
 	for (pfn =3D sect_start_pfn; pfn <=3D sect_end_pfn; pfn++) {
@@ -479,15 +473,13 @@ int unregister_memory_block_under_nodes(struct memo=
ry_block *mem_blk)
 			continue;
 		if (!node_online(nid))
 			continue;
-		if (node_test_and_set(nid, *unlinked_nodes))
+		if (node_test_and_set(nid, unlinked_nodes))
 			continue;
 		sysfs_remove_link(&node_devices[nid]->dev.kobj,
 			 kobject_name(&mem_blk->dev.kobj));
 		sysfs_remove_link(&mem_blk->dev.kobj,
 			 kobject_name(&node_devices[nid]->dev.kobj));
 	}
-	NODEMASK_FREE(unlinked_nodes);
-	return 0;
 }
=20
 int link_mem_sections(int nid, unsigned long start_pfn, unsigned long en=
d_pfn)
diff --git a/include/linux/node.h b/include/linux/node.h
index 9a6db437f2d1..708939bae9aa 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -72,7 +72,7 @@ extern int register_cpu_under_node(unsigned int cpu, un=
signed int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)=
;
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
 						void *arg);
-extern int unregister_memory_block_under_nodes(struct memory_block *mem_=
blk);
+extern void unregister_memory_block_under_nodes(struct memory_block *mem=
_blk);
=20
 #ifdef CONFIG_HUGETLBFS
 extern void register_hugetlbfs_with_node(node_registration_func_t doregi=
ster,
@@ -104,9 +104,8 @@ static inline int register_mem_sect_under_node(struct=
 memory_block *mem_blk,
 {
 	return 0;
 }
-static inline int unregister_memory_block_under_nodes(struct memory_bloc=
k *mem_blk)
+static inline void unregister_memory_block_under_nodes(struct memory_blo=
ck *mem_blk)
 {
-	return 0;
 }
=20
 static inline void register_hugetlbfs_with_node(node_registration_func_t=
 reg,
--=20
2.24.1

