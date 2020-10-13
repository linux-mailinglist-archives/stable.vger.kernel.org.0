Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9E28D72F
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 01:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgJMXxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 19:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgJMXxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F9A22202;
        Tue, 13 Oct 2020 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633190;
        bh=BA2yLTwGwGOpTQ1VF3mEHvOygAJ/X8NPfMQ/UHjxjDo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=13+L2yTrQQd3doaNKG/baBKrOSaCXTgFN5xP//+wy+NS108qu3ozaCVadSO6KRGh8
         4IdEgp9/D0NpJQgoIB6AtLJ1t5ewUixJFKAMtHHrW0FlQuN3irOzfR4Fx726czEirp
         Y0ie29JiT3boVYL/2l2a2ZjoTXmsOGs3SGX9T1SY=
Date:   Tue, 13 Oct 2020 16:53:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bharata@linux.ibm.com, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, stable@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 088/181] mm: memcg/slab: uncharge during
 kmem_cache_free_bulk()
Message-ID: <20201013235309.EcZce1ggx%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharata B Rao <bharata@linux.ibm.com>
Subject: mm: memcg/slab: uncharge during kmem_cache_free_bulk()

Object cgroup charging is done for all the objects during allocation, but
during freeing, uncharging ends up happening for only one object in the
case of bulk allocation/freeing.

Fix this by having a separate call to uncharge all the objects from
kmem_cache_free_bulk() and by modifying memcg_slab_free_hook() to take
care of bulk uncharging.

Link: https://lkml.kernel.org/r/20201009060423.390479-1-bharata@linux.ibm.com
Fixes: 964d4bd370d5 ("mm: memcg/slab: save obj_cgroup for non-root slab objects"
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 mm/slab.h |   50 +++++++++++++++++++++++++++++++-------------------
 mm/slub.c |    3 ++-
 3 files changed, 34 insertions(+), 21 deletions(-)

--- a/mm/slab.c~mm-memcg-slab-uncharge-during-kmem_cache_free_bulk
+++ a/mm/slab.c
@@ -3438,7 +3438,7 @@ void ___cache_free(struct kmem_cache *ca
 		memset(objp, 0, cachep->object_size);
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
-	memcg_slab_free_hook(cachep, virt_to_head_page(objp), objp);
+	memcg_slab_free_hook(cachep, &objp, 1);
 
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
--- a/mm/slab.h~mm-memcg-slab-uncharge-during-kmem_cache_free_bulk
+++ a/mm/slab.h
@@ -345,30 +345,42 @@ static inline void memcg_slab_post_alloc
 	obj_cgroup_put(objcg);
 }
 
-static inline void memcg_slab_free_hook(struct kmem_cache *s, struct page *page,
-					void *p)
+static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
+					void **p, int objects)
 {
+	struct kmem_cache *s;
 	struct obj_cgroup *objcg;
+	struct page *page;
 	unsigned int off;
+	int i;
 
 	if (!memcg_kmem_enabled())
 		return;
 
-	if (!page_has_obj_cgroups(page))
-		return;
-
-	off = obj_to_index(s, page, p);
-	objcg = page_obj_cgroups(page)[off];
-	page_obj_cgroups(page)[off] = NULL;
-
-	if (!objcg)
-		return;
-
-	obj_cgroup_uncharge(objcg, obj_full_size(s));
-	mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
-			-obj_full_size(s));
-
-	obj_cgroup_put(objcg);
+	for (i = 0; i < objects; i++) {
+		if (unlikely(!p[i]))
+			continue;
+
+		page = virt_to_head_page(p[i]);
+		if (!page_has_obj_cgroups(page))
+			continue;
+
+		if (!s_orig)
+			s = page->slab_cache;
+		else
+			s = s_orig;
+
+		off = obj_to_index(s, page, p[i]);
+		objcg = page_obj_cgroups(page)[off];
+		if (!objcg)
+			continue;
+
+		page_obj_cgroups(page)[off] = NULL;
+		obj_cgroup_uncharge(objcg, obj_full_size(s));
+		mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
+				-obj_full_size(s));
+		obj_cgroup_put(objcg);
+	}
 }
 
 #else /* CONFIG_MEMCG_KMEM */
@@ -406,8 +418,8 @@ static inline void memcg_slab_post_alloc
 {
 }
 
-static inline void memcg_slab_free_hook(struct kmem_cache *s, struct page *page,
-					void *p)
+static inline void memcg_slab_free_hook(struct kmem_cache *s,
+					void **p, int objects)
 {
 }
 #endif /* CONFIG_MEMCG_KMEM */
--- a/mm/slub.c~mm-memcg-slab-uncharge-during-kmem_cache_free_bulk
+++ a/mm/slub.c
@@ -3095,7 +3095,7 @@ static __always_inline void do_slab_free
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	memcg_slab_free_hook(s, page, head);
+	memcg_slab_free_hook(s, &head, 1);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
@@ -3257,6 +3257,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 	if (WARN_ON(!size))
 		return;
 
+	memcg_slab_free_hook(s, p, size);
 	do {
 		struct detached_freelist df;
 
_
