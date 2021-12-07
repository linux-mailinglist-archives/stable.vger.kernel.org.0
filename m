Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4226946B83C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhLGKCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:02:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51648 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhLGKCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:02:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD0A6CE19C3;
        Tue,  7 Dec 2021 09:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931E3C341C6;
        Tue,  7 Dec 2021 09:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638871152;
        bh=+rf/Jsw9jwUNuaVnVdOe/668hcd6zrLyW3JgtBuRq4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8lycE78VE+PHrv4E6fUEAoJ/K74qdM0tOWMMto0XHMKdMaaGsmTFH9iCU4OuVN0D
         INgMV3M13OXdnkwxlfKQBJqkSlWjSwli7lfTtZACcIV1NrgH32XTccLhtb+7mANAMy
         Ot3IHXg69ueRXB2IPPgFstyPfVR7B+n8zzFPtG0EGEnSIB/FjEeTS/kjTafGs6SZeG
         7IyyT4ywhvnVD/zE/YzKVOUe8Zokg1rUgDUwqUaiDZrogXovwn39Xu2mLYbC38oYiK
         N+/CoJojffmYVVBPSf6cuvMlLf4Zz3VdR0Mt7jS/VicTGwbdtISIeTmK81oGPX4lYw
         Vn71rtSvkWCiA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/5] binder: use wake_up_pollfree()
Date:   Tue,  7 Dec 2021 01:57:23 -0800
Message-Id: <20211207095726.169766-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207095726.169766-1-ebiggers@kernel.org>
References: <20211207095726.169766-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
all non-exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.
epoll and aio poll are fortunately not affected by this, but it's very
fragile.  Thus, the new function wake_up_pollfree() has been introduced.

Convert binder to use wake_up_pollfree().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread exits.")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/android/binder.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index cffbe57a8e086..c75fb600740cc 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4422,23 +4422,20 @@ static int binder_thread_release(struct binder_proc *proc,
 	__release(&t->lock);
 
 	/*
-	 * If this thread used poll, make sure we remove the waitqueue
-	 * from any epoll data structures holding it with POLLFREE.
-	 * waitqueue_active() is safe to use here because we're holding
-	 * the inner lock.
+	 * If this thread used poll, make sure we remove the waitqueue from any
+	 * poll data structures holding it.
 	 */
-	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
-	    waitqueue_active(&thread->wait)) {
-		wake_up_poll(&thread->wait, EPOLLHUP | POLLFREE);
-	}
+	if (thread->looper & BINDER_LOOPER_STATE_POLL)
+		wake_up_pollfree(&thread->wait);
 
 	binder_inner_proc_unlock(thread->proc);
 
 	/*
-	 * This is needed to avoid races between wake_up_poll() above and
-	 * and ep_remove_waitqueue() called for other reasons (eg the epoll file
-	 * descriptor being closed); ep_remove_waitqueue() holds an RCU read
-	 * lock, so we can be sure it's done after calling synchronize_rcu().
+	 * This is needed to avoid races between wake_up_pollfree() above and
+	 * someone else removing the last entry from the queue for other reasons
+	 * (e.g. ep_remove_wait_queue() being called due to an epoll file
+	 * descriptor being closed).  Such other users hold an RCU read lock, so
+	 * we can be sure they're done after we call synchronize_rcu().
 	 */
 	if (thread->looper & BINDER_LOOPER_STATE_POLL)
 		synchronize_rcu();
-- 
2.34.1

