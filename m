Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE43C3C51F5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349586AbhGLHoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349379AbhGLHl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57EF660FF3;
        Mon, 12 Jul 2021 07:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075548;
        bh=BAFU7XVbOgmnXzHVElnLhdiGFbJEgWoDgMv0T85c/Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Guzmoo1mUVEeHOaYirFqKQ4j3BOSLCsgrZG1O2pPICqjpzr4CP+HhcagCaFzzNaLh
         3Dqlp866momXmrqvDulBwTLY2rJ+MUkHtpGU1cGQOQ9UxgdZ9x6FhSvJDXpHEYJeEn
         3dx1Q0sa4Le7WT8M3xsd3F1gsUxbNCYW1t1Mh5jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan@google.com>,
        jenhaochen@google.com, Martin Liu <liumartin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 262/800] kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()
Date:   Mon, 12 Jul 2021 08:04:45 +0200
Message-Id: <20210712060951.429492452@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit d71ba1649fa3c464c51ec7163e4b817345bff2c7 ]

kthread_mod_delayed_work() might race with
kthread_cancel_delayed_work_sync() or another kthread_mod_delayed_work()
call.  The function lets the other operation win when it sees
work->canceling counter set.  And it returns @false.

But it should return @true as it is done by the related workqueue API, see
mod_delayed_work_on().

The reason is that the return value might be used for reference counting.
It has to distinguish the case when the number of queued works has changed
or stayed the same.

The change is safe.  kthread_mod_delayed_work() return value is not
checked anywhere at the moment.

Link: https://lore.kernel.org/r/20210521163526.GA17916@redhat.com
Link: https://lkml.kernel.org/r/20210610133051.15337-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: <jenhaochen@google.com>
Cc: Martin Liu <liumartin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kthread.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 6e02094849d3..08931e525dd9 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1162,14 +1162,14 @@ static bool __kthread_cancel_work(struct kthread_work *work)
  * modify @dwork's timer so that it expires after @delay. If @delay is zero,
  * @work is guaranteed to be queued immediately.
  *
- * Return: %true if @dwork was pending and its timer was modified,
- * %false otherwise.
+ * Return: %false if @dwork was idle and queued, %true otherwise.
  *
  * A special case is when the work is being canceled in parallel.
  * It might be caused either by the real kthread_cancel_delayed_work_sync()
  * or yet another kthread_mod_delayed_work() call. We let the other command
- * win and return %false here. The caller is supposed to synchronize these
- * operations a reasonable way.
+ * win and return %true here. The return value can be used for reference
+ * counting and the number of queued works stays the same. Anyway, the caller
+ * is supposed to synchronize these operations a reasonable way.
  *
  * This function is safe to call from any context including IRQ handler.
  * See __kthread_cancel_work() and kthread_delayed_work_timer_fn()
@@ -1181,13 +1181,15 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
 {
 	struct kthread_work *work = &dwork->work;
 	unsigned long flags;
-	int ret = false;
+	int ret;
 
 	raw_spin_lock_irqsave(&worker->lock, flags);
 
 	/* Do not bother with canceling when never queued. */
-	if (!work->worker)
+	if (!work->worker) {
+		ret = false;
 		goto fast_queue;
+	}
 
 	/* Work must not be used with >1 worker, see kthread_queue_work() */
 	WARN_ON_ONCE(work->worker != worker);
@@ -1205,8 +1207,11 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
 	 * be used for reference counting.
 	 */
 	kthread_cancel_delayed_work_timer(work, &flags);
-	if (work->canceling)
+	if (work->canceling) {
+		/* The number of works in the queue does not change. */
+		ret = true;
 		goto out;
+	}
 	ret = __kthread_cancel_work(work);
 
 fast_queue:
-- 
2.30.2



