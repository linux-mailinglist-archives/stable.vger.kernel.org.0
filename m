Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BF3FF3D7
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfKPPlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbfKPPlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:16 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 493F220733;
        Sat, 16 Nov 2019 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918875;
        bh=a3atx0pDJ6BtMgQLn3IDaJgOpT1UTvSQakhdCHeRKyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNqG2zevJiQaJAVKOa2Ta9dY9h6Pu04D8qyjXO6i/TW/xT/JF5KTFM0IkGPzDC3cQ
         UNKlUXFM9LVtTEeYJtBGZ6JbiiorwMu3v1/UKP19p5SnuqjSUo0UuDSAsQyN4PMbyq
         j704dUngPPQVf+mC8l42kU58ILxJkUilN4TWBZRw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 003/237] printk: lock/unlock console only for new logbuf entries
Date:   Sat, 16 Nov 2019 10:37:18 -0500
Message-Id: <20191116154113.7417-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d0d03223b45b1..9ee6016a19fc8 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1894,8 +1894,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    const char *fmt, va_list args)
 {
 	int printed_len;
-	bool in_sched = false;
+	bool in_sched = false, pending_output;
 	unsigned long flags;
+	u64 curr_log_seq;
 
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
@@ -1907,11 +1908,13 @@ asmlinkage int vprintk_emit(int facility, int level,
 
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
@@ -1928,7 +1931,8 @@ asmlinkage int vprintk_emit(int facility, int level,
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

