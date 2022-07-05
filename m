Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27D566CF0
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiGEMUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiGEMR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B98193D7;
        Tue,  5 Jul 2022 05:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DBD619A6;
        Tue,  5 Jul 2022 12:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C12C341C7;
        Tue,  5 Jul 2022 12:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023186;
        bh=G9rKul6QLomKJrTc71bzE9xvfktuMjJvjc1FJYL1LoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQZVIEgVOprzPP2f0VNGBq+jEkwyJ05lKn7CcFWQAhqXEUc9Bp2Qly+3j9U4z1ZKp
         4gCSy/cDRyuJCA6h0lbkuf5VTZZQ1A0NhEU9/5ubujmI3G1am4c7PSu8ZoCwIrz70z
         yRe0b4c9oSuyuwtXdmh1v99ve5PShotRaPCSyc9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 67/98] selftests/rseq: Introduce thread pointer getters
Date:   Tue,  5 Jul 2022 13:58:25 +0200
Message-Id: <20220705115619.480288100@linuxfoundation.org>
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

commit 886ddfba933f5ce9d76c278165d834d114ba4ffc upstream.

This is done in preparation for the selftest uplift to become compatible
with glibc-2.35.

glibc-2.35 exposes the rseq per-thread data in the TCB, accessible
at an offset from the thread pointer.

The toolchains do not implement accessing the thread pointer on all
architectures. Provide thread pointer getters for ppc and x86 which
lack (or lacked until recently) toolchain support.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-7-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-generic-thread-pointer.h |   25 ++++++++
 tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h     |   30 +++++++++
 tools/testing/selftests/rseq/rseq-thread-pointer.h         |   19 ++++++
 tools/testing/selftests/rseq/rseq-x86-thread-pointer.h     |   40 +++++++++++++
 4 files changed, 114 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/rseq-generic-thread-pointer.h
 create mode 100644 tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h
 create mode 100644 tools/testing/selftests/rseq/rseq-thread-pointer.h
 create mode 100644 tools/testing/selftests/rseq/rseq-x86-thread-pointer.h

--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-generic-thread-pointer.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-generic-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_GENERIC_THREAD_POINTER
+#define _RSEQ_GENERIC_THREAD_POINTER
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* Use gcc builtin thread pointer. */
+static inline void *rseq_thread_pointer(void)
+{
+	return __builtin_thread_pointer();
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-ppc-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_PPC_THREAD_POINTER
+#define _RSEQ_PPC_THREAD_POINTER
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+static inline void *rseq_thread_pointer(void)
+{
+#ifdef __powerpc64__
+	register void *__result asm ("r13");
+#else
+	register void *__result asm ("r2");
+#endif
+	asm ("" : "=r" (__result));
+	return __result;
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-thread-pointer.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_THREAD_POINTER
+#define _RSEQ_THREAD_POINTER
+
+#if defined(__x86_64__) || defined(__i386__)
+#include "rseq-x86-thread-pointer.h"
+#elif defined(__PPC__)
+#include "rseq-ppc-thread-pointer.h"
+#else
+#include "rseq-generic-thread-pointer.h"
+#endif
+
+#endif
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-x86-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_X86_THREAD_POINTER
+#define _RSEQ_X86_THREAD_POINTER
+
+#include <features.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#if __GNUC_PREREQ (11, 1)
+static inline void *rseq_thread_pointer(void)
+{
+	return __builtin_thread_pointer();
+}
+#else
+static inline void *rseq_thread_pointer(void)
+{
+	void *__result;
+
+# ifdef __x86_64__
+	__asm__ ("mov %%fs:0, %0" : "=r" (__result));
+# else
+	__asm__ ("mov %%gs:0, %0" : "=r" (__result));
+# endif
+	return __result;
+}
+#endif /* !GCC 11 */
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif


