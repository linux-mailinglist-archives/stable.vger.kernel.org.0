Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD7B40A1D8
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 02:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhINAYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 20:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbhINAYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 20:24:45 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1571C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 17:23:28 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id j27-20020a05620a0a5b00b0042874883070so43774247qka.19
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 17:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PW8ap1YlMsbVLSYF/S3HCznTHGTdylyO4PDqs2kNG6A=;
        b=j0JfYfb5ZgufJ3HB2w6CNXN9S7PLqIiJh1RTBS3JyXj4NH6mrntnqH3iLX+bwTvAsp
         ez00g9aVBQfZIapF1EB+BtbQ7WhRApJQX5SnF8CfJCtRfBf48C0wSlljtLiXQWd/1Lkf
         uOI15jCVqwcBGOiOS0He7PiRPSMI/3oltIFJ1uMzm2K0QZRhlW5BY+skTFHWUuAHcG80
         qa8eXKA+88WNFMQf3Vspku1tPZcSHQH1BhcoEB84ykrP1A+WBzJmXCBa4g2o2ffs28M5
         tG6mzeu6dayKxNZEJjQCBCl5XODPu5joJpSbvg8jpz5nN1V1uTKz483P7X2w+fcZ+u7d
         9zIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PW8ap1YlMsbVLSYF/S3HCznTHGTdylyO4PDqs2kNG6A=;
        b=weaAA27Pptk54g09TFkGmdFChlcLxEQzks/GSV+HViuvSQEEXpQ0COnFFi/of08luN
         VNRX3+xAHFd3XOdG4U/JdX3n9VNn5a66IB376uoBnrDh0nGvaPhQ2ADP6wMnrDMMqlMj
         AP5icWUhqrmiPVtFMmq619TnFn6wUPjr9IrhhnfLcO5RtMlBzOj3DPCQI9E6ILmm2OsH
         YAo7d623d/1tFFfFTUdK1enHrDpJ3P9YZtBPf5eVfDPNZNgcWQmMD4q7URC1dFx4bpYy
         M2q0wVsSto9MZIMO6qcDWfiCi8dX+IEKvnwtApUM3f/u0ff3HnTF7Tl53FaIPBEpltkT
         HLLg==
X-Gm-Message-State: AOAM533CKJl6ucocgq6mXFalZkqS3vNYQrYnUvCPKY2ZYOOSm3YnC7wP
        7AnnfgGt1R6jw1NXPtRRzYji+DuUE22dYBiTlSg=
X-Google-Smtp-Source: ABdhPJwC8hmaKjBS55V257lfS3Ie1kXZVggMDKzC5FGVPkSyZgEhX325pWkrwMQwRYxf8p8W3+5d4oTvs7fPRFlmBI8=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:4780:ab8c:bb56:31d6])
 (user=ndesaulniers job=sendgmr) by 2002:a05:6214:2427:: with SMTP id
 gy7mr2451393qvb.20.1631579007666; Mon, 13 Sep 2021 17:23:27 -0700 (PDT)
Date:   Mon, 13 Sep 2021 17:23:18 -0700
In-Reply-To: <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
Message-Id: <20210914002318.2298583-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2] overflow.h: use new generic division helpers to avoid / operator
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Cc: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Pavel Machek <pavel@ucw.cz>
Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
Link: https://github.com/ClangBuiltLinux/linux/issues/1438
Fixes: f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
add fallback code")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes v1 -> v2:
* Change the BUILD_BUG_ON_MSG's to check the divisor! Not the dividend!
* Change __builtin_choose_expr/__builtin_constant_p soup to _Generic as
  per Linus.
* Add Linus' Suggested-by.
* use __ prefixes on new macros.
* add parens around use of macro parameters.
* realign trailing \.

Note to Rasmus: I did not include comments on the usage. I don't think
we really intend for folks to be using these, much less so in -stable.

 include/linux/math64.h   | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/overflow.h |  8 ++++----
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 66deb1fdc2ef..a1a6ad98b5ea 100644
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
 
+#define __div64_x64(dividend, divisor) ({		\
+	BUILD_BUG_ON_MSG(sizeof(divisor) < sizeof(u64),	\
+	                 "prefer __div_x64");		\
+	__builtin_choose_expr(				\
+		is_signed_type(typeof(dividend)),	\
+		div64_s64((dividend), (divisor)),	\
+		div64_u64((dividend), (divisor)));	\
+})
+
 /**
  * div_u64 - unsigned 64bit divide with 32bit divisor
  * @dividend: unsigned 64bit dividend
@@ -141,6 +153,31 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
 }
 #endif
 
+#define __div_x64(dividend, divisor) ({			\
+	BUILD_BUG_ON_MSG(sizeof(divisor) > sizeof(u32),	\
+	                 "prefer __div64_x64");		\
+	__builtin_choose_expr(				\
+		is_signed_type(typeof(dividend)),	\
+		div_s64((dividend), (divisor)),		\
+		div_u64((dividend), (divisor)));	\
+})
+
+#define __div_64(dividend, divisor)			\
+	_Generic((divisor),				\
+	s64: __div64_x64((dividend), (divisor)),	\
+	u64: __div64_x64((dividend), (divisor)),	\
+	default: __div_x64((dividend), (divisor)))
+
+#define div_64(dividend, divisor) ({				\
+	BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64) ||	\
+	                 sizeof(divisor) > sizeof(u64),		\
+	                 "128b div unsupported");		\
+	_Generic((dividend),					\
+	s64: __div_64((dividend), (divisor)),			\
+	u64: __div_64((dividend), (divisor)),			\
+	default: (dividend) / (divisor));			\
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
 

base-commit: cb83afdc0b865d7c8a74d2b2a1f7dd393e1d196d
-- 
2.33.0.309.g3052b89438-goog

