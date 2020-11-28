Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7602C703D
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 18:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbgK1Rz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 12:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732425AbgK1EVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 23:21:22 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFF4B2222C;
        Sat, 28 Nov 2020 03:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606535717;
        bh=eKzbgkZcjfsjpKMY2EDpGY2K1+EjiqoBkxWUnDWGdO0=;
        h=Date:From:To:Subject:From;
        b=U2GHE3L5Y/8JmC3QTHkRuxR4xmRtufaWuDX8/evCQ9I5oMZM+kwLX3+WzLLtPpIF2
         riVhJF+wmbyfZc3wZqvINt6SWBUvWKq3fo8BGLhnqxlDK7bjBvBfALLxyroOIb0MRc
         bgZPY3QqAmei7bynbrrV6ke0gcuxSLTgGmiw38u4=
Date:   Fri, 27 Nov 2020 19:55:16 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org
Subject:  +
 mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch added to
 -mm tree
Message-ID: <20201128035516.7u-KfyWb8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix obj_cgroup_charge() return value handling
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Shakeel Butt <shakeelb@google.com>
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

mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

