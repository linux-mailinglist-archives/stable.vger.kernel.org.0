Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628D7245042
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 02:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHOAY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 20:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgHOAY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 20:24:29 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4F9C061385
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 17:24:28 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l18so7056848qvq.16
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 17:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XRzGQ7xGX/sFN7c8Gj9tV2IiOtNpdC4f2YfZedk7h2c=;
        b=L3cjo58SrUy7KFXgcMpEtxPUkK6nFHCdECr6hz0JngvEIo+tQDBMqL7MIhJnheK6WB
         AYUI/ErQO7CMh7M2c+tzkGPUFHxiXuo+wU/dfQI/hnB2B7Wu7jj8nyUIf8kRRbJ7urbi
         E+9mHB88xM7jGW4skoOw3m3Ea1irBY8nrIJLDup0O78Z+ghnbXrsONYSHWFyTzR8Ghdn
         LjYyimThv+zFEub528avQ46xO58t4kv7EuxHC8wrCWc8k/V/o6EMFHj/9gUVas/QLGw+
         Wp18MnI4qGrU1oHVOwOlhPYhqLSWNQ1r+OsEgAgNEydNtq7RJZl8Qpq1eLFzZgkMaIFy
         sMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XRzGQ7xGX/sFN7c8Gj9tV2IiOtNpdC4f2YfZedk7h2c=;
        b=ieVup7Nfa0sDa3z2j4ClTS80IcDxcJOmItZ0jfIVfvR7Wmlc9FQY3gpqyABQH7C5Xf
         W651cidYcMnpx38q/PGUtjWsdkqUuC1eGLSPSwba9t18bltaKQ9ipg1FEg5C+U1VXgXe
         NjlhKSncYm+Ryf0Dvxvv8e5CYuzUITm4lPuX4tWsI+p55Bx9zhIU6RIwYoO/kwqrVx+6
         vnoC8l0iXVtFM5rzlgKp3NQxBUfkqDm6gWIgAB+0wHbwKAQS+e47tBm5m5uzYjsd97f+
         Tn4mmTDYh+gBFMhCcZkMZF1pPyXixerYJHshy10mPn7qmlM3ePyQeZq1YArrs5UeB0hN
         mOaA==
X-Gm-Message-State: AOAM531/P+POLySxcP+RmwbnzOzJDnLLLFqDunEXQ8uEHIza5DQP/XiR
        OuRAPTfF8oe3q7Id6zCMb3Aii4/7qPD8X2rupss=
X-Google-Smtp-Source: ABdhPJzOm3IFfI3nNhI3u/ndph4cDdUq8GGSmKQkiNXTpMrnurkQJwXTZk9v15oscx27u9xKAQRQqDeTuk2/zjHzMEw=
X-Received: by 2002:a0c:fbd1:: with SMTP id n17mr5138941qvp.4.1597451067876;
 Fri, 14 Aug 2020 17:24:27 -0700 (PDT)
Date:   Fri, 14 Aug 2020 17:24:15 -0700
Message-Id: <20200815002417.1512973-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH] lib/string.c: implement stpcpy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "=?UTF-8?q?D=C3=A1vid=20Bolvansk=C3=BD?=" <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Joe Perches <joe@perches.com>, Tony Luck <tony.luck@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLVM implemented a recent "libcall optimization" that lowers calls to
`sprintf(dest, "%s", str)` where the return value is used to
`stpcpy(dest, str) - dest`. This generally avoids the machinery involved
in parsing format strings.

`stpcpy` is just like `strcpy` except:
1. it returns the pointer to the new tail of `dest`. This allows you to
   chain multiple calls to `stpcpy` in one statement.
2. it requires the parameters not to overlap.  Calling `sprintf` with
   overlapping arguments was clarified in ISO C99 and POSIX.1-2001 to be
   undefined behavior.

`stpcpy` was first standardized in POSIX.1-2008.

Implement this so that we don't observe linkage failures due to missing
symbol definitions for `stpcpy`.

Similar to last year's fire drill with:
commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")

This optimization was introduced into clang-12.

Cc: stable@vger.kernel.org
Link: https://bugs.llvm.org/show_bug.cgi?id=47162
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
Link: https://reviews.llvm.org/D85963
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/linux/string.h |  3 +++
 lib/string.c           | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index b1f3894a0a3e..e570b9b10f50 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -31,6 +31,9 @@ size_t strlcpy(char *, const char *, size_t);
 #ifndef __HAVE_ARCH_STRSCPY
 ssize_t strscpy(char *, const char *, size_t);
 #endif
+#ifndef __HAVE_ARCH_STPCPY
+extern char *stpcpy(char *__restrict, const char *__restrict__);
+#endif
 
 /* Wraps calls to strscpy()/memset(), no arch specific code required */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count);
diff --git a/lib/string.c b/lib/string.c
index 6012c385fb31..81bc4d62c256 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -272,6 +272,29 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
 }
 EXPORT_SYMBOL(strscpy_pad);
 
+#ifndef __HAVE_ARCH_STPCPY
+/**
+ * stpcpy - copy a string from src to dest returning a pointer to the new end
+ *          of dest, including src's NULL terminator. May overrun dest.
+ * @dest: pointer to end of string being copied into. Must be large enough
+ *        to receive copy.
+ * @src: pointer to the beginning of string being copied from. Must not overlap
+ *       dest.
+ *
+ * stpcpy differs from strcpy in two key ways:
+ * 1. inputs must not overlap.
+ * 2. return value is the new NULL terminated character. (for strcpy, the
+ *    return value is a pointer to src.
+ */
+#undef stpcpy
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
+{
+	while ((*dest++ = *src++) != '\0')
+		/* nothing */;
+	return dest;
+}
+#endif
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
-- 
2.28.0.220.ged08abb693-goog

