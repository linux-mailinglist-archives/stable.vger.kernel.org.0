Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89DF3DC202
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 02:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhGaAcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 20:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234448AbhGaAck (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 20:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E0A260FE7;
        Sat, 31 Jul 2021 00:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627691555;
        bh=o+PLNhrJjYzJClkCiD1x2ngH38naHAhxH0uspRMZAk0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Fob9LrC7lLW8/Nupz+JnUcvUWuJy7rdK6mqt5l6vB9mpv9tbhBMqv5bfxWvURlr30
         5lIc/NL9RSkw9Yq4Bw6ak54rXQL1e1dj7ZFX1ltvJZSNqYl8S7GCfOub7XDUQzEspn
         cgsvmB0nKl1fUej7/1Ycak74kHxKaGDHrlRlEIxrpr0BLvvK3B2tIiaVkdiqDfRqSC
         AHyBHuqGs3vBL5G07jo9fgiKBmpFxO3DoolQonsPYsczpYTlS3fakoJnJjzct+qs5S
         WQxiXn+VNJbA9JTOiFyLZd7CSR6jddfaTUukpSu3cXq0Kkp75O+App2GDM3hZ+KY5E
         CUJ9C95gyztiw==
Subject: Re: [PATCH] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
To:     Fangrui Song <maskray@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Marco Elver <elver@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org
References: <20210730223815.1382706-1-nathan@kernel.org>
 <CAKwvOdnJ9VMZfZrZprD6k0oWxVJVSNePUM7fbzFTJygXfO24Pw@mail.gmail.com>
 <20210730225936.ce3hcjdg2sptvbh7@google.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <baf67422-8662-02f2-0bbf-6afb141875af@kernel.org>
Date:   Fri, 30 Jul 2021 17:32:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730225936.ce3hcjdg2sptvbh7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/30/2021 3:59 PM, Fangrui Song wrote:
> On 2021-07-30, Nick Desaulniers wrote:
>> On Fri, Jul 30, 2021 at 3:38 PM Nathan Chancellor <nathan@kernel.org> 
>> wrote:
>>>
>>> A recent change in LLVM causes module_{c,d}tor sections to appear when
>>> CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
>>> because these are not handled anywhere:
>>>
>>> ld.lld: warning: 
>>> arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being 
>>> placed in '.text.asan.module_ctor'
>>> ld.lld: warning: 
>>> arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being 
>>> placed in '.text.asan.module_dtor'
>>> ld.lld: warning: 
>>> arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being 
>>> placed in '.text.tsan.module_ctor'
>>
>> ^ .text.tsan.*
> 
> I was wondering why the orphan section warning only arose recently.
> Now I see: the function asan.module_ctor has the SHF_GNU_RETAIN flag, so
> it is in a separate section even with -fno-function-sections (default).

Thanks for the explanation, I will add this to the commit message.

> It seems that with -ffunction-sections the issue should have been caught
> much earlier.
> 
>>>
>>> Place them in the TEXT_TEXT section so that these technologies continue
>>> to work with the newer compiler versions. All of the KASAN and KCSAN
>>> KUnit tests continue to pass after this change.
>>>
>>> Cc: stable@vger.kernel.org
>>> Link: https://github.com/ClangBuiltLinux/linux/issues/1432
>>> Link: 
>>> https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865 
>>>
>>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>>> ---
>>>  include/asm-generic/vmlinux.lds.h | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/asm-generic/vmlinux.lds.h 
>>> b/include/asm-generic/vmlinux.lds.h
>>> index 17325416e2de..3b79b1e76556 100644
>>> --- a/include/asm-generic/vmlinux.lds.h
>>> +++ b/include/asm-generic/vmlinux.lds.h
>>> @@ -586,6 +586,7 @@
>>>                 
>>> NOINSTR_TEXT                                            \
>>>                 
>>> *(.text..refcount)                                      \
>>>                 
>>> *(.ref.text)                                            \
>>> +               *(.text.asan 
>>> .text.asan.*)                              \
>>
>> Will this match .text.tsan.module_ctor?

No, I forgot to test CONFIG_KCSAN with this version, rather than the 
prior one I had on GitHub so I will send v2 shortly.

> asan.module_ctor is the only function AddressSanitizer synthesizes in 
> the instrumented translation unit.
> There is no function called "asan".
> 
> (Even if a function "asan" exists due to -ffunction-sections
> -funique-section-names, TEXT_MAIN will match .text.asan, so the
> .text.asan pattern will match nothing.)

Sounds good, I will update it to remove the .text.asan and replace it 
with .text.tsan.*

>> Do we want to add these conditionally on
>> CONFIG_KASAN_GENERIC/CONFIG_KCSAN like we do for SANITIZER_DISCARDS?

I do not think there is a point in doing so but I can if others feel 
strongly.

Thank you both for the comments for the comments!

Cheers,
Nathan
