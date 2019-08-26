Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3573A9D60D
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 20:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfHZSzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 14:55:45 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39026 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfHZSzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 14:55:45 -0400
Received: by mail-pl1-f193.google.com with SMTP id z3so10496936pln.6
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 11:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uf/27RQpOZzXTjl5l7nGdlxcHj1LxbdACG68IVyP4WI=;
        b=cjdfurU1b0Vx2+CqMWey/UOsihqeZ7YHZYICCb3864djsN1gfsphqolSt4uhHL1StQ
         hzvw4D+C57k29/pD2a3PZqyicikChVD6klTyfZbkFC7CQYonX+OyC6mddID4Id3aALRu
         31Ea47RGYBjQlW7toKPCYI5/wWUtp5yWEbQY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uf/27RQpOZzXTjl5l7nGdlxcHj1LxbdACG68IVyP4WI=;
        b=Ygqg2pFuJg1hwvusqU1uF8mMQgLYUyjcluyEv5a6+N+v0BIIq+nAee/rLRhPlL0lHr
         5FANTtZbvCPqzcd32XnKHGbLpGOOSGpR20esHWIiYVK2vtclytzMEFhdlI4N9plWa5iL
         MKW5lo1ky4X9bOIZxxi4q2wXop0iiYl3QGAMyPrF4hUqEQ4q8EvuCFoGbmeRmk8t3MwB
         2j/546q6Gb5bhlDdeAubOsBUaGnl3ZyYlRCc3zQ6/3ofC+vwZqqZmXMLmEq+TR4FS+Wn
         xq05SHQcop1mDEbkNmxREmi4TWyyIfWgB9qTedSBSUra8/LFJXOL6GXdNk6+QPk1d9ql
         AO+g==
X-Gm-Message-State: APjAAAV4/+FYqMPz9fFkKZ1iVZeSZqDXciZnsxyd27Q2l1KBxhdE6T7L
        usik3+5Abe7lMSMuIPCvRp8oOiUT+6MJgg==
X-Google-Smtp-Source: APXvYqwGUlrFGfn3Tvcp4f1xhPKiOz6+1Xvu1tPI+XtZkKv1p+vElr98T93XzA8K96V4hIENHAHH4w==
X-Received: by 2002:a17:902:141:: with SMTP id 59mr20969802plb.324.1566845743669;
        Mon, 26 Aug 2019 11:55:43 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id i11sm15551883pfk.34.2019.08.26.11.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 11:55:42 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org, sashal@kernel.org,
        bristot@redhat.com, tj@kernel.org, lizefan@huawei.com,
        hannes@cmpxchg.org, juri.lelli@arm.com, rostedt@goodmis.org
Subject: [PATCH 4.4.y v2] cgroup: Disable IRQs while holding css_set_lock
Date:   Mon, 26 Aug 2019 11:55:34 -0700
Message-Id: <20190826185534.56945-1-zsm@chromium.org>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
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
---
Note:
* Syzkaller triggered a warning in __local_bh_enable_ip with the
following stacktrace when fuzzing a 4.4 kernel.
Call Trace:
 [<ffffffff81cb25b1>] __dump_stack lib/dump_stack.c:15 [inline]
 [<ffffffff81cb25b1>] dump_stack+0xc1/0x120 lib/dump_stack.c:51
 [<ffffffff813e220d>] panic+0x1a2/0x364 kernel/panic.c:116
 [<ffffffff813e2435>] __warn.cold+0x20/0x45 kernel/panic.c:470
 [<ffffffff813e2498>] warn_slowpath_null+0x3e/0x44 kernel/panic.c:514
 [<ffffffff81117276>] __local_bh_enable_ip+0x96/0xd0 kernel/softirq.c:150
 [<ffffffff82a3a7c6>] __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:178 [inline]
 [<ffffffff82a3a7c6>] _raw_spin_unlock_bh+0x36/0x40 kernel/locking/spinlock.c:207
 [<ffffffff812bb9bb>] spin_unlock_bh include/linux/spinlock.h:352 [inline]
 [<ffffffff812bb9bb>] put_css_set kernel/cgroup.c:808 [inline]
 [<ffffffff812bb9bb>] put_css_set+0x8b/0xb0 kernel/cgroup.c:796
 [<ffffffff812ca55c>] cgroup_free+0xfc/0x1e0 kernel/cgroup.c:5812
 [<ffffffff8110025d>] __put_task_struct+0xbd/0x3c0 kernel/fork.c:258
 [<ffffffff8126605a>] put_task_struct include/linux/sched.h:2158 [inline]
 [<ffffffff8126605a>] posix_cpu_timer_del+0x1ba/0x2a0 kernel/time/posix-cpu-timers.c:418
 [<ffffffff812647f1>] timer_delete_hook kernel/time/posix-timers.c:953 [inline]
 [<ffffffff812647f1>] itimer_delete kernel/time/posix-timers.c:996 [inline]
 [<ffffffff812647f1>] exit_itimers+0x121/0x280 kernel/time/posix-timers.c:1021
 [<ffffffff81112df4>] do_exit+0xcf4/0x2960 kernel/exit.c:738
 [<ffffffff81114be6>] do_group_exit+0x116/0x330 kernel/exit.c:893
 [<ffffffff8113709b>] get_signal+0x33b/0x1a50 kernel/signal.c:2380
 [<ffffffff8100b2b2>] do_signal+0x92/0x17c0 arch/x86/kernel/signal.c:737
 [<ffffffff810028b0>] exit_to_usermode_loop+0xc0/0x150 arch/x86/entry/common.c:242
 [<ffffffff81005300>] prepare_exit_to_usermode arch/x86/entry/common.c:276 [inline]
 [<ffffffff81005300>] syscall_return_slowpath+0x1c0/0x1f0 arch/x86/entry/common.c:345
 [<ffffffff82a3b3f9>] int_ret_from_sys_call+0x25/0xa3

* This patch resolves conflicts related to the following changes that
are not present in linux-4.4.y.
4f41fc59620f ("cgroup, kernfs: make mountinfo show properly scoped path for cgroup namespaces")
ed82571b1a14 ("cgroup: mount cgroupns-root when inside non-init cgroupns")
a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
16af43964545 ("cgroup: implement cgroup_get_from_path() and expose cgroup_put()")

* This commit is present in linux-4.9.y.

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 kernel/cgroup.c | 122 +++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 58 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5299618d6308..7a7c535f8a2f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -784,6 +784,8 @@ static void put_css_set_locked(struct css_set *cset)
 
 static void put_css_set(struct css_set *cset)
 {
+	unsigned long flags;
+
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
 	 * can see it. Similar to atomic_dec_and_lock(), but for an
@@ -792,9 +794,9 @@ static void put_css_set(struct css_set *cset)
 	if (atomic_add_unless(&cset->refcount, -1, 1))
 		return;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	put_css_set_locked(cset);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 }
 
 /*
@@ -1017,11 +1019,11 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 
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
@@ -1049,7 +1051,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	 * find_existing_css_set() */
 	memcpy(cset->subsys, template, sizeof(cset->subsys));
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	/* Add reference counts and links from the new css_set. */
 	list_for_each_entry(link, &old_cset->cgrp_links, cgrp_link) {
 		struct cgroup *c = link->cgrp;
@@ -1075,7 +1077,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 		css_get(css);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	return cset;
 }
@@ -1139,7 +1141,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	 * Release all the links from cset_links to this hierarchy's
 	 * root cgroup
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	list_for_each_entry_safe(link, tmp_link, &cgrp->cset_links, cset_link) {
 		list_del(&link->cset_link);
@@ -1147,7 +1149,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 		kfree(link);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	if (!list_empty(&root->root_list)) {
 		list_del(&root->root_list);
@@ -1551,11 +1553,11 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
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
@@ -1832,7 +1834,7 @@ static void cgroup_enable_task_cg_lists(void)
 {
 	struct task_struct *p, *g;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	if (use_task_css_set_links)
 		goto out_unlock;
@@ -1857,8 +1859,12 @@ static void cgroup_enable_task_cg_lists(void)
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
 
@@ -1867,11 +1873,11 @@ static void cgroup_enable_task_cg_lists(void)
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
@@ -1976,13 +1982,13 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
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
@@ -2215,7 +2221,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 	char *path = NULL;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
 
@@ -2228,7 +2234,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 			path = buf;
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 	return path;
 }
@@ -2403,7 +2409,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 * the new cgroup.  There are no failure cases after here, so this
 	 * is the commit point.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
 		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list) {
 			struct css_set *from_cset = task_css_set(task);
@@ -2414,7 +2420,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
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
 
@@ -2466,14 +2472,14 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 
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
@@ -2623,7 +2629,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	 * already PF_EXITING could be freed from underneath us unless we
 	 * take an rcu_read_lock.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2632,7 +2638,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	return cgroup_taskset_migrate(&tset, cgrp);
 }
@@ -2653,7 +2659,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	int ret;
 
 	/* look up all src csets */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2663,7 +2669,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(dst_cgrp, &preloaded_csets);
@@ -2696,9 +2702,9 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 		struct cgroup *cgrp;
 		struct inode *inode;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 
 		while (!cgroup_is_descendant(dst_cgrp, cgrp))
 			cgrp = cgroup_parent(cgrp);
@@ -2800,9 +2806,9 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		if (root == &cgrp_dfl_root)
 			continue;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irq(&css_set_lock);
 		from_cgrp = task_cgroup_from_root(from, root);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irq(&css_set_lock);
 
 		retval = cgroup_attach_task(from_cgrp, tsk, false);
 		if (retval)
@@ -2927,7 +2933,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 
 	/* look up all csses currently attached to @cgrp's subtree */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	css_for_each_descendant_pre(css, cgroup_css(cgrp, NULL)) {
 		struct cgrp_cset_link *link;
 
@@ -2939,14 +2945,14 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
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
 
@@ -2958,7 +2964,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		list_for_each_entry_safe(task, ntask, &src_cset->tasks, cg_list)
 			cgroup_taskset_add(task, &tset);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	ret = cgroup_taskset_migrate(&tset, cgrp);
 out_finish:
@@ -3641,10 +3647,10 @@ static int cgroup_task_count(const struct cgroup *cgrp)
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
 
@@ -3982,7 +3988,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	memset(it, 0, sizeof(*it));
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	it->ss = css->ss;
 
@@ -3995,7 +4001,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	css_task_iter_advance_css_set(it);
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 }
 
 /**
@@ -4013,7 +4019,7 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 		it->cur_task = NULL;
 	}
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	if (it->task_pos) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
@@ -4022,7 +4028,7 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 		css_task_iter_advance(it);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 
 	return it->cur_task;
 }
@@ -4036,10 +4042,10 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
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
@@ -4068,10 +4074,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
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
@@ -5180,10 +5186,10 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
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
@@ -5436,7 +5442,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		goto out;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 
 	for_each_root(root) {
 		struct cgroup_subsys *ss;
@@ -5488,7 +5494,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 
 	retval = 0;
 out_unlock:
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 	kfree(buf);
 out:
@@ -5649,13 +5655,13 @@ void cgroup_post_fork(struct task_struct *child,
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
@@ -5699,9 +5705,9 @@ void cgroup_exit(struct task_struct *tsk)
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
@@ -5914,7 +5920,7 @@ static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
 	if (!name_buf)
 		return -ENOMEM;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	rcu_read_lock();
 	cset = rcu_dereference(current->cgroups);
 	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
@@ -5925,7 +5931,7 @@ static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
 			   c->root->hierarchy_id, name_buf);
 	}
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	kfree(name_buf);
 	return 0;
 }
@@ -5936,7 +5942,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
@@ -5959,7 +5965,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 	overflow:
 		seq_puts(seq, "  ...\n");
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irq(&css_set_lock);
 	return 0;
 }
 
-- 
2.23.0.187.g17f5b7556c-goog

