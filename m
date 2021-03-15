Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8B333C4C7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhCORtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237213AbhCORst (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B7264F07;
        Mon, 15 Mar 2021 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830529;
        bh=Re0/mlvUgRwYeG+u2dvNfKtdx7dNoSOhRBet1PdIV5Y=;
        h=Date:From:To:Subject:From;
        b=ASt5X4025E5z7+Q1r50knkreOnNcXvXbgF2P8Mlwzehva2T23kGKnV4X/jLmTdY5P
         h8g5hF9pPH4Z5JsqeQGLgFioSy4+zXyKHplOnlPpgaSKexN4rv7b+cvSEhFQE9swAz
         Pz6fJ+aljiBdpqHxfChesFFBbi34J5tVkpHGqLDU=
Date:   Mon, 15 Mar 2021 10:48:48 -0700
From:   akpm@linux-foundation.org
To:     chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        rui.xiang@huawei.com, shakeelb@google.com, stable@vger.kernel.org,
        wangkefeng.wang@huawei.com, zhouguanghui1@huawei.com,
        ziy@nvidia.com
Subject:  [merged]
 mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch
 removed from -mm tree
Message-ID: <20210315174848.UqwGSbPhq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcg: rename mem_cgroup_split_huge_fixup to split_page_memcg and add nr_pages argument
has been removed from the -mm tree.  Its filename was
     mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Subject: mm/memcg: rename mem_cgroup_split_huge_fixup to split_page_memcg and add nr_pages argument

Rename mem_cgroup_split_huge_fixup to split_page_memcg and explicitly pass
in page number argument.

In this way, the interface name is more common and can be used by
potential users.  In addition, the complete info(memcg and flag) of the
memcg needs to be set to the tail pages.

Link: https://lkml.kernel.org/r/20210304074053.65527-2-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 mm/huge_memory.c           |    2 +-
 mm/memcontrol.c            |   15 ++++++---------
 3 files changed, 9 insertions(+), 14 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1061,9 +1061,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head);
-#endif
+void split_page_memcg(struct page *head, unsigned int nr);
 
 #else /* CONFIG_MEMCG */
 
@@ -1400,7 +1398,7 @@ unsigned long mem_cgroup_soft_limit_recl
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
--- a/mm/huge_memory.c~mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg
+++ a/mm/huge_memory.c
@@ -2467,7 +2467,7 @@ static void __split_huge_page(struct pag
 	int i;
 
 	/* complete memcg works before add pages to LRU */
-	mem_cgroup_split_huge_fixup(head);
+	split_page_memcg(head, nr);
 
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry = { .val = page_private(head) };
--- a/mm/memcontrol.c~mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3287,24 +3287,21 @@ void obj_cgroup_uncharge(struct obj_cgro
 
 #endif /* CONFIG_MEMCG_KMEM */
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * Because page_memcg(head) is not set on compound tails, set it now.
+ * Because page_memcg(head) is not set on tails, set it now.
  */
-void mem_cgroup_split_huge_fixup(struct page *head)
+void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct mem_cgroup *memcg = page_memcg(head);
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
-		css_get(&memcg->css);
-		head[i].memcg_data = (unsigned long)memcg;
-	}
+	for (i = 1; i < nr; i++)
+		head[i].memcg_data = head->memcg_data;
+	css_get_many(&memcg->css, nr - 1);
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_MEMCG_SWAP
 /**
_

Patches currently in -mm which might be from zhouguanghui1@huawei.com are


