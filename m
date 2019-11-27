Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64AF10BBE1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732797AbfK0VQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732784AbfK0VNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A67321741;
        Wed, 27 Nov 2019 21:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889233;
        bh=YLyGdyG2GbF2+WCjoHDmiZSalR1OSon7kNEebSIaPzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmhuvF6XYW46HzCTHKf76Sj+6RSY6ETZWYgLCmZs/DSb9MfjrECgqyL6WuzLqaTym
         Y1hrUOzuRTjFtCeBNLBKONiD5BMkbg7BboWXIgqx1AqgnyH7+K2Nly67io7ISXlHCT
         n6S8jXj0sVc29goYNiSH5cSt2OImsOPSeNvtdYr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 38/66] exit/exec: Seperate mm_release()
Date:   Wed, 27 Nov 2019 21:32:33 +0100
Message-Id: <20191127202718.958636413@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

---
 fs/exec.c                |    2 +-
 include/linux/sched/mm.h |    6 ++++--
 kernel/exit.c            |    2 +-
 kernel/fork.c            |   12 +++++++++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1015,7 +1015,7 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	mm_release(tsk, old_mm);
+	exec_mm_release(tsk, old_mm);
 
 	if (old_mm) {
 		sync_mm_rss(old_mm);
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -117,8 +117,10 @@ extern struct mm_struct *get_task_mm(str
  * succeeds.
  */
 extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
-/* Remove the current tasks stale references to the old mm_struct */
-extern void mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exit() */
+extern void exit_mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exec() */
+extern void exec_mm_release(struct task_struct *, struct mm_struct *);
 
 #ifdef CONFIG_MEMCG
 extern void mm_update_next_owner(struct mm_struct *mm);
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -437,7 +437,7 @@ static void exit_mm(void)
 	struct mm_struct *mm = current->mm;
 	struct core_state *core_state;
 
-	mm_release(current, mm);
+	exit_mm_release(current, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1283,7 +1283,7 @@ static int wait_for_vfork_done(struct ta
  * restoring the old one. . .
  * Eric Biederman 10 January 1998
  */
-void mm_release(struct task_struct *tsk, struct mm_struct *mm)
+static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
 	/* Get rid of any futexes when releasing the mm */
 	futex_mm_release(tsk);
@@ -1320,6 +1320,16 @@ void mm_release(struct task_struct *tsk,
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
 /**
  * dup_mm() - duplicates an existing mm structure
  * @tsk: the task_struct with which the new mm will be associated.


