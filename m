Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FA93ECF12
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhHPHNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8023 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhHPHN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:28 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gp52m5XqkzYq71;
        Mon, 16 Aug 2021 15:12:32 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:51 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:51 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Chen Huang <chenhuang5@huawei.com>,
        "Christoph Lameter" <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10.y 11/11] mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()
Date:   Mon, 16 Aug 2021 07:21:47 +0000
Message-ID: <20210816072147.3481782-12-chenhuang5@huawei.com>
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

From: Wang Hai <wanghai38@huawei.com>

When I use kfree_rcu() to free a large memory allocated by kmalloc_node(),
the following dump occurs.

  BUG: kernel NULL pointer dereference, address: 0000000000000020
  [...]
  Oops: 0000 [#1] SMP
  [...]
  Workqueue: events kfree_rcu_work
  RIP: 0010:__obj_to_index include/linux/slub_def.h:182 [inline]
  RIP: 0010:obj_to_index include/linux/slub_def.h:191 [inline]
  RIP: 0010:memcg_slab_free_hook+0x120/0x260 mm/slab.h:363
  [...]
  Call Trace:
    kmem_cache_free_bulk+0x58/0x630 mm/slub.c:3293
    kfree_bulk include/linux/slab.h:413 [inline]
    kfree_rcu_work+0x1ab/0x200 kernel/rcu/tree.c:3300
    process_one_work+0x207/0x530 kernel/workqueue.c:2276
    worker_thread+0x320/0x610 kernel/workqueue.c:2422
    kthread+0x13d/0x160 kernel/kthread.c:313
    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

When kmalloc_node() a large memory, page is allocated, not slab, so when
freeing memory via kfree_rcu(), this large memory should not be used by
memcg_slab_free_hook(), because memcg_slab_free_hook() is is used for
slab.

Using page_objcgs_check() instead of page_objcgs() in
memcg_slab_free_hook() to fix this bug.

Link: https://lkml.kernel.org/r/20210728145655.274476-1-wanghai38@huawei.com
Fixes: 270c6a71460e ("mm: memcontrol/slab: Use helpers to access slab page's memcg_data")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 mm/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 571757eb4a8f..9759992c720c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -349,7 +349,7 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 			continue;
 
 		page = virt_to_head_page(p[i]);
-		objcgs = page_objcgs(page);
+		objcgs = page_objcgs_check(page);
 		if (!objcgs)
 			continue;
 
-- 
2.18.0.huawei.25

