Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C61B409E2B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbhIMUdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243333AbhIMUdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:33:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2782C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:32:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 124-20020a251182000000b005a027223ed9so14416698ybr.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iuVSNTEj/IrVtot2IP0rOmE+tkb9TmEFRChI7WrvsVQ=;
        b=QfsUizU+ni8bMJ8NAONpVHC3V/328414sovWfgK5sAwuAfSUh6x2O8/d85OqrluMzl
         TzH2VGLQ0E7Ah8Z58EEcKpadNKIBf8ka5SaRAoCW80G6WrsVaFA4PuCSEKNTlZ1SHMlu
         BI4AD8sqcAugho8eO2KKG2wRqn3MTu9hMRXq6zdt/y0cZ7FS9bDWJKICngh7WOgPPPvy
         wN1xkDEICdMUYs6Ql13jsM94dZ1bPO0RxNhV9RhoEHp/h8hthXtEotyNhcsSSTGNV5dv
         y5IHh++pc0tzxISdH5GYHZC9u9cjonhFSz9oYydsGJo3nKhWVq2VR2fbabLf3mTrZFkd
         YuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iuVSNTEj/IrVtot2IP0rOmE+tkb9TmEFRChI7WrvsVQ=;
        b=rFMunddBuIF72xgLhvBv5zT3cChMOhBPzRp5usDYVCwTFkZsbZMZuLcURKCXFgUP3Q
         D/bOyvGV6xj4u6E2NBQKR9GB26j++Y7CtPPvq5qhFKpCikYBsyyu+7NMKMaCnO3Fk09w
         pZwG/VQJ+1OpIBCMpYksTDPC0WgkvgpkcoB3Vo/8wU87+FA+iQolqfK/xA7krAwD+cFJ
         FYybmVI5kX1wlP9bd0m4lEOQ064LhPIQievtaQWBrvUbdWaCM4Tkyr6gfXykDanqNY1+
         YkrQtbay9vzeyg9b0I2D62w9CX9cgkaMnyIq4KfnRBtugHT3dWXn2WmWe/LNBE7x1OwF
         vVVQ==
X-Gm-Message-State: AOAM531L/zNi6Cwhqd48qUQAQCMrXXPGjGrkeIxc0qpZmOdlASdy4jIQ
        FWTcRmI97MXhr6BVkxeMnp/KFb1EJXhEj8wmexk=
X-Google-Smtp-Source: ABdhPJyCJBVWKkqUWGh+Aa18x15EeEHvZbuAtWv2VaDsr4cGSS1eyqeI+yo8WXzQNPGM8k1FEZtJUhi7X3UtLLjCb5I=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:18fb:7cc2:db5f:5817])
 (user=ndesaulniers job=sendgmr) by 2002:a25:ca08:: with SMTP id
 a8mr17928720ybg.231.1631565133012; Mon, 13 Sep 2021 13:32:13 -0700 (PDT)
Date:   Mon, 13 Sep 2021 13:32:01 -0700
Message-Id: <20210913203201.1844253-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 5.10] overflow.h: use new generic division helpers to avoid / operator
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fad7cd3310db ("nbd: add the check to prevent overflow in
__nbd_ioctl()") raised an issue from the fallback helpers added in
commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
add fallback code")

ERROR: modpost: "__divdi3" [drivers/block/nbd.ko] undefined!

As Stephen Rothwell notes:
  The added check_mul_overflow() call is being passed 64 bit values.
  COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW is not set for this build (see
  include/linux/overflow.h).

Specifically, the helpers for checking whether the results of a
multiplication overflowed (__unsigned_mul_overflow,
__signed_add_overflow) use the division operator when
!COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.  This is problematic for 64b
operands on 32b hosts.

This was fixed upstream by
commit 76ae847497bc ("Documentation: raise minimum supported version of
GCC to 5.1")
which is not suitable to be backported to stable; I didn't have this
patch ready in time.

Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Pavel Machek <pavel@ucw.cz>
Link: https://github.com/ClangBuiltLinux/linux/issues/1438
Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
Link: https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/
Fixes: f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
add fallback code")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
This kind of generic meta-programming in C and my lack of experience in
doing so makes me very uncomfortable (and slightly ashamed) to send
this. I would appreciate careful review and feedback. I would appreciate
if Naresh can test this with GCC 4.9, which I don't have handy.

Linus also suggested I look into the use of _Generic; I haven't
evaluated that approach yet, but I felt like posting this early for
feedback.

 include/linux/math64.h   | 35 +++++++++++++++++++++++++++++++++++
 include/linux/overflow.h |  8 ++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 66deb1fdc2ef..bc9c12c168d0 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -10,6 +10,9 @@
 
 #define div64_long(x, y) div64_s64((x), (y))
 #define div64_ul(x, y)   div64_u64((x), (y))
+#ifndef is_signed_type
+#define is_signed_type(type)       (((type)(-1)) < (type)1)
+#endif
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -111,6 +114,15 @@ extern s64 div64_s64(s64 dividend, s64 divisor);
 
 #endif /* BITS_PER_LONG */
 
+#define div64_x64(dividend, divisor) ({			\
+	BUILD_BUG_ON_MSG(sizeof(dividend) < sizeof(u64),\
+	                 "prefer div_x64");		\
+	__builtin_choose_expr(				\
+		is_signed_type(typeof(dividend)),	\
+		div64_s64(dividend, divisor),		\
+		div64_u64(dividend, divisor));		\
+})
+
 /**
  * div_u64 - unsigned 64bit divide with 32bit divisor
  * @dividend: unsigned 64bit dividend
@@ -141,6 +153,29 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
 }
 #endif
 
+#define div_x64(dividend, divisor) ({			\
+	BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u32),\
+	                 "prefer div64_x64");		\
+	__builtin_choose_expr(				\
+		is_signed_type(typeof(dividend)),	\
+		div_s64(dividend, divisor),		\
+		div_u64(dividend, divisor));		\
+})
+
+#define div_64(dividend, divisor) ({						\
+	BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64),			\
+	                 "128b div unsupported");				\
+	__builtin_choose_expr(							\
+		__builtin_types_compatible_p(typeof(dividend), s64) ||		\
+		__builtin_types_compatible_p(typeof(dividend), u64),		\
+		__builtin_choose_expr(						\
+			__builtin_types_compatible_p(typeof(divisor), s64) ||	\
+			__builtin_types_compatible_p(typeof(divisor), u64),	\
+			div64_x64(dividend, divisor),				\
+			div_x64(dividend, divisor)),				\
+		dividend / divisor);						\
+})
+
 u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
 
 #ifndef mul_u32_u32
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index ef74051d5cfe..2ebdf220c184 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -123,8 +123,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 	(void) (&__a == __d);				\
 	*__d = __a * __b;				\
 	__builtin_constant_p(__b) ?			\
-	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
-	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
+	  __b > 0 && __a > div_64(type_max(typeof(__a)), __b) :	\
+	  __a > 0 && __b > div_64(type_max(typeof(__b)), __a);	\
 })
 
 /*
@@ -195,8 +195,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 	(void) (&__a == &__b);						\
 	(void) (&__a == __d);						\
 	*__d = (u64)__a * (u64)__b;					\
-	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
-	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
+	(__b > 0 && (__a > div_64(__tmax, __b) || __a < div_64(__tmin, __b))) ||		\
+	(__b < (typeof(__b))-1 && (__a > div_64(__tmin, __b) || __a < div_64(__tmax, __b))) ||	\
 	(__b == (typeof(__b))-1 && __a == __tmin);			\
 })
 
-- 
2.33.0.309.g3052b89438-goog

