Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967BC3ECF09
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhHPHNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:22 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13323 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhHPHNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gp52y4g8wz85rx;
        Mon, 16 Aug 2021 15:12:42 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:47 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:47 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Chen Huang <chenhuang5@huawei.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "Xiongchun Duan" <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10.y 05/11] mm: memcontrol: introduce obj_cgroup_{un}charge_pages
Date:   Mon, 16 Aug 2021 07:21:41 +0000
Message-ID: <20210816072147.3481782-6-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20210816072147.3481782-1-chenhuang5@huawei.com>
References: <20210816072147.3481782-1-chenhuang5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema756-chm.china.huawei.com (10.1.198.198)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

We know that the unit of slab object charging is bytes, the unit of kmem
page charging is PAGE_SIZE.  If we want to reuse obj_cgroup APIs to
charge the kmem pages, we should pass PAGE_SIZE (as third parameter) to
obj_cgroup_charge().  Because the size is already PAGE_SIZE, we can skip
touch the objcg stock.  And obj_cgroup_{un}charge_pages() are introduced
to charge in units of page level.

In the latter patch, we also can reuse those two helpers to charge or
uncharge a number of kernel pages to a object cgroup.  This is just a
code movement without any functional changes.

Link: https://lkml.kernel.org/r/20210319163821.20704-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 mm/memcontrol.c | 63 +++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index abeaf5cede74..d45c2c97d9b8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2888,6 +2888,20 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 	page->memcg_data = (unsigned long)memcg;
 }
 
+static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+retry:
+	memcg = obj_cgroup_memcg(objcg);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
+	rcu_read_unlock();
+
+	return memcg;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * The allocated objcg pointers array is not accounted directly.
@@ -3032,6 +3046,29 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
+				      unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	__memcg_kmem_uncharge(memcg, nr_pages);
+	css_put(&memcg->css);
+}
+
+static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
+				   unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
 /**
  * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
@@ -3156,19 +3193,8 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
-		if (nr_pages) {
-			struct mem_cgroup *memcg;
-
-			rcu_read_lock();
-retry:
-			memcg = obj_cgroup_memcg(old);
-			if (unlikely(!css_tryget(&memcg->css)))
-				goto retry;
-			rcu_read_unlock();
-
-			__memcg_kmem_uncharge(memcg, nr_pages);
-			css_put(&memcg->css);
-		}
+		if (nr_pages)
+			obj_cgroup_uncharge_pages(old, nr_pages);
 
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.
@@ -3226,7 +3252,6 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 {
-	struct mem_cgroup *memcg;
 	unsigned int nr_pages, nr_bytes;
 	int ret;
 
@@ -3243,24 +3268,16 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * refill_obj_stock(), called from this function or
 	 * independently later.
 	 */
-	rcu_read_lock();
-retry:
-	memcg = obj_cgroup_memcg(objcg);
-	if (unlikely(!css_tryget(&memcg->css)))
-		goto retry;
-	rcu_read_unlock();
-
 	nr_pages = size >> PAGE_SHIFT;
 	nr_bytes = size & (PAGE_SIZE - 1);
 
 	if (nr_bytes)
 		nr_pages += 1;
 
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
 	if (!ret && nr_bytes)
 		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
 
-	css_put(&memcg->css);
 	return ret;
 }
 
-- 
2.18.0.huawei.25

