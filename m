Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593F11F2E98
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgFIAnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbgFHXMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABA7620B80;
        Mon,  8 Jun 2020 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657938;
        bh=aN5brpsFZWSZstePsyj1eXrJmP0H8MYhQWcXHNeVZI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeLfjrPGnIBjd48EsveAaHCeHPVQKdPV0BhpIr6FXSHpQoE3vUSplL3KL5d3k/kSa
         vDm1dbtJT65cXhUYp85KBVTo7q2dqDr6UsM48dL9iTHTizTfLqVEmdY0y6tMz3Sh/Z
         gbP/UgYnAYU1pQ/SrlJd421JE/r6ZPBkNl1k93oc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Penyaev <rpenyaev@suse.de>, Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 005/606] epoll: call final ep_events_available() check under the lock
Date:   Mon,  8 Jun 2020 19:02:10 -0400
Message-Id: <20200608231211.3363633-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Penyaev <rpenyaev@suse.de>

[ Upstream commit 65759097d804d2a9ad2b687db436319704ba7019 ]

There is a possible race when ep_scan_ready_list() leaves ->rdllist and
->obflist empty for a short period of time although some events are
pending.  It is quite likely that ep_events_available() observes empty
lists and goes to sleep.

Since commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of
nested epoll") we are conservative in wakeups (there is only one place
for wakeup and this is ep_poll_callback()), thus ep_events_available()
must always observe correct state of two lists.

The easiest and correct way is to do the final check under the lock.
This does not impact the performance, since lock is taken anyway for
adding a wait entry to the wait queue.

The discussion of the problem can be found here:

   https://lore.kernel.org/linux-fsdevel/a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com/

In this patch barrierless __set_current_state() is used.  This is safe
since waitqueue_active() is called under the same lock on wakeup side.

Short-circuit for fatal signals (i.e.  fatal_signal_pending() check) is
moved to the line just before actual events harvesting routine.  This is
fully compliant to what is said in the comment of the patch where the
actual fatal_signal_pending() check was added: c257a340ede0 ("fs, epoll:
short circuit fetching events if thread has been killed").

Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Reported-by: Jason Baron <jbaron@akamai.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jason Baron <jbaron@akamai.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200505145609.1865152-1-rpenyaev@suse.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index b0a097274cfe..f5a481089893 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1857,34 +1857,33 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * event delivery.
 		 */
 		init_wait(&wait);
-		write_lock_irq(&ep->lock);
-		__add_wait_queue_exclusive(&ep->wq, &wait);
-		write_unlock_irq(&ep->lock);
 
+		write_lock_irq(&ep->lock);
 		/*
-		 * We don't want to sleep if the ep_poll_callback() sends us
-		 * a wakeup in between. That's why we set the task state
-		 * to TASK_INTERRUPTIBLE before doing the checks.
+		 * Barrierless variant, waitqueue_active() is called under
+		 * the same lock on wakeup ep_poll_callback() side, so it
+		 * is safe to avoid an explicit barrier.
 		 */
-		set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
 		/*
-		 * Always short-circuit for fatal signals to allow
-		 * threads to make a timely exit without the chance of
-		 * finding more events available and fetching
-		 * repeatedly.
+		 * Do the final check under the lock. ep_scan_ready_list()
+		 * plays with two lists (->rdllist and ->ovflist) and there
+		 * is always a race when both lists are empty for short
+		 * period of time although events are pending, so lock is
+		 * important.
 		 */
-		if (fatal_signal_pending(current)) {
-			res = -EINTR;
-			break;
+		eavail = ep_events_available(ep);
+		if (!eavail) {
+			if (signal_pending(current))
+				res = -EINTR;
+			else
+				__add_wait_queue_exclusive(&ep->wq, &wait);
 		}
+		write_unlock_irq(&ep->lock);
 
-		eavail = ep_events_available(ep);
-		if (eavail)
-			break;
-		if (signal_pending(current)) {
-			res = -EINTR;
+		if (eavail || res)
 			break;
-		}
 
 		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
 			timed_out = 1;
@@ -1905,6 +1904,15 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 	}
 
 send_events:
+	if (fatal_signal_pending(current)) {
+		/*
+		 * Always short-circuit for fatal signals to allow
+		 * threads to make a timely exit without the chance of
+		 * finding more events available and fetching
+		 * repeatedly.
+		 */
+		res = -EINTR;
+	}
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
 	 * there's still timeout left over, we go trying again in search of
-- 
2.25.1

