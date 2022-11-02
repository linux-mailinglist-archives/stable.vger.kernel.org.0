Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D32A61580D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiKBCoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiKBCob (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:44:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16B1838A
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFA6617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67D9C433C1;
        Wed,  2 Nov 2022 02:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357069;
        bh=10sfB5NRFNUabj3Qqig+S7a2CiqUZeVO9ywV7EFd6y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cooxmf/r3Ty+hrKHcsVNTVK1VTLbWBI5QD9bq//dZCWgUHnLvFKCNDXvzGzLdXR6m
         icdGqRjelVOGuzmXvbP6SBNL3DSANSR9u+1czWsOlW8977xVGqVau08Ox8rjOm1de7
         /uxut1Uc3akS9KN2QMP3pTVYYVedGePQsD+/lLWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Waiman Long <longman@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 090/240] mm/kmemleak: prevent soft lockup in kmemleak_scan()s object iteration loops
Date:   Wed,  2 Nov 2022 03:31:05 +0100
Message-Id: <20221102022113.432265587@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 984a608377cb623351b8a3670b285f32ebeb2d32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |   61 +++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 19 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1464,6 +1464,27 @@ static void scan_gray_list(void)
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
@@ -1474,7 +1495,7 @@ static void kmemleak_scan(void)
 	struct zone *zone;
 	int __maybe_unused i;
 	int new_leaks = 0;
-	int loop1_cnt = 0;
+	int loop_cnt = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1483,7 +1504,6 @@ static void kmemleak_scan(void)
 	list_for_each_entry_rcu(object, &object_list, object_list) {
 		bool obj_pinned = false;
 
-		loop1_cnt++;
 		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
@@ -1517,24 +1537,11 @@ static void kmemleak_scan(void)
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
 
@@ -1601,8 +1608,16 @@ static void kmemleak_scan(void)
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
@@ -1635,8 +1650,16 @@ static void kmemleak_scan(void)
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


