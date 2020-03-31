Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B7199019
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbgCaJJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbgCaJJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:09:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D394C20B1F;
        Tue, 31 Mar 2020 09:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645743;
        bh=gJXCPdAm6kytCWXBKwOUdWR72qRSaKL9kkbp0X+2k2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzjvFqHM5HybEgcqsgn+DPNr+BbnIonzz+VfhFC3rcDlv6akwMS+Ws7yH339vu9Qo
         Wpw6SsyDcpDtrx+Yr/h0m5RTXhw607cwvE9iYo3xbFrM/tCgFdfHz3mBjeb45NCcWD
         dRmdXlXS41DYcdVDkQrEeuMCu3iDphcuYzziuU8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 114/170] mm: fork: fix kernel_stack memcg stats for various stack implementations
Date:   Tue, 31 Mar 2020 10:58:48 +0200
Message-Id: <20200331085436.270978792@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit 8380ce479010f2f779587b462a9b4681934297c3 upstream.

Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio the
space for task stacks can be allocated using __vmalloc_node_range(),
alloc_pages_node() and kmem_cache_alloc_node().

In the first and the second cases page->mem_cgroup pointer is set, but
in the third it's not: memcg membership of a slab page should be
determined using the memcg_from_slab_page() function, which looks at
page->slab_cache->memcg_params.memcg .  In this case, using
mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
page->mem_cgroup pointer is NULL even for pages charged to a non-root
memory cgroup.

It can lead to kernel_stack per-memcg counters permanently showing 0 on
some architectures (depending on the configuration).

In order to fix it, let's introduce a mod_memcg_obj_state() helper,
which takes a pointer to a kernel object as a first argument, uses
mem_cgroup_from_obj() to get a RCU-protected memcg pointer and calls
mod_memcg_state().  It allows to handle all possible configurations
(CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE values) without
spilling any memcg/kmem specifics into fork.c .

Note: This is a special version of the patch created for stable
backports.  It contains code from the following two patches:
  - mm: memcg/slab: introduce mem_cgroup_from_obj()
  - mm: fork: fix kernel_stack memcg stats for various stack implementations

[guro@fb.com: introduce mem_cgroup_from_obj()]
  Link: http://lkml.kernel.org/r/20200324004221.GA36662@carbon.dhcp.thefacebook.com
Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200303233550.251375-1-guro@fb.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/memcontrol.h |   12 ++++++++++++
 kernel/fork.c              |    4 ++--
 mm/memcontrol.c            |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -695,6 +695,7 @@ static inline unsigned long lruvec_page_
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void mod_memcg_obj_state(void *p, int idx, int val);
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
@@ -1123,6 +1124,10 @@ static inline void __mod_lruvec_slab_sta
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
+static inline void mod_memcg_obj_state(void *p, int idx, int val)
+{
+}
+
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
@@ -1427,6 +1432,8 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1468,6 +1475,11 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -397,8 +397,8 @@ static void account_kernel_stack(struct
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
-				     account * (THREAD_SIZE / 1024));
+		mod_memcg_obj_state(stack, MEMCG_KERNEL_STACK_KB,
+				    account * (THREAD_SIZE / 1024));
 	}
 }
 
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -777,6 +777,17 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_unlock();
 }
 
+void mod_memcg_obj_state(void *p, int idx, int val)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
+}
+
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
@@ -2661,6 +2672,33 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	struct page *page;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	page = virt_to_head_page(p);
+
+	/*
+	 * Slab pages don't have page->mem_cgroup set because corresponding
+	 * kmem caches can be reparented during the lifetime. That's why
+	 * memcg_from_slab_page() should be used instead.
+	 */
+	if (PageSlab(page))
+		return memcg_from_slab_page(page);
+
+	/* All other pages use page->mem_cgroup */
+	return page->mem_cgroup;
+}
+
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;


