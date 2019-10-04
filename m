Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27DCBA79
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbfJDMcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:32:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37226 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387447AbfJDMcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 08:32:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so8299890qtr.4
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 05:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Hw1We8CfLP0SmMR5o0InXrIroKd+SFzmFpF3ivXp5LM=;
        b=cAaNojfmryyKfKdO3SRJe1euhDCu8cW2aH/D85tNJwzQ0LfO1GhwSmT9A6tMoDzOwY
         nz+rEpHh5tD44/XzmXf0SnVKx36KJXQK2nPjoCmjf3pgbTtiSFMlgBVAz/1WTq2UjsGu
         4YINp2cH8G94VfSWKLocnQFxfFRMlOPyksxowbbvmfNu1fbIWDLGPmwe6DqzA8E4D+O4
         TbVlO7131CpSQCoIDsLtv3gdwtkjYY/4Ag8+ilq+aVxtRLidvoe66Lq395JJQgERnv2l
         lTukgnjQqN7nMFX9SADTiXhcZ0EprLeUyE2+RwAQpAe3geQ8ZCywefmNoYRDavVt+fmY
         ohKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Hw1We8CfLP0SmMR5o0InXrIroKd+SFzmFpF3ivXp5LM=;
        b=jRN+CtfZIhfhUAcxdFnlg8kmjxPh3eSOXAl5lC7YYMm8Cd3OREw0nglRVUBEk/Oa+j
         VfU2jpocSD/DcO4Fw68tvh3XE/Pcv7e/JUJdE6wWRSBXsLbVHOp3f95gU4d9M+UtTGA9
         YNvl6MJMWE32TtMixMqLn8JdyxPOf3UrvA4raoGP9URmPT7vPGjjM5LyO1+p1WO21mi1
         WFyr/rv8c3wtkgwmbvbIb1kzkt4PXNAZ4JLFOpfz5Aqchj/mQW2JKKsBt7N/n+jWb0A8
         qiRLDcoKEOhCprywreKEkTB2VA5yUFdIqz/dcJrH6iJRqWVyASq31S0dTzBicYFfpbjL
         /T0Q==
X-Gm-Message-State: APjAAAU5Hy46Mb9OdAzfUWl/kuvlcMxr6QeTjpm9zLZSdpt3DCFg4+x4
        dGH/a5Yx1Um/yV1URyeOGa7QnA==
X-Google-Smtp-Source: APXvYqwbpAN5ELMp+6w5nN6jYaLLbzyMoDeH/vjPeAPPNyULlo3jYy+p9faA2ZMBfWONzOlBN2WXcA==
X-Received: by 2002:aed:3c27:: with SMTP id t36mr15801812qte.388.1570192332198;
        Fri, 04 Oct 2019 05:32:12 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c131sm3352420qke.24.2019.10.04.05.32.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 05:32:11 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     akpm@linux-foundation.org
Cc:     tj@kernel.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org,
        guro@fb.com, mhocko@suse.com, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        stable@vger.kernel.org
Subject: [PATCH v2] mm/slub: fix a deadlock in show_slab_objects()
Date:   Fri,  4 Oct 2019 08:31:49 -0400
Message-Id: <1570192309-10132-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Long time ago, there fixed a similar deadlock in show_slab_objects()
[1]. However, it is apparently due to the commits like 01fb58bcba63
("slab: remove synchronous synchronize_sched() from memcg cache
deactivation path") and 03afc0e25f7f ("slab: get_online_mems for
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

[1] http://lkml.iu.edu/hypermail/linux/kernel/1101.0/02850.html

Fixes: 01fb58bcba63 ("slab: remove synchronous synchronize_sched() from memcg cache deactivation path")
Fixes: 03afc0e25f7f ("slab: get_online_mems for kmem_cache_{create,destroy,shrink}")
Cc: stable@vger.kernel.org
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Qian Cai <cai@lca.pw>
---

v2: fix the comment alignment and improve the changelog.

 mm/slub.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 42c1b3af3c98..86bfd9d98af5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4838,7 +4838,13 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 		}
 	}
 
-	get_online_mems();
+	/*
+	 * It is impossible to take "mem_hotplug_lock" here with "kernfs_mutex"
+	 * already held which will conflict with an existing lock order:
+	 *
+	 * mem_hotplug_lock->slab_mutex->kernfs_mutex
+	 */
+
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		struct kmem_cache_node *n;
@@ -4879,7 +4885,6 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
 #endif
-	put_online_mems();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }
-- 
1.8.3.1

