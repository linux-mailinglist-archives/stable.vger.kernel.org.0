Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57566566D16
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbiGEMVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiGEMRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDD0193CE;
        Tue,  5 Jul 2022 05:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBC85619A6;
        Tue,  5 Jul 2022 12:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFDCC341C7;
        Tue,  5 Jul 2022 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023175;
        bh=kd6p/UrJ3DHSukQSI++ieBOSln3aoMGyy+6/k6m0eFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DR+LCbugMi5em9PmILj+HvDLnIMRXT/Bz18Nf9nXxYFoWCsiN8ZkBSI+AscNj5zSA
         cdKqUQH58W3dRcupg0l6uYqyAlg5BUjNMryVlU205tNIpPUIE+HKnYl+82f5+PWmTJ
         1Mwq5FsdgVG2hCcCDKB+6fD5926x6VNYdJOV3Dew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 63/98] selftests/rseq: introduce own copy of rseq uapi header
Date:   Tue,  5 Jul 2022 13:58:21 +0200
Message-Id: <20220705115619.369538607@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 5c105d55a9dc9e01535116ccfc26e703168a574f upstream.

The Linux kernel rseq uapi header has a broken layout for the
rseq_cs.ptr field on 32-bit little endian architectures. The entire
rseq_cs.ptr field is planned for removal, leaving only the 64-bit
rseq_cs.ptr64 field available.

Both glibc and librseq use their own copy of the Linux kernel uapi
header, where they introduce proper union fields to access to the 32-bit
low order bits of the rseq_cs pointer on 32-bit architectures.

Introduce a copy of the Linux kernel uapi headers in the Linux kernel
selftests.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-2-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-abi.h |  151 ++++++++++++++++++++++++++++++++
 tools/testing/selftests/rseq/rseq.c     |   14 +-
 tools/testing/selftests/rseq/rseq.h     |   10 --
 3 files changed, 161 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/rseq/rseq-abi.h

--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-abi.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _RSEQ_ABI_H
+#define _RSEQ_ABI_H
+
+/*
+ * rseq-abi.h
+ *
+ * Restartable sequences system call API
+ *
+ * Copyright (c) 2015-2022 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+enum rseq_abi_cpu_id_state {
+	RSEQ_ABI_CPU_ID_UNINITIALIZED			= -1,
+	RSEQ_ABI_CPU_ID_REGISTRATION_FAILED		= -2,
+};
+
+enum rseq_abi_flags {
+	RSEQ_ABI_FLAG_UNREGISTER = (1 << 0),
+};
+
+enum rseq_abi_cs_flags_bit {
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT	= 0,
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT	= 1,
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT	= 2,
+};
+
+enum rseq_abi_cs_flags {
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT	=
+		(1U << RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT),
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL	=
+		(1U << RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT),
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE	=
+		(1U << RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT),
+};
+
+/*
+ * struct rseq_abi_cs is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line. It is usually declared as
+ * link-time constant data.
+ */
+struct rseq_abi_cs {
+	/* Version of this structure. */
+	__u32 version;
+	/* enum rseq_abi_cs_flags */
+	__u32 flags;
+	__u64 start_ip;
+	/* Offset from start_ip. */
+	__u64 post_commit_offset;
+	__u64 abort_ip;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+/*
+ * struct rseq_abi is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line.
+ *
+ * A single struct rseq_abi per thread is allowed.
+ */
+struct rseq_abi {
+	/*
+	 * Restartable sequences cpu_id_start field. Updated by the
+	 * kernel. Read by user-space with single-copy atomicity
+	 * semantics. This field should only be read by the thread which
+	 * registered this data structure. Aligned on 32-bit. Always
+	 * contains a value in the range of possible CPUs, although the
+	 * value may not be the actual current CPU (e.g. if rseq is not
+	 * initialized). This CPU number value should always be compared
+	 * against the value of the cpu_id field before performing a rseq
+	 * commit or returning a value read from a data structure indexed
+	 * using the cpu_id_start value.
+	 */
+	__u32 cpu_id_start;
+	/*
+	 * Restartable sequences cpu_id field. Updated by the kernel.
+	 * Read by user-space with single-copy atomicity semantics. This
+	 * field should only be read by the thread which registered this
+	 * data structure. Aligned on 32-bit. Values
+	 * RSEQ_CPU_ID_UNINITIALIZED and RSEQ_CPU_ID_REGISTRATION_FAILED
+	 * have a special semantic: the former means "rseq uninitialized",
+	 * and latter means "rseq initialization failed". This value is
+	 * meant to be read within rseq critical sections and compared
+	 * with the cpu_id_start value previously read, before performing
+	 * the commit instruction, or read and compared with the
+	 * cpu_id_start value before returning a value loaded from a data
+	 * structure indexed using the cpu_id_start value.
+	 */
+	__u32 cpu_id;
+	/*
+	 * Restartable sequences rseq_cs field.
+	 *
+	 * Contains NULL when no critical section is active for the current
+	 * thread, or holds a pointer to the currently active struct rseq_cs.
+	 *
+	 * Updated by user-space, which sets the address of the currently
+	 * active rseq_cs at the beginning of assembly instruction sequence
+	 * block, and set to NULL by the kernel when it restarts an assembly
+	 * instruction sequence block, as well as when the kernel detects that
+	 * it is preempting or delivering a signal outside of the range
+	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
+	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 *
+	 * Read and set by the kernel. Set by user-space with single-copy
+	 * atomicity semantics. This field should only be updated by the
+	 * thread which registered this data structure. Aligned on 64-bit.
+	 */
+	union {
+		__u64 ptr64;
+
+		/*
+		 * The "arch" field provides architecture accessor for
+		 * the ptr field based on architecture pointer size and
+		 * endianness.
+		 */
+		struct {
+#ifdef __LP64__
+			__u64 ptr;
+#elif defined(__BYTE_ORDER) ? (__BYTE_ORDER == __BIG_ENDIAN) : defined(__BIG_ENDIAN)
+			__u32 padding;		/* Initialized to zero. */
+			__u32 ptr;
+#else
+			__u32 ptr;
+			__u32 padding;		/* Initialized to zero. */
+#endif
+		} arch;
+	} rseq_cs;
+
+	/*
+	 * Restartable sequences flags field.
+	 *
+	 * This field should only be updated by the thread which
+	 * registered this data structure. Read by the kernel.
+	 * Mainly used for single-stepping through rseq critical sections
+	 * with debuggers.
+	 *
+	 * - RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT
+	 *     Inhibit instruction sequence block restart on preemption
+	 *     for this thread.
+	 * - RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL
+	 *     Inhibit instruction sequence block restart on signal
+	 *     delivery for this thread.
+	 * - RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE
+	 *     Inhibit instruction sequence block restart on migration for
+	 *     this thread.
+	 */
+	__u32 flags;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+#endif /* _RSEQ_ABI_H */
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -30,8 +30,8 @@
 #include "../kselftest.h"
 #include "rseq.h"
 
-__thread volatile struct rseq __rseq_abi = {
-	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
+__thread volatile struct rseq_abi __rseq_abi = {
+	.cpu_id = RSEQ_ABI_CPU_ID_UNINITIALIZED,
 };
 
 /*
@@ -66,7 +66,7 @@ static void signal_restore(sigset_t olds
 		abort();
 }
 
-static int sys_rseq(volatile struct rseq *rseq_abi, uint32_t rseq_len,
+static int sys_rseq(volatile struct rseq_abi *rseq_abi, uint32_t rseq_len,
 		    int flags, uint32_t sig)
 {
 	return syscall(__NR_rseq, rseq_abi, rseq_len, flags, sig);
@@ -86,13 +86,13 @@ int rseq_register_current_thread(void)
 	}
 	if (__rseq_refcount++)
 		goto end;
-	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq), 0, RSEQ_SIG);
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi), 0, RSEQ_SIG);
 	if (!rc) {
 		assert(rseq_current_cpu_raw() >= 0);
 		goto end;
 	}
 	if (errno != EBUSY)
-		__rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
+		__rseq_abi.cpu_id = RSEQ_ABI_CPU_ID_REGISTRATION_FAILED;
 	ret = -1;
 	__rseq_refcount--;
 end:
@@ -114,8 +114,8 @@ int rseq_unregister_current_thread(void)
 	}
 	if (--__rseq_refcount)
 		goto end;
-	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq),
-		      RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi),
+		      RSEQ_ABI_FLAG_UNREGISTER, RSEQ_SIG);
 	if (!rc)
 		goto end;
 	__rseq_refcount = 1;
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -16,7 +16,7 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <linux/rseq.h>
+#include "rseq-abi.h"
 
 /*
  * Empty code injection macros, override when testing.
@@ -43,7 +43,7 @@
 #define RSEQ_INJECT_FAILED
 #endif
 
-extern __thread volatile struct rseq __rseq_abi;
+extern __thread volatile struct rseq_abi __rseq_abi;
 extern int __rseq_handled;
 
 #define rseq_likely(x)		__builtin_expect(!!(x), 1)
@@ -139,11 +139,7 @@ static inline uint32_t rseq_current_cpu(
 
 static inline void rseq_clear_rseq_cs(void)
 {
-#ifdef __LP64__
-	__rseq_abi.rseq_cs.ptr = 0;
-#else
-	__rseq_abi.rseq_cs.ptr.ptr32 = 0;
-#endif
+	__rseq_abi.rseq_cs.arch.ptr = 0;
 }
 
 /*


