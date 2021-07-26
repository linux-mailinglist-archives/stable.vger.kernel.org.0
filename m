Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9963D5F18
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhGZPQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236332AbhGZPLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF47E60F38;
        Mon, 26 Jul 2021 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314727;
        bh=xISeChsXU7oujCsY+sJsyh9zA/XO7lNOGNh6ltcJzxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLd1gopHHmCZ9gdsjD4hL3JiDaWMO81quvW6eROcSCitSjxEttoHw4wgI2EiVaGaS
         CA4RQUIa7+cJYHtTJHgTeaN0FxDd91hcH0nbV1N64Hi6EuKfKtmAyIui4qS4uKOhYC
         RdEq61pGGgSktP1UGsP2EaGvofJRn1oOLgaoFlm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nanyong Sun <sunnanyong@huawei.com>
Subject: [PATCH 4.19 034/120] mm: slab: fix kmem_cache_create failed when sysfs node not destroyed
Date:   Mon, 26 Jul 2021 17:38:06 +0200
Message-Id: <20210726153833.480800654@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -311,14 +311,6 @@ int slab_unmergeable(struct kmem_cache *
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
 
@@ -918,6 +910,16 @@ void kmem_cache_destroy(struct kmem_cach
 	get_online_mems();
 
 	mutex_lock(&slab_mutex);
+
+	/*
+	 * Another thread referenced it again
+	 */
+	if (READ_ONCE(s->refcount)) {
+		spin_lock_irq(&memcg_kmem_wq_lock);
+		s->memcg_params.dying = false;
+		spin_unlock_irq(&memcg_kmem_wq_lock);
+		goto out_unlock;
+	}
 #endif
 
 	err = shutdown_memcg_caches(s);


