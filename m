Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4CA636EC0
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 01:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiKXALp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 19:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiKXALn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 19:11:43 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7668657C8;
        Wed, 23 Nov 2022 16:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669248702; x=1700784702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HsaYmEBZ2D4kRCGcsqMdWbhVBRYbJtEAV6N40hYOmOo=;
  b=FuNJnXFTvftzTUMyjI9DtamtXRzbPRclRmG5dMShElCUepIxt6xqZqmU
   CdU5sjsghgu7Dn7M/vcA8xyHAKXxGY5yQE6T2EAE/ZYvth4mJWtuXwred
   4z7pfvVzMn8plFFO6MpSdF/Nx78RsL0dMVhdVJe1Ry1zuYglc7TMxlk9f
   A=;
X-IronPort-AV: E=Sophos;i="5.96,187,1665446400"; 
   d="scan'208";a="154218830"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 00:11:40 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id D3AD8C1F69;
        Thu, 24 Nov 2022 00:11:36 +0000 (UTC)
Received: from EX19D002UWC003.ant.amazon.com (10.13.138.183) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 24 Nov 2022 00:11:35 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC003.ant.amazon.com (10.13.138.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 24 Nov 2022 00:11:35 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 24 Nov 2022 00:11:35
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id B0195ABFD; Thu, 24 Nov 2022 00:11:35 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <shakeelb@google.com>,
        <viro@zeniv.linux.org.uk>, <bsegall@google.com>
CC:     <mdecandia@gmail.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Roman Penyaev <rpenyaev@suse.de>,
        Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 1/2] epoll: call final ep_events_available() check under the lock
Date:   Thu, 24 Nov 2022 00:11:22 +0000
Message-ID: <20221124001123.3248571-2-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221124001123.3248571-1-risbhat@amazon.com>
References: <20221124001123.3248571-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Penyaev <rpenyaev@suse.de>

Commit 65759097d804d2a9ad2b687db436319704ba7019 upstream.

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
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 fs/eventpoll.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7e11135bc915..e5496483a882 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1905,33 +1905,31 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
@@ -1952,6 +1950,15 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
2.37.1

