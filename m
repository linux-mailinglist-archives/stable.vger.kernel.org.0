Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5492929B35B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766402AbgJ0Osg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766399AbgJ0Osf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA01B20709;
        Tue, 27 Oct 2020 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810114;
        bh=Of77r7x2rdiMMi/oxFJ0EzT5PIgFqQpFRrjBUHaBRJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub7kOyHt4QhG9GnycyLOimscU9b00pNqCuEvYyTKVJfgXv57ukoVPsvmJMfVexKwx
         DXOGxutsgFMZeYrXuAnqXAD2UU9FL1mjKIzIW1ddKBa7FYmm+dMp3laJ2obzwkce8S
         I4LlussXlCUsoxnYWGtfejEeNjE9IkSxFkbg2JXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.8 026/633] binder: fix UAF when releasing todo list
Date:   Tue, 27 Oct 2020 14:46:09 +0100
Message-Id: <20201027135523.934548690@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit f3277cbfba763cd2826396521b9296de67cf1bbc upstream.

When releasing a thread todo list when tearing down
a binder_proc, the following race was possible which
could result in a use-after-free:

1.  Thread 1: enter binder_release_work from binder_thread_release
2.  Thread 2: binder_update_ref_for_handle() -> binder_dec_node_ilocked()
3.  Thread 2: dec nodeA --> 0 (will free node)
4.  Thread 1: ACQ inner_proc_lock
5.  Thread 2: block on inner_proc_lock
6.  Thread 1: dequeue work (BINDER_WORK_NODE, part of nodeA)
7.  Thread 1: REL inner_proc_lock
8.  Thread 2: ACQ inner_proc_lock
9.  Thread 2: todo list cleanup, but work was already dequeued
10. Thread 2: free node
11. Thread 2: REL inner_proc_lock
12. Thread 1: deref w->type (UAF)

The problem was that for a BINDER_WORK_NODE, the binder_work element
must not be accessed after releasing the inner_proc_lock while
processing the todo list elements since another thread might be
handling a deref on the node containing the binder_work element
leading to the node being freed.

Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20201009232455.4054810-1-tkjos@google.com
Cc: <stable@vger.kernel.org> # 4.14, 4.19, 5.4, 5.8
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -223,7 +223,7 @@ static struct binder_transaction_log_ent
 struct binder_work {
 	struct list_head entry;
 
-	enum {
+	enum binder_work_type {
 		BINDER_WORK_TRANSACTION = 1,
 		BINDER_WORK_TRANSACTION_COMPLETE,
 		BINDER_WORK_RETURN_ERROR,
@@ -885,27 +885,6 @@ static struct binder_work *binder_dequeu
 	return w;
 }
 
-/**
- * binder_dequeue_work_head() - Dequeues the item at head of list
- * @proc:         binder_proc associated with list
- * @list:         list to dequeue head
- *
- * Removes the head of the list if there are items on the list
- *
- * Return: pointer dequeued binder_work, NULL if list was empty
- */
-static struct binder_work *binder_dequeue_work_head(
-					struct binder_proc *proc,
-					struct list_head *list)
-{
-	struct binder_work *w;
-
-	binder_inner_proc_lock(proc);
-	w = binder_dequeue_work_head_ilocked(list);
-	binder_inner_proc_unlock(proc);
-	return w;
-}
-
 static void
 binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer);
 static void binder_free_thread(struct binder_thread *thread);
@@ -4589,13 +4568,17 @@ static void binder_release_work(struct b
 				struct list_head *list)
 {
 	struct binder_work *w;
+	enum binder_work_type wtype;
 
 	while (1) {
-		w = binder_dequeue_work_head(proc, list);
+		binder_inner_proc_lock(proc);
+		w = binder_dequeue_work_head_ilocked(list);
+		wtype = w ? w->type : 0;
+		binder_inner_proc_unlock(proc);
 		if (!w)
 			return;
 
-		switch (w->type) {
+		switch (wtype) {
 		case BINDER_WORK_TRANSACTION: {
 			struct binder_transaction *t;
 
@@ -4629,9 +4612,11 @@ static void binder_release_work(struct b
 			kfree(death);
 			binder_stats_deleted(BINDER_STAT_DEATH);
 		} break;
+		case BINDER_WORK_NODE:
+			break;
 		default:
 			pr_err("unexpected work type, %d, not freed\n",
-			       w->type);
+			       wtype);
 			break;
 		}
 	}


