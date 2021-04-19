Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE00136433A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbhDSNPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240408AbhDSNOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33B9A613C6;
        Mon, 19 Apr 2021 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837953;
        bh=XSByVW6EpXQRDvdD4lKuUX5can3tiot14ZTS7RWWRU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWNmaqgnRWLGl3EDS8FI5sVETtIJYqfYPKe6Tm1O01FutDnw/8edp67XcqN3l9EAC
         C3rZ5efrlrEYZzQ3n+p/mI6IyEGZ905bRcDz/+/tkybEDByPoxKUFEve3cfXGqX7h8
         g+Opzb6f8wRWR7ID+AkA1l2cmi9q+8pUuCELxXQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Wu <walter-zh.wu@mediatek.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 114/122] kasan: remove redundant config option
Date:   Mon, 19 Apr 2021 15:06:34 +0200
Message-Id: <20210419130534.044357764@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Walter Wu <walter-zh.wu@mediatek.com>

[ Upstream commit 02c587733c8161355a43e6e110c2e29bd0acff72 ]

CONFIG_KASAN_STACK and CONFIG_KASAN_STACK_ENABLE both enable KASAN stack
instrumentation, but we should only need one config, so that we remove
CONFIG_KASAN_STACK_ENABLE and make CONFIG_KASAN_STACK workable.  see [1].

When enable KASAN stack instrumentation, then for gcc we could do no
prompt and default value y, and for clang prompt and default value n.

This patch fixes the following compilation warning:

  include/linux/kasan.h:333:30: warning: 'CONFIG_KASAN_STACK' is not defined, evaluates to 0 [-Wundef]

[akpm@linux-foundation.org: fix merge snafu]

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210221 [1]
Link: https://lkml.kernel.org/r/20210226012531.29231-1-walter-zh.wu@mediatek.com
Fixes: d9b571c885a8 ("kasan: fix KASAN_STACK dependency for HW_TAGS")
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/sleep.S        |  2 +-
 arch/x86/kernel/acpi/wakeup_64.S |  2 +-
 include/linux/kasan.h            |  2 +-
 lib/Kconfig.kasan                |  9 ++-------
 mm/kasan/common.c                |  2 +-
 mm/kasan/kasan.h                 |  2 +-
 mm/kasan/report_generic.c        |  2 +-
 scripts/Makefile.kasan           | 10 ++++++++--
 security/Kconfig.hardening       |  4 ++--
 9 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index 6bdef7362c0e..7c44ede122a9 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -133,7 +133,7 @@ SYM_FUNC_START(_cpu_resume)
 	 */
 	bl	cpu_do_resume
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 	mov	x0, sp
 	bl	kasan_unpoison_task_stack_below
 #endif
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 5d3a0b8fd379..c7f412f4e07d 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -112,7 +112,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	movq	pt_regs_r14(%rax), %r14
 	movq	pt_regs_r15(%rax), %r15
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 	/*
 	 * The suspend path may have poisoned some areas deeper in the stack,
 	 * which we now need to unpoison.
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 0aea9e2a2a01..f2980f010a48 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -306,7 +306,7 @@ static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
 
 #endif /* CONFIG_KASAN */
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 void kasan_unpoison_task_stack(struct task_struct *task);
 #else
 static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 0d3b7940cf43..fde82ec85f8f 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -138,9 +138,10 @@ config KASAN_INLINE
 
 endchoice
 
-config KASAN_STACK_ENABLE
+config KASAN_STACK
 	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
+	default y if CC_IS_GCC
 	help
 	  The LLVM stack address sanitizer has a know problem that
 	  causes excessive stack usage in a lot of functions, see
@@ -154,12 +155,6 @@ config KASAN_STACK_ENABLE
 	  CONFIG_COMPILE_TEST.	On gcc it is assumed to always be safe
 	  to use and enabled by default.
 
-config KASAN_STACK
-	int
-	depends on KASAN_GENERIC || KASAN_SW_TAGS
-	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
-	default 0
-
 config KASAN_SW_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
 	depends on KASAN_SW_TAGS
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b25167664ead..38ceb759f853 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -63,7 +63,7 @@ void __kasan_unpoison_range(const void *address, size_t size)
 	unpoison_range(address, size);
 }
 
-#if CONFIG_KASAN_STACK
+#ifdef CONFIG_KASAN_STACK
 /* Unpoison the entire stack for a task. */
 void kasan_unpoison_task_stack(struct task_struct *task)
 {
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 8c706e7652f2..daa06aa5ea19 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -224,7 +224,7 @@ void *find_first_bad_addr(void *addr, size_t size);
 const char *get_bug_type(struct kasan_access_info *info);
 void metadata_fetch_row(char *buffer, void *row);
 
-#if defined(CONFIG_KASAN_GENERIC) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN_GENERIC) && defined(CONFIG_KASAN_STACK)
 void print_address_stack_frame(const void *addr);
 #else
 static inline void print_address_stack_frame(const void *addr) { }
diff --git a/mm/kasan/report_generic.c b/mm/kasan/report_generic.c
index 8a9c889872da..4e16518d9877 100644
--- a/mm/kasan/report_generic.c
+++ b/mm/kasan/report_generic.c
@@ -128,7 +128,7 @@ void metadata_fetch_row(char *buffer, void *row)
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
 
-#if CONFIG_KASAN_STACK
+#ifdef CONFIG_KASAN_STACK
 static bool __must_check tokenize_frame_descr(const char **frame_descr,
 					      char *token, size_t max_tok_len,
 					      unsigned long *value)
diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 127012f45166..3d791908ed36 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -4,6 +4,12 @@ KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
 cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
 
+ifdef CONFIG_KASAN_STACK
+	stack_enable := 1
+else
+	stack_enable := 0
+endif
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -27,7 +33,7 @@ else
 	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
 	 $(call cc-param,asan-globals=1) \
 	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-stack=$(CONFIG_KASAN_STACK)) \
+	 $(call cc-param,asan-stack=$(stack_enable)) \
 	 $(call cc-param,asan-instrument-allocas=1)
 endif
 
@@ -42,7 +48,7 @@ else
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		$(call cc-param,hwasan-instrument-stack=$(CONFIG_KASAN_STACK)) \
+		$(call cc-param,hwasan-instrument-stack=$(stack_enable)) \
 		$(call cc-param,hwasan-use-short-granules=0) \
 		$(instrumentation_flags)
 
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 269967c4fc1b..a56c36470cb1 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -64,7 +64,7 @@ choice
 	config GCC_PLUGIN_STRUCTLEAK_BYREF
 		bool "zero-init structs passed by reference (strong)"
 		depends on GCC_PLUGINS
-		depends on !(KASAN && KASAN_STACK=1)
+		depends on !(KASAN && KASAN_STACK)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any structures on the stack that may
@@ -82,7 +82,7 @@ choice
 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
 		bool "zero-init anything passed by reference (very strong)"
 		depends on GCC_PLUGINS
-		depends on !(KASAN && KASAN_STACK=1)
+		depends on !(KASAN && KASAN_STACK)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any stack variables that may be passed
-- 
2.30.2



