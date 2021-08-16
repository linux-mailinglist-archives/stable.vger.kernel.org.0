Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54963ECF0D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhHPHNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:24 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13324 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhHPHNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gp52z6xdZz86X8;
        Mon, 16 Aug 2021 15:12:43 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:49 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:48 +0800
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
Subject: [PATCH 5.10.y 07/11] mm: memcontrol: change ug->dummy_page only if memcg changed
Date:   Mon, 16 Aug 2021 07:21:43 +0000
Message-ID: <20210816072147.3481782-8-chenhuang5@huawei.com>
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

Just like assignment to ug->memcg, we only need to update ug->dummy_page
if memcg changed.  So move it to there.  This is a very small
optimization.

Link: https://lkml.kernel.org/r/20210319163821.20704-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d45c2c97d9b8..73418413958c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6907,6 +6907,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->memcg = page_memcg(page);
+		ug->dummy_page = page;
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
@@ -6920,7 +6921,6 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 	else
 		ug->pgpgout++;
 
-	ug->dummy_page = page;
 	page->memcg_data = 0;
 	css_put(&ug->memcg->css);
 }
-- 
2.18.0.huawei.25

