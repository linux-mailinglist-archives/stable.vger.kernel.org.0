Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA9D1161FA
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfLHN4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60358 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbfLHNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0007fk-Kd; Sun, 08 Dec 2019 13:54:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0002OI-8v; Sun, 08 Dec 2019 13:54:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Martijn Coenen" <maco@android.com>,
        "Mattias Nissler" <mnissler@chromium.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sun, 08 Dec 2019 13:53:32 +0000
Message-ID: <lsq.1575813165.964374927@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 48/72] ANDROID: binder: remove waitqueue when thread
 exits.
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn Coenen <maco@android.com>

commit f5cb779ba16334b45ba8946d6bfa6d9834d1527f upstream.

binder_poll() passes the thread->wait waitqueue that
can be slept on for work. When a thread that uses
epoll explicitly exits using BINDER_THREAD_EXIT,
the waitqueue is freed, but it is never removed
from the corresponding epoll data structure. When
the process subsequently exits, the epoll cleanup
code tries to access the waitlist, which results in
a use-after-free.

Prevent this by using POLLFREE when the thread exits.

Signed-off-by: Martijn Coenen <maco@android.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
[backport BINDER_LOOPER_STATE_POLL logic as well]
Signed-off-by: Mattias Nissler <mnissler@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/android/binder.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -329,7 +329,8 @@ enum {
 	BINDER_LOOPER_STATE_EXITED      = 0x04,
 	BINDER_LOOPER_STATE_INVALID     = 0x08,
 	BINDER_LOOPER_STATE_WAITING     = 0x10,
-	BINDER_LOOPER_STATE_NEED_RETURN = 0x20
+	BINDER_LOOPER_STATE_NEED_RETURN = 0x20,
+	BINDER_LOOPER_STATE_POLL	= 0x40,
 };
 
 struct binder_thread {
@@ -2554,6 +2555,18 @@ static int binder_free_thread(struct bin
 		} else
 			BUG();
 	}
+
+	/*
+	 * If this thread used poll, make sure we remove the waitqueue
+	 * from any epoll data structures holding it with POLLFREE.
+	 * waitqueue_active() is safe to use here because we're holding
+	 * the global lock.
+	 */
+	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
+	    waitqueue_active(&thread->wait)) {
+		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
+	}
+
 	if (send_reply)
 		binder_send_failed_reply(send_reply, BR_DEAD_REPLY);
 	binder_release_work(&thread->todo);
@@ -2577,6 +2590,8 @@ static unsigned int binder_poll(struct f
 		return POLLERR;
 	}
 
+	thread->looper |= BINDER_LOOPER_STATE_POLL;
+
 	wait_for_proc_work = thread->transaction_stack == NULL &&
 		list_empty(&thread->todo) && thread->return_error == BR_OK;
 

