Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197E130CA13
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbhBBSiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233814AbhBBOFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:05:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA9765013;
        Tue,  2 Feb 2021 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273733;
        bh=5OdF8KNEhaHlwckNROCRwzAMDqlWwPiibC8M5kSr5hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UegtS+XSXTu9oBg4NXCKzlKI/9AV8DCfanjGqdwSt+elNDa31c/Gq39/kS2VcMucq
         4MdVF4qYZLyCRdhwTOO029gl+7vFRbAQAmB8JC+zE8CFmCVSV14oFGsPQWYv2/1R5x
         xcIR3zHelmDVzkyPt6rhv3gWjv6TLBhd/kxQ2lgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 10/28] exit/exec: Seperate mm_release()
Date:   Tue,  2 Feb 2021 14:38:30 +0100
Message-Id: <20210202132941.605144316@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4610ba7ad877fafc0a25a30c6c82015304120426 upstream.

mm_release() contains the futex exit handling. mm_release() is called from
do_exit()->exit_mm() and from exec()->exec_mm().

In the exit_mm() case PF_EXITING and the futex state is updated. In the
exec_mm() case these states are not touched.

As the futex exit code needs further protections against exit races, this
needs to be split into two functions.

Preparatory only, no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.240518241@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c             |    2 +-
 include/linux/sched.h |    6 ++++--
 kernel/exit.c         |    2 +-
 kernel/fork.c         |   12 +++++++++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -875,7 +875,7 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	mm_release(tsk, old_mm);
+	exec_mm_release(tsk, old_mm);
 
 	if (old_mm) {
 		sync_mm_rss(old_mm);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2647,8 +2647,10 @@ extern struct mm_struct *get_task_mm(str
  * succeeds.
  */
 extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
-/* Remove the current tasks stale references to the old mm_struct */
-extern void mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exit() */
+extern void exit_mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exec() */
+extern void exec_mm_release(struct task_struct *, struct mm_struct *);
 
 #ifdef CONFIG_HAVE_COPY_THREAD_TLS
 extern int copy_thread_tls(unsigned long, unsigned long, unsigned long,
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -389,7 +389,7 @@ static void exit_mm(struct task_struct *
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
 
-	mm_release(tsk, mm);
+	exit_mm_release(tsk, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -887,7 +887,7 @@ static int wait_for_vfork_done(struct ta
  * restoring the old one. . .
  * Eric Biederman 10 January 1998
  */
-void mm_release(struct task_struct *tsk, struct mm_struct *mm)
+static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
 	/* Get rid of any futexes when releasing the mm */
 	futex_mm_release(tsk);
@@ -924,6 +924,16 @@ void mm_release(struct task_struct *tsk,
 		complete_vfork_done(tsk);
 }
 
+void exit_mm_release(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm_release(tsk, mm);
+}
+
+void exec_mm_release(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm_release(tsk, mm);
+}
+
 /*
  * Allocate a new mm structure and copy contents from the
  * mm structure of the passed in task structure.


