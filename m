Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29482EFF60
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 13:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbhAIM2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 07:28:33 -0500
Received: from elvis.franken.de ([193.175.24.41]:38220 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbhAIM2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 07:28:33 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kyDLP-0005En-00; Sat, 09 Jan 2021 13:27:47 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 492FAC0880; Sat,  9 Jan 2021 12:12:59 +0100 (CET)
Date:   Sat, 9 Jan 2021 12:12:59 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
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
Subject: Re: [PATCH v4 mips-next 0/7] MIPS: vmlinux.lds.S sections fixes &
 cleanup
Message-ID: <20210109111259.GA4213@alpha.franken.de>
References: <20210107123331.354075-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107123331.354075-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 12:33:38PM +0000, Alexander Lobakin wrote:
> This series hunts the problems discovered after manual enabling of
> ARCH_WANT_LD_ORPHAN_WARN. Notably:
>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
>    placement (marked for stable);
>  - properly stops .eh_frame section generation.
> 
> Compile and runtime tested on MIPS32R2 CPS board with no issues
> using two different toolkits:
>  - Binutils 2.35.1, GCC 10.2.0;
>  - LLVM stack 11.0.0.
> 
> Since v3 [2]:
>  - fix the third patch as GNU stack emits .rel.dyn into VDSO for
>    some reason if .cfi_sections is specified.
> 
> Since v2 [1]:
>  - stop discarding .eh_frame and just prevent it from generating
>    (Kees);
>  - drop redundant sections assertions (Fangrui);
>  - place GOT table in .text instead of asserting as it's not empty
>    when building with LLVM (Nathan);
>  - catch compound literals in generic definitions when building with
>    LD_DEAD_CODE_DATA_ELIMINATION (Kees);
>  - collect two Reviewed-bys (Kees).
> 
> Since v1 [0]:
>  - catch .got entries too as LLD may produce it (Nathan);
>  - check for unwanted sections to be zero-sized instead of
>    discarding (Fangrui).
> 
> [0] https://lore.kernel.org/linux-mips/20210104121729.46981-1-alobakin@pm.me
> [1] https://lore.kernel.org/linux-mips/20210106200713.31840-1-alobakin@pm.me
> [2] https://lore.kernel.org/linux-mips/20210107115120.281008-1-alobakin@pm.me
> 
> Alexander Lobakin (7):
>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>   MIPS: properly stop .eh_frame generation
>   MIPS: vmlinux.lds.S: catch bad .rel.dyn at link time
>   MIPS: vmlinux.lds.S: explicitly declare .got table
>   vmlinux.lds.h: catch compound literals into data and BSS
>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN

this breaks my builds:

  LD      vmlinux.o
  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.kallsyms1
mips64-linux-gnu-ld: Unexpected run-time relocations (.rel) detected!


$ mips64-linux-gnu-ld --version
GNU ld version 2.27-3.fc24

$ mips64-linux-gnu-gcc --version
mips64-linux-gnu-gcc (GCC) 6.1.1 20160621 (Red Hat Cross 6.1.1-2)

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
