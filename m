Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22472ED24A
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbhAGOcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbhAGOc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2191A208A9;
        Thu,  7 Jan 2021 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029888;
        bh=f4vhq9KKECt90I+ZBtZ2i5ARE0XL8YZKLdTxRXOPHJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtbQEUuXY37wOueB5g1oAIfzwOKTtbeZzTuiGYLVwt5gdyVXmlehuGMZxv94H+qXI
         K3UWHnm6DLJswgSBO/WEO9p0i+9hOjdbPiCnTxKvvXVwnB9p5GEbPqt7jJtt53zWlQ
         9zkqIF6gouWlabxnHHPcoS3MHTmbw7SicX1zQdFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 4.14 07/29] mm: memcontrol: implement lruvec stat functions on top of each other
Date:   Thu,  7 Jan 2021 15:31:22 +0100
Message-Id: <20210107143053.956822483@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit 284542656e22c43fdada8c8cc0ca9ede8453eed7 upstream

The implementation of the lruvec stat functions and their variants for
accounting through a page, or accounting from a preemptible context, are
mostly identical and needlessly repetitive.

Implement the lruvec_page functions by looking up the page's lruvec and
then using the lruvec function.

Implement the functions for preemptible contexts by disabling preemption
before calling the atomic context functions.

Link: http://lkml.kernel.org/r/20171103153336.24044-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -569,51 +569,51 @@ static inline void __mod_lruvec_state(st
 {
 	struct mem_cgroup_per_node *pn;
 
+	/* Update node */
 	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+
 	if (mem_cgroup_disabled())
 		return;
+
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+
+	/* Update memcg */
 	__mod_memcg_state(pn->memcg, idx, val);
+
+	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stat->count[idx], val);
 }
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-	if (mem_cgroup_disabled())
-		return;
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	mod_memcg_state(pn->memcg, idx, val);
-	this_cpu_add(pn->lruvec_stat->count[idx], val);
+	preempt_disable();
+	__mod_lruvec_state(lruvec, idx, val);
+	preempt_enable();
 }
 
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
+	pg_data_t *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
 
-	__mod_node_page_state(page_pgdat(page), idx, val);
-	if (mem_cgroup_disabled() || !page->mem_cgroup)
+	/* Untracked pages have no memcg, no lruvec. Update only the node */
+	if (!page->mem_cgroup) {
+		__mod_node_page_state(pgdat, idx, val);
 		return;
-	__mod_memcg_state(page->mem_cgroup, idx, val);
-	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
-	__this_cpu_add(pn->lruvec_stat->count[idx], val);
+	}
+
+	lruvec = mem_cgroup_lruvec(pgdat, page->mem_cgroup);
+	__mod_lruvec_state(lruvec, idx, val);
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-
-	mod_node_page_state(page_pgdat(page), idx, val);
-	if (mem_cgroup_disabled() || !page->mem_cgroup)
-		return;
-	mod_memcg_state(page->mem_cgroup, idx, val);
-	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
-	this_cpu_add(pn->lruvec_stat->count[idx], val);
+	preempt_disable();
+	__mod_lruvec_page_state(page, idx, val);
+	preempt_enable();
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,


