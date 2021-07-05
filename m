Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797283BC056
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhGEPfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231622AbhGEPeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C73A3619D4;
        Mon,  5 Jul 2021 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499070;
        bh=Ims1rXSAGRxN6QiBEy5sg3G9fANKxXysNCIqQN6rQ8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLQbNyK9YSU6y/u2DxmZ6ZAcZB7Yo6ef48GZQpHI9rHiAz+YjbdI8dPEtuV46U/6m
         8SNFuHGMsImQOD045Fb597EsIq1hVumobNXMA8yLcpGRKbd+MJa1UaKSW5TaUOaV1/
         Ue5ZBoUIqwgbRoXoXxk8/5pQnrCiS0vkOrmBmk2r/wz34w8UJVS7f1/q8vWZrvLE7D
         /fLtFZPA9t369bnBb9gqd3FyE/29jVTGcjfhx1sLiEhonUDE8IWT7gdMhbd5gscjfl
         glI6qlV8jXOcxG3AoqPObYe8obgNrp/HPePohuAS0b2H3Y8k/J+Hx0PnvlTe84ampj
         y9a8ZcQZfdC2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>, Oleg Nesterov <oleg@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan@google.com>,
        jenhaochen@google.com, Martin Liu <liumartin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 24/26] kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()
Date:   Mon,  5 Jul 2021 11:30:37 -0400
Message-Id: <20210705153039.1521781-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2eb8d7550324..b2bac5d929d2 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1083,14 +1083,14 @@ static bool __kthread_cancel_work(struct kthread_work *work)
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
@@ -1102,13 +1102,15 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
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
@@ -1126,8 +1128,11 @@ bool kthread_mod_delayed_work(struct kthread_worker *worker,
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

