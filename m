Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FE42E6D57
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 03:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgL2Cgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 21:36:43 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46530 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbgL2Cgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 21:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609209402; x=1640745402;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=WNvD9PeP/CVjLO9t9rENFYHz763kp8LfoAEiMgG+6j0=;
  b=hMur5EEmCd+PA3ThzmhhGvDBQJXOyK1d5/40+b2aWelOM3Y4EYjr4K4+
   sQQtZ232MmJOPT0f1sygXlYYMxNUx7IPxK4B896fklXLdxToFlr6huuHh
   epAtwTdWjefcFxDsrFsXvX2pdfKjdzf1kPa0BlSgMelhA1feMZBCd6NCs
   c=;
X-IronPort-AV: E=Sophos;i="5.78,456,1599523200"; 
   d="scan'208";a="75556085"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 Dec 2020 02:36:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 99B27A1E8A
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 02:36:00 +0000 (UTC)
Received: from EX13D46UWB003.ant.amazon.com (10.43.161.117) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 29 Dec 2020 02:35:59 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D46UWB003.ant.amazon.com (10.43.161.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 29 Dec 2020 02:35:59 +0000
Received: from dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (172.22.152.76)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 29 Dec 2020 02:35:59 +0000
Received: by dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 8711B452F4; Tue, 29 Dec 2020 02:35:58 +0000 (UTC)
Date:   Tue, 29 Dec 2020 02:35:58 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <shaoyi@amazon.com>, <surajjs@amazon.com>
Subject: [PATCH 4.14 2/3] mm: memcontrol: implement lruvec stat functions on
 top of each other
Message-ID: <20201229023558.GA25485@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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
---
 include/linux/memcontrol.h | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2c80b69dd266..1ffc54ac4cc9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -569,51 +569,51 @@ static inline void __mod_lruvec_state(struct lruvec *lruvec,
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
-- 
2.16.6

