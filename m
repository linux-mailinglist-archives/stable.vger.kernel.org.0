Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568AA6434AC
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiLETsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiLETsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:48:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0722A409
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AECE612EA
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4708BC433D6;
        Mon,  5 Dec 2022 19:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269499;
        bh=Rx2GmuUzDJD6XPZYdKsG6ioRe9cBY+L9Fi8T8pksxpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSx6skyQUpWJCvJ2Zm8WZ6WA5AStGxvMpwYOZsFI7pAQ2PmLBIvwwR2xCZ9o6FEp2
         Mo48ivxTa1cbHlBjZ2jhtjy9WuOyi9NfjmcfIx2HpQa//M00xmfArBPd6kHFo5SNp8
         VVrs67cynmDDJ9DMmgbT8huFEmdE18b70YxC7Lns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Roman Penyaev <rpenyaev@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 142/153] epoll: call final ep_events_available() check under the lock
Date:   Mon,  5 Dec 2022 20:11:06 +0100
Message-Id: <20221205190812.693368567@linuxfoundation.org>
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

From: Roman Penyaev <rpenyaev@suse.de>

commit 65759097d804d2a9ad2b687db436319704ba7019 upstream.

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
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1905,33 +1905,31 @@ fetch_events:
 		init_wait(&wait);
 		wait.func = ep_autoremove_wake_function;
 		write_lock_irq(&ep->lock);
-		__add_wait_queue_exclusive(&ep->wq, &wait);
-		write_unlock_irq(&ep->lock);
-
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
@@ -1952,6 +1950,15 @@ fetch_events:
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


