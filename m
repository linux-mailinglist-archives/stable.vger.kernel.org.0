Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8273D289BE5
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 00:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389986AbgJIWpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 18:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388159AbgJIWpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 18:45:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFCB6222C3;
        Fri,  9 Oct 2020 22:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602283506;
        bh=IxEqZRkPAqh68aChGyrp+I9s04+UqS0TtgGna8UtdtY=;
        h=Date:From:To:Subject:From;
        b=DN68gTavAtWlT/sTYeYbozxA9Ozstiq84LmdjzyGRtYFvIpUIeB5iP+OAXkv6fgml
         YGlyCNn5yLmzR/XRLjlaWsO5Wt5PJ4fNLC4yO/TNXcRUcwIV1ng6hQhinXrrV7Zqa3
         2YWIRjSIP/Js6fQU6ywUnjDFxoYBzzza+g6mHVX8=
Date:   Fri, 09 Oct 2020 15:45:05 -0700
From:   akpm@linux-foundation.org
To:     bharata@linux.ibm.com, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, stable@vger.kernel.org, tj@kernel.org,
        vbabka@suse.cz
Subject:  +
 mm-memcg-slab-uncharge-during-kmem_cache_free_bulk.patch added to -mm tree
Message-ID: <20201009224505.kVHC2Upzb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: uncharge during kmem_cache_free_bulk()
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-uncharge-during-kmem_cache_free_bulk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-uncharge-during-kmem_cache_free_bulk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-uncharge-during-kmem_cache_free_bulk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Roman Gushchin <guro@fb.com>
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

Patches currently in -mm which might be from bharata@linux.ibm.com are

mm-memcg-slab-uncharge-during-kmem_cache_free_bulk.patch

