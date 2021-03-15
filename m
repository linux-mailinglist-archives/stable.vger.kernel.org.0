Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA61233C4E2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhCOR4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236502AbhCORsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68EA64F38;
        Mon, 15 Mar 2021 17:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830499;
        bh=La0k6mXiBq4v1eGGNkR102cawZAbudeEJTNqKuXcXSU=;
        h=Date:From:To:Subject:From;
        b=UZyiCcqMuplsqIOPtlKxGAEYqtE3WoLkaQcY2rMgzyKcK9MNkNsnO/5+MTbUMi8nz
         bnuB8RwbeBoUcAAZDEcBsCqJvwVTHNUNJmr6wub9yhhjb38AdWPIrk1FIELkag2rzf
         /C+SG3MvyqLT8mWRIfMlDUQQgKmn8+1AEBVuoTRA=
Date:   Mon, 15 Mar 2021 10:48:18 -0700
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, arnd@arndb.de, deanbo422@gmail.com,
        elver@google.com, green.hu@gmail.com, guoren@kernel.org,
        keescook@chromium.org, luc.vanoostenryck@gmail.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nickhu@andestech.com,
        nivedita@alum.mit.edu, ojeda@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, rdunlap@infradead.org,
        samitolvanen@google.com, stable@vger.kernel.org
Subject:  [merged]
 linux-compiler-clangh-define-have_builtin_bswap.patch removed from -mm tree
Message-ID: <20210315174818.oB6_t9ZNg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*
has been removed from the -mm tree.  Its filename was
     linux-compiler-clangh-define-have_builtin_bswap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Separating compiler-clang.h from compiler-gcc.h inadventently dropped the
definitions of the three HAVE_BUILTIN_BSWAP macros, which requires falling
back to the open-coded version and hoping that the compiler detects it.

Since all versions of clang support the __builtin_bswap interfaces, add
back the flags and have the headers pick these up automatically.

This results in a 4% improvement of compilation speed for arm defconfig.

Note: it might also be worth revisiting which architectures set
CONFIG_ARCH_USE_BUILTIN_BSWAP for one compiler or the other, today this is
set on six architectures (arm32, csky, mips, powerpc, s390, x86), while
another ten architectures define custom helpers (alpha, arc, ia64, m68k,
mips, nios2, parisc, sh, sparc, xtensa), and the rest (arm64, h8300,
hexagon, microblaze, nds32, openrisc, riscv) just get the unoptimized
version and rely on the compiler to detect it.

A long time ago, the compiler builtins were architecture specific, but
nowadays, all compilers that are able to build the kernel have correct
implementations of them, though some may not be as optimized as the inline
asm versions.

The patch that dropped the optimization landed in v4.19, so as discussed
it would be fairly safe to backport this revert to stable kernels to the
4.19/5.4/5.10 stable kernels, but there is a remaining risk for
regressions, and it has no known side-effects besides compile speed.

Link: https://lkml.kernel.org/r/20210226161151.2629097-1-arnd@kernel.org
Link: https://lore.kernel.org/lkml/20210225164513.3667778-1-arnd@kernel.org/
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Guo Ren <guoren@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/compiler-clang.h~linux-compiler-clangh-define-have_builtin_bswap
+++ a/include/linux/compiler-clang.h
@@ -31,6 +31,12 @@
 #define __no_sanitize_thread
 #endif
 
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
 #if __has_feature(undefined_behavior_sanitizer)
 /* GCC does not have __SANITIZE_UNDEFINED__ */
 #define __no_sanitize_undefined \
_

Patches currently in -mm which might be from arnd@arndb.de are


