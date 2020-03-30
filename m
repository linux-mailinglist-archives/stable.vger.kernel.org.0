Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AF8198750
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 00:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgC3WXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 18:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgC3WXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 18:23:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77AC20658;
        Mon, 30 Mar 2020 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585606990;
        bh=dmw/8FKOTQsVeiiqyB/GilTS9oqe8wNAFTSoslDBH2M=;
        h=Date:From:To:Subject:From;
        b=vFNglqbT97BXJ2EImsfOnbiXMebjVLZKJIxqm4uVZtJXJUzyYTEtEMMZudw/DEz9O
         AXgIyebnNj4X0ExT0jVlgLRs4P4bi1KYfk0DG/8xYk+dgyB48IM1eO5mNjMFTt1ciw
         WPhzf5e2NNBk3otYTHoF5+ytJYJQH3+a8IC9uncs=
Date:   Mon, 30 Mar 2020 15:23:09 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bhe@redhat.com,
        dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com,
        rppt@linux.ibm.com, sachinp@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch removed from
 -mm tree
Message-ID: <20200330222309.5eTk9ZUJH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/sparse: fix kernel crash with pfn_section_valid check
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/sparse: fix kernel crash with pfn_section_valid check

Fix the below crash

BUG: Kernel NULL pointer dereference on read at 0x00000000
Faulting instruction address: 0xc000000000c3447c
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
CPU: 11 PID: 7519 Comm: lt-ndctl Not tainted 5.6.0-rc7-autotest #1
...
NIP [c000000000c3447c] vmemmap_populated+0x98/0xc0
LR [c000000000088354] vmemmap_free+0x144/0x320
Call Trace:
 section_deactivate+0x220/0x240
 __remove_pages+0x118/0x170
 arch_remove_memory+0x3c/0x150
 memunmap_pages+0x1cc/0x2f0
 devm_action_release+0x30/0x50
 release_nodes+0x2f8/0x3e0
 device_release_driver_internal+0x168/0x270
 unbind_store+0x130/0x170
 drv_attr_store+0x44/0x60
 sysfs_kf_write+0x68/0x80
 kernfs_fop_write+0x100/0x290
 __vfs_write+0x3c/0x70
 vfs_write+0xcc/0x240
 ksys_write+0x7c/0x140
 system_call+0x5c/0x68

The crash is due to NULL dereference at

test_bit(idx, ms->usage->subsection_map); due to ms->usage = NULL; in
pfn_section_valid()

With commit d41e2f3bd546 ("mm/hotplug: fix hot remove failure in
SPARSEMEM|!VMEMMAP case") section_mem_map is set to NULL after
depopulate_section_mem().  This was done so that pfn_page() can work
correctly with kernel config that disables SPARSEMEM_VMEMMAP.  With that
config pfn_to_page does

	__section_mem_map_addr(__sec) + __pfn;

where

static inline struct page *__section_mem_map_addr(struct mem_section *section)
{
	unsigned long map = section->section_mem_map;
	map &= SECTION_MAP_MASK;
	return (struct page *)map;
}

Now with SPASEMEM_VMEMAP enabled, mem_section->usage->subsection_map is
used to check the pfn validity (pfn_valid()).  Since section_deactivate
release mem_section->usage if a section is fully deactivated, pfn_valid()
check after a subsection_deactivate cause a kernel crash.

static inline int pfn_valid(unsigned long pfn)
{
...
	return early_section(ms) || pfn_section_valid(ms, pfn);
}

where

static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
{
	int idx = subsection_map_index(pfn);

	return test_bit(idx, ms->usage->subsection_map);
}

Avoid this by clearing SECTION_HAS_MEM_MAP when mem_section->usage is
freed.  For architectures like ppc64 where large pages are used for
vmmemap mapping (16MB), a specific vmemmap mapping can cover multiple
sections.  Hence before a vmemmap mapping page can be freed, the kernel
needs to make sure there are no valid sections within that mapping. 
Clearing the section valid bit before depopulate_section_memap enables
this.

[aneesh.kumar@linux.ibm.com: add comment]
  Link: http://lkml.kernel.org/r/20200326133235.343616-1-aneesh.kumar@linux.ibm.comLink: http://lkml.kernel.org/r/20200325031914.107660-1-aneesh.kumar@linux.ibm.com
Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/sparse.c~mm-sparse-fix-kernel-crash-with-pfn_section_valid-check
+++ a/mm/sparse.c
@@ -781,6 +781,12 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
+		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
 	if (section_is_early && memmap)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


