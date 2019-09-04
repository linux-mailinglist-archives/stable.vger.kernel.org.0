Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA68A8E28
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbfIDR40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387477AbfIDR4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3A121883;
        Wed,  4 Sep 2019 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619783;
        bh=eq/HtPGBtzvxRU6dDUs6h1NFUEdwOGdiKH2lt5gXh1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0n/XQGW2PwjAx2Q2iSVKqJ+MCn72w6o1AP44j0ovLapJw+NDqi9SiUvWiRphrUdP
         1vb/m59qUtwATM+h6KqSQyKwxPBLaUxexdYL7Hyl5Df+bocIl3u3d9bAOf5I5IFA7+
         5134fBOWX8/TlMYkfQxznvEcO/zmXZST5gd7fO5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juri Lelli <juri.lelli@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, cgroups@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.4 33/77] cgroup: Disable IRQs while holding css_set_lock
Date:   Wed,  4 Sep 2019 19:53:20 +0200
Message-Id: <20190904175306.620633120@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@redhat.com>

commit 82d6489d0fed2ec8a8c48c19e8d8a04ac8e5bb26 upstream.

While testing the deadline scheduler + cgroup setup I hit this
warning.

[  132.612935] ------------[ cut here ]------------
[  132.612951] WARNING: CPU: 5 PID: 0 at kernel/softirq.c:150 __local_bh_enable_ip+0x6b/0x80
[  132.612952] Modules linked in: (a ton of modules...)
[  132.612981] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.7.0-rc2 #2
[  132.612981] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[  132.612982]  0000000000000086 45c8bb5effdd088b ffff88013fd43da0 ffffffff813d229e
[  132.612984]  0000000000000000 0000000000000000 ffff88013fd43de0 ffffffff810a652b
[  132.612985]  00000096811387b5 0000000000000200 ffff8800bab29d80 ffff880034c54c00
[  132.612986] Call Trace:
[  132.612987]  <IRQ>  [<ffffffff813d229e>] dump_stack+0x63/0x85
[  132.612994]  [<ffffffff810a652b>] __warn+0xcb/0xf0
[  132.612997]  [<ffffffff810e76a0>] ? push_dl_task.part.32+0x170/0x170
[  132.612999]  [<ffffffff810a665d>] warn_slowpath_null+0x1d/0x20
[  132.613000]  [<ffffffff810aba5b>] __local_bh_enable_ip+0x6b/0x80
[  132.613008]  [<ffffffff817d6c8a>] _raw_write_unlock_bh+0x1a/0x20
[  132.613010]  [<ffffffff817d6c9e>] _raw_spin_unlock_bh+0xe/0x10
[  132.613015]  [<ffffffff811388ac>] put_css_set+0x5c/0x60
[  132.613016]  [<ffffffff8113dc7f>] cgroup_free+0x7f/0xa0
[  132.613017]  [<ffffffff810a3912>] __put_task_struct+0x42/0x140
[  132.613018]  [<ffffffff810e776a>] dl_task_timer+0xca/0x250
[  132.613027]  [<ffffffff810e76a0>] ? push_dl_task.part.32+0x170/0x170
[  132.613030]  [<ffffffff8111371e>] __hrtimer_run_queues+0xee/0x270
[  132.613031]  [<ffffffff81113ec8>] hrtimer_interrupt+0xa8/0x190
[  132.613034]  [<ffffffff81051a58>] local_apic_timer_interrupt+0x38/0x60
[  132.613035]  [<ffffffff817d9b0d>] smp_apic_timer_interrupt+0x3d/0x50
[  132.613037]  [<ffffffff817d7c5c>] apic_timer_interrupt+0x8c/0xa0
[  132.613038]  <EOI>  [<ffffffff81063466>] ? native_safe_halt+0x6/0x10
[  132.613043]  [<ffffffff81037a4e>] default_idle+0x1e/0xd0
[  132.613044]  [<ffffffff810381cf>] arch_cpu_idle+0xf/0x20
[  132.613046]  [<ffffffff810e8fda>] default_idle_call+0x2a/0x40
[  132.613047]  [<ffffffff810e92d7>] cpu_startup_entry+0x2e7/0x340
[  132.613048]  [<ffffffff81050235>] start_secondary+0x155/0x190
[  132.613049] ---[ end trace f91934d162ce9977 ]---

The warn is the spin_(lock|unlock)_bh(&css_set_lock) in the interrupt
context. Converting the spin_lock_bh to spin_lock_irq(save) to avoid
this problem - and other problems of sharing a spinlock with an
interrupt.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: cgroups@vger.kernel.org
Cc: stable@vger.kernel.org # 4.5+
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Acked-by: Zefan Li <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |  122 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 64 insertions(+), 58 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -784,6 +784,8 @@ static void put_css_set_locked(struct cs
 
 static void put_css_set(struct css_set *cset)
 {
+	unsigned long flags;
+
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
 	 * can see it. Similar to atomic_dec_and_lock(), but for an
@@ -792,9 +794,9 @@ static void put_css_set(struct css_set *
 	if (atomic_add_unless(&cset->refcount, -1, 1))
 		return;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	put_css_set_locked(cset);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 }
 
 /*
@@ -1017,11 +1019,11 @@ static struct css_set *find_css_set(stru
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	cset = find_existing_css_set(old_cset, cgrp, template);
 	if (cset)
 		get_css_set(cset);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	if (cset)
 		return cset;
@@ -1049,7 +1051,7 @@ static struct css_set *find_css_set(stru
 	 * find_existing_css_set() */
 	memcpy(cset->subsys, template, sizeof(cset->subsys));
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	/* Add reference counts and links from the new css_set. */
 	list_for_each_entry(link, &old_cset->cgrp_links, cgrp_link) {
 		struct cgroup *c = link->cgrp;
@@ -1075,7 +1077,7 @@ static struct css_set *find_css_set(stru
 		css_get(css);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	return cset;
 }
@@ -1139,7 +1141,7 @@ static void cgroup_destroy_root(struct c
 	 * Release all the links from cset_links to this hierarchy's
 	 * root cgroup
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	list_for_each_entry_safe(link, tmp_link, &cgrp->cset_links, cset_link) {
 		list_del(&link->cset_link);
@@ -1147,7 +1149,7 @@ static void cgroup_destroy_root(struct c
 		kfree(link);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	if (!list_empty(&root->root_list)) {
 		list_del(&root->root_list);
@@ -1551,11 +1553,11 @@ static int rebind_subsystems(struct cgro
 		ss->root = dst_root;
 		css->cgroup = dcgrp;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		hash_for_each(css_set_table, i, cset, hlist)
 			list_move_tail(&cset->e_cset_node[ss->id],
 				       &dcgrp->e_csets[ss->id]);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 
 		src_root->subsys_mask &= ~(1 << ssid);
 		scgrp->subtree_control &= ~(1 << ssid);
@@ -1832,7 +1834,7 @@ static void cgroup_enable_task_cg_lists(
 {
 	struct task_struct *p, *g;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	if (use_task_css_set_links)
 		goto out_unlock;
@@ -1857,8 +1859,12 @@ static void cgroup_enable_task_cg_lists(
 		 * entry won't be deleted though the process has exited.
 		 * Do it while holding siglock so that we don't end up
 		 * racing against cgroup_exit().
+		 *
+		 * Interrupts were already disabled while acquiring
+		 * the css_set_lock, so we do not need to disable it
+		 * again when acquiring the sighand->siglock here.
 		 */
-		spin_lock_irq(&p->sighand->siglock);
+		spin_lock(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING)) {
 			struct css_set *cset = task_css_set(p);
 
@@ -1867,11 +1873,11 @@ static void cgroup_enable_task_cg_lists(
 			list_add_tail(&p->cg_list, &cset->tasks);
 			get_css_set(cset);
 		}
-		spin_unlock_irq(&p->sighand->siglock);
+		spin_unlock(&p->sighand->siglock);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 out_unlock:
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 }
 
 static void init_cgroup_housekeeping(struct cgroup *cgrp)
@@ -1976,13 +1982,13 @@ static int cgroup_setup_root(struct cgro
 	 * Link the root cgroup in this hierarchy into all the css_set
 	 * objects.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	hash_for_each(css_set_table, i, cset, hlist) {
 		link_css_set(&tmp_links, cset, root_cgrp);
 		if (css_set_populated(cset))
 			cgroup_update_populated(root_cgrp, true);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	BUG_ON(!list_empty(&root_cgrp->self.children));
 	BUG_ON(atomic_read(&root->nr_cgrps) != 1);
@@ -2215,7 +2221,7 @@ char *task_cgroup_path(struct task_struc
 	char *path = NULL;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
 
@@ -2228,7 +2234,7 @@ char *task_cgroup_path(struct task_struc
 			path = buf;
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 	return path;
 }
@@ -2403,7 +2409,7 @@ static int cgroup_taskset_migrate(struct
 	 * the new cgroup.  There are no failure cases after here, so this
 	 * is the commit point.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
 		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list) {
 			struct css_set *from_cset = task_css_set(task);
@@ -2414,7 +2420,7 @@ static int cgroup_taskset_migrate(struct
 			put_css_set_locked(from_cset);
 		}
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	/*
 	 * Migration is committed, all target tasks are now on dst_csets.
@@ -2443,13 +2449,13 @@ out_cancel_attach:
 		}
 	}
 out_release_tset:
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_splice_init(&tset->dst_csets, &tset->src_csets);
 	list_for_each_entry_safe(cset, tmp_cset, &tset->src_csets, mg_node) {
 		list_splice_tail_init(&cset->mg_tasks, &cset->tasks);
 		list_del_init(&cset->mg_node);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	return ret;
 }
 
@@ -2466,14 +2472,14 @@ static void cgroup_migrate_finish(struct
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
 		put_css_set_locked(cset);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 }
 
 /**
@@ -2623,7 +2629,7 @@ static int cgroup_migrate(struct task_st
 	 * already PF_EXITING could be freed from underneath us unless we
 	 * take an rcu_read_lock.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2632,7 +2638,7 @@ static int cgroup_migrate(struct task_st
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	return cgroup_taskset_migrate(&tset, cgrp);
 }
@@ -2653,7 +2659,7 @@ static int cgroup_attach_task(struct cgr
 	int ret;
 
 	/* look up all src csets */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2663,7 +2669,7 @@ static int cgroup_attach_task(struct cgr
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(dst_cgrp, &preloaded_csets);
@@ -2696,9 +2702,9 @@ static int cgroup_procs_write_permission
 		struct cgroup *cgrp;
 		struct inode *inode;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 
 		while (!cgroup_is_descendant(dst_cgrp, cgrp))
 			cgrp = cgroup_parent(cgrp);
@@ -2800,9 +2806,9 @@ int cgroup_attach_task_all(struct task_s
 		if (root == &cgrp_dfl_root)
 			continue;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		from_cgrp = task_cgroup_from_root(from, root);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 
 		retval = cgroup_attach_task(from_cgrp, tsk, false);
 		if (retval)
@@ -2927,7 +2933,7 @@ static int cgroup_update_dfl_csses(struc
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 
 	/* look up all csses currently attached to @cgrp's subtree */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	css_for_each_descendant_pre(css, cgroup_css(cgrp, NULL)) {
 		struct cgrp_cset_link *link;
 
@@ -2939,14 +2945,14 @@ static int cgroup_update_dfl_csses(struc
 			cgroup_migrate_add_src(link->cset, cgrp,
 					       &preloaded_csets);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(NULL, &preloaded_csets);
 	if (ret)
 		goto out_finish;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(src_cset, &preloaded_csets, mg_preload_node) {
 		struct task_struct *task, *ntask;
 
@@ -2958,7 +2964,7 @@ static int cgroup_update_dfl_csses(struc
 		list_for_each_entry_safe(task, ntask, &src_cset->tasks, cg_list)
 			cgroup_taskset_add(task, &tset);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	ret = cgroup_taskset_migrate(&tset, cgrp);
 out_finish:
@@ -3641,10 +3647,10 @@ static int cgroup_task_count(const struc
 	int count = 0;
 	struct cgrp_cset_link *link;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
 		count += atomic_read(&link->cset->refcount);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	return count;
 }
 
@@ -3982,7 +3988,7 @@ void css_task_iter_start(struct cgroup_s
 
 	memset(it, 0, sizeof(*it));
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	it->ss = css->ss;
 
@@ -3995,7 +4001,7 @@ void css_task_iter_start(struct cgroup_s
 
 	css_task_iter_advance_css_set(it);
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 }
 
 /**
@@ -4013,7 +4019,7 @@ struct task_struct *css_task_iter_next(s
 		it->cur_task = NULL;
 	}
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	if (it->task_pos) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
@@ -4022,7 +4028,7 @@ struct task_struct *css_task_iter_next(s
 		css_task_iter_advance(it);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	return it->cur_task;
 }
@@ -4036,10 +4042,10 @@ struct task_struct *css_task_iter_next(s
 void css_task_iter_end(struct css_task_iter *it)
 {
 	if (it->cur_cset) {
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		list_del(&it->iters_node);
 		put_css_set_locked(it->cur_cset);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 	}
 
 	if (it->cur_task)
@@ -4068,10 +4074,10 @@ int cgroup_transfer_tasks(struct cgroup
 	mutex_lock(&cgroup_mutex);
 
 	/* all tasks in @from are being moved, all csets are source */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &from->cset_links, cset_link)
 		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	ret = cgroup_migrate_prepare_dst(to, &preloaded_csets);
 	if (ret)
@@ -5180,10 +5186,10 @@ static int cgroup_destroy_locked(struct
 	 */
 	cgrp->self.flags &= ~CSS_ONLINE;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
 		link->cset->dead = true;
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	/* initiate massacre of all css's */
 	for_each_css(css, ssid, cgrp)
@@ -5436,7 +5442,7 @@ int proc_cgroup_show(struct seq_file *m,
 		goto out;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	for_each_root(root) {
 		struct cgroup_subsys *ss;
@@ -5488,7 +5494,7 @@ int proc_cgroup_show(struct seq_file *m,
 
 	retval = 0;
 out_unlock:
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 	kfree(buf);
 out:
@@ -5649,13 +5655,13 @@ void cgroup_post_fork(struct task_struct
 	if (use_task_css_set_links) {
 		struct css_set *cset;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			get_css_set(cset);
 			css_set_move_task(child, NULL, cset, false);
 		}
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 	}
 
 	/*
@@ -5699,9 +5705,9 @@ void cgroup_exit(struct task_struct *tsk
 	cset = task_css_set(tsk);
 
 	if (!list_empty(&tsk->cg_list)) {
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
 	}
@@ -5914,7 +5920,7 @@ static int current_css_set_cg_links_read
 	if (!name_buf)
 		return -ENOMEM;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	cset = rcu_dereference(current->cgroups);
 	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
@@ -5925,7 +5931,7 @@ static int current_css_set_cg_links_read
 			   c->root->hierarchy_id, name_buf);
 	}
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	kfree(name_buf);
 	return 0;
 }
@@ -5936,7 +5942,7 @@ static int cgroup_css_links_read(struct
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
@@ -5959,7 +5965,7 @@ static int cgroup_css_links_read(struct
 	overflow:
 		seq_puts(seq, "  ...\n");
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	return 0;
 }
 


