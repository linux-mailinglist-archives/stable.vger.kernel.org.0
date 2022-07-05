Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901D4566D50
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiGEMWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbiGEMSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DEA193E2;
        Tue,  5 Jul 2022 05:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4DCAB817AC;
        Tue,  5 Jul 2022 12:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B0EC341C7;
        Tue,  5 Jul 2022 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023189;
        bh=/tWmGCqwNuBv2ZFBAZMFfrnGTqFYVqZFwG8JGBoUnSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIJSAHPtQpXAA26mclS/NCqXVz5DBJdVmzympf5CE0sTwjePF4O9pDRp6CXJL0B96
         Uy1LL1nPgDWk60jsP/G3Gf47NGOPkF1f0gD9Z7hVOINlWCR2MwlymdhctPTI5g0ZOF
         67RrIsSq6WjmoQW3hMWqQo5L/EW7+GvnENjJBpFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 68/98] selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35
Date:   Tue,  5 Jul 2022 13:58:26 +0200
Message-Id: <20220705115619.507941499@linuxfoundation.org>
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

commit 233e667e1ae3e348686bd9dd0172e62a09d852e1 upstream.

glibc-2.35 (upcoming release date 2022-02-01) exposes the rseq per-thread
data in the TCB, accessible at an offset from the thread pointer, rather
than through an actual Thread-Local Storage (TLS) variable, as the
Linux kernel selftests initially expected.

The __rseq_abi TLS and glibc-2.35's ABI for per-thread data cannot
actively coexist in a process, because the kernel supports only a single
rseq registration per thread.

Here is the scheme introduced to ensure selftests can work both with an
older glibc and with glibc-2.35+:

- librseq exposes its own "rseq_offset, rseq_size, rseq_flags" ABI.

- librseq queries for glibc rseq ABI (__rseq_offset, __rseq_size,
  __rseq_flags) using dlsym() in a librseq library constructor. If those
  are found, copy their values into rseq_offset, rseq_size, and
  rseq_flags.

- Else, if those glibc symbols are not found, handle rseq registration
  from librseq and use its own IE-model TLS to implement the rseq ABI
  per-thread storage.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-8-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/Makefile |    2 
 tools/testing/selftests/rseq/rseq.c   |  161 ++++++++++++++++------------------
 tools/testing/selftests/rseq/rseq.h   |   13 ++
 3 files changed, 88 insertions(+), 88 deletions(-)

--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -6,7 +6,7 @@ endif
 
 CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L$(OUTPUT) -Wl,-rpath=./ \
 	  $(CLANG_FLAGS)
-LDLIBS += -lpthread
+LDLIBS += -lpthread -ldl
 
 # Own dependencies because we only want to build against 1st prerequisite, but
 # still track changes to header files and depend on shared object.
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -26,103 +26,113 @@
 #include <assert.h>
 #include <signal.h>
 #include <limits.h>
+#include <dlfcn.h>
 
 #include "../kselftest.h"
 #include "rseq.h"
 
-__thread struct rseq_abi __rseq_abi = {
-	.cpu_id = RSEQ_ABI_CPU_ID_UNINITIALIZED,
-};
+static const int *libc_rseq_offset_p;
+static const unsigned int *libc_rseq_size_p;
+static const unsigned int *libc_rseq_flags_p;
+
+/* Offset from the thread pointer to the rseq area.  */
+int rseq_offset;
+
+/* Size of the registered rseq area.  0 if the registration was
+   unsuccessful.  */
+unsigned int rseq_size = -1U;
 
-/*
- * Shared with other libraries. This library may take rseq ownership if it is
- * still 0 when executing the library constructor. Set to 1 by library
- * constructor when handling rseq. Set to 0 in destructor if handling rseq.
- */
-int __rseq_handled;
+/* Flags used during rseq registration.  */
+unsigned int rseq_flags;
 
-/* Whether this library have ownership of rseq registration. */
 static int rseq_ownership;
 
-static __thread volatile uint32_t __rseq_refcount;
+static
+__thread struct rseq_abi __rseq_abi __attribute__((tls_model("initial-exec"))) = {
+	.cpu_id = RSEQ_ABI_CPU_ID_UNINITIALIZED,
+};
 
-static void signal_off_save(sigset_t *oldset)
+static int sys_rseq(struct rseq_abi *rseq_abi, uint32_t rseq_len,
+		    int flags, uint32_t sig)
 {
-	sigset_t set;
-	int ret;
-
-	sigfillset(&set);
-	ret = pthread_sigmask(SIG_BLOCK, &set, oldset);
-	if (ret)
-		abort();
+	return syscall(__NR_rseq, rseq_abi, rseq_len, flags, sig);
 }
 
-static void signal_restore(sigset_t oldset)
+int rseq_available(void)
 {
-	int ret;
+	int rc;
 
-	ret = pthread_sigmask(SIG_SETMASK, &oldset, NULL);
-	if (ret)
+	rc = sys_rseq(NULL, 0, 0, 0);
+	if (rc != -1)
 		abort();
-}
-
-static int sys_rseq(volatile struct rseq_abi *rseq_abi, uint32_t rseq_len,
-		    int flags, uint32_t sig)
-{
-	return syscall(__NR_rseq, rseq_abi, rseq_len, flags, sig);
+	switch (errno) {
+	case ENOSYS:
+		return 0;
+	case EINVAL:
+		return 1;
+	default:
+		abort();
+	}
 }
 
 int rseq_register_current_thread(void)
 {
-	int rc, ret = 0;
-	sigset_t oldset;
+	int rc;
 
-	if (!rseq_ownership)
+	if (!rseq_ownership) {
+		/* Treat libc's ownership as a successful registration. */
 		return 0;
-	signal_off_save(&oldset);
-	if (__rseq_refcount == UINT_MAX) {
-		ret = -1;
-		goto end;
 	}
-	if (__rseq_refcount++)
-		goto end;
 	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi), 0, RSEQ_SIG);
-	if (!rc) {
-		assert(rseq_current_cpu_raw() >= 0);
-		goto end;
-	}
-	if (errno != EBUSY)
-		RSEQ_WRITE_ONCE(__rseq_abi.cpu_id, RSEQ_ABI_CPU_ID_REGISTRATION_FAILED);
-	ret = -1;
-	__rseq_refcount--;
-end:
-	signal_restore(oldset);
-	return ret;
+	if (rc)
+		return -1;
+	assert(rseq_current_cpu_raw() >= 0);
+	return 0;
 }
 
 int rseq_unregister_current_thread(void)
 {
-	int rc, ret = 0;
-	sigset_t oldset;
+	int rc;
 
-	if (!rseq_ownership)
+	if (!rseq_ownership) {
+		/* Treat libc's ownership as a successful unregistration. */
 		return 0;
-	signal_off_save(&oldset);
-	if (!__rseq_refcount) {
-		ret = -1;
-		goto end;
 	}
-	if (--__rseq_refcount)
-		goto end;
-	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi),
-		      RSEQ_ABI_FLAG_UNREGISTER, RSEQ_SIG);
-	if (!rc)
-		goto end;
-	__rseq_refcount = 1;
-	ret = -1;
-end:
-	signal_restore(oldset);
-	return ret;
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi), RSEQ_ABI_FLAG_UNREGISTER, RSEQ_SIG);
+	if (rc)
+		return -1;
+	return 0;
+}
+
+static __attribute__((constructor))
+void rseq_init(void)
+{
+	libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
+	libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
+	libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
+	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p) {
+		/* rseq registration owned by glibc */
+		rseq_offset = *libc_rseq_offset_p;
+		rseq_size = *libc_rseq_size_p;
+		rseq_flags = *libc_rseq_flags_p;
+		return;
+	}
+	if (!rseq_available())
+		return;
+	rseq_ownership = 1;
+	rseq_offset = (void *)&__rseq_abi - rseq_thread_pointer();
+	rseq_size = sizeof(struct rseq_abi);
+	rseq_flags = 0;
+}
+
+static __attribute__((destructor))
+void rseq_exit(void)
+{
+	if (!rseq_ownership)
+		return;
+	rseq_offset = 0;
+	rseq_size = -1U;
+	rseq_ownership = 0;
 }
 
 int32_t rseq_fallback_current_cpu(void)
@@ -136,20 +146,3 @@ int32_t rseq_fallback_current_cpu(void)
 	}
 	return cpu;
 }
-
-void __attribute__((constructor)) rseq_init(void)
-{
-	/* Check whether rseq is handled by another library. */
-	if (__rseq_handled)
-		return;
-	__rseq_handled = 1;
-	rseq_ownership = 1;
-}
-
-void __attribute__((destructor)) rseq_fini(void)
-{
-	if (!rseq_ownership)
-		return;
-	__rseq_handled = 0;
-	rseq_ownership = 0;
-}
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -43,12 +43,19 @@
 #define RSEQ_INJECT_FAILED
 #endif
 
-extern __thread struct rseq_abi __rseq_abi;
-extern int __rseq_handled;
+#include "rseq-thread-pointer.h"
+
+/* Offset from the thread pointer to the rseq area.  */
+extern int rseq_offset;
+/* Size of the registered rseq area.  0 if the registration was
+   unsuccessful.  */
+extern unsigned int rseq_size;
+/* Flags used during rseq registration.  */
+extern unsigned int rseq_flags;
 
 static inline struct rseq_abi *rseq_get_abi(void)
 {
-	return &__rseq_abi;
+	return (struct rseq_abi *) ((uintptr_t) rseq_thread_pointer() + rseq_offset);
 }
 
 #define rseq_likely(x)		__builtin_expect(!!(x), 1)


