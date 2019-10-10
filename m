Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF379D249A
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388540AbfJJIsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389576AbfJJIr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19793208C3;
        Thu, 10 Oct 2019 08:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697277;
        bh=3bVwMOhQgfQowCqxLpYbzvOzjlXR/c/34+yYfBGFIUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW/p2H9FxXGC6yG0Ve04T2LpQsDDLENdqjmJslxWnfuQKmZFWZHG9RzjLU5dxnM2K
         pyQMQdJ1EPRQt1WJCeuujI3eQuYLgEQOradm+vU1U17O34kvIqvX7HQQ1Qr34/aRay
         lDq0BEHQADfX7mVneMn558OS7oXzwRyPvZcwOsTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/114] powerpc/pseries: Fix cpu_hotplug_lock acquisition in resize_hpt()
Date:   Thu, 10 Oct 2019 10:36:28 +0200
Message-Id: <20191010083612.288945867@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

[ Upstream commit c784be435d5dae28d3b03db31753dd7a18733f0c ]

The calls to arch_add_memory()/arch_remove_memory() are always made
with the read-side cpu_hotplug_lock acquired via memory_hotplug_begin().
On pSeries, arch_add_memory()/arch_remove_memory() eventually call
resize_hpt() which in turn calls stop_machine() which acquires the
read-side cpu_hotplug_lock again, thereby resulting in the recursive
acquisition of this lock.

In the absence of CONFIG_PROVE_LOCKING, we hadn't observed a system
lockup during a memory hotplug operation because cpus_read_lock() is a
per-cpu rwsem read, which, in the fast-path (in the absence of the
writer, which in our case is a CPU-hotplug operation) simply
increments the read_count on the semaphore. Thus a recursive read in
the fast-path doesn't cause any problems.

However, we can hit this problem in practice if there is a concurrent
CPU-Hotplug operation in progress which is waiting to acquire the
write-side of the lock. This will cause the second recursive read to
block until the writer finishes. While the writer is blocked since the
first read holds the lock. Thus both the reader as well as the writers
fail to make any progress thereby blocking both CPU-Hotplug as well as
Memory Hotplug operations.

Memory-Hotplug				CPU-Hotplug
CPU 0					CPU 1
------                                  ------

1. down_read(cpu_hotplug_lock.rw_sem)
   [memory_hotplug_begin]
					2. down_write(cpu_hotplug_lock.rw_sem)
					[cpu_up/cpu_down]
3. down_read(cpu_hotplug_lock.rw_sem)
   [stop_machine()]

Lockdep complains as follows in these code-paths.

 swapper/0/1 is trying to acquire lock:
 (____ptrval____) (cpu_hotplug_lock.rw_sem){++++}, at: stop_machine+0x2c/0x60

but task is already holding lock:
(____ptrval____) (cpu_hotplug_lock.rw_sem){++++}, at: mem_hotplug_begin+0x20/0x50

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(cpu_hotplug_lock.rw_sem);
   lock(cpu_hotplug_lock.rw_sem);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 3 locks held by swapper/0/1:
  #0: (____ptrval____) (&dev->mutex){....}, at: __driver_attach+0x12c/0x1b0
  #1: (____ptrval____) (cpu_hotplug_lock.rw_sem){++++}, at: mem_hotplug_begin+0x20/0x50
  #2: (____ptrval____) (mem_hotplug_lock.rw_sem){++++}, at: percpu_down_write+0x54/0x1a0

stack backtrace:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.0.0-rc5-58373-gbc99402235f3-dirty #166
 Call Trace:
   dump_stack+0xe8/0x164 (unreliable)
   __lock_acquire+0x1110/0x1c70
   lock_acquire+0x240/0x290
   cpus_read_lock+0x64/0xf0
   stop_machine+0x2c/0x60
   pseries_lpar_resize_hpt+0x19c/0x2c0
   resize_hpt_for_hotplug+0x70/0xd0
   arch_add_memory+0x58/0xfc
   devm_memremap_pages+0x5e8/0x8f0
   pmem_attach_disk+0x764/0x830
   nvdimm_bus_probe+0x118/0x240
   really_probe+0x230/0x4b0
   driver_probe_device+0x16c/0x1e0
   __driver_attach+0x148/0x1b0
   bus_for_each_dev+0x90/0x130
   driver_attach+0x34/0x50
   bus_add_driver+0x1a8/0x360
   driver_register+0x108/0x170
   __nd_driver_register+0xd0/0xf0
   nd_pmem_driver_init+0x34/0x48
   do_one_initcall+0x1e0/0x45c
   kernel_init_freeable+0x540/0x64c
   kernel_init+0x2c/0x160
   ret_from_kernel_thread+0x5c/0x68

Fix this issue by
  1) Requiring all the calls to pseries_lpar_resize_hpt() be made
     with cpu_hotplug_lock held.

  2) In pseries_lpar_resize_hpt() invoke stop_machine_cpuslocked()
     as a consequence of 1)

  3) To satisfy 1), in hpt_order_set(), call mmu_hash_ops.resize_hpt()
     with cpu_hotplug_lock held.

Fixes: dbcf929c0062 ("powerpc/pseries: Add support for hash table resizing")
Cc: stable@vger.kernel.org # v4.11+
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1557906352-29048-1-git-send-email-ego@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/hash_utils_64.c       | 9 ++++++++-
 arch/powerpc/platforms/pseries/lpar.c | 8 ++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 29fd8940867e5..b1007e9a31ba7 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -37,6 +37,7 @@
 #include <linux/context_tracking.h>
 #include <linux/libfdt.h>
 #include <linux/pkeys.h>
+#include <linux/cpu.h>
 
 #include <asm/debugfs.h>
 #include <asm/processor.h>
@@ -1891,10 +1892,16 @@ static int hpt_order_get(void *data, u64 *val)
 
 static int hpt_order_set(void *data, u64 val)
 {
+	int ret;
+
 	if (!mmu_hash_ops.resize_hpt)
 		return -ENODEV;
 
-	return mmu_hash_ops.resize_hpt(val);
+	cpus_read_lock();
+	ret = mmu_hash_ops.resize_hpt(val);
+	cpus_read_unlock();
+
+	return ret;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_hpt_order, hpt_order_get, hpt_order_set, "%llu\n");
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 9e52b686a8fa4..ea602f7f97ce1 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -647,7 +647,10 @@ static int pseries_lpar_resize_hpt_commit(void *data)
 	return 0;
 }
 
-/* Must be called in user context */
+/*
+ * Must be called in process context. The caller must hold the
+ * cpus_lock.
+ */
 static int pseries_lpar_resize_hpt(unsigned long shift)
 {
 	struct hpt_resize_state state = {
@@ -699,7 +702,8 @@ static int pseries_lpar_resize_hpt(unsigned long shift)
 
 	t1 = ktime_get();
 
-	rc = stop_machine(pseries_lpar_resize_hpt_commit, &state, NULL);
+	rc = stop_machine_cpuslocked(pseries_lpar_resize_hpt_commit,
+				     &state, NULL);
 
 	t2 = ktime_get();
 
-- 
2.20.1



