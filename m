Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BF02CCA31
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 00:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgLBXA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 18:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgLBXA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 18:00:57 -0500
Date:   Wed, 02 Dec 2020 15:00:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606950016;
        bh=mbs/FoFkQP+7uPBggMSrgy6V+fHkPw55wNT6RZXTBWk=;
        h=From:To:Subject:From;
        b=XbRb3HSCaCreUUbdrzQKua8lS3Rh7NOAVGfwqYo5yH8hHHB5qwNO5bOswCaaZye8A
         Nu3y1ePguaUcoIVskllSYFXa6Ig2m6SzIgFYJ5izQhcU3jtIxPHv3BRfFqC/cJ5y2+
         bTRmJxl073IgEjhBxvdiMXdbgsIivOdHM6grMy/o=
From:   akpm@linux-foundation.org
To:     guro@fb.com, ktkhai@virtuozzo.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  +
 mm-list_lru-set-shrinker-map-bit-when-child-nr_items-is-not-zero.patch
 added to -mm tree
Message-ID: <20201202230015.JJb73xgsx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: list_lru: set shrinker map bit when child nr_items is not zero
has been added to the -mm tree.  Its filename is
     mm-list_lru-set-shrinker-map-bit-when-child-nr_items-is-not-zero.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-set-shrinker-map-bit-when-child-nr_items-is-not-zero.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-set-shrinker-map-bit-when-child-nr_items-is-not-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: list_lru: set shrinker map bit when child nr_items is not zero

When investigating a slab cache bloat problem, significant amount of
negative dentry cache was seen, but confusingly they neither got shrunk
by reclaimer (the host has very tight memory) nor be shrunk by dropping
cache.  The vmcore shows there are over 14M negative dentry objects on lru,
but tracing result shows they were even not scanned at all.  The further
investigation shows the memcg's vfs shrinker_map bit is not set.  So the
reclaimer or dropping cache just skip calling vfs shrinker.  So we have
to reboot the hosts to get the memory back.

I didn't manage to come up with a reproducer in test environment, and the
problem can't be reproduced after rebooting.  But it seems there is race
between shrinker map bit clear and reparenting by code inspection.  The
hypothesis is elaborated as below.

The memcg hierarchy on our production environment looks like:
                root
               /    \
          system   user

The main workloads are running under user slice's children, and it creates
and removes memcg frequently.  So reparenting happens very often under user
slice, but no task is under user slice directly.

So with the frequent reparenting and tight memory pressure, the below
hypothetical race condition may happen:

       CPU A                            CPU B
reparent
    dst->nr_items == 0
                                 shrinker:
                                     total_objects == 0
    add src->nr_items to dst
    set_bit
                                     return SHRINK_EMPTY
                                     clear_bit
child memcg offline
    replace child's kmemcg_id with
    parent's (in memcg_offline_kmem())
                                  list_lru_del() between shrinker runs
                                     see parent's kmemcg_id
                                     dec dst->nr_items
reparent again
    dst->nr_items may go negative
    due to concurrent list_lru_del()

                                 The second run of shrinker:
                                     read nr_items without any
                                     synchronization, so it may
                                     see intermediate negative
                                     nr_items then total_objects
                                     may return 0 coincidently

                                     keep the bit cleared
    dst->nr_items != 0
    skip set_bit
    add scr->nr_item to dst

After this point dst->nr_item may never go zero, so reparenting will not
set shrinker_map bit anymore.  And since there is no task under user
slice directly, so no new object will be added to its lru to set the
shrinker map bit either.  That bit is kept cleared forever.

How does list_lru_del() race with reparenting?  It is because
reparenting replaces children's kmemcg_id to parent's without protecting
from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
actually deleting items from child's lru, but dec'ing parent's nr_items,
so the parent's nr_items may go negative as commit
2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
free kmemcg_id on css offline") says.

Since it is impossible that dst->nr_items goes negative and
src->nr_items goes zero at the same time, so it seems we could set the
shrinker map bit iff src->nr_items != 0.  We could synchronize
list_lru_count_one() and reparenting with nlru->lock, but it seems
checking src->nr_items in reparenting is the simplest and avoids lock
contention.

Link: https://lkml.kernel.org/r/20201202171749.264354-1-shy828301@gmail.com
Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>	[4.19]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-set-shrinker-map-bit-when-child-nr_items-is-not-zero
+++ a/mm/list_lru.c
@@ -534,7 +534,6 @@ static void memcg_drain_list_lru_node(st
 	struct list_lru_node *nlru = &lru->node[nid];
 	int dst_idx = dst_memcg->kmemcg_id;
 	struct list_lru_one *src, *dst;
-	bool set;
 
 	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
@@ -546,11 +545,12 @@ static void memcg_drain_list_lru_node(st
 	dst = list_lru_from_memcg_idx(nlru, dst_idx);
 
 	list_splice_init(&src->list, &dst->list);
-	set = (!dst->nr_items && src->nr_items);
-	dst->nr_items += src->nr_items;
-	if (set)
+
+	if (src->nr_items) {
+		dst->nr_items += src->nr_items;
 		memcg_set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
-	src->nr_items = 0;
+		src->nr_items = 0;
+	}
 
 	spin_unlock_irq(&nlru->lock);
 }
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-list_lru-set-shrinker-map-bit-when-child-nr_items-is-not-zero.patch
mm-truncate_complete_page-is-not-existed-anymore.patch
mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
mm-migrate-clean-up-migrate_prep_local.patch
mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

