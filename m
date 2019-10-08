Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA656CF3E1
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfJHHbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:31:12 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33369 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730112AbfJHHbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:31:12 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8C23B31E;
        Tue,  8 Oct 2019 03:31:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:31:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QheNJ8
        q8d3SMNWvq6676gVZgix+nEAk+n4uLWcZoB5E=; b=AWKr+BLV6vBxE3Wn3HdnLP
        EweB+OXwhjYXyhAeWepqn0Ht98ts+u+drA9+w5uvp1tYXLtSKToLtKvhAzPmeg80
        oelKkcKYCGgxkELnpfi+6twtvXsSS55YjDAZHbuSJXkPAB9QUJH2NFRqJcUwS42/
        x8zv8eVV5hH3b3aXeJ1wo/gx9bjIyNPitoEJsEzxJvVV8ncr46eYF++37M9VC1Wh
        hTHCpv2JxE2gbNo4EL0riWc+X5fROEb7FpLadcmWENFEpuBKgZD3TdfcSUnEmL1n
        kU4TPd1J5w/hU5nLw9+PeLxpbmAHxgpNeLad7d1Wbpvhhb+K8OphUa7KqiiEroPQ
        ==
X-ME-Sender: <xms:PzucXfEp17Y3enDh7XeGnMehbco0syhWkVKpPumyYLVLPxZlwcxwoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:PzucXYFL3-r4UHeSbosETy7oo2zSEK5kiB2UYhWJU74qiZfIfAP-MA>
    <xmx:PzucXUtBdqqQrwCvlO64D5Ro6BbOYjRQXfQXarxsXfD8Kty-JsEt6w>
    <xmx:PzucXYzETkPOHxFocG00N_NXo7BLZEh8i9U_SobB2OcZlStauj1RAQ>
    <xmx:PzucXfQAvbubB_2ZR_VNID6vkP3eiNnyV-DtaUK_NXQCg4fkr2lcgw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F00F8005C;
        Tue,  8 Oct 2019 03:31:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/pseries: Fix cpu_hotplug_lock acquisition in" failed to apply to 4.19-stable tree
To:     ego@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:31:09 +0200
Message-ID: <157051986923180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c784be435d5dae28d3b03db31753dd7a18733f0c Mon Sep 17 00:00:00 2001
From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
Date: Wed, 15 May 2019 13:15:52 +0530
Subject: [PATCH] powerpc/pseries: Fix cpu_hotplug_lock acquisition in
 resize_hpt()

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

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index e6d471058597..c363e850550e 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -34,6 +34,7 @@
 #include <linux/libfdt.h>
 #include <linux/pkeys.h>
 #include <linux/hugetlb.h>
+#include <linux/cpu.h>
 
 #include <asm/debugfs.h>
 #include <asm/processor.h>
@@ -1931,10 +1932,16 @@ static int hpt_order_get(void *data, u64 *val)
 
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
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_hpt_order, hpt_order_get, hpt_order_set, "%llu\n");
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 09bb878c21e0..4f76e5f30c97 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1413,7 +1413,10 @@ static int pseries_lpar_resize_hpt_commit(void *data)
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
@@ -1467,7 +1470,8 @@ static int pseries_lpar_resize_hpt(unsigned long shift)
 
 	t1 = ktime_get();
 
-	rc = stop_machine(pseries_lpar_resize_hpt_commit, &state, NULL);
+	rc = stop_machine_cpuslocked(pseries_lpar_resize_hpt_commit,
+				     &state, NULL);
 
 	t2 = ktime_get();
 

