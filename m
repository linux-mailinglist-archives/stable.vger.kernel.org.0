Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ACA26916B
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 18:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgINQTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 12:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgINQRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 12:17:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349FAC061788
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 09:16:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b127so239882ybh.21
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YI5TFjrZrW6iX6wLKYhaDvA2UAvnRhVpfjmVtoFV008=;
        b=vXMRc/pNGgQ0c8UXl2DPqopDPJA6DtVr6/XcYChPaglz/iNglFqK+mTodoVaHIdwpq
         C63+5CRQO9d5ztZ7r+1Sno5e3tFMg7ZXQ8fjZ/qU4P0tAQhOlGrOed070oTIGc0RJk3Y
         r+CIvaxawo4c7O13+z0RXgz8AODB/woVEs8iKVP9Lv0IriRJA0DNi1zTHuxsf4ck56dd
         iTMoPK899e5pa3fFdpKcQ7EZAF9ohW2tXpd4m2uDwHpi3EQYnXV5V5o0vEYUBQZVzVSU
         hD520P01MTbJhxV2wfRFrGTbKLPSln2glDgk43McGyxujSODT7H1Ye/jvP5Uja4yG0uO
         T2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YI5TFjrZrW6iX6wLKYhaDvA2UAvnRhVpfjmVtoFV008=;
        b=oz69ZLGWZ81WSZUhcHyE70LDARMu8UnJ133uwwFHbAyvG633Yh2AQBhtSlKAHpaRTi
         yc4WjKhoAA7ETf8Hi7tWSTcNnteOZdC/svuO4OtqTbaPAuacGJXnTsa5EuON204bwAK6
         cu/deWr1LKUNlwmSxQF/OvKKOqn83CiNxxaja35SmkRhpI9NLTrYo+cT3+GZ+vEugcOV
         oOLUVVGLfIiE7xGwDYZmXh0z8kGE+r5qcGuHpzxTYpoZFR1hX64s761z+ILv7NR0uqQR
         1hD1O7NSMlIEPUGzHqAt3c3oK0sDZ/1MMDaQDPbY/XGt7LTUQJgCzMr51B6TO5HbTDHY
         8Kxw==
X-Gm-Message-State: AOAM530LYXv+N6JK6QixeydyR/YI1eUi403YEtw8k/JJNbQh5Lwp/W1/
        6mGs8LNUIlwuyODJ0kFzJvR7i79p/lmW3CPqPL0=
X-Google-Smtp-Source: ABdhPJwD7JVagoDruqSqJDoFs6vE126qHPtYArFvvt+8uZMKEwM2SSkjvjwott5vd30JoTaEVIfYPDYNURSk750kq7o=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a25:ce90:: with SMTP id
 x138mr2809847ybe.95.1600100209393; Mon, 14 Sep 2020 09:16:49 -0700 (PDT)
Date:   Mon, 14 Sep 2020 09:16:43 -0700
In-Reply-To: <20200914160958.889694-1-ndesaulniers@google.com>
Message-Id: <20200914161643.938408-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200914160958.889694-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v5] lib/string.c: implement stpcpy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andy Lavr <andy.lavr@gmail.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
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

Reported-by: Sami Tolvanen <samitolvanen@google.com>
Suggested-by: Andy Lavr <andy.lavr@gmail.com>
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: stable@vger.kernel.org
Link: https://bugs.llvm.org/show_bug.cgi?id=47162
Link: https://bugs.llvm.org/show_bug.cgi?id=47280
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
Link: https://reviews.llvm.org/D85963
---
Changes V5:
* fix missing parens in comment.

Changes V4:
* Roll up Kees' comment fixup from
  https://lore.kernel.org/lkml/202009060302.4574D8D0E0@keescook/#t.
* Keep Nathan's tested by tag.
* Add Kees' reviewed by tag from
  https://lore.kernel.org/lkml/202009031446.3865FE82B@keescook/.

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
index 6012c385fb31..4288e0158d47 100644
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
-- 
2.28.0.618.gf4bc123cb7-goog

