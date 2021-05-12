Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F55C37CF2B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343781AbhELRJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244650AbhELQu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45A0D61C82;
        Wed, 12 May 2021 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836243;
        bh=EJcE5JDRfV4iUHKPcnVxIvVXWmWC/mHM0lQ78IWIRFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nokwq0NQMzps1JoWVnQLXwq8/yI/osa8R/Z2c0YVU0mG5lab3vLKaJRBfZvTksIbE
         sDiu9f4tP66lp0UObj87W0GsBH4Q1fzt+TxHsapakQBJQE6gAFnf4zWO2X/8ki9n7P
         jqjFA3jTFTw7YBrRYWa7HUSPaoYOuiXK8SzaRPUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 667/677] mm: memcontrol: slab: fix obtain a reference to a freeing memcg
Date:   Wed, 12 May 2021 16:51:53 +0200
Message-Id: <20210512144859.524551274@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 9f38f03ae8d5f57371b71aa6b4275765b65454fd ]

Patch series "Use obj_cgroup APIs to charge kmem pages", v5.

Since Roman's series "The new cgroup slab memory controller" applied.
All slab objects are charged with the new APIs of obj_cgroup.  The new
APIs introduce a struct obj_cgroup to charge slab objects.  It prevents
long-living objects from pinning the original memory cgroup in the
memory.  But there are still some corner objects (e.g.  allocations
larger than order-1 page on SLUB) which are not charged with the new
APIs.  Those objects (include the pages which are allocated from buddy
allocator directly) are charged as kmem pages which still hold a
reference to the memory cgroup.

E.g.  We know that the kernel stack is charged as kmem pages because the
size of the kernel stack can be greater than 2 pages (e.g.  16KB on
x86_64 or arm64).  If we create a thread (suppose the thread stack is
charged to memory cgroup A) and then move it from memory cgroup A to
memory cgroup B.  Because the kernel stack of the thread hold a
reference to the memory cgroup A.  The thread can pin the memory cgroup
A in the memory even if we remove the cgroup A.  If we want to see this
scenario by using the following script.  We can see that the system has
added 500 dying cgroups (This is not a real world issue, just a script
to show that the large kmallocs are charged as kmem pages which can pin
the memory cgroup in the memory).

	#!/bin/bash

	cat /proc/cgroups | grep memory

	cd /sys/fs/cgroup/memory
	echo 1 > memory.move_charge_at_immigrate

	for i in range{1..500}
	do
		mkdir kmem_test
		echo $$ > kmem_test/cgroup.procs
		sleep 3600 &
		echo $$ > cgroup.procs
		echo `cat kmem_test/cgroup.procs` > cgroup.procs
		rmdir kmem_test
	done

	cat /proc/cgroups | grep memory

This patchset aims to make those kmem pages to drop the reference to
memory cgroup by using the APIs of obj_cgroup.  Finally, we can see that
the number of the dying cgroups will not increase if we run the above test
script.

This patch (of 7):

The rcu_read_lock/unlock only can guarantee that the memcg will not be
freed, but it cannot guarantee the success of css_get (which is in the
refill_stock when cached memcg changed) to memcg.

  rcu_read_lock()
  memcg = obj_cgroup_memcg(old)
  __memcg_kmem_uncharge(memcg)
      refill_stock(memcg)
          if (stock->cached != memcg)
              // css_get can change the ref counter from 0 back to 1.
              css_get(&memcg->css)
  rcu_read_unlock()

This fix is very like the commit:

  eefbfa7fd678 ("mm: memcg/slab: fix use after free in obj_cgroup_charge")

Fix this by holding a reference to the memcg which is passed to the
__memcg_kmem_uncharge() before calling __memcg_kmem_uncharge().

Link: https://lkml.kernel.org/r/20210319163821.20704-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20210319163821.20704-2-songmuchun@bytedance.com
Fixes: 3de7d4f25a74 ("mm: memcg/slab: optimize objcg stock draining")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e064ac0d850a..e876ba693998 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3181,9 +3181,17 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
 		if (nr_pages) {
+			struct mem_cgroup *memcg;
+
 			rcu_read_lock();
-			__memcg_kmem_uncharge(obj_cgroup_memcg(old), nr_pages);
+retry:
+			memcg = obj_cgroup_memcg(old);
+			if (unlikely(!css_tryget(&memcg->css)))
+				goto retry;
 			rcu_read_unlock();
+
+			__memcg_kmem_uncharge(memcg, nr_pages);
+			css_put(&memcg->css);
 		}
 
 		/*
-- 
2.30.2



