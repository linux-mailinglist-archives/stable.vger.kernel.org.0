Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0943787F7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbhEJLUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236096AbhEJLHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C57F6191F;
        Mon, 10 May 2021 10:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644294;
        bh=Io83Kb3ARhTR0rwI6TNaCpzuTfgWzS115D2hkwnVGY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEKUV5owWKYldLJAQaKiieV730tpOZzWdbtJOkTlMtXo+qqlkhVf4YTIugnRg2eqn
         zPWKwPXEF8hcjms5Ppva1GGEGniZUHJNXipeX7LUV8w81E+Y7wz4UxAp10vFX7wGNt
         wO8GmyLLxFc/ux/p5dHmp3740jO935wmwTnyKmiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jason Baron <jbaron@akamai.com>,
        Roman Penyaev <rpenyaev@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 023/384] fs/epoll: restore waking from ep_done_scan()
Date:   Mon, 10 May 2021 12:16:52 +0200
Message-Id: <20210510102015.639784691@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

commit 7fab29e356309ff93a4b30ecc466129682ec190b upstream.

Commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested
epoll") changed the userspace visible behavior of exclusive waiters
blocked on a common epoll descriptor upon a single event becoming ready.

Previously, all tasks doing epoll_wait would awake, and now only one is
awoken, potentially causing missed wakeups on applications that rely on
this behavior, such as Apache Qpid.

While the aforementioned commit aims at having only a wakeup single path
in ep_poll_callback (with the exceptions of epoll_ctl cases), we need to
restore the wakeup in what was the old ep_scan_ready_list() such that
the next thread can be awoken, in a cascading style, after the waker's
corresponding ep_send_events().

Link: https://lkml.kernel.org/r/20210405231025.33829-3-dave@stgolabs.net
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
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
 


