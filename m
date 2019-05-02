Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C6111CD1
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfEBPZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbfEBPZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69BF62085A;
        Thu,  2 May 2019 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810706;
        bh=qeRtJdY2lVqyEgh89+ZBGB9AihGkjC2DK6ctS8XbHtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCco3wpb6q3aTYTnxV68+XrvI03/f6mQpeXRai536fjebrW/mqfCu0dN8ocN0Md3H
         GK9GfcsgTH8vYDTOji4pajLOSmMXwjtdvDEipgASjCdUbOLTNUjfucjUJK7GxcxUyg
         79GefzMlB9RBtERLQcMlugpXC61uSPYxc5Gn4zWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 48/49] ptrace: take into account saved_sigmask in PTRACE{GET,SET}SIGMASK
Date:   Thu,  2 May 2019 17:21:25 +0200
Message-Id: <20190502143329.915572044@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fcfc2aa0185f4a731d05a21e9f359968fdfd02e7 ]

There are a few system calls (pselect, ppoll, etc) which replace a task
sigmask while they are running in a kernel-space

When a task calls one of these syscalls, the kernel saves a current
sigmask in task->saved_sigmask and sets a syscall sigmask.

On syscall-exit-stop, ptrace traps a task before restoring the
saved_sigmask, so PTRACE_GETSIGMASK returns the syscall sigmask and
PTRACE_SETSIGMASK does nothing, because its sigmask is replaced by
saved_sigmask, when the task returns to user-space.

This patch fixes this problem.  PTRACE_GETSIGMASK returns saved_sigmask
if it's set.  PTRACE_SETSIGMASK drops the TIF_RESTORE_SIGMASK flag.

Link: http://lkml.kernel.org/r/20181120060616.6043-1-avagin@gmail.com
Fixes: 29000caecbe8 ("ptrace: add ability to get/set signal-blocked mask")
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 include/linux/sched/signal.h | 18 ++++++++++++++++++
 kernel/ptrace.c              | 15 +++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index fbf86ecd149d..bcaba7e8ca6e 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -377,10 +377,20 @@ static inline void set_restore_sigmask(void)
 	set_thread_flag(TIF_RESTORE_SIGMASK);
 	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
 }
+
+static inline void clear_tsk_restore_sigmask(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_RESTORE_SIGMASK);
+}
+
 static inline void clear_restore_sigmask(void)
 {
 	clear_thread_flag(TIF_RESTORE_SIGMASK);
 }
+static inline bool test_tsk_restore_sigmask(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_RESTORE_SIGMASK);
+}
 static inline bool test_restore_sigmask(void)
 {
 	return test_thread_flag(TIF_RESTORE_SIGMASK);
@@ -398,6 +408,10 @@ static inline void set_restore_sigmask(void)
 	current->restore_sigmask = true;
 	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
 }
+static inline void clear_tsk_restore_sigmask(struct task_struct *tsk)
+{
+	tsk->restore_sigmask = false;
+}
 static inline void clear_restore_sigmask(void)
 {
 	current->restore_sigmask = false;
@@ -406,6 +420,10 @@ static inline bool test_restore_sigmask(void)
 {
 	return current->restore_sigmask;
 }
+static inline bool test_tsk_restore_sigmask(struct task_struct *tsk)
+{
+	return tsk->restore_sigmask;
+}
 static inline bool test_and_clear_restore_sigmask(void)
 {
 	if (!current->restore_sigmask)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 84b1367935e4..f1c85b6c39ae 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -29,6 +29,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
 #include <linux/compat.h>
+#include <linux/sched/signal.h>
 
 /*
  * Access another process' address space via ptrace.
@@ -925,18 +926,26 @@ int ptrace_request(struct task_struct *child, long request,
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
 
-	case PTRACE_GETSIGMASK:
+	case PTRACE_GETSIGMASK: {
+		sigset_t *mask;
+
 		if (addr != sizeof(sigset_t)) {
 			ret = -EINVAL;
 			break;
 		}
 
-		if (copy_to_user(datavp, &child->blocked, sizeof(sigset_t)))
+		if (test_tsk_restore_sigmask(child))
+			mask = &child->saved_sigmask;
+		else
+			mask = &child->blocked;
+
+		if (copy_to_user(datavp, mask, sizeof(sigset_t)))
 			ret = -EFAULT;
 		else
 			ret = 0;
 
 		break;
+	}
 
 	case PTRACE_SETSIGMASK: {
 		sigset_t new_set;
@@ -962,6 +971,8 @@ int ptrace_request(struct task_struct *child, long request,
 		child->blocked = new_set;
 		spin_unlock_irq(&child->sighand->siglock);
 
+		clear_tsk_restore_sigmask(child);
+
 		ret = 0;
 		break;
 	}
-- 
2.19.1



