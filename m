Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F69D470F10
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244195AbhLJX53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243900AbhLJX52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:57:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE863C061746;
        Fri, 10 Dec 2021 15:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A7FCB82A0F;
        Fri, 10 Dec 2021 23:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B284C341C8;
        Fri, 10 Dec 2021 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180430;
        bh=2bzW2w7aAtN6vTz8wSsCi2t78/V3+vf900A/oTHd8Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8boaELvu+qqivdngAfArCcUEUBehpTFctWlexqVQiBTY4iyEjVFbYX7Ncufia208
         dA3yr0IgtOFM1uTL1c3LTYI0CIYSWgquAX6tKwZ6NADTK3eAxvlvPw03oaMU261g2T
         tPAx4rywiwRSTgd0CTZ/xns37FzVHSTDt3r73ad3YRC/PtKgLgqvQ27c1tIg9G1XuE
         E+LfayKkY1x+SkBbW4Op5wyGrF1T3hzRYl5sDjqbz1Vs8a0Xnr+OqKHngJpAv8N/qM
         9rSpGxLqWyrDx8lBqH/DncoHEwyBI23qxmtR2ZBoyp4Z7Jk553BIERw3fMUQnJuuKE
         NIXssVky/oZag==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 2/5] binder: use wake_up_pollfree()
Date:   Fri, 10 Dec 2021 15:53:09 -0800
Message-Id: <20211210235312.40412-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210235312.40412-1-ebiggers@kernel.org>
References: <20211210235312.40412-1-ebiggers@kernel.org>
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
index 9229c5c9ad473..35c13be4adc60 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4416,23 +4416,20 @@ static int binder_thread_release(struct binder_proc *proc,
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

