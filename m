Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFC945C644
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344116AbhKXOGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356555AbhKXOE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB1AC63336;
        Wed, 24 Nov 2021 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759483;
        bh=irvAJEBxtkxgS1Zcw/EQ0fQuIZDjxWq4z5lhFf4NxOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNYmq7ixhiUdyGEH0aPrxJvj1TRucaYvtMfcsbdkGgEs4beF+0Fgf4yuggH7DUNpt
         AZH5rWEprOlr6707/yPFsnc05tJboIHZukACzeO1sQs3B0z94WEpdZxZyB1Xt8cc9Q
         Bq6I7ZtksWD8qNuuznDfWDSKr/GELjitJLe7y1YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 256/279] signal: Implement force_fatal_sig
Date:   Wed, 24 Nov 2021 12:59:03 +0100
Message-Id: <20211124115727.571042343@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 26d5badbccddcc063dc5174a2baffd13a23322aa upstream.

Add a simple helper force_fatal_sig that causes a signal to be
delivered to a process as if the signal handler was set to SIG_DFL.

Reimplement force_sigsegv based upon this new helper.  This fixes
force_sigsegv so that when it forces the default signal handler
to be used the code now forces the signal to be unblocked as well.

Reusing the tested logic in force_sig_info_to_task that was built for
force_sig_seccomp this makes the implementation trivial.

This is interesting both because it makes force_sigsegv simpler and
because there are a couple of buggy places in the kernel that call
do_exit(SIGILL) or do_exit(SIGSYS) because there is no straight
forward way today for those places to simply force the exit of a
process with the chosen signal.  Creating force_fatal_sig allows
those places to be implemented with normal signal exits.

Link: https://lkml.kernel.org/r/20211020174406.17889-13-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/signal.h |    1 +
 kernel/signal.c              |   26 +++++++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -338,6 +338,7 @@ extern int kill_pid(struct pid *pid, int
 extern __must_check bool do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int);
+extern void force_fatal_sig(int);
 extern int send_sig(int, struct task_struct *, int);
 extern int zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1650,6 +1650,19 @@ void force_sig(int sig)
 }
 EXPORT_SYMBOL(force_sig);
 
+void force_fatal_sig(int sig)
+{
+	struct kernel_siginfo info;
+
+	clear_siginfo(&info);
+	info.si_signo = sig;
+	info.si_errno = 0;
+	info.si_code = SI_KERNEL;
+	info.si_pid = 0;
+	info.si_uid = 0;
+	force_sig_info_to_task(&info, current, true);
+}
+
 /*
  * When things go south during signal handling, we
  * will force a SIGSEGV. And if the signal that caused
@@ -1658,15 +1671,10 @@ EXPORT_SYMBOL(force_sig);
  */
 void force_sigsegv(int sig)
 {
-	struct task_struct *p = current;
-
-	if (sig == SIGSEGV) {
-		unsigned long flags;
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		p->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	}
-	force_sig(SIGSEGV);
+	if (sig == SIGSEGV)
+		force_fatal_sig(SIGSEGV);
+	else
+		force_sig(SIGSEGV);
 }
 
 int force_sig_fault_to_task(int sig, int code, void __user *addr


