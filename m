Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4EF252485
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 01:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgHYX7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 19:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgHYX7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 19:59:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E1C20738;
        Tue, 25 Aug 2020 23:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598399939;
        bh=qsxkhEf3iT0kNTicH+fRO9AEdXpqxGWrrtqYULHftDY=;
        h=Date:From:To:Subject:From;
        b=RLTshv1sR+6MTmNksD7fWCtk/aHPHl0NehvETxiZfKD+b6VhW3GSA2FJJU8Syixon
         ilqA/n43mNGrZqegX4GMcCVWSpjyEqNvXqdltEBWBxn7/zIXxFjzEb3U28+qidSNhf
         4DcG+ZOVq4EI6mG8qAw0L06cRwYzC0tyY3MFjtJY=
Date:   Tue, 25 Aug 2020 16:58:58 -0700
From:   akpm@linux-foundation.org
To:     alexandru.ardelean@analog.com, andriy.shevchenko@linux.intel.com,
        andy.lavr@gmail.com, joe@perches.com, keescook@chromium.org,
        linux@rasmusvillemoes.dk, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, nivedita@alum.mit.edu,
        samitolvanen@google.com, stable@vger.kernel.org,
        yury.norov@gmail.com
Subject:  + lib-stringc-implement-stpcpy.patch added to -mm tree
Message-ID: <20200825235858.5PxgY_EDa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/string.c: implement stpcpy
has been added to the -mm tree.  Its filename is
     lib-stringc-implement-stpcpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stringc-implement-stpcpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stringc-implement-stpcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Similar to last year's fire drill with: commit 5f074f3e192f
("lib/string.c: implement a basic bcmp")

The kernel is somewhere between a "freestanding" environment (no full
libc) and "hosted" environment (many symbols from libc exist with the same
type, function signature, and semantics).

As H.  Peter Anvin notes, there's not really a great way to inform the
compiler that you're targeting a freestanding environment but would like
to opt-in to some libcall optimizations (see pr/47280 below), rather than
opt-out.

Arvind notes, -fno-builtin-* behaves slightly differently between GCC and
Clang, and Clang is missing many __builtin_* definitions, which I consider
a bug in Clang and am working on fixing.

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
encourage its use.  As such, I've removed the declaration from any header,
but it still needs to be exported to avoid linkage errors in modules.

Link: https://lkml.kernel.org/r/20200825140001.2941001-1-ndesaulniers@google.com
Link: https://bugs.llvm.org/show_bug.cgi?id=47162
Link: https://bugs.llvm.org/show_bug.cgi?id=47280
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
Link: https://reviews.llvm.org/D85963
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Andy Lavr <andy.lavr@gmail.com>
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: <stable@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Yury Norov <yury.norov@gmail.com>
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
+ * stpcpy differs from strcpy in a key way: the return value is the new
+ * %NUL-terminated character. (for strcpy, the return value is a pointer to
+ * src. This interface is considered unsafe as it doesn't perform bounds
+ * checking of the inputs. As such it's not recommended for usage. Instead,
+ * its definition is provided in case the compiler lowers other libcalls to
+ * stpcpy.
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

maintainers-add-llvm-maintainers.patch
lib-stringc-implement-stpcpy.patch

