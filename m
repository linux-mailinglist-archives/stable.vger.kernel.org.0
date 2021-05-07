Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DEA375E2D
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 03:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhEGBFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 21:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 21:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D31F61289;
        Fri,  7 May 2021 01:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349448;
        bh=ywG4yXXZ9eivodlDtaUiW9MkrJJEsrhDYn0L37s0iYU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tF6aVm4OY4nxbOG2rNj/LlE4PXXG7dMKQ2XQdjQqAkx1EKG84Pe/HWPiyqzY24eTL
         S1Vuva/TS3uos482eIHq9LARmJcYWT6N/RjmsFhZnZxcUSoOuRd/WLuxc7bkB/l589
         BOAKvLq4Y2hQannvz+qq86up45wVdipEVAKsAKRI=
Date:   Thu, 06 May 2021 18:04:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de,
        jbaron@akamai.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rpenyaev@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 40/91] fs/epoll: restore waking from
 ep_done_scan()
Message-ID: <20210507010407.7J59uHTtq%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: fs/epoll: restore waking from ep_done_scan()

339ddb53d373 (fs/epoll: remove unnecessary wakeups of nested epoll)
changed the userspace visible behavior of exclusive waiters blocked on a
common epoll descriptor upon a single event becoming ready.  Previously,
all tasks doing epoll_wait would awake, and now only one is awoken,
potentially causing missed wakeups on applications that rely on this
behavior, such as Apache Qpid.

While the aforementioned commit aims at having only a wakeup single path
in ep_poll_callback (with the exceptions of epoll_ctl cases), we need to
restore the wakeup in what was the old ep_scan_ready_list() such that the
next thread can be awoken, in a cascading style, after the waker's
corresponding ep_send_events().

Link: https://lkml.kernel.org/r/20210405231025.33829-3-dave@stgolabs.net
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/eventpoll.c~fs-epoll-restore-waking-from-ep_done_scan
+++ a/fs/eventpoll.c
@@ -657,6 +657,12 @@ static void ep_done_scan(struct eventpol
 	 */
 	list_splice(txlist, &ep->rdllist);
 	__pm_relax(ep->ws);
+
+	if (!list_empty(&ep->rdllist)) {
+		if (waitqueue_active(&ep->wq))
+			wake_up(&ep->wq);
+	}
+
 	write_unlock_irq(&ep->lock);
 }
 
_
