Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38FB20E64C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390027AbgF2VqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFB02476B;
        Mon, 29 Jun 2020 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444085;
        bh=h4/VQuK+NEk8IFZm8ehPUDjin5k8yswJvnKZPww2js0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKvq5L/782ij95RqgY/Eb/z4sPGL/Fo6nBTHlT9nqNXcNrMDXMdc6O+DpmYMBagRG
         hq6OHb+MQmEFwvdxazGDMX9TMvhRo/sTAX2Ar3Fohdf9Fmssgc1osWEWAqYPHHiYA7
         GXtxjgUSL3MpfyPjfNFxlfgAGb23VnnKVni0kCTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 195/265] s390/ptrace: return -ENOSYS when invalid syscall is supplied
Date:   Mon, 29 Jun 2020 11:17:08 -0400
Message-Id: <20200629151818.2493727-196-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit cd29fa798001075a554b978df3a64e6656c25794 ]

The current code returns the syscall number which an invalid
syscall number is supplied and tracing is enabled. This makes
the strace testsuite fail.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 9eee345568890..3f29646313e82 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -838,6 +838,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long mask = -1UL;
+	long ret = -1;
 
 	if (is_compat_task())
 		mask = 0xffffffff;
@@ -854,8 +855,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 * debugger stored an invalid system call number. Skip
 		 * the system call and the system call restart handling.
 		 */
-		clear_pt_regs_flag(regs, PIF_SYSCALL);
-		return -1;
+		goto skip;
 	}
 
 #ifdef CONFIG_SECCOMP
@@ -871,7 +871,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 			sd.arch = AUDIT_ARCH_S390X;
 		}
 
-		sd.nr = regs->gprs[2] & 0xffff;
+		sd.nr = regs->int_code & 0xffff;
 		sd.args[0] = regs->orig_gpr2 & mask;
 		sd.args[1] = regs->gprs[3] & mask;
 		sd.args[2] = regs->gprs[4] & mask;
@@ -880,19 +880,26 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		sd.args[5] = regs->gprs[7] & mask;
 
 		if (__secure_computing(&sd) == -1)
-			return -1;
+			goto skip;
 	}
 #endif /* CONFIG_SECCOMP */
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->gprs[2]);
+		trace_sys_enter(regs, regs->int_code & 0xffff);
 
 
-	audit_syscall_entry(regs->gprs[2], regs->orig_gpr2 & mask,
+	audit_syscall_entry(regs->int_code & 0xffff, regs->orig_gpr2 & mask,
 			    regs->gprs[3] &mask, regs->gprs[4] &mask,
 			    regs->gprs[5] &mask);
 
+	if ((signed long)regs->gprs[2] >= NR_syscalls) {
+		regs->gprs[2] = -ENOSYS;
+		ret = -ENOSYS;
+	}
 	return regs->gprs[2];
+skip:
+	clear_pt_regs_flag(regs, PIF_SYSCALL);
+	return ret;
 }
 
 asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
-- 
2.25.1

