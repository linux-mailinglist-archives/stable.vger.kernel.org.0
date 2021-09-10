Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD31406C1E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhIJMhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhIJMf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC55461026;
        Fri, 10 Sep 2021 12:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277287;
        bh=PV0pCOrM3/lW/LE60bNOLlHJ41NWQ3XVhQlG126X4us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrlAzwASAaTlGCqI7ZijVyJk7vRJhWxGaMBRjiPCwz+d2UM7AU1Pw3YOBeKMEUSoM
         sUwLwxAkKRjIos8/yVijRbPkpEp/v07RAYyAh8kp1zzka9gOAtK0vViwtToTLBB/dw
         uAJ4/4oM3sP4lFV6uYyzIFCIqTWh6QQ2fpiADRNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.4 20/37] ARC: wireup clone3 syscall
Date:   Fri, 10 Sep 2021 14:30:23 +0200
Message-Id: <20210910122917.829853895@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit bd71c453db91ecb464405411f2821d040f2a0d44 upstream.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/Kconfig                   |    1 +
 arch/arc/include/asm/syscalls.h    |    1 +
 arch/arc/include/uapi/asm/unistd.h |    1 +
 arch/arc/kernel/entry.S            |   12 ++++++++++++
 arch/arc/kernel/process.c          |    7 +++----
 arch/arc/kernel/sys.c              |    1 +
 6 files changed, 19 insertions(+), 4 deletions(-)

--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -29,6 +29,7 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_IOREMAP_PROT
--- a/arch/arc/include/asm/syscalls.h
+++ b/arch/arc/include/asm/syscalls.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 
 int sys_clone_wrapper(int, int, int, int, int);
+int sys_clone3_wrapper(void *, size_t);
 int sys_cacheflush(uint32_t, uint32_t uint32_t);
 int sys_arc_settls(void *);
 int sys_arc_gettls(void);
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -21,6 +21,7 @@
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_CLONE3
 #define __ARCH_WANT_SYS_VFORK
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_TIME32_SYSCALLS
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -35,6 +35,18 @@ ENTRY(sys_clone_wrapper)
 	b .Lret_from_system_call
 END(sys_clone_wrapper)
 
+ENTRY(sys_clone3_wrapper)
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_clone3
+	DISCARD_CALLEE_SAVED_USER
+
+	GET_CURR_THR_INFO_FLAGS   r10
+	btst r10, TIF_SYSCALL_TRACE
+	bnz  tracesys_exit
+
+	b .Lret_from_system_call
+END(sys_clone3_wrapper)
+
 ENTRY(ret_from_fork)
 	; when the forked child comes here from the __switch_to function
 	; r0 has the last task pointer.
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -171,9 +171,8 @@ asmlinkage void ret_from_fork(void);
  * |    user_r25    |
  * ------------------  <===== END of PAGE
  */
-int copy_thread(unsigned long clone_flags,
-		unsigned long usp, unsigned long kthread_arg,
-		struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long usp,
+	unsigned long kthread_arg, struct task_struct *p, unsigned long tls)
 {
 	struct pt_regs *c_regs;        /* child's pt_regs */
 	unsigned long *childksp;       /* to unwind out of __switch_to() */
@@ -231,7 +230,7 @@ int copy_thread(unsigned long clone_flag
 		 * set task's userland tls data ptr from 4th arg
 		 * clone C-lib call is difft from clone sys-call
 		 */
-		task_thread_info(p)->thr_ptr = regs->r3;
+		task_thread_info(p)->thr_ptr = tls;
 	} else {
 		/* Normal fork case: set parent's TLS ptr in child */
 		task_thread_info(p)->thr_ptr =
--- a/arch/arc/kernel/sys.c
+++ b/arch/arc/kernel/sys.c
@@ -7,6 +7,7 @@
 #include <asm/syscalls.h>
 
 #define sys_clone	sys_clone_wrapper
+#define sys_clone3	sys_clone3_wrapper
 
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),


