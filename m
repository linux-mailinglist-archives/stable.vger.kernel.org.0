Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA252F2138
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbhAKU6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 15:58:20 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:54485 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbhAKU6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 15:58:20 -0500
Date:   Mon, 11 Jan 2021 20:57:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610398657; bh=423czqlXYO6cyt2pvAdEvcmUk4C4FxO/GExpCv7aBhM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=dKDO7F+tdwzxF97ZxwMYSL4RZdRIfEJ7fdVw7R+H5Yl3BXfxLuchuMdWlPl0VrA4Q
         ciraikiocq7nnzvIqgDtQra9docDLxlWfsWcj6sKaq54aIm+vLWd2BE39I2KTgOukm
         cWVg03Mo1ReSb4qU0K9BNE0+PLK8cQBw4Fwmjpw6ARjhxZ/nvOOrhguyZ7Q2PAJXKM
         6xp1bPRrf+o7skGbTZpnLBXSMRq+ideRn1t06+wSZtoLfjsCo4emJZ/uizqNCqUs1e
         er8Fsgyp7Fk5VSQifGrHKodyJ9Ah4MohRFqP/cSWJ8P072GPm0npPBigwB7oOqkoKQ
         cHpLCkjWkYyXA==
To:     Kees Cook <keescook@chromium.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v5 mips-next 0/9] MIPS: vmlinux.lds.S sections fixes & cleanup
Message-ID: <20210111205649.18263-1-alobakin@pm.me>
In-Reply-To: <202101111153.AE5123B6@keescook>
References: <20210110115245.30762-1-alobakin@pm.me> <202101111153.AE5123B6@keescook>
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

From: Kees Cook <keescook@chromium.org>
Date: Mon, 11 Jan 2021 11:53:39 -0800

> On Sun, Jan 10, 2021 at 11:53:50AM +0000, Alexander Lobakin wrote:
>> This series hunts the problems discovered after manual enabling of
>> ARCH_WANT_LD_ORPHAN_WARN. Notably:
>>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
>>    placement (marked for stable);
>>  - stops blind catching of orphan text sections with .text.*
>>    directive;
>>  - properly stops .eh_frame section generation.
>>
>> Compile and runtime tested on MIPS32R2 CPS board with no issues
>> using two different toolkits:
>>  - Binutils 2.35.1, GCC 10.2.1 (with Alpine patches);
>>  - LLVM stack: 11.0.0 and from latest Git snapshot.
>>
>> Since v4 [3]:
>>  - new: drop redundant .text.cps-vec creation and blind inclusion
>>    of orphan text sections via .text.* directive in vmlinux.lds.S;
>>  - don't assert SIZEOF(.rel.dyn) as it's reported that it may be not
>>    empty on certain machines and compilers (Thomas);
>>  - align GOT table like it's done for ARM64;
>>  - new: catch UBSAN's "unnamed data" sections in generic definitions
>>    when building with LD_DEAD_CODE_DATA_ELIMINATION;
>>  - collect Reviewed-bys (Kees, Nathan).
>
> Looks good; which tree will this land through?

linux-mips/mips-next I guess, since 7 of 9 patches are related only
to this architecture.
This might need Arnd's Acked-bys or Reviewed-by for the two that
refer include/asm-generic, let's see what Thomas think.

> -Kees
>
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
>> [3] https://lore.kernel.org/linux-mips/20210107123331.354075-1-alobakin@=
pm.me
>>
>> Alexander Lobakin (9):
>>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>>   MIPS: CPS: don't create redundant .text.cps-vec section
>>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>>   MIPS: properly stop .eh_frame generation
>>   MIPS: vmlinux.lds.S: explicitly catch .rel.dyn symbols
>>   MIPS: vmlinux.lds.S: explicitly declare .got table
>>   vmlinux.lds.h: catch compound literals into data and BSS
>>   vmlinux.lds.h: catch UBSAN's "unnamed data" into data
>>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN
>>
>>  arch/mips/Kconfig                 |  1 +
>>  arch/mips/include/asm/asm.h       | 18 ++++++++++++++++++
>>  arch/mips/kernel/cps-vec.S        |  1 -
>>  arch/mips/kernel/vmlinux.lds.S    | 11 +++++++++--
>>  include/asm-generic/vmlinux.lds.h |  6 +++---
>>  5 files changed, 31 insertions(+), 6 deletions(-)
>>
>> --
>> 2.30.0
>>
>>
>
> --
> Kees Cook

Al

