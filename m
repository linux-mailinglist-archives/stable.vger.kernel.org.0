Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E224990FB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354631AbiAXUIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:08:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359743AbiAXUAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:00:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E179AB8121C;
        Mon, 24 Jan 2022 20:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ECEC340E8;
        Mon, 24 Jan 2022 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054406;
        bh=YRtFLS33UvhcMXoutG1kpLoHx0Za8NOY2p3DeITTCGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8G190iczAmIsVdkIDTfdooI4luwueeEHzp5fS3yymmRXtMvTdrMl7hYhWww7QVw4
         IyOEYt6f0ZqCXhhygYJVU4qh8wK1TD8i75Egm2b5zyaGCmqKzyeACaRoRoIb/SsT68
         UecxR8EzEEdO+y0Inb4DT8kx/cPQYSexluZnTUA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-um@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/563] um: registers: Rename function names to avoid conflicts and build problems
Date:   Mon, 24 Jan 2022 19:42:24 +0100
Message-Id: <20220124184037.530599766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f79dc338279e6..b28373a2b8d2d 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -336,7 +336,7 @@ void __init os_early_checks(void)
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



