Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150A32F7A32
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbhAOMqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388055AbhAOMhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A44221F7;
        Fri, 15 Jan 2021 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714250;
        bh=wE75PDFaHZkN7JcxnkK7MJaJs7Pq9I4BTZG8r9FSRRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNQAessvayhzKZWAyNP8Ao0/cLPXfGASvMAxB3wkHSIOoRag1/iCFLnh+NgG99YLN
         VFGso0GJmKKY+uWi+JBSBeeoC77+I7e5kVVUG62SpkfbLLx4eEMZT/4m05nTuuc+o+
         ZYhw7JJA5mX4wsvp1abbq6BCuDwZLef4yLsSPWSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Jasiak?= <pawel@jasiak.xyz>,
        Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 5.10 051/103] fanotify: Fix sys_fanotify_mark() on native x86-32
Date:   Fri, 15 Jan 2021 13:27:44 +0100
Message-Id: <20210115122008.527139997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

commit 2ca408d9c749c32288bc28725f9f12ba30299e8f upstream.

Commit

  121b32a58a3a ("x86/entry/32: Use IA32-specific wrappers for syscalls taking 64-bit arguments")

converted native x86-32 which take 64-bit arguments to use the
compat handlers to allow conversion to passing args via pt_regs.
sys_fanotify_mark() was however missed, as it has a general compat
handler. Add a config option that will use the syscall wrapper that
takes the split args for native 32-bit.

 [ bp: Fix typo in Kconfig help text. ]

Fixes: 121b32a58a3a ("x86/entry/32: Use IA32-specific wrappers for syscalls taking 64-bit arguments")
Reported-by: Paweł Jasiak <pawel@jasiak.xyz>
Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Andy Lutomirski <luto@kernel.org>
Link: https://lkml.kernel.org/r/20201130223059.101286-1-brgerst@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/Kconfig                       |    6 ++++++
 arch/x86/Kconfig                   |    1 +
 fs/notify/fanotify/fanotify_user.c |   17 +++++++----------
 include/linux/syscalls.h           |   24 ++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 10 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1053,6 +1053,12 @@ config ARCH_WANT_LD_ORPHAN_WARN
 	  by the linker, since the locations of such sections can change between linker
 	  versions.
 
+config ARCH_SPLIT_ARG64
+	bool
+	help
+	   If a 32-bit architecture requires 64-bit arguments to be split into
+	   pairs of 32-bit arguments, select this option.
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -18,6 +18,7 @@ config X86_32
 	select MODULES_USE_ELF_REL
 	select OLD_SIGACTION
 	select GENERIC_VDSO_32
+	select ARCH_SPLIT_ARG64
 
 config X86_64
 	def_bool y
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1285,26 +1285,23 @@ fput_and_out:
 	return ret;
 }
 
+#ifndef CONFIG_ARCH_SPLIT_ARG64
 SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
 			      __u64, mask, int, dfd,
 			      const char  __user *, pathname)
 {
 	return do_fanotify_mark(fanotify_fd, flags, mask, dfd, pathname);
 }
+#endif
 
-#ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE6(fanotify_mark,
+#if defined(CONFIG_ARCH_SPLIT_ARG64) || defined(CONFIG_COMPAT)
+SYSCALL32_DEFINE6(fanotify_mark,
 				int, fanotify_fd, unsigned int, flags,
-				__u32, mask0, __u32, mask1, int, dfd,
+				SC_ARG64(mask), int, dfd,
 				const char  __user *, pathname)
 {
-	return do_fanotify_mark(fanotify_fd, flags,
-#ifdef __BIG_ENDIAN
-				((__u64)mask0 << 32) | mask1,
-#else
-				((__u64)mask1 << 32) | mask0,
-#endif
-				 dfd, pathname);
+	return do_fanotify_mark(fanotify_fd, flags, SC_VAL64(__u64, mask),
+				dfd, pathname);
 }
 #endif
 
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -251,6 +251,30 @@ static inline int is_syscall_trace_event
 	static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 #endif /* __SYSCALL_DEFINEx */
 
+/* For split 64-bit arguments on 32-bit architectures */
+#ifdef __LITTLE_ENDIAN
+#define SC_ARG64(name) u32, name##_lo, u32, name##_hi
+#else
+#define SC_ARG64(name) u32, name##_hi, u32, name##_lo
+#endif
+#define SC_VAL64(type, name) ((type) name##_hi << 32 | name##_lo)
+
+#ifdef CONFIG_COMPAT
+#define SYSCALL32_DEFINE1 COMPAT_SYSCALL_DEFINE1
+#define SYSCALL32_DEFINE2 COMPAT_SYSCALL_DEFINE2
+#define SYSCALL32_DEFINE3 COMPAT_SYSCALL_DEFINE3
+#define SYSCALL32_DEFINE4 COMPAT_SYSCALL_DEFINE4
+#define SYSCALL32_DEFINE5 COMPAT_SYSCALL_DEFINE5
+#define SYSCALL32_DEFINE6 COMPAT_SYSCALL_DEFINE6
+#else
+#define SYSCALL32_DEFINE1 SYSCALL_DEFINE1
+#define SYSCALL32_DEFINE2 SYSCALL_DEFINE2
+#define SYSCALL32_DEFINE3 SYSCALL_DEFINE3
+#define SYSCALL32_DEFINE4 SYSCALL_DEFINE4
+#define SYSCALL32_DEFINE5 SYSCALL_DEFINE5
+#define SYSCALL32_DEFINE6 SYSCALL_DEFINE6
+#endif
+
 /*
  * Called before coming back to user-mode. Returning to user-mode with an
  * address limit different than USER_DS can allow to overwrite kernel memory.


