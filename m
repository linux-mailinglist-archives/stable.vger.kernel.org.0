Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C024917F3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344817AbiARCnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56058 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbiARCim (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:38:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A9A611D6;
        Tue, 18 Jan 2022 02:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B0AC36AEB;
        Tue, 18 Jan 2022 02:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473519;
        bh=SwHp8z8g4fBVnumYsGHPVujRk5tCwr58kzWwwIKJFhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6ACzTGagxJmWe/nJv3+V6MNcHLiAHd+81QWNHuAjBJL2xL2tqvgAUeALe18i/erb
         8pB9iB3x+gG7fV4g4xvDWxXGNo1HU7s5lLC3yrAG50v+7IHs82uQV201rurWNn6ZPX
         T+XJhSCy5jAcp2uUCSy4ejil1ee6NbhXjEqxuQEUBF1j49Ij/uv327EV1k+ebiH5j7
         hfIISSm4LiOsc8Emc/k+6hAs297guGZjxzSobNAg4Duj8fIGnSDRt5/+s2JTLKTuuD
         HPgQr5POjLOe4PhkmVhnwsL189BDhh28VlHsIX6VNkPq6YCLxmkWlG+DG3/oDAayPf
         6+6LZI4b/VFsw==
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
Subject: [PATCH AUTOSEL 5.15 145/188] um: registers: Rename function names to avoid conflicts and build problems
Date:   Mon, 17 Jan 2022 21:31:09 -0500
Message-Id: <20220118023152.1948105-145-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 0c50fa6e8a55b..fbb709a222839 100644
--- a/arch/um/include/shared/registers.h
+++ b/arch/um/include/shared/registers.h
@@ -16,8 +16,8 @@ extern int restore_fp_registers(int pid, unsigned long *fp_regs);
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
index 2d9270508e156..b123955be7acc 100644
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
index 8a72c99994eb1..e3ee4db58b40d 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -368,7 +368,7 @@ void __init os_early_checks(void)
 	check_tmpexec();
 
 	pid = start_ptraced_child();
-	if (init_registers(pid))
+	if (init_pid_registers(pid))
 		fatal("Failed to initialize default registers");
 	stop_ptraced_child(pid, 1, 1);
 }
diff --git a/arch/x86/um/syscalls_64.c b/arch/x86/um/syscalls_64.c
index 58f51667e2e4b..8249685b40960 100644
--- a/arch/x86/um/syscalls_64.c
+++ b/arch/x86/um/syscalls_64.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <asm/prctl.h> /* XXX This should get the constants from libc */
 #include <os.h>
+#include <registers.h>
 
 long arch_prctl(struct task_struct *task, int option,
 		unsigned long __user *arg2)
@@ -35,7 +36,7 @@ long arch_prctl(struct task_struct *task, int option,
 	switch (option) {
 	case ARCH_SET_FS:
 	case ARCH_SET_GS:
-		ret = restore_registers(pid, &current->thread.regs.regs);
+		ret = restore_pid_registers(pid, &current->thread.regs.regs);
 		if (ret)
 			return ret;
 		break;
-- 
2.34.1

