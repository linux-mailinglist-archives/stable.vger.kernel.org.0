Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FB1606CBF
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJUA7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJUA7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFE21A16C4;
        Thu, 20 Oct 2022 17:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A43F161D3B;
        Fri, 21 Oct 2022 00:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0506CC433D7;
        Fri, 21 Oct 2022 00:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666313948;
        bh=GFKsXoH/72kHQuGJs4wHnLPIv8dR5pye1WNdA9+itok=;
        h=Date:To:From:Subject:From;
        b=czayl6gWFN2nPlOBl3rvo+6JahmiN+9YU3Sb0K2CkCndPNzDZBjRgXiuLrA1e3eqC
         xs3cgQNWdiUygWRCcsU0wBqg3RmYXesr4hPexZMKYCm65aD3tCv/MJv2RWYMlux34i
         4VnN/icyxsBzCMYHtpU1sYbe0glevil1lgs6gnoU=
Date:   Thu, 20 Oct 2022 17:59:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, catalin.marinas@arm.com,
        longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021005908.0506CC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: prevent soft lockup in kmemleak_scan()'s object iteration loops
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/kmemleak.c |   61 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 19 deletions(-)

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

mm-kmemleak-prevent-soft-lockup-in-kmemleak_scans-object-iteration-loops.patch

