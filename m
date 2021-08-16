Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97C73ECF10
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhHPHN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:27 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8420 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbhHPHNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gp4yV1LN2z881X;
        Mon, 16 Aug 2021 15:08:50 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:51 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:50 +0800
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
Subject: [PATCH 5.10.y 10/11] mm: memcontrol: move PageMemcgKmem to the scope of CONFIG_MEMCG_KMEM
Date:   Mon, 16 Aug 2021 07:21:46 +0000
Message-ID: <20210816072147.3481782-11-chenhuang5@huawei.com>
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

The page only can be marked as kmem when CONFIG_MEMCG_KMEM is enabled.
So move PageMemcgKmem() to the scope of the CONFIG_MEMCG_KMEM.

As a bonus, on !CONFIG_MEMCG_KMEM build some code can be compiled out.

Link: https://lkml.kernel.org/r/20210319163821.20704-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 include/linux/memcontrol.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b8bb5d37d4ad..f07463cf7dac 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -506,6 +506,7 @@ static inline struct mem_cgroup *page_memcg_check(struct page *page)
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 /*
  * PageMemcgKmem - check if the page has MemcgKmem flag set
  * @page: a pointer to the page struct
@@ -520,7 +521,6 @@ static inline bool PageMemcgKmem(struct page *page)
 	return page->memcg_data & MEMCG_DATA_KMEM;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 /*
  * page_objcgs - get the object cgroups vector associated with a page
  * @page: a pointer to the page struct
@@ -575,6 +575,11 @@ static inline bool set_page_objcgs(struct page *page,
 			MEMCG_DATA_OBJCGS);
 }
 #else
+static inline bool PageMemcgKmem(struct page *page)
+{
+	return false;
+}
+
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
 	return NULL;
-- 
2.18.0.huawei.25

