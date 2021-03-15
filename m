Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9C533BC88
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhCOO0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhCOOZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE0165051;
        Mon, 15 Mar 2021 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818307;
        bh=LmaRk/sJmObyLW98Vd25innhe9ZWfKcVqYyv3A+ceZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLvvLKV2l7v/YVVuM975ouDNQQvsN6FjOBTVqZgHyfLp/2qEQa7dGs9Fon9LWhMLY
         x3TI45XxJ9RVTbGrgTL3l7ntEjq/NgNWVZCahs16t4fp8/A6d7jpXIqEZ5u6F2KwJC
         koDRDW0gZ0eT3KVpG9A6bl1wFvNwYc5BLlX3BvwM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Guanghui <zhouguanghui1@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Tianhong Ding <dingtianhong@huawei.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 304/306] mm/memcg: rename mem_cgroup_split_huge_fixup to split_page_memcg and add nr_pages argument
Date:   Mon, 15 Mar 2021 15:24:29 +0100
Message-Id: <20210315135517.977166756@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135517.556638562@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210315135517.556638562@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Zhou Guanghui <zhouguanghui1@huawei.com>

commit be6c8982e4ab9a41907555f601b711a7e2a17d4c upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |    6 ++----
 mm/huge_memory.c           |    2 +-
 mm/memcontrol.c            |   15 ++++++---------
 3 files changed, 9 insertions(+), 14 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1072,9 +1072,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head);
-#endif
+void split_page_memcg(struct page *head, unsigned int nr);
 
 #else /* CONFIG_MEMCG */
 
@@ -1416,7 +1414,7 @@ unsigned long mem_cgroup_soft_limit_recl
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2465,7 +2465,7 @@ static void __split_huge_page(struct pag
 	int i;
 
 	/* complete memcg works before add pages to LRU */
-	mem_cgroup_split_huge_fixup(head);
+	split_page_memcg(head, nr);
 
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry = { .val = page_private(head) };
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3296,24 +3296,21 @@ void obj_cgroup_uncharge(struct obj_cgro
 
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


