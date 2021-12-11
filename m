Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1385B470F73
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbhLKAcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345465AbhLKAcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:32:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93190C061746;
        Fri, 10 Dec 2021 16:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFA46CE2DDB;
        Sat, 11 Dec 2021 00:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F143BC341C8;
        Sat, 11 Dec 2021 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639182524;
        bh=qpi9l/PqhmH2sxL4+/VUW06naq+hTMA57sGIqqM7cOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJvA63xxl6Z0qb5/SDWRrVYBY3jb1S5IC7KYh3HecXZSZmbHa7spkpVl88DMquDtM
         h+ZWI7XZF7ekzVhDfLYUPNSEpw4SkSMK79Wb0h3XIayBV5kJu18l+2StO75ala1P0J
         DfDhWO1qccurq9IIommOPwPuntdquNl66OQAecX2vqz5pDXOFElHH4sgHspuV/GLsP
         +rtWhWjVYXUjAQsWROpwIqOWMJYxPAP5UlsVd5j5ujfEbWbsawEKTLUwoYbhdJVKiN
         1Qyl4V1PcTAdx71tBvcD7MTnJQD/kxXaiNSPUfSUV1CnmogdqGauhe1uxknemSayKv
         V89/XCmQ+nzhg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4,4.9 2/3] binder: use wake_up_pollfree()
Date:   Fri, 10 Dec 2021 16:28:31 -0800
Message-Id: <20211211002832.153742-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211211002832.153742-1-ebiggers@kernel.org>
References: <20211211002832.153742-1-ebiggers@kernel.org>
MIME-Version: 1.0
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
---
 drivers/android/binder.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index bf047f16fce9e..31a204ebfa6c5 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2641,21 +2641,18 @@ static int binder_free_thread(struct binder_proc *proc,
 	}
 
 	/*
-	 * If this thread used poll, make sure we remove the waitqueue
-	 * from any epoll data structures holding it with POLLFREE.
-	 * waitqueue_active() is safe to use here because we're holding
-	 * the global lock.
+	 * If this thread used poll, make sure we remove the waitqueue from any
+	 * poll data structures holding it.
 	 */
-	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
-	    waitqueue_active(&thread->wait)) {
-		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
-	}
+	if (thread->looper & BINDER_LOOPER_STATE_POLL)
+		wake_up_pollfree(&thread->wait);
 
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

