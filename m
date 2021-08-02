Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302433DD944
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhHBN67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236071AbhHBN47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AEF361167;
        Mon,  2 Aug 2021 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912483;
        bh=J5jZaVtgq2HwXYklkyka55c+ubzUflzBxn1Q+IdGoJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqToirT77xM5RNLha/VGez26HdUZEvEhVivjF96LQmqRKdqrFZODL0T2jfucXW0yy
         7gH4xv9u0sBpPcuzlA0nt1cYdd2L3pdFQuGBm1AH5BbMISx9XNDvQyvY9Q8D2K/gTc
         Om+2duSu9+z6+TNXbHhBnlutt6Bfi5QMQ3o97XOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 013/104] mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()
Date:   Mon,  2 Aug 2021 15:44:10 +0200
Message-Id: <20210802134344.451782516@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit 121dffe20b141c9b27f39d49b15882469cbebae7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -350,7 +350,7 @@ static inline void memcg_slab_free_hook(
 			continue;
 
 		page = virt_to_head_page(p[i]);
-		objcgs = page_objcgs(page);
+		objcgs = page_objcgs_check(page);
 		if (!objcgs)
 			continue;
 


