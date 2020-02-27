Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A356E171C53
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388650AbgB0OLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388646AbgB0OLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A0720578;
        Thu, 27 Feb 2020 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812666;
        bh=iPUDlsPFH+FwV8NLJMv8GkVXfyIZWc1Sf8LGJLRKhek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPzQEq3rXiDAuu5tnVCC8/uwH8waJlQ3VCwvpFtyf3LQJQOT8YMXhrGrU3iF12WjN
         F2RCDhbwd8XnQ5tE1l//HyMHJ573EQTvvM3zi3/u/HK9q0wgeuPfU6/bR7ZZ2hFxBz
         gku+Ah9nd4FhF2jW7BoSOvznZLALEu9XSieKMT7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yang <richardw.yang@linux.intel.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 067/135] mm/sparsemem: pfn_to_page is not valid yet on SPARSEMEM
Date:   Thu, 27 Feb 2020 14:36:47 +0100
Message-Id: <20200227132239.331589181@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

commit 18e19f195cd888f65643a77a0c6aee8f5be6439a upstream.

When we use SPARSEMEM instead of SPARSEMEM_VMEMMAP, pfn_to_page()
doesn't work before sparse_init_one_section() is called.

This leads to a crash when hotplug memory:

    BUG: unable to handle page fault for address: 0000000006400000
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    PGD 0 P4D 0
    Oops: 0002 [#1] SMP PTI
    CPU: 3 PID: 221 Comm: kworker/u16:1 Tainted: G        W         5.5.0-next-20200205+ #343
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
    Workqueue: kacpi_hotplug acpi_hotplug_work_fn
    RIP: 0010:__memset+0x24/0x30
    Code: cc cc cc cc cc cc 0f 1f 44 00 00 49 89 f9 48 89 d1 83 e2 07 48 c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 <f3> 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 f3
    RSP: 0018:ffffb43ac0373c80 EFLAGS: 00010a87
    RAX: ffffffffffffffff RBX: ffff8a1518800000 RCX: 0000000000050000
    RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000000006400000
    RBP: 0000000000140000 R08: 0000000000100000 R09: 0000000006400000
    R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
    R13: 0000000000000028 R14: 0000000000000000 R15: ffff8a153ffd9280
    FS:  0000000000000000(0000) GS:ffff8a153ab00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000006400000 CR3: 0000000136fca000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     sparse_add_section+0x1c9/0x26a
     __add_pages+0xbf/0x150
     add_pages+0x12/0x60
     add_memory_resource+0xc8/0x210
     __add_memory+0x62/0xb0
     acpi_memory_device_add+0x13f/0x300
     acpi_bus_attach+0xf6/0x200
     acpi_bus_scan+0x43/0x90
     acpi_device_hotplug+0x275/0x3d0
     acpi_hotplug_work_fn+0x1a/0x30
     process_one_work+0x1a7/0x370
     worker_thread+0x30/0x380
     kthread+0x112/0x130
     ret_from_fork+0x35/0x40

We should use memmap as it did.

On x86 the impact is limited to x86_32 builds, or x86_64 configurations
that override the default setting for SPARSEMEM_VMEMMAP.

Other memory hotplug archs (arm64, ia64, and ppc) also default to
SPARSEMEM_VMEMMAP=y.

[dan.j.williams@intel.com: changelog update]
{rppt@linux.ibm.com: changelog update]
Link: http://lkml.kernel.org/r/20200219030454.4844-1-bhe@redhat.com
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -884,7 +884,7 @@ int __meminit sparse_add_section(int nid
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(pfn_to_page(start_pfn), sizeof(struct page) * nr_pages);
+	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
 	set_section_nid(section_nr, nid);


