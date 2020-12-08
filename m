Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFB22D1F3E
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 01:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgLHAqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 19:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgLHAqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 19:46:53 -0500
Date:   Mon, 07 Dec 2020 16:46:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388372;
        bh=igobVAQfvkFD6xzp7vzKXlZMUmLS1WhfTL2osG20Gy8=;
        h=From:To:Subject:From;
        b=oKgGt65wMGVvn7jhvavkqj1z/Gu1GMMWO85YPfbTv4xmok9tuuZrMN7L4rS9RtSZy
         TtebVrILnPxEMGG/yuHuPuw5hY564+IaFK09ZC31fy0GH/caMtaRPNImtZPF0sLqOQ
         9faIRXKjGkjuJcYPbZkYx+yeJMtvAoTRjYMbONfQ=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch removed
 from -mm tree
Message-ID: <20201208004612.q2WeJNYNf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix obj_cgroup_charge() return value handling
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: fix obj_cgroup_charge() return value handling

Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for
all allocations") introduced a regression into the handling of the
obj_cgroup_charge() return value.  If a non-zero value is returned
(indicating of exceeding one of memory.max limits), the allocation should
fail, instead of falling back to non-accounted mode.

To make the code more readable, move memcg_slab_pre_alloc_hook() and
memcg_slab_post_alloc_hook() calling conditions into bodies of these
hooks.

Link: https://lkml.kernel.org/r/20201127161828.GD840171@carbon.dhcp.thefacebook.com
Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/mm/slab.h~mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling
+++ a/mm/slab.h
@@ -274,22 +274,32 @@ static inline size_t obj_full_size(struc
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
@@ -315,7 +325,7 @@ static inline void memcg_slab_post_alloc
 	unsigned long off;
 	size_t i;
 
-	if (!objcg)
+	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
 	flags &= ~__GFP_ACCOUNT;
@@ -400,11 +410,11 @@ static inline void memcg_free_page_obj_c
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
@@ -508,9 +518,8 @@ static inline struct kmem_cache *slab_pr
 	if (should_failslab(s, flags))
 		return NULL;
 
-	if (memcg_kmem_enabled() &&
-	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		*objcgp = memcg_slab_pre_alloc_hook(s, size, flags);
+	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+		return NULL;
 
 	return s;
 }
@@ -529,8 +538,7 @@ static inline void slab_post_alloc_hook(
 					 s->flags, flags);
 	}
 
-	if (memcg_kmem_enabled())
-		memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
+	memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
 }
 
 #ifndef CONFIG_SLOB
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-fix-obsolete-code-comments.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

