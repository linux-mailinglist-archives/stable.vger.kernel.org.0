Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4303B1EAC5F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgFASTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbgFASR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71D882065C;
        Mon,  1 Jun 2020 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035448;
        bh=BAip3cu+vBm8jN5Fq21e/g/Ky+tOWukszXJJNnq+UQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4CdAcI4aEz+bthHlokDW91rOkg/k3DlhrBJhZjJF9GavOBEnCWm9infyTreU87sl
         o8ZJ8tzbBGynD+JBg2hX1kJagyfRMGIH/JcTQn08B3CZNFM7f79yWMGySzuiWVq7C1
         SJXXUmHo2Xsp+zOT7YgooRi1p5hEJn7eproZmew0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Lang <jaytlang@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>, stable#@vger.kernel.org
Subject: [PATCH 5.6 163/177] x86/ioperm: Prevent a memory leak when fork fails
Date:   Mon,  1 Jun 2020 19:55:01 +0200
Message-Id: <20200601174101.811808609@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Lang <jaytlang@mit.edu>

commit 4bfe6cce133cad82cea04490c308795275857782 upstream.

In the copy_process() routine called by _do_fork(), failure to allocate
a PID (or further along in the function) will trigger an invocation to
exit_thread(). This is done to clean up from an earlier call to
copy_thread_tls(). Naturally, the child task is passed into exit_thread(),
however during the process, io_bitmap_exit() nullifies the parent's
io_bitmap rather than the child's.

As copy_thread_tls() has been called ahead of the failure, the reference
count on the calling thread's io_bitmap is incremented as we would expect.
However, io_bitmap_exit() doesn't accept any arguments, and thus assumes
it should trash the current thread's io_bitmap reference rather than the
child's. This is pretty sneaky in practice, because in all instances but
this one, exit_thread() is called with respect to the current task and
everything works out.

A determined attacker can issue an appropriate ioctl (i.e. KDENABIO) to
get a bitmap allocated, and force a clone3() syscall to fail by passing
in a zeroed clone_args structure. The kernel handles the erroneous struct
and the buggy code path is followed, and even though the parent's reference
to the io_bitmap is trashed, the child still holds a reference and thus
the structure will never be freed.

Fix this by tweaking io_bitmap_exit() and its subroutines to accept a
task_struct argument which to operate on.

Fixes: ea5f1cd7ab49 ("x86/ioperm: Remove bitmap if all permissions dropped")
Signed-off-by: Jay Lang <jaytlang@mit.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable#@vger.kernel.org
Link: https://lkml.kernel.org/r/20200524162742.253727-1-jaytlang@mit.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/io_bitmap.h |    4 ++--
 arch/x86/kernel/ioport.c         |   22 +++++++++++-----------
 arch/x86/kernel/process.c        |    4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/io_bitmap.h
+++ b/arch/x86/include/asm/io_bitmap.h
@@ -17,7 +17,7 @@ struct task_struct;
 
 #ifdef CONFIG_X86_IOPL_IOPERM
 void io_bitmap_share(struct task_struct *tsk);
-void io_bitmap_exit(void);
+void io_bitmap_exit(struct task_struct *tsk);
 
 void native_tss_update_io_bitmap(void);
 
@@ -29,7 +29,7 @@ void native_tss_update_io_bitmap(void);
 
 #else
 static inline void io_bitmap_share(struct task_struct *tsk) { }
-static inline void io_bitmap_exit(void) { }
+static inline void io_bitmap_exit(struct task_struct *tsk) { }
 static inline void tss_update_io_bitmap(void) { }
 #endif
 
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -32,15 +32,15 @@ void io_bitmap_share(struct task_struct
 	set_tsk_thread_flag(tsk, TIF_IO_BITMAP);
 }
 
-static void task_update_io_bitmap(void)
+static void task_update_io_bitmap(struct task_struct *tsk)
 {
-	struct thread_struct *t = &current->thread;
+	struct thread_struct *t = &tsk->thread;
 
 	if (t->iopl_emul == 3 || t->io_bitmap) {
 		/* TSS update is handled on exit to user space */
-		set_thread_flag(TIF_IO_BITMAP);
+		set_tsk_thread_flag(tsk, TIF_IO_BITMAP);
 	} else {
-		clear_thread_flag(TIF_IO_BITMAP);
+		clear_tsk_thread_flag(tsk, TIF_IO_BITMAP);
 		/* Invalidate TSS */
 		preempt_disable();
 		tss_update_io_bitmap();
@@ -48,12 +48,12 @@ static void task_update_io_bitmap(void)
 	}
 }
 
-void io_bitmap_exit(void)
+void io_bitmap_exit(struct task_struct *tsk)
 {
-	struct io_bitmap *iobm = current->thread.io_bitmap;
+	struct io_bitmap *iobm = tsk->thread.io_bitmap;
 
-	current->thread.io_bitmap = NULL;
-	task_update_io_bitmap();
+	tsk->thread.io_bitmap = NULL;
+	task_update_io_bitmap(tsk);
 	if (iobm && refcount_dec_and_test(&iobm->refcnt))
 		kfree(iobm);
 }
@@ -101,7 +101,7 @@ long ksys_ioperm(unsigned long from, uns
 		if (!iobm)
 			return -ENOMEM;
 		refcount_set(&iobm->refcnt, 1);
-		io_bitmap_exit();
+		io_bitmap_exit(current);
 	}
 
 	/*
@@ -133,7 +133,7 @@ long ksys_ioperm(unsigned long from, uns
 	}
 	/* All permissions dropped? */
 	if (max_long == UINT_MAX) {
-		io_bitmap_exit();
+		io_bitmap_exit(current);
 		return 0;
 	}
 
@@ -191,7 +191,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, leve
 	}
 
 	t->iopl_emul = level;
-	task_update_io_bitmap();
+	task_update_io_bitmap(current);
 
 	return 0;
 }
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -97,7 +97,7 @@ int arch_dup_task_struct(struct task_str
 }
 
 /*
- * Free current thread data structures etc..
+ * Free thread data structures etc..
  */
 void exit_thread(struct task_struct *tsk)
 {
@@ -105,7 +105,7 @@ void exit_thread(struct task_struct *tsk
 	struct fpu *fpu = &t->fpu;
 
 	if (test_thread_flag(TIF_IO_BITMAP))
-		io_bitmap_exit();
+		io_bitmap_exit(tsk);
 
 	free_vm86(t);
 


