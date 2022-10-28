Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EA4611C28
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJ1VHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJ1VHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:07:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C734C1DD88C;
        Fri, 28 Oct 2022 14:07:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 636AF629FD;
        Fri, 28 Oct 2022 21:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DF0C433C1;
        Fri, 28 Oct 2022 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991225;
        bh=OdHZqnmGvOWMhBMsP6mONPB7VY+f5C4giJd2cIR04vE=;
        h=Date:To:From:Subject:From;
        b=VlyqDzaiJjTbCBhsnwiq1dhffqSALLY0FynxWjQjQKhFtEu825JJvbv6YL+vI1TYt
         71u3mKMHmaVgx1AyIIFp8Bi0zJoYIZcNkA9aR0PiVvghQn0FHe+4r8mdLQs4ODd68C
         qKhI9bqrdbpdTmKKTQQx2yYoEmPzqbYxhVgIGG+Q=
Date:   Fri, 28 Oct 2022 14:07:04 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, catalin.marinas@arm.com,
        longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops.patch removed from -mm tree
Message-Id: <20221028210705.A9DF0C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: prevent soft lockup in kmemleak_scan()'s object iteration loops
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: prevent soft lockup in kmemleak_scan()'s object iteration loops
Date: Thu, 20 Oct 2022 13:56:19 -0400

Commit 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object
iteration loop of kmemleak_scan()") adds cond_resched() in the first
object iteration loop of kmemleak_scan().  However, it turns that the 2nd
objection iteration loop can still cause soft lockup to happen in some
cases.  So add a cond_resched() call in the 2nd and 3rd loops as well to
prevent that and for completeness.

Link: https://lkml.kernel.org/r/20221020175619.366317-1-longman@redhat.com
Fixes: 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops
+++ a/mm/kmemleak.c
@@ -1461,6 +1461,27 @@ static void scan_gray_list(void)
 }
 
 /*
+ * Conditionally call resched() in a object iteration loop while making sure
+ * that the given object won't go away without RCU read lock by performing a
+ * get_object() if !pinned.
+ *
+ * Return: false if can't do a cond_resched() due to get_object() failure
+ *	   true otherwise
+ */
+static bool kmemleak_cond_resched(struct kmemleak_object *object, bool pinned)
+{
+	if (!pinned && !get_object(object))
+		return false;
+
+	rcu_read_unlock();
+	cond_resched();
+	rcu_read_lock();
+	if (!pinned)
+		put_object(object);
+	return true;
+}
+
+/*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
@@ -1471,7 +1492,7 @@ static void kmemleak_scan(void)
 	struct zone *zone;
 	int __maybe_unused i;
 	int new_leaks = 0;
-	int loop1_cnt = 0;
+	int loop_cnt = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1480,7 +1501,6 @@ static void kmemleak_scan(void)
 	list_for_each_entry_rcu(object, &object_list, object_list) {
 		bool obj_pinned = false;
 
-		loop1_cnt++;
 		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
@@ -1514,24 +1534,11 @@ static void kmemleak_scan(void)
 		raw_spin_unlock_irq(&object->lock);
 
 		/*
-		 * Do a cond_resched() to avoid soft lockup every 64k objects.
-		 * Make sure a reference has been taken so that the object
-		 * won't go away without RCU read lock.
+		 * Do a cond_resched() every 64k objects to avoid soft lockup.
 		 */
-		if (!(loop1_cnt & 0xffff)) {
-			if (!obj_pinned && !get_object(object)) {
-				/* Try the next object instead */
-				loop1_cnt--;
-				continue;
-			}
-
-			rcu_read_unlock();
-			cond_resched();
-			rcu_read_lock();
-
-			if (!obj_pinned)
-				put_object(object);
-		}
+		if (!(++loop_cnt & 0xffff) &&
+		    !kmemleak_cond_resched(object, obj_pinned))
+			loop_cnt--; /* Try again on next object */
 	}
 	rcu_read_unlock();
 
@@ -1598,8 +1605,16 @@ static void kmemleak_scan(void)
 	 * scan and color them gray until the next scan.
 	 */
 	rcu_read_lock();
+	loop_cnt = 0;
 	list_for_each_entry_rcu(object, &object_list, object_list) {
 		/*
+		 * Do a cond_resched() every 64k objects to avoid soft lockup.
+		 */
+		if (!(++loop_cnt & 0xffff) &&
+		    !kmemleak_cond_resched(object, false))
+			loop_cnt--;	/* Try again on next object */
+
+		/*
 		 * This is racy but we can save the overhead of lock/unlock
 		 * calls. The missed objects, if any, should be caught in
 		 * the next scan.
@@ -1632,8 +1647,16 @@ static void kmemleak_scan(void)
 	 * Scanning result reporting.
 	 */
 	rcu_read_lock();
+	loop_cnt = 0;
 	list_for_each_entry_rcu(object, &object_list, object_list) {
 		/*
+		 * Do a cond_resched() every 64k objects to avoid soft lockup.
+		 */
+		if (!(++loop_cnt & 0xffff) &&
+		    !kmemleak_cond_resched(object, false))
+			loop_cnt--;	/* Try again on next object */
+
+		/*
 		 * This is racy but we can save the overhead of lock/unlock
 		 * calls. The missed objects, if any, should be caught in
 		 * the next scan.
_

Patches currently in -mm which might be from longman@redhat.com are


