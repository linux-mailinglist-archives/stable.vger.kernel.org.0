Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B66190328
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 02:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCXBGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 21:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgCXBGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 21:06:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6257720714;
        Tue, 24 Mar 2020 01:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585011994;
        bh=nkAaU5b3pOynaIIlMjxIm1aRxWKaQfp+QZvKhnVa+sE=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=HWzfjzUBiYLfTCpe6yT40lyJiEH4pT03ogcytuWMa2lWP+TZpLohXGQ4NH7oTZzkk
         CgEnnqksCVnPMNMInNc+SsAX9uDxHb7kQ2ZkRavRrjxsMp+D4BN+WH2WIGdy5Ipev/
         NUSke5sMT2a1zQdDITWBqMANk4JvoAUqirOsy0EQ=
Date:   Mon, 23 Mar 2020 18:06:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various
 stack implementations
Message-Id: <20200323180633.5e75654282d076d74766bd88@linux-foundation.org>
In-Reply-To: <20200323180358.7603217aa9955f298255da4e@linux-foundation.org>
References: <20200303233550.251375-1-guro@fb.com>
        <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
        <20200324004221.GA36662@carbon.dhcp.thefacebook.com>
        <20200323180358.7603217aa9955f298255da4e@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Mar 2020 18:03:58 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Mar 2020 17:42:21 -0700 Roman Gushchin <guro@fb.com> wrote:
> 
> > How about this one? I've merged them into one and stripped it a little bit.
> > 
> > Thanks!
> > 
> 
> Yes, that looks good.  Here's the delta from the previously reviewed
> version.  I think it's valid to retain those acks and revewed-by's.
> 
> 

And here's the altered "mm: memcg/slab: introduce
mem_cgroup_from_obj()", which I have renamed to "mm: memcg/slab: use
mem_cgroup_from_obj()":

The end result is slightly different - mem_cgroup_from_obj() will now
end up inside #ifdef CONFIG_MEMCG_KMEM.  Should I undo that?


From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: use mem_cgroup_from_obj()

Sometimes we need to get a memcg pointer from a charged kernel object. 
The right way to get it depends on whether it's a proper slab object or
it's backed by raw pages (e.g.  it's a vmalloc alloction).  In the first
case the kmem_cache->memcg_params.memcg indirection should be used; in
other cases it's just page->mem_cgroup.

To simplify this task and hide the implementation details let's use the
mem_cgroup_from_obj() helper, which takes a pointer to any kernel object
and returns a valid memcg pointer or NULL.

Passing a kernel address rather than a pointer to a page will allow to use
this helper for per-object (rather than per-page) tracked objects in the
future.

The caller is still responsible to ensure that the returned memcg isn't
going away underneath: take the rcu read lock, cgroup mutex etc; depending
on the context.

mem_cgroup_from_kmem() defined in mm/list_lru.c is now obsolete and can be
removed.

Link: http://lkml.kernel.org/r/20200117203609.3146239-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c   |   12 +-----------
 mm/memcontrol.c |    5 ++---
 2 files changed, 3 insertions(+), 14 deletions(-)

--- a/mm/list_lru.c~mm-memcg-slab-introduce-mem_cgroup_from_obj
+++ a/mm/list_lru.c
@@ -57,16 +57,6 @@ list_lru_from_memcg_idx(struct list_lru_
 	return &nlru->lru;
 }
 
-static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	struct page *page;
-
-	if (!memcg_kmem_enabled())
-		return NULL;
-	page = virt_to_head_page(ptr);
-	return memcg_from_slab_page(page);
-}
-
 static inline struct list_lru_one *
 list_lru_from_kmem(struct list_lru_node *nlru, void *ptr,
 		   struct mem_cgroup **memcg_ptr)
@@ -77,7 +67,7 @@ list_lru_from_kmem(struct list_lru_node
 	if (!nlru->memcg_lrus)
 		goto out;
 
-	memcg = mem_cgroup_from_kmem(ptr);
+	memcg = mem_cgroup_from_obj(ptr);
 	if (!memcg)
 		goto out;
 
--- a/mm/memcontrol.c~mm-memcg-slab-introduce-mem_cgroup_from_obj
+++ a/mm/memcontrol.c
@@ -759,13 +759,12 @@ void __mod_lruvec_state(struct lruvec *l
 
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 {
-	struct page *page = virt_to_head_page(p);
-	pg_data_t *pgdat = page_pgdat(page);
+	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = memcg_from_slab_page(page);
+	memcg = mem_cgroup_from_obj(p);
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg || memcg == root_mem_cgroup) {
_

