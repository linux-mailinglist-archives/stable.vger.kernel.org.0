Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749C62A58D3
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgKCUo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730941AbgKCUoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3AC223C6;
        Tue,  3 Nov 2020 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436294;
        bh=L09PQ0NKIh2/xPbztU0P+2cLViNX3IbYzZDIB6CpROE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJYKc9akaw1VHfsM8HPD0GCWWv6DmOyNRYr7I+OKUNm6dbpPn/mwZ1p0xTADkhmSj
         9Tw14UuVTx2GwKZwVjW8xZJyprwckrf0btxKGTUWJQY8T0M0gKEOuf6Tu82xgud2dg
         oxFin+8GhXXlK4Tdb73XWKaGhggxNg10cFx1E+hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 188/391] mm: memcg/slab: uncharge during kmem_cache_free_bulk()
Date:   Tue,  3 Nov 2020 21:33:59 +0100
Message-Id: <20201103203359.574280444@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharata B Rao <bharata@linux.ibm.com>

commit d1b2cf6cb84a9bd0de6f151512648dd1af82f80f upstream.

Object cgroup charging is done for all the objects during allocation, but
during freeing, uncharging ends up happening for only one object in the
case of bulk allocation/freeing.

Fix this by having a separate call to uncharge all the objects from
kmem_cache_free_bulk() and by modifying memcg_slab_free_hook() to take
care of bulk uncharging.

Fixes: 964d4bd370d5 ("mm: memcg/slab: save obj_cgroup for non-root slab objects"
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Link: https://lkml.kernel.org/r/20201009060423.390479-1-bharata@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab.c |    2 +-
 mm/slab.h |   50 +++++++++++++++++++++++++++++++-------------------
 mm/slub.c |    3 ++-
 3 files changed, 34 insertions(+), 21 deletions(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3440,7 +3440,7 @@ void ___cache_free(struct kmem_cache *ca
 		memset(objp, 0, cachep->object_size);
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
-	memcg_slab_free_hook(cachep, virt_to_head_page(objp), objp);
+	memcg_slab_free_hook(cachep, &objp, 1);
 
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
--- a/mm/slab.h
+++ b/mm/slab.h
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
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3091,7 +3091,7 @@ static __always_inline void do_slab_free
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	memcg_slab_free_hook(s, page, head);
+	memcg_slab_free_hook(s, &head, 1);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
@@ -3253,6 +3253,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 	if (WARN_ON(!size))
 		return;
 
+	memcg_slab_free_hook(s, p, size);
 	do {
 		struct detached_freelist df;
 


