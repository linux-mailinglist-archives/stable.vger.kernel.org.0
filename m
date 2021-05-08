Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932E6377475
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 00:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 18:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 18:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DAB61402;
        Sat,  8 May 2021 22:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514399;
        bh=27wRMLGCi6YeKKvV31K2TcEHPms/kTvMZS4NCDoypsc=;
        h=Date:From:To:Subject:From;
        b=emR73mIyplXIxViz5pk8hPcsoZHVgZ8z/ywDAD3uLN3Xigq+KIGcRg+BVI4/+ufJG
         tHjThDavD7Ad33ernltfLqQP/sGdeds84pUvQWIZ8rSBkjNtyPfqjbDKbghmj4HNzE
         pHqLjsAQYnuOzFdWenBJQDC4mtcz+OvMWLl9Gtws=
Date:   Sat, 08 May 2021 15:53:19 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, dbueso@suse.de, jbaron@akamai.com,
        mm-commits@vger.kernel.org, rpenyaev@suse.de,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged] fs-epoll-restore-waking-from-ep_done_scan.patch
 removed from -mm tree
Message-ID: <20210508225319.NKQs9i8ok%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/epoll: restore waking from ep_done_scan()
has been removed from the -mm tree.  Its filename was
     fs-epoll-restore-waking-from-ep_done_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dave@stgolabs.net are


