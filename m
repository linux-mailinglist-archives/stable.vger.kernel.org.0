Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E568796E1
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390799AbfG2T4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387662AbfG2T4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:56:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A27DC2054F;
        Mon, 29 Jul 2019 19:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430172;
        bh=3REMcknYv3pETQW3TR1cFRdY+nSpyds+rsmZVywm0Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+j7EoxPK19h870zk8TOoK+OuG1lEF3Wekp6URHxN6uaVM3lbYQ/SJyT0RtOgCAcz
         oU/MUlbHUTzyJYKMpjQSNQp+JTy8JnnqStKxXCD6WH4qWwqFUsTURMlD0WDH2FzKOY
         Ir1q2PPrVmyuhX9Xj3bLlTp3pznUagzDMkxIR0aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 5.2 203/215] iommu/iova: Remove stale cached32_node
Date:   Mon, 29 Jul 2019 21:23:19 +0200
Message-Id: <20190729190815.215836625@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9eed17d37c77171cf5ffb95c4257f87df3cd4c8f upstream.

Since the cached32_node is allowed to be advanced above dma_32bit_pfn
(to provide a shortcut into the limited range), we need to be careful to
remove the to be freed node if it is the cached32_node.

[   48.477773] BUG: KASAN: use-after-free in __cached_rbnode_delete_update+0x68/0x110
[   48.477812] Read of size 8 at addr ffff88870fc19020 by task kworker/u8:1/37
[   48.477843]
[   48.477879] CPU: 1 PID: 37 Comm: kworker/u8:1 Tainted: G     U            5.2.0+ #735
[   48.477915] Hardware name: Intel Corporation NUC7i5BNK/NUC7i5BNB, BIOS BNKBL357.86A.0052.2017.0918.1346 09/18/2017
[   48.478047] Workqueue: i915 __i915_gem_free_work [i915]
[   48.478075] Call Trace:
[   48.478111]  dump_stack+0x5b/0x90
[   48.478137]  print_address_description+0x67/0x237
[   48.478178]  ? __cached_rbnode_delete_update+0x68/0x110
[   48.478212]  __kasan_report.cold.3+0x1c/0x38
[   48.478240]  ? __cached_rbnode_delete_update+0x68/0x110
[   48.478280]  ? __cached_rbnode_delete_update+0x68/0x110
[   48.478308]  __cached_rbnode_delete_update+0x68/0x110
[   48.478344]  private_free_iova+0x2b/0x60
[   48.478378]  iova_magazine_free_pfns+0x46/0xa0
[   48.478403]  free_iova_fast+0x277/0x340
[   48.478443]  fq_ring_free+0x15a/0x1a0
[   48.478473]  queue_iova+0x19c/0x1f0
[   48.478597]  cleanup_page_dma.isra.64+0x62/0xb0 [i915]
[   48.478712]  __gen8_ppgtt_cleanup+0x63/0x80 [i915]
[   48.478826]  __gen8_ppgtt_cleanup+0x42/0x80 [i915]
[   48.478940]  __gen8_ppgtt_clear+0x433/0x4b0 [i915]
[   48.479053]  __gen8_ppgtt_clear+0x462/0x4b0 [i915]
[   48.479081]  ? __sg_free_table+0x9e/0xf0
[   48.479116]  ? kfree+0x7f/0x150
[   48.479234]  i915_vma_unbind+0x1e2/0x240 [i915]
[   48.479352]  i915_vma_destroy+0x3a/0x280 [i915]
[   48.479465]  __i915_gem_free_objects+0xf0/0x2d0 [i915]
[   48.479579]  __i915_gem_free_work+0x41/0xa0 [i915]
[   48.479607]  process_one_work+0x495/0x710
[   48.479642]  worker_thread+0x4c7/0x6f0
[   48.479687]  ? process_one_work+0x710/0x710
[   48.479724]  kthread+0x1b2/0x1d0
[   48.479774]  ? kthread_create_worker_on_cpu+0xa0/0xa0
[   48.479820]  ret_from_fork+0x1f/0x30
[   48.479864]
[   48.479907] Allocated by task 631:
[   48.479944]  save_stack+0x19/0x80
[   48.479994]  __kasan_kmalloc.constprop.6+0xc1/0xd0
[   48.480038]  kmem_cache_alloc+0x91/0xf0
[   48.480082]  alloc_iova+0x2b/0x1e0
[   48.480125]  alloc_iova_fast+0x58/0x376
[   48.480166]  intel_alloc_iova+0x90/0xc0
[   48.480214]  intel_map_sg+0xde/0x1f0
[   48.480343]  i915_gem_gtt_prepare_pages+0xb8/0x170 [i915]
[   48.480465]  huge_get_pages+0x232/0x2b0 [i915]
[   48.480590]  ____i915_gem_object_get_pages+0x40/0xb0 [i915]
[   48.480712]  __i915_gem_object_get_pages+0x90/0xa0 [i915]
[   48.480834]  i915_gem_object_prepare_write+0x2d6/0x330 [i915]
[   48.480955]  create_test_object.isra.54+0x1a9/0x3e0 [i915]
[   48.481075]  igt_shared_ctx_exec+0x365/0x3c0 [i915]
[   48.481210]  __i915_subtests.cold.4+0x30/0x92 [i915]
[   48.481341]  __run_selftests.cold.3+0xa9/0x119 [i915]
[   48.481466]  i915_live_selftests+0x3c/0x70 [i915]
[   48.481583]  i915_pci_probe+0xe7/0x220 [i915]
[   48.481620]  pci_device_probe+0xe0/0x180
[   48.481665]  really_probe+0x163/0x4e0
[   48.481710]  device_driver_attach+0x85/0x90
[   48.481750]  __driver_attach+0xa5/0x180
[   48.481796]  bus_for_each_dev+0xda/0x130
[   48.481831]  bus_add_driver+0x205/0x2e0
[   48.481882]  driver_register+0xca/0x140
[   48.481927]  do_one_initcall+0x6c/0x1af
[   48.481970]  do_init_module+0x106/0x350
[   48.482010]  load_module+0x3d2c/0x3ea0
[   48.482058]  __do_sys_finit_module+0x110/0x180
[   48.482102]  do_syscall_64+0x62/0x1f0
[   48.482147]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   48.482190]
[   48.482224] Freed by task 37:
[   48.482273]  save_stack+0x19/0x80
[   48.482318]  __kasan_slab_free+0x12e/0x180
[   48.482363]  kmem_cache_free+0x70/0x140
[   48.482406]  __free_iova+0x1d/0x30
[   48.482445]  fq_ring_free+0x15a/0x1a0
[   48.482490]  queue_iova+0x19c/0x1f0
[   48.482624]  cleanup_page_dma.isra.64+0x62/0xb0 [i915]
[   48.482749]  __gen8_ppgtt_cleanup+0x63/0x80 [i915]
[   48.482873]  __gen8_ppgtt_cleanup+0x42/0x80 [i915]
[   48.482999]  __gen8_ppgtt_clear+0x433/0x4b0 [i915]
[   48.483123]  __gen8_ppgtt_clear+0x462/0x4b0 [i915]
[   48.483250]  i915_vma_unbind+0x1e2/0x240 [i915]
[   48.483378]  i915_vma_destroy+0x3a/0x280 [i915]
[   48.483500]  __i915_gem_free_objects+0xf0/0x2d0 [i915]
[   48.483622]  __i915_gem_free_work+0x41/0xa0 [i915]
[   48.483659]  process_one_work+0x495/0x710
[   48.483704]  worker_thread+0x4c7/0x6f0
[   48.483748]  kthread+0x1b2/0x1d0
[   48.483787]  ret_from_fork+0x1f/0x30
[   48.483831]
[   48.483868] The buggy address belongs to the object at ffff88870fc19000
[   48.483868]  which belongs to the cache iommu_iova of size 40
[   48.483920] The buggy address is located 32 bytes inside of
[   48.483920]  40-byte region [ffff88870fc19000, ffff88870fc19028)
[   48.483964] The buggy address belongs to the page:
[   48.484006] page:ffffea001c3f0600 refcount:1 mapcount:0 mapping:ffff8888181a91c0 index:0x0 compound_mapcount: 0
[   48.484045] flags: 0x8000000000010200(slab|head)
[   48.484096] raw: 8000000000010200 ffffea001c421a08 ffffea001c447e88 ffff8888181a91c0
[   48.484141] raw: 0000000000000000 0000000000120012 00000001ffffffff 0000000000000000
[   48.484188] page dumped because: kasan: bad access detected
[   48.484230]
[   48.484265] Memory state around the buggy address:
[   48.484314]  ffff88870fc18f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   48.484361]  ffff88870fc18f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   48.484406] >ffff88870fc19000: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
[   48.484451]                                ^
[   48.484494]  ffff88870fc19080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   48.484530]  ffff88870fc19100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108602
Fixes: e60aa7b53845 ("iommu/iova: Extend rbtree node caching")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: <stable@vger.kernel.org> # v4.15+
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/iova.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -137,8 +137,9 @@ __cached_rbnode_delete_update(struct iov
 	struct iova *cached_iova;
 
 	cached_iova = rb_entry(iovad->cached32_node, struct iova, node);
-	if (free->pfn_hi < iovad->dma_32bit_pfn &&
-	    free->pfn_lo >= cached_iova->pfn_lo) {
+	if (free == cached_iova ||
+	    (free->pfn_hi < iovad->dma_32bit_pfn &&
+	     free->pfn_lo >= cached_iova->pfn_lo)) {
 		iovad->cached32_node = rb_next(&free->node);
 		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
 	}


