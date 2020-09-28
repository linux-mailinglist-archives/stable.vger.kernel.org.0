Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADBD27B6E2
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 23:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgI1VOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 17:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1VOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 17:14:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D17BD208FE;
        Mon, 28 Sep 2020 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327686;
        bh=iJkoLdMQHNzhBsSiCB5XQDDr48smcixBRGjIHskcVbQ=;
        h=Date:From:To:Subject:From;
        b=W5P4EYCbK3KjaQ6xZ1Ol9qS9uzXKZIGotcgeWC9JCi+m+AqjOxI9mk6GVQo4WWDQ4
         PiP6s+rcon5lGQgnss3A9o7tIy9Ulrs0qsGhVEYzU+uX+fRwxMWDGmrOuy8MlrwRLq
         QTftThAwKTUz8DyZPMCHRqcpfj8O7T/885KrsgJM=
Date:   Mon, 28 Sep 2020 14:14:45 -0700
From:   akpm@linux-foundation.org
To:     andy.lavr@gmail.com, joe@perches.com, keescook@chromium.org,
        linux@rasmusvillemoes.dk, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, nivedita@alum.mit.edu,
        samitolvanen@google.com, stable@vger.kernel.org
Subject:  [merged] lib-stringc-implement-stpcpy.patch removed from
 -mm tree
Message-ID: <20200928211445.JGYhd51Fi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/string.c: implement stpcpy
has been removed from the -mm tree.  Its filename was
     lib-stringc-implement-stpcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: lib/string.c: implement stpcpy

LLVM implemented a recent "libcall optimization" that lowers calls to
`sprintf(dest, "%s", str)` where the return value is used to `stpcpy(dest,
str) - dest`.  This generally avoids the machinery involved in parsing
format strings.  `stpcpy` is just like `strcpy` except it returns the
pointer to the new tail of `dest`.  This optimization was introduced into
clang-12.

Implement this so that we don't observe linkage failures due to missing
symbol definitions for `stpcpy`.

Similar to last year's fire drill with:
commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")

The kernel is somewhere between a "freestanding" environment (no full
libc) and "hosted" environment (many symbols from libc exist with the same
type, function signature, and semantics).

As H.  Peter Anvin notes, there's not really a great way to inform the
compiler that you're targeting a freestanding environment but would like
to opt-in to some libcall optimizations (see pr/47280 below), rather than
opt-out.

Arvind notes, -fno-builtin-* behaves slightly differently between GCC
and Clang, and Clang is missing many __builtin_* definitions, which I
consider a bug in Clang and am working on fixing.

Masahiro summarizes the subtle distinction between compilers justly:
  To prevent transformation from foo() into bar(), there are two ways in
  Clang to do that; -fno-builtin-foo, and -fno-builtin-bar.  There is
  only one in GCC; -fno-buitin-foo.

(Any difference in that behavior in Clang is likely a bug from a missing
__builtin_* definition.)

Masahiro also notes:
  We want to disable optimization from foo() to bar(),
  but we may still benefit from the optimization from
  foo() into something else. If GCC implements the same transform, we
  would run into a problem because it is not -fno-builtin-bar, but
  -fno-builtin-foo that disables that optimization.

  In this regard, -fno-builtin-foo would be more future-proof than
  -fno-built-bar, but -fno-builtin-foo is still potentially overkill. We
  may want to prevent calls from foo() being optimized into calls to
  bar(), but we still may want other optimization on calls to foo().

It seems that compilers today don't quite provide the fine grain control
over which libcall optimizations pseudo-freestanding environments would
prefer.

Finally, Kees notes that this interface is unsafe, so we should not
encourage its use.  As such, I've removed the declaration from any
header, but it still needs to be exported to avoid linkage errors in
modules.

Link: https://lkml.kernel.org/r/20200914161643.938408-1-ndesaulniers@google.com
Link: https://bugs.llvm.org/show_bug.cgi?id=47162
Link: https://bugs.llvm.org/show_bug.cgi?id=47280
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
Link: https://reviews.llvm.org/D85963
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Suggested-by: Andy Lavr <andy.lavr@gmail.com>
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/lib/string.c~lib-stringc-implement-stpcpy
+++ a/lib/string.c
@@ -272,6 +272,30 @@ ssize_t strscpy_pad(char *dest, const ch
 }
 EXPORT_SYMBOL(strscpy_pad);
 
+/**
+ * stpcpy - copy a string from src to dest returning a pointer to the new end
+ *          of dest, including src's %NUL-terminator. May overrun dest.
+ * @dest: pointer to end of string being copied into. Must be large enough
+ *        to receive copy.
+ * @src: pointer to the beginning of string being copied from. Must not overlap
+ *       dest.
+ *
+ * stpcpy differs from strcpy in a key way: the return value is a pointer
+ * to the new %NUL-terminating character in @dest. (For strcpy, the return
+ * value is a pointer to the start of @dest). This interface is considered
+ * unsafe as it doesn't perform bounds checking of the inputs. As such it's
+ * not recommended for usage. Instead, its definition is provided in case
+ * the compiler lowers other libcalls to stpcpy.
+ */
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src);
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
+{
+	while ((*dest++ = *src++) != '\0')
+		/* nothing */;
+	return --dest;
+}
+EXPORT_SYMBOL(stpcpy);
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
_

Patches currently in -mm which might be from ndesaulniers@google.com are

compiler-clang-add-build-check-for-clang-1001.patch
revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch
revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch
partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch
compiler-gcc-improve-version-error.patch

