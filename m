Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D03E6831
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbfJ0VXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732371AbfJ0VXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A3C2205C9;
        Sun, 27 Oct 2019 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211416;
        bh=DmYqqLwWAQOY9fKmJuHqIKjq1AvOXwPMA3SrV2NgqCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsQhY8q68Ex2XeI59nszc26Y2OTIj2AHClpLV7V1hKrlIwJFrokLTyFC9r4IMJ9G6
         0O2enGSzAMyl+xeKuI3LmhONkp61nQi/pXcD5bYAjbjfctXidOQsI+NanhsBtfaqzM
         jMgrEpAtDi/NlWVWBTiVHDndVV9HKXIPTxAKi8cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Michal Hocko <mhocko@suse.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 145/197] mm/slub: fix a deadlock in show_slab_objects()
Date:   Sun, 27 Oct 2019 22:01:03 +0100
Message-Id: <20191027203359.520600345@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit e4f8e513c3d353c134ad4eef9fd0bba12406c7c8 upstream.

A long time ago we fixed a similar deadlock in show_slab_objects() [1].
However, it is apparently due to the commits like 01fb58bcba63 ("slab:
remove synchronous synchronize_sched() from memcg cache deactivation
path") and 03afc0e25f7f ("slab: get_online_mems for
kmem_cache_{create,destroy,shrink}"), this kind of deadlock is back by
just reading files in /sys/kernel/slab which will generate a lockdep
splat below.

Since the "mem_hotplug_lock" here is only to obtain a stable online node
mask while racing with NUMA node hotplug, in the worst case, the results
may me miscalculated while doing NUMA node hotplug, but they shall be
corrected by later reads of the same files.

  WARNING: possible circular locking dependency detected
  ------------------------------------------------------
  cat/5224 is trying to acquire lock:
  ffff900012ac3120 (mem_hotplug_lock.rw_sem){++++}, at:
  show_slab_objects+0x94/0x3a8

  but task is already holding lock:
  b8ff009693eee398 (kn->count#45){++++}, at: kernfs_seq_start+0x44/0xf0

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (kn->count#45){++++}:
         lock_acquire+0x31c/0x360
         __kernfs_remove+0x290/0x490
         kernfs_remove+0x30/0x44
         sysfs_remove_dir+0x70/0x88
         kobject_del+0x50/0xb0
         sysfs_slab_unlink+0x2c/0x38
         shutdown_cache+0xa0/0xf0
         kmemcg_cache_shutdown_fn+0x1c/0x34
         kmemcg_workfn+0x44/0x64
         process_one_work+0x4f4/0x950
         worker_thread+0x390/0x4bc
         kthread+0x1cc/0x1e8
         ret_from_fork+0x10/0x18

  -> #1 (slab_mutex){+.+.}:
         lock_acquire+0x31c/0x360
         __mutex_lock_common+0x16c/0xf78
         mutex_lock_nested+0x40/0x50
         memcg_create_kmem_cache+0x38/0x16c
         memcg_kmem_cache_create_func+0x3c/0x70
         process_one_work+0x4f4/0x950
         worker_thread+0x390/0x4bc
         kthread+0x1cc/0x1e8
         ret_from_fork+0x10/0x18

  -> #0 (mem_hotplug_lock.rw_sem){++++}:
         validate_chain+0xd10/0x2bcc
         __lock_acquire+0x7f4/0xb8c
         lock_acquire+0x31c/0x360
         get_online_mems+0x54/0x150
         show_slab_objects+0x94/0x3a8
         total_objects_show+0x28/0x34
         slab_attr_show+0x38/0x54
         sysfs_kf_seq_show+0x198/0x2d4
         kernfs_seq_show+0xa4/0xcc
         seq_read+0x30c/0x8a8
         kernfs_fop_read+0xa8/0x314
         __vfs_read+0x88/0x20c
         vfs_read+0xd8/0x10c
         ksys_read+0xb0/0x120
         __arm64_sys_read+0x54/0x88
         el0_svc_handler+0x170/0x240
         el0_svc+0x8/0xc

  other info that might help us debug this:

  Chain exists of:
    mem_hotplug_lock.rw_sem --> slab_mutex --> kn->count#45

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(kn->count#45);
                                 lock(slab_mutex);
                                 lock(kn->count#45);
    lock(mem_hotplug_lock.rw_sem);

   *** DEADLOCK ***

  3 locks held by cat/5224:
   #0: 9eff00095b14b2a0 (&p->lock){+.+.}, at: seq_read+0x4c/0x8a8
   #1: 0eff008997041480 (&of->mutex){+.+.}, at: kernfs_seq_start+0x34/0xf0
   #2: b8ff009693eee398 (kn->count#45){++++}, at:
  kernfs_seq_start+0x44/0xf0

  stack backtrace:
  Call trace:
   dump_backtrace+0x0/0x248
   show_stack+0x20/0x2c
   dump_stack+0xd0/0x140
   print_circular_bug+0x368/0x380
   check_noncircular+0x248/0x250
   validate_chain+0xd10/0x2bcc
   __lock_acquire+0x7f4/0xb8c
   lock_acquire+0x31c/0x360
   get_online_mems+0x54/0x150
   show_slab_objects+0x94/0x3a8
   total_objects_show+0x28/0x34
   slab_attr_show+0x38/0x54
   sysfs_kf_seq_show+0x198/0x2d4
   kernfs_seq_show+0xa4/0xcc
   seq_read+0x30c/0x8a8
   kernfs_fop_read+0xa8/0x314
   __vfs_read+0x88/0x20c
   vfs_read+0xd8/0x10c
   ksys_read+0xb0/0x120
   __arm64_sys_read+0x54/0x88
   el0_svc_handler+0x170/0x240
   el0_svc+0x8/0xc

I think it is important to mention that this doesn't expose the
show_slab_objects to use-after-free.  There is only a single path that
might really race here and that is the slab hotplug notifier callback
__kmem_cache_shrink (via slab_mem_going_offline_callback) but that path
doesn't really destroy kmem_cache_node data structures.

[1] http://lkml.iu.edu/hypermail/linux/kernel/1101.0/02850.html

[akpm@linux-foundation.org: add comment explaining why we don't need mem_hotplug_lock]
Link: http://lkml.kernel.org/r/1570192309-10132-1-git-send-email-cai@lca.pw
Fixes: 01fb58bcba63 ("slab: remove synchronous synchronize_sched() from memcg cache deactivation path")
Fixes: 03afc0e25f7f ("slab: get_online_mems for kmem_cache_{create,destroy,shrink}")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4836,7 +4836,17 @@ static ssize_t show_slab_objects(struct
 		}
 	}
 
-	get_online_mems();
+	/*
+	 * It is impossible to take "mem_hotplug_lock" here with "kernfs_mutex"
+	 * already held which will conflict with an existing lock order:
+	 *
+	 * mem_hotplug_lock->slab_mutex->kernfs_mutex
+	 *
+	 * We don't really need mem_hotplug_lock (to hold off
+	 * slab_mem_going_offline_callback) here because slab's memory hot
+	 * unplug code doesn't destroy the kmem_cache->node[] data.
+	 */
+
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		struct kmem_cache_node *n;
@@ -4877,7 +4887,6 @@ static ssize_t show_slab_objects(struct
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
 #endif
-	put_online_mems();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }


