Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CD22F022B
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbhAIRXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 12:23:30 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:44599 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIRX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 12:23:29 -0500
Date:   Sat, 09 Jan 2021 17:22:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610212965; bh=lopjhVQdd7RoqSJIPbFqTTvc23zHkmg9CyWUgEh5sKA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Ri9U/Od4YzXlGOUK9ElK3xgypcRqggj+x1IlTwfndxT4i6t/zNX6uYCGF3hLZ60Qt
         s/10mn9DN1W47l3PQM6dE4GbXdn6Wb/tK76qD7kFojUFXwNedZU5sZQ1W91do4HS+q
         ROsNrcPcXlnfAqcrXeqDOpJpmHUKvc1V/WxHlm77MGG2e53MPBTAxRlttmmt2uwTA4
         +FiDGuvgG6ceKOdiy2Sz9QeQ9n69ly+y+MN2S4KmUxnKl+rpa+XzJOWQzm34XDZCOy
         LcrRcjQjnyOWKA/31JwyV55dqUS1YGppDwjXj/WYfHH0l7xFdrAALzy5Rdy7hKzQWG
         SrFbmsX4FgPMA==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 mips-next 0/7] MIPS: vmlinux.lds.S sections fixes & cleanup
Message-ID: <20210109172204.498737-1-alobakin@pm.me>
In-Reply-To: <20210109111259.GA4213@alpha.franken.de>
References: <20210107123331.354075-1-alobakin@pm.me> <20210109111259.GA4213@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Sat, 9 Jan 2021 12:12:59 +0100

> On Thu, Jan 07, 2021 at 12:33:38PM +0000, Alexander Lobakin wrote:
>> This series hunts the problems discovered after manual enabling of
>> ARCH_WANT_LD_ORPHAN_WARN. Notably:
>>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
>>    placement (marked for stable);
>>  - properly stops .eh_frame section generation.
>>
>> Compile and runtime tested on MIPS32R2 CPS board with no issues
>> using two different toolkits:
>>  - Binutils 2.35.1, GCC 10.2.0;
>>  - LLVM stack 11.0.0.
>>
>> Since v3 [2]:
>>  - fix the third patch as GNU stack emits .rel.dyn into VDSO for
>>    some reason if .cfi_sections is specified.
>>
>> Since v2 [1]:
>>  - stop discarding .eh_frame and just prevent it from generating
>>    (Kees);
>>  - drop redundant sections assertions (Fangrui);
>>  - place GOT table in .text instead of asserting as it's not empty
>>    when building with LLVM (Nathan);
>>  - catch compound literals in generic definitions when building with
>>    LD_DEAD_CODE_DATA_ELIMINATION (Kees);
>>  - collect two Reviewed-bys (Kees).
>>
>> Since v1 [0]:
>>  - catch .got entries too as LLD may produce it (Nathan);
>>  - check for unwanted sections to be zero-sized instead of
>>    discarding (Fangrui).
>>
>> [0] https://lore.kernel.org/linux-mips/20210104121729.46981-1-alobakin@p=
m.me
>> [1] https://lore.kernel.org/linux-mips/20210106200713.31840-1-alobakin@p=
m.me
>> [2] https://lore.kernel.org/linux-mips/20210107115120.281008-1-alobakin@=
pm.me
>>
>> Alexander Lobakin (7):
>>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>>   MIPS: properly stop .eh_frame generation
>>   MIPS: vmlinux.lds.S: catch bad .rel.dyn at link time
>>   MIPS: vmlinux.lds.S: explicitly declare .got table
>>   vmlinux.lds.h: catch compound literals into data and BSS
>>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN
>
> this breaks my builds:
>
>   LD      vmlinux.o
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.kallsyms1
> mips64-linux-gnu-ld: Unexpected run-time relocations (.rel) detected!

I think they should be handled as it's done for ARM64 [0]. Will do v5
soon.

[0] https://elixir.bootlin.com/linux/v5.11-rc2/source/arch/arm64/kernel/vml=
inux.lds.S#L219

> $ mips64-linux-gnu-ld --version
> GNU ld version 2.27-3.fc24
>
> $ mips64-linux-gnu-gcc --version
> mips64-linux-gnu-gcc (GCC) 6.1.1 20160621 (Red Hat Cross 6.1.1-2)
>
> Thomas.

Thanks,
Alex

> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessaril=
y a
> good idea.                                                [ RFC1925, 2.3 =
]

