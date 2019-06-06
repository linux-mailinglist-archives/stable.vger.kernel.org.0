Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1961537612
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 16:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfFFOJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 10:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfFFOJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 10:09:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14D6E30C34C4;
        Thu,  6 Jun 2019 14:08:57 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id D22F01084285;
        Thu,  6 Jun 2019 14:08:52 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  6 Jun 2019 16:08:56 +0200 (CEST)
Date:   Thu, 6 Jun 2019 16:08:52 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de, dbueso@suse.de,
        axboe@kernel.dk, dave@stgolabs.net, e@80x24.org, jbaron@akamai.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        omar.kilani@gmail.com, tglx@linutronix.de, stable@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH 1/2] select: change do_poll() to return -ERESTARTNOHAND
 rather than -EINTR
Message-ID: <20190606140852.GB13440@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <20190606140814.GA13440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606140814.GA13440@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 06 Jun 2019 14:09:12 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

do_poll() returns -EINTR if interrupted and after that all its callers
have to translate it into -ERESTARTNOHAND. Change do_poll() to return
-ERESTARTNOHAND and update (simplify) the callers.

Note that this also unifies all users of restore_saved_sigmask_unless(),
see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/select.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 1fc1b24..57712c3 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -925,7 +925,7 @@ static int do_poll(struct poll_list *list, struct poll_wqueues *wait,
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
-				count = -EINTR;
+				count = -ERESTARTNOHAND;
 		}
 		if (count || timed_out)
 			break;
@@ -1040,7 +1040,7 @@ static long do_restart_poll(struct restart_block *restart_block)
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	if (ret == -EINTR) {
+	if (ret == -ERESTARTNOHAND) {
 		restart_block->fn = do_restart_poll;
 		ret = -ERESTART_RESTARTBLOCK;
 	}
@@ -1061,7 +1061,7 @@ SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	if (ret == -EINTR) {
+	if (ret == -ERESTARTNOHAND) {
 		struct restart_block *restart_block;
 
 		restart_block = &current->restart_block;
@@ -1102,11 +1102,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-
-	restore_saved_sigmask_unless(ret == -EINTR);
-	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
-		ret = -ERESTARTNOHAND;
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
@@ -1135,11 +1131,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-
-	restore_saved_sigmask_unless(ret == -EINTR);
-	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
-		ret = -ERESTARTNOHAND;
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	return ret;
@@ -1413,11 +1405,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-
-	restore_saved_sigmask_unless(ret == -EINTR);
-	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
-		ret = -ERESTARTNOHAND;
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	return ret;
@@ -1446,11 +1434,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-
-	restore_saved_sigmask_unless(ret == -EINTR);
-	/* We can restart this syscall, usually */
-	if (ret == -EINTR)
-		ret = -ERESTARTNOHAND;
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
-- 
2.5.0


