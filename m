Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37244EAC37
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 13:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiC2L2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 07:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbiC2L2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 07:28:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D3F1D760C
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 04:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA70EB80A37
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 11:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224E1C2BBE4;
        Tue, 29 Mar 2022 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648553195;
        bh=1dxOYq65rIMIrsxhvxqgMc5PGLcUlFtmZkGpw9nmSnc=;
        h=Subject:To:Cc:From:Date:From;
        b=z4vIF12Ur5l/4w7miPGZrCTB0JhLXaUmNVd3EmBZ2H4yC0Kx8l9Ke+3ysg6IqQPJx
         jW8Ql2FTYz91GJp98zkdB2oLeCxuw0gZHa2vNlFUJNfkyBRsVCVcrbJd5GuMtoDO/b
         XdkasHUnhsLnIhar6NwBoGEAa2IoHs9oliqIE62g=
Subject: FAILED: patch "[PATCH] locking/lockdep: Avoid potential access of invalid memory in" failed to apply to 5.4-stable tree
To:     longman@redhat.com, bvanassche@acm.org,
        penguin-kernel@i-love.sakura.ne.jp, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Mar 2022 13:26:33 +0200
Message-ID: <16485531938335@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 61cc4534b6550997c97a03759ab46b29d44c0017 Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Sun, 2 Jan 2022 21:35:58 -0500
Subject: [PATCH] locking/lockdep: Avoid potential access of invalid memory in
 lock_class

It was found that reading /proc/lockdep after a lockdep splat may
potentially cause an access to freed memory if lockdep_unregister_key()
is called after the splat but before access to /proc/lockdep [1]. This
is due to the fact that graph_lock() call in lockdep_unregister_key()
fails after the clearing of debug_locks by the splat process.

After lockdep_unregister_key() is called, the lock_name may be freed
but the corresponding lock_class structure still have a reference to
it. That invalid memory pointer will then be accessed when /proc/lockdep
is read by a user and a use-after-free (UAF) error will be reported if
KASAN is enabled.

To fix this problem, lockdep_unregister_key() is now modified to always
search for a matching key irrespective of the debug_locks state and
zap the corresponding lock class if a matching one is found.

[1] https://lore.kernel.org/lkml/77f05c15-81b6-bddd-9650-80d5f23fe330@i-love.sakura.ne.jp/

Fixes: 8b39adbee805 ("locking/lockdep: Make lockdep_unregister_key() honor 'debug_locks' again")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lkml.kernel.org/r/20220103023558.1377055-1-longman@redhat.com

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 89b3df51fd98..2e6892ec3756 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6287,7 +6287,13 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 		lockdep_reset_lock_reg(lock);
 }
 
-/* Unregister a dynamically allocated key. */
+/*
+ * Unregister a dynamically allocated key.
+ *
+ * Unlike lockdep_register_key(), a search is always done to find a matching
+ * key irrespective of debug_locks to avoid potential invalid access to freed
+ * memory in lock_class entry.
+ */
 void lockdep_unregister_key(struct lock_class_key *key)
 {
 	struct hlist_head *hash_head = keyhashentry(key);
@@ -6302,10 +6308,8 @@ void lockdep_unregister_key(struct lock_class_key *key)
 		return;
 
 	raw_local_irq_save(flags);
-	if (!graph_lock())
-		goto out_irq;
+	lockdep_lock();
 
-	pf = get_pending_free();
 	hlist_for_each_entry_rcu(k, hash_head, hash_entry) {
 		if (k == key) {
 			hlist_del_rcu(&k->hash_entry);
@@ -6313,11 +6317,13 @@ void lockdep_unregister_key(struct lock_class_key *key)
 			break;
 		}
 	}
-	WARN_ON_ONCE(!found);
-	__lockdep_free_key_range(pf, key, 1);
-	call_rcu_zapped(pf);
-	graph_unlock();
-out_irq:
+	WARN_ON_ONCE(!found && debug_locks);
+	if (found) {
+		pf = get_pending_free();
+		__lockdep_free_key_range(pf, key, 1);
+		call_rcu_zapped(pf);
+	}
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 
 	/* Wait until is_dynamic_key() has finished accessing k->hash_entry. */

