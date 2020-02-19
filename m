Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52B164F3A
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgBSTuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 14:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSTuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 14:50:50 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962B7207FD;
        Wed, 19 Feb 2020 19:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582141849;
        bh=/nKMx2b1v0PVXnvLf7DkKAWxLYqiPo1fkrKNAxkMrvs=;
        h=Date:From:To:Subject:From;
        b=M4xmiGBsPlL3SOLV90mNK7Z84+BebRnhVKu3LoUNBaMHVT0haZgpDnucW3YkWdvJy
         BfcLi5Hi9Hit8I9qT+vZScPLdS65oMc8SzJ6U2GYnZbd/AWFUMNEQVxK6V78spvFmO
         UzW73FtexDWK9xJg7ydcXehwdn40Td0U3XcIU4vg=
Date:   Wed, 19 Feb 2020 11:50:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.ibm.com, osalvador@suse.de, mhocko@suse.com,
        david@redhat.com, dan.j.williams@intel.com, bhe@redhat.com,
        richardw.yang@linux.intel.com
Subject:  +
 mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem.patch added to -mm
 tree
Message-ID: <20200219195049.K7dGY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: pfn_to_page is not valid yet on SPARSEMEM
has been added to the -mm tree.  Its filename is
     mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/sparsemem: pfn_to_page is not valid yet on SPARSEMEM

When we use SPARSEMEM instead of SPARSEMEM_VMEMMAP, pfn_to_page()
doesn't work before sparse_init_one_section() is called. This leads to a
crash when hotplug memory:

[   41.839170] BUG: unable to handle page fault for address: 0000000006400000
[   41.840663] #PF: supervisor write access in kernel mode
[   41.841822] #PF: error_code(0x0002) - not-present page
[   41.842970] PGD 0 P4D 0
[   41.843538] Oops: 0002 [#1] SMP PTI
[   41.844125] CPU: 3 PID: 221 Comm: kworker/u16:1 Tainted: G        W         5.5.0-next-20200205+ #343
[   41.845659] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[   41.846977] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[   41.847904] RIP: 0010:__memset+0x24/0x30
[   41.848660] Code: cc cc cc cc cc cc 0f 1f 44 00 00 49 89 f9 48 89 d1 83 e2 07 48 c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 <f3> 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 f3
[   41.851836] RSP: 0018:ffffb43ac0373c80 EFLAGS: 00010a87
[   41.852686] RAX: ffffffffffffffff RBX: ffff8a1518800000 RCX: 0000000000050000
[   41.853824] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000000006400000
[   41.854967] RBP: 0000000000140000 R08: 0000000000100000 R09: 0000000006400000
[   41.856107] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
[   41.857255] R13: 0000000000000028 R14: 0000000000000000 R15: ffff8a153ffd9280
[   41.858414] FS:  0000000000000000(0000) GS:ffff8a153ab00000(0000) knlGS:0000000000000000
[   41.859703] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.860627] CR2: 0000000006400000 CR3: 0000000136fca000 CR4: 00000000000006e0
[   41.861716] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   41.862680] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   41.863628] Call Trace:
[   41.863983]  sparse_add_section+0x1c9/0x26a
[   41.864570]  __add_pages+0xbf/0x150
[   41.865057]  add_pages+0x12/0x60
[   41.865489]  add_memory_resource+0xc8/0x210
[   41.866017]  ? wake_up_q+0xa0/0xa0
[   41.866416]  __add_memory+0x62/0xb0
[   41.866825]  acpi_memory_device_add+0x13f/0x300
[   41.867410]  acpi_bus_attach+0xf6/0x200
[   41.867890]  acpi_bus_scan+0x43/0x90
[   41.868448]  acpi_device_hotplug+0x275/0x3d0
[   41.868972]  acpi_hotplug_work_fn+0x1a/0x30
[   41.869473]  process_one_work+0x1a7/0x370
[   41.869953]  worker_thread+0x30/0x380
[   41.870396]  ? flush_rcu_work+0x30/0x30
[   41.870846]  kthread+0x112/0x130
[   41.871236]  ? kthread_create_on_node+0x60/0x60
[   41.871770]  ret_from_fork+0x35/0x40

We should use memmap as it did.

On x86 the impact is limited to x86_32 builds, or x86_64 configurations
that override the default setting for SPARSEMEM_VMEMMAP.

[dan.j.williams@intel.com: changelog update]
Link: http://lkml.kernel.org/r/20200219030454.4844-1-bhe@redhat.com
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem
+++ a/mm/sparse.c
@@ -876,7 +876,7 @@ int __meminit sparse_add_section(int nid
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(pfn_to_page(start_pfn), sizeof(struct page) * nr_pages);
+	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
 	set_section_nid(section_nr, nid);
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-sparsemem-pfn_to_page-is-not-valid-yet-on-sparsemem.patch
mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch

