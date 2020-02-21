Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135621675FC
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbgBUIMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732812AbgBUIMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:12:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 773902467A;
        Fri, 21 Feb 2020 08:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272737;
        bh=HETN9lzhT4lP6BoRdKhMd9UfEPjojCOaxXyYfT0N564=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sStYyiCq13KXNjLjEnsGDKkmNMlWFRmNjLBgCwrTD/Ot8ZEfQSD1UbHni+vypcRIi
         WxduTft4ku1F8HNoQr/EAgeitrk2C/ZDuv6cUfo3Eyi4QRVcOQ53QUANmwusz2ctO+
         t/uLpvtwq73vr7Jo909XiOZpkk/gvOH4UX4HwuY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Marco Elver <elver@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 255/344] debugobjects: Fix various data races
Date:   Fri, 21 Feb 2020 08:40:54 +0100
Message-Id: <20200221072412.710716074@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 35fd7a637c42bb54ba4608f4d40ae6e55fc88781 ]

The counters obj_pool_free, and obj_nr_tofree, and the flag obj_freeing are
read locklessly outside the pool_lock critical sections. If read with plain
accesses, this would result in data races.

This is addressed as follows:

 * reads outside critical sections become READ_ONCE()s (pairing with
   WRITE_ONCE()s added);

 * writes become WRITE_ONCE()s (pairing with READ_ONCE()s added); since
   writes happen inside critical sections, only the write and not the read
   of RMWs needs to be atomic, thus WRITE_ONCE(var, var +/- X) is
   sufficient.

The data races were reported by KCSAN:

  BUG: KCSAN: data-race in __free_object / fill_pool

  write to 0xffffffff8beb04f8 of 4 bytes by interrupt on cpu 1:
   __free_object+0x1ee/0x8e0 lib/debugobjects.c:404
   __debug_check_no_obj_freed+0x199/0x330 lib/debugobjects.c:969
   debug_check_no_obj_freed+0x3c/0x44 lib/debugobjects.c:994
   slab_free_hook mm/slub.c:1422 [inline]

  read to 0xffffffff8beb04f8 of 4 bytes by task 1 on cpu 2:
   fill_pool+0x3d/0x520 lib/debugobjects.c:135
   __debug_object_init+0x3c/0x810 lib/debugobjects.c:536
   debug_object_init lib/debugobjects.c:591 [inline]
   debug_object_activate+0x228/0x320 lib/debugobjects.c:677
   debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]

  BUG: KCSAN: data-race in __debug_object_init / fill_pool

  read to 0xffffffff8beb04f8 of 4 bytes by task 10 on cpu 6:
   fill_pool+0x3d/0x520 lib/debugobjects.c:135
   __debug_object_init+0x3c/0x810 lib/debugobjects.c:536
   debug_object_init_on_stack+0x39/0x50 lib/debugobjects.c:606
   init_timer_on_stack_key kernel/time/timer.c:742 [inline]

  write to 0xffffffff8beb04f8 of 4 bytes by task 1 on cpu 3:
   alloc_object lib/debugobjects.c:258 [inline]
   __debug_object_init+0x717/0x810 lib/debugobjects.c:544
   debug_object_init lib/debugobjects.c:591 [inline]
   debug_object_activate+0x228/0x320 lib/debugobjects.c:677
   debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]

  BUG: KCSAN: data-race in free_obj_work / free_object

  read to 0xffffffff9140c190 of 4 bytes by task 10 on cpu 6:
   free_object+0x4b/0xd0 lib/debugobjects.c:426
   debug_object_free+0x190/0x210 lib/debugobjects.c:824
   destroy_timer_on_stack kernel/time/timer.c:749 [inline]

  write to 0xffffffff9140c190 of 4 bytes by task 93 on cpu 1:
   free_obj_work+0x24f/0x480 lib/debugobjects.c:313
   process_one_work+0x454/0x8d0 kernel/workqueue.c:2264
   worker_thread+0x9a/0x780 kernel/workqueue.c:2410

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200116185529.11026-1-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 61261195f5b60..48054dbf1b51f 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -132,14 +132,18 @@ static void fill_pool(void)
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (likely(obj_pool_free >= debug_objects_pool_min_level))
+	if (likely(READ_ONCE(obj_pool_free) >= debug_objects_pool_min_level))
 		return;
 
 	/*
 	 * Reuse objs from the global free list; they will be reinitialized
 	 * when allocating.
+	 *
+	 * Both obj_nr_tofree and obj_pool_free are checked locklessly; the
+	 * READ_ONCE()s pair with the WRITE_ONCE()s in pool_lock critical
+	 * sections.
 	 */
-	while (obj_nr_tofree && (obj_pool_free < obj_pool_min_free)) {
+	while (READ_ONCE(obj_nr_tofree) && (READ_ONCE(obj_pool_free) < obj_pool_min_free)) {
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		/*
 		 * Recheck with the lock held as the worker thread might have
@@ -148,9 +152,9 @@ static void fill_pool(void)
 		while (obj_nr_tofree && (obj_pool_free < obj_pool_min_free)) {
 			obj = hlist_entry(obj_to_free.first, typeof(*obj), node);
 			hlist_del(&obj->node);
-			obj_nr_tofree--;
+			WRITE_ONCE(obj_nr_tofree, obj_nr_tofree - 1);
 			hlist_add_head(&obj->node, &obj_pool);
-			obj_pool_free++;
+			WRITE_ONCE(obj_pool_free, obj_pool_free + 1);
 		}
 		raw_spin_unlock_irqrestore(&pool_lock, flags);
 	}
@@ -158,7 +162,7 @@ static void fill_pool(void)
 	if (unlikely(!obj_cache))
 		return;
 
-	while (obj_pool_free < debug_objects_pool_min_level) {
+	while (READ_ONCE(obj_pool_free) < debug_objects_pool_min_level) {
 		struct debug_obj *new[ODEBUG_BATCH_SIZE];
 		int cnt;
 
@@ -174,7 +178,7 @@ static void fill_pool(void)
 		while (cnt) {
 			hlist_add_head(&new[--cnt]->node, &obj_pool);
 			debug_objects_allocated++;
-			obj_pool_free++;
+			WRITE_ONCE(obj_pool_free, obj_pool_free + 1);
 		}
 		raw_spin_unlock_irqrestore(&pool_lock, flags);
 	}
@@ -236,7 +240,7 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 	obj = __alloc_object(&obj_pool);
 	if (obj) {
 		obj_pool_used++;
-		obj_pool_free--;
+		WRITE_ONCE(obj_pool_free, obj_pool_free - 1);
 
 		/*
 		 * Looking ahead, allocate one batch of debug objects and
@@ -255,7 +259,7 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 					       &percpu_pool->free_objs);
 				percpu_pool->obj_free++;
 				obj_pool_used++;
-				obj_pool_free--;
+				WRITE_ONCE(obj_pool_free, obj_pool_free - 1);
 			}
 		}
 
@@ -309,8 +313,8 @@ static void free_obj_work(struct work_struct *work)
 		obj = hlist_entry(obj_to_free.first, typeof(*obj), node);
 		hlist_del(&obj->node);
 		hlist_add_head(&obj->node, &obj_pool);
-		obj_pool_free++;
-		obj_nr_tofree--;
+		WRITE_ONCE(obj_pool_free, obj_pool_free + 1);
+		WRITE_ONCE(obj_nr_tofree, obj_nr_tofree - 1);
 	}
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
 	return;
@@ -324,7 +328,7 @@ free_objs:
 	if (obj_nr_tofree) {
 		hlist_move_list(&obj_to_free, &tofree);
 		debug_objects_freed += obj_nr_tofree;
-		obj_nr_tofree = 0;
+		WRITE_ONCE(obj_nr_tofree, 0);
 	}
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
 
@@ -375,10 +379,10 @@ free_to_obj_pool:
 	obj_pool_used--;
 
 	if (work) {
-		obj_nr_tofree++;
+		WRITE_ONCE(obj_nr_tofree, obj_nr_tofree + 1);
 		hlist_add_head(&obj->node, &obj_to_free);
 		if (lookahead_count) {
-			obj_nr_tofree += lookahead_count;
+			WRITE_ONCE(obj_nr_tofree, obj_nr_tofree + lookahead_count);
 			obj_pool_used -= lookahead_count;
 			while (lookahead_count) {
 				hlist_add_head(&objs[--lookahead_count]->node,
@@ -396,15 +400,15 @@ free_to_obj_pool:
 			for (i = 0; i < ODEBUG_BATCH_SIZE; i++) {
 				obj = __alloc_object(&obj_pool);
 				hlist_add_head(&obj->node, &obj_to_free);
-				obj_pool_free--;
-				obj_nr_tofree++;
+				WRITE_ONCE(obj_pool_free, obj_pool_free - 1);
+				WRITE_ONCE(obj_nr_tofree, obj_nr_tofree + 1);
 			}
 		}
 	} else {
-		obj_pool_free++;
+		WRITE_ONCE(obj_pool_free, obj_pool_free + 1);
 		hlist_add_head(&obj->node, &obj_pool);
 		if (lookahead_count) {
-			obj_pool_free += lookahead_count;
+			WRITE_ONCE(obj_pool_free, obj_pool_free + lookahead_count);
 			obj_pool_used -= lookahead_count;
 			while (lookahead_count) {
 				hlist_add_head(&objs[--lookahead_count]->node,
@@ -423,7 +427,7 @@ free_to_obj_pool:
 static void free_object(struct debug_obj *obj)
 {
 	__free_object(obj);
-	if (!obj_freeing && obj_nr_tofree) {
+	if (!READ_ONCE(obj_freeing) && READ_ONCE(obj_nr_tofree)) {
 		WRITE_ONCE(obj_freeing, true);
 		schedule_delayed_work(&debug_obj_work, ODEBUG_FREE_WORK_DELAY);
 	}
@@ -982,7 +986,7 @@ repeat:
 		debug_objects_maxchecked = objs_checked;
 
 	/* Schedule work to actually kmem_cache_free() objects */
-	if (!obj_freeing && obj_nr_tofree) {
+	if (!READ_ONCE(obj_freeing) && READ_ONCE(obj_nr_tofree)) {
 		WRITE_ONCE(obj_freeing, true);
 		schedule_delayed_work(&debug_obj_work, ODEBUG_FREE_WORK_DELAY);
 	}
@@ -1008,12 +1012,12 @@ static int debug_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "max_checked   :%d\n", debug_objects_maxchecked);
 	seq_printf(m, "warnings      :%d\n", debug_objects_warnings);
 	seq_printf(m, "fixups        :%d\n", debug_objects_fixups);
-	seq_printf(m, "pool_free     :%d\n", obj_pool_free + obj_percpu_free);
+	seq_printf(m, "pool_free     :%d\n", READ_ONCE(obj_pool_free) + obj_percpu_free);
 	seq_printf(m, "pool_pcp_free :%d\n", obj_percpu_free);
 	seq_printf(m, "pool_min_free :%d\n", obj_pool_min_free);
 	seq_printf(m, "pool_used     :%d\n", obj_pool_used - obj_percpu_free);
 	seq_printf(m, "pool_max_used :%d\n", obj_pool_max_used);
-	seq_printf(m, "on_free_list  :%d\n", obj_nr_tofree);
+	seq_printf(m, "on_free_list  :%d\n", READ_ONCE(obj_nr_tofree));
 	seq_printf(m, "objs_allocated:%d\n", debug_objects_allocated);
 	seq_printf(m, "objs_freed    :%d\n", debug_objects_freed);
 	return 0;
-- 
2.20.1



