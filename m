Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD62409EC3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 23:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245321AbhIMVGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 17:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhIMVGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 17:06:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2486EC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 14:05:06 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h17so6268755edj.6
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 14:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wD6wLfn0xDOQutt/AgUvNEKB8hl15ogJfUQtZqFzVtQ=;
        b=JRajFJIqqGlp4kvZBFhIbIscc6gCCChb+nyumxk1yCGNcbvlOGBg0zTY7JPUmnBaHD
         90uKIfh+7sSfOT5IYGSnMTfTGjB39ZRdn8bmhaQl7OJFozZEQitnXpLnfnmGsWq8D7ym
         eLBVOD20Cs5v/DktE3IIc3FNywZuAMVQcSL/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wD6wLfn0xDOQutt/AgUvNEKB8hl15ogJfUQtZqFzVtQ=;
        b=NWH6lw8B2wvGf4r8MQCQfo2lHjGkI8lyDgPqhKXBdwlZLZ3ZR6bdBO4vh9ddZAy+qx
         5TmF+opGuoJeVsjeIaXeRRmeFD7tJWmUePs89NsVvvHVVwElEuMT/8rsptwGEZe47yr1
         w08OABD+JB8YJXtVpGirGIEpJLRcfAPu77L6v0kNlKoh2PEG9baua9Ya+tJpNI5K0PpY
         VPDBHaICTw1BE+uzdntcMUytBOkA1uvLH3jMEnsmYKraXBcVmyO5MBcXhHc4MGaQwXC4
         xGsumNwhCpW4i2Q6o4uRJX2IZQzoP+0ej5mjaYy8rD5h8UIcSA5CbThZjW1G+hDSR6dw
         12sw==
X-Gm-Message-State: AOAM5331Nn6xOOwdR9XpV3tKH3q55KOKy4UObb05Ac+bJR1GPrwB15TA
        dqPfsOwlLn4QqNRDaB2UkR0gvQ==
X-Google-Smtp-Source: ABdhPJz7Yl7kAHQCuPUlaARmIg2IFeFg5oPLn5/MiipNz67Px6e9NL25/vb4584edt2ldDWy+cmegA==
X-Received: by 2002:aa7:de85:: with SMTP id j5mr15201090edv.147.1631567104661;
        Mon, 13 Sep 2021 14:05:04 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.69.72])
        by smtp.gmail.com with ESMTPSA id q19sm4495157edc.74.2021.09.13.14.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 14:05:04 -0700 (PDT)
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     llvm@lists.linux.dev, stable@vger.kernel.org,
        Arnd Bergmann <arnd@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
References: <20210913203201.1844253-1-ndesaulniers@google.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
Date:   Mon, 13 Sep 2021 23:05:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210913203201.1844253-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/09/2021 22.32, Nick Desaulniers wrote:
> commit fad7cd3310db ("nbd: add the check to prevent overflow in
> __nbd_ioctl()") raised an issue from the fallback helpers added in
> commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> add fallback code")
> 
> ERROR: modpost: "__divdi3" [drivers/block/nbd.ko] undefined!
> 
> As Stephen Rothwell notes:
>   The added check_mul_overflow() call is being passed 64 bit values.
>   COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW is not set for this build (see
>   include/linux/overflow.h).
> 
> Specifically, the helpers for checking whether the results of a
> multiplication overflowed (__unsigned_mul_overflow,
> __signed_add_overflow) use the division operator when
> !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.  This is problematic for 64b
> operands on 32b hosts.
> 
> This was fixed upstream by
> commit 76ae847497bc ("Documentation: raise minimum supported version of
> GCC to 5.1")
> which is not suitable to be backported to stable; I didn't have this
> patch ready in time.
> 
> Cc: stable@vger.kernel.org
> Cc: Arnd Bergmann <arnd@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Suggested-by: Pavel Machek <pavel@ucw.cz>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1438
> Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
> Link: https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/
> Fixes: f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> add fallback code")
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> This kind of generic meta-programming in C and my lack of experience in
> doing so makes me very uncomfortable (and slightly ashamed) to send
> this. I would appreciate careful review and feedback. I would appreciate
> if Naresh can test this with GCC 4.9, which I don't have handy.
> 
> Linus also suggested I look into the use of _Generic; I haven't
> evaluated that approach yet, but I felt like posting this early for
> feedback.
> 
>  include/linux/math64.h   | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/overflow.h |  8 ++++----
>  2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/math64.h b/include/linux/math64.h
> index 66deb1fdc2ef..bc9c12c168d0 100644
> --- a/include/linux/math64.h
> +++ b/include/linux/math64.h
> @@ -10,6 +10,9 @@
>  
>  #define div64_long(x, y) div64_s64((x), (y))
>  #define div64_ul(x, y)   div64_u64((x), (y))
> +#ifndef is_signed_type
> +#define is_signed_type(type)       (((type)(-1)) < (type)1)
> +#endif
>  
>  /**
>   * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> @@ -111,6 +114,15 @@ extern s64 div64_s64(s64 dividend, s64 divisor);
>  
>  #endif /* BITS_PER_LONG */

Some comments on when and how to use this would be nice (not just build
bugs when used wrong).

> +#define div64_x64(dividend, divisor) ({			\
> +	BUILD_BUG_ON_MSG(sizeof(dividend) < sizeof(u64),\
> +	                 "prefer div_x64");		\
> +	__builtin_choose_expr(				\
> +		is_signed_type(typeof(dividend)),	\
> +		div64_s64(dividend, divisor),		\
> +		div64_u64(dividend, divisor));		\
> +})
> +
>  /**
>   * div_u64 - unsigned 64bit divide with 32bit divisor
>   * @dividend: unsigned 64bit dividend
> @@ -141,6 +153,29 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
>  }
>  #endif
>  
> +#define div_x64(dividend, divisor) ({			\
> +	BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u32),\
> +	                 "prefer div64_x64");		\
> +	__builtin_choose_expr(				\
> +		is_signed_type(typeof(dividend)),	\
> +		div_s64(dividend, divisor),		\
> +		div_u64(dividend, divisor));		\
> +})
> +
> +#define div_64(dividend, divisor) ({						\
> +	BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64),			\
> +	                 "128b div unsupported");				\
> +	__builtin_choose_expr(							\
> +		__builtin_types_compatible_p(typeof(dividend), s64) ||		\
> +		__builtin_types_compatible_p(typeof(dividend), u64),		\

You can save a bit of typing using __same_type(dividend, s64) - it's a
nice property of typeof() that it's idempotent when applied to a type
name. _Generic would probably also do, but I don't think it would save
that much, if anything, here.

>  u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
>  
>  #ifndef mul_u32_u32
> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index ef74051d5cfe..2ebdf220c184 100644
> --- a/include/linux/overflow.h
> +++ b/include/linux/overflow.h
> @@ -123,8 +123,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
>  	(void) (&__a == __d);				\
>  	*__d = __a * __b;				\
>  	__builtin_constant_p(__b) ?			\
> -	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
> -	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
> +	  __b > 0 && __a > div_64(type_max(typeof(__a)), __b) :	\
> +	  __a > 0 && __b > div_64(type_max(typeof(__b)), __a);	\
>  })
>  
>  /*
> @@ -195,8 +195,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
>  	(void) (&__a == &__b);						\
>  	(void) (&__a == __d);						\
>  	*__d = (u64)__a * (u64)__b;					\
> -	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
> -	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
> +	(__b > 0 && (__a > div_64(__tmax, __b) || __a < div_64(__tmin, __b))) ||		\
> +	(__b < (typeof(__b))-1 && (__a > div_64(__tmin, __b) || __a < div_64(__tmax, __b))) ||	\
>  	(__b == (typeof(__b))-1 && __a == __tmin);			\
>  })

I had actually forgotten what horrors lay hidden in these fallback
macros, I just knew they needed a wooden stake sooner or later. Now you
made me look at this right before bedtime :(

So, I'd sleep a little better if we got the 64 bit tests commented back
in in test_overflow.c, and [assuming that the above would actually make
that file build with gcc 4.9] that patch also backported to 5.10, so we
had some confidence that the whole house of cards is actually solid.

Rasmus
