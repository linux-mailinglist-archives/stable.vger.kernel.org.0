Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB00216619
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 08:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgGGF7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 01:59:48 -0400
Received: from foss.arm.com ([217.140.110.172]:50000 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgGGF7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 01:59:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF5EF1045;
        Mon,  6 Jul 2020 22:59:47 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-02.shanghai.arm.com [10.169.212.213])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E28C53F68F;
        Mon,  6 Jul 2020 22:59:42 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Chuhong Yuan <hslester96@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        Kaly Xin <Kaly.Xin@arm.com>, Jia He <justin.he@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done
Date:   Tue,  7 Jul 2020 13:59:17 +0800
Message-Id: <20200707055917.143653-4-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200707055917.143653-1-justin.he@arm.com>
References: <20200707055917.143653-1-justin.he@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
online at that time), mem_hotplug_begin/done is unpaired in such case.

Therefore a warning:
 Call Trace:
  percpu_up_write+0x33/0x40
  try_remove_memory+0x66/0x120
  ? _cond_resched+0x19/0x30
  remove_memory+0x2b/0x40
  dev_dax_kmem_remove+0x36/0x72 [kmem]
  device_release_driver_internal+0xf0/0x1c0
  device_release_driver+0x12/0x20
  bus_remove_device+0xe1/0x150
  device_del+0x17b/0x3e0
  unregister_dev_dax+0x29/0x60
  devm_action_release+0x15/0x20
  release_nodes+0x19a/0x1e0
  devres_release_all+0x3f/0x50
  device_release_driver_internal+0x100/0x1c0
  driver_detach+0x4c/0x8f
  bus_remove_driver+0x5c/0xd0
  driver_unregister+0x31/0x50
  dax_pmem_exit+0x10/0xfe0 [dax_pmem]

Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Jia He <justin.he@arm.com>
---
 mm/memory_hotplug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index da374cd3d45b..76c75a599da3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1742,7 +1742,7 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
 	 */
 	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
 	if (rc)
-		goto done;
+		return rc;
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
@@ -1766,9 +1766,8 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
 
 	try_offline_node(nid);
 
-done:
 	mem_hotplug_done();
-	return rc;
+	return 0;
 }
 
 /**
-- 
2.17.1

