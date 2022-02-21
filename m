Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3CD4BDE0F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347969AbiBUJKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347886AbiBUJJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52513D73;
        Mon, 21 Feb 2022 01:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49F9610E8;
        Mon, 21 Feb 2022 09:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B29FC340E9;
        Mon, 21 Feb 2022 09:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434121;
        bh=mfk97mA/SsxJDNku6jlkF2PMrziryMO6qIAuCrRg9JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w54wg2rVjT8dnYEw+po+jVBSjaT27fjzJGxeYJT4o0aKiGEN8PyZ4X2ZcwNcaLJhp
         sE/jjXrjY79NP+buW9NVf+Q4LmlQeiVZ6gFax0OqI9eeigd6XLdagIc8moozgPXzdn
         M/23SD9RIEL8KKkiElyKSGxOJjjN7QyEb7JUdQHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 002/121] mm: memcg: synchronize objcg lists with a dedicated spinlock
Date:   Mon, 21 Feb 2022 09:48:14 +0100
Message-Id: <20220221084921.228445331@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit 0764db9b49c932b89ee4d9e3236dff4bb07b4a66 upstream.

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
            dump_stack_lvl+0x76/0x98
            check_noncircular+0x136/0x158
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
          INFO: lockdep is turned off.

In this example a slab allocation from __send_signal() caused a
refilling and draining of a percpu objcg stock, resulted in a releasing
of another non-related objcg.  Objcg release path requires taking the
css_set_lock, which is used to synchronize objcg lists.

This can create a circular dependency with the sighandler lock, which is
taken with the locked css_set_lock by the freezer code (to freeze a
task).

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |   10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -197,7 +197,7 @@ struct obj_cgroup {
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
 	union {
-		struct list_head list;
+		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
 };
@@ -300,7 +300,8 @@ struct mem_cgroup {
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
 	struct obj_cgroup __rcu *objcg;
-	struct list_head objcg_list; /* list of inherited objcgs */
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
 #endif
 
 	MEMCG_PADDING(_pad2_);
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -250,7 +250,7 @@ struct cgroup_subsys_state *vmpressure_t
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-extern spinlock_t css_set_lock;
+static DEFINE_SPINLOCK(objcg_lock);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
@@ -284,13 +284,13 @@ static void obj_cgroup_release(struct pe
 	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
 	nr_pages = nr_bytes >> PAGE_SHIFT;
 
-	spin_lock_irqsave(&css_set_lock, flags);
+	spin_lock_irqsave(&objcg_lock, flags);
 	memcg = obj_cgroup_memcg(objcg);
 	if (nr_pages)
 		__memcg_kmem_uncharge(memcg, nr_pages);
 	list_del(&objcg->list);
 	mem_cgroup_put(memcg);
-	spin_unlock_irqrestore(&css_set_lock, flags);
+	spin_unlock_irqrestore(&objcg_lock, flags);
 
 	percpu_ref_exit(ref);
 	kfree_rcu(objcg, rcu);
@@ -322,7 +322,7 @@ static void memcg_reparent_objcgs(struct
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
-	spin_lock_irq(&css_set_lock);
+	spin_lock_irq(&objcg_lock);
 
 	/* Move active objcg to the parent's list */
 	xchg(&objcg->memcg, parent);
@@ -337,7 +337,7 @@ static void memcg_reparent_objcgs(struct
 	}
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
-	spin_unlock_irq(&css_set_lock);
+	spin_unlock_irq(&objcg_lock);
 
 	percpu_ref_kill(&objcg->refcnt);
 }


