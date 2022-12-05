Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35A6434B1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbiLETtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbiLETsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:48:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6380F2A71C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05DB2B811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B8AC433C1;
        Mon,  5 Dec 2022 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269510;
        bh=BrYTrlNDPn3umQ3A3/PjFGXyZBcAAe/WxcxfFzvrk1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zx7RHaPHgojP8JmhmWloabi9mdZKshSYak4YRiVp/mknhOE6++TI/KrVXynzMprTj
         Ifxg0pak+ROnV6olzSmG2gMYiMTmVGrFsnwrLAidbh/5Z8KSluf3juFpzWjJEQ2354
         0qAdYrZCQe0k3iJ13F5DRSPiL7gKVsTjJ569ZxqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Soheil Hassas Yeganeh <soheil@google.com>,
        Guantao Liu <guantaol@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 143/153] epoll: check for events when removing a timed out thread from the wait queue
Date:   Mon,  5 Dec 2022 20:11:07 +0100
Message-Id: <20221205190812.717209660@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil@google.com>

commit 289caf5d8f6c61c6d2b7fd752a7f483cd153f182 upstream.

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
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1928,23 +1928,30 @@ fetch_events:
 		}
 		write_unlock_irq(&ep->lock);
 
-		if (eavail || res)
-			break;
-
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
-			timed_out = 1;
-			break;
-		}
-
-		/* We were woken up, thus go and try to harvest some events */
+		if (!eavail && !res)
+			timed_out = !schedule_hrtimeout_range(to, slack,
+							      HRTIMER_MODE_ABS);
+
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


