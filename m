Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A6746E001
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbhLIBKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 20:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241723AbhLIBKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 20:10:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84814C061746;
        Wed,  8 Dec 2021 17:06:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E284B8235B;
        Thu,  9 Dec 2021 01:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81510C341CA;
        Thu,  9 Dec 2021 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639011988;
        bh=JSyZz0sb7RhFw3Zf+ynfEZJrO9JuZhu8RB5wW2VzICE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYfFZYF9PWn4E0itq5qzHz2Fkzp2T0qSCiTnG4jxoWJGE9dC1KOjuFwAPx9ndZNkD
         a2+Wh4DKFqBqSQxDGYnBDiIohvgBbpCJW7HtlCwtU1JNdwB44wZOsf69MDxzY1AXPZ
         U+2aQ4ThGx6no4X9m9faRTlACCs2BVx+bSNgyvdzKr/FZfoVRJ219iWKuAMiD1GOdB
         w3DQSPzE9s5QHtI5U0hccgYiQcCwng4uLAS9R31zsiHRr1ztcmnl54iB8I2+vJHszh
         /hxTrKj8v7yMDqkO+IaVBBam+qivLRiCa5wyoIkKxysjllcfAhRN5Y4VHelKReSoFy
         GLGiV6uYXj5MA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/5] binder: use wake_up_pollfree()
Date:   Wed,  8 Dec 2021 17:04:52 -0800
Message-Id: <20211209010455.42744-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209010455.42744-1-ebiggers@kernel.org>
References: <20211209010455.42744-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
all exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.  epoll
and aio poll are fortunately not affected by this, but it's very
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

