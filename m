Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE9E4729C4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344063AbhLMKYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343565AbhLMKWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:22:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183D8C01389C;
        Mon, 13 Dec 2021 01:59:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4D2FB80E84;
        Mon, 13 Dec 2021 09:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6A4C34602;
        Mon, 13 Dec 2021 09:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389554;
        bh=V9ZrcY/d7BjvEsFuMaik7JWW8x2pC4HSZ7V8mOn9F0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vISBJlvCzOkIGIzSMbRKef9fqHvrzHtxUmQcchNhfBfhiZXXMTao1mzFtloYFge2D
         bEQgyIlMzFakAcVmnnBcsvlJbo5W7ebpP8wmnhbxExF3vHKwgSuPwQ42bCowFa7pvI
         X7n/5uSCeI7ypOjQQiEV6DR7/AaL2YkYYiSfHdLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 096/171] binder: use wake_up_pollfree()
Date:   Mon, 13 Dec 2021 10:30:11 +0100
Message-Id: <20211213092948.270657641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -4422,23 +4422,20 @@ static int binder_thread_release(struct
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


