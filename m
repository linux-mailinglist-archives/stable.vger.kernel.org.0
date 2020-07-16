Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A20222DE1
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 23:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgGPV22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 17:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgGPV21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 17:28:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D268220787;
        Thu, 16 Jul 2020 21:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594934906;
        bh=XjpmwpqQaaG73yx7/K3aj3b2qjYwIj7j4S4YgPX8vV8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0J0MnEC9RR9E4z4FzmlAXySC51JwAFjD4v0KdFXADo1sRtT8v3dYWhyL6vl446U1D
         WZDcNbC3L89I91XhSSrRGwFi3YL2FxDVwCN/0IyUKnIBbOoSkBR80VDNyhfR62mE5Q
         CQKdYRE2jIGwku+l7FHnNiV4nMTBvBzzFkdqVMZM=
Date:   Thu, 16 Jul 2020 14:28:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-memcg-slab-fix-memory-leak-at-non-root-kmem_cache-destroy.patch added to
 -mm tree
Message-ID: <20200716212825.AGqHB_kfq%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix memory leak at non-root kmem_cache destroy
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-memory-leak-at-non-root-kmem_cache-destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-memory-leak-at-non-root-kmem_cache-destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-memory-leak-at-non-root-kmem_cache-destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix memory leak at non-root kmem_cache destroy

If the kmem_cache refcount is greater than one, we should not mark the
root kmem_cache as dying.  If we mark the root kmem_cache dying
incorrectly, the non-root kmem_cache can never be destroyed.  It resulted
in memory leak when memcg was destroyed.  We can use the following steps
to reproduce.

  1) Use kmem_cache_create() to create a new kmem_cache named A.
  2) Coincidentally, the kmem_cache A is an alias for kmem_cache B,
     so the refcount of B is just increased.
  3) Use kmem_cache_destroy() to destroy the kmem_cache A, just
     decrease the B's refcount but mark the B as dying.
  4) Create a new memory cgroup and alloc memory from the kmem_cache
     B. It leads to create a non-root kmem_cache for allocating memory.
  5) When destroy the memory cgroup created in the step 4), the
     non-root kmem_cache can never be destroyed.

If we repeat steps 4) and 5), this will cause a lot of memory leak.  So
only when refcount reach zero, we mark the root kmem_cache as dying.

Link: http://lkml.kernel.org/r/20200716165103.83462-1-songmuchun@bytedance.com
Fixes: 92ee383f6daa ("mm: fix race between kmem_cache destroy, create and deactivate")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

--- a/mm/slab_common.c~mm-memcg-slab-fix-memory-leak-at-non-root-kmem_cache-destroy
+++ a/mm/slab_common.c
@@ -326,6 +326,14 @@ int slab_unmergeable(struct kmem_cache *
 	if (s->refcount < 0)
 		return 1;
 
+#ifdef CONFIG_MEMCG_KMEM
+	/*
+	 * Skip the dying kmem_cache.
+	 */
+	if (s->memcg_params.dying)
+		return 1;
+#endif
+
 	return 0;
 }
 
@@ -886,12 +894,15 @@ static int shutdown_memcg_caches(struct
 	return 0;
 }
 
-static void flush_memcg_workqueue(struct kmem_cache *s)
+static void memcg_set_kmem_cache_dying(struct kmem_cache *s)
 {
 	spin_lock_irq(&memcg_kmem_wq_lock);
 	s->memcg_params.dying = true;
 	spin_unlock_irq(&memcg_kmem_wq_lock);
+}
 
+static void flush_memcg_workqueue(struct kmem_cache *s)
+{
 	/*
 	 * SLAB and SLUB deactivate the kmem_caches through call_rcu. Make
 	 * sure all registered rcu callbacks have been invoked.
@@ -923,10 +934,6 @@ static inline int shutdown_memcg_caches(
 {
 	return 0;
 }
-
-static inline void flush_memcg_workqueue(struct kmem_cache *s)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 void slab_kmem_cache_release(struct kmem_cache *s)
@@ -944,8 +951,6 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s))
 		return;
 
-	flush_memcg_workqueue(s);
-
 	get_online_cpus();
 	get_online_mems();
 
@@ -955,6 +960,22 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
+#ifdef CONFIG_MEMCG_KMEM
+	memcg_set_kmem_cache_dying(s);
+
+	mutex_unlock(&slab_mutex);
+
+	put_online_mems();
+	put_online_cpus();
+
+	flush_memcg_workqueue(s);
+
+	get_online_cpus();
+	get_online_mems();
+
+	mutex_lock(&slab_mutex);
+#endif
+
 	err = shutdown_memcg_caches(s);
 	if (!err)
 		err = shutdown_cache(s);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcg-slab-fix-memory-leak-at-non-root-kmem_cache-destroy.patch
mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch

