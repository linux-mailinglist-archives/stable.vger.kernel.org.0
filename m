Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F2945BF5C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbhKXM5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345226AbhKXMzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:55:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1356F6136A;
        Wed, 24 Nov 2021 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757111;
        bh=vmhunX6zkGMQ1pBFWB4S+ZXnSY4Sw4TotJ6WSiidUzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSsc2988n6iwAIZaDDzV51jp51IQFiE8Z6VPJ82MDDv/HVhEARUnp9Arw+BO76ZK8
         ZiQPhnVsPvIi+XZ/TNZ84ukmuZe0V5Y2+voe91/GX7y7tqGuvvhxj3qAb7cqlGBPZU
         ZICFPyy7AHat9WBqG14IPCy2Tsu3bE+dTIXFhkrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.19 063/323] signal: Remove the bogus sigkill_pending in ptrace_stop
Date:   Wed, 24 Nov 2021 12:54:13 +0100
Message-Id: <20211124115720.990379972@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -2003,15 +2003,6 @@ static inline bool may_ptrace_stop(void)
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
@@ -2038,17 +2029,16 @@ static void ptrace_stop(int exit_code, i
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


