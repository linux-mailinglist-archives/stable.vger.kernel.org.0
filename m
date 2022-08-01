Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3735868F4
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiHALzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiHALyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:54:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA0D3D59A;
        Mon,  1 Aug 2022 04:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03BF9612C6;
        Mon,  1 Aug 2022 11:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12911C433C1;
        Mon,  1 Aug 2022 11:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354646;
        bh=BpAflb7GzevfsToXqLm9RcWX5VEy/6pjtieqjNxcy8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C64+yzTezovEJ754bzdt7w7DvFWyxmObCkHDmbhk+7mmMhYaqxfDKMnkhEw4kXYNv
         Cx5goDtm8DdAZ0wltAymIxrN0g+mD6Xe/9L5o8NbJHF4egorgk73e5szExYkEYLzlj
         O9FseLKl+otEagRA8WTpljKCX9/o6g6yWTB62xB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+03d7b43290037d1f87ca@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 07/65] watch_queue: Fix missing locking in add_watch_to_object()
Date:   Mon,  1 Aug 2022 13:46:24 +0200
Message-Id: <20220801114133.974957264@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
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

commit e64ab2dbd882933b65cd82ff6235d705ad65dbb6 upstream.

If a watch is being added to a queue, it needs to guard against
interference from addition of a new watch, manual removal of a watch and
removal of a watch due to some other queue being destroyed.

KEYCTL_WATCH_KEY guards against this for the same {key,queue} pair by
holding the key->sem writelocked and by holding refs on both the key and
the queue - but that doesn't prevent interaction from other {key,queue}
pairs.

While add_watch_to_object() does take the spinlock on the event queue,
it doesn't take the lock on the source's watch list.  The assumption was
that the caller would prevent that (say by taking key->sem) - but that
doesn't prevent interference from the destruction of another queue.

Fix this by locking the watcher list in add_watch_to_object().

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: syzbot+03d7b43290037d1f87ca@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: keyrings@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |   58 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -457,6 +457,33 @@ void init_watch(struct watch *watch, str
 	rcu_assign_pointer(watch->queue, wqueue);
 }
 
+static int add_one_watch(struct watch *watch, struct watch_list *wlist, struct watch_queue *wqueue)
+{
+	const struct cred *cred;
+	struct watch *w;
+
+	hlist_for_each_entry(w, &wlist->watchers, list_node) {
+		struct watch_queue *wq = rcu_access_pointer(w->queue);
+		if (wqueue == wq && watch->id == w->id)
+			return -EBUSY;
+	}
+
+	cred = current_cred();
+	if (atomic_inc_return(&cred->user->nr_watches) > task_rlimit(current, RLIMIT_NOFILE)) {
+		atomic_dec(&cred->user->nr_watches);
+		return -EAGAIN;
+	}
+
+	watch->cred = get_cred(cred);
+	rcu_assign_pointer(watch->watch_list, wlist);
+
+	kref_get(&wqueue->usage);
+	kref_get(&watch->usage);
+	hlist_add_head(&watch->queue_node, &wqueue->watches);
+	hlist_add_head_rcu(&watch->list_node, &wlist->watchers);
+	return 0;
+}
+
 /**
  * add_watch_to_object - Add a watch on an object to a watch list
  * @watch: The watch to add
@@ -471,34 +498,21 @@ void init_watch(struct watch *watch, str
  */
 int add_watch_to_object(struct watch *watch, struct watch_list *wlist)
 {
-	struct watch_queue *wqueue = rcu_access_pointer(watch->queue);
-	struct watch *w;
+	struct watch_queue *wqueue;
+	int ret = -ENOENT;
 
-	hlist_for_each_entry(w, &wlist->watchers, list_node) {
-		struct watch_queue *wq = rcu_access_pointer(w->queue);
-		if (wqueue == wq && watch->id == w->id)
-			return -EBUSY;
-	}
-
-	watch->cred = get_current_cred();
-	rcu_assign_pointer(watch->watch_list, wlist);
-
-	if (atomic_inc_return(&watch->cred->user->nr_watches) >
-	    task_rlimit(current, RLIMIT_NOFILE)) {
-		atomic_dec(&watch->cred->user->nr_watches);
-		put_cred(watch->cred);
-		return -EAGAIN;
-	}
+	rcu_read_lock();
 
+	wqueue = rcu_access_pointer(watch->queue);
 	if (lock_wqueue(wqueue)) {
-		kref_get(&wqueue->usage);
-		kref_get(&watch->usage);
-		hlist_add_head(&watch->queue_node, &wqueue->watches);
+		spin_lock(&wlist->lock);
+		ret = add_one_watch(watch, wlist, wqueue);
+		spin_unlock(&wlist->lock);
 		unlock_wqueue(wqueue);
 	}
 
-	hlist_add_head_rcu(&watch->list_node, &wlist->watchers);
-	return 0;
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(add_watch_to_object);
 


