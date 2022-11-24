Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44D0636EC2
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 01:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKXAMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 19:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXAMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 19:12:13 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D02A391E0;
        Wed, 23 Nov 2022 16:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669248732; x=1700784732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FtoEGFIFtNtH2rZixELgHast4muQhN87FUrXFKCArio=;
  b=FWiB4Cg8z2psDns0HF0HLPauSOtBUxoZYvphWJghi5vjDuHpsAuPzV8k
   VI1U5XtD1tzOwggeaFgrGE0YbI6z93rKeCQTLG/Li4BfENAz4Sipr6OgE
   uCVKGTESr1/ANC2GiN4N/M5ycxalLjqZD6+S8/qHViQjmy3xMkOlfFBMz
   c=;
X-IronPort-AV: E=Sophos;i="5.96,187,1665446400"; 
   d="scan'208";a="154207588"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 00:12:10 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id ADEA0423D3;
        Thu, 24 Nov 2022 00:12:05 +0000 (UTC)
Received: from EX19D002UWA003.ant.amazon.com (10.13.138.235) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 24 Nov 2022 00:11:38 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D002UWA003.ant.amazon.com (10.13.138.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 24 Nov 2022 00:11:37 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 24 Nov 2022 00:11:36
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id C1383ABFD; Thu, 24 Nov 2022 00:11:36 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <shakeelb@google.com>,
        <viro@zeniv.linux.org.uk>, <bsegall@google.com>
CC:     <mdecandia@gmail.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "Guantao Liu" <guantaol@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 2/2] epoll: check for events when removing a timed out thread from the wait queue
Date:   Thu, 24 Nov 2022 00:11:23 +0000
Message-ID: <20221124001123.3248571-3-risbhat@amazon.com>
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

From: Soheil Hassas Yeganeh <soheil@google.com>

Commit 289caf5d8f6c61c6d2b7fd752a7f483cd153f182 upstream.

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
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 fs/eventpoll.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e5496483a882..877f9f61a4e8 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1928,23 +1928,30 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
2.37.1

