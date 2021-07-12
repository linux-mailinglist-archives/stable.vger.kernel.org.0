Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473783C49BA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhGLGqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239167AbhGLGov (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D786611F1;
        Mon, 12 Jul 2021 06:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072065;
        bh=X7N+hfWzZ01ntgSwiLLeppKf3NllJCroZW0ac6LKqIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ousYRLvT024PrKZSzj+mk3ow23r2EnnbWZeI6Zg6gvXs0K6TWrdv6sGqpRsIeB8aC
         Uns4J8EpSAV4R0vd+NFNTFQmC8SmVY+4F30aGPHD/B2NGf+NFv3BuFEGr1AFT/pq1a
         U4hKSPmthGBHaPrseL05poKgwiZIie90MovCSj1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/593] mm: memcg/slab: properly set up gfp flags for objcg pointer array
Date:   Mon, 12 Jul 2021 08:07:36 +0200
Message-Id: <20210712060917.202126218@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 41eb5df1cbc9b302fc263ad7c9f38cfc38b4df61 ]

Patch series "mm: memcg/slab: Fix objcg pointer array handling problem", v4.

Since the merging of the new slab memory controller in v5.9, the page
structure stores a pointer to objcg pointer array for slab pages.  When
the slab has no used objects, it can be freed in free_slab() which will
call kfree() to free the objcg pointer array in
memcg_alloc_page_obj_cgroups().  If it happens that the objcg pointer
array is the last used object in its slab, that slab may then be freed
which may caused kfree() to be called again.

With the right workload, the slab cache may be set up in a way that allows
the recursive kfree() calling loop to nest deep enough to cause a kernel
stack overflow and panic the system.  In fact, we have a reproducer that
can cause kernel stack overflow on a s390 system involving kmalloc-rcl-256
and kmalloc-rcl-128 slabs with the following kfree() loop recursively
called 74 times:

  [ 285.520739] [<000000000ec432fc>] kfree+0x4bc/0x560 [ 285.520740]
[<000000000ec43466>] __free_slab+0xc6/0x228 [ 285.520741]
[<000000000ec41fc2>] __slab_free+0x3c2/0x3e0 [ 285.520742]
[<000000000ec432fc>] kfree+0x4bc/0x560 : While investigating this issue, I
also found an issue on the allocation side.  If the objcg pointer array
happen to come from the same slab or a circular dependency linkage is
formed with multiple slabs, those affected slabs can never be freed again.

This patch series addresses these two issues by introducing a new set of
kmalloc-cg-<n> caches split from kmalloc-<n> caches.  The new set will
only contain non-reclaimable and non-dma objects that are accounted in
memory cgroups whereas the old set are now for unaccounted objects only.
By making this split, all the objcg pointer arrays will come from the
kmalloc-<n> caches, but those caches will never hold any objcg pointer
array.  As a result, deeply nested kfree() call and the unfreeable slab
problems are now gone.

This patch (of 4):

Since the merging of the new slab memory controller in v5.9, the page
structure may store a pointer to obj_cgroup pointer array for slab pages.
Currently, only the __GFP_ACCOUNT bit is masked off.  However, the array
is not readily reclaimable and doesn't need to come from the DMA buffer.
So those GFP bits should be masked off as well.

Do the flag bit clearing at memcg_alloc_page_obj_cgroups() to make sure
that it is consistently applied no matter where it is called.

Link: https://lkml.kernel.org/r/20210505200610.13943-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20210505200610.13943-2-longman@redhat.com
Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 8 ++++++++
 mm/slab.h       | 1 -
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8d9f5fa4c6d3..92bf987d0a41 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2898,12 +2898,20 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * The allocated objcg pointers array is not accounted directly.
+ * Moreover, it should not come from DMA buffer and is not readily
+ * reclaimable. So those GFP bits should be masked off.
+ */
+#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
+
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp)
 {
 	unsigned int objects = objs_per_slab_page(s, page);
 	void *vec;
 
+	gfp &= ~OBJCGS_CLEAR_MASK;
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
 			   page_to_nid(page));
 	if (!vec)
diff --git a/mm/slab.h b/mm/slab.h
index e258ffcfb0ef..944e8b2040ae 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -326,7 +326,6 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
-	flags &= ~__GFP_ACCOUNT;
 	for (i = 0; i < size; i++) {
 		if (likely(p[i])) {
 			page = virt_to_head_page(p[i]);
-- 
2.30.2



