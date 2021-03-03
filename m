Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5136532BC06
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359129AbhCCNhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhCCBYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 20:24:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92E1264FA9;
        Wed,  3 Mar 2021 01:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614734620;
        bh=ZzVqlJ0dzPhnPMDb4M5LM35tPS9vSUjk5MKOkXPz4y0=;
        h=Date:From:To:Subject:From;
        b=CCeWc5qSkh7Rho6hHjUY8K9LYxj4vODVJiN2ySKxuo6Qo1jVatnaE/C0sPjWuhPJG
         UkgfywADeUUGScTGS9Jt9S/Pkn/qd8OtVVEkwHF+1/qDigMcDvqpKBBUW84FVdYw8S
         JfOpHPmSFCmTM/9nJyTSlVcgVB1Pn3GhFMJpKtUI=
Date:   Tue, 02 Mar 2021 17:23:38 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, elver@google.com, keescook@chromium.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nivedita@alum.mit.edu,
        ojeda@kernel.org, rdunlap@infradead.org, samitolvanen@google.com,
        stable@vger.kernel.org
Subject:  [to-be-updated]
 linux-compiler-clangh-define-have_builtin_bswap.patch removed from -mm tree
Message-ID: <20210303012338.CEzHUdBK8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*
has been removed from the -mm tree.  Its filename was
     linux-compiler-clangh-define-have_builtin_bswap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Separating compiler-clang.h from compiler-gcc.h inadventently dropped the
definitions of the three HAVE_BUILTIN_BSWAP macros, which requires falling
back to the open-coded version and hoping that the compiler detects it.

Since all versions of clang support the __builtin_bswap interfaces, add
back the flags and have the headers pick these up automatically.

This results in a 4% improvement of compilation speed for arm defconfig.

Link: https://lkml.kernel.org/r/20210225164513.3667778-1-arnd@kernel.org
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/compiler-clang.h~linux-compiler-clangh-define-have_builtin_bswap
+++ a/include/linux/compiler-clang.h
@@ -31,6 +31,16 @@
 #define __no_sanitize_thread
 #endif
 
+/*
+ * sparse (__CHECKER__) pretends to be gcc, but can't do constant
+ * folding in __builtin_bswap*() (yet), so don't set these for it.
+ */
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP) && !defined(__CHECKER__)
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP && !__CHECKER__ */
+
 #if __has_feature(undefined_behavior_sanitizer)
 /* GCC does not have __SANITIZE_UNDEFINED__ */
 #define __no_sanitize_undefined \
_

Patches currently in -mm which might be from arnd@arndb.de are

memblock-fix-section-mismatch-warning.patch
stop_machine-mark-helpers-__always_inline.patch

