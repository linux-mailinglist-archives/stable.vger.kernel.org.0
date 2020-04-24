Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0E11B6BF8
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 05:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgDXDcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 23:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbgDXDcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 23:32:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04A320715;
        Fri, 24 Apr 2020 03:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587699134;
        bh=heYBxyRSj6OCmDC8ifkTZrTjLvYjcxlqxGx3/mMEEfM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ltAJ2OTIhE3L6u1YdG/qUhtRaT9KYhoxi55ErXlp9wTMEeMJXTy3Dq1yD20kkzF/Y
         gOV0uuInsAcG2d3RY31fzfJ+gGOyS3oQoANKOWAJIoF8abV8j/JRgEPP90JXpZmuur
         fw1gC5wpVQ8jWFbcwiSn+uGerYmkjKbeIzk6KtPU=
Date:   Thu, 23 Apr 2020 20:32:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jbaron@akamai.com, khazhy@google.com, mm-commits@vger.kernel.org,
        r@hev.cc, rpenyaev@suse.de, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch added to
 -mm tree
Message-ID: <20200424033213.WRxjDVHj1%akpm@linux-foundation.org>
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: eventpoll: fix missing wakeup for ovflist in ep_poll_callback
has been added to the -mm tree.  Its filename is
     eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Khazhismel Kumykov <khazhy@google.com>
Subject: eventpoll: fix missing wakeup for ovflist in ep_poll_callback

In the event that we add to ovflist, before 339ddb53d373 we would be woken
up by ep_scan_ready_list, and did no wakeup in ep_poll_callback.  With
that wakeup removed, if we add to ovflist here, we may never wake up. 
Rather than adding back the ep_scan_ready_list wakeup - which was
resulting un uncessary wakeups, trigger a wake-up in ep_poll_callback.

We noticed that one of our workloads was missing wakeups starting with
339ddb53d373 and upon manual inspection, this wakeup seemed missing to me.
With this patch added, we no longer see missing wakeups.  I haven't yet
tried to make a small reproducer, but the existing kselftests in
filesystem/epoll passed for me with this patch.

Link: http://lkml.kernel.org/r/20200424025057.118641-1-khazhy@google.com
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Heiher <r@hev.cc>
Cc: Jason Baron <jbaron@akamai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c~eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback
+++ a/fs/eventpoll.c
@@ -1240,7 +1240,7 @@ static int ep_poll_callback(wait_queue_e
 		if (epi->next == EP_UNACTIVE_PTR &&
 		    chain_epi_lockless(epi))
 			ep_pm_stay_awake_rcu(epi);
-		goto out_unlock;
+		goto out_wakeup_unlock;
 	}
 
 	/* If this file is already in the ready list we exit soon */
@@ -1249,6 +1249,7 @@ static int ep_poll_callback(wait_queue_e
 		ep_pm_stay_awake_rcu(epi);
 	}
 
+out_wakeup_unlock:
 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 	 * wait list.
_

Patches currently in -mm which might be from khazhy@google.com are

eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch

