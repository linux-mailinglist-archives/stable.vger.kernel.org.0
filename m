Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6523ECF1B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhHPHNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13326 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbhHPHNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gp53G031Tz86mP;
        Mon, 16 Aug 2021 15:12:58 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:50 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:49 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Chen Huang <chenhuang5@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10.y 09/11] mm: memcontrol: inline __memcg_kmem_{un}charge() into obj_cgroup_{un}charge_pages()
Date:   Mon, 16 Aug 2021 07:21:45 +0000
Message-ID: <20210816072147.3481782-10-chenhuang5@huawei.com>
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

There is only one user of __memcg_kmem_charge(), so manually inline
__memcg_kmem_charge() to obj_cgroup_charge_pages().  Similarly manually
inline __memcg_kmem_uncharge() into obj_cgroup_uncharge_pages() and call
obj_cgroup_uncharge_pages() in obj_cgroup_release().

This is just code cleanup without any functionality changes.

Link: https://lkml.kernel.org/r/20210319163821.20704-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Conflicts:
	mm/memcontrol.c
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 mm/memcontrol.c | 60 +++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 738051c79cdd..8932f986bf2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -252,6 +252,9 @@ struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
 #ifdef CONFIG_MEMCG_KMEM
 extern spinlock_t css_set_lock;
 
+static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
+				      unsigned int nr_pages);
+
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
@@ -287,7 +290,7 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	spin_lock_irqsave(&css_set_lock, flags);
 	memcg = obj_cgroup_memcg(objcg);
 	if (nr_pages)
-		__memcg_kmem_uncharge(memcg, nr_pages);
+		obj_cgroup_uncharge_pages(objcg, nr_pages);
 	list_del(&objcg->list);
 	mem_cgroup_put(memcg);
 	spin_unlock_irqrestore(&css_set_lock, flags);
@@ -3018,46 +3021,45 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+/*
+ * obj_cgroup_uncharge_pages: uncharge a number of kernel pages from a objcg
+ * @objcg: object cgroup to uncharge
+ * @nr_pages: number of pages to uncharge
+ */
 static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 				      unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
-	__memcg_kmem_uncharge(memcg, nr_pages);
-	css_put(&memcg->css);
-}
 
-static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
-				   unsigned int nr_pages)
-{
-	struct mem_cgroup *memcg;
-	int ret;
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		page_counter_uncharge(&memcg->kmem, nr_pages);
+	refill_stock(memcg, nr_pages);
 
-	memcg = get_mem_cgroup_from_objcg(objcg);
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
 	css_put(&memcg->css);
-
-	return ret;
 }
 
-/**
- * __memcg_kmem_charge: charge a number of kernel pages to a memcg
- * @memcg: memory cgroup to charge
+/*
+ * obj_cgroup_charge_pages: charge a number of kernel pages to a objcg
+ * @objcg: object cgroup to charge
  * @gfp: reclaim mode
  * @nr_pages: number of pages to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			unsigned int nr_pages)
+static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
+				   unsigned int nr_pages)
 {
 	struct page_counter *counter;
+	struct mem_cgroup *memcg;
 	int ret;
 
+	memcg = get_mem_cgroup_from_objcg(objcg);
+
 	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
@@ -3069,25 +3071,15 @@ int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
 		 */
 		if (gfp & __GFP_NOFAIL) {
 			page_counter_charge(&memcg->kmem, nr_pages);
-			return 0;
+			goto out;
 		}
 		cancel_charge(memcg, nr_pages);
-		return -ENOMEM;
+		ret = -ENOMEM;
 	}
-	return 0;
-}
-
-/**
- * __memcg_kmem_uncharge: uncharge a number of kernel pages from a memcg
- * @memcg: memcg to uncharge
- * @nr_pages: number of pages to uncharge
- */
-void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_uncharge(&memcg->kmem, nr_pages);
+out:
+	css_put(&memcg->css);
 
-	refill_stock(memcg, nr_pages);
+	return ret;
 }
 
 /**
-- 
2.18.0.huawei.25

