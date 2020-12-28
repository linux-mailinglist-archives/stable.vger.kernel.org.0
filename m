Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7642E4018
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbgL1OsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502726AbgL1OWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83892207B2;
        Mon, 28 Dec 2020 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165325;
        bh=bGare5+V4WK81xVo1PvOlyd3KvpwimvlkV0R4giQkh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec6CEB8r6MDYFTMwznW/CjcVv2E/QHfMfVXPez2Ctj8cQyU5r+x8m4kTcE4LABKhm
         N8acgsHw3CR8EKrzdViRdSqTIaZv5ODyxUDcEO+0ox/3C3apz2fa/Vwvr8QQNC3HYc
         kM/TY/c75QxzCYFI8FAc7FV/6xaV3LQFaybLUmzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Guantao Liu <guantaol@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/717] epoll: check for events when removing a timed out thread from the wait queue
Date:   Mon, 28 Dec 2020 13:48:11 +0100
Message-Id: <20201228125044.585494704@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil@google.com>

[ Upstream commit 289caf5d8f6c61c6d2b7fd752a7f483cd153f182 ]

Patch series "simplify ep_poll".

This patch series is a followup based on the suggestions and feedback by
Linus:
https://lkml.kernel.org/r/CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com

The first patch in the series is a fix for the epoll race in presence of
timeouts, so that it can be cleanly backported to all affected stable
kernels.

The rest of the patch series simplify the ep_poll() implementation.  Some
of these simplifications result in minor performance enhancements as well.
We have kept these changes under self tests and internal benchmarks for a
few days, and there are minor (1-2%) performance enhancements as a result.

This patch (of 8):

After abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2)
timeout"), we break out of the ep_poll loop upon timeout, without checking
whether there is any new events available.  Prior to that patch-series we
always called ep_events_available() after exiting the loop.

This can cause races and missed wakeups.  For example, consider the
following scenario reported by Guantao Liu:

Suppose we have an eventfd added using EPOLLET to an epollfd.

Thread 1: Sleeps for just below 5ms and then writes to an eventfd.
Thread 2: Calls epoll_wait with a timeout of 5 ms. If it sees an
          event of the eventfd, it will write back on that fd.
Thread 3: Calls epoll_wait with a negative timeout.

Prior to abc610e01c66, it is guaranteed that Thread 3 will wake up either
by Thread 1 or Thread 2.  After abc610e01c66, Thread 3 can be blocked
indefinitely if Thread 2 sees a timeout right before the write to the
eventfd by Thread 1.  Thread 2 will be woken up from
schedule_hrtimeout_range and, with evail 0, it will not call
ep_send_events().

To fix this issue:
1) Simplify the timed_out case as suggested by Linus.
2) while holding the lock, recheck whether the thread was woken up
   after its time out has reached.

Note that (2) is different from Linus' original suggestion: It do not set
"eavail = ep_events_available(ep)" to avoid unnecessary contention (when
there are too many timed-out threads and a small number of events), as
well as races mentioned in the discussion thread.

This is the first patch in the series so that the backport to stable
releases is straightforward.

Link: https://lkml.kernel.org/r/20201106231635.3528496-1-soheil.kdev@gmail.com
Link: https://lkml.kernel.org/r/CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com
Link: https://lkml.kernel.org/r/20201106231635.3528496-2-soheil.kdev@gmail.com
Fixes: abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2) timeout")
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Tested-by: Guantao Liu <guantaol@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Guantao Liu <guantaol@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4df61129566d4..117b1c395ae4a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1902,23 +1902,30 @@ fetch_events:
 		}
 		write_unlock_irq(&ep->lock);
 
-		if (eavail || res)
-			break;
+		if (!eavail && !res)
+			timed_out = !schedule_hrtimeout_range(to, slack,
+							      HRTIMER_MODE_ABS);
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
-			timed_out = 1;
-			break;
-		}
-
-		/* We were woken up, thus go and try to harvest some events */
+		/*
+		 * We were woken up, thus go and try to harvest some events.
+		 * If timed out and still on the wait queue, recheck eavail
+		 * carefully under lock, below.
+		 */
 		eavail = 1;
-
 	} while (0);
 
 	__set_current_state(TASK_RUNNING);
 
 	if (!list_empty_careful(&wait.entry)) {
 		write_lock_irq(&ep->lock);
+		/*
+		 * If the thread timed out and is not on the wait queue, it
+		 * means that the thread was woken up after its timeout expired
+		 * before it could reacquire the lock. Thus, when wait.entry is
+		 * empty, it needs to harvest events.
+		 */
+		if (timed_out)
+			eavail = list_empty(&wait.entry);
 		__remove_wait_queue(&ep->wq, &wait);
 		write_unlock_irq(&ep->lock);
 	}
-- 
2.27.0



