Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB236AE27
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhDZHlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233613AbhDZHjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87328611C1;
        Mon, 26 Apr 2021 07:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422689;
        bh=lvDTFbO2kjOhNiaJHK/06WRErW0tZZG9MqNptvbm+NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YG5oLzWw29RwEymG7EQKexDj+I1eC64h91H/7RdTUKYxh6thY7rUqasogbCTcSRKw
         T4FQ8jpF3LihbLeIfRK/W1xkm0xGsFO8yL7kvLzgFIHSJrdQJOO7Ouxf7s9VBCo2cp
         g73Uw5x4SR5HlVpXIA9T8S2dPxOxDmkCfiH12pq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.4 01/20] s390/ptrace: return -ENOSYS when invalid syscall is supplied
Date:   Mon, 26 Apr 2021 09:29:52 +0200
Message-Id: <20210426072816.735738001@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit cd29fa798001075a554b978df3a64e6656c25794 upstream.

The current code returns the syscall number which an invalid
syscall number is supplied and tracing is enabled. This makes
the strace testsuite fail.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1895132
[krzysztof: adjusted the backport around missing ifdef CONFIG_SECCOMP,
 add Link and Fixes; apparently this should go with the referenced commit]
Fixes: 00332c16b160 ("s390/ptrace: pass invalid syscall numbers to tracing")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ptrace.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -867,6 +867,7 @@ long compat_arch_ptrace(struct task_stru
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long mask = -1UL;
+	long ret = -1;
 
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
@@ -878,27 +879,33 @@ asmlinkage long do_syscall_trace_enter(s
 		 * Tracing decided this syscall should not happen. Skip
 		 * the system call and the system call restart handling.
 		 */
-		clear_pt_regs_flag(regs, PIF_SYSCALL);
-		return -1;
+		goto skip;
 	}
 
 	/* Do the secure computing check after ptrace. */
 	if (secure_computing(NULL)) {
 		/* seccomp failures shouldn't expose any additional code. */
-		return -1;
+		goto skip;
 	}
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->gprs[2]);
+		trace_sys_enter(regs, regs->int_code & 0xffff);
 
 	if (is_compat_task())
 		mask = 0xffffffff;
 
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


