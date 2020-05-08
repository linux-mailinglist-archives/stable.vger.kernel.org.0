Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE4F1CBABF
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 00:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgEHWcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 18:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgEHWcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 18:32:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C5D224954;
        Fri,  8 May 2020 22:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588977154;
        bh=9O7aVXTprmnKzqIg94XpvK4wCmJquNVihz8396flCi8=;
        h=Date:From:To:Subject:From;
        b=SqeNT7/5crlGqhWVu8Me3eRtaC5QRKW70ITKcD1tTsB1BJD/2gID0h9Ny4FzRVXXR
         Tq488pe57pUl3aTOa8ZYGVvVjS5mrrT2fXyzqsq5B3Laa2Ri3/gFr2cM+RoEKgOvWh
         sGT2UIiJ9xsfJ9kCtNnZ4k+m1NcCHvbit+hppPs8=
Date:   Fri, 08 May 2020 15:32:34 -0700
From:   akpm@linux-foundation.org
To:     jbaron@akamai.com, khazhy@google.com, mm-commits@vger.kernel.org,
        r@hev.cc, rpenyaev@suse.de, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch removed
 from -mm tree
Message-ID: <20200508223234.3hxaFzIsF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: eventpoll: fix missing wakeup for ovflist in ep_poll_callback
has been removed from the -mm tree.  Its filename was
     eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Khazhismel Kumykov <khazhy@google.com>
Subject: eventpoll: fix missing wakeup for ovflist in ep_poll_callback

In the event that we add to ovflist, before 339ddb53d373 we would be woken
up by ep_scan_ready_list, and did no wakeup in ep_poll_callback.  With
that wakeup removed, if we add to ovflist here, we may never wake up. 
Rather than adding back the ep_scan_ready_list wakeup - which was
resulting in unnecessary wakeups, trigger a wake-up in ep_poll_callback.

We noticed that one of our workloads was missing wakeups starting with
339ddb53d373 and upon manual inspection, this wakeup seemed missing to me.
With this patch added, we no longer see missing wakeups.  I haven't yet
tried to make a small reproducer, but the existing kselftests in
filesystem/epoll passed for me with this patch.

[khazhy@google.com: use if/elif instead of goto + cleanup suggested by Roman]
  Link: http://lkml.kernel.org/r/20200424190039.192373-1-khazhy@google.com
Link: http://lkml.kernel.org/r/20200424025057.118641-1-khazhy@google.com
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Heiher <r@hev.cc>
Cc: Jason Baron <jbaron@akamai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/eventpoll.c~eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback
+++ a/fs/eventpoll.c
@@ -1171,6 +1171,10 @@ static inline bool chain_epi_lockless(st
 {
 	struct eventpoll *ep = epi->ep;
 
+	/* Fast preliminary check */
+	if (epi->next != EP_UNACTIVE_PTR)
+		return false;
+
 	/* Check that the same epi has not been just chained from another CPU */
 	if (cmpxchg(&epi->next, EP_UNACTIVE_PTR, NULL) != EP_UNACTIVE_PTR)
 		return false;
@@ -1237,16 +1241,12 @@ static int ep_poll_callback(wait_queue_e
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
_

Patches currently in -mm which might be from khazhy@google.com are


