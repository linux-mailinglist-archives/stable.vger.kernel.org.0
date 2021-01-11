Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0855E2F2358
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 01:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405319AbhALAZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:21 -0500
Received: from elvis.franken.de ([193.175.24.41]:44158 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390474AbhAKWoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 17:44:39 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kz5uk-0007xs-00; Mon, 11 Jan 2021 23:43:54 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 015D2C0899; Mon, 11 Jan 2021 23:43:05 +0100 (CET)
Date:   Mon, 11 Jan 2021 23:43:05 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [PATCH v5 mips-next 0/9] MIPS: vmlinux.lds.S sections fixes &
 cleanup
Message-ID: <20210111224305.GA22825@alpha.franken.de>
References: <20210110115245.30762-1-alobakin@pm.me>
 <202101111153.AE5123B6@keescook>
 <20210111205649.18263-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111205649.18263-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 08:57:25PM +0000, Alexander Lobakin wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Mon, 11 Jan 2021 11:53:39 -0800
> 
> > On Sun, Jan 10, 2021 at 11:53:50AM +0000, Alexander Lobakin wrote:
> >> This series hunts the problems discovered after manual enabling of
> >> ARCH_WANT_LD_ORPHAN_WARN. Notably:
> >>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
> >>    placement (marked for stable);
> >>  - stops blind catching of orphan text sections with .text.*
> >>    directive;
> >>  - properly stops .eh_frame section generation.
> >>
> >> Compile and runtime tested on MIPS32R2 CPS board with no issues
> >> using two different toolkits:
> >>  - Binutils 2.35.1, GCC 10.2.1 (with Alpine patches);
> >>  - LLVM stack: 11.0.0 and from latest Git snapshot.
> >>
> >> Since v4 [3]:
> >>  - new: drop redundant .text.cps-vec creation and blind inclusion
> >>    of orphan text sections via .text.* directive in vmlinux.lds.S;
> >>  - don't assert SIZEOF(.rel.dyn) as it's reported that it may be not
> >>    empty on certain machines and compilers (Thomas);
> >>  - align GOT table like it's done for ARM64;
> >>  - new: catch UBSAN's "unnamed data" sections in generic definitions
> >>    when building with LD_DEAD_CODE_DATA_ELIMINATION;
> >>  - collect Reviewed-bys (Kees, Nathan).
> >
> > Looks good; which tree will this land through?
> 
> linux-mips/mips-next I guess, since 7 of 9 patches are related only
> to this architecture.
> This might need Arnd's Acked-bys or Reviewed-by for the two that
> refer include/asm-generic, let's see what Thomas think.

Looks good from my side and I have it already sitting in branch for
submission.

Arnd, are you ok with the changes in include/asm-generic ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
