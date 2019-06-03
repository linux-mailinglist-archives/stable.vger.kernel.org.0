Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1C32BA9
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfFCJKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbfFCJKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1382527E32;
        Mon,  3 Jun 2019 09:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553030;
        bh=uJqMRlVgTXkqM8Df4tfYcYSfh4LY6/T02rXWYiZHRNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvKrkYy6tGxu+z2/lwYbdEddZ8pgpHrKgo/JXjd/wyGNGuVjH9iBxOBJacmDaDf/f
         MVHSFBCj3pk9Cq/jq3Uj152ksa1KpTgQtzPGT6RaTMTEYecNEbfxpQwdKUqiQZjwl+
         +AFoRuOHrwSpe3EKeTN9TpCrZVRpzasybffeHuqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19 28/32] compiler.h: give up __compiletime_assert_fallback()
Date:   Mon,  3 Jun 2019 11:08:22 +0200
Message-Id: <20190603090315.423148657@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 81b45683487a51b0f4d3b29d37f20d6d078544e4 upstream.

__compiletime_assert_fallback() is supposed to stop building earlier
by using the negative-array-size method in case the compiler does not
support "error" attribute, but has never worked like that.

You can simply try:

    BUILD_BUG_ON(1);

GCC immediately terminates the build, but Clang does not report
anything because Clang does not support the "error" attribute now.
It will later fail at link time, but __compiletime_assert_fallback()
is not working at least.

The root cause is commit 1d6a0d19c855 ("bug.h: prevent double evaluation
of `condition' in BUILD_BUG_ON").  Prior to that commit, BUILD_BUG_ON()
was checked by the negative-array-size method *and* the link-time trick.
Since that commit, the negative-array-size is not effective because
'__cond' is no longer constant.  As the comment in <linux/build_bug.h>
says, GCC (and Clang as well) only emits the error for obvious cases.

When '__cond' is a variable,

    ((void)sizeof(char[1 - 2 * __cond]))

... is not obvious for the compiler to know the array size is negative.

Reverting that commit would break BUILD_BUG() because negative-size-array
is evaluated before the code is optimized out.

Let's give up __compiletime_assert_fallback().  This commit does not
change the current behavior since it just rips off the useless code.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler.h |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -319,29 +319,14 @@ static inline void *offset_to_ptr(const
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
-/*
- * Sparse complains of variable sized arrays due to the temporary variable in
- * __compiletime_assert. Unfortunately we can't just expand it out to make
- * sparse see a constant array size without breaking compiletime_assert on old
- * versions of GCC (e.g. 4.2.4), so hide the array from sparse altogether.
- */
-# ifndef __CHECKER__
-#  define __compiletime_error_fallback(condition) \
-	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
-# endif
-#endif
-#ifndef __compiletime_error_fallback
-# define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
 #ifdef __OPTIMIZE__
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
-		int __cond = !(condition);				\
 		extern void prefix ## suffix(void) __compiletime_error(msg); \
-		if (__cond)						\
+		if (!(condition))					\
 			prefix ## suffix();				\
-		__compiletime_error_fallback(__cond);			\
 	} while (0)
 #else
 # define __compiletime_assert(condition, msg, prefix, suffix) do { } while (0)


