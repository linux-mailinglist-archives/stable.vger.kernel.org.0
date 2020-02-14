Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B40B15F19D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731540AbgBNPya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731005AbgBNPy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EF6824682;
        Fri, 14 Feb 2020 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695667;
        bh=uUQSXsPDd+4BHJdQzlIVjHWOL7psttXaEA3OsvqvNWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ft8CrLK0X9eEpSB345RsA9yyGus8FH+Z4WFv1dEvdzOPbeiPpT6fHXQXwDFKR/tye
         gnCDk+2owXrE7Jt2X2Ls4D0zKEO1b5vJ9oIzUBltNODJKgiKYHSsPe+YvMB2NcAEWH
         KM5kxpNycX5JeYGo3en9lDAdL086dFJqcDJQdGmA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.5 256/542] iommu/iova: Silence warnings under memory pressure
Date:   Fri, 14 Feb 2020 10:44:08 -0500
Message-Id: <20200214154854.6746-256-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 944c9175397476199d4dd1028d87ddc582c35ee8 ]

When running heavy memory pressure workloads, this 5+ old system is
throwing endless warnings below because disk IO is too slow to recover
from swapping. Since the volume from alloc_iova_fast() could be large,
once it calls printk(), it will trigger disk IO (writing to the log
files) and pending softirqs which could cause an infinite loop and make
no progress for days by the ongoimng memory reclaim. This is the counter
part for Intel where the AMD part has already been merged. See the
commit 3d708895325b ("iommu/amd: Silence warnings under memory
pressure"). Since the allocation failure will be reported in
intel_alloc_iova(), so just call dev_err_once() there because even the
"ratelimited" is too much, and silence the one in alloc_iova_mem() to
avoid the expensive warn_alloc().

 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 slab_out_of_memory: 66 callbacks suppressed
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
   cache: iommu_iova, object size: 40, buffer size: 448, default order:
0, min order: 0
   node 0: slabs: 1822, objs: 16398, free: 0
   node 1: slabs: 2051, objs: 18459, free: 31
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
   cache: iommu_iova, object size: 40, buffer size: 448, default order:
0, min order: 0
   node 0: slabs: 1822, objs: 16398, free: 0
   node 1: slabs: 2051, objs: 18459, free: 31
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
   cache: iommu_iova, object size: 40, buffer size: 448, default order:
0, min order: 0
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   node 0: slabs: 697, objs: 4182, free: 0
   node 0: slabs: 697, objs: 4182, free: 0
   node 0: slabs: 697, objs: 4182, free: 0
   node 0: slabs: 697, objs: 4182, free: 0
   node 1: slabs: 381, objs: 2286, free: 27
   node 1: slabs: 381, objs: 2286, free: 27
   node 1: slabs: 381, objs: 2286, free: 27
   node 1: slabs: 381, objs: 2286, free: 27
   node 0: slabs: 1822, objs: 16398, free: 0
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   node 1: slabs: 2051, objs: 18459, free: 31
   node 0: slabs: 697, objs: 4182, free: 0
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
   node 1: slabs: 381, objs: 2286, free: 27
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   node 0: slabs: 697, objs: 4182, free: 0
   node 1: slabs: 381, objs: 2286, free: 27
 hpsa 0000:03:00.0: DMAR: Allocating 1-page iova failed
 warn_alloc: 96 callbacks suppressed
 kworker/11:1H: page allocation failure: order:0,
mode:0xa20(GFP_ATOMIC), nodemask=(null),cpuset=/,mems_allowed=0-1
 CPU: 11 PID: 1642 Comm: kworker/11:1H Tainted: G    B
 Hardware name: HP ProLiant XL420 Gen9/ProLiant XL420 Gen9, BIOS U19
12/27/2015
 Workqueue: kblockd blk_mq_run_work_fn
 Call Trace:
  dump_stack+0xa0/0xea
  warn_alloc.cold.94+0x8a/0x12d
  __alloc_pages_slowpath+0x1750/0x1870
  __alloc_pages_nodemask+0x58a/0x710
  alloc_pages_current+0x9c/0x110
  alloc_slab_page+0xc9/0x760
  allocate_slab+0x48f/0x5d0
  new_slab+0x46/0x70
  ___slab_alloc+0x4ab/0x7b0
  __slab_alloc+0x43/0x70
  kmem_cache_alloc+0x2dd/0x450
 SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
  alloc_iova+0x33/0x210
   cache: skbuff_head_cache, object size: 208, buffer size: 640, default
order: 0, min order: 0
   node 0: slabs: 697, objs: 4182, free: 0
  alloc_iova_fast+0x62/0x3d1
   node 1: slabs: 381, objs: 2286, free: 27
  intel_alloc_iova+0xce/0xe0
  intel_map_sg+0xed/0x410
  scsi_dma_map+0xd7/0x160
  scsi_queue_rq+0xbf7/0x1310
  blk_mq_dispatch_rq_list+0x4d9/0xbc0
  blk_mq_sched_dispatch_requests+0x24a/0x300
  __blk_mq_run_hw_queue+0x156/0x230
  blk_mq_run_work_fn+0x3b/0x40
  process_one_work+0x579/0xb90
  worker_thread+0x63/0x5b0
  kthread+0x1e6/0x210
  ret_from_fork+0x3a/0x50
 Mem-Info:
 active_anon:2422723 inactive_anon:361971 isolated_anon:34403
  active_file:2285 inactive_file:1838 isolated_file:0
  unevictable:0 dirty:1 writeback:5 unstable:0
  slab_reclaimable:13972 slab_unreclaimable:453879
  mapped:2380 shmem:154 pagetables:6948 bounce:0
  free:19133 free_pcp:7363 free_cma:0

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 3 ++-
 drivers/iommu/iova.c        | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 932267f49f9a8..541896ab3d086 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3406,7 +3406,8 @@ static unsigned long intel_alloc_iova(struct device *dev,
 	iova_pfn = alloc_iova_fast(&domain->iovad, nrpages,
 				   IOVA_PFN(dma_mask), true);
 	if (unlikely(!iova_pfn)) {
-		dev_err(dev, "Allocating %ld-page iova failed", nrpages);
+		dev_err_once(dev, "Allocating %ld-page iova failed\n",
+			     nrpages);
 		return 0;
 	}
 
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index c7a914b9bbbc4..0e6a9536eca62 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -233,7 +233,7 @@ static DEFINE_MUTEX(iova_cache_mutex);
 
 struct iova *alloc_iova_mem(void)
 {
-	return kmem_cache_zalloc(iova_cache, GFP_ATOMIC);
+	return kmem_cache_zalloc(iova_cache, GFP_ATOMIC | __GFP_NOWARN);
 }
 EXPORT_SYMBOL(alloc_iova_mem);
 
-- 
2.20.1

