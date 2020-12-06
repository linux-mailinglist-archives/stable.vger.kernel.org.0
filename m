Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925022D0129
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 07:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgLFGPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 01:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLFGPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 01:15:30 -0500
Date:   Sat, 05 Dec 2020 22:14:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235289;
        bh=AOVqoxJMKb9AUnv02YL93cYo6yHYpzGWwaF0vnteRQE=;
        h=From:To:Subject:In-Reply-To:From;
        b=IauN4NFdFj7DrjffQAjCnWC7sQyzpnOlKROaV8UADz/OgEWHgQSkzJFPkuTH984Es
         ii4K7qKu0uXWWC+ZyuuakZNjzAOe/IYWWV9s5Zp8OM9iNSxvDxmpUn1/D5ISRNGJWi
         ubXhVceGvRw0elpp2jAZoREktPG6eSZF5fx7G6zU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, ktkhai@virtuozzo.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 04/12] mm: list_lru: set shrinker map bit when
 child nr_items is not zero
Message-ID: <20201206061448.D4xiqM6MX%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
