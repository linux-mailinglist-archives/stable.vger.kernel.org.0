Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA93DC15F
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhG3W7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbhG3W7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 18:59:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CA5C061765
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:59:42 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i10so12844767pla.3
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V2dvuvNFpryb1cvQLGlVrhhfsTfSnu/5+tUDbUkQolo=;
        b=sCMXYE8BPVu/dKEp3RQsjKh5BuJC1zZZb4+9CntVolv0Jbrb/288cSPWlbgdYB6uV8
         WJXTQDArwMcZuEtSPpFWbXRWRAWq6AvaG6OKGWySn3W8iDAsfRyVvtdb1/efkiAlUIUW
         n7KgCTW1pAQ8LyKDcl2tVh/E5CWElNXrwCZmEevGnBD7Pn0mnmpbVXIjrhbcv4C5m963
         eoeYNJGNPQUSRSipE7Kfd9amGgFWJIUqyeyILlgygBlypxHV+pfv0CgeLk7sG0mF4Lc/
         MdIVR+f/eT+lmsmqc7z9fRROYhrxD8JPegsJJ+4ESDXsUCKfqNjW34r9okUBJARXwgH9
         6rUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V2dvuvNFpryb1cvQLGlVrhhfsTfSnu/5+tUDbUkQolo=;
        b=hfXVg4vUN+GwYGcZ7s4A6b0kbswdf0eQUmYFk8QvICaCsBVISawE7YRziWT6gjonMA
         R88No6wiezg9CBGUyFnpP923uBbEsczj7O5Ut+5f6gW+WznAo8kFp9RXLh7eubPayAgf
         1lV10Tfb85cPNTkY39w8HLDNbM+bYoJEr6TKvM7pp1bGNGNM1n0aCDFZ4DbQ8/PSSDTG
         viEc1OKIuAdW1eeM+Jg//khDWzDZ4yl62bBVB5cGqJ+6lBnKtxvV3lK8BFs1hfqQsa9A
         jnwK2HpN1ccQ6fC6ixj5Vxy0xC1y9etKBmDLFfa8WhZnKSBaAewqd7UPwg+bR/nM4vQ4
         8y6A==
X-Gm-Message-State: AOAM530Wh/hdRWfp95n5pNLSYb0F8xzp61IIN9FpwVKxhG6yE+4LVxX8
        gjrqTxG82mWvWEH9hufuWfWW9Q==
X-Google-Smtp-Source: ABdhPJy5fOXlF8mlpIqzL8jUb2C6BgbXxOZyyEYs4oEPgoSBaa6t7Y9gQXLYxESft75tpRgo3kepEw==
X-Received: by 2002:a17:902:b713:b029:12b:b249:693f with SMTP id d19-20020a170902b713b029012bb249693fmr4511815pls.17.1627685981632;
        Fri, 30 Jul 2021 15:59:41 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:200:160:995:7f22:dc59])
        by smtp.gmail.com with ESMTPSA id a20sm3235150pjh.46.2021.07.30.15.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:59:40 -0700 (PDT)
Date:   Fri, 30 Jul 2021 15:59:36 -0700
From:   Fangrui Song <maskray@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Marco Elver <elver@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
Message-ID: <20210730225936.ce3hcjdg2sptvbh7@google.com>
References: <20210730223815.1382706-1-nathan@kernel.org>
 <CAKwvOdnJ9VMZfZrZprD6k0oWxVJVSNePUM7fbzFTJygXfO24Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdnJ9VMZfZrZprD6k0oWxVJVSNePUM7fbzFTJygXfO24Pw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-30, Nick Desaulniers wrote:
>On Fri, Jul 30, 2021 at 3:38 PM Nathan Chancellor <nathan@kernel.org> wrote:
>>
>> A recent change in LLVM causes module_{c,d}tor sections to appear when
>> CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
>> because these are not handled anywhere:
>>
>> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being placed in '.text.asan.module_ctor'
>> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being placed in '.text.asan.module_dtor'
>> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being placed in '.text.tsan.module_ctor'
>
>^ .text.tsan.*

I was wondering why the orphan section warning only arose recently.
Now I see: the function asan.module_ctor has the SHF_GNU_RETAIN flag, so
it is in a separate section even with -fno-function-sections (default).

It seems that with -ffunction-sections the issue should have been caught
much earlier.

>>
>> Place them in the TEXT_TEXT section so that these technologies continue
>> to work with the newer compiler versions. All of the KASAN and KCSAN
>> KUnit tests continue to pass after this change.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://github.com/ClangBuiltLinux/linux/issues/1432
>> Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> ---
>>  include/asm-generic/vmlinux.lds.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> index 17325416e2de..3b79b1e76556 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -586,6 +586,7 @@
>>                 NOINSTR_TEXT                                            \
>>                 *(.text..refcount)                                      \
>>                 *(.ref.text)                                            \
>> +               *(.text.asan .text.asan.*)                              \
>
>Will this match .text.tsan.module_ctor?

asan.module_ctor is the only function AddressSanitizer synthesizes in the instrumented translation unit.
There is no function called "asan".

(Even if a function "asan" exists due to -ffunction-sections
-funique-section-names, TEXT_MAIN will match .text.asan, so the
.text.asan pattern will match nothing.)

>Do we want to add these conditionally on
>CONFIG_KASAN_GENERIC/CONFIG_KCSAN like we do for SANITIZER_DISCARDS?
>
>>                 TEXT_CFI_JT                                             \
>>         MEM_KEEP(init.text*)                                            \
>>         MEM_KEEP(exit.text*)                                            \
>>
>> base-commit: 4669e13cd67f8532be12815ed3d37e775a9bdc16
>> --
>
>
>-- 
>Thanks,
>~Nick Desaulniers
