Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37DB582D81
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiG0Q6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240633AbiG0Q6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D067166;
        Wed, 27 Jul 2022 09:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C0861A8E;
        Wed, 27 Jul 2022 16:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F933C433D7;
        Wed, 27 Jul 2022 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939811;
        bh=7yvDQWnND4ZyWhVfrWdvzBV3QLcB2BtDLr3nL9fwep4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpt68wB95/fbl5ZprPE+yOzymTKh70/MEuTTpzRnpH1ZYH46Ha+7sPlmEicGnLY+4
         7EE0g46f0vag/QP5+JeZmJ+XxMQBQAI7W8wL34R6QBg83FyeQBVpE4KelRdTiguQ5y
         KjoY7QrKT3CyaDPhvcjpdryzR3faZsnZrtZFIav0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Noam Rathaus <noamr@ssd-disclosure.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 096/105] watchqueue: make sure to serialize wqueue->defunct properly
Date:   Wed, 27 Jul 2022 18:11:22 +0200
Message-Id: <20220727161015.962743329@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 353f7988dd8413c47718f7ca79c030b6fb62cfe5 upstream.

When the pipe is closed, we mark the associated watchqueue defunct by
calling watch_queue_clear().  However, while that is protected by the
watchqueue lock, new watchqueue entries aren't actually added under that
lock at all: they use the pipe->rd_wait.lock instead, and looking up
that pipe happens without any locking.

The watchqueue code uses the RCU read-side section to make sure that the
wqueue entry itself hasn't disappeared, but that does not protect the
pipe_info in any way.

So make sure to actually hold the wqueue lock when posting watch events,
properly serializing against the pipe being torn down.

Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |   53 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 16 deletions(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -34,6 +34,27 @@ MODULE_LICENSE("GPL");
 #define WATCH_QUEUE_NOTE_SIZE 128
 #define WATCH_QUEUE_NOTES_PER_PAGE (PAGE_SIZE / WATCH_QUEUE_NOTE_SIZE)
 
+/*
+ * This must be called under the RCU read-lock, which makes
+ * sure that the wqueue still exists. It can then take the lock,
+ * and check that the wqueue hasn't been destroyed, which in
+ * turn makes sure that the notification pipe still exists.
+ */
+static inline bool lock_wqueue(struct watch_queue *wqueue)
+{
+	spin_lock_bh(&wqueue->lock);
+	if (unlikely(wqueue->defunct)) {
+		spin_unlock_bh(&wqueue->lock);
+		return false;
+	}
+	return true;
+}
+
+static inline void unlock_wqueue(struct watch_queue *wqueue)
+{
+	spin_unlock_bh(&wqueue->lock);
+}
+
 static void watch_queue_pipe_buf_release(struct pipe_inode_info *pipe,
 					 struct pipe_buffer *buf)
 {
@@ -69,6 +90,10 @@ static const struct pipe_buf_operations
 
 /*
  * Post a notification to a watch queue.
+ *
+ * Must be called with the RCU lock for reading, and the
+ * watch_queue lock held, which guarantees that the pipe
+ * hasn't been released.
  */
 static bool post_one_notification(struct watch_queue *wqueue,
 				  struct watch_notification *n)
@@ -85,9 +110,6 @@ static bool post_one_notification(struct
 
 	spin_lock_irq(&pipe->rd_wait.lock);
 
-	if (wqueue->defunct)
-		goto out;
-
 	mask = pipe->ring_size - 1;
 	head = pipe->head;
 	tail = pipe->tail;
@@ -203,7 +225,10 @@ void __post_watch_notification(struct wa
 		if (security_post_notification(watch->cred, cred, n) < 0)
 			continue;
 
-		post_one_notification(wqueue, n);
+		if (lock_wqueue(wqueue)) {
+			post_one_notification(wqueue, n);
+			unlock_wqueue(wqueue);;
+		}
 	}
 
 	rcu_read_unlock();
@@ -465,11 +490,12 @@ int add_watch_to_object(struct watch *wa
 		return -EAGAIN;
 	}
 
-	spin_lock_bh(&wqueue->lock);
-	kref_get(&wqueue->usage);
-	kref_get(&watch->usage);
-	hlist_add_head(&watch->queue_node, &wqueue->watches);
-	spin_unlock_bh(&wqueue->lock);
+	if (lock_wqueue(wqueue)) {
+		kref_get(&wqueue->usage);
+		kref_get(&watch->usage);
+		hlist_add_head(&watch->queue_node, &wqueue->watches);
+		unlock_wqueue(wqueue);
+	}
 
 	hlist_add_head(&watch->list_node, &wlist->watchers);
 	return 0;
@@ -523,20 +549,15 @@ found:
 
 	wqueue = rcu_dereference(watch->queue);
 
-	/* We don't need the watch list lock for the next bit as RCU is
-	 * protecting *wqueue from deallocation.
-	 */
-	if (wqueue) {
+	if (lock_wqueue(wqueue)) {
 		post_one_notification(wqueue, &n.watch);
 
-		spin_lock_bh(&wqueue->lock);
-
 		if (!hlist_unhashed(&watch->queue_node)) {
 			hlist_del_init_rcu(&watch->queue_node);
 			put_watch(watch);
 		}
 
-		spin_unlock_bh(&wqueue->lock);
+		unlock_wqueue(wqueue);
 	}
 
 	if (wlist->release_watch) {


