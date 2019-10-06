Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B1CD410
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfJFRUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbfJFRUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:20:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF01C21835;
        Sun,  6 Oct 2019 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382417;
        bh=C6AbjV4f8ptNOGIJz+ANPjxCKhBIdSX/ugZ/YNSZmgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHaLORJfhGXH/nu/Zyzn1DtkZPLTm5jXzSl8DZ6iwj0tnqS1bxq7T2xFIPx2XDi1F
         f9YlccdAqVUkk2urplPZ/lzk2BO1Zv/ZwV0mnr18fsqykQW9MRk1Y8mta9atqQV525
         1BR5J1jSXJ8qRxa9CycOddIHbpC/yaLqSyF/asIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mattias Nissler <mnissler@chromium.org>
Subject: [PATCH 4.4 23/36] ANDROID: binder: remove waitqueue when thread exits.
Date:   Sun,  6 Oct 2019 19:19:05 +0200
Message-Id: <20191006171054.595539874@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org> # 4.14
[backport BINDER_LOOPER_STATE_POLL logic as well]
Signed-off-by: Mattias Nissler <mnissler@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -334,7 +334,8 @@ enum {
 	BINDER_LOOPER_STATE_EXITED      = 0x04,
 	BINDER_LOOPER_STATE_INVALID     = 0x08,
 	BINDER_LOOPER_STATE_WAITING     = 0x10,
-	BINDER_LOOPER_STATE_NEED_RETURN = 0x20
+	BINDER_LOOPER_STATE_NEED_RETURN = 0x20,
+	BINDER_LOOPER_STATE_POLL	= 0x40,
 };
 
 struct binder_thread {
@@ -2610,6 +2611,18 @@ static int binder_free_thread(struct bin
 		} else
 			BUG();
 	}
+
+	/*
+	 * If this thread used poll, make sure we remove the waitqueue
+	 * from any epoll data structures holding it with POLLFREE.
+	 * waitqueue_active() is safe to use here because we're holding
+	 * the inner lock.
+	 */
+	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
+	    waitqueue_active(&thread->wait)) {
+		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
+	}
+
 	if (send_reply)
 		binder_send_failed_reply(send_reply, BR_DEAD_REPLY);
 	binder_release_work(&thread->todo);
@@ -2633,6 +2646,8 @@ static unsigned int binder_poll(struct f
 		return POLLERR;
 	}
 
+	thread->looper |= BINDER_LOOPER_STATE_POLL;
+
 	wait_for_proc_work = thread->transaction_stack == NULL &&
 		list_empty(&thread->todo) && thread->return_error == BR_OK;
 


