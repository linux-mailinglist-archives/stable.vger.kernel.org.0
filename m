Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8F5450F80
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbhKOScD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240824AbhKOS3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:29:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13276344B;
        Mon, 15 Nov 2021 17:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999101;
        bh=pHEm7tUF1dkso5ru07rRpKujM9nnoDPt0XNDZFwsXxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFAF35BRxVn1D0tQP7DClKzjOFyGLy17RhRWHHsDwp8bFkLvuvW3544kAod9pIOG6
         4nS+ueG6jubDLZdCOn+jzOC/9GuHmnUaXKo5BiTYpYKOrAhCM0uXnITTlg/EtcfpOO
         k4lNl8cLawEKwQ74VBjzsPg4BS4oTK5CNUAmev0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.14 143/849] signal: Remove the bogus sigkill_pending in ptrace_stop
Date:   Mon, 15 Nov 2021 17:53:46 +0100
Message-Id: <20211115165424.977156932@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 7d613f9f72ec8f90ddefcae038fdae5adb8404b3 upstream.

The existence of sigkill_pending is a little silly as it is
functionally a duplicate of fatal_signal_pending that is used in
exactly one place.

Checking for pending fatal signals and returning early in ptrace_stop
is actively harmful.  It casues the ptrace_stop called by
ptrace_signal to return early before setting current->exit_code.
Later when ptrace_signal reads the signal number from
current->exit_code is undefined, making it unpredictable what will
happen.

Instead rely on the fact that schedule will not sleep if there is a
pending signal that can awaken a task.

Removing the explict sigkill_pending test fixes fixes ptrace_signal
when ptrace_stop does not stop because current->exit_code is always
set to to signr.

Cc: stable@vger.kernel.org
Fixes: 3d749b9e676b ("ptrace: simplify ptrace_stop()->sigkill_pending() path")
Fixes: 1a669c2f16d4 ("Add arch_ptrace_stop")
Link: https://lkml.kernel.org/r/87pmsyx29t.fsf@disp2133
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2109,15 +2109,6 @@ static inline bool may_ptrace_stop(void)
 	return true;
 }
 
-/*
- * Return non-zero if there is a SIGKILL that should be waking us up.
- * Called with the siglock held.
- */
-static bool sigkill_pending(struct task_struct *tsk)
-{
-	return sigismember(&tsk->pending.signal, SIGKILL) ||
-	       sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
-}
 
 /*
  * This must be called with current->sighand->siglock held.
@@ -2144,17 +2135,16 @@ static void ptrace_stop(int exit_code, i
 		 * calling arch_ptrace_stop, so we must release it now.
 		 * To preserve proper semantics, we must do this before
 		 * any signal bookkeeping like checking group_stop_count.
-		 * Meanwhile, a SIGKILL could come in before we retake the
-		 * siglock.  That must prevent us from sleeping in TASK_TRACED.
-		 * So after regaining the lock, we must check for SIGKILL.
 		 */
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
-		if (sigkill_pending(current))
-			return;
 	}
 
+	/*
+	 * schedule() will not sleep if there is a pending signal that
+	 * can awaken the task.
+	 */
 	set_special_state(TASK_TRACED);
 
 	/*


