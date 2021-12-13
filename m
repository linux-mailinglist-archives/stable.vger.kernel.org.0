Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BDB4724E3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhLMJj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhLMJh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:37:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CFEC08E84F;
        Mon, 13 Dec 2021 01:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E20F5CE0E89;
        Mon, 13 Dec 2021 09:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D819C341C8;
        Mon, 13 Dec 2021 09:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388211;
        bh=qQRcYqriZd8cBWq963OzjwCewfgW4UhreNkeb+jSpb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ib+CZJK6aHNBhYm6FMDBRO/gzSV8IfIridYLs4HtEqkWFANPAy1BlOLpaAa7FYldq
         bMSNoG/ygb1eq1q9Glb8Dg/qCQQf/3yUZUcjrEZbZhBHiVRHq37sa2W/sH4G8+P8+X
         u0CaSo4jIEVFjgljy6wAgK8lZdBo4amk3t+F5yqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org, Linus Torvalds" 
        <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 24/53] binder: use wake_up_pollfree()
Date:   Mon, 13 Dec 2021 10:30:03 +0100
Message-Id: <20211213092929.166801755@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit a880b28a71e39013e357fd3adccd1d8a31bc69a8 upstream.

wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
all exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.  epoll
and aio poll are fortunately not affected by this, but it's very
fragile.  Thus, the new function wake_up_pollfree() has been introduced.

Convert binder to use wake_up_pollfree().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread exits.")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211209010455.42744-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4336,23 +4336,20 @@ static int binder_thread_release(struct
 	}
 
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
-		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
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


