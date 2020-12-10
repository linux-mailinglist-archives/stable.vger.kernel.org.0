Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675C52D602C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbgLJOjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391245AbgLJOjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:44 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 58/75] mm: memcg/slab: fix obj_cgroup_charge() return value handling
Date:   Thu, 10 Dec 2020 15:27:23 +0100
Message-Id: <20201210142608.910717022@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit becaba65f62f88e553ec92ed98370e9d2b18e629 upstream.

Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
for all allocations") introduced a regression into the handling of the
obj_cgroup_charge() return value.  If a non-zero value is returned
(indicating of exceeding one of memory.max limits), the allocation
should fail, instead of falling back to non-accounted mode.

To make the code more readable, move memcg_slab_pre_alloc_hook() and
memcg_slab_post_alloc_hook() calling conditions into bodies of these
hooks.

Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201127161828.GD840171@carbon.dhcp.thefacebook.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.h |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -275,25 +275,35 @@ static inline size_t obj_full_size(struc
 	return s->size + sizeof(struct obj_cgroup *);
 }
 
-static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
-							   size_t objects,
-							   gfp_t flags)
+/*
+ * Returns false if the allocation should fail.
+ */
+static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct obj_cgroup **objcgp,
+					     size_t objects, gfp_t flags)
 {
 	struct obj_cgroup *objcg;
 
+	if (!memcg_kmem_enabled())
+		return true;
+
+	if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
+		return true;
+
 	if (memcg_kmem_bypass())
-		return NULL;
+		return true;
 
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
-		return NULL;
+		return true;
 
 	if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))) {
 		obj_cgroup_put(objcg);
-		return NULL;
+		return false;
 	}
 
-	return objcg;
+	*objcgp = objcg;
+	return true;
 }
 
 static inline void mod_objcg_state(struct obj_cgroup *objcg,
@@ -319,7 +329,7 @@ static inline void memcg_slab_post_alloc
 	unsigned long off;
 	size_t i;
 
-	if (!objcg)
+	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
 	flags &= ~__GFP_ACCOUNT;
@@ -404,11 +414,11 @@ static inline void memcg_free_page_obj_c
 {
 }
 
-static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
-							   size_t objects,
-							   gfp_t flags)
+static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct obj_cgroup **objcgp,
+					     size_t objects, gfp_t flags)
 {
-	return NULL;
+	return true;
 }
 
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
@@ -512,9 +522,8 @@ static inline struct kmem_cache *slab_pr
 	if (should_failslab(s, flags))
 		return NULL;
 
-	if (memcg_kmem_enabled() &&
-	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		*objcgp = memcg_slab_pre_alloc_hook(s, size, flags);
+	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+		return NULL;
 
 	return s;
 }
@@ -533,8 +542,7 @@ static inline void slab_post_alloc_hook(
 					 s->flags, flags);
 	}
 
-	if (memcg_kmem_enabled())
-		memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
+	memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
 }
 
 #ifndef CONFIG_SLOB


