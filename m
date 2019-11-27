Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5883610B9B0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfK0Uzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbfK0Uzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE3921582;
        Wed, 27 Nov 2019 20:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888149;
        bh=qnPaGnwI1+zKTHUEDoGuiq69olDMV3XND0zpPHHIdLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1V/sqTVnbGnqcD66P/Oaf0IzTL7VEtiT9V2zsv3HauzBlOQE2NyUIm08SmQ1PcKy
         +MW27xPUtu6q2I2F6ZPfQdUvxzrudv7pEiyFKNGzBFteTDeUJBRysDm/crrCFwNl8Q
         gYlW3bRUSnubB3KDW6DBf8QhvzCh1K7jUG7jt8/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/306] printk: lock/unlock console only for new logbuf entries
Date:   Wed, 27 Nov 2019 21:27:54 +0100
Message-Id: <20191127203116.455029038@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

[ Upstream commit 3ac37a93fa9217e576bebfd4ba3e80edaaeb2289 ]

Prior to commit 5c2992ee7fd8a29 ("printk: remove console flushing special
cases for partial buffered lines") we would do console_cont_flush()
for each pr_cont() to print cont fragments, so console_unlock() would
actually print data:

	pr_cont();
	 console_lock();
	 console_unlock()
	  console_cont_flush(); // print cont fragment
	...
	pr_cont();
	 console_lock();
	 console_unlock()
	  console_cont_flush(); // print cont fragment

We don't do console_cont_flush() anymore, so when we do pr_cont()
console_unlock() does nothing (unless we flushed the cont buffer):

	pr_cont();
	 console_lock();
	 console_unlock();      // noop
	...
	pr_cont();
	 console_lock();
	 console_unlock();      // noop
	...
	pr_cont();
	  cont_flush();
	    console_lock();
	    console_unlock();   // print data

We also wakeup klogd purposelessly for pr_cont() output - un-flushed
cont buffer is not stored in log_buf; there is nothing to pull.

Thus we can console_lock()/console_unlock()/wake_up_klogd() only when
we know that we log_store()-ed a message and there is something to
print to the consoles/syslog.

Link: http://lkml.kernel.org/r/20181002023836.4487-3-sergey.senozhatsky@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c7b3d5489937d..59ceaed1aeed7 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1901,8 +1901,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    const char *fmt, va_list args)
 {
 	int printed_len;
-	bool in_sched = false;
+	bool in_sched = false, pending_output;
 	unsigned long flags;
+	u64 curr_log_seq;
 
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
@@ -1914,11 +1915,13 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	/* This stops the holder of console_sem just where we want him */
 	logbuf_lock_irqsave(flags);
+	curr_log_seq = log_next_seq;
 	printed_len = vprintk_store(facility, level, dict, dictlen, fmt, args);
+	pending_output = (curr_log_seq != log_next_seq);
 	logbuf_unlock_irqrestore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
-	if (!in_sched) {
+	if (!in_sched && pending_output) {
 		/*
 		 * Disable preemption to avoid being preempted while holding
 		 * console_sem which would prevent anyone from printing to
@@ -1935,7 +1938,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		preempt_enable();
 	}
 
-	wake_up_klogd();
+	if (pending_output)
+		wake_up_klogd();
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
-- 
2.20.1



