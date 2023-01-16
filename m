Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14C766C592
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjAPQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjAPQHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD37265BC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA8561042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94609C433EF;
        Mon, 16 Jan 2023 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885113;
        bh=dq5amhVjW74auuD0xBEmuShJQxPzQqIjSmg9XsIKu7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJhje3w1d0+Lg9odkYIMcrP0KUpwIRGKJjGEp9qKrm0LPbM6UI4OyxOgxjTMlaHnw
         2VODQrXQ2rs9gvz5fuqH9Ri9QqPhWkfD38NhHvtkqCIaQNi106jRBUoOpiRzS4Obdm
         /llHRk//RpIlz4Tblr7I7us1RTFm2Uh8hycSjPvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 62/86] tools/nolibc/arch: split arch-specific code into individual files
Date:   Mon, 16 Jan 2023 16:51:36 +0100
Message-Id: <20230116154749.640583303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 271661c1cde5ff47eb7af9946866cd66b70dc328 ]

In order to ease maintenance, this splits the arch-specific code into
one file per architecture. A common file "arch.h" is used to include the
right file among arch-* based on the detected architecture. Projects
which are already split per architecture could simply rename these
files to $arch/arch.h and get rid of the common arch.h. For this
reason, include guards were placed into each arch-specific file.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-aarch64.h |  199 +++++
 tools/include/nolibc/arch-arm.h     |  204 +++++
 tools/include/nolibc/arch-i386.h    |  196 +++++
 tools/include/nolibc/arch-mips.h    |  215 +++++
 tools/include/nolibc/arch-riscv.h   |  204 +++++
 tools/include/nolibc/arch-x86_64.h  |  215 +++++
 tools/include/nolibc/arch.h         |   32 +
 tools/include/nolibc/nolibc.h       | 1187 +--------------------------
 8 files changed, 1266 insertions(+), 1186 deletions(-)
 create mode 100644 tools/include/nolibc/arch-aarch64.h
 create mode 100644 tools/include/nolibc/arch-arm.h
 create mode 100644 tools/include/nolibc/arch-i386.h
 create mode 100644 tools/include/nolibc/arch-mips.h
 create mode 100644 tools/include/nolibc/arch-riscv.h
 create mode 100644 tools/include/nolibc/arch-x86_64.h
 create mode 100644 tools/include/nolibc/arch.h

diff --git a/tools/include/nolibc/arch-aarch64.h b/tools/include/nolibc/arch-aarch64.h
new file mode 100644
index 000000000000..443de5fb7f54
--- /dev/null
+++ b/tools/include/nolibc/arch-aarch64.h
@@ -0,0 +1,199 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * AARCH64 specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_AARCH64_H
+#define _NOLIBC_ARCH_AARCH64_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY    0x4000
+
+/* The struct returned by the newfstatat() syscall. Differs slightly from the
+ * x86_64's stat one by field ordering, so be careful.
+ */
+struct sys_stat_struct {
+	unsigned long   st_dev;
+	unsigned long   st_ino;
+	unsigned int    st_mode;
+	unsigned int    st_nlink;
+	unsigned int    st_uid;
+	unsigned int    st_gid;
+
+	unsigned long   st_rdev;
+	unsigned long   __pad1;
+	long            st_size;
+	int             st_blksize;
+	int             __pad2;
+
+	long            st_blocks;
+	long            st_atime;
+	unsigned long   st_atime_nsec;
+	long            st_mtime;
+
+	unsigned long   st_mtime_nsec;
+	long            st_ctime;
+	unsigned long   st_ctime_nsec;
+	unsigned int    __unused[2];
+};
+
+/* Syscalls for AARCH64 :
+ *   - registers are 64-bit
+ *   - stack is 16-byte aligned
+ *   - syscall number is passed in x8
+ *   - arguments are in x0, x1, x2, x3, x4, x5
+ *   - the system call is performed by calling svc 0
+ *   - syscall return comes in x0.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *
+ * On aarch64, select() is not implemented so we have to use pselect6().
+ */
+#define __ARCH_WANT_SYS_PSELECT6
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1),                                                 \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	register long _arg4 asm("x3") = (long)(arg4);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	register long _arg4 asm("x3") = (long)(arg4);                         \
+	register long _arg5 asm("x4") = (long)(arg5);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r" (_arg1)                                                \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	register long _arg4 asm("x3") = (long)(arg4);                         \
+	register long _arg5 asm("x4") = (long)(arg5);                         \
+	register long _arg6 asm("x5") = (long)(arg6);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r" (_arg1)                                                \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_arg6), "r"(_num)                                       \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+/* startup code */
+asm(".section .text\n"
+    ".global _start\n"
+    "_start:\n"
+    "ldr x0, [sp]\n"              // argc (x0) was in the stack
+    "add x1, sp, 8\n"             // argv (x1) = sp
+    "lsl x2, x0, 3\n"             // envp (x2) = 8*argc ...
+    "add x2, x2, 8\n"             //           + 8 (skip null)
+    "add x2, x2, x1\n"            //           + argv
+    "and sp, x1, -16\n"           // sp must be 16-byte aligned in the callee
+    "bl main\n"                   // main() returns the status code, we'll exit with it.
+    "mov x8, 93\n"                // NR_exit == 93
+    "svc #0\n"
+    "");
+
+#endif // _NOLIBC_ARCH_AARCH64_H
diff --git a/tools/include/nolibc/arch-arm.h b/tools/include/nolibc/arch-arm.h
new file mode 100644
index 000000000000..66f687ad987f
--- /dev/null
+++ b/tools/include/nolibc/arch-arm.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * ARM specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_ARM_H
+#define _NOLIBC_ARCH_ARM_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY    0x4000
+
+/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
+ * exactly 56 bytes (stops before the unused array). In big endian, the format
+ * differs as devices are returned as short only.
+ */
+struct sys_stat_struct {
+#if defined(__ARMEB__)
+	unsigned short st_dev;
+	unsigned short __pad1;
+#else
+	unsigned long  st_dev;
+#endif
+	unsigned long  st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+
+#if defined(__ARMEB__)
+	unsigned short st_rdev;
+	unsigned short __pad2;
+#else
+	unsigned long  st_rdev;
+#endif
+	unsigned long  st_size;
+	unsigned long  st_blksize;
+	unsigned long  st_blocks;
+
+	unsigned long  st_atime;
+	unsigned long  st_atime_nsec;
+	unsigned long  st_mtime;
+	unsigned long  st_mtime_nsec;
+
+	unsigned long  st_ctime;
+	unsigned long  st_ctime_nsec;
+	unsigned long  __unused[2];
+};
+
+/* Syscalls for ARM in ARM or Thumb modes :
+ *   - registers are 32-bit
+ *   - stack is 8-byte aligned
+ *     ( http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka4127.html)
+ *   - syscall number is passed in r7
+ *   - arguments are in r0, r1, r2, r3, r4, r5
+ *   - the system call is performed by calling svc #0
+ *   - syscall return comes in r0.
+ *   - only lr is clobbered.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *   - the syscall number is always specified last in order to allow to force
+ *     some registers before (gcc refuses a %-register at the last position).
+ *
+ * Also, ARM supports the old_select syscall if newselect is not available
+ */
+#define __ARCH_WANT_SYS_OLD_SELECT
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1),                                                 \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	register long _arg3 asm("r2") = (long)(arg3);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	register long _arg3 asm("r2") = (long)(arg3);                         \
+	register long _arg4 asm("r3") = (long)(arg4);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	register long _arg3 asm("r2") = (long)(arg3);                         \
+	register long _arg4 asm("r3") = (long)(arg4);                         \
+	register long _arg5 asm("r4") = (long)(arg5);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r" (_arg1)                                                \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+/* startup code */
+asm(".section .text\n"
+    ".global _start\n"
+    "_start:\n"
+#if defined(__THUMBEB__) || defined(__THUMBEL__)
+    /* We enter here in 32-bit mode but if some previous functions were in
+     * 16-bit mode, the assembler cannot know, so we need to tell it we're in
+     * 32-bit now, then switch to 16-bit (is there a better way to do it than
+     * adding 1 by hand ?) and tell the asm we're now in 16-bit mode so that
+     * it generates correct instructions. Note that we do not support thumb1.
+     */
+    ".code 32\n"
+    "add     r0, pc, #1\n"
+    "bx      r0\n"
+    ".code 16\n"
+#endif
+    "pop {%r0}\n"                 // argc was in the stack
+    "mov %r1, %sp\n"              // argv = sp
+    "add %r2, %r1, %r0, lsl #2\n" // envp = argv + 4*argc ...
+    "add %r2, %r2, $4\n"          //        ... + 4
+    "and %r3, %r1, $-8\n"         // AAPCS : sp must be 8-byte aligned in the
+    "mov %sp, %r3\n"              //         callee, an bl doesn't push (lr=pc)
+    "bl main\n"                   // main() returns the status code, we'll exit with it.
+    "movs r7, $1\n"               // NR_exit == 1
+    "svc $0x00\n"
+    "");
+
+#endif // _NOLIBC_ARCH_ARM_H
diff --git a/tools/include/nolibc/arch-i386.h b/tools/include/nolibc/arch-i386.h
new file mode 100644
index 000000000000..32f42e2cee26
--- /dev/null
+++ b/tools/include/nolibc/arch-i386.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * i386 specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_I386_H
+#define _NOLIBC_ARCH_I386_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
+
+/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
+ * exactly 56 bytes (stops before the unused array).
+ */
+struct sys_stat_struct {
+	unsigned long  st_dev;
+	unsigned long  st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+
+	unsigned long  st_rdev;
+	unsigned long  st_size;
+	unsigned long  st_blksize;
+	unsigned long  st_blocks;
+
+	unsigned long  st_atime;
+	unsigned long  st_atime_nsec;
+	unsigned long  st_mtime;
+	unsigned long  st_mtime_nsec;
+
+	unsigned long  st_ctime;
+	unsigned long  st_ctime_nsec;
+	unsigned long  __unused[2];
+};
+
+/* Syscalls for i386 :
+ *   - mostly similar to x86_64
+ *   - registers are 32-bit
+ *   - syscall number is passed in eax
+ *   - arguments are in ebx, ecx, edx, esi, edi, ebp respectively
+ *   - all registers are preserved (except eax of course)
+ *   - the system call is performed by calling int $0x80
+ *   - syscall return comes in eax
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *   - the syscall number is always specified last in order to allow to force
+ *     some registers before (gcc refuses a %-register at the last position).
+ *
+ * Also, i386 supports the old_select syscall if newselect is not available
+ */
+#define __ARCH_WANT_SYS_OLD_SELECT
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1),                                                 \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	register long _arg3 asm("edx") = (long)(arg3);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	register long _arg3 asm("edx") = (long)(arg3);                        \
+	register long _arg4 asm("esi") = (long)(arg4);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	register long _arg3 asm("edx") = (long)(arg3);                        \
+	register long _arg4 asm("esi") = (long)(arg4);                        \
+	register long _arg5 asm("edi") = (long)(arg5);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+/* startup code */
+/*
+ * i386 System V ABI mandates:
+ * 1) last pushed argument must be 16-byte aligned.
+ * 2) The deepest stack frame should be set to zero
+ *
+ */
+asm(".section .text\n"
+    ".global _start\n"
+    "_start:\n"
+    "pop %eax\n"                // argc   (first arg, %eax)
+    "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
+    "lea 4(%ebx,%eax,4),%ecx\n" // then a NULL then envp (third arg, %ecx)
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned before
+    "sub $4, %esp\n"            // the call instruction (args are aligned)
+    "push %ecx\n"               // push all registers on the stack so that we
+    "push %ebx\n"               // support both regparm and plain stack modes
+    "push %eax\n"
+    "call main\n"               // main() returns the status code in %eax
+    "mov %eax, %ebx\n"          // retrieve exit code (32-bit int)
+    "movl $1, %eax\n"           // NR_exit == 1
+    "int $0x80\n"               // exit now
+    "hlt\n"                     // ensure it does not
+    "");
+
+#endif // _NOLIBC_ARCH_I386_H
diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
new file mode 100644
index 000000000000..e330201dde6a
--- /dev/null
+++ b/tools/include/nolibc/arch-mips.h
@@ -0,0 +1,215 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * MIPS specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_MIPS_H
+#define _NOLIBC_ARCH_MIPS_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_APPEND       0x0008
+#define O_NONBLOCK     0x0080
+#define O_CREAT        0x0100
+#define O_TRUNC        0x0200
+#define O_EXCL         0x0400
+#define O_NOCTTY       0x0800
+#define O_DIRECTORY   0x10000
+
+/* The struct returned by the stat() syscall. 88 bytes are returned by the
+ * syscall.
+ */
+struct sys_stat_struct {
+	unsigned int  st_dev;
+	long          st_pad1[3];
+	unsigned long st_ino;
+	unsigned int  st_mode;
+	unsigned int  st_nlink;
+	unsigned int  st_uid;
+	unsigned int  st_gid;
+	unsigned int  st_rdev;
+	long          st_pad2[2];
+	long          st_size;
+	long          st_pad3;
+
+	long          st_atime;
+	long          st_atime_nsec;
+	long          st_mtime;
+	long          st_mtime_nsec;
+
+	long          st_ctime;
+	long          st_ctime_nsec;
+	long          st_blksize;
+	long          st_blocks;
+	long          st_pad4[14];
+};
+
+/* Syscalls for MIPS ABI O32 :
+ *   - WARNING! there's always a delayed slot!
+ *   - WARNING again, the syntax is different, registers take a '$' and numbers
+ *     do not.
+ *   - registers are 32-bit
+ *   - stack is 8-byte aligned
+ *   - syscall number is passed in v0 (starts at 0xfa0).
+ *   - arguments are in a0, a1, a2, a3, then the stack. The caller needs to
+ *     leave some room in the stack for the callee to save a0..a3 if needed.
+ *   - Many registers are clobbered, in fact only a0..a2 and s0..s8 are
+ *     preserved. See: https://www.linux-mips.org/wiki/Syscall as well as
+ *     scall32-o32.S in the kernel sources.
+ *   - the system call is performed by calling "syscall"
+ *   - syscall return comes in v0, and register a3 needs to be checked to know
+ *     if an error occurred, in which case errno is in v0.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ */
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "r"(_num)                                                   \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "0"(_num),                                                  \
+		  "r"(_arg1)                                                  \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2)                                      \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num asm("v0")  = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2), "r"(_arg3)                          \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r" (_num), "=r"(_arg4)                                    \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4)              \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	register long _arg5 = (long)(arg5);                                   \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"sw %7, 16($sp)\n"                                            \
+		"syscall\n  "                                                 \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r" (_num), "=r"(_arg4)                                    \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5)  \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+/* startup code, note that it's called __start on MIPS */
+asm(".section .text\n"
+    ".set nomips16\n"
+    ".global __start\n"
+    ".set    noreorder\n"
+    ".option pic0\n"
+    ".ent __start\n"
+    "__start:\n"
+    "lw $a0,($sp)\n"              // argc was in the stack
+    "addiu  $a1, $sp, 4\n"        // argv = sp + 4
+    "sll $a2, $a0, 2\n"           // a2 = argc * 4
+    "add   $a2, $a2, $a1\n"       // envp = argv + 4*argc ...
+    "addiu $a2, $a2, 4\n"         //        ... + 4
+    "li $t0, -8\n"
+    "and $sp, $sp, $t0\n"         // sp must be 8-byte aligned
+    "addiu $sp,$sp,-16\n"         // the callee expects to save a0..a3 there!
+    "jal main\n"                  // main() returns the status code, we'll exit with it.
+    "nop\n"                       // delayed slot
+    "move $a0, $v0\n"             // retrieve 32-bit exit code from v0
+    "li $v0, 4001\n"              // NR_exit == 4001
+    "syscall\n"
+    ".end __start\n"
+    "");
+
+#endif // _NOLIBC_ARCH_MIPS_H
diff --git a/tools/include/nolibc/arch-riscv.h b/tools/include/nolibc/arch-riscv.h
new file mode 100644
index 000000000000..9d5ff78f606b
--- /dev/null
+++ b/tools/include/nolibc/arch-riscv.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * RISCV (32 and 64) specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_RISCV_H
+#define _NOLIBC_ARCH_RISCV_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT         0x100
+#define O_EXCL          0x200
+#define O_NOCTTY        0x400
+#define O_TRUNC        0x1000
+#define O_APPEND       0x2000
+#define O_NONBLOCK     0x4000
+#define O_DIRECTORY  0x200000
+
+struct sys_stat_struct {
+	unsigned long	st_dev;		/* Device.  */
+	unsigned long	st_ino;		/* File serial number.  */
+	unsigned int	st_mode;	/* File mode.  */
+	unsigned int	st_nlink;	/* Link count.  */
+	unsigned int	st_uid;		/* User ID of the file's owner.  */
+	unsigned int	st_gid;		/* Group ID of the file's group. */
+	unsigned long	st_rdev;	/* Device number, if device.  */
+	unsigned long	__pad1;
+	long		st_size;	/* Size of file, in bytes.  */
+	int		st_blksize;	/* Optimal block size for I/O.  */
+	int		__pad2;
+	long		st_blocks;	/* Number 512-byte blocks allocated. */
+	long		st_atime;	/* Time of last access.  */
+	unsigned long	st_atime_nsec;
+	long		st_mtime;	/* Time of last modification.  */
+	unsigned long	st_mtime_nsec;
+	long		st_ctime;	/* Time of last status change.  */
+	unsigned long	st_ctime_nsec;
+	unsigned int	__unused4;
+	unsigned int	__unused5;
+};
+
+#if   __riscv_xlen == 64
+#define PTRLOG "3"
+#define SZREG  "8"
+#elif __riscv_xlen == 32
+#define PTRLOG "2"
+#define SZREG  "4"
+#endif
+
+/* Syscalls for RISCV :
+ *   - stack is 16-byte aligned
+ *   - syscall number is passed in a7
+ *   - arguments are in a0, a1, a2, a3, a4, a5
+ *   - the system call is performed by calling ecall
+ *   - syscall return comes in a0
+ *   - the arguments are cast to long and assigned into the target
+ *     registers which are then simply passed as registers to the asm code,
+ *     so that we don't have to experience issues with register constraints.
+ *
+ * On riscv, select() is not implemented so we have to use pselect6().
+ */
+#define __ARCH_WANT_SYS_PSELECT6
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0");                                        \
+									      \
+	asm volatile (                                                        \
+		"ecall\n\t"                                                   \
+		: "=r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);		              \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2),                                                 \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n\t"                                                   \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3),                                     \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4),                         \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	register long _arg5 asm("a4") = (long)(arg5);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5),             \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	register long _arg5 asm("a4") = (long)(arg5);                         \
+	register long _arg6 asm("a5") = (long)(arg6);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), "r"(_arg6), \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+/* startup code */
+asm(".section .text\n"
+    ".global _start\n"
+    "_start:\n"
+    ".option push\n"
+    ".option norelax\n"
+    "lla   gp, __global_pointer$\n"
+    ".option pop\n"
+    "ld    a0, 0(sp)\n"          // argc (a0) was in the stack
+    "add   a1, sp, "SZREG"\n"    // argv (a1) = sp
+    "slli  a2, a0, "PTRLOG"\n"   // envp (a2) = SZREG*argc ...
+    "add   a2, a2, "SZREG"\n"    //             + SZREG (skip null)
+    "add   a2,a2,a1\n"           //             + argv
+    "andi  sp,a1,-16\n"          // sp must be 16-byte aligned
+    "call  main\n"               // main() returns the status code, we'll exit with it.
+    "li a7, 93\n"                // NR_exit == 93
+    "ecall\n"
+    "");
+
+#endif // _NOLIBC_ARCH_RISCV_H
diff --git a/tools/include/nolibc/arch-x86_64.h b/tools/include/nolibc/arch-x86_64.h
new file mode 100644
index 000000000000..83c4b458ada7
--- /dev/null
+++ b/tools/include/nolibc/arch-x86_64.h
@@ -0,0 +1,215 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * x86_64 specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_X86_64_H
+#define _NOLIBC_ARCH_X86_64_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
+
+/* The struct returned by the stat() syscall, equivalent to stat64(). The
+ * syscall returns 116 bytes and stops in the middle of __unused.
+ */
+struct sys_stat_struct {
+	unsigned long st_dev;
+	unsigned long st_ino;
+	unsigned long st_nlink;
+	unsigned int  st_mode;
+	unsigned int  st_uid;
+
+	unsigned int  st_gid;
+	unsigned int  __pad0;
+	unsigned long st_rdev;
+	long          st_size;
+	long          st_blksize;
+
+	long          st_blocks;
+	unsigned long st_atime;
+	unsigned long st_atime_nsec;
+	unsigned long st_mtime;
+
+	unsigned long st_mtime_nsec;
+	unsigned long st_ctime;
+	unsigned long st_ctime_nsec;
+	long          __unused[3];
+};
+
+/* Syscalls for x86_64 :
+ *   - registers are 64-bit
+ *   - syscall number is passed in rax
+ *   - arguments are in rdi, rsi, rdx, r10, r8, r9 respectively
+ *   - the system call is performed by calling the syscall instruction
+ *   - syscall return comes in rax
+ *   - rcx and r11 are clobbered, others are preserved.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *   - the syscall number is always specified last in order to allow to force
+ *     some registers before (gcc refuses a %-register at the last position).
+ *   - see also x86-64 ABI section A.2 AMD64 Linux Kernel Conventions, A.2.1
+ *     Calling Conventions.
+ *
+ * Link x86-64 ABI: https://gitlab.com/x86-psABIs/x86-64-ABI/-/wikis/x86-64-psABI
+ *
+ */
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1),                                                 \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	register long _arg4 asm("r10") = (long)(arg4);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	register long _arg4 asm("r10") = (long)(arg4);                        \
+	register long _arg5 asm("r8")  = (long)(arg5);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	register long _arg4 asm("r10") = (long)(arg4);                        \
+	register long _arg5 asm("r8")  = (long)(arg5);                        \
+	register long _arg6 asm("r9")  = (long)(arg6);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_arg6), "0"(_num)                                       \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+/* startup code */
+/*
+ * x86-64 System V ABI mandates:
+ * 1) %rsp must be 16-byte aligned right before the function call.
+ * 2) The deepest stack frame should be zero (the %rbp).
+ *
+ */
+asm(".section .text\n"
+    ".global _start\n"
+    "_start:\n"
+    "pop %rdi\n"                // argc   (first arg, %rdi)
+    "mov %rsp, %rsi\n"          // argv[] (second arg, %rsi)
+    "lea 8(%rsi,%rdi,8),%rdx\n" // then a NULL then envp (third arg, %rdx)
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
+    "call main\n"               // main() returns the status code, we'll exit with it.
+    "mov %eax, %edi\n"          // retrieve exit code (32 bit)
+    "mov $60, %eax\n"           // NR_exit == 60
+    "syscall\n"                 // really exit
+    "hlt\n"                     // ensure it does not return
+    "");
+
+#endif // _NOLIBC_ARCH_X86_64_H
diff --git a/tools/include/nolibc/arch.h b/tools/include/nolibc/arch.h
new file mode 100644
index 000000000000..4c6992321b0d
--- /dev/null
+++ b/tools/include/nolibc/arch.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+/* Below comes the architecture-specific code. For each architecture, we have
+ * the syscall declarations and the _start code definition. This is the only
+ * global part. On all architectures the kernel puts everything in the stack
+ * before jumping to _start just above us, without any return address (_start
+ * is not a function but an entry pint). So at the stack pointer we find argc.
+ * Then argv[] begins, and ends at the first NULL. Then we have envp which
+ * starts and ends with a NULL as well. So envp=argv+argc+1.
+ */
+
+#ifndef _NOLIBC_ARCH_H
+#define _NOLIBC_ARCH_H
+
+#if defined(__x86_64__)
+#include "arch-x86_64.h"
+#elif defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__)
+#include "arch-i386.h"
+#elif defined(__ARM_EABI__)
+#include "arch-arm.h"
+#elif defined(__aarch64__)
+#include "arch-aarch64.h"
+#elif defined(__mips__) && defined(_ABIO32)
+#include "arch-mips.h"
+#elif defined(__riscv)
+#include "arch-riscv.h"
+#endif
+
+#endif /* _NOLIBC_ARCH_H */
diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index fbfc02aa99c3..d272b721dc51 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -92,6 +92,7 @@
 #include <linux/fs.h>
 #include <linux/loop.h>
 #include <linux/time.h>
+#include "arch.h"
 #include "types.h"
 
 /* Used by programs to avoid std includes */
@@ -111,1192 +112,6 @@ static int errno;
  */
 #define MAX_ERRNO 4095
 
-/* Below comes the architecture-specific code. For each architecture, we have
- * the syscall declarations and the _start code definition. This is the only
- * global part. On all architectures the kernel puts everything in the stack
- * before jumping to _start just above us, without any return address (_start
- * is not a function but an entry pint). So at the stack pointer we find argc.
- * Then argv[] begins, and ends at the first NULL. Then we have envp which
- * starts and ends with a NULL as well. So envp=argv+argc+1.
- */
-
-#if defined(__x86_64__)
-/* Syscalls for x86_64 :
- *   - registers are 64-bit
- *   - syscall number is passed in rax
- *   - arguments are in rdi, rsi, rdx, r10, r8, r9 respectively
- *   - the system call is performed by calling the syscall instruction
- *   - syscall return comes in rax
- *   - rcx and r11 are clobbered, others are preserved.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *   - the syscall number is always specified last in order to allow to force
- *     some registers before (gcc refuses a %-register at the last position).
- *   - see also x86-64 ABI section A.2 AMD64 Linux Kernel Conventions, A.2.1
- *     Calling Conventions.
- *
- * Link x86-64 ABI: https://gitlab.com/x86-psABIs/x86-64-ABI/-/wikis/x86-64-psABI
- *
- */
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "0"(_num)                                                   \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "r"(_arg1),                                                 \
-		  "0"(_num)                                                   \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "0"(_num)                                                   \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "0"(_num)                                                   \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-	register long _arg4 asm("r10") = (long)(arg4);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "0"(_num)                                                   \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-	register long _arg4 asm("r10") = (long)(arg4);                        \
-	register long _arg5 asm("r8")  = (long)(arg5);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "0"(_num)                                                   \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-	register long _arg4 asm("r10") = (long)(arg4);                        \
-	register long _arg5 asm("r8")  = (long)(arg5);                        \
-	register long _arg6 asm("r9")  = (long)(arg6);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a"(_ret)                                                  \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_arg6), "0"(_num)                                       \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-/* startup code */
-/*
- * x86-64 System V ABI mandates:
- * 1) %rsp must be 16-byte aligned right before the function call.
- * 2) The deepest stack frame should be zero (the %rbp).
- *
- */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    "pop %rdi\n"                // argc   (first arg, %rdi)
-    "mov %rsp, %rsi\n"          // argv[] (second arg, %rsi)
-    "lea 8(%rsi,%rdi,8),%rdx\n" // then a NULL then envp (third arg, %rdx)
-    "xor %ebp, %ebp\n"          // zero the stack frame
-    "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
-    "call main\n"               // main() returns the status code, we'll exit with it.
-    "mov %eax, %edi\n"          // retrieve exit code (32 bit)
-    "mov $60, %eax\n"           // NR_exit == 60
-    "syscall\n"                 // really exit
-    "hlt\n"                     // ensure it does not return
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY   0x10000
-
-/* The struct returned by the stat() syscall, equivalent to stat64(). The
- * syscall returns 116 bytes and stops in the middle of __unused.
- */
-struct sys_stat_struct {
-	unsigned long st_dev;
-	unsigned long st_ino;
-	unsigned long st_nlink;
-	unsigned int  st_mode;
-	unsigned int  st_uid;
-
-	unsigned int  st_gid;
-	unsigned int  __pad0;
-	unsigned long st_rdev;
-	long          st_size;
-	long          st_blksize;
-
-	long          st_blocks;
-	unsigned long st_atime;
-	unsigned long st_atime_nsec;
-	unsigned long st_mtime;
-
-	unsigned long st_mtime_nsec;
-	unsigned long st_ctime;
-	unsigned long st_ctime_nsec;
-	long          __unused[3];
-};
-
-#elif defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__)
-/* Syscalls for i386 :
- *   - mostly similar to x86_64
- *   - registers are 32-bit
- *   - syscall number is passed in eax
- *   - arguments are in ebx, ecx, edx, esi, edi, ebp respectively
- *   - all registers are preserved (except eax of course)
- *   - the system call is performed by calling int $0x80
- *   - syscall return comes in eax
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *   - the syscall number is always specified last in order to allow to force
- *     some registers before (gcc refuses a %-register at the last position).
- *
- * Also, i386 supports the old_select syscall if newselect is not available
- */
-#define __ARCH_WANT_SYS_OLD_SELECT
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1),                                                 \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-	register long _arg3 asm("edx") = (long)(arg3);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-	register long _arg3 asm("edx") = (long)(arg3);                        \
-	register long _arg4 asm("esi") = (long)(arg4);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-	register long _arg3 asm("edx") = (long)(arg3);                        \
-	register long _arg4 asm("esi") = (long)(arg4);                        \
-	register long _arg5 asm("edi") = (long)(arg5);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-/* startup code */
-/*
- * i386 System V ABI mandates:
- * 1) last pushed argument must be 16-byte aligned.
- * 2) The deepest stack frame should be set to zero
- *
- */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    "pop %eax\n"                // argc   (first arg, %eax)
-    "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
-    "lea 4(%ebx,%eax,4),%ecx\n" // then a NULL then envp (third arg, %ecx)
-    "xor %ebp, %ebp\n"          // zero the stack frame
-    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned before
-    "sub $4, %esp\n"            // the call instruction (args are aligned)
-    "push %ecx\n"               // push all registers on the stack so that we
-    "push %ebx\n"               // support both regparm and plain stack modes
-    "push %eax\n"
-    "call main\n"               // main() returns the status code in %eax
-    "mov %eax, %ebx\n"          // retrieve exit code (32-bit int)
-    "movl $1, %eax\n"           // NR_exit == 1
-    "int $0x80\n"               // exit now
-    "hlt\n"                     // ensure it does not
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY   0x10000
-
-/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
- * exactly 56 bytes (stops before the unused array).
- */
-struct sys_stat_struct {
-	unsigned long  st_dev;
-	unsigned long  st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-
-	unsigned long  st_rdev;
-	unsigned long  st_size;
-	unsigned long  st_blksize;
-	unsigned long  st_blocks;
-
-	unsigned long  st_atime;
-	unsigned long  st_atime_nsec;
-	unsigned long  st_mtime;
-	unsigned long  st_mtime_nsec;
-
-	unsigned long  st_ctime;
-	unsigned long  st_ctime_nsec;
-	unsigned long  __unused[2];
-};
-
-#elif defined(__ARM_EABI__)
-/* Syscalls for ARM in ARM or Thumb modes :
- *   - registers are 32-bit
- *   - stack is 8-byte aligned
- *     ( http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka4127.html)
- *   - syscall number is passed in r7
- *   - arguments are in r0, r1, r2, r3, r4, r5
- *   - the system call is performed by calling svc #0
- *   - syscall return comes in r0.
- *   - only lr is clobbered.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *   - the syscall number is always specified last in order to allow to force
- *     some registers before (gcc refuses a %-register at the last position).
- *
- * Also, ARM supports the old_select syscall if newselect is not available
- */
-#define __ARCH_WANT_SYS_OLD_SELECT
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0");                                        \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1),                                                 \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-	register long _arg3 asm("r2") = (long)(arg3);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-	register long _arg3 asm("r2") = (long)(arg3);                         \
-	register long _arg4 asm("r3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-	register long _arg3 asm("r2") = (long)(arg3);                         \
-	register long _arg4 asm("r3") = (long)(arg4);                         \
-	register long _arg5 asm("r4") = (long)(arg5);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r" (_arg1)                                                \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-/* startup code */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-#if defined(__THUMBEB__) || defined(__THUMBEL__)
-    /* We enter here in 32-bit mode but if some previous functions were in
-     * 16-bit mode, the assembler cannot know, so we need to tell it we're in
-     * 32-bit now, then switch to 16-bit (is there a better way to do it than
-     * adding 1 by hand ?) and tell the asm we're now in 16-bit mode so that
-     * it generates correct instructions. Note that we do not support thumb1.
-     */
-    ".code 32\n"
-    "add     r0, pc, #1\n"
-    "bx      r0\n"
-    ".code 16\n"
-#endif
-    "pop {%r0}\n"                 // argc was in the stack
-    "mov %r1, %sp\n"              // argv = sp
-    "add %r2, %r1, %r0, lsl #2\n" // envp = argv + 4*argc ...
-    "add %r2, %r2, $4\n"          //        ... + 4
-    "and %r3, %r1, $-8\n"         // AAPCS : sp must be 8-byte aligned in the
-    "mov %sp, %r3\n"              //         callee, an bl doesn't push (lr=pc)
-    "bl main\n"                   // main() returns the status code, we'll exit with it.
-    "movs r7, $1\n"               // NR_exit == 1
-    "svc $0x00\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY    0x4000
-
-/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
- * exactly 56 bytes (stops before the unused array). In big endian, the format
- * differs as devices are returned as short only.
- */
-struct sys_stat_struct {
-#if defined(__ARMEB__)
-	unsigned short st_dev;
-	unsigned short __pad1;
-#else
-	unsigned long  st_dev;
-#endif
-	unsigned long  st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-#if defined(__ARMEB__)
-	unsigned short st_rdev;
-	unsigned short __pad2;
-#else
-	unsigned long  st_rdev;
-#endif
-	unsigned long  st_size;
-	unsigned long  st_blksize;
-	unsigned long  st_blocks;
-	unsigned long  st_atime;
-	unsigned long  st_atime_nsec;
-	unsigned long  st_mtime;
-	unsigned long  st_mtime_nsec;
-	unsigned long  st_ctime;
-	unsigned long  st_ctime_nsec;
-	unsigned long  __unused[2];
-};
-
-#elif defined(__aarch64__)
-/* Syscalls for AARCH64 :
- *   - registers are 64-bit
- *   - stack is 16-byte aligned
- *   - syscall number is passed in x8
- *   - arguments are in x0, x1, x2, x3, x4, x5
- *   - the system call is performed by calling svc 0
- *   - syscall return comes in x0.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *
- * On aarch64, select() is not implemented so we have to use pselect6().
- */
-#define __ARCH_WANT_SYS_PSELECT6
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0");                                        \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1),                                                 \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-	register long _arg4 asm("x3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-	register long _arg4 asm("x3") = (long)(arg4);                         \
-	register long _arg5 asm("x4") = (long)(arg5);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r" (_arg1)                                                \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-	register long _arg4 asm("x3") = (long)(arg4);                         \
-	register long _arg5 asm("x4") = (long)(arg5);                         \
-	register long _arg6 asm("x5") = (long)(arg6);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r" (_arg1)                                                \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_arg6), "r"(_num)                                       \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-/* startup code */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    "ldr x0, [sp]\n"              // argc (x0) was in the stack
-    "add x1, sp, 8\n"             // argv (x1) = sp
-    "lsl x2, x0, 3\n"             // envp (x2) = 8*argc ...
-    "add x2, x2, 8\n"             //           + 8 (skip null)
-    "add x2, x2, x1\n"            //           + argv
-    "and sp, x1, -16\n"           // sp must be 16-byte aligned in the callee
-    "bl main\n"                   // main() returns the status code, we'll exit with it.
-    "mov x8, 93\n"                // NR_exit == 93
-    "svc #0\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY    0x4000
-
-/* The struct returned by the newfstatat() syscall. Differs slightly from the
- * x86_64's stat one by field ordering, so be careful.
- */
-struct sys_stat_struct {
-	unsigned long   st_dev;
-	unsigned long   st_ino;
-	unsigned int    st_mode;
-	unsigned int    st_nlink;
-	unsigned int    st_uid;
-	unsigned int    st_gid;
-
-	unsigned long   st_rdev;
-	unsigned long   __pad1;
-	long            st_size;
-	int             st_blksize;
-	int             __pad2;
-
-	long            st_blocks;
-	long            st_atime;
-	unsigned long   st_atime_nsec;
-	long            st_mtime;
-
-	unsigned long   st_mtime_nsec;
-	long            st_ctime;
-	unsigned long   st_ctime_nsec;
-	unsigned int    __unused[2];
-};
-
-#elif defined(__mips__) && defined(_ABIO32)
-/* Syscalls for MIPS ABI O32 :
- *   - WARNING! there's always a delayed slot!
- *   - WARNING again, the syntax is different, registers take a '$' and numbers
- *     do not.
- *   - registers are 32-bit
- *   - stack is 8-byte aligned
- *   - syscall number is passed in v0 (starts at 0xfa0).
- *   - arguments are in a0, a1, a2, a3, then the stack. The caller needs to
- *     leave some room in the stack for the callee to save a0..a3 if needed.
- *   - Many registers are clobbered, in fact only a0..a2 and s0..s8 are
- *     preserved. See: https://www.linux-mips.org/wiki/Syscall as well as
- *     scall32-o32.S in the kernel sources.
- *   - the system call is performed by calling "syscall"
- *   - syscall return comes in v0, and register a3 needs to be checked to know
- *     if an error occurred, in which case errno is in v0.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- */
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "r"(_num)                                                   \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "0"(_num),                                                  \
-		  "r"(_arg1)                                                  \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2)                                      \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num asm("v0")  = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2), "r"(_arg3)                          \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r" (_num), "=r"(_arg4)                                    \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4)              \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-	register long _arg5 = (long)(arg5);				      \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"sw %7, 16($sp)\n"                                            \
-		"syscall\n  "                                                 \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r" (_num), "=r"(_arg4)                                    \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5)  \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-/* startup code, note that it's called __start on MIPS */
-asm(".section .text\n"
-    ".set nomips16\n"
-    ".global __start\n"
-    ".set    noreorder\n"
-    ".option pic0\n"
-    ".ent __start\n"
-    "__start:\n"
-    "lw $a0,($sp)\n"              // argc was in the stack
-    "addiu  $a1, $sp, 4\n"        // argv = sp + 4
-    "sll $a2, $a0, 2\n"           // a2 = argc * 4
-    "add   $a2, $a2, $a1\n"       // envp = argv + 4*argc ...
-    "addiu $a2, $a2, 4\n"         //        ... + 4
-    "li $t0, -8\n"
-    "and $sp, $sp, $t0\n"         // sp must be 8-byte aligned
-    "addiu $sp,$sp,-16\n"         // the callee expects to save a0..a3 there!
-    "jal main\n"                  // main() returns the status code, we'll exit with it.
-    "nop\n"                       // delayed slot
-    "move $a0, $v0\n"             // retrieve 32-bit exit code from v0
-    "li $v0, 4001\n"              // NR_exit == 4001
-    "syscall\n"
-    ".end __start\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_APPEND       0x0008
-#define O_NONBLOCK     0x0080
-#define O_CREAT        0x0100
-#define O_TRUNC        0x0200
-#define O_EXCL         0x0400
-#define O_NOCTTY       0x0800
-#define O_DIRECTORY   0x10000
-
-/* The struct returned by the stat() syscall. 88 bytes are returned by the
- * syscall.
- */
-struct sys_stat_struct {
-	unsigned int  st_dev;
-	long          st_pad1[3];
-	unsigned long st_ino;
-	unsigned int  st_mode;
-	unsigned int  st_nlink;
-	unsigned int  st_uid;
-	unsigned int  st_gid;
-	unsigned int  st_rdev;
-	long          st_pad2[2];
-	long          st_size;
-	long          st_pad3;
-	long          st_atime;
-	long          st_atime_nsec;
-	long          st_mtime;
-	long          st_mtime_nsec;
-	long          st_ctime;
-	long          st_ctime_nsec;
-	long          st_blksize;
-	long          st_blocks;
-	long          st_pad4[14];
-};
-
-#elif defined(__riscv)
-
-#if   __riscv_xlen == 64
-#define PTRLOG "3"
-#define SZREG  "8"
-#elif __riscv_xlen == 32
-#define PTRLOG "2"
-#define SZREG  "4"
-#endif
-
-/* Syscalls for RISCV :
- *   - stack is 16-byte aligned
- *   - syscall number is passed in a7
- *   - arguments are in a0, a1, a2, a3, a4, a5
- *   - the system call is performed by calling ecall
- *   - syscall return comes in a0
- *   - the arguments are cast to long and assigned into the target
- *     registers which are then simply passed as registers to the asm code,
- *     so that we don't have to experience issues with register constraints.
- *
- * On riscv, select() is not implemented so we have to use pselect6().
- */
-#define __ARCH_WANT_SYS_PSELECT6
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0");                                        \
-									      \
-	asm volatile (                                                        \
-		"ecall\n\t"                                                   \
-		: "=r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);		              \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2),                                                 \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n\t"                                                   \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3),                                     \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3), "r"(_arg4),                         \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-	register long _arg5 asm("a4") = (long)(arg5);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5),             \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-	register long _arg5 asm("a4") = (long)(arg5);                         \
-	register long _arg6 asm("a5") = (long)(arg6);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), "r"(_arg6), \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-/* startup code */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    ".option push\n"
-    ".option norelax\n"
-    "lla   gp, __global_pointer$\n"
-    ".option pop\n"
-    "ld    a0, 0(sp)\n"          // argc (a0) was in the stack
-    "add   a1, sp, "SZREG"\n"    // argv (a1) = sp
-    "slli  a2, a0, "PTRLOG"\n"   // envp (a2) = SZREG*argc ...
-    "add   a2, a2, "SZREG"\n"    //             + SZREG (skip null)
-    "add   a2,a2,a1\n"           //             + argv
-    "andi  sp,a1,-16\n"          // sp must be 16-byte aligned
-    "call  main\n"               // main() returns the status code, we'll exit with it.
-    "li a7, 93\n"                // NR_exit == 93
-    "ecall\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT         0x100
-#define O_EXCL          0x200
-#define O_NOCTTY        0x400
-#define O_TRUNC        0x1000
-#define O_APPEND       0x2000
-#define O_NONBLOCK     0x4000
-#define O_DIRECTORY  0x200000
-
-struct sys_stat_struct {
-	unsigned long	st_dev;		/* Device.  */
-	unsigned long	st_ino;		/* File serial number.  */
-	unsigned int	st_mode;	/* File mode.  */
-	unsigned int	st_nlink;	/* Link count.  */
-	unsigned int	st_uid;		/* User ID of the file's owner.  */
-	unsigned int	st_gid;		/* Group ID of the file's group. */
-	unsigned long	st_rdev;	/* Device number, if device.  */
-	unsigned long	__pad1;
-	long		st_size;	/* Size of file, in bytes.  */
-	int		st_blksize;	/* Optimal block size for I/O.  */
-	int		__pad2;
-	long		st_blocks;	/* Number 512-byte blocks allocated. */
-	long		st_atime;	/* Time of last access.  */
-	unsigned long	st_atime_nsec;
-	long		st_mtime;	/* Time of last modification.  */
-	unsigned long	st_mtime_nsec;
-	long		st_ctime;	/* Time of last status change.  */
-	unsigned long	st_ctime_nsec;
-	unsigned int	__unused4;
-	unsigned int	__unused5;
-};
-
-#endif
-
 
 /* Below are the C functions used to declare the raw syscalls. They try to be
  * architecture-agnostic, and return either a success or -errno. Declaring them
-- 
2.35.1



