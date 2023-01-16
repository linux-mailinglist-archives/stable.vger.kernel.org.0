Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2804266C93E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjAPQrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbjAPQqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4F29E22
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB5F16105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01E0C433EF;
        Mon, 16 Jan 2023 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886878;
        bh=Dj/+s6ligdfUQajquPqFO7mdQQkPYF/YSpwZ/V16bn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKx++VcC4Y4ehCy/Zw73XrpoM6rlTpVvRmJsJc8QS0346KGzsQ3xp5ysI6NP3CVir
         JsvS8miCzUynWiEdH/A5bxBfY3KkwiazgUVtBOp9Bj13z6LlZCB8Qz5Bu6SW2SCUb+
         Kr1YISSlPuHWr2dI6hOMGnECNouoYi70cPqHEwGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 596/658] parisc: Align parisc MADV_XXX constants with all other architectures
Date:   Mon, 16 Jan 2023 16:51:24 +0100
Message-Id: <20230116154936.739592195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 71bdea6f798b425bc0003780b13e3fdecb16a010 upstream.

Adjust some MADV_XXX constants to be in sync what their values are on
all other platforms. There is currently no reason to have an own
numbering on parisc, but it requires workarounds in many userspace
sources (e.g. glibc, qemu, ...) - which are often forgotten and thus
introduce bugs and different behaviour on parisc.

A wrapper avoids an ABI breakage for existing userspace applications by
translating any old values to the new ones, so this change allows us to
move over all programs to the new ABI over time.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

---
 arch/parisc/include/uapi/asm/mman.h       |   23 +++++++++++------------
 arch/parisc/kernel/sys_parisc.c           |   27 +++++++++++++++++++++++++++
 arch/parisc/kernel/syscalls/syscall.tbl   |    2 +-
 tools/arch/parisc/include/uapi/asm/mman.h |   12 ++++++------
 tools/perf/bench/bench.h                  |   12 ------------
 5 files changed, 45 insertions(+), 31 deletions(-)

--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -48,28 +48,27 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
 
-#define MADV_COLD	20		/* deactivate these pages */
-#define MADV_PAGEOUT	21		/* reclaim these pages */
-
-#define MADV_MERGEABLE   65		/* KSM may merge identical pages */
-#define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
-#define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
-#define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE 15		/* Not worth backing with hugepages */
 
-#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
 					   overrides the coredump filter bits */
-#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
-#define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
-#define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
+#define MADV_COLD	20		/* deactivate these pages */
+#define MADV_PAGEOUT	21		/* reclaim these pages */
 
 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
 
 /* compatibility flags */
 #define MAP_FILE	0
-#define MAP_VARIABLE	0
 
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -373,3 +373,30 @@ long parisc_personality(unsigned long pe
 
 	return err;
 }
+
+/*
+ * madvise() wrapper
+ *
+ * Up to kernel v6.1 parisc has different values than all other
+ * platforms for the MADV_xxx flags listed below.
+ * To keep binary compatibility with existing userspace programs
+ * translate the former values to the new values.
+ *
+ * XXX: Remove this wrapper in year 2025 (or later)
+ */
+
+asmlinkage notrace long parisc_madvise(unsigned long start, size_t len_in, int behavior)
+{
+	switch (behavior) {
+	case 65: behavior = MADV_MERGEABLE;	break;
+	case 66: behavior = MADV_UNMERGEABLE;	break;
+	case 67: behavior = MADV_HUGEPAGE;	break;
+	case 68: behavior = MADV_NOHUGEPAGE;	break;
+	case 69: behavior = MADV_DONTDUMP;	break;
+	case 70: behavior = MADV_DODUMP;	break;
+	case 71: behavior = MADV_WIPEONFORK;	break;
+	case 72: behavior = MADV_KEEPONFORK;	break;
+	}
+
+	return sys_madvise(start, len_in, behavior);
+}
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -131,7 +131,7 @@
 116	common	sysinfo			sys_sysinfo			compat_sys_sysinfo
 117	common	shutdown		sys_shutdown
 118	common	fsync			sys_fsync
-119	common	madvise			sys_madvise
+119	common	madvise			parisc_madvise
 120	common	clone			sys_clone_wrapper
 121	common	setdomainname		sys_setdomainname
 122	common	sendfile		sys_sendfile			compat_sys_sendfile
--- a/tools/arch/parisc/include/uapi/asm/mman.h
+++ b/tools/arch/parisc/include/uapi/asm/mman.h
@@ -1,20 +1,20 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef TOOLS_ARCH_PARISC_UAPI_ASM_MMAN_FIX_H
 #define TOOLS_ARCH_PARISC_UAPI_ASM_MMAN_FIX_H
-#define MADV_DODUMP	70
+#define MADV_DODUMP	17
 #define MADV_DOFORK	11
-#define MADV_DONTDUMP   69
+#define MADV_DONTDUMP   16
 #define MADV_DONTFORK	10
 #define MADV_DONTNEED   4
 #define MADV_FREE	8
-#define MADV_HUGEPAGE	67
-#define MADV_MERGEABLE   65
-#define MADV_NOHUGEPAGE	68
+#define MADV_HUGEPAGE	14
+#define MADV_MERGEABLE  12
+#define MADV_NOHUGEPAGE 15
 #define MADV_NORMAL     0
 #define MADV_RANDOM     1
 #define MADV_REMOVE	9
 #define MADV_SEQUENTIAL 2
-#define MADV_UNMERGEABLE 66
+#define MADV_UNMERGEABLE 13
 #define MADV_WILLNEED   3
 #define MAP_ANONYMOUS	0x10
 #define MAP_DENYWRITE	0x0800
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -10,25 +10,13 @@ extern struct timeval bench__start, benc
  * The madvise transparent hugepage constants were added in glibc
  * 2.13. For compatibility with older versions of glibc, define these
  * tokens if they are not already defined.
- *
- * PA-RISC uses different madvise values from other architectures and
- * needs to be special-cased.
  */
-#ifdef __hppa__
-# ifndef MADV_HUGEPAGE
-#  define MADV_HUGEPAGE		67
-# endif
-# ifndef MADV_NOHUGEPAGE
-#  define MADV_NOHUGEPAGE	68
-# endif
-#else
 # ifndef MADV_HUGEPAGE
 #  define MADV_HUGEPAGE		14
 # endif
 # ifndef MADV_NOHUGEPAGE
 #  define MADV_NOHUGEPAGE	15
 # endif
-#endif
 
 int bench_numa(int argc, const char **argv);
 int bench_sched_messaging(int argc, const char **argv);


