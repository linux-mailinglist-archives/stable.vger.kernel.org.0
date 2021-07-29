Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2733DAE8E
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhG2Vx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 17:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhG2Vx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB1E60F48;
        Thu, 29 Jul 2021 21:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595635;
        bh=fAq3DahtlZ3nKcXaZ1PRHc7AS0nh1xwDLxj0akIi2SE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y9fCnhtLlQn2MjBdD543Ze6ppejDq3yc8oLuJsmJZ3euiMvLUVrjboLUiQhEfudHG
         VWyy6wxOR7sfT9A6GldSF7oKUeEGyTL3GgOd46/MW3eMjYkAgxc6SOZBXCA8FFkbgP
         WfAHpe92l1nSZrHw+GScbReHGEnc20UdSq01oYVU=
Date:   Thu, 29 Jul 2021 14:53:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ast@kernel.org, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        wanghai38@huawei.com, wangkefeng.wang@huawei.com
Subject:  [patch 7/7] mm/memcg: fix NULL pointer dereference in
 memcg_slab_free_hook()
Message-ID: <20210729215354.cIhMlxeSy%akpm@linux-foundation.org>
In-Reply-To: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Subject: mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()

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
---

 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.h~mm-memcg-fix-null-pointer-dereference-in-memcg_slab_free_hook
+++ a/mm/slab.h
@@ -346,7 +346,7 @@ static inline void memcg_slab_free_hook(
 			continue;
 
 		page = virt_to_head_page(p[i]);
-		objcgs = page_objcgs(page);
+		objcgs = page_objcgs_check(page);
 		if (!objcgs)
 			continue;
 
_
