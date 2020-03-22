Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1153B18E5C2
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgCVBWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 21:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B68C20757;
        Sun, 22 Mar 2020 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584840134;
        bh=wxm93Vm+4qrFdWvilJt/Pg/Fhx76X//hnCX8KhDSgDw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AgAD4p4m7Rib0TctHxKmYFN1SWbLGb8Boi9TndmYjtCEeh5+mUSx2qBYP8deUyjCM
         +8upMLkjOytTf9bEokl5bLtJEYt1IN8HcdSqpDbzADZG5BiFZaRhEzxB8kLacQrGa7
         7PYI8L7ZRD9bvGqRRRL/++YtX2nAlT7/Giv+9RM0=
Date:   Sat, 21 Mar 2020 18:22:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        richardw.yang@linux.intel.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 02/10] mm/hotplug: fix hot remove failure in
 SPARSEMEM|!VMEMMAP case
Message-ID: <20200322012213.bAcH5rYaA%akpm@linux-foundation.org>
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>
Subject: mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case

In section_deactivate(), pfn_to_page() doesn't work any more after
ms->section_mem_map is resetting to NULL in SPARSEMEM|!VMEMMAP case.  It
caused hot remove failure:

kernel BUG at mm/page_alloc.c:4806!
invalid opcode: 0000 [#1] SMP PTI
CPU: 3 PID: 8 Comm: kworker/u16:0 Tainted: G        W         5.5.0-next-20200205+ #340
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
RIP: 0010:free_pages+0x85/0xa0
Call Trace:
 __remove_pages+0x99/0xc0
 arch_remove_memory+0x23/0x4d
 try_remove_memory+0xc8/0x130
 ? walk_memory_blocks+0x72/0xa0
 __remove_memory+0xa/0x11
 acpi_memory_device_remove+0x72/0x100
 acpi_bus_trim+0x55/0x90
 acpi_device_hotplug+0x2eb/0x3d0
 acpi_hotplug_work_fn+0x1a/0x30
 process_one_work+0x1a7/0x370
 worker_thread+0x30/0x380
 ? flush_rcu_work+0x30/0x30
 kthread+0x112/0x130
 ? kthread_create_on_node+0x60/0x60
 ret_from_fork+0x35/0x40

Let's move the ->section_mem_map resetting after
depopulate_section_memmap() to fix it.

[akpm@linux-foundation.org: remove unneeded initialization, per David]
Link: http://lkml.kernel.org/r/20200307084229.28251-2-bhe@redhat.com
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/sparse.c~mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case
+++ a/mm/sparse.c
@@ -734,6 +734,7 @@ static void section_deactivate(unsigned
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
 	struct page *memmap = NULL;
+	bool empty;
 	unsigned long *subsection_map = ms->usage
 		? &ms->usage->subsection_map[0] : NULL;
 
@@ -764,7 +765,8 @@ static void section_deactivate(unsigned
 	 * For 2/ and 3/ the SPARSEMEM_VMEMMAP={y,n} cases are unified
 	 */
 	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
-	if (bitmap_empty(subsection_map, SUBSECTIONS_PER_SECTION)) {
+	empty = bitmap_empty(subsection_map, SUBSECTIONS_PER_SECTION);
+	if (empty) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
 		/*
@@ -779,13 +781,15 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		ms->section_mem_map = (unsigned long)NULL;
 	}
 
 	if (section_is_early && memmap)
 		free_map_bootmem(memmap);
 	else
 		depopulate_section_memmap(pfn, nr_pages, altmap);
+
+	if (empty)
+		ms->section_mem_map = (unsigned long)NULL;
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
_
