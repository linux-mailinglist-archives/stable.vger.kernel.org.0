Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301F937614
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 16:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfFFOJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 10:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfFFOJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 10:09:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85681307D95F;
        Thu,  6 Jun 2019 14:09:22 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 37DB68185;
        Thu,  6 Jun 2019 14:09:16 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  6 Jun 2019 16:09:22 +0200 (CEST)
Date:   Thu, 6 Jun 2019 16:09:15 +0200
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
Subject: [PATCH 2/2] select: shift restore_saved_sigmask_unless() into
 poll_select_copy_remaining()
Message-ID: <20190606140915.GC13440@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <20190606140814.GA13440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606140814.GA13440@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 06 Jun 2019 14:09:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that restore_saved_sigmask_unless() is always called with the same
argument right before poll_select_copy_remaining() we can move it into
poll_select_copy_remaining() and make it the only caller of restore()
in fs/select.c.

The patch also renames poll_select_copy_remaining(), poll_select_finish()
looks better after this change.

kern_select() doesn't use set_user_sigmask(), so in this case
poll_select_finish() does restore_saved_sigmask_unless() "for no reason".
But this won't hurt, and WARN_ON(!TIF_SIGPENDING) is still valid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/select.c | 46 +++++++++++++---------------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 57712c3..51ceec2 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -294,12 +294,14 @@ enum poll_time_type {
 	PT_OLD_TIMESPEC = 3,
 };
 
-static int poll_select_copy_remaining(struct timespec64 *end_time,
-				      void __user *p,
-				      enum poll_time_type pt_type, int ret)
+static int poll_select_finish(struct timespec64 *end_time,
+			      void __user *p,
+			      enum poll_time_type pt_type, int ret)
 {
 	struct timespec64 rts;
 
+	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
+
 	if (!p)
 		return ret;
 
@@ -714,9 +716,7 @@ static int kern_select(int n, fd_set __user *inp, fd_set __user *outp,
 	}
 
 	ret = core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tvp, PT_TIMEVAL, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tvp, PT_TIMEVAL, ret);
 }
 
 SYSCALL_DEFINE5(select, int, n, fd_set __user *, inp, fd_set __user *, outp,
@@ -757,10 +757,7 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
-	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
-	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tsp, type, ret);
 }
 
 /*
@@ -1102,10 +1099,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
-	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tsp, PT_TIMESPEC, ret);
 }
 
 #if defined(CONFIG_COMPAT_32BIT_TIME) && !defined(CONFIG_64BIT)
@@ -1131,10 +1125,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
-	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 }
 #endif
 
@@ -1271,9 +1262,7 @@ static int do_compat_select(int n, compat_ulong_t __user *inp,
 	}
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tvp, PT_OLD_TIMEVAL, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tvp, PT_OLD_TIMEVAL, ret);
 }
 
 COMPAT_SYSCALL_DEFINE5(select, int, n, compat_ulong_t __user *, inp,
@@ -1333,10 +1322,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
-	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tsp, type, ret);
 }
 
 COMPAT_SYSCALL_DEFINE6(pselect6_time64, int, n, compat_ulong_t __user *, inp,
@@ -1405,10 +1391,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
-	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 }
 #endif
 
@@ -1434,10 +1417,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 		return ret;
 
 	ret = do_sys_poll(ufds, nfds, to);
-	restore_saved_sigmask_unless(ret == -ERESTARTNOHAND);
-	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
-
-	return ret;
+	return poll_select_finish(&end_time, tsp, PT_TIMESPEC, ret);
 }
 
 #endif
-- 
2.5.0


