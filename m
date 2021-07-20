Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BCB3CF584
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 09:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhGTHJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 03:09:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7403 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhGTHJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 03:09:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GTW4R2pSrz7xBj;
        Tue, 20 Jul 2021 15:46:31 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 15:50:09 +0800
Received: from huawei.com (10.175.113.32) by dggpemm000001.china.huawei.com
 (7.185.36.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Jul
 2021 15:50:08 +0800
From:   Nanyong Sun <sunnanyong@huawei.com>
To:     <songmuchun@bytedance.com>, <cl@linux.com>, <penberg@kernel.org>,
        <rientjes@google.com>, <iamjoonsoo.kim@lge.com>,
        <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v4.19.y,v5.4.y] mm: slab: fix kmem_cache_create failed when sysfs node not destroyed
Date:   Tue, 20 Jul 2021 16:20:48 +0800
Message-ID: <20210720082048.2797315-1-sunnanyong@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm000001.china.huawei.com (7.185.36.245)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit d38a2b7a9c93 ("mm: memcg/slab: fix memory leak at non-root
kmem_cache destroy") introduced a problem: If one thread destroy a
kmem_cache A and another thread concurrently create a kmem_cache B,
which is mergeable with A and has same size with A, the B may fail to
create due to the duplicate sysfs node.
The scenario in detail:
1) Thread 1 uses kmem_cache_destroy() to destroy kmem_cache A which is
mergeable, it decreases A's refcount and if refcount is 0, then call
memcg_set_kmem_cache_dying() which set A->memcg_params.dying = true,
then unlock the slab_mutex and call flush_memcg_workqueue(), it may cost
a while.
Note: now the sysfs node(like '/kernel/slab/:0000248') of A is still
present, it will be deleted in shutdown_cache() which will be called
after flush_memcg_workqueue() is done and lock the slab_mutex again.
2) Now if thread 2 is coming, it use kmem_cache_create() to create B, which
is mergeable with A(their size is same), it gain the lock of slab_mutex,
then call __kmem_cache_alias() trying to find a mergeable node, because
of the below added code in commit d38a2b7a9c93 ("mm: memcg/slab: fix
memory leak at non-root kmem_cache destroy"), B is not mergeable with
A whose memcg_params.dying is true.

int slab_unmergeable(struct kmem_cache *s)
 	if (s->refcount < 0)
 		return 1;

	/*
	 * Skip the dying kmem_cache.
	 */
	if (s->memcg_params.dying)
		return 1;

 	return 0;
 }

So B has to create its own sysfs node by calling:
 create_cache->
	__kmem_cache_create->
		sysfs_slab_add->
			kobject_init_and_add
Because B is mergeable itself, its filename of sysfs node is based on its size,
like '/kernel/slab/:0000248', which is duplicate with A, and the sysfs
node of A is still present now, so kobject_init_and_add() will return
fail and result in kmem_cache_create() fail.

Concurrently modprobe and rmmod the two modules below can reproduce the issue
quickly: nf_conntrack_expect, se_sess_cache. See call trace in the end.

LTS versions of v4.19.y and v5.4.y have this problem, whereas linux versions after
v5.9 do not have this problem because the patchset: ("The new cgroup slab memory
controller") almost refactored memcg slab.

A potential solution(this patch belongs): Just let the dying kmem_cache be mergeable,
the slab_mutex lock can prevent the race between alias kmem_cache creating thread
and root kmem_cache destroying thread. In the destroying thread, after
flush_memcg_workqueue() is done, judge the refcount again, if someone
reference it again during un-lock time, we don't need to destroy the kmem_cache
completely, we can reuse it.

Another potential solution: revert the commit d38a2b7a9c93 ("mm: memcg/slab:
fix memory leak at non-root kmem_cache destroy"), compare to the fail of
kmem_cache_create, the memory leak in special scenario seems less harmful.

Call trace:
 sysfs: cannot create duplicate filename '/kernel/slab/:0000248'
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 Call trace:
  dump_backtrace+0x0/0x198
  show_stack+0x24/0x30
  dump_stack+0xb0/0x100
  sysfs_warn_dup+0x6c/0x88
  sysfs_create_dir_ns+0x104/0x120
  kobject_add_internal+0xd0/0x378
  kobject_init_and_add+0x90/0xd8
  sysfs_slab_add+0x16c/0x2d0
  __kmem_cache_create+0x16c/0x1d8
  create_cache+0xbc/0x1f8
  kmem_cache_create_usercopy+0x1a0/0x230
  kmem_cache_create+0x50/0x68
  init_se_kmem_caches+0x38/0x258 [target_core_mod]
  target_core_init_configfs+0x8c/0x390 [target_core_mod]
  do_one_initcall+0x54/0x230
  do_init_module+0x64/0x1ec
  load_module+0x150c/0x16f0
  __se_sys_finit_module+0xf0/0x108
  __arm64_sys_finit_module+0x24/0x30
  el0_svc_common+0x80/0x1c0
  el0_svc_handler+0x78/0xe0
  el0_svc+0x10/0x260
 kobject_add_internal failed for :0000248 with -EEXIST, don't try to register things with the same name in the same directory.
 kmem_cache_create(se_sess_cache) failed with error -17
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 Call trace:
  dump_backtrace+0x0/0x198
  show_stack+0x24/0x30
  dump_stack+0xb0/0x100
  kmem_cache_create_usercopy+0xa8/0x230
  kmem_cache_create+0x50/0x68
  init_se_kmem_caches+0x38/0x258 [target_core_mod]
  target_core_init_configfs+0x8c/0x390 [target_core_mod]
  do_one_initcall+0x54/0x230
  do_init_module+0x64/0x1ec
  load_module+0x150c/0x16f0
  __se_sys_finit_module+0xf0/0x108
  __arm64_sys_finit_module+0x24/0x30
  el0_svc_common+0x80/0x1c0
  el0_svc_handler+0x78/0xe0
  el0_svc+0x10/0x260

Fixes: d38a2b7a9c93 ("mm: memcg/slab: fix memory leak at non-root kmem_cache destroy")
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: stable@vger.kernel.org
---
 mm/slab_common.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d208b47e01a8..acc743315bb5 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -326,14 +326,6 @@ int slab_unmergeable(struct kmem_cache *s)
 	if (s->refcount < 0)
 		return 1;
 
-#ifdef CONFIG_MEMCG_KMEM
-	/*
-	 * Skip the dying kmem_cache.
-	 */
-	if (s->memcg_params.dying)
-		return 1;
-#endif
-
 	return 0;
 }
 
@@ -947,6 +939,16 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	get_online_mems();
 
 	mutex_lock(&slab_mutex);
+
+	/*
+	 *Another thread referenced it again
+	 */
+	if (READ_ONCE(s->refcount)) {
+		spin_lock_irq(&memcg_kmem_wq_lock);
+		s->memcg_params.dying = false;
+		spin_unlock_irq(&memcg_kmem_wq_lock);
+		goto out_unlock;
+	}
 #endif
 
 	err = shutdown_memcg_caches(s);
-- 
2.18.0.huawei.25

