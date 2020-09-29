Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D818527C5D9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgI2Ljf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbgI2Lje (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB5521924;
        Tue, 29 Sep 2020 11:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379570;
        bh=gJD//Oy/ibZwweliO6ECZfgOHChNYbZiHj/rS3DkxL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3mj+ctxec3jwCU1BZMfyb4aeiqPUhDYpi7LmJMNpWHN+0kiZI7co5fNxKEbsrKCZ
         jp4t2yIABduGatfsIQaBShUBdeSZjb5BHJNr20n41PwORgtPAXZWcrPx5JKUHLYrsO
         bvxhxNWtlgsNlvsnGKqky0RHeTNEpsNoPxPyVtqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/388] exec: Fix a deadlock in strace
Date:   Tue, 29 Sep 2020 12:58:44 +0200
Message-Id: <20200929110019.819469535@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit 3e74fabd39710ee29fa25618d2c2b40cfa7d76c7 ]

This fixes a deadlock in the tracer when tracing a multi-threaded
application that calls execve while more than one thread are running.

I observed that when running strace on the gcc test suite, it always
blocks after a while, when expect calls execve, because other threads
have to be terminated.  They send ptrace events, but the strace is no
longer able to respond, since it is blocked in vm_access.

The deadlock is always happening when strace needs to access the
tracees process mmap, while another thread in the tracee starts to
execve a child process, but that cannot continue until the
PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:

strace          D    0 30614  30584 0x00000000
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
schedule_preempt_disabled+0x15/0x20
__mutex_lock.isra.13+0x1ec/0x520
__mutex_lock_killable_slowpath+0x13/0x20
mutex_lock_killable+0x28/0x30
mm_access+0x27/0xa0
process_vm_rw_core.isra.3+0xff/0x550
process_vm_rw+0xdd/0xf0
__x64_sys_process_vm_readv+0x31/0x40
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

expect          D    0 31933  30876 0x80004003
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
flush_old_exec+0xc4/0x770
load_elf_binary+0x35a/0x16c0
search_binary_handler+0x97/0x1d0
__do_execve_file.isra.40+0x5d4/0x8a0
__x64_sys_execve+0x49/0x60
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

This changes mm_access to use the new exec_update_mutex
instead of cred_guard_mutex.

This patch is based on the following patch by Eric W. Biederman:
"[PATCH 0/5] Infrastructure to allow fixing exec deadlocks"
Link: https://lore.kernel.org/lkml/87v9ne5y4y.fsf_-_@x220.int.ebiederm.org/

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index cfdc57658ad88..594272569a80f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1221,7 +1221,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	struct mm_struct *mm;
 	int err;
 
-	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
+	err =  mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1231,7 +1231,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 		mmput(mm);
 		mm = ERR_PTR(-EACCES);
 	}
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 
 	return mm;
 }
-- 
2.25.1



