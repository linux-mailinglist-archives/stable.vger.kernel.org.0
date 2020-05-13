Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9771D0EC1
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgEMJuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgEMJuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D5C23128;
        Wed, 13 May 2020 09:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363402;
        bh=H6RK4Fn9JCQrahNvg7ybV844UB/P0cnu7StCAIBei8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIABCVsMFeUEcsIOh0l7E83e8/AJBwu6FIxD9JFjf5wzYgfwJOzn85/kf5TbSfyB+
         YufsjvSRjyXbtYqOqJfyTOBsHqF0OoTFBTsauxFCkKVbeOrDPEhFnKrVC/2Rg3jmlQ
         n8dqLzLDb7mDStmfqrYPexHvmoIYq2dmGK75f1Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Penyaev <rpenyaev@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 59/90] eventpoll: fix missing wakeup for ovflist in ep_poll_callback
Date:   Wed, 13 May 2020 11:44:55 +0200
Message-Id: <20200513094415.943881845@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khazhismel Kumykov <khazhy@google.com>

commit 0c54a6a44bf3d41e76ce3f583a6ece267618df2e upstream.

In the event that we add to ovflist, before commit 339ddb53d373
("fs/epoll: remove unnecessary wakeups of nested epoll") we would be
woken up by ep_scan_ready_list, and did no wakeup in ep_poll_callback.

With that wakeup removed, if we add to ovflist here, we may never wake
up.  Rather than adding back the ep_scan_ready_list wakeup - which was
resulting in unnecessary wakeups, trigger a wake-up in ep_poll_callback.

We noticed that one of our workloads was missing wakeups starting with
339ddb53d373 and upon manual inspection, this wakeup seemed missing to me.
With this patch added, we no longer see missing wakeups.  I haven't yet
tried to make a small reproducer, but the existing kselftests in
filesystem/epoll passed for me with this patch.

[khazhy@google.com: use if/elif instead of goto + cleanup suggested by Roman]
  Link: http://lkml.kernel.org/r/20200424190039.192373-1-khazhy@google.com
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Heiher <r@hev.cc>
Cc: Jason Baron <jbaron@akamai.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200424025057.118641-1-khazhy@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1176,6 +1176,10 @@ static inline bool chain_epi_lockless(st
 {
 	struct eventpoll *ep = epi->ep;
 
+	/* Fast preliminary check */
+	if (epi->next != EP_UNACTIVE_PTR)
+		return false;
+
 	/* Check that the same epi has not been just chained from another CPU */
 	if (cmpxchg(&epi->next, EP_UNACTIVE_PTR, NULL) != EP_UNACTIVE_PTR)
 		return false;
@@ -1242,16 +1246,12 @@ static int ep_poll_callback(wait_queue_e
 	 * chained in ep->ovflist and requeued later on.
 	 */
 	if (READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR) {
-		if (epi->next == EP_UNACTIVE_PTR &&
-		    chain_epi_lockless(epi))
+		if (chain_epi_lockless(epi))
+			ep_pm_stay_awake_rcu(epi);
+	} else if (!ep_is_linked(epi)) {
+		/* In the usual case, add event to ready list. */
+		if (list_add_tail_lockless(&epi->rdllink, &ep->rdllist))
 			ep_pm_stay_awake_rcu(epi);
-		goto out_unlock;
-	}
-
-	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(epi) &&
-	    list_add_tail_lockless(&epi->rdllink, &ep->rdllist)) {
-		ep_pm_stay_awake_rcu(epi);
 	}
 
 	/*


