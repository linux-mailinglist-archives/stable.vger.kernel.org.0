Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA5A2F7E8C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 15:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbhAOOry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 09:47:54 -0500
Received: from elvis.franken.de ([193.175.24.41]:53938 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732175AbhAOOry (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 09:47:54 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1l0QNY-0006aU-02; Fri, 15 Jan 2021 15:47:08 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id CCB8EC057E; Fri, 15 Jan 2021 15:40:37 +0100 (CET)
Date:   Fri, 15 Jan 2021 15:40:37 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Kees Cook <keescook@chromium.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v5 mips-next 0/9] MIPS: vmlinux.lds.S sections fixes &
 cleanup
Message-ID: <20210115144037.GC15166@alpha.franken.de>
References: <20210110115245.30762-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110115245.30762-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 11:53:50AM +0000, Alexander Lobakin wrote:
> This series hunts the problems discovered after manual enabling of
> ARCH_WANT_LD_ORPHAN_WARN. Notably:
>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
>    placement (marked for stable);
>  - stops blind catching of orphan text sections with .text.*
>    directive;
>  - properly stops .eh_frame section generation.
> 
> Compile and runtime tested on MIPS32R2 CPS board with no issues
> using two different toolkits:
>  - Binutils 2.35.1, GCC 10.2.1 (with Alpine patches);
>  - LLVM stack: 11.0.0 and from latest Git snapshot.
> 
> Since v4 [3]:
>  - new: drop redundant .text.cps-vec creation and blind inclusion
>    of orphan text sections via .text.* directive in vmlinux.lds.S;
>  - don't assert SIZEOF(.rel.dyn) as it's reported that it may be not
>    empty on certain machines and compilers (Thomas);
>  - align GOT table like it's done for ARM64;
>  - new: catch UBSAN's "unnamed data" sections in generic definitions
>    when building with LD_DEAD_CODE_DATA_ELIMINATION;
>  - collect Reviewed-bys (Kees, Nathan).
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
> [3] https://lore.kernel.org/linux-mips/20210107123331.354075-1-alobakin@pm.me
> 
> Alexander Lobakin (9):
>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>   MIPS: CPS: don't create redundant .text.cps-vec section
>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>   MIPS: properly stop .eh_frame generation
>   MIPS: vmlinux.lds.S: explicitly catch .rel.dyn symbols
>   MIPS: vmlinux.lds.S: explicitly declare .got table
>   vmlinux.lds.h: catch compound literals into data and BSS
>   vmlinux.lds.h: catch UBSAN's "unnamed data" into data
>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN
> 
>  arch/mips/Kconfig                 |  1 +
>  arch/mips/include/asm/asm.h       | 18 ++++++++++++++++++
>  arch/mips/kernel/cps-vec.S        |  1 -
>  arch/mips/kernel/vmlinux.lds.S    | 11 +++++++++--
>  include/asm-generic/vmlinux.lds.h |  6 +++---
>  5 files changed, 31 insertions(+), 6 deletions(-)

applied to mips-next.

Thoomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
