Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF32B610E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgKQNPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730175AbgKQNPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:15:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2504241A5;
        Tue, 17 Nov 2020 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618922;
        bh=7ZgGRFTBb4esTxHrldhRpAIbdUE7d/bxJmUOO41GJyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XW7RhhcHanUR8bDNCoUT+oNumnAZ4iP0Ojy16cnSwL7Xkb537j/D7DDTSbmvpZWCR
         6WlqvW+WCeTP5dT7exQ4PurAjkPKRg0fkFNhWtsy3iDop1r3UsyGYHxPAmKexi2Zws
         E8LxCvXhvSQv0YLrHSm18B4k3T2gYV7JYlQ8ZcEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.14 53/85] dont dump the threads that had been already exiting when zapped.
Date:   Tue, 17 Nov 2020 14:05:22 +0100
Message-Id: <20201117122113.631066714@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 77f6ab8b7768cf5e6bdd0e72499270a0671506ee upstream.

Coredump logics needs to report not only the registers of the dumping
thread, but (since 2.5.43) those of other threads getting killed.

Doing that might require extra state saved on the stack in asm glue at
kernel entry; signal delivery logics does that (we need to be able to
save sigcontext there, at the very least) and so does seccomp.

That covers all callers of do_coredump().  Secondary threads get hit with
SIGKILL and caught as soon as they reach exit_mm(), which normally happens
in signal delivery, so those are also fine most of the time.  Unfortunately,
it is possible to end up with secondary zapped when it has already entered
exit(2) (or, worse yet, is oopsing).  In those cases we reach exit_mm()
when mm->core_state is already set, but the stack contents is not what
we would have in signal delivery.

At least on two architectures (alpha and m68k) it leads to infoleaks - we
end up with a chunk of kernel stack written into coredump, with the contents
consisting of normal C stack frames of the call chain leading to exit_mm()
instead of the expected copy of userland registers.  In case of alpha we
leak 312 bytes of stack.  Other architectures (including the regset-using
ones) might have similar problems - the normal user of regsets is ptrace
and the state of tracee at the time of such calls is special in the same
way signal delivery is.

Note that had the zapper gotten to the exiting thread slightly later,
it wouldn't have been included into coredump anyway - we skip the threads
that have already cleared their ->mm.  So let's pretend that zapper always
loses the race.  IOW, have exit_mm() only insert into the dumper list if
we'd gotten there from handling a fatal signal[*]

As the result, the callers of do_exit() that have *not* gone through get_signal()
are not seen by coredump logics as secondary threads.  Which excludes voluntary
exit()/oopsen/traps/etc.  The dumper thread itself is unaffected by that,
so seccomp is fine.

[*] originally I intended to add a new flag in tsk->flags, but ebiederman pointed
out that PF_SIGNALED is already doing just what we need.

Cc: stable@vger.kernel.org
Fixes: d89f3847def4 ("[PATCH] thread-aware coredumps, 2.5.43-C3")
History-tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -516,7 +516,10 @@ static void exit_mm(void)
 		up_read(&mm->mmap_sem);
 
 		self.task = current;
-		self.next = xchg(&core_state->dumper.next, &self);
+		if (self.task->flags & PF_SIGNALED)
+			self.next = xchg(&core_state->dumper.next, &self);
+		else
+			self.task = NULL;
 		/*
 		 * Implies mb(), the result of xchg() must be visible
 		 * to core_state->dumper.


