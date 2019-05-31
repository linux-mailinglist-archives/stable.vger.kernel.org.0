Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B647030840
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 08:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfEaGEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 02:04:15 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39675 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaGEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 02:04:15 -0400
Received: by mail-ed1-f68.google.com with SMTP id e24so12792978edq.6
        for <stable@vger.kernel.org>; Thu, 30 May 2019 23:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xeJtG7vEar5JVvT9PCS2XrltCjozk3OE5Wgh3IZCm48=;
        b=gZFICE+J9YJB/dVuG+P4RmSBhGxFlflDNSFVLINZmw0ueczc1xcH45vTifwugcB+yw
         n8I3S1wJUmDdRAAd9bLFH4FJ4Vg4RwvOSVeB96mRzvAqbk19/UcbqTkYO9QxXOdn8jVS
         aoBMPREM+MYyWXPvXWjIz+3u4090SuYeWGyHGK4TGFzhmB6xLo3Xl/9HWEexCHhrMr3D
         sLIsJk5bzYNvkeTjvQR04KzAU4IejV5QpbnKqo/5LTT8y1d6Jih7iGqRu0nY9bNHo9HQ
         D/lWdcHu6TJ2FRAC+JN0q8EtoLCIKt89jKtlcJt6kRk35zi/n2L8TAh6f4WJ3rMoFE8E
         aZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xeJtG7vEar5JVvT9PCS2XrltCjozk3OE5Wgh3IZCm48=;
        b=FDWE2TaAHm0fAlSTFQM4OJmSq/cxIHXtzcJrC+KM3LQ7mT3z4SsLLb4eWJau0J1ZeX
         SXEsG82QzQ2MlkCCtBLVXUIj+AUXlqI2Yi4A76GimC86mTuZNbWJI0Mei9u5MXt0z388
         tXa93cFdANshW3vwCDKGQ4mMaxJ6OaM9YQTBfo8NxN7wbnIoOTRcILYN2neuR7mMcTp5
         UGgRj73TEIwg8/G0VtGHGodiSyCsq9/xNrg8+A0PmSWcydkSFydRGhOwrCMg3IC1S7La
         YGUXv5IB5O3n88mZIkK3tK6hwS0u16OLuga1oyaoS7TdOf3xvpC5y+gtBWiwCKkMWwvX
         viyw==
X-Gm-Message-State: APjAAAXIG9WfgrFhBS1KXq3PHAaCo3rGP/cfNtYfY25DNIiruqemuxuj
        1GkXRKIPHvM7V4Mx1B39rtg=
X-Google-Smtp-Source: APXvYqxznhQzTz2a5j83A03h0kysNOOfSAleLHYXahj2hpd6RlHtOg8qP+kYyZe3ko7r+o0+b+tCfw==
X-Received: by 2002:a50:f286:: with SMTP id f6mr6677791edm.44.1559282653176;
        Thu, 30 May 2019 23:04:13 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id g18sm1314552edh.13.2019.05.30.23.04.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 23:04:12 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19] compiler.h: give up __compiletime_assert_fallback()
Date:   Thu, 30 May 2019 23:01:10 -0700
Message-Id: <20190531060109.124476-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2
MIME-Version: 1.0
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
---

Hi Greg and Sasha,

Please pick up this patch for 4.19. It fixes an insane amount of spam
from the drivers/gpu/drm/i915 subsystem because they enable the -Wvla
warning and we have been carrying it in our CI for a while.

 include/linux/compiler.h | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 81c2238b884c..bb22908c79e8 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -319,29 +319,14 @@ static inline void *offset_to_ptr(const int *off)
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
-- 
2.22.0.rc2

