Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73B820E837
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391738AbgF2WEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgF2SfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 193132476C;
        Mon, 29 Jun 2020 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444084;
        bh=bu0XAxa18yWCEfHS6NqT/vNP6+rA4huyowrE0NGD83o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSQKiSme39MyhkQXFhOgqWlROnW8FvmfB13joouCHeLzkXwJGk2VwFyAeQlpR0h7U
         zSf0Xy/tSfRt8OquH1wjvywuGlawK8pItkurqbFrHDSEucWa/oZhuN4EPlIPf9MPWj
         u/AvqGF9B4PBWprJtfR3Uu4aACp2WnZdlKH2sHiM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 194/265] s390/seccomp: pass syscall arguments via seccomp_data
Date:   Mon, 29 Jun 2020 11:17:07 -0400
Message-Id: <20200629151818.2493727-195-sashal@kernel.org>
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

[ Upstream commit 664f5f8de825648d1d31f6f5652e3cd117c77b50 ]

Use __secure_computing() and pass the register data via
seccomp_data so secure computing doesn't have to fetch it
again.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 58faa12542a1b..9eee345568890 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -839,6 +839,9 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long mask = -1UL;
 
+	if (is_compat_task())
+		mask = 0xffffffff;
+
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
 	 * call number to gprs[2].
@@ -855,17 +858,35 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		return -1;
 	}
 
+#ifdef CONFIG_SECCOMP
 	/* Do the secure computing check after ptrace. */
-	if (secure_computing()) {
-		/* seccomp failures shouldn't expose any additional code. */
-		return -1;
+	if (unlikely(test_thread_flag(TIF_SECCOMP))) {
+		struct seccomp_data sd;
+
+		if (is_compat_task()) {
+			sd.instruction_pointer = regs->psw.addr & 0x7fffffff;
+			sd.arch = AUDIT_ARCH_S390;
+		} else {
+			sd.instruction_pointer = regs->psw.addr;
+			sd.arch = AUDIT_ARCH_S390X;
+		}
+
+		sd.nr = regs->gprs[2] & 0xffff;
+		sd.args[0] = regs->orig_gpr2 & mask;
+		sd.args[1] = regs->gprs[3] & mask;
+		sd.args[2] = regs->gprs[4] & mask;
+		sd.args[3] = regs->gprs[5] & mask;
+		sd.args[4] = regs->gprs[6] & mask;
+		sd.args[5] = regs->gprs[7] & mask;
+
+		if (__secure_computing(&sd) == -1)
+			return -1;
 	}
+#endif /* CONFIG_SECCOMP */
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->gprs[2]);
 
-	if (is_compat_task())
-		mask = 0xffffffff;
 
 	audit_syscall_entry(regs->gprs[2], regs->orig_gpr2 & mask,
 			    regs->gprs[3] &mask, regs->gprs[4] &mask,
-- 
2.25.1

