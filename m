Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1154B3207
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 01:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354409AbiBLAcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 19:32:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiBLAci (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 19:32:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3810FD81;
        Fri, 11 Feb 2022 16:32:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B24B0B82DFD;
        Sat, 12 Feb 2022 00:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41860C340EB;
        Sat, 12 Feb 2022 00:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625953;
        bh=pFynoFBRGjzEmNdcVAWTCxiCJ95mGPFynRNKw3+luQQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Jk5G3x0c10lAzBxHNDcBoTnW21E8gyjI6pLrDNKPVh6WcdlCT/P9IlS2lmltBVoU+
         GYXgI64gMQ0gmRnaaVJk5V2EmPLj4Q0kaE++Ck7B2LSMUmkQHyTQaBx4DR2kyD04JY
         1dFmz2+Ri0QdomXM5zj2NVrFKB8HBtbhyarmoNCo=
Date:   Fri, 11 Feb 2022 16:32:32 -0800
To:     tj@kernel.org, stable@vger.kernel.org, shakeelb@google.com,
        longman@redhat.com, jeremy.linton@arm.com, hannes@cmpxchg.org,
        egorenar@linux.ibm.com, guro@fb.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 4/5] mm: memcg: synchronize objcg lists with a dedicated spinlock
Message-Id: <20220212003233.41860C340EB@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: synchronize objcg lists with a dedicated spinlock

Alexander reported a circular lock dependency revealed by the mmap1 ltp
test:

  LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
          WARNING: possible circular locking dependency detected
          5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1 Not tainted
          ------------------------------------------------------
          mmap1/202299 is trying to acquire lock:
          00000001892c0188 (css_set_lock){..-.}-{2:2}, at: obj_cgroup_release+0x4a/0xe0
          but task is already holding lock:
          00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
          which lock already depends on the new lock.
          the existing dependency chain (in reverse order) is:
          -> #1 (&sighand->siglock){-.-.}-{2:2}:
                 __lock_acquire+0x604/0xbd8
                 lock_acquire.part.0+0xe2/0x238
                 lock_acquire+0xb0/0x200
                 _raw_spin_lock_irqsave+0x6a/0xd8
                 __lock_task_sighand+0x90/0x190
                 cgroup_freeze_task+0x2e/0x90
                 cgroup_migrate_execute+0x11c/0x608
                 cgroup_update_dfl_csses+0x246/0x270
                 cgroup_subtree_control_write+0x238/0x518
                 kernfs_fop_write_iter+0x13e/0x1e0
                 new_sync_write+0x100/0x190
                 vfs_write+0x22c/0x2d8
                 ksys_write+0x6c/0xf8
                 __do_syscall+0x1da/0x208
                 system_call+0x82/0xb0
          -> #0 (css_set_lock){..-.}-{2:2}:
                 check_prev_add+0xe0/0xed8
                 validate_chain+0x736/0xb20
                 __lock_acquire+0x604/0xbd8
                 lock_acquire.part.0+0xe2/0x238
                 lock_acquire+0xb0/0x200
                 _raw_spin_lock_irqsave+0x6a/0xd8
                 obj_cgroup_release+0x4a/0xe0
                 percpu_ref_put_many.constprop.0+0x150/0x168
                 drain_obj_stock+0x94/0xe8
                 refill_obj_stock+0x94/0x278
                 obj_cgroup_charge+0x164/0x1d8
                 kmem_cache_alloc+0xac/0x528
                 __sigqueue_alloc+0x150/0x308
                 __send_signal+0x260/0x550
                 send_signal+0x7e/0x348
                 force_sig_info_to_task+0x104/0x180
                 force_sig_fault+0x48/0x58
                 __do_pgm_check+0x120/0x1f0
                 pgm_check_handler+0x11e/0x180
          other info that might help us debug this:
           Possible unsafe locking scenario:
                 CPU0                    CPU1
                 ----                    ----
            lock(&sighand->siglock);
                                         lock(css_set_lock);
                                         lock(&sighand->siglock);
            lock(css_set_lock);
           *** DEADLOCK ***
          2 locks held by mmap1/202299:
           #0: 00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
           #1: 00000001892ad560 (rcu_read_lock){....}-{1:2}, at: percpu_ref_put_many.constprop.0+0x0/0x168
          stack backtrace:
          CPU: 15 PID: 202299 Comm: mmap1 Not tainted 5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1
          Hardware name: IBM 3906 M04 704 (LPAR)
          Call Trace:
           [<00000001888aacfe>] dump_stack_lvl+0x76/0x98
           [<0000000187c6d7be>] check_noncircular+0x136/0x158
           [<0000000187c6e888>] check_prev_add+0xe0/0xed8
           [<0000000187c6fdb6>] validate_chain+0x736/0xb20
           [<0000000187c71e54>] __lock_acquire+0x604/0xbd8
           [<0000000187c7301a>] lock_acquire.part.0+0xe2/0x238
           [<0000000187c73220>] lock_acquire+0xb0/0x200
           [<00000001888bf9aa>] _raw_spin_lock_irqsave+0x6a/0xd8
           [<0000000187ef6862>] obj_cgroup_release+0x4a/0xe0
           [<0000000187ef6498>] percpu_ref_put_many.constprop.0+0x150/0x168
           [<0000000187ef9674>] drain_obj_stock+0x94/0xe8
           [<0000000187efa464>] refill_obj_stock+0x94/0x278
           [<0000000187eff55c>] obj_cgroup_charge+0x164/0x1d8
           [<0000000187ed8aa4>] kmem_cache_alloc+0xac/0x528
           [<0000000187bf2eb8>] __sigqueue_alloc+0x150/0x308
           [<0000000187bf4210>] __send_signal+0x260/0x550
           [<0000000187bf5f06>] send_signal+0x7e/0x348
           [<0000000187bf7274>] force_sig_info_to_task+0x104/0x180
           [<0000000187bf7758>] force_sig_fault+0x48/0x58
           [<00000001888ae160>] __do_pgm_check+0x120/0x1f0
           [<00000001888c0cde>] pgm_check_handler+0x11e/0x180
          INFO: lockdep is turned off.

In this example a slab allocation from __send_signal() caused a refilling
and draining of a percpu objcg stock, resulted in a releasing of another
non-related objcg.  Objcg release path requires taking the css_set_lock,
which is used to synchronize objcg lists.

This can create a circular dependency with the sighandler lock, which is
taken with the locked css_set_lock by the freezer code (to freeze a task).

In general it seems that using css_set_lock to synchronize objcg lists
makes any slab allocations and deallocation with the locked css_set_lock
and any intervened locks risky.

To fix the problem and make the code more robust let's stop using
css_set_lock to synchronize objcg lists and use a new dedicated spinlock
instead.

Link: https://lkml.kernel.org/r/Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~mm-memcg-synchronize-objcg-lists-with-a-dedicated-spinlock
+++ a/include/linux/memcontrol.h
@@ -219,7 +219,7 @@ struct obj_cgroup {
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
 	union {
-		struct list_head list;
+		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
 };
@@ -315,7 +315,8 @@ struct mem_cgroup {
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
 	struct obj_cgroup __rcu *objcg;
-	struct list_head objcg_list; /* list of inherited objcgs */
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
 #endif
 
 	MEMCG_PADDING(_pad2_);
--- a/mm/memcontrol.c~mm-memcg-synchronize-objcg-lists-with-a-dedicated-spinlock
+++ a/mm/memcontrol.c
@@ -254,7 +254,7 @@ struct mem_cgroup *vmpressure_to_memcg(s
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-extern spinlock_t css_set_lock;
+static DEFINE_SPINLOCK(objcg_lock);
 
 bool mem_cgroup_kmem_disabled(void)
 {
@@ -298,9 +298,9 @@ static void obj_cgroup_release(struct pe
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 
-	spin_lock_irqsave(&css_set_lock, flags);
+	spin_lock_irqsave(&objcg_lock, flags);
 	list_del(&objcg->list);
-	spin_unlock_irqrestore(&css_set_lock, flags);
+	spin_unlock_irqrestore(&objcg_lock, flags);
 
 	percpu_ref_exit(ref);
 	kfree_rcu(objcg, rcu);
@@ -332,7 +332,7 @@ static void memcg_reparent_objcgs(struct
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
-	spin_lock_irq(&css_set_lock);
+	spin_lock_irq(&objcg_lock);
 
 	/* 1) Ready to reparent active objcg. */
 	list_add(&objcg->list, &memcg->objcg_list);
@@ -342,7 +342,7 @@ static void memcg_reparent_objcgs(struct
 	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
-	spin_unlock_irq(&css_set_lock);
+	spin_unlock_irq(&objcg_lock);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
_
