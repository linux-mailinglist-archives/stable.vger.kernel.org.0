Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACD5251A57
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHYN77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 09:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgHYN64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 09:58:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1EAC061755
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 06:58:56 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gf6so1868159pjb.6
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Us+zKhWOc0nF2Stw/sjqwIYhi1P3cVkrUO+fKBNUwt4=;
        b=kChPl54dn9ymEmCalokFzgP0MuYBhYIUai4sfhGRDTh7cmSDYrE9/f2w2wlzy79P1U
         odUElDEA6bydiFE9ZvHxHgUU1DeCZfPfixc+QnXh6sqh3mCROa7cWR80GWycaCUfb4IF
         UBKXlwIVApSR31H2zG7ZxWF6WxQTdY9nQlI9tLzJ7tq7xXyPlCbj3ruaO4VmIFc2t8FP
         u5EoeZ4mdLG9kegCOTiKILj3FbecfJPwMC/TsHIbN2mbiBeuIHnoLEgj58tO1/iziyT3
         ZHyFWI96H8MuXgxec7wRTEFCpZDQz1eBjJcUj1sj21HyfKjhnsCK5NAQONRKGgGjyfaK
         ImQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Us+zKhWOc0nF2Stw/sjqwIYhi1P3cVkrUO+fKBNUwt4=;
        b=Qo4U42FKaxTn+ZE4yJSNcbLewUDyIXg3L2hEj9XKg3MYxTLimadU5xkgL8Ns7cUj9K
         rkEVJOPA5fvKX4nQ5H2OVrLofpkHWtfjzDFZi7vvnsQn0eW4xl0sZJaJfZAFoZQ2M5b9
         WNG+HNWBiA5F6LYmyGqPjc5eD2BYjAhTTYYcz1DyDZkN0nasOcTzJsYDzIteNj+Rju/0
         K2fwxyI7gwKKPNUh8mFRqfE/E4ERqsVL8Znn4Wnp0K3y56liYVJcrqq6+h3iMvhNYtFu
         JlnfJZ0KZkauwSyUwjWeuTJqgaWVbWC3WE+Ip39BZJDYHbjQPKA2E3ezmMU6LoPtW4mM
         LgLA==
X-Gm-Message-State: AOAM533WgGBeBLCRQISNzfGwvQjoDICrIdFIEniRlXYVFnnn6hh/bGnZ
        Dl4LpVDJ2QQL+JwoUltrJfaqPJZnBZmVktfDMf8=
X-Google-Smtp-Source: ABdhPJyZgdjJcZNgecDr3UiTzEn5aQy+0LYKn3Ej4qIsX1xwC3PrG7l2IDzKFUt1pE1eWuX67nXFBj1sKlB/v8+4iqU=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a62:7c97:: with SMTP id
 x145mr8231879pfc.155.1598363935586; Tue, 25 Aug 2020 06:58:55 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:58:36 -0700
Message-Id: <20200825135838.2938771-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v3] lib/string.c: implement stpcpy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLVM implemented a recent "libcall optimization" that lowers calls to
`sprintf(dest, "%s", str)` where the return value is used to
`stpcpy(dest, str) - dest`. This generally avoids the machinery involved
in parsing format strings.  `stpcpy` is just like `strcpy` except it
returns the pointer to the new tail of `dest`.  This optimization was
introduced into clang-12.

Implement this so that we don't observe linkage failures due to missing
symbol definitions for `stpcpy`.

Similar to last year's fire drill with:
commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")

The kernel is somewhere between a "freestanding" environment (no full libc)
and "hosted" environment (many symbols from libc exist with the same
type, function signature, and semantics).

As H. Peter Anvin notes, there's not really a great way to inform the
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

Cc: stable@vger.kernel.org
Link: https://bugs.llvm.org/show_bug.cgi?id=47162
Link: https://bugs.llvm.org/show_bug.cgi?id=47280
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
Link: https://reviews.llvm.org/D85963
Suggested-by: Andy Lavr <andy.lavr@gmail.com>
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V3:
* Drop Sami's Tested by tag; newer patch.
* Add EXPORT_SYMBOL as per Andy.
* Rewrite commit message, rewrote part of what Masahiro said to be
  generic in terms of foo() and bar().
* Prefer %NUL-terminated to NULL terminated. NUL is the ASCII character
  '\0', as per Arvind and Rasmus.

Changes V2:
* Added Sami's Tested by; though the patch changed implementation, the
  missing symbol at link time was the problem Sami was observing.
* Fix __restrict -> __restrict__ typo as per Joe.
* Drop note about restrict from commit message as per Arvind.
* Fix NULL -> NUL as per Arvind; NUL is ASCII '\0'. TIL
* Fix off by one error as per Arvind; I had another off by one error in
  my test program that was masking this.

 lib/string.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/lib/string.c b/lib/string.c
index 6012c385fb31..6bd0cf0fb009 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -272,6 +272,30 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
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
-- 
2.28.0.297.g1956fa8f8d-goog

