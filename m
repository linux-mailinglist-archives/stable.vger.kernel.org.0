Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FAE245307
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgHOV5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgHOVwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:52:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617EAC06135B
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 19:09:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d2so6603077plo.2
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 19:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=54FL2fi4838KNUxBDYGwUIbd4eC5LfouQots9gMJMF0=;
        b=fPvq6U6A360rPMQQfY80tv926Cd5O3nR4WPkH6JUn3SS4hp8J9vEeuVc8QeEpFMBTo
         xXoUqxM6lxDduHfN8MJCfliJLBMFyqGypCTtDhu57I8yZD1gzmRxGPsFsc6DfyxonpwQ
         6kCaIoeHLd7JFEftxyEAgBxGUAAjqVFsKV4936IzdButxXfd4XyOFm//dLBHTd/jc5fb
         LYh0OmapnhdXPgays9Ex8Eqi2F/ZdVQTvlJLIGBgwpscpX8iuzHC6U3vBvl1MbMN/7fb
         N8pn4/28tirBW60VwYTiFtv+PPo9JsuEa8A16klsOl/e5uOnISACuAIgTXSZbfn2Z4Um
         Omjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=54FL2fi4838KNUxBDYGwUIbd4eC5LfouQots9gMJMF0=;
        b=XEWE/UcZ1XnNjlF4PlKNFv2Y7805Hh4GDs81Rf5OEU2nlcCI0dPl7N5CZVuwcgj28l
         sxpCwKPPkbZLSNELi0sogTLI2EE3hrWlZP+oAwVocbE9OuBJPS2Ph/YunOOI8NYO8X6m
         kR/VM+B44IRI2Cc7lxIYsKOSEdtRU7F2/fDlF3VSuu6yrfWHTECe7CgNdPtlVVwr82xv
         ZxVjEVWecxYSeJ7XYSZ4S0Cf890JsXEL/mJ3djUn49V81yq+HVWiJraz0PMe6V1Mn1Sk
         wm/Ma4NHvibUcgFLJ7hODVImzfntVBWX625zlSS9NAZAsblQ1Pppf1/kVJ1c94udenD7
         th5Q==
X-Gm-Message-State: AOAM533zA/4rJf2v+FujZzwW+ggOwc1faPEfUIbV8TC9sBTo1cHkjS54
        Fi8GroAai3aPA7vvR3KxGuEPcXmfAhoS8zqkZho=
X-Google-Smtp-Source: ABdhPJxn7c2rM9XYQqL7VYIyJCPlruhb5XpkLIh39f2LFOz1FHt3BUVCChncetKEKYyR5pNeNBUbYTh/dt1My/lLq5w=
X-Received: by 2002:a63:df54:: with SMTP id h20mr3416349pgj.319.1597457393328;
 Fri, 14 Aug 2020 19:09:53 -0700 (PDT)
Date:   Fri, 14 Aug 2020 19:09:44 -0700
In-Reply-To: <20200815014006.GB99152@rani.riverdale.lan>
Message-Id: <20200815020946.1538085-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200815014006.GB99152@rani.riverdale.lan>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2] lib/string.c: implement stpcpy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "=?UTF-8?q?D=C3=A1vid=20Bolvansk=C3=BD?=" <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
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
in parsing format strings.  Calling `sprintf` with overlapping arguments
was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.

`stpcpy` is just like `strcpy` except it returns the pointer to the new
tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
one statement.

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
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Joe Perches <joe@perches.com>
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V2:
* Added Sami's Tested by; though the patch changed implementation, the
  missing symbol at link time was the problem Sami was observing.
* Fix __restrict -> __restrict__ typo as per Joe.
* Drop note about restrict from commit message as per Arvind.
* Fix NULL -> NUL as per Arvind; NUL is ASCII '\0'. TIL
* Fix off by one error as per Arvind; I had another off by one error in
  my test program that was masking this.

 include/linux/string.h |  3 +++
 lib/string.c           | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index b1f3894a0a3e..7686dbca8582 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -31,6 +31,9 @@ size_t strlcpy(char *, const char *, size_t);
 #ifndef __HAVE_ARCH_STRSCPY
 ssize_t strscpy(char *, const char *, size_t);
 #endif
+#ifndef __HAVE_ARCH_STPCPY
+extern char *stpcpy(char *__restrict__, const char *__restrict__);
+#endif
 
 /* Wraps calls to strscpy()/memset(), no arch specific code required */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count);
diff --git a/lib/string.c b/lib/string.c
index 6012c385fb31..68ddbffbbd58 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -272,6 +272,29 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
 }
 EXPORT_SYMBOL(strscpy_pad);
 
+#ifndef __HAVE_ARCH_STPCPY
+/**
+ * stpcpy - copy a string from src to dest returning a pointer to the new end
+ *          of dest, including src's NUL terminator. May overrun dest.
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
+	return --dest;
+}
+#endif
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
-- 
2.28.0.220.ged08abb693-goog

