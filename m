Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EB03D9577
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 20:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhG1SqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 14:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhG1SqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 14:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC33E60525;
        Wed, 28 Jul 2021 18:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627497958;
        bh=RjAgnQkk/Psy9Gs4coi2GKJyu5o6SGoC86V4MpiCPE4=;
        h=Date:From:To:Subject:From;
        b=OoX/9USH4OowkA7gO83Jp8xCJGKjyOyksANR+/CvfR5rw5azxzlNmshjiXzI2FpDl
         xThDlMtBTePYlzcNUAdY+JMYOmwKd25cF6EnU6RoBN/WO0zRd6up/jcS3cFdYu+Y5a
         5ZWoOtIhQ42bzggX2lAVE2lreSYy+aHf26GUuFjQ=
Date:   Wed, 28 Jul 2021 11:45:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vbabka@suse.cz, stable@vger.kernel.org, shakeelb@google.com,
        rientjes@google.com, penberg@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, guro@fb.com,
        cl@linux.com, ast@kernel.org, wanghai38@huawei.com
Subject:  +
 mm-memcg-fix-null-pointer-dereference-in-memcg_slab_free_hook.patch added to
 -mm tree
Message-ID: <20210728184557.xaKCu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-null-pointer-dereference-in-memcg_slab_free_hook.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-null-pointer-dereference-in-memcg_slab_free_hook.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-null-pointer-dereference-in-memcg_slab_free_hook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

Patches currently in -mm which might be from wanghai38@huawei.com are

mm-memcg-fix-null-pointer-dereference-in-memcg_slab_free_hook.patch

