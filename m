Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0B7491C72
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356118AbiARDPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348243AbiARDJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ECDBB811CE;
        Tue, 18 Jan 2022 03:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E0FC36AE3;
        Tue, 18 Jan 2022 03:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475361;
        bh=ypGe6ZiPObWziSfTo04HOWAK/HNjCmpuxDJ2gVqG6As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or+BHgasDMtTlf2oy1W0RYv+/H1U44mGKLjSptCZu1oQIjE5ElqV0DwEDHI4rnbYX
         NTBF9HXHskiTqwtIwYLok5igE4FZ6yVApascozr7UW2MwS84kEmxMKJTkCqV+z0JJ8
         m+VOu2bWRqyKL+r/9palsU7u2+Kk5O7ypNQhVXb2FjzEq2opsGiYiBtBEoXi5I+7S8
         iRGDxeTfuMhj7Cy/9evkxKtBepKlr2ZsXGxYqLzn0PBV0VqlfrF/wzdICcvAD3HIM7
         i21Nd3gJpA5NwUTIXGjJuP914qx5wPVMuDQihij0QAdgcLZrcHbTk0+3SYdkTXzJ4N
         URizZJ45CVloQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-um@lists.infradead.org, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH AUTOSEL 4.4 19/29] um: registers: Rename function names to avoid conflicts and build problems
Date:   Mon, 17 Jan 2022 22:08:12 -0500
Message-Id: <20220118030822.1955469-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 077b7320942b64b0da182aefd83c374462a65535 ]

The function names init_registers() and restore_registers() are used
in several net/ethernet/ and gpu/drm/ drivers for other purposes (not
calls to UML functions), so rename them.

This fixes multiple build errors.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: linux-um@lists.infradead.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/shared/registers.h | 4 ++--
 arch/um/os-Linux/registers.c       | 4 ++--
 arch/um/os-Linux/start_up.c        | 2 +-
 arch/x86/um/syscalls_64.c          | 3 ++-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/um/include/shared/registers.h b/arch/um/include/shared/registers.h
index f5b76355ad71a..089f979e112e3 100644
--- a/arch/um/include/shared/registers.h
+++ b/arch/um/include/shared/registers.h
@@ -14,8 +14,8 @@ extern int restore_fp_registers(int pid, unsigned long *fp_regs);
 extern int save_fpx_registers(int pid, unsigned long *fp_regs);
 extern int restore_fpx_registers(int pid, unsigned long *fp_regs);
 extern int save_registers(int pid, struct uml_pt_regs *regs);
-extern int restore_registers(int pid, struct uml_pt_regs *regs);
-extern int init_registers(int pid);
+extern int restore_pid_registers(int pid, struct uml_pt_regs *regs);
+extern int init_pid_registers(int pid);
 extern void get_safe_registers(unsigned long *regs, unsigned long *fp_regs);
 extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
 extern int get_fp_registers(int pid, unsigned long *regs);
diff --git a/arch/um/os-Linux/registers.c b/arch/um/os-Linux/registers.c
index 2ff8d4fe83c4f..34a5963bd7efd 100644
--- a/arch/um/os-Linux/registers.c
+++ b/arch/um/os-Linux/registers.c
@@ -21,7 +21,7 @@ int save_registers(int pid, struct uml_pt_regs *regs)
 	return 0;
 }
 
-int restore_registers(int pid, struct uml_pt_regs *regs)
+int restore_pid_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
@@ -36,7 +36,7 @@ int restore_registers(int pid, struct uml_pt_regs *regs)
 static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[FP_SIZE];
 
-int init_registers(int pid)
+int init_pid_registers(int pid)
 {
 	int err;
 
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 22a358ef1b0cd..dc06933ba63d9 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -334,7 +334,7 @@ void __init os_early_checks(void)
 	check_tmpexec();
 
 	pid = start_ptraced_child();
-	if (init_registers(pid))
+	if (init_pid_registers(pid))
 		fatal("Failed to initialize default registers");
 	stop_ptraced_child(pid, 1, 1);
 }
diff --git a/arch/x86/um/syscalls_64.c b/arch/x86/um/syscalls_64.c
index e6552275320bc..40ecacb2c54b3 100644
--- a/arch/x86/um/syscalls_64.c
+++ b/arch/x86/um/syscalls_64.c
@@ -9,6 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/prctl.h> /* XXX This should get the constants from libc */
 #include <os.h>
+#include <registers.h>
 
 long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 {
@@ -32,7 +33,7 @@ long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 	switch (code) {
 	case ARCH_SET_FS:
 	case ARCH_SET_GS:
-		ret = restore_registers(pid, &current->thread.regs.regs);
+		ret = restore_pid_registers(pid, &current->thread.regs.regs);
 		if (ret)
 			return ret;
 		break;
-- 
2.34.1

