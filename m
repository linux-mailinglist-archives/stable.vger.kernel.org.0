Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE310BB94
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfK0VN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbfK0VN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A70D21556;
        Wed, 27 Nov 2019 21:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889236;
        bh=edJx2cAHfixmC0zyvlsHBTeDbnwMU/Lbodnd4g+u4rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ys9c11P82Z8aJ5JkZF6AK93QSoUgzAJydb+aOSPjWz0GaNv38x2j8sQ0EWwPQW0Jk
         oaAQwcxvDheOyVk8tJgpX6KTkLf9z/tX3ShmZifhl8guwuyAU4+RQ2RZcT8zXZ05Nx
         45HIOtiRy6Rxu2wXsbYlgQpqXoHG1T9FoTqhX/kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 39/66] futex: Split futex_mm_release() for exit/exec
Date:   Wed, 27 Nov 2019 21:32:34 +0100
Message-Id: <20191127202720.161543786@linuxfoundation.org>
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

commit 150d71584b12809144b8145b817e83b81158ae5f upstream.

To allow separate handling of the futex exit state in the futex exit code
for exit and exec, split futex_mm_release() into two functions and invoke
them from the corresponding exit/exec_mm_release() callsites.

Preparatory only, no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.332094221@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/futex.h |    6 ++++--
 kernel/fork.c         |    5 ++---
 kernel/futex.c        |    7 ++++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -93,14 +93,16 @@ static inline void futex_exit_done(struc
 	tsk->futex_state = FUTEX_STATE_DEAD;
 }
 
-void futex_mm_release(struct task_struct *tsk);
+void futex_exit_release(struct task_struct *tsk);
+void futex_exec_release(struct task_struct *tsk);
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
-static inline void futex_mm_release(struct task_struct *tsk) { }
 static inline void futex_exit_done(struct task_struct *tsk) { }
+static inline void futex_exit_release(struct task_struct *tsk) { }
+static inline void futex_exec_release(struct task_struct *tsk) { }
 static inline long do_futex(u32 __user *uaddr, int op, u32 val,
 			    ktime_t *timeout, u32 __user *uaddr2,
 			    u32 val2, u32 val3)
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1285,9 +1285,6 @@ static int wait_for_vfork_done(struct ta
  */
 static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	/* Get rid of any futexes when releasing the mm */
-	futex_mm_release(tsk);
-
 	uprobe_free_utask(tsk);
 
 	/* Get rid of any cached register state */
@@ -1322,11 +1319,13 @@ static void mm_release(struct task_struc
 
 void exit_mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
+	futex_exit_release(tsk);
 	mm_release(tsk, mm);
 }
 
 void exec_mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
+	futex_exec_release(tsk);
 	mm_release(tsk, mm);
 }
 
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3661,7 +3661,7 @@ static void exit_robust_list(struct task
 	}
 }
 
-void futex_mm_release(struct task_struct *tsk)
+void futex_exec_release(struct task_struct *tsk)
 {
 	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
@@ -3679,6 +3679,11 @@ void futex_mm_release(struct task_struct
 		exit_pi_state_list(tsk);
 }
 
+void futex_exit_release(struct task_struct *tsk)
+{
+	futex_exec_release(tsk);
+}
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {


