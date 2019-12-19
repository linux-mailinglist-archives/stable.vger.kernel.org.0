Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6236126D4F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfLSSjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:39:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbfLSSjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:39:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1A220716;
        Thu, 19 Dec 2019 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780780;
        bh=50IYEcPXOfhe0jbnqeO8tgjp+YuTPtOxuPQAqlXtAkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJPmUYfojyK1pGgBeyKtojROp33fusteCNmTiLRUHUjfL4aqc39kPqoY6ebV4H69e
         zwIHNIhlVdxOB+H5dlwmPINc8yKdzfqdu6bc6VTmzsTOcQIqgcM+4S8olGF0ZeMpyu
         j5ui7hQOBZ94T08kDpIbCW7bgYPDWiC6sUYAb4xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jann Horn <jann@thejh.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH 4.4 076/162] sched/core: Add try_get_task_stack() and put_task_stack()
Date:   Thu, 19 Dec 2019 19:33:04 +0100
Message-Id: <20191219183212.424053540@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit c6c314a613cd7d03fb97713e0d642b493de42e69 upstream.

There are a few places in the kernel that access stack memory
belonging to a different task.  Before we can start freeing task
stacks before the task_struct is freed, we need a way for those code
paths to pin the stack.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jann Horn <jann@thejh.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/17a434f50ad3d77000104f21666575e10a9c1fbd.1474003868.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sched.h |   16 ++++++++++++++++
 init/Kconfig          |    3 +++
 2 files changed, 19 insertions(+)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2858,11 +2858,19 @@ static inline struct thread_info *task_t
 {
 	return &task->thread_info;
 }
+
+/*
+ * When accessing the stack of a non-current task that might exit, use
+ * try_get_task_stack() instead.  task_stack_page will return a pointer
+ * that could get freed out from under you.
+ */
 static inline void *task_stack_page(const struct task_struct *task)
 {
 	return task->stack;
 }
+
 #define setup_thread_stack(new,old)	do { } while(0)
+
 static inline unsigned long *end_of_stack(const struct task_struct *task)
 {
 	return task->stack;
@@ -2898,6 +2906,14 @@ static inline unsigned long *end_of_stac
 }
 
 #endif
+
+static inline void *try_get_task_stack(struct task_struct *tsk)
+{
+	return task_stack_page(tsk);
+}
+
+static inline void put_task_stack(struct task_struct *tsk) {}
+
 #define task_stack_end_corrupted(task) \
 		(*(end_of_stack(task)) != STACK_END_MAGIC)
 
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -33,6 +33,9 @@ config THREAD_INFO_IN_TASK
 	  make this work, an arch will need to remove all thread_info fields
 	  except flags and fix any runtime bugs.
 
+	  One subtle change that will be needed is to use try_get_task_stack()
+	  and put_task_stack() in save_thread_stack_tsk() and get_wchan().
+
 menu "General setup"
 
 config BROKEN


